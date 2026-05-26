# Cyberfox

## Project Overview

Cyberfox is a desktop-first Flutter application that generates markdown context files for AI coding agents. Users fill in a structured form on the left panel; the right panel renders a live markdown preview. When satisfied, the user clicks Save and the file is written to disk with the exact filename each AI agent expects (e.g. `CLAUDE.md`, `.cursorrules`).

## Tech Stack

| Category | Technology | Version / Notes |
|----------|------------|-----------------|
| UI Framework | Flutter | 3.x beta channel |
| Language | Dart | ^3.13.0-103.1.beta |
| Markdown rendering | flutter_markdown | ^0.7.7+1 |
| Native folder picker | file_picker | ^10.1.9 |
| Desktop targets | Linux, macOS, Windows | primary targets; mobile not supported |

## Setup Commands

| Command | Description |
|---------|-------------|
| `flutter pub get` | Install dependencies |
| `flutter run -d linux` | Run on Linux desktop (substitute `macos` or `windows`) |
| `flutter analyze` | Static analysis |

## Project Structure

```
lib/
├── main.dart                      # App entry point; mounts AppSettingsScope + MaterialApp
├── core/
│   ├── generators/
│   │   └── markdown_generator.dart  # MarkdownGenerator.generate(ProjectConfig) → String
│   ├── l10n/
│   │   └── app_strings.dart         # AppStrings class with ptBR and en static instances
│   ├── models/
│   │   ├── ai_target.dart           # AiTarget(name, filename) + aiTargets list constant
│   │   ├── documentation_reference.dart
│   │   ├── project_config.dart      # Central data model aggregating all form fields
│   │   ├── setup_command.dart
│   │   └── tech_stack_entry.dart
│   ├── settings/
│   │   └── app_settings.dart        # AppSettings (ChangeNotifier) + AppSettingsScope (InheritedNotifier)
│   └── templates/
│       └── base_template.dart       # buildProjectTemplate(ProjectConfig) → String (actual markdown logic)
└── features/
    ├── home/
    │   └── home_page.dart           # Main screen: form panel + preview panel; all form state lives here
    └── settings/
        └── settings_page.dart       # Language switcher screen
```

## Core Features

- Live split-pane preview: markdown re-renders on every keystroke, no button required
- 7 supported AI agents, each mapped to its canonical output filename
- Tech Stack table (category / technology / version-notes)
- Setup Commands table (command / description)
- Core Features, Acceptance Criteria, and What Not To Do bullet lists
- Documentation References section (title, URL, optional description)
- Bilingual UI — English and Português (Brasil), switchable at runtime via Settings
- Native folder picker for saving the file; post-save dialog offers to clear all fields

## Supported AI Agents

| Agent | Output filename |
|-------|----------------|
| Claude Code | `CLAUDE.md` |
| Cursor | `.cursorrules` |
| Windsurf | `.windsurfrules` |
| Cline | `.clinerules` |
| GitHub Copilot | `copilot-instructions.md` |
| Aider | `CONVENTIONS.md` |
| Devin | `AGENTS.md` |

To add a new agent, append an `AiTarget` entry to the `aiTargets` list in `lib/core/models/ai_target.dart`. No other change is needed.

## Architecture Notes

- **State management**: `AppSettings` is a `ChangeNotifier` wrapped in `AppSettingsScope` (`InheritedNotifier`). Access it anywhere with `AppSettingsScope.of(context)` or `AppSettingsScope.stringsOf(context)`. Do not introduce a second state-management library.
- **Form state**: All mutable form state (`TextEditingController`s, lists) lives in `_HomePageState` inside `home_page.dart`. `setState` is used directly; no `Provider`/`Riverpod`/`Bloc`.
- **Markdown generation**: `MarkdownGenerator` is a thin wrapper around `buildProjectTemplate` in `base_template.dart`. If the output format must change, edit `base_template.dart`.
- **Localisation**: All user-visible strings go through `AppStrings`. Add new strings to both `ptBR` and `en` static instances simultaneously.
- **No router**: The app has two screens only. Navigation uses a plain `MaterialPageRoute` push from `HomePage` to `SettingsPage`.

## What Not To Do

- Do not add mobile (iOS/Android) targets; the layout assumes a wide desktop window.
- Do not introduce a third-party state management library; `InheritedNotifier` + `setState` is intentional.
- Do not hard-code user-visible strings outside `AppStrings`; always add entries to both locales.
- Do not add a "generate" button; the preview must remain live/reactive.
- Do not persist form state between sessions; the app is intentionally stateless on launch.
