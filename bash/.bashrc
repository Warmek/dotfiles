# Tools
eval "$(starship init bash)"
eval "$(fzf --bash)"
eval "$(zoxide init bash)"

export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
source <(carapace _carapace)

# Aliases
alias ls='ls --color'
alias la='ls -la'
alias v='nvim'
alias t='tmux'
alias ga='git add'
alias gc='git commit'
alias gp='git pull'
alias gP='git push'
alias gch='fzf-git-checkout' # TODO: create function
alias gsb='fzf-git-branch' # TODO: create function
alias cd='z'
