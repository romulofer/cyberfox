[English](#english) · [Português (Brasil)](#português-brasil)

---

# English

## Cyberfox

A desktop-first Flutter application for generating markdown context files for AI coding agents.

Instead of writing project context files by hand for each AI tool, Cyberfox lets you fill in a structured form and instantly preview the generated markdown. Save the file directly into your project with the exact filename each agent expects.

### Features

- **Live split-pane preview** — markdown updates in real-time as you type, no generate button required
- **7 supported AI agents** — each with its canonical output filename
- **Tech Stack table** — category, technology and version/notes columns
- **Setup Commands** — command + description, rendered as a table
- **Core Features** — bullet list of main functionalities
- **Acceptance Criteria** — bullet list of done conditions
- **What Not To Do** — bullet list of prohibitions and anti-patterns
- **Documentation References** — title, URL and optional description
- **Bilingual UI** — English and Português (Brasil), switchable at runtime

### Supported AI Agents

| Agent | Output filename |
|---|---|
| Claude Code | `CLAUDE.md` |
| Cursor | `.cursorrules` |
| Windsurf | `.windsurfrules` |
| Cline | `.clinerules` |
| GitHub Copilot | `copilot-instructions.md` |
| Aider | `CONVENTIONS.md` |
| Devin | `AGENTS.md` |

### Requirements

- Flutter 3.x (beta channel)
- Dart 3.x
- Desktop target: Linux, macOS or Windows

### Getting Started

```bash
git clone <repository-url>
cd cyberfox
flutter pub get
flutter run -d linux     # or -d macos / -d windows
```

### How to Use

1. Fill in the **Project** section: name, description and target AI agent
2. Add entries to **Tech Stack**, **Setup Commands**, and the remaining sections as needed
3. Watch the **live preview** on the right panel update as you type
4. Click **Save \<filename\>** in the toolbar, choose a folder, and the file is written with the correct name for your selected agent
5. To change the UI language, open **Settings** (gear icon in the top-right corner)

### Project Structure

```
lib/
├── core/
│   ├── generators/       # Markdown generation logic
│   ├── l10n/             # UI strings (EN / PT-BR)
│   ├── models/           # Data models (ProjectConfig, TechStackEntry, …)
│   ├── settings/         # AppSettings + InheritedNotifier scope
│   └── templates/        # Markdown template function
└── features/
    ├── home/             # Main split-pane screen
    └── settings/         # Language settings screen
```

### Dependencies

| Package | Purpose |
|---|---|
| `flutter_markdown` | Render markdown in the preview panel |
| `file_picker` | Native folder picker dialog for saving |

---

# Português (Brasil)

## Cyberfox

Aplicativo Flutter desktop-first para geração de arquivos markdown de contexto para agentes de IA.

Em vez de escrever manualmente arquivos de contexto para cada ferramenta de IA, o Cyberfox permite preencher um formulário estruturado e visualizar instantaneamente o markdown gerado. Salve o arquivo diretamente no seu projeto com o nome exato que cada agente espera.

### Funcionalidades

- **Preview em tempo real** — o markdown atualiza enquanto você digita, sem botão de gerar
- **7 agentes de IA suportados** — cada um com seu nome de arquivo canônico
- **Tabela de Tech Stack** — colunas de categoria, tecnologia e versão/notas
- **Comandos de Setup** — comando + descrição, renderizados como tabela
- **Funcionalidades Principais** — lista de bullet das principais funções
- **Critérios de Aceite** — lista de bullet das condições de conclusão
- **O Que Não Fazer** — lista de bullet de proibições e anti-padrões
- **Documentações de Referência** — título, URL e descrição opcional
- **Interface bilíngue** — Português (Brasil) e English, alternável em tempo de execução

### Agentes de IA Suportados

| Agente | Nome do arquivo gerado |
|---|---|
| Claude Code | `CLAUDE.md` |
| Cursor | `.cursorrules` |
| Windsurf | `.windsurfrules` |
| Cline | `.clinerules` |
| GitHub Copilot | `copilot-instructions.md` |
| Aider | `CONVENTIONS.md` |
| Devin | `AGENTS.md` |

### Requisitos

- Flutter 3.x (canal beta)
- Dart 3.x
- Desktop: Linux, macOS ou Windows

### Como Começar

```bash
git clone <url-do-repositório>
cd cyberfox
flutter pub get
flutter run -d linux     # ou -d macos / -d windows
```

### Como Usar

1. Preencha a seção **Projeto**: nome, descrição e agente de IA alvo
2. Adicione entradas em **Tech Stack**, **Comandos de Setup** e demais seções conforme necessário
3. Acompanhe o **preview em tempo real** no painel direito enquanto preenche
4. Clique em **Salvar \<nome-do-arquivo\>** na barra de ferramentas, escolha uma pasta e o arquivo é salvo com o nome correto para o agente selecionado
5. Para alterar o idioma da interface, abra **Configurações** (ícone de engrenagem no canto superior direito)

### Estrutura do Projeto

```
lib/
├── core/
│   ├── generators/       # Lógica de geração do markdown
│   ├── l10n/             # Strings da interface (EN / PT-BR)
│   ├── models/           # Modelos de dados (ProjectConfig, TechStackEntry, …)
│   ├── settings/         # AppSettings + escopo InheritedNotifier
│   └── templates/        # Função de template markdown
└── features/
    ├── home/             # Tela principal com layout dividido
    └── settings/         # Tela de configurações de idioma
```

### Dependências

| Pacote | Finalidade |
|---|---|
| `flutter_markdown` | Renderizar markdown no painel de preview |
| `file_picker` | Seletor nativo de pasta para salvar o arquivo |
