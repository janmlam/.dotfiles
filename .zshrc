export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"
export MAVEN_OPTS="$MAVEN_OPTS -Dno.uio.nettskjema.api.properties.path=file:///Users/janlam/properties/nettskjema-api.properties"
export MAVEN_OPTS="$MAVEN_OPTS -Dno.uio.nettskjema.authorization.properties.path=file:///Users/janlam/properties/nettskjema-authorization.properties"
export PATH="/opt/homebrew/opt/node@16/bin:$PATH"
export VAULT_ADDR="https://vault.uio.no:8200"
# export PATH=$(pyenv root)/shims:$PATH
# export JAVA_HOME=$(jenv javahome)
setopt histignoredups
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
export SAVEHIST=5000
export HISTSIZE=5000
export HISTFILE=~/.zsh_history
export HISTTIMEFORMAT='%F %T '

# GPG start
export GPG_TTY=$(tty)
#if [ -S "$(gpgconf --list-dirs agent-socket)" ]; then
#    export GPG_AGENT_INFO
#else
#    eval $(gpgconf --launch gpg-agent) 
#fi

# GPG end
export CLICOLOR=1

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PIPENV_PYTHON="$PYENV_ROOT/shims/python"

plugin=(
  pyenv
)

eval "$(pyenv init -)"

alias proxy='ssh -CfND 15236 -i ~/.ssh/id_ed25519 janlam@login.uio.no'
alias nsproxy='nstunnel ; sshuttle -r webjump 0.0.0.0/0 -x login.uio.no'
alias nsldap='mvn clean jetty:run -Plocal,jetty,local-ldap -Djboss.server.log.dir=/tmp -DsocksProxyHost=127.0.0.1 -DsocksProxyPort=9998 -Dno.uio.nettskjema.properties.path=file:///Users/janlam/properties/nettskjema.properties'
alias nsapi='./mvnw spring-boot:run -Dno.uio.nettskjema.api.profiles=localhost,proxy-enabled'
alias ecshuttle='sshuttle -r webjump 0/0 129.240.8.71'
alias assh='autossh -M $RANDOM'
alias tunnel2Con='ssh -f -N autotunnel'
alias nstunnel='ssh autotunnel'
alias helsenorgetunnel='ssh -D 9997 tunnel-nettskjema-helsenorge-jump'
alias gitrecent='git for-each-ref --count=7 --sort=-committerdate refs/heads/ --format="%(refname:short)"'
alias gitclear='git fetch --all -p; git branch -vv | grep '\'': gone]'\'' | awk '\''{ print  }'\'' | xargs -n 1 git branch -D'
alias sortMessages='bash /Users/janlam/nettskjema-api/src/test/sh/sort-i18n-files.sh'

function gitMergeMaster() {
    BRANCH=$1
    git pull origin master
    git checkout master
    git merge $BRANCH
    git push -u origin master
}

# start OMZ
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="simple"
plugins=(
  git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete
)
source $ZSH/oh-my-zsh.sh
# end OMZ

searchAndDestroy() {
  lsof -i TCP:$1 | grep LISTEN | awk '{print $2}' | xargs kill -9
  echo "Port" $1 "found and killed."
}

decode_base64_url() {
  local len=$((${#1} % 4))
  local result="$1"
  if [ $len -eq 2 ]; then result="$1"'=='
  elif [ $len -eq 3 ]; then result="$1"'=' 
  fi
  echo "$result" | tr '_-' '/+' | openssl enc -d -base64
}

decode_jwt(){
   decode_base64_url $(echo -n $2 | cut -d "." -f $1) | jq .
}

# Decode JWT header
alias jwth="decode_jwt 1"

# Decode JWT Payload
alias jwtp="decode_jwt 2"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
