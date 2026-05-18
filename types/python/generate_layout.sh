#!/usr/bin/env bash
# Gerador de layout Zellij para projetos Python
# Todos os painéis ativam o ambiente conda do projeto automaticamente
#
# Args: $1=nome $2=dir $3=shells

PROJECT_NAME="$1"
PROJECT_DIR="$2"
SHELLS="$3"

CONDA_INIT="source ~/miniforge3/etc/profile.d/conda.sh && conda activate $PROJECT_NAME"

cat <<EOF
// Layout gerado por new-project
// Projeto: $PROJECT_NAME | Tipo: python | Shells: $SHELLS
//
// Para personalizar, edite: $PROJECT_DIR/.zellij.kdl

layout {
EOF

if [ "$SHELLS" -eq 1 ]; then
  cat <<EOF
    pane cwd="$PROJECT_DIR" {
        name "main"
        focus true
        command "bash"
        args "-lc" "cd $PROJECT_DIR && $CONDA_INIT && zsh"
    }
EOF

elif [ "$SHELLS" -eq 2 ]; then
  cat <<EOF
    pane split_direction="vertical" {
        pane cwd="$PROJECT_DIR" {
            name "main"
            focus true
            command "bash"
            args "-lc" "cd $PROJECT_DIR && $CONDA_INIT && zsh"
        }
        pane cwd="$PROJECT_DIR" {
            name "shell-2"
            command "bash"
            args "-lc" "cd $PROJECT_DIR && $CONDA_INIT && zsh"
        }
    }
EOF

elif [ "$SHELLS" -eq 3 ]; then
  cat <<EOF
    pane split_direction="vertical" {
        pane cwd="$PROJECT_DIR" {
            name "main"
            focus true
            command "bash"
            args "-lc" "cd $PROJECT_DIR && $CONDA_INIT && zsh"
        }
        pane cwd="$PROJECT_DIR" {
            name "shell-2"
            command "bash"
            args "-lc" "cd $PROJECT_DIR && $CONDA_INIT && zsh"
        }
    }
    pane cwd="$PROJECT_DIR" {
        name "shell-3"
        command "bash"
        args "-lc" "cd $PROJECT_DIR && $CONDA_INIT && zsh"
    }
EOF

else
  # 4+ shells: grade 2x2 (ou mais)
  cat <<EOF
    pane split_direction="vertical" {
        pane cwd="$PROJECT_DIR" {
            name "main"
            focus true
            command "bash"
            args "-lc" "cd $PROJECT_DIR && $CONDA_INIT && zsh"
        }
        pane cwd="$PROJECT_DIR" {
            name "shell-2"
            command "bash"
            args "-lc" "cd $PROJECT_DIR && $CONDA_INIT && zsh"
        }
    }
    pane split_direction="vertical" {
        pane cwd="$PROJECT_DIR" {
            name "shell-3"
            command "bash"
            args "-lc" "cd $PROJECT_DIR && $CONDA_INIT && zsh"
        }
        pane cwd="$PROJECT_DIR" {
            name "shell-4"
            command "bash"
            args "-lc" "cd $PROJECT_DIR && $CONDA_INIT && zsh"
        }
    }
EOF
  # shells 5, 6... adiciona mais painéis abaixo
  for ((i=5; i<=SHELLS; i++)); do
    cat <<EOF
    pane cwd="$PROJECT_DIR" {
        name "shell-$i"
        command "bash"
        args "-lc" "cd $PROJECT_DIR && $CONDA_INIT && zsh"
    }
EOF
  done
fi

echo "}"
