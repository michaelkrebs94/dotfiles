autoload -U colors; colors
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ~/.zgenom/zgenom.zsh
# Generate zgen init.sh if it doesn't exist
if ! zgenom saved; then
    zgenom ohmyzsh

    # Plugins
    zgenom ohmyzsh plugins/git
    zgenom ohmyzsh plugins/github
    zgenom ohmyzsh plugins/sudo
    zgenom ohmyzsh plugins/command-not-found
    zgenom ohmyzsh plugins/kubectl
    zgenom ohmyzsh plugins/docker
    zgenom ohmyzsh plugins/docker-compose
    zgenom load zsh-users/zsh-autosuggestions
    zgenom load denolfe/git-it-on.zsh
    zgenom load caarlos0/zsh-mkc

    # These 2 must be in this order
    zgenom load zsh-users/zsh-syntax-highlighting

    # Completion-only repos
    zgenom load zsh-users/zsh-completions src

    # Theme
    zgenom load romkatv/powerlevel10k powerlevel10k

    # Generate init.sh
    zgenom save
fi


export ZSH_DISABLE_COMPFIX=true

[[ ! -f /opt/homebrew/bin/brew ]] || alias brew='/opt/homebrew/bin/brew'
[[ ! -f /opt/homebrew/bin/brew ]] || export PATH="/opt/homebrew/bin:$PATH"
export PATH=/usr/local/opt/gnu-getopt/bin:/usr/local/opt/gnu-sed/libexec/gnubin:/usr/local/opt/coreutils/libexec/gnubin:/Users/irk8fe/GIT/scripts:$PATH

source ~/.p10k.zsh

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
setopt nullglob
subshells=(~/.zshrc_*)
[[ -e "${subshells[0]}" ]] || for f in $subshells; do source $f; done

# code completions for homebrew modules
completions=(
  "/opt/homebrew/etc/bash_completion.d/az"
  "/opt/homebrew/etc/bash_completion.d/dotnet"
  "/opt/homebrew/etc/bash_completion.d/npm"
  )
for f in $completions; do [[ ! -f $f ]] || source $f; done

unsetopt nullglob

