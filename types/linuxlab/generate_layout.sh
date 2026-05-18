#!/usr/bin/env bash
# Gerador de layout Zellij para linuxlab
# Abre painéis com SSH direto nas VMs Vagrant
#
# Args: $1=nome $2=dir $3=shells
# Shells recomendado: 2 (uma VM por painel) ou 3 (+ painel de controle local)

PROJECT_NAME="$1"
PROJECT_DIR="$2"
SHELLS="$3"

# Ajuste os IPs/nomes conforme suas VMs no Vagrantfile
VM1_SSH="ssh vagrant@192.168.56.101"   # ajuste o IP da VM1
VM2_SSH="ssh vagrant@192.168.56.102"   # ajuste o IP da VM2
VAGRANT_DIR="/mnt/c/vagrant-labs/701-702"

cat <<EOF
// Layout gerado por new-project
// Projeto: $PROJECT_NAME | Tipo: linuxlab | Shells: $SHELLS
//
// Painéis:
//   vm1: SSH na máquina virtual 1
//   vm2: SSH na máquina virtual 2
//   local: shell WSL local (vagrant up, vagrant status, etc)
//
// IMPORTANTE: ajuste os IPs das VMs conforme seu Vagrantfile
// VM1: $VM1_SSH
// VM2: $VM2_SSH
//
// Para personalizar, edite: $PROJECT_DIR/.zellij.kdl

layout {
EOF

if [ "$SHELLS" -eq 1 ]; then
  cat <<EOF
    pane cwd="$VAGRANT_DIR" {
        name "vm1"
        focus true
        command "bash"
        args "-lc" "cd $VAGRANT_DIR && echo 'Conectar: $VM1_SSH' && zsh"
    }
EOF

elif [ "$SHELLS" -eq 2 ]; then
  cat <<EOF
    pane split_direction="vertical" {
        pane cwd="$VAGRANT_DIR" {
            name "vm1"
            focus true
            command "bash"
            args "-lc" "cd $VAGRANT_DIR && echo 'Conectar VM1: $VM1_SSH' && zsh"
        }
        pane cwd="$VAGRANT_DIR" {
            name "vm2"
            command "bash"
            args "-lc" "cd $VAGRANT_DIR && echo 'Conectar VM2: $VM2_SSH' && zsh"
        }
    }
EOF

else
  # 3+ shells: vm1, vm2 em cima; local embaixo
  cat <<EOF
    pane split_direction="vertical" {
        pane cwd="$VAGRANT_DIR" {
            name "vm1"
            focus true
            command "bash"
            args "-lc" "cd $VAGRANT_DIR && echo 'Conectar VM1: $VM1_SSH' && zsh"
        }
        pane cwd="$VAGRANT_DIR" {
            name "vm2"
            command "bash"
            args "-lc" "cd $VAGRANT_DIR && echo 'Conectar VM2: $VM2_SSH' && zsh"
        }
    }
    pane cwd="$VAGRANT_DIR" {
        name "local (vagrant)"
        command "bash"
        args "-lc" "cd $VAGRANT_DIR && echo 'vagrant up | vagrant status | vagrant ssh vm1' && zsh"
    }
EOF
  for ((i=4; i<=SHELLS; i++)); do
    cat <<EOF
    pane cwd="$VAGRANT_DIR" {
        name "shell-$i"
        command "bash"
        args "-lc" "cd $VAGRANT_DIR && zsh"
    }
EOF
  done
fi

echo "}"
