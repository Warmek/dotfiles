export PROFILING_MODE=0
if [ $PROFILING_MODE -ne 0 ]; then
    zmodload zsh/zprof
    zsh_start_time=$(python3 -c 'import time; print(int(time.time() * 1000))')
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in zsh plugins
zinit ice silent wait'!0'
zinit light zsh-users/zsh-syntax-highlighting
zinit ice silent wait'!0'
zinit light zsh-users/zsh-completions
zinit ice silent wait lucid atload'_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions
zinit ice silent wait'!0'
zinit light Aloxaf/fzf-tab

zinit ice silent wait'!0'
zinit snippet OMZL::git.zsh
zinit ice silent wait'!0'
zinit snippet OMZP::git
zinit ice silent wait'!0'
zinit snippet OMZP::sudo

autoload -Uz add-zsh-hook vcs_info
setopt PROMPT_SUBST
add-zsh-hook precmd vcs_info
PROMPT='%F{blue}%~%f %F{white}${vcs_info_msg_0_}%f%F{magenta}❯%f '

zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '*'
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:git:*' formats       '%b%u%c '
zstyle ':vcs_info:git:*' actionformats '%b|%a%u%c '

# Load completions
autoload -Uz compinit

_comp_files=($ZSH_CACHE_DIR/zsh/zcompcache(Nm-20))
if (( $#_comp_files )); then
  compinit -i -C -d "$ZSH_CACHE_DIR/zcompcache"
else
  compinit -i -d "$ZSH_CACHE_DIR/zcompcache"
fi


unset _comp_file

zinit cdreplay -q

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

function fzf-git-branch() {
    git rev-parse HEAD > /dev/null 2>&1 || return

    git branch --color=always --all --sort=-committerdate |
        grep -v HEAD |
        fzf --height 50% --ansi --no-multi --preview-window right:65% \
            --preview 'git log -n 50 --color=always --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed "s/.* //" <<< {})' |
        sed "s/.* //"
}

function fzf-git-checkout() {
    git rev-parse HEAD > /dev/null 2>&1 || return

    local branch

    branch=$(fzf-git-branch)
    if [[ "$branch" = "" ]]; then
        echo "No branch selected."
        return
    fi

    # If branch name starts with 'remotes/' then it is a remote branch. By
    # using --track and a remote branch name, it is the same as:
    # git checkout -b branchName --track origin/branchName
    if [[ "$branch" = 'remotes/'* ]]; then
        git checkout --track $branch
    else
        git checkout $branch;
    fi
}

# Aliases
alias ls='ls --color'
alias la='ls -la'
alias v='nvim'
alias t='tmux'
alias gp='git pull'
alias gP='git push'
alias gch='fzf-git-checkout'
alias gsb='fzf-git-branch'

# profiling
if [ $PROFILING_MODE -ne 0 ]; then
    zsh_end_time=$(python3 -c 'import time; print(int(time.time() * 1000))')
    zprof
    echo "Shell init time: $((zsh_end_time - zsh_start_time - 21)) ms"
fi
