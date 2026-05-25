class AppStrings {
  // General
  final String saving;
  final String add;
  final String Function(String filename) saveFileLabel;
  final String Function(String path) savedAt;
  final String Function(String error) saveError;
  final String chooseFolderTitle;
  final String previewPlaceholder;

  // Form — Project section
  final String sectionProject;
  final String fieldName;
  final String fieldDescription;
  final String fieldTargetAi;

  // Form — Tech Stack section
  final String sectionTechStack;
  final String fieldCategory;
  final String hintCategory;
  final String fieldTechnology;
  final String hintTechnology;
  final String fieldVersionNotes;
  final String hintVersionNotes;

  // Form — Setup Commands section
  final String sectionSetupCommands;
  final String fieldCommand;
  final String hintCommand;
  final String fieldCommandDescription;
  final String hintCommandDescription;

  // Form — Core Features section
  final String sectionCoreFeatures;
  final String fieldFeature;
  final String hintFeature;

  // Form — Acceptance Criteria section
  final String sectionAcceptanceCriteria;
  final String fieldCriterion;
  final String hintCriterion;

  // Form — What Not To Do section
  final String sectionWhatNotToDo;
  final String fieldProhibition;
  final String hintProhibition;

  // Form — Documentation References section
  final String sectionDocRefs;
  final String fieldDocTitle;
  final String fieldDocUrl;
  final String fieldDocDescriptionOptional;

  // Clear entries dialog
  final String clearDialogTitle;
  final String clearDialogContent;
  final String clearDialogConfirm;
  final String clearDialogCancel;

  // Settings page
  final String settingsTitle;
  final String settingsLanguage;
  final String languagePtBR;
  final String languageEn;

  AppStrings._({
    required this.saving,
    required this.add,
    required this.saveFileLabel,
    required this.savedAt,
    required this.saveError,
    required this.chooseFolderTitle,
    required this.previewPlaceholder,
    required this.sectionProject,
    required this.fieldName,
    required this.fieldDescription,
    required this.fieldTargetAi,
    required this.sectionTechStack,
    required this.fieldCategory,
    required this.hintCategory,
    required this.fieldTechnology,
    required this.hintTechnology,
    required this.fieldVersionNotes,
    required this.hintVersionNotes,
    required this.sectionSetupCommands,
    required this.fieldCommand,
    required this.hintCommand,
    required this.fieldCommandDescription,
    required this.hintCommandDescription,
    required this.sectionCoreFeatures,
    required this.fieldFeature,
    required this.hintFeature,
    required this.sectionAcceptanceCriteria,
    required this.fieldCriterion,
    required this.hintCriterion,
    required this.sectionWhatNotToDo,
    required this.fieldProhibition,
    required this.hintProhibition,
    required this.sectionDocRefs,
    required this.fieldDocTitle,
    required this.fieldDocUrl,
    required this.fieldDocDescriptionOptional,
    required this.clearDialogTitle,
    required this.clearDialogContent,
    required this.clearDialogConfirm,
    required this.clearDialogCancel,
    required this.settingsTitle,
    required this.settingsLanguage,
    required this.languagePtBR,
    required this.languageEn,
  });

  static final ptBR = AppStrings._(
    saving: 'Salvando...',
    add: 'Adicionar',
    saveFileLabel: (f) => 'Salvar $f',
    savedAt: (path) => 'Salvo em $path',
    saveError: (e) => 'Erro ao salvar: $e',
    chooseFolderTitle: 'Escolher pasta para salvar',
    previewPlaceholder:
        'O preview aparecerá aqui conforme você preenche o formulário.',
    sectionProject: 'Projeto',
    fieldName: 'Nome',
    fieldDescription: 'Descrição',
    fieldTargetAi: 'Agente de IA alvo',
    sectionTechStack: 'Tech Stack',
    fieldCategory: 'Categoria',
    hintCategory: 'Frontend, Backend, Database…',
    fieldTechnology: 'Tecnologia',
    hintTechnology: 'Flutter, PostgreSQL…',
    fieldVersionNotes: 'Versão / Notas',
    hintVersionNotes: '3.10, gerenciado via Docker…',
    sectionSetupCommands: 'Comandos de Setup',
    fieldCommand: 'Comando',
    hintCommand: 'flutter pub get',
    fieldCommandDescription: 'Descrição',
    hintCommandDescription: 'Instalar dependências',
    sectionCoreFeatures: 'Funcionalidades Principais',
    fieldFeature: 'Funcionalidade',
    hintFeature: 'Autenticação com JWT',
    sectionAcceptanceCriteria: 'Critérios de Aceite',
    fieldCriterion: 'Critério',
    hintCriterion: 'Testes de integração passando',
    sectionWhatNotToDo: 'O Que Não Fazer',
    fieldProhibition: 'Proibição / Anti-padrão',
    hintProhibition: 'Nunca commitar secrets',
    sectionDocRefs: 'Documentações de Referência',
    fieldDocTitle: 'Título',
    fieldDocUrl: 'URL',
    fieldDocDescriptionOptional: 'Descrição (opcional)',
    clearDialogTitle: 'Limpar entradas?',
    clearDialogContent:
        'Deseja limpar todos os campos para começar um novo arquivo?',
    clearDialogConfirm: 'Limpar',
    clearDialogCancel: 'Manter',
    settingsTitle: 'Configurações',
    settingsLanguage: 'Idioma',
    languagePtBR: 'Português (Brasil)',
    languageEn: 'English',
  );

  static final en = AppStrings._(
    saving: 'Saving...',
    add: 'Add',
    saveFileLabel: (f) => 'Save $f',
    savedAt: (path) => 'Saved to $path',
    saveError: (e) => 'Error saving: $e',
    chooseFolderTitle: 'Choose folder to save',
    previewPlaceholder:
        'The preview will appear here as you fill in the form.',
    sectionProject: 'Project',
    fieldName: 'Name',
    fieldDescription: 'Description',
    fieldTargetAi: 'Target AI Agent',
    sectionTechStack: 'Tech Stack',
    fieldCategory: 'Category',
    hintCategory: 'Frontend, Backend, Database…',
    fieldTechnology: 'Technology',
    hintTechnology: 'Flutter, PostgreSQL…',
    fieldVersionNotes: 'Version / Notes',
    hintVersionNotes: '3.10, managed via Docker…',
    sectionSetupCommands: 'Setup Commands',
    fieldCommand: 'Command',
    hintCommand: 'flutter pub get',
    fieldCommandDescription: 'Description',
    hintCommandDescription: 'Install dependencies',
    sectionCoreFeatures: 'Core Features',
    fieldFeature: 'Feature',
    hintFeature: 'JWT Authentication',
    sectionAcceptanceCriteria: 'Acceptance Criteria',
    fieldCriterion: 'Criterion',
    hintCriterion: 'Integration tests passing',
    sectionWhatNotToDo: 'What Not To Do',
    fieldProhibition: 'Prohibition / Anti-pattern',
    hintProhibition: 'Never commit secrets',
    sectionDocRefs: 'Documentation References',
    fieldDocTitle: 'Title',
    fieldDocUrl: 'URL',
    fieldDocDescriptionOptional: 'Description (optional)',
    clearDialogTitle: 'Clear entries?',
    clearDialogContent:
        'Do you want to clear all fields to start a new file?',
    clearDialogConfirm: 'Clear',
    clearDialogCancel: 'Keep',
    settingsTitle: 'Settings',
    settingsLanguage: 'Language',
    languagePtBR: 'Português (Brasil)',
    languageEn: 'English',
  );
}
