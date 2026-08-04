#!/bin/zsh
# ─── 从 backups/ 里选一个存档一键恢复 ────────────────────────────────
set -e

GREEN="\033[32m"; YELLOW="\033[33m"; RED="\033[31m"; NC="\033[0m"
success() { echo -e "  ${GREEN}✓${NC} $1"; }
warn()    { echo -e "  ${YELLOW}!${NC} $1"; }
error()   { echo -e "  ${RED}✗${NC} $1"; exit 1; }

SCRIPT_DIR="$(cd "$(dirname "${(%):-%N}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
BACKUPS_DIR="$REPO_DIR/backups"

# 列出所有备份文件夹，按时间倒序（最新的在最上面）
BACKUP_LIST=($(ls -1 "$BACKUPS_DIR" 2>/dev/null | grep -v '^.gitkeep$' | sort -r))

if [[ ${#BACKUP_LIST[@]} -eq 0 ]]; then
    error "backups/ 里没有任何备份，先跑 ./scripts/backup.sh <说明> 存一个"
fi

echo "可用备份："
local i=1
for name in "${BACKUP_LIST[@]}"; do
    echo "  [$i] $name"
    i=$((i + 1))
done

echo ""
read "CHOICE?输入编号选择要恢复的备份: "

if [[ ! "$CHOICE" =~ ^[0-9]+$ ]] || (( CHOICE < 1 || CHOICE > ${#BACKUP_LIST[@]} )); then
    error "无效编号"
fi

CHOSEN="${BACKUP_LIST[$CHOICE]}"
CHOSEN_DIR="$BACKUPS_DIR/$CHOSEN"

echo ""
echo "即将用 backups/$CHOSEN 恢复 ~/.zshrc 和 ~/.config/starship.toml"
read "CONFIRM?确认吗？(y/N): "
if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
    warn "已取消"
    exit 0
fi

# 恢复前，把当前状态也存一份安全备份，防止手抖选错
SAFETY_DIR="$BACKUPS_DIR/$(date +%Y%m%d-%H%M)-before-restore"
mkdir -p "$SAFETY_DIR"
[[ -f ~/.zshrc ]] && cp ~/.zshrc "$SAFETY_DIR/.zshrc"
[[ -f ~/.config/starship.toml ]] && cp ~/.config/starship.toml "$SAFETY_DIR/starship.toml"
warn "已把恢复前的当前状态存到 backups/$(basename "$SAFETY_DIR")（以防选错）"

if [[ -f "$CHOSEN_DIR/.zshrc" ]]; then
    cp "$CHOSEN_DIR/.zshrc" ~/.zshrc
    success ".zshrc 已恢复"
fi

if [[ -f "$CHOSEN_DIR/starship.toml" ]]; then
    mkdir -p ~/.config
    cp "$CHOSEN_DIR/starship.toml" ~/.config/starship.toml
    success "starship.toml 已恢复"
fi

echo ""
echo "✅ 恢复完成，打开新的终端窗口 / Tab 生效。"
