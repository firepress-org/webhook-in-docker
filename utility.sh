#!/usr/bin/env bash

set -o errexit          # Exit on most errors (see the manual)
set -o errtrace         # Make sure any error trap is inherited
set -o pipefail         # Use last non-zero exit code in a pipeline
#set -o xtrace          # Trace the execution of the script (debug)
#
#set -o nounset          # Disallow expansion of unset variables
# --- Find bad variables by using `./utility.sh test two three`, else disable it
# --- or remove $1, $2, $3 var defintions in @main


### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
# DOCKER
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
function lint {
  docker_image="redcoolbeans/dockerlint"

  docker run -it --rm \
    -v $(pwd)/Dockerfile:/Dockerfile:ro \
    ${docker_image}
}

function figlet {
  docker_image="devmtl/figlet:1.0"
  message="Hey figlet"

  docker run --rm ${docker_image} ${message}
}


### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
# Git
# Requires https://github.com/aktau/github-release
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###

function hash {
  git rev-parse --short HEAD
}
function master {
  git checkout master
}
function edge {
  git checkout edge
}
function check {
  git status
}
function diff {
  check && echo
  git diff
}
function push {

  App_is_input2_empty

  git status && \
  git add -A && \
  git commit -m "${input_2}" && \
  clear
  git push
}
function squash {
  echo " "
}
function rbmaster {
  # think rebase_master_from_edge
  if [[ $(git status | grep -c "nothing to commit") == "1" ]]; then
    echo "good, nothing to commit" | 2>/dev/null
    git checkout master
    git pull origin master
    git rebase edge
    git push
    hash_master_is=$(git rev-parse --short HEAD)
    # go back to edge by default
    git checkout edge
    #
    hash_edge_is=$(git rev-parse --short HEAD)
    my_message="Diligence: ${hash_master_is} | ${hash_master_is} (master vs edge should be the same)" App_Blue

  else
    my_message="You must push your commit(s) before doing a rebase." App_Pink
  fi
}
function rbedge {
  # think rebase_edge_from_master
  if [[ $(git status | grep -c "nothing to commit") == "1" ]]; then
    echo "good, nothing to commit" | 2>/dev/null
    git checkout edge
    git pull origin edge
    git rebase master
    git push
    hash_edge_is=$(git rev-parse --short HEAD)
    #
    git checkout master
    hash_master_is=$(git rev-parse --short HEAD)
    git checkout edge
    my_message="Diligence: ${hash_master_is} | ${hash_master_is} (master vs edge should be the same)" App_Blue

  else
    my_message="You must push your commit(s) before doing a rebase." App_Pink
  fi
}
function ci-status {
  hub ci-status $(git rev-parse HEAD)
}
function version {
  # update version in Dockerfile
  # tag version on the latest commit
  # push tag to remote

  App_is_input2_empty
  tag_version="${input_2}"

  # Prompt a warning
  min=1 max=10 message="WARNING: On MASTER branch?? CHANGELOG.md is updated??"
  for ACTION in $(seq ${min} ${max}); do
    echo -e "${col_pink} ${message} ${col_pink}" && sleep 0.4 && clear && \
    echo -e "${col_blue} ${message} ${col_blue}" && sleep 0.4 && clear
	done

  sed -i '' "s/^ARG VERSION=.*$/ARG VERSION=\"$tag_version\"/" Dockerfile 

  git add . && \
  git commit -m "Updated to version: $tag_version" && \
  git push && \
  sleep 1 && \
  # push tag
  git tag ${tag_version} && \
  git push --tags
}
function release {
  # ensure to 'version' has tag the latest commit
  # release on github

  App_is_input2_empty

  tag_version="${input_2}"
  git_repo_url=$(cat Dockerfile | grep GIT_REPO_URL= | head -n 1 | grep -o '".*"' | sed 's/"//g')

  # Prompt a warning
  min=1 max=10 message="WARNING: On MASTER branch?? CHANGELOG.md is updated??"
  for ACTION in $(seq ${min} ${max}); do
    echo -e "${col_pink} ${message} ${col_pink}" && sleep 0.4 && clear && \
    echo -e "${col_blue} ${message} ${col_blue}" && sleep 0.4 && clear
	done

  # push tag
  git tag ${tag_version} && \
  git push --tags
  
  export GITHUB_TOKEN="$(cat ~/secrets_open/token_github/token.txt)"
  gopath=$(go env GOPATH)

  release_message="Refer to [CHANGELOG.md]("${git_repo_url}"/blob/master/CHANGELOG.md) for details about this release."
  clear && echo && \
  echo "Let's release version: ${tag_version}" && sleep 1 && \

  hub release create -oc \
    -m "${tag_version}" \
    -m "${release_message}" \
    -t "$(git rev-parse HEAD)" \
    "${tag_version}"
  # https://hub.github.com/hub-release.1.html
    # title
    # description
    # on which commits (use the latest)
    # on which tag (use the latest)

    echo "${git_repo_url}/releases/tag/${tag_version}"
}
function tag {
  echo "Look for 'ver' instead."
}


### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
# OTHER
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###

function test {

  echo "\$1 is now ${input_1}"
  echo "\$2 is now ${input_2}"
  echo "\$3 is now ${input_3}"
  my_message="Date is: ${date_sec}." App_Blue
  # Useful when trying to find bad variables along 'set -o nounset'
}
#
  #
#
function gitignore {
# this overrides your existing .gitignore

cat <<EOF > .gitignore
# .gitignore
############
test
.cache
coverage
dist
node_modules
npm-debug
.env

# Directories
############

# Files
############
var-config.sh

# Compiled source #
###################
*.com
*.class
*.dll
*.exe
*.o
*.so

# Packages #
############
# it's better to unpack these files and commit the raw source
# git has its own built in compression methods
*.7z
*.dmg
*.gz
*.iso
*.jar
*.rar
*.tar
*.zip

# Logs and databases #
######################
*.log
*.sql
*.sqlite

# OS generated files #
######################
.DS_Store
.DS_Store?
.vscode
.Trashes
ehthumbs.db
Thumbs.db
.AppleDouble
.LSOverride
.metadata_never_index

# Thumbnails
############
._*

# Icon must end with two \r
###########################
Icon

# Files that might appear in the root of a volume
#################################################
.DocumentRevisions-V100
.fseventsd
.dbfseventsd
.Spotlight-V100
.TemporaryItems
.Trashes
.trash
.VolumeIcon.icns
.com.apple.timemachine.donotpresent
.com.apple.timemachine.supported
.PKInstallSandboxManager
.PKInstallSandboxManager-SystemSoftware
.file
.hotfiles.btree
.quota.ops.user
.quota.user
.quota.ops.group
.quota.group
.vol
.efi

# Directories potentially created on remote AFP share
#####################################################
.AppleDB
.AppleDesktop
Network Trash Folder
Temporary Items
.apdisk
.Mobile*
.disk_*

# Sherlock files
################
TheFindByContentFolder
TheVolumeSettingsFolder
.FBCIndex
.FBCSemaphoreFile
.FBCLockFolder
EOF
}
#
  #
#
function App_is_input2_empty {
  if [[ "${input_2}" == "not-set" ]]; then
    my_message="You must provide a Git message." App_Pink
    App_stop
  fi
}
#
  #
#
function array_example {
  arr=( "hello" "world" "three" )
  
  for i in "${arr[@]}"; do
    echo ${i}
  done
}
#
  #
#
function passgen {
  grp1=$(openssl rand -base64 32 | sed 's/[^123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz]//g' | cut -c11-14) && \
  grp2=$(openssl rand -base64 32 | sed 's/[^123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz]//g' | cut -c2-25) && \
  grp3=$(openssl rand -base64 32 | sed 's/[^123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz]//g' | cut -c21-24) && \
  clear && \
  echo "${grp1}_${grp2}_${grp3}"
}
function passgenmax {
  grp1=$(openssl rand -base64 32 | sed 's/[^123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz]//g' | cut -c11-14) && \
  grp2=$(openssl rand -base64 48 | sed 's/[^123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz]//g' | cut -c2-50) && \
  grp3=$(openssl rand -base64 32 | sed 's/[^123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz]//g' | cut -c21-24) && \
  clear && \
  echo "${grp1}_${grp2}_${grp3}"
}
#
  #
#
function App_stop {
  echo && exit 1
}
#
  #
#
function App_utility_vars {
#==============================================
#	Date generators
 date_nano="$(date +%Y-%m-%d_%HH%Ms%S-%N)";
  date_sec="$(date +%Y-%m-%d_%HH%Ms%S)";
  date_min="$(date +%Y-%m-%d_%HH%M)";
 date_hour="$(date +%Y-%m-%d_%HH)XX";
  date_day="$(date +%Y-%m-%d)";
date_month="$(date +%Y-%m)-XX";
 date_year="$(date +%Y)-XX-XX";
          # 2017-02-22_10H24_14-500892448
          # 2017-02-22_10H24_14
          # 2017-02-22_10H24
          # 2017-02-22_10HXX
          # 2017-02-22
          # 2017-02-XX
          # 2017-XX-XX

#==============================================
#	Define color for echo prompts:
  export col_std="\e[39m——>\e[39m"
  export col_grey="\e[39m——>\e[39m"
  export col_blue="\e[34m——>\e[39m"
  export col_pink="\e[35m——>\e[39m"
  export col_green="\e[36m——>\e[39m"
  export col_white="\e[97m——>\e[39m"
  export col_def="\e[39m"
}
function App_Pink {
  echo -e "${col_pink} ERROR: ${my_message}"
}
function App_Blue {
  echo -e "${col_blue} ${my_message}"
}
function App_Green {
  echo -e "${col_green} ${my_message}"
}
#
  #
#
function doc {
cat << EOF
  Utility's doc (documentation):

  This text is used as a placeholder. Words that will follow won't
  make any sense and this is fine. At the moment, the goal is to 
  build a structure for our site.

  Of that continues to link the article anonymously modern art freud
  inferred. Eventually primitive brothel scene with a distinction. The
  Enlightenment criticized from the history.
EOF
}
function docs { 
  doc
}

function main() {

  trap script_trap_err ERR
  trap script_trap_exit EXIT

  # shellcheck source=.bashcheck.sh
  source "$(dirname "${BASH_SOURCE[0]}")/.bashcheck.sh"

  App_utility_vars

  # input management
  input_1=$1
  if [[ -z "$1" ]]; then    #if empty
    clear
    my_message="You must provide at least one attribute." App_Pink
    App_stop
  else
    input_1=$1
  fi

  if [[ -z "$2" ]]; then    #if empty
    input_2="not-set"
  else
    input_2=$2
  fi

  if [[ -z "$3" ]]; then    #if empty
    input_3="not-set"
  else
    input_3=$3
  fi

  script_init "$@"
  cron_init
  colour_init
  #lock_init system

  clear
  $1
}

### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
# ENTRYPOINT
### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###
main "$@"
echo
# https://github.com/firepress-org/bash-script-template