export_path() {
  for p in ${(s.:.)2}; do
    if [[ ! "${(P)1}" =~ "$p" ]]; then
      export "$1"="$p:${(P)1}"
    fi
  done
}

export_env() {
  local brew_prefix="$1"
  if [ -d "$brew_prefix" ]; then
    export_path 'PATH' "$brew_prefix/sbin:$brew_prefix/bin"
    export_path 'MANPATH' "$brew_prefix/share/man"
    export_path 'INFOPATH' "$brew_prefix/share/info"
    export_path 'XDG_DATA_DIRS' "$brew_prefix/share"
    fpath=( "$brew_prefix/completions/zsh" $fpath )
  fi
}

local HOME_PREFIX="$HOME/.linuxbrew"
local RECOMMENDED_PREFIX='/home/linuxbrew/.linuxbrew'

export_env $HOME_PREFIX
export_env $RECOMMENDED_PREFIX

if (( ! $+commands[brew] )); then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
  if [[ ! $? -eq 0 ]]; then
      echo -n 'Recommended install failed. Try just cloning git repo? '
      if read -q; then
          echo '...'
          git clone https://github.com/Linuxbrew/brew "$HOME_PREFIX" &> /dev/null &!
      fi
  fi
fi

unfunction export_env export_path
