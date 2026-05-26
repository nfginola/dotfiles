# (ctrl + s) in terminal sends a stop signal (legacy TTY feature): annoying, remove
stty -ixon

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

# Plugins
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting

# Prompt
__git_branch() {
    local branch
    branch=$(git symbolic-ref --short HEAD 2>/dev/null) || return
    echo " %F{red}($branch)%f"
}
setopt PROMPT_SUBST
PS1='%B%F{214}%~%f%b$(__git_branch) $ '

# Env
export SUDO_EDITOR=nvim
export EDITOR=nvim
export VISUAL=nvim
export TMPDIR=$HOME/.tmp
export PATH="$HOME/.local/bin:$HOME/.local/bin/scripts/:$PATH"

# NNN
export NNN_FCOLORS='c1e2272e006033f7c6d6abc4'
export NNN_PLUG='j:autojump;f:fzopen;p:preview-tui;d:diffs;v:imgview;k:fzcd;e:eedit'
export NNN_FIFO="$TMPDIR/nnn.fifo"
export NNN_OPENER="$HOME/.local/bin/scripts/opener.sh"

# Aliases
alias ls='ls --color=auto'
_ls_colors=(
    "di=38;5;214"   # directories       — amber
    "fi=38;5;177"   # regular files     — purple floral
    "ln=38;5;255"   # symlinks          — bright white
    "ex=38;5;120"   # executables       — soft green
    "mi=38;5;196"   # missing symlinks  — red
    "*.tar=38;5;203" "*.tgz=38;5;203" "*.zip=38;5;203"   # archives
    "*.gz=38;5;203"  "*.bz2=38;5;203" "*.xz=38;5;203"   # archives
    "*.7z=38;5;203"  "*.rar=38;5;203"                    # archives  — coral
    "*.png=38;5;81" "*.jpg=38;5;81" "*.jpeg=38;5;81"  # images
    "*.gif=38;5;81" "*.webp=38;5;81" "*.svg=38;5;81"  # images
    "*.mp4=38;5;81" "*.mkv=38;5;81"                    # video
    "*.mp3=38;5;81" "*.flac=38;5;81" "*.wav=38;5;81"  # audio     — sky blue
)
export LS_COLORS="${(j[:])_ls_colors}"
alias grep='grep --color=auto'
alias j='z'
# alias jf='zi'
alias claude='claude --allow-dangerously-skip-permissions'
alias rp='realpath'

# Helpers
#source $HOME/.local/bin/scripts/quitcd.sh

# zoxide
eval "$(zoxide init zsh)"

# Keybindings
bindkey '^R' history-incremental-search-backward

# FZF
export FZF_DEFAULT_OPTS="
	--bind='ctrl-n:down'
	--bind='ctrl-p:up'
"
if [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
    source /usr/share/fzf/key-bindings.zsh
elif [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
    source /usr/share/doc/fzf/examples/key-bindings.zsh
fi

# workaround: fast-syntax-highlighting (FSH) colours vanish on the first cold-start terminal.
#
# WezTerm cold-start 
# → mux server sends SIGWINCH late 
# → ZLE's resize handler wipes region_highlight (!) 
# → prompt redraws without FSH colours.
_fsh_rehighlight() {
    (( $+functions[_zsh_highlight] )) && _zsh_highlight  # rebuild colour data
    zle reset-prompt                                      # repaint with new colours
}

# register function as ZLE widget
zle -N _fsh_rehighlight

# declare callback which invokes the ZLE widget on SIGWINCH (signal window change)
TRAPWINCH() { zle && zle _fsh_rehighlight }

if [[ -f "$HOME/.zshrc.work" ]]; then
    source "$HOME/.zshrc.work"
fi

# zinit stuff above this

unalias zi 2>/dev/null

# zoxide
eval "$(zoxide init zsh)"

# fzf
# Debian's packaged fzf may not support `fzf --zsh`, so fall back to the shipped
# completion script when that flag is unavailable.
if command -v fzf >/dev/null; then
    if fzf --zsh >/dev/null 2>&1; then
        eval "$(fzf --zsh)"
    elif [[ -f /usr/share/fzf/completion.zsh ]]; then
        source /usr/share/fzf/completion.zsh
    elif [[ -f /usr/share/doc/fzf/examples/completion.zsh ]]; then
        source /usr/share/doc/fzf/examples/completion.zsh
    fi
fi
