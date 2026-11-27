extends Node
## 操作电脑插件 · local-harness
## 工具：pc_move / pc_click / pc_type / pc_key / pc_windows / pc_focus
##
## 全部通过 PowerShell 调 .NET 的 WinForms API，不需要额外依赖。
## 注意：这些工具会真的动你的鼠标键盘，属于高危能力，默认清单里标了 dangerous。

const PS_HEAD := "Add-Type -AssemblyName System.Windows.Forms;"


func _pref(key: String, def_value):
	var ml := Engine.get_main_loop()
	var prefs = ml.root.get_node_or_null("/root/PluginPrefs") if ml != null else null
	return prefs.get_value("control", key, def_value) if prefs != null else def_value


func _wait() -> void:
	OS.delay_msec(int(_pref("delay_ms", 120)))


func run(tool: String, args: Dictionary) -> Dictionary:
	match tool:
		"pc_move":
			return _move(args)
		"pc_click":
			return _click(args)
		"pc_type":
			return _type(args)
		"pc_key":
			return _key(args)
		"pc_windows":
			return _windows()
		"pc_focus":
			return _focus(args)
	return {"ok": false, "output": "未知工具：%s" % tool}


func _ps(script: String) -> Array:
	var out: Array = []
	var code := OS.execute("powershell.exe",
		PackedStringArray(["-NoProfile", "-NonInteractive", "-ExecutionPolicy", "Bypass", "-Command", PS_HEAD + script]),
		out, true)
	if code != 0:
		var msg := "PowerShell 失败（%d）" % code
		if out.size() > 0:
			msg += "：" + str(out[0]).strip_edges().substr(0, 300)
		out.insert(0, msg)
		out.insert(0, "__ERR__")
	return out


func _ok(script: String, ok_text: String) -> Dictionary:
	var r := _ps(script)
	if r.size() > 0 and str(r[0]) == "__ERR__":
		return {"ok": false, "output": str(r[1])}
	return {"ok": true, "output": ok_text}


func _move(args: Dictionary) -> Dictionary:
	var x := int(args.get("x", 0))
	var y := int(args.get("y", 0))
	return _ok("[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point(%d,%d);'ok'" % [x, y],
		"鼠标移动到 (%d, %d)" % [x, y])


func _click(args: Dictionary) -> Dictionary:
	var x := int(args.get("x", 0))
	var y := int(args.get("y", 0))
	var btn := str(args.get("button", "left"))
	_wait()
	var script := (
		"Add-Type -Namespace W -Name U -MemberDefinition '[DllImport(\"user32.dll\")] public static extern void mouse_event(uint f,uint dx,uint dy,uint d,uint e);';" +
		"[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point(%d,%d);Start-Sleep -Milliseconds 60;" % [x, y]
	)
	if btn == "right":
		script += "[W.U]::mouse_event(0x0008,0,0,0,0);Start-Sleep -Milliseconds 40;[W.U]::mouse_event(0x0010,0,0,0,0);'ok'"
	elif btn == "double":
		script += "1..2 | ForEach-Object { [W.U]::mouse_event(0x0002,0,0,0,0);[W.U]::mouse_event(0x0004,0,0,0,0);Start-Sleep -Milliseconds 80 };'ok'"
	else:
		script += "[W.U]::mouse_event(0x0002,0,0,0,0);Start-Sleep -Milliseconds 40;[W.U]::mouse_event(0x0004,0,0,0,0);'ok'"
	return _ok(script, "在 (%d, %d) 做了 %s 点击" % [x, y, btn])


func _type(args: Dictionary) -> Dictionary:
	var text := str(args.get("text", ""))
	if text == "":
		return {"ok": false, "output": "text 不能为空"}
	# SendKeys 里这些字符有特殊含义，逐个转义
	var esc := text
	for ch in ["+", "^", "%", "~", "(", ")", "[", "]", "{", "}"]:
		esc = esc.replace(ch, "{" + ch + "}")
	esc = esc.replace("\n", "{ENTER}")
	var r := _ps("[System.Windows.Forms.SendKeys]::SendWait('" + esc.replace("'", "''") + "');'ok'")
	if r.size() > 0 and str(r[0]) == "__ERR__":
		return {"ok": false, "output": str(r[1])}
	return {"ok": true, "output": "已输入 %d 个字符" % text.length()}


func _key(args: Dictionary) -> Dictionary:
	var keys := str(args.get("keys", ""))
	if keys == "":
		return {"ok": false, "output": "keys 不能为空"}
	var r := _ps("[System.Windows.Forms.SendKeys]::SendWait('" + keys.replace("'", "''") + "');'ok'")
	if r.size() > 0 and str(r[0]) == "__ERR__":
		return {"ok": false, "output": str(r[1])}
	return {"ok": true, "output": "已发送按键 " + keys}


func _windows() -> Dictionary:
	var out: Array = []
	var code := OS.execute("powershell.exe", PackedStringArray([
		"-NoProfile", "-NonInteractive", "-Command",
		"Get-Process | Where-Object { $_.MainWindowTitle -ne '' } | ForEach-Object { '{0}|{1}' -f $_.MainWindowTitle, $_.ProcessName }"
	]), out, true)
	if code != 0 or out.size() == 0:
		return {"ok": false, "output": "读取窗口列表失败"}
	var lines: PackedStringArray = []
	for line in str(out[0]).split("\n"):
		var t := line.strip_edges()
		if t != "":
			lines.append("- " + t.replace("|", "  （进程 "))
			if not t.ends_with("）"):
				lines[lines.size() - 1] = lines[lines.size() - 1] + "）"
	return {"ok": true, "output": "窗口列表：\n" + "\n".join(lines).replace("（进程 ", "（进程 ")}


func _focus(args: Dictionary) -> Dictionary:
	var title := str(args.get("title", "")).strip_edges()
	if title == "":
		return {"ok": false, "output": "title 不能为空"}
	_wait()
	var script := (
		"Add-Type -Namespace W -Name U -MemberDefinition '[DllImport(\"user32.dll\")] public static extern bool SetForegroundWindow(IntPtr h);[DllImport(\"user32.dll\")] public static extern bool ShowWindow(IntPtr h,int c);';" +
		"$p = Get-Process | Where-Object { $_.MainWindowTitle -like '*" + title.replace("'", "''") + "*' } | Select-Object -First 1;" +
		"if ($p) { [W.U]::ShowWindow($p.MainWindowHandle,9) | Out-Null; [W.U]::SetForegroundWindow($p.MainWindowHandle) | Out-Null; 'ok' } else { 'none' }"
	)
	var r := _ps(script)
	if r.size() > 0 and str(r[0]) == "__ERR__":
		return {"ok": false, "output": str(r[1])}
	var body := str(r[0]).strip_edges() if r.size() > 0 else ""
	if body == "none":
		return {"ok": false, "output": "没找到标题包含「%s」的窗口" % title}
	return {"ok": true, "output": "已切到窗口：" + title}
