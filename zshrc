autoload -U colors; colors
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH_DISABLE_COMPFIX=true

[[ ! -f /opt/homebrew/bin/brew ]] || alias brew='/opt/homebrew/bin/brew'
[[ ! -f /opt/homebrew/bin/brew ]] || export PATH="/opt/homebrew/bin:$PATH"
export PATH=/usr/local/opt/gnu-getopt/bin:/usr/local/opt/gnu-sed/libexec/gnubin:/usr/local/opt/coreutils/libexec/gnubin:/Users/irk8fe/GIT/scripts:$PATH

# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git)
source $ZSH/oh-my-zsh.sh

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

alias sshns='ssh -q -o StrictHostKeyChecking=no -o GlobalKnownHostsFile=/dev/null -o UserKnownHostsFile=/dev/null'
alias scpns='scp -q -o StrictHostKeyChecking=no -o GlobalKnownHostsFile=/dev/null -o UserKnownHostsFile=/dev/null'
alias amend='git commit -a --amend --no-edit && git push --force-with-lease'
alias randpass='openssl rand -base64 8'

alias k='kubectl'
alias gst="git status"
alias wapo='watch "kubectl get po"'
alias gh-not='yarn --cwd ~/GIT/scripts/github-notifications dev'

setopt rcquotes
alias prunebranches='git fetch -p && for branch in $(git for-each-ref --format ''%(refname) %(upstream:track)'' refs/heads | awk ''$2 == "[gone]" {sub("refs/heads/", "", $1); print $1}''); do git branch -D $branch; done'

function k8s_root_shell (){
    kpexec --kubeconfig $KUBECONFIG -it -T $1 -- /bin/bash
}

export EDITOR="code --wait"

function set-dotnet-vars {
  DOTNET_BASE=$(dotnet --info | grep "Base Path" | awk '{print $3}')
  DOTNET_ROOT=$(echo $DOTNET_BASE | sed -E "s/^(.*)(\/sdk\/[^\/]+\/)$/\1/")
  
  export MSBuildSDKsPath=${DOTNET_BASE}Sdks/ 
  export DOTNET_ROOT=$DOTNET_ROOT
  export PATH=$DOTNET_ROOT:$PATH
}

set-dotnet-vars

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
fi

autoload -Uz compinit && compinit

# custom other zshrc files
subshells=(~/.zshrc_*)
[[ -e "${subshells[0]}" ]] || for f in $subshells; do source $f; done