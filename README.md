# 操作电脑 / Computer control

移动鼠标、点击、输入文字、按键、列出并切换窗口。危险：会给模型操作桌面的能力。

Move the mouse, click, type text, press keys, list and focus windows. Dangerous: gives the model control over your desktop.

> Local-Harness（Godot 版）的独立插件。不随主程序发布，由主程序
> 「设置 → 插件管理」从 GitHub 下载并自动部署到 `user://plugins/control/`。

## 安装

1. 打开 Local-Harness → 设置 → 插件管理 → 刷新列表
2. 找到「操作电脑」点「安装」
3. 装好后在侧栏底部点同名按钮，里面是这个插件自己的设置页

手动安装：把本仓库下载解压到 `%LOCALAPPDATA%\Godot\app_userdata\Local-Harness\plugins\control\`

## 工具

- `pc_move` —— 把鼠标移动到屏幕坐标 (x, y)。（会产生操作）
  - `x`: int
  - `y`: int
- `pc_click` —— 在坐标 (x, y) 点击，button 可选 left/right/double。（高危）
  - `x`: int
  - `y`: int
  - `button`: string，可选
- `pc_type` —— 把一段文字输入到当前焦点窗口。（高危）
  - `text`: string
- `pc_key` —— 按一个组合键，用 SendKeys 语法，例如 ^c 复制、{ENTER}、%{TAB}。（高危）
  - `keys`: string
- `pc_windows` —— 列出当前有标题的窗口（标题 + 进程名 + 是否前台）。（只读）
- `pc_focus` —— 按标题关键字把某个窗口切到前台。（高危）
  - `title`: string，标题关键字

## 命令

（没有命令）

## 设置项

- **每步操作前等待（毫秒）**（`delay_ms`，默认 `120`）给界面一点反应时间，太小容易点空

## 权限

每个工具都能在插件设置页里单独开关。关掉之后它不会出现在模型的工具清单里，
就算模型硬要调用也会被主程序拒绝。协议里用 `level` 标了风险等级：

- `read` 只读：不会改动任何东西
- `act` 会产生操作：会读写文件、联网或占用设备
- `danger` 高危：会操作你的系统

## 怎么用

装好后直接在对话里提需求，例如：“把鼠标移动到屏幕坐标 (x, y)。”

模型会输出一行 ```tool 协议块，宿主解析后执行，再把结果喂回模型。
也可以直接用斜杠命令，不经过模型。

## 许可

GPL-3.0（与主程序一致）。完整协议文本见仓库根目录的 [LICENSE](LICENSE)。

---

# Computer control

Move the mouse, click, type text, press keys, list and focus windows. Dangerous: gives the model control over your desktop.

> An independent plugin for **Local-Harness (Godot edition)**. It is not bundled with the
> app; the app downloads it from this repository into `user://plugins/control/` and hot-loads it.

## Install

1. Local-Harness → Settings → Plugins → Refresh
2. Find "Computer control" and click Install
3. Open it from the button at the bottom of the sidebar for its own settings page

Manual: unzip this repo into `%LOCALAPPDATA%\Godot\app_userdata\Local-Harness\plugins\control\`

## Tools

- `pc_move` — 把鼠标移动到屏幕坐标 (x, y)。 (has side effects)
  - `x`: int
  - `y`: int
- `pc_click` — 在坐标 (x, y) 点击，button 可选 left/right/double。 (dangerous)
  - `x`: int
  - `y`: int
  - `button`: string，可选
- `pc_type` — 把一段文字输入到当前焦点窗口。 (dangerous)
  - `text`: string
- `pc_key` — 按一个组合键，用 SendKeys 语法，例如 ^c 复制、{ENTER}、%{TAB}。 (dangerous)
  - `keys`: string
- `pc_windows` — 列出当前有标题的窗口（标题 + 进程名 + 是否前台）。 (read-only)
- `pc_focus` — 按标题关键字把某个窗口切到前台。 (dangerous)
  - `title`: string，标题关键字

## Commands

(no commands)

## Settings

- **每步操作前等待（毫秒）** (`delay_ms`, default `120`) 给界面一点反应时间，太小容易点空

## Permissions

Every tool can be toggled individually on the plugin settings page. A disabled tool is
removed from the model's tool list and rejected by the host even if the model still calls it.
`level` in the manifest marks the risk:

- `read` — no side effects
- `act` — reads/writes, network or devices
- `danger` — controls your system

## Usage

Just ask in the chat, e.g. “把鼠标移动到屏幕坐标 (x, y)。”

The model emits a ```tool block, the host executes it and feeds the result back.
You can also use the slash commands above, which skip the model entirely.

## License

GPL-3.0 (same as the host app). Full text: [LICENSE](LICENSE).
