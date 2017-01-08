#!/usr/bin/env bash
# Bootstrap file for setting Go development environment.

go_version='1.7.4'
postgresql_version='9.6'
node_version='6.x'

# Heper functions
function append_to_file {
  echo "$1" | sudo tee -a "$2"
}

function replace_in_file {
  sudo sed -i "$1" "$2"
}

function install {
  echo "Installing $1..."
  shift
  sudo apt-get -y install "$@"
}

function update_packages {
  echo 'Updating package information...'
  sudo apt-get -y update
}

function add_repository {
  sudo add-apt-repository "$1"
  update_packages
}
# End of Heper functions

# Dependencies
function install_git {
  add_repository ppa:git-core/ppa
  install 'Git' git
}

function install_dependencies {
  sudo update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8

  install_git
}
# Enf of Dependencies

# PostgreSQL
function install_postgresql {
  append_to_file \
    'deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main' \
    /etc/apt/sources.list.d/pgdg.list
  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
    sudo apt-key add -
  update_packages

  install 'PostgreSQL' postgresql-"$postgresql_version" libpq-dev
}

function create_postgresql_superuser {
  sudo -u postgres createuser -s ubuntu
}

function allow_external_connections {
  append_to_file \
    'host all all all password' \
    /etc/postgresql/"$postgresql_version"/main/pg_hba.conf
  replace_in_file \
    "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" \
    /etc/postgresql/"$postgresql_version"/main/postgresql.conf
}

function install_postgresql_and_allow_external_connections {
  install_postgresql
  create_postgresql_superuser
  allow_external_connections
}
# End of PostgreSQL

# Go
function install_go {
  echo 'Installing Go...'
  wget https://storage.googleapis.com/golang/go"$go_version".linux-amd64.tar.gz
  sudo tar -xvf go"$go_version".linux-amd64.tar.gz
  sudo mv go /usr/local
}

function set_go_env_vars {
  echo 'Setting Go environment variables...'
  append_to_file 'export GOROOT=/usr/local/go' ~/.profile
  append_to_file 'export GOPATH=/vagrant/code' ~/.profile
  append_to_file 'export PATH=$PATH:$GOROOT/bin:$GOPATH/bin' ~/.profile
  source ~/.profile
}

function install_go_and_set_env_vars {
  install_go
  set_go_env_vars
}
#End of Go

# NodeJS
function install_node {
  curl -sL https://deb.nodesource.com/setup_"$node_version" | sudo -E bash -
  update_packages
  install 'NodeJS' nodejs
}

function set_npm_permissions {
  echo 'Setting correct Npm permissions...'
  mkdir ~/.npm-global
  npm config set prefix '~/.npm-global'
  append_to_file 'export PATH=~/.npm-global/bin:$PATH' ~/.profile
  source ~/.profile
}

function install_yarn {
  npm install --global yarn
}

function install_node_and_yarn {
  install_node
  set_npm_permissions
  install_yarn
}
# End of NodeJS


update_packages
install_dependencies
install_postgresql_and_allow_external_connections
install_go_and_set_env_vars
install_node_and_yarn


echo 'All set, rock on!'
