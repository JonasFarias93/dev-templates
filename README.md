# dev-templates

> Coleção de templates de projeto com estrutura, dependências e layout de terminal prontos — usado pelo script `new-project` dos [dotfiles](https://github.com/JonasFarias93/dotfiles).

---

## Por que este repositório existe

Iniciar um projeto novo sempre envolve as mesmas tarefas repetitivas: criar a estrutura de pastas, configurar o ambiente virtual, montar o `.gitignore`, abrir o terminal dividido do jeito certo para aquele tipo de projeto. Com o tempo, eu começava a copiar de projetos anteriores — o que funciona, mas não escala e não documenta nada.

Este repositório centraliza esses blueprints. Cada tipo de projeto tem seu próprio template com tudo que precisa para sair do zero ao ambiente configurado em segundos. E como o template é um arquivo de texto versionado, dá para melhorá-lo com o tempo e essas melhorias se aplicam a todos os projetos futuros.

---

## Como usar

O ponto de entrada é o script `new-project`, instalado pelos [dotfiles](https://github.com/JonasFarias93/dotfiles) e disponível globalmente no terminal.

```bash
new-project <nome> <tipo> [número-de-shells]
```

**Exemplos:**

```bash
new-project minha-api python-django 4
# Cria ~/projects/minha-api com estrutura Django,
# ambiente conda e layout Zellij 2x2

new-project estudo-redes linuxlab 3
# Cria ~/projects/estudo-redes com layout Zellij
# de 2 painéis SSH (vm1, vm2) + 1 painel local

new-project app-analise python 2
# Cria ~/projects/app-analise com Python puro
# e 2 shells lado a lado
```

**Para abrir o projeto no Zellij:**

```bash
zellij --layout nome-do-projeto
```

---

## O que o `new-project` faz

1. **Valida** os argumentos e verifica se o tipo existe
2. **Cria** a pasta `~/projects/nome-do-projeto/`
3. **Copia** os arquivos do template escolhido (environment.yml, .gitignore, etc.)
4. **Substitui** o placeholder `{{PROJECT_NAME}}` pelo nome real do projeto em todos os arquivos
5. **Gera** o layout Zellij dinamicamente (via `generate_layout.sh` do tipo) com o número de shells pedido
6. **Linka** o layout em `~/.config/zellij/layouts/nome-do-projeto.kdl`
7. **Inicializa** o repositório git com um commit inicial

---

## Tipos disponíveis

### `python`

Python puro com ambiente conda.

```bash
new-project meu-script python 2
```

Inclui:
- `environment.yml` com Python 3.11, pytest e pytest-watch
- `.gitignore` para projetos Python
- Layout Zellij com N shells, todos ativando o ambiente conda automaticamente

Ideal para: scripts, automações, CLIs, análise de dados, estudos.

---

### `python-django`

Django com estrutura pensada para desenvolvimento web.

```bash
new-project minha-api python-django 4
```

Inclui:
- `environment.yml` com Django, pytest-django, pytest-watch e python-dotenv
- `.gitignore` para projetos Python/Django
- Layout Zellij com painéis nomeados: **main**, **testes (ptw)**, **servidor**, **livre** — igual ao workflow de desenvolvimento real

Com 4 shells, o layout fica assim:

```
┌─────────────────────┬─────────────────────┐
│                     │                     │
│        main         │    testes (ptw)     │
│   (git, navegação)  │   (pytest-watch)    │
│                     │                     │
├─────────────────────┼─────────────────────┤
│                     │                     │
│      servidor       │       livre         │
│   (runserver)       │  (make, manage...)  │
│                     │                     │
└─────────────────────┴─────────────────────┘
```

Todos os painéis abrem já no diretório do projeto com o ambiente conda ativado.

---

### `linuxlab`

Ambiente para estudo de Linux e administração de sistemas com VMs Vagrant.

```bash
new-project estudo-redes linuxlab 3
```

O ambiente consiste em duas máquinas virtuais criadas pelo Vagrant no VirtualBox (Windows), acessadas via SSH pelo WSL.

Com 3 shells, o layout fica:

```
┌─────────────────────┬─────────────────────┐
│                     │                     │
│        vm1          │        vm2          │
│    (SSH → VM 1)     │    (SSH → VM 2)     │
│                     │                     │
├─────────────────────┴─────────────────────┤
│                                           │
│              local (vagrant)              │
│     (vagrant up, status, ssh, etc.)       │
│                                           │
└───────────────────────────────────────────┘
```

> **Importante:** edite o `generate_layout.sh` do linuxlab com os IPs reais das suas VMs antes de usar.

---

## Estrutura do repositório

```
dev-templates/
├── README.md
└── types/
    ├── python/
    │   ├── environment.yml       # Dependências conda
    │   ├── .gitignore            # Arquivos ignorados pelo git
    │   └── generate_layout.sh   # Gerador do layout Zellij
    │
    ├── python-django/
    │   ├── environment.yml
    │   └── generate_layout.sh
    │
    ├── linuxlab/
    │   └── generate_layout.sh
    │
    └── python-flet/             # Em construção
```

---

## Como o `generate_layout.sh` funciona

Cada tipo de projeto tem um script `generate_layout.sh` que recebe três argumentos e imprime um arquivo `.kdl` (formato de config do Zellij) no stdout:

```bash
# Assinatura
bash generate_layout.sh <nome-do-projeto> <caminho-do-projeto> <número-de-shells>

# Exemplo (chamado internamente pelo new-project)
bash generate_layout.sh minha-api /home/jonas/projects/minha-api 4
```

O script adapta o layout conforme o número de shells:
- 1 shell → painel único
- 2 shells → dividido verticalmente
- 3 shells → 2 em cima, 1 embaixo
- 4+ shells → grade 2×2 (e mais painéis abaixo se necessário)

---

## Adicionando um novo tipo

```bash
# 1. Crie a pasta do tipo
mkdir types/meu-tipo

# 2. Adicione os arquivos base (copie de um tipo existente)
cp types/python/environment.yml types/meu-tipo/
cp types/python/.gitignore types/meu-tipo/
cp types/python/generate_layout.sh types/meu-tipo/

# 3. Adapte o generate_layout.sh para o novo tipo
vim types/meu-tipo/generate_layout.sh

# 4. Teste
new-project teste-novo meu-tipo 2
```

O `new-project` detecta automaticamente qualquer pasta dentro de `types/` como um tipo válido.

---

## Ajuste fino por projeto

O layout gerado fica salvo dentro do próprio projeto:

```
~/projects/meu-projeto/.zellij.kdl
```

Edite esse arquivo para personalizar o que roda em cada painel (comandos iniciais, nomes, tamanhos). As mudanças são refletidas na próxima vez que abrir o layout no Zellij.

---

## Roadmap

- [ ] `python-flet` — template para apps desktop com Flet
- [ ] `javascript` — template base com Node + NVM
- [ ] Suporte a arquivos base por tipo (ex: `settings.py` padrão para Django)
- [ ] Flag `--dry-run` no `new-project` para visualizar o que será criado antes de executar

---

## Relacionado

**[dotfiles](https://github.com/JonasFarias93/dotfiles)** — Ambiente WSL onde o `new-project` vive e de onde tudo parte
