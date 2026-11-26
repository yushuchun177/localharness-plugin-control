# 操作电脑 / Computer control

移动鼠标、点击、输入文字、按键、列出并切换窗口。危险：会给模型操作桌面的能力。

Move the mouse, click, type text, press keys, list and focus windows. Dangerous: gives the model control over your desktop.

Local-Harness（Godot 版）的独立插件。**不随主程序发布**，由主程序「设置 → 插件管理」从 GitHub 下载并自动部署到 `user://plugins/control/`。

## 工具

- `pc_move` —— 把鼠标移动到屏幕坐标 (x, y)。
  - `x`: int
  - `y`: int
- `pc_click` —— 在坐标 (x, y) 点击，button 可选 left/right/double。
  - `x`: int
  - `y`: int
  - `button`: string，可选
- `pc_type` —— 把一段文字输入到当前焦点窗口。
  - `text`: string
- `pc_key` —— 按一个组合键，用 SendKeys 语法，例如 ^c 复制、{ENTER}、%{TAB}。
  - `keys`: string
- `pc_windows` —— 列出当前有标题的窗口（标题 + 进程名 + 是否前台）。
- `pc_focus` —— 按标题关键字把某个窗口切到前台。
  - `title`: string，标题关键字

## 安装

1. Local-Harness → 设置 → 插件管理 → 刷新列表
2. 找到「操作电脑」点安装
3. 装完直接在对话里让模型调用（插件会出现在系统提示的工具清单里）

手动安装：把仓库解压到 `%LOCALAPPDATA%\Godot\app_userdata\Local-Harness\plugins\control\`。

## 结构

```
manifest.json   清单：id / 版本 / 工具定义
main.gd         extends Node，实现 run(tool, args) -> {ok, output}
```

## 许可

GPL-3.0（与主程序一致）。
