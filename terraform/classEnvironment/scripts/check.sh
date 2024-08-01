#!/usr/bin/env bash

# This source code come from the opensource project DetectionLab : https://github.com/clong/DetectionLab
# This script is meant to verify that your system is configured to build the lab successfully.

ERROR=$(tput setaf 1; echo -n "  [!]"; tput sgr0)
GOODTOGO=$(tput setaf 2; echo -n "  [✓]"; tput sgr0)
INFO=$(tput setaf 3; echo -n "  [-]"; tput sgr0)

PROVIDERS="proxmox"
ANSIBLE_HOSTS="local"
print_usage() {
  echo "Usage: ./check.sh <provider> <ansible_host>"
  echo "provider must be one of the following:"
  for p in $PROVIDERS;  do
    echo " - $p";
  done
  echo "Ansible host must be one of the following:"
  for a in $ANSIBLE_HOSTS;  do
    echo " - $a";
  done
  exit 0
}

if [ $# -lt 2 ]; then
  print_usage
else
  PROVIDER=$1
  ANSIBLE_HOST=$2
fi

check_packer_path() {
  if ! which packer >/dev/null; then
    (echo >&2 "${ERROR} packer was not found in your PATH.")
    (echo >&2 "${ERROR} Please correct this before continuing. Exiting.")
    (echo >&2 "${ERROR} Correct this by installing packer : https://developer.hashicorp.com/packer/docs/install")
    exit 1
  else
    (echo >&2 "${GOODTOGO} packer was found in your PATH")
  fi
}

check_terraform_path() {
  if ! which terraform >/dev/null; then
    (echo >&2 "${ERROR} terraform was not found in your PATH.")
    (echo >&2 "${ERROR} Please correct this before continuing. Exiting.")
    (echo >&2 "${ERROR} Correct this by installing terraform : https://developer.hashicorp.com/terraform/downloads")
    exit 1
  else
    (echo >&2 "${GOODTOGO} terraform was found in your PATH")
  fi
}

check_sshpass_path() {
  if ! which sshpass >/dev/null; then
    (echo >&2 "${ERROR} sshpass was not found in your PATH.")
    (echo >&2 "${ERROR} Please correct this before continuing. Exiting.")
    (echo >&2 "${ERROR} Correct this by installing sshpass")
    exit 1
  else
    (echo >&2 "${GOODTOGO} sshpass was found in your PATH")
  fi
}


check_ansible_installed() {
  if ! which ansible >/dev/null; then
    (echo >&2 "${ERROR} ansible was not found in your PATH.")
  else
    (echo >&2 "${GOODTOGO} ansible is installed")
  fi
}

check_python_env(){
  if ! which python3 >/dev/null; then
    (echo >&2 "${ERROR} python3 was not found in your PATH.")
  else
    (echo >&2 "${GOODTOGO} python3 is installed")
    PYTHON_VERSION=$(python3 --version | cut -d ' ' -f 2)
    REQUIRED_VERSION="3.8"
    if [ "$(printf '%s\n' "$REQUIRED_VERSION" "$PYTHON_VERSION" | sort -V | head -n1)" = "$REQUIRED_VERSION" ]; then
      (echo >&2 "${GOODTOGO} python3 ($PYTHON_VERSION) is supported")
      check_ansible_env
    else
      (echo >&2 "${ERROR} python3 ($PYTHON_VERSION) is not supported start checking other available python interpreter")
      check_python_venv
      exit 1
    fi
  fi
}

check_python_venv(){
    PYTHON_INSTALLED=$(ls -1 /usr/bin/python* | grep '.*[3]\(.[0-9]\+\)\?$')
    REQUIRED_VERSION="3.8"
    GOOD_PYTHON=""
    (echo >&2 "${GOODTOGO} Supported python3 interpreter :")
    for python_interpreter in $PYTHON_INSTALLED;  do
      PYTHON_VERSION="$($python_interpreter --version | cut -d ' ' -f 2)"
      # If the version of python is not greater or equal to the required version
      if [ "$(printf '%s\n' "$REQUIRED_VERSION" "$PYTHON_VERSION" | sort -V | head -n1)" = "$REQUIRED_VERSION" ]; then
          (echo >&2 "  ${GOODTOGO} $python_interpreter ($PYTHON_VERSION) is supported")
          GOOD_PYTHON=$(echo "$GOOD_PYTHON" "$python_interpreter")
      fi
    done

    INTERPRETER_FOUND=0
    if [ "$GOOD_PYTHON" != "" ]; then
      (echo >&2 "${GOODTOGO} Verify python3 available environment :")
      for python in $GOOD_PYTHON; do
        (echo >&2 "${GOODTOGO} Checking $python :")
        VENV_FOUND=0
        VIRTUALENV_FOUND=0
        PIP_FOUND=0
        if [ "$($python -m venv -h 2>/dev/null | grep -i 'usage:')" ]; then
          (echo >&2 "  ${GOODTOGO} $python venv module is installed")
          VENV_FOUND=1
        else
          (echo >&2 "  ${ERROR} $python venv module not installed")
        fi

        if [ "$($python -m virtualenv -h 2>/dev/null | grep -i 'usage:')" ]; then
          (echo >&2 "  ${GOODTOGO} $python virtualenv module is installed")
          VIRTUALENV_FOUND=1
        else
          (echo >&2 "  ${ERROR} $python virtualenv module not installed")
        fi

        if [ "$($python -m pip -h 2>/dev/null | grep -i 'usage:')" ]; then
          (echo >&2 "  ${GOODTOGO} $python pip module is installed")
          PIP_FOUND=1
        else
          (echo >&2 "  ${ERROR} $python pip module not installed")
        fi

        if [[ $PIP_FOUND -eq 1 ]] && [[ $VENV_FOUND -eq 1 || $VIRTUALENV_FOUND -eq 1 ]]; then
          if [ "$VIRTUALENV_FOUND" -eq 1 ]; then
            (echo >&2 "  ${GOODTOGO} $python environment is available consider creating a venv : \"$python -m virtualenv .venv\", activate it with source .venv/bin/activate and relaunch the prepare script")
          else
            (echo >&2 "  ${GOODTOGO} $python environment is available consider creating a venv : \"$python -m venv .venv\", activate it with source .venv/bin/activate and relaunch the prepare script")
          fi
          INTERPRETER_FOUND=1
        fi
      done
    fi

    if [ "$INTERPRETER_FOUND" -eq 1 ]; then
      (echo >&2 "  ${ERROR} no available interpreter found, please install pip and venv")
    fi
}

check_ansible_env(){
  (echo >&2 "${GOODTOGO} Checking if python3 env is ansible ready :")
  ANSIBLE_CORE_CHECK=$(python3 -m pip --disable-pip-version-check list|grep -c ansible-core)
  if [ "$ANSIBLE_CORE_CHECK" -eq 1 ]; then
    ANSIBLE_VERSION=$(python3 -m pip --disable-pip-version-check list|grep ansible-core|cut -d ' ' -f 2-|sed -e 's/ //g' )
    REQUIRED_VERSION="2.12.6"
    if [ "$(printf '%s\n' "$REQUIRED_VERSION" "$ANSIBLE_VERSION" | sort -V | head -n1)" = "$REQUIRED_VERSION" ]; then
      (echo >&2 "  ${GOODTOGO} ansible-core $ANSIBLE_VERSION  is supported")
    else
      (echo >&2 "  ${ERROR} $ANSIBLE_VERSION  is not supported consider doing :")
      echo "        python3 -m pip install ansible-core==2.12.6"
    fi
  else
    (echo >&2 "  ${ERROR} ansible-core is not installed consider doing :")
    echo "        python3 -m pip install ansible-core==2.12.6"
  fi

  PYWINRM_CHECK=$(python3 -m pip --disable-pip-version-check list |grep -c pywinrm )
  if [ "$PYWINRM_CHECK" -eq 1 ]; then
    (echo >&2 "  ${GOODTOGO} pywinrm is installed")
  else
    (echo >&2 "  ${ERROR} pywinrm  is not install consider doing :")
    echo "        python3 -m pip install pywinrm"
    exit 1
  fi

  if ! which ansible >/dev/null; then
    (echo >&2 "${ERROR} ansible was not found in your PATH abort")
    exit 1
  else
    (echo >&2 "${GOODTOGO} ansible is installed")
  fi

  if ! which ansible-galaxy >/dev/null; then
    (echo >&2 "${ERROR} ansible-galaxy was not found in your PATH abort")
    exit 1
  else
    (echo >&2 "${GOODTOGO} ansible-galaxy is installed")
  fi

  GALAXY_COLLECTION=$(ansible-galaxy collection list)
  ANSIBLE_COLLECTION_EXPECTED="community.windows community.general ansible.windows"
  GALAXY_OK=1
  for collection in $ANSIBLE_COLLECTION_EXPECTED; do
    if [ $(echo $GALAXY_COLLECTION|grep -c $collection) -eq 1 ]; then
      (echo >&2 "  ${GOODTOGO} ansible-galaxy collection $collection installed")
    else
      (echo >&2 "  ${ERROR} ansible-galaxy collection $collection not installed")
      GALAXY_OK=0
    fi
  done
  if [ $GALAXY_OK -eq 0 ]; then
    (echo >&2 "${ERROR} ansible-galaxy requirements missing consider doing : ansible-galaxy install -r ansible/requirements.yml")
    exit 1
  else
    (echo >&2 "${GOODTOGO} ansible-galaxy requirements ok")
  fi
}

# Check available disk space. Recommend 120GB free, warn if less.
check_disk_free_space() {
  FREE_DISK_SPACE=$(df -m "$HOME" | tr -s ' ' | grep '/' | cut -d ' ' -f 4)
  if [ "$FREE_DISK_SPACE" -lt 120000 ]; then
    (echo >&2 "${INFO} Warning: You appear to have less than 120GB of HDD space free on your primary partition. If you are using a separate parition, you may ignore this warning.\n")
  else
    (echo >&2 "${GOODTOGO} You have more than 120GB of free space on your primary partition")
  fi
}

check_ram_space() {
  RAM_SPACE=$(free|tr -s ' '|grep Mem|cut -d ' ' -f 2)
  if [ "$RAM_SPACE" -lt 24000000 ]; then
    (echo >&2 "${INFO} Warning: You appear to have less than 24GB of RAM on your disk, you should consider running only a part of the lab.\n")
  else
    (echo >&2 "${GOODTOGO} You have more than 24GB of ram")
  fi
}

main() {
  # Get location of prepare.sh
  # https://stackoverflow.com/questions/59895/getting-the-source-directory-of-a-bash-script-from-within
  VAGRANT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  case $PROVIDER in
    "proxmox")
      (echo >&2 "[+] Enumerating proxmox")
      check_packer_path
      check_terraform_path
      case $ANSIBLE_HOST in
        "local")
          check_python_env
          ;;
        *)
          ;;
      esac
      ;;
    *)
      print_usage
      ;;
  esac
}

main 
exit 0