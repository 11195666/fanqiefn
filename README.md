# 番茄净化 - 番茄小说通知/小组件权限伪装

iOS 越狱插件，为番茄小说（com.dragon.read）伪装通知权限和小组件权限，去除添加小组件的弹窗提醒和开启通知提醒。

## 功能

- **通知权限伪装** — 拦截 iOS 通知授权请求，始终返回已授权，避免弹出系统通知权限对话框
- **通知设置伪装** — 将所有通知设置（提示、声音、角标、预览）伪装为已启用状态
- **远程推送伪装** — 返回已注册远程推送状态，拦截注册调用避免触发弹窗
- **小组件伪装** — 拦截 `NSUserDefaults` 中小组件相关 key 的读取，返回已添加状态
- **弹窗拦截** — 拦截包含小组件关键词的 `UIAlertController` 弹窗，彻底去除提醒

## 安装

### 系统要求

- iOS 15.0+
- 越狱环境（rootless 方案，如 Dopamine、palera1n 等）
- 番茄小说已安装

### 方式一：下载预编译包

从 [Releases](https://github.com/11195666/fanqiefn/releases) 页面下载 `.deb` 文件，使用包管理器（Sileo / Zebra）安装，或通过命令行：

```bash
dpkg -i fanqiefn_*.deb
```

### 方式二：从源码编译

需要安装 [Theos](https://theos.dev/) 开发环境。

```bash
git clone https://github.com/你的用户名/fanqiefn.git
cd fanqiefn
make package FINALPACKAGE=1
```

## 技术原理

基于 [MobileSubstrate](https://github.com/DHowett/theos) (Cydia Substrate) 实现，Hook 以下系统 API：

| Hook 目标 | 作用 |
|-----------|------|
| `UNUserNotificationCenter` | 拦截通知授权请求，始终回调 `granted=YES` |
| `UNNotificationSettings` | 伪造所有通知设置为已启用 |
| `UIApplication` | 拦截远程推送注册、返回已注册状态 |
| `NSUserDefaults` | 拦截小组件相关 key，返回已添加状态 |
| `UIAlertController` | 拦截小组件相关弹窗标题和内容 |

## 项目结构

```
├── Makefile         # Theos 编译配置
├── control          # 包信息
├── fanqiefn.plist   # MobileSubstrate 过滤配置（仅注入番茄小说）
├── Tweak.xm         # 核心 Hook 逻辑（Logos 语法）
└── README.md
```

## 免责声明

本项目仅供学习和研究使用，请勿用于任何违反法律法规或番茄小说用户协议的用途。使用本插件所产生的任何后果由使用者自行承担。

## 许可证

本项目采用 [MIT License](LICENSE) 开源。
