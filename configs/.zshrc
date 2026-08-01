#!/bin/zsh
# ─── Zsh 配置：Starship + zsh-autosuggestions + zsh-syntax-highlighting ───

# ─── Homebrew ────────────────────────────────────────────────────────
if [[ -d /opt/homebrew ]]; then
    export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
    BREW_PREFIX="/opt/homebrew"
elif [[ -d /usr/local/Cellar ]]; then
    export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
    BREW_PREFIX="/usr/local"
else
    BREW_PREFIX=""
fi

# ─── Starship prompt ────────────────────────────────────────────────
eval "$(starship init zsh)"

# ─── Zsh 自动建议（fish 式历史建议）───────────────────────────────────
if [[ -n "$BREW_PREFIX" && -f "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# ─── 补全增强 ───────────────────────────────────────────────────────
if [[ -n "$BREW_PREFIX" && -d "$BREW_PREFIX/share/zsh-completions" ]]; then
    fpath=("$BREW_PREFIX/share/zsh-completions" $fpath)
fi
autoload -Uz compinit && compinit

# 大小写不敏感 + 子串匹配
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=*'

# ─── 历史记录 ────────────────────────────────────────────────────────
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY

# ─── 上下键按前缀搜索历史 ─────────────────────────────────────────────
autoload -U up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

# ─── 可选：常用别名（需要额外安装对应工具才生效，默认注释）─────────────
# brew install eza bat fd ripgrep btop lazygit  # 需要时再装
# alias ls='eza --icons --group-directories-first'
# alias ll='eza -la --icons --group-directories-first'
# alias cat='bat'
# alias find='fd'
# alias grep='rg'
# alias top='btop'
# alias lg='lazygit'

# ─── zsh-syntax-highlighting（必须放在文件最后）────────────────────────
# 放最后是为了让 compinit / zle -N 等前面创建的 widget 也能被语法高亮覆盖
if [[ -n "$BREW_PREFIX" && -f "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
