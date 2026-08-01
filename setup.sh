#!/bin/zsh
# ─── MBP4_Terminal_Setup ────────────────────────────────────────────
# Zsh + Starship (Catppuccin Mocha) + 语法高亮，仅 macOS / Homebrew
# 幂等：反复运行不会重复安装，已装的会跳过
set -e

BOLD="\033[1m"
GREEN="\033[32m"
YELLOW="\033[33m"
NC="\033[0m"

info()    { echo -e "  $1"; }
success() { echo -e "  ${GREEN}✓${NC} $1"; }
warn()    { echo -e "  ${YELLOW}!${NC} $1"; }

SCRIPT_DIR="$(cd "$(dirname "${(%):-%N}")" && pwd)"
CONFIGS_DIR="$SCRIPT_DIR/configs"

if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "本脚本目前只支持 macOS。"
    exit 1
fi

echo -e "${BOLD}══════════════════════════════════════════${NC}"
echo -e "${BOLD}  🍎 MBP4_Terminal_Setup${NC}"
echo -e "${BOLD}══════════════════════════════════════════${NC}"

# ─── Step 1: Homebrew ────────────────────────────────────────────────
echo ""
echo -e "${BOLD}[1/5] Homebrew${NC}"
if ! command -v brew &>/dev/null; then
    info "未检测到 Homebrew，正在安装..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [[ -d /opt/homebrew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    success "Homebrew 安装完成"
else
    success "Homebrew 已安装"
fi

# ─── Step 2: Starship ────────────────────────────────────────────────
echo ""
echo -e "${BOLD}[2/5] Starship 提示符${NC}"
if brew list starship &>/dev/null; then
    success "starship 已安装"
else
    info "安装 starship..."
    brew install starship
    success "starship 安装完成"
fi

# ─── Step 3: Zsh 插件 ────────────────────────────────────────────────
echo ""
echo -e "${BOLD}[3/5] Zsh 插件（自动建议 / 语法高亮 / 补全）${NC}"
for plugin in zsh-autosuggestions zsh-syntax-highlighting zsh-completions; do
    if brew list "$plugin" &>/dev/null; then
        success "$plugin 已安装"
    else
        info "安装 $plugin..."
        brew install "$plugin"
        success "$plugin 安装完成"
    fi
done

# ─── Step 4: 字体 ────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}[4/5] MesloLGS NF 字体${NC}"
if brew list --cask font-meslo-lg-nerd-font &>/dev/null; then
    success "字体已安装"
else
    info "安装字体..."
    brew install --cask font-meslo-lg-nerd-font
    success "字体安装完成"
fi
warn "记得在 Otty 设置里把字体切换为 MesloLGS NF"

# ─── Step 5: 部署配置文件 ─────────────────────────────────────────────
echo ""
echo -e "${BOLD}[5/5] 部署配置文件${NC}"
mkdir -p ~/.config

if [[ -f ~/.zshrc ]] && ! diff -q "$CONFIGS_DIR/.zshrc" ~/.zshrc &>/dev/null; then
    cp ~/.zshrc ~/.zshrc.bak.$(date +%s)
    warn "已备份原 .zshrc"
fi
cp "$CONFIGS_DIR/.zshrc" ~/.zshrc
success ".zshrc 已部署"

if [[ -f ~/.config/starship.toml ]] && ! diff -q "$CONFIGS_DIR/starship.toml" ~/.config/starship.toml &>/dev/null; then
    cp ~/.config/starship.toml ~/.config/starship.toml.bak.$(date +%s)
    warn "已备份原 starship.toml"
fi
cp "$CONFIGS_DIR/starship.toml" ~/.config/starship.toml
success "starship.toml 已部署"

if [[ "$SHELL" != "$(which zsh)" ]]; then
    info "切换默认 Shell 为 zsh..."
    chsh -s "$(which zsh)"
    success "默认 Shell 已切换（下次登录生效）"
else
    success "zsh 已是默认 Shell"
fi

echo ""
echo -e "${BOLD}✅ 完成！${NC} 打开新的终端窗口 / Tab 即可生效。"
