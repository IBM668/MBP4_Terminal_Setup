# 🍎 MBP4_Terminal_Setup

个人 MacBook Pro (M4) 终端环境配置，一条命令搞定新机器上的 Shell 环境。

只做一件事：**Zsh + Starship + 语法高亮**，不含 Ghostty / Fish / 额外 CLI 工具集，全部通过 Homebrew 安装，干净、可重复运行。终端用的是 [Otty](https://otty.app)，但配置文件跟终端无关，换终端也能直接用。

## 工具栈

| 组件 | 说明 |
|------|------|
| **Zsh** | macOS 自带，不需要额外安装 shell 本体 |
| **[Starship](https://starship.rs)** | 跨 Shell 提示符，配色用的 [Catppuccin Mocha](https://catppuccin.com/) |
| **zsh-autosuggestions** | 输入时灰色显示历史命令建议 |
| **zsh-syntax-highlighting** | 命令语法高亮 |
| **zsh-completions** | 补全增强 |
| **MesloLGS NF** | Nerd Font，Starship 图标需要它 |

## 快速开始

```bash
git clone https://github.com/IBM668/MBP4_Terminal_Setup.git
cd MBP4_Terminal_Setup
./setup.sh
```

脚本会自动：Homebrew → Starship → 三个 zsh 插件 → MesloLGS NF 字体 → 部署 `.zshrc` / `starship.toml`（已有文件自动备份成 `.bak.<时间戳>`）→ 切换默认 shell 为 zsh。

装完后在 Otty 设置里把字体切成 **MesloLGS NF**，重开一个窗口即可生效。脚本幂等，可以重复运行。

## 更新配置

```bash
cd MBP4_Terminal_Setup
git pull
./setup.sh
```

反向同步（本机改了配置想存回仓库）：

```bash
cp ~/.zshrc configs/.zshrc
cp ~/.config/starship.toml configs/starship.toml
git add -A && git commit -m "update config"
git push
```

## 目录结构
MBP4_Terminal_Setup/

├── README.md

├── setup.sh

└── configs/

├── .zshrc

└── starship.toml


## License

MIT
