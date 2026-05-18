#!/usr/bin/env bash
# Gerador de layout Zellij para projetos Python/Django
# Espelha o layout do exp360: main + testes (ptw) + servidor + shell livre
#
# Args: $1=nome $2=dir $3=shells

PROJECT_NAME="$1"
PROJECT_DIR="$2"
SHELLS="$3"

CONDA_INIT="source ~/miniforge3/etc/profile.d/conda.sh && conda activate $PROJECT_NAME"

cat <<EOF
// Layout gerado por new-project
// Projeto: $PROJECT_NAME | Tipo: python-django | Shells: $SHELLS
//
// Painéis sugeridos para Django:
//   shell-1: main (navegação, git)
//   shell-2: ptw (pytest-watch)
//   shell-3: runserver
//   shell-4: livre (make, manage, etc)
//
// Para personalizar, edite: $PROJECT_DIR/.zellij.kdl

layout {
EOF

if [ "$SHELLS" -le 2 ]; then
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
            name "testes (ptw)"
            command "bash"
            args "-lc" "cd $PROJECT_DIR && $CONDA_INIT && zsh"
        }
    }
    pane cwd="$PROJECT_DIR" {
        name "servidor"
        command "bash"
        args "-lc" "cd $PROJECT_DIR && $CONDA_INIT && zsh"
    }
EOF

else
  # 4+ shells — grade 2x2 igual ao exp360
  cat <<EOF
    pane split_direction="vertical" {
        pane cwd="$PROJECT_DIR" {
            name "main"
            focus true
            command "bash"
            args "-lc" "cd $PROJECT_DIR && $CONDA_INIT && zsh"
        }
        pane cwd="$PROJECT_DIR" {
            name "testes (ptw)"
            command "bash"
            args "-lc" "cd $PROJECT_DIR && $CONDA_INIT && zsh"
        }
    }
    pane split_direction="vertical" {
        pane cwd="$PROJECT_DIR" {
            name "servidor"
            command "bash"
            args "-lc" "cd $PROJECT_DIR && $CONDA_INIT && zsh"
        }
        pane cwd="$PROJECT_DIR" {
            name "livre"
            command "bash"
            args "-lc" "cd $PROJECT_DIR && $CONDA_INIT && zsh"
        }
    }
EOF
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
