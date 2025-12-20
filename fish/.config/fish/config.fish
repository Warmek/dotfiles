if status is-interactive
    set fish_greeting
end

if command -q nix-your-shell
  nix-your-shell fish | source
end

#carapace
set -Ux CARAPACE_BRIDGES 'zsh,fish,bash,inshellisense' # optional
carapace _carapace | source

fzf --fish | source

alias gc="git commit"
alias gp="git pull"
alias gP="git push"
alias v="nvim"
alias t="tmux"

bind ctrl-y 'accept-autosuggestion'
