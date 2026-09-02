# Load local secrets (not tracked in git)
[ -f ~/.config/env/secrets.sh ] && source ~/.config/env/secrets.sh

# Tools
eval "$(starship init bash)"
eval "$(fzf --bash)"
eval "$(zoxide init bash)"
eval "$(keychain --eval --quiet)"

# Aliases
alias ls='ls --color'
alias la='ls -la'
alias v='nvim'
alias t='tmux'
alias ga='git add'
alias gc='git commit'
alias gp='git pull'
alias gP='git push'
alias gch='fzf-git-checkout'
alias cd='z'

fzf-git-checkout() {
    if [ $# -gt 0 ]; then
        git checkout "$@"
        return
    fi

    local branch
    branch=$(git branch --all --format='%(refname:short)' | \
             grep -v HEAD | \
             fzf --preview 'git log -1 --oneline {}' \
                 --preview-window=right:50% \
                 --header='Select branch to checkout')
    
    if [ -n "$branch" ]; then
        branch="${branch#origin/}"
        git checkout "$branch"
    fi
}

# opencode
export PATH=/$HOME/.opencode/bin:$PATH
#
# Add .NET Core SDK tools
export PATH="$HOME/.dotnet/tools:$PATH"

export PATH="$HOME/.local/bin:$PATH"
