extends VBoxContainer
## 操作电脑 —— 这个页面是插件自己提供的界面。
## 界面全部由插件自己拼，主程序只提供积木。

func build(plugin_id: String) -> void:
	add_theme_constant_override("separation", 12)
	size_flags_horizontal = Control.SIZE_EXPAND_FILL

	add_child(PluginUI.section("操作节奏"))
	add_child(PluginUI.slider_row(plugin_id, "delay_ms", "每步之间等多久", 0, 1000, 20, "毫秒", 120,
		"界面反应慢的电脑调大一点，防止点空"))
	add_child(PluginUI.big_toggle(plugin_id, "safe_mode", "安全模式（只读）",
		"打开后只允许“看窗口列表”，不允许动鼠标键盘", false))

	add_child(PluginUI.section("试一下"))
	add_child(PluginUI.action_row("列出当前窗口", "只读，不会动你的鼠标", "看看",
		func(): return Plugins.invoke("pc_windows", {})))
	add_child(PluginUI.overview(plugin_id))
	add_child(PluginUI.permissions_section(plugin_id))
	add_child(PluginUI.doc_section(plugin_id))
