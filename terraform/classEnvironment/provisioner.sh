#!/usr/bin/env bash

ERROR=$(tput setaf 1; echo -n "[!]"; tput sgr0)
OK=$(tput setaf 2; echo -n "[✓]"; tput sgr0)
INFO=$(tput setaf 3; echo -n "[-]"; tput sgr0)

# Global variables
LAB=
PROVIDER="proxmox"
METHOD=
JOB=
PROVIDERS="proxmox"
LABS="bytekingdom-light"
SIEM="SIEM"
TASKS="check install start stop status restart destroy disablevagrant enablevagrant"
ANSIBLE_PLAYBOOKS="edr.yml build.yml ad-servers.yml ad-parent_domain.yml ad-child_domain.yml ad-members.yml ad-trusts.yml ad-data.yml ad-gmsa.yml laps.yml ad-relations.yml adcs.yml ad-acl.yml servers.yml security.yml vulnerabilities.yml reboot.yml elk.yml sccm-install.yml sccm-config.yml monitoring.yml wazuh-agent.yml"
METHODS="local"
ANSIBLE_ONLY=0
ANSIBLE_PLAYBOOK=
GOAD_VAGRANT_OPTIONS=
GOAD_EXTENSIONS="elk"

print_usage() {
  echo "${ERROR} Usage: ./goad.sh -t task -l lab -p provider -m method"
  echo "${INFO} -t : task must be one of the following:"
  echo "   - check   : verify dependencies";
  echo "   - install : create the lab";
  echo "   - start   : start the lab";
  echo "   - stop    : stop the lab";
  echo "   - restart : reload the lab";
  echo "   - status  : show lab info and status";
  echo "   - destroy : trash the lab";
  echo "${INFO} -l : lab must be one of the following:"
  for lab in $LABS;  do
    echo "   - $lab";
  done
  echo "${INFO} -p : provider must be one of the following:"
  for p in $PROVIDERS;  do
    echo "   - $p";
  done
  echo "${INFO} -m : method must be one of the following (optional, default : local):"
  echo "   - local : to use local ansible install (default)";
  echo "   - docker : to use docker ansible install";
  echo "${INFO} -a : to run only ansible on install (optional)";
  echo "${INFO} -r : to run only one ansible playbook (optional)";
  echo "   - example : vulnerabilities.yml";
  echo "${INFO} -e : to activate extension (separated by coma) (optional)";
  for extension in $GOAD_EXTENSIONS;  do
    echo "   - $extension";
  done
  echo "${INFO} -h : show this help";
  echo
  echo "${OK} example: ./provisioner.sh -t check -l GOAD -p virtualbox -m local";
  exit 0
}

function exists_in_list() {
    LIST=$1
    VALUE=$2
    echo $LIST | tr " " '\n' | grep -F -q -x "$VALUE"
}

while getopts t:l:p:m:ar:e:h flag
  do
      case "${flag}" in
          t) TASK=${OPTARG};;
          l) LAB=${OPTARG};;
          p) PROVIDER=${OPTARG};;
          m) METHOD=${OPTARG};;
          a) ANSIBLE_ONLY=1;;
          r) ANSIBLE_PLAYBOOK=${OPTARG};;
          e) GOAD_VAGRANT_OPTIONS="$GOAD_VAGRANT_OPTIONS,${OPTARG}";;
          h) print_usage; exit;
      esac
  done

  if exists_in_list "$TASKS" "$TASK"; then
    echo "${OK} Task: $TASK"
  else
    echo "${ERROR} Task: \"$TASK\" unknow"
    print_usage
  fi

  if exists_in_list "$LABS" "$LAB"; then
    echo "${OK} Lab: $LAB"
  else
    echo "${ERROR} Lab: $LAB not allowed"
    print_usage
  fi

  if exists_in_list "$PROVIDERS" "$PROVIDER"; then
    echo "${OK} Provider: $PROVIDER"
  else
    echo "${ERROR} Provider: $PROVIDER not allowed"
    print_usage
  fi

  # loop on every extension
  for GOAD_EXT in $(echo $GOAD_VAGRANT_OPTIONS | sed "s/,/ /g")
  do
      if exists_in_list "$GOAD_EXTENSIONS" "$GOAD_EXT"; then
        echo "${OK} Extension: $GOAD_EXT"
      else
        echo "${ERROR} Extension: $GOAD_EXT not allowed"
        print_usage
      fi
  done

  if [ -z $METHOD ]; then
     METHOD="local"
  else
    if exists_in_list "$METHODS" "$METHOD"; then
      echo "${OK} Method: $METHOD"
    else
      echo "${ERROR} Method: $METHOD not allowed"
      print_usage
    fi
  fi
  if [[ ! -z $ANSIBLE_PLAYBOOK ]]; then
     if exists_in_list "$ANSIBLE_PLAYBOOKS" "$ANSIBLE_PLAYBOOK"; then
      echo "${OK} Ansible playbook: $ANSIBLE_PLAYBOOK"
    else
      echo "${ERROR} Ansible playbook: $ANSIBLE_PLAYBOOK not allowed"
      print_usage
    fi
  fi

  if [[ "$ANSIBLE_ONLY" -eq 1 ]]; then
    echo "${OK} Run ansible only"
  fi

# check if the lab provider folder exist
if [[ -d "$LAB" ]]; then
   echo "${OK} folder $LAB found"
else
   echo "${ERROR} folder $LAB not found"
   exit 1
fi

install_providing(){
  folders=("$@")

  for folder in "${folders[@]}"; do
    if [ -d "$folder" ]; then
      cd "$folder"
      echo "${OK} Initializing Terraform in $folder..."
      terraform init

      result=$?
      if [ ! $result -eq 0 ]; then
        echo "${ERROR} terraform init in $folder finished with error, aborting"
        exit 1
      fi

      echo "${OK} Applying Terraform in $folder..."
      terraform apply -auto-approve
      result=$?
      if [ ! $result -eq 0 ]; then
        echo "${ERROR} terraform apply in $folder finished with error, aborting"
        exit 1
      fi

      echo "${OK} Ready to launch provisioning in $folder"
      cd -
    else
      echo "${ERROR} folder $folder not found"
      exit 1
    fi
  done
}


install_provisioning(){
  lab=$1
  provider=$2
  method=$3
  case $provider in
    "proxmox")
        case $method in
          "local")
              if [ -z $ANSIBLE_PLAYBOOK ]; then
              echo "${OK} Launching ansible playbook: $lab"
                cd $lab/ansible
                export LAB=$lab PROVIDER=$provider
                echo "${OK1} Sleeping 4ms to let the VMs boot"
                #sleep 240           
                ./provisioning.sh
                
              else
                cd $lab/ansible
                echo "${OK1} Sleeping 4ms to let the VMs boot"
                #sleep 240
                ansible-playbook -i ../data/inventory -i ../inventory $ANSIBLE_PLAYBOOK
                cd -
              fi
            ;;
        esac
      ;;
  esac
}

install(){
  echo "${OK} Launch installation for: $LAB / $PROVIDER / $METHOD"
  cd $CURRENT_DIR
  #install_providing $SIEM
  if [[ "$ANSIBLE_ONLY" -eq 0 ]]; then
    install_providing $LAB
  fi
  cd $CURRENT_DIR
  install_provisioning $LAB $PROVIDER $METHOD
}

check(){
  echo "${OK} Launch check : ./scripts/check.sh $PROVIDER $METHOD"
  ./scripts/check.sh $PROVIDER $METHOD
  check_result=$?
  if [ $check_result -eq 0 ]; then
    echo "${OK} Check is ok, you can start the installation"
  else
    echo "${ERROR} Check is not ok, please fix the errors and retry"
    echo "${INFO} You could also run the setup script"
  fi
}

start(){
  case $PROVIDER in
    "proxmox")
      if ! which qm >/dev/null; then
        (echo >&2 "${ERROR} qm not found in your PATH")
        exit 1
      else
        if [ -d "$LAB" ]; then
          vms=$(cat $LAB/*.tf| grep -E 'name = ".*"'|cut -d '"' -f 2)
          for vm in "${vms[@]}"
          do
            id=$(qm list | grep $vm  | awk '{print $1}')
            echo "[+] VM id : $id"
            echo "[+] Starting $vm"
            qm start "$id"
          done
        else
          echo "${ERROR} folder $LAB not found"
          exit 1
        fi
      fi
      ;;
  esac
}

stop(){
  case $PROVIDER in
    "proxmox")
      if ! which qm >/dev/null; then
        (echo >&2 "${ERROR} qm not found in your PATH")
        exit 1
      else
        if [ -d "$LAB" ]; then
          vms=$(cat $LAB/*.tf| grep -E 'name = ".*"'|cut -d '"' -f 2)
          for vm in "${vms[@]}"
          do
            id=$(qm list | grep $vm  | awk '{print $1}')
            echo "[+] VM id : $id"
            echo "[+] Stopping $vm"
            qm stop "$id" && qm wait "$id"
          done
        else
          echo "${ERROR} folder $LAB not found"
          exit 1
        fi
      fi
      ;;
  esac
}

restart(){
  case $PROVIDER in
    "proxmox")
      if ! which qm >/dev/null; then
        (echo >&2 "${ERROR} qm not found in your PATH")
        exit 1
      else
        if [ -d "$LAB" ]; then
          vms=$(cat $LAB/*.tf| grep -E 'name = ".*"'|cut -d '"' -f 2)
          for vm in "${vms[@]}"
          do
            id=$(qm list | grep $vm  | awk '{print $1}')
            echo "[+] VM id is : $id"
            echo "[+] Stopping $vm"
            qm stop "$id" && qm wait "$id"
            echo "[+] Starting $vm"
            qm start "$id"
          done
        else
          echo "${ERROR} folder $LAB not found"
          exit 1
        fi
      fi
      ;;
  esac
}

destroy(){
  folders=("$SIEM" "$LAB")

  for folder in "${folders[@]}"; do
    if [ -d "$folder" ]; then
      cd "$folder"
      echo "${OK} Destroying infrastructure in $folder..."
      terraform destroy -auto-approve

      result=$?
      if [ ! $result -eq 0 ]; then
        echo "${ERROR} terraform destroy in $folder finished with error, aborting"
        exit 1
      fi

      echo "${OK} Infrastructure destroyed in $folder"
      cd -
    else
      echo "${ERROR} folder $folder not found"
      exit 1
    fi
  done
}

status(){
  case $PROVIDER in
    "virtualbox"|"vmware")
          cd "$LAB"
          GOAD_VAGRANT_OPTIONS=$GOAD_VAGRANT_OPTIONS vagrant status
          cd -
      ;;
    "proxmox")
      if ! which qm >/dev/null; then
        (echo >&2 "${ERROR} qm not found in your PATH")
        exit 1
      else
        if [ -d "$LAB" ]; then
          vms=$(cat $LAB/*.tf| grep -E 'name = ".*"'|cut -d '"' -f 2)
          for vm in "${vms[@]}"
          do
            qm list | grep $vm
          done
        else
          echo "${ERROR} folder $LAB not found"
          exit 1
        fi
      fi
      ;;
  esac
}

snapshot() {
  # TODO : snapshot
  echo "not implemeneted"
}

reset() {
  # TODO : reset to last snapshot
  echo "not implemeneted"
}

main() {
  CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  cd $CURRENT_DIR
  case $TASK in
    check)
      check
      ;;
    install)
      install
      ;;
    status)
      status
      ;;
    start)
      start
      ;;
    stop)
      stop
      ;;
    restart)
      restart
      ;;
    destroy)
      destroy
      ;;
    snapshot)
      snapshot
      ;;
    disablevagrant)
      disablevagrant
      ;;
    enablevagrant)
      enablevagrant
      ;;
    *)
      echo "unknow option"
      ;;
  esac
}

main