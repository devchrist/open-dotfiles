#!/usr/bin/env zsh

SRC_DIR=$(cd $(dirname ${BASH_SORCE:-$0}); pwd)
SHELL_DIR=~/.zshrc
SHELL_PROFILE_DIR=~/.zprofile
VS_CODE_SETTING_DIR=~/Library/Application\ Support/Code/User

function install_validation() {
  if [ "$(uname)" = "Darwin" ]; then
    echo "Darwin"
  else
    echo "Not Support Distribution."
    exit 1
  fi

  if [ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]; then
    echo "Not Install Zinit. Please Install Zinit here."
    echo "https://github.com/zdharma-continuum/zinit"
    exit 1
  else
    echo "Zinit Checked."
  fi

  if [ -e /Library/Developer/CommandLineTools ]; then
    echo "Xcode CLI Tool Checked."
  elif [ -e /Applications/Xcode.app/Contents/Developer ]; then
    echo "Xcode CLI Tool Checked."
  else
    echo "Not Xcode CLI Tool."
    echo "---[Xcode CLI Tool Install Command]---"
    echo "xcode-select --install"
    echo "--------------------------------------"
    exit 1
  fi
}

function install_homebrew() {
  if [ -n "$HOMEBREW_PREFIX" ]; then
    if [ -e $HOMEBREW_PREFIX ]; then
      echo "\nChecked Homebrew.\n"
    else
      echo "\nNot Installed Homebrew.\n"
      NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
  else
    echo "\nNot Installed Homebrew.\n"
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  echo "\nHomebrew Setup Zprofile.\n"
  {
    echo "# Set PATH, MANPATH, etc., for Homebrew."
    echo "eval \"\$(/opt/homebrew/bin/brew shellenv)\""
  } >> $SHELL_PROFILE_DIR

  echo "\nHomebrew Bundle Install.\n"
  local brewfile_dir="$SRC_DIR/src/brew/Brewfile"
  brew bundle install --file=$brewfile_dir
  echo "\nDone.\n"
}

function add_zinit_plugin() {
  {
    echo "\n\n# Zinit Plugin"
    echo "zinit light zsh-users/zsh-syntax-highlighting"
    echo "zinit light zsh-users/zsh-history-substring-search # Need to write after highlighting"
    echo "zinit light zsh-users/zsh-autosuggestions"
    echo "zinit light zsh-users/zsh-completions"
    echo "zinit light zdharma-continuum/history-search-multi-word"
  } >> $SHELL_DIR
}

function add_zinit_thema() {
  {
    echo "\n# Terminal Thema"
    echo "## Prune (https://github.com/sindresorhus/pure)"
    echo "zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'"
    echo "zinit light sindresorhus/pure"
    echo "zstyle :prompt:pure:path color cyan"
    echo "zstyle :prompt:pure:git:branch color yellow"
    echo "zstyle :prompt:pure:virtualenv color cyan"
    echo "PURE_CMD_MAX_EXEC_TIME=180"
  } >> $SHELL_DIR
}

function add_zstyle() {
  {
    echo "\n# Zsh Style"
    echo "zstyle ':completion:*' menu yes select"
    echo "zstyle ':completion:*' file-list all"
  } >> $SHELL_DIR
}

function add_alias() {
  {
    echo "\n# Alias"
    echo "alias c='clear'"
  } >> $SHELL_DIR
}

function add_nodebrew() {

  if [ ! -e $HOME/.nodebrew ]; then
    echo "Nodebrew setup directory"
    nodebrew setup_dir
  else
    echo "Nodebrew Checked."
  fi

  {
    echo "\n# Nodebrew"
    echo "export PATH=\$HOME/.nodebrew/current/bin:\$PATH"
  } >> $SHELL_DIR
}

function add_pyenv() {
  {
    echo "\n# Pyenv"
    echo "export PYENV_ROOT=\"$HOME/.pyenv\""
    echo "eval \"\$(pyenv init --path)\""
    echo "eval \"\$(pyenv init -)\""
  } >> $SHELL_DIR
}

function add_rbenv() {
  {
    echo "\n# Rbenv"
    echo "eval \"\$(rbenv init - zsh)\""
  } >> $SHELL_DIR
}

function add_mysql_client() {
  {
    echo "\n# Mysql Client"
    echo "export PATH=\"/opt/homebrew/opt/mysql-client/bin:\$PATH\""
  } >> $SHELL_DIR
}

function setup_zsh() {
  # zsh compinit
  sed -i '' -e $'1s/^/autoload -Uz compinit \\&\\& compinit\\\n/' $SHELL_DIR
  add_zinit_plugin
  add_zinit_thema
  add_zstyle
  add_alias
  add_nodebrew
  add_pyenv
  add_rbenv
  add_mysql_client
}

function vim_cnf() {
  echo "\nCopy vim Config"
  cp -f $SRC_DIR/src/vim/.vimrc ~/.vimrc
  cp -f $SRC_DIR/src/vim/.gvimrc ~/.gvimrc
}

function install_vscode_extention() {
  local extensions=$(cat src/vscode/extensions.json | jq '.extensions[]')
  echo $extensions
}

function vscode_cnf() {
  echo "\nCopy vscode Config"
  if [ ! -e $VS_CODE_SETTING_DIR ]; then
    echo "VSCode setup directory"
    mkdir -p $VS_CODE_SETTING_DIR
  else
    echo "VSCode Checked."
  fi
  cp -f $SRC_DIR/src/vscode/settings.json $VS_CODE_SETTING_DIR/settings.json
}

function main() {

  echo "\ndotfiles install start.\n"

  install_validation
  install_homebrew
  setup_zsh
  vim_cnf
  # install_vscode_extention
  vscode_cnf

  echo "\ndotfiles installed.\n"
}

main