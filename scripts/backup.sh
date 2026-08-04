#!/bin/zsh
# ─── 备份当前 .zshrc / starship.toml 到仓库 backups/ 下 ─────────────
# 用法: ./scripts/backup.sh <简单说明，不要带空格>
# 例如: ./scripts/backup.sh zshstartship  →  backups/20260606-zshstartship/
set -e

GREEN="\033[32m"; YELLOW="\033[33m"; RED="\033[31m"; NC="\033[0m"
success() { echo -e "  ${GREEN}✓${NC} $1"; }
warn()    { echo -e "  ${YELLOW}!${NC} $1"; }
error()   { echo -e "  ${RED}✗${NC} $1"; exit 1; }

DESC="$1"
if [[ -z "$DESC" ]]; then
    error "请提供备份说明，例如: ./scripts/backup.sh zshstartship"
fi

SCRIPT_DIR="$(cd "$(dirname "${(%):-%N}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
DATE="$(date +%Y%m%d)"
BACKUP_DIR="$REPO_DIR/backups/${DATE}-${DESC}"

if [[ -d "$BACKUP_DIR" ]]; then
    BACKUP_DIR="${BACKUP_DIR}-$(date +%H%M)"
    warn "当天同名备份已存在，改用: $(basename "$BACKUP_DIR")"
fi

mkdir -p "$BACKUP_DIR"

if [[ -f ~/.zshrc ]]; then
    cp ~/.zshrc "$BACKUP_DIR/.zshrc"
    success "已备份 ~/.zshrc"
else
    warn "~/.zshrc 不存在，跳过"
fi

if [[ -f ~/.config/starship.toml ]]; then
    cp ~/.config/starship.toml "$BACKUP_DIR/starship.toml"
    success "已备份 ~/.config/starship.toml"
else
    warn "~/.config/starship.toml 不存在，跳过"
fi

echo ""
echo "备份已保存到: backups/$(basename "$BACKUP_DIR")"
echo "记得提交到 git 才算真正存档:"
echo "  cd $REPO_DIR && git add backups && git commit -m \"backup: ${DESC}\" && git push"
