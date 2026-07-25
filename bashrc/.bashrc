#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='\[\e[1;38;5;214m\]\W\[\e[0m\] \$ '

# export SUDO_EDITOR=/usr/bin/vim
# export EDITOR=/usr/bin/vim
# export VISUAL=/usr/bin/vim
SUDO_EDITOR=nvim
EDITOR=nvim
VISUAL=nvim


# Add "$1" to PATH only if not already present (avoids duplicates on repeated sourcing)
prepend_path () {
    case ":$PATH:" in
        *:"$1":*) ;;
        *) PATH="$1${PATH:+:$PATH}" ;;
    esac
}
append_path () {
    case ":$PATH:" in
        *:"$1":*) ;;
        *) PATH="${PATH:+$PATH:}$1" ;;
    esac
}
append_path "$HOME/.local/bin/scripts/"
TMPDIR=$HOME/.tmp

#export NNN_OPTS="dAUea"
export NNN_FCOLORS='c1e2272e006033f7c6d6abc4'
export NNN_PLUG='j:autojump;f:fzopen;p:preview-tui;d:diffs;v:imgview;k:fzcd;e:eedit'
export NNN_FIFO="$TMPDIR/nnn.fifo"
#export NNN_OPENER="$HOME/.local/bin/helpers/opener.sh"

#export NNN_TMPFILE="$TMPDIR/nnn.tmp"
#Key binding for nnn is in quitcd.sh
#source $HOME/.local/bin/helpers/quitcd.sh

if [[ -f "$HOME/.bash_aliases" ]]; then
    . "$HOME/.bash_aliases"
fi

if ! shopt -oq posix; then
    if [[ -f /usr/share/bash-completion/bash_completion ]]; then
        . /usr/share/bash-completion/bash_completion
    elif [[ -f /etc/bash_completion ]]; then
        . /etc/bash_completion
    fi
fi

alias j='z'
alias jj='zi'
# zoxide must be at bottom
eval "$(zoxide init bash)"

prepend_path "$HOME/.local/bin"
unset -f append_path prepend_path

if [[ -f "$HOME/.bashrc.work" ]]; then
    . "$HOME/.bashrc.work"
fi
