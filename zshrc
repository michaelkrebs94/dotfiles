# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH_DISABLE_COMPFIX=TRUE

# If you come from bash you might have to change your $PATH.
# export PATH=/opt/homebrew/bin:$HOME/bin:/usr/local/bin:$PATH
alias brew='/opt/homebrew/bin/brew'

export PATH=/opt/homebrew/bin/:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/michaelkrebs/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git)
source $ZSH/oh-my-zsh.sh

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

alias sshns='ssh -q -o StrictHostKeyChecking=no -o GlobalKnownHostsFile=/dev/null -o UserKnownHostsFile=/dev/null'
alias scpns='scp -q -o StrictHostKeyChecking=no -o GlobalKnownHostsFile=/dev/null -o UserKnownHostsFile=/dev/null'
alias amend='git commit -a --amend --no-edit && git push --force-with-lease'
alias randpass='openssl rand -base64 8'

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

  autoload -Uz compinit
  compinit
fi
