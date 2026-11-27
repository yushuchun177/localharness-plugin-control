extends VBoxContainer
## 本插件的设置界面 —— 由插件自己提供，主程序只负责挂载。
## 想改这个插件在这里长什么样、有哪些开关，改这个文件即可。

func build(plugin_id: String) -> void:
	add_theme_constant_override("separation", 10)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_child(PluginUI.title("操作电脑"))
	add_child(PluginUI.hint("装上它，模型就能替你动鼠标键盘。下面每一项都是单独开关，只开你需要的。"))
	add_child(PluginUI.section("行为"))
	add_child(PluginUI.int_field(plugin_id, "delay_ms", "每步操作前等待（毫秒）", 120,
		"给界面一点反应时间，太小容易点空"))
	add_child(PluginUI.section("能力开关"))
	add_child(PluginUI.hint("每一项都能单独关掉；关掉后模型看不到这个能力，也调用不了。"))
	for t in Plugins.tools_of(plugin_id):
		var tname := str(t.get("name", ""))
		var human := tname
		var desc := str(t.get("description", ""))
		if tname == "pc_move":
			human = "移动鼠标"
			desc = "把光标挪到指定坐标，不点击"
		if tname == "pc_click":
			human = "点击鼠标"
			desc = "左键/右键/双击，会在你屏幕上真的点下去"
		if tname == "pc_type":
			human = "输入文字"
			desc = "像打字一样把内容送进当前窗口"
		if tname == "pc_key":
			human = "按快捷键"
			desc = "例如 Ctrl+C、Enter、Alt+Tab"
		if tname == "pc_windows":
			human = "读取窗口列表"
			desc = "只读：列出当前打开了哪些窗口"
		if tname == "pc_focus":
			human = "切换窗口"
			desc = "把某个窗口切到最前面"
		add_child(PluginUI.perm_row(tname, human, desc, bool(t.get("dangerous", false))))
	add_child(PluginUI.readme_box(plugin_id))
