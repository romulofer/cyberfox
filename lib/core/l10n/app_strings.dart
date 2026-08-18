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

  // Form — Phases section
  final String sectionPhases;
  final String fieldPhaseName;
  final String hintPhaseName;
  final String fieldPhaseDescription;
  final String hintPhaseDescription;
  final String fieldPhaseTask;
  final String hintPhaseTask;
  final String addPhase;

  // Form — Acceptance Criteria section
  final String sectionAcceptanceCriteria;
  final String fieldCriterion;
  final String hintCriterion;

  // Form — What To Do section
  final String sectionWhatToDo;
  final String fieldGuideline;
  final String hintGuideline;

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

  // Settings page — language
  final String settingsTitle;
  final String settingsLanguage;
  final String languagePtBR;
  final String languageEn;

  // Settings page — theme
  final String settingsTheme;
  final String themeSystem;
  final String themeLight;
  final String themeDark;

  // Section templates
  final String templatesLabel;
  final String templateApply;
  final String templateNamePlaceholder;
  final String templateSave;
  final String templateDelete;
  final String templateEmpty;
  final String templatesManageTitle;
  final String templatesManageIntro;
  final String templateNew;
  final String templateEdit;
  final String templateSection;
  final String templateCancel;
  final String templateApplyLabel;
  final String templateExport;
  final String templateImport;

  // Generated markdown headings
  final String mdProjectOverview;
  final String mdTechStack;
  final String mdTechCategory;
  final String mdTechTechnology;
  final String mdTechVersionNotes;
  final String mdSetupCommands;
  final String mdSetupCommand;
  final String mdSetupDescription;
  final String mdCoreFeatures;
  final String mdPhases;
  final String mdPhaseLabel;
  final String mdAcceptanceCriteria;
  final String mdWhatToDo;
  final String mdWhatNotToDo;
  final String mdDocumentationReferences;

  // Settings page — custom agents
  final String sectionCustomAgents;
  final String fieldAgentName;
  final String hintAgentName;
  final String fieldAgentFilename;
  final String hintAgentFilename;

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
    required this.sectionPhases,
    required this.fieldPhaseName,
    required this.hintPhaseName,
    required this.fieldPhaseDescription,
    required this.hintPhaseDescription,
    required this.fieldPhaseTask,
    required this.hintPhaseTask,
    required this.addPhase,
    required this.sectionAcceptanceCriteria,
    required this.fieldCriterion,
    required this.hintCriterion,
    required this.sectionWhatToDo,
    required this.fieldGuideline,
    required this.hintGuideline,
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
    required this.settingsTheme,
    required this.themeSystem,
    required this.themeLight,
    required this.themeDark,
    required this.templatesLabel,
    required this.templateApply,
    required this.templateNamePlaceholder,
    required this.templateSave,
    required this.templateDelete,
    required this.templateEmpty,
    required this.templatesManageTitle,
    required this.templatesManageIntro,
    required this.templateNew,
    required this.templateEdit,
    required this.templateSection,
    required this.templateCancel,
    required this.templateApplyLabel,
    required this.templateExport,
    required this.templateImport,
    required this.mdProjectOverview,
    required this.mdTechStack,
    required this.mdTechCategory,
    required this.mdTechTechnology,
    required this.mdTechVersionNotes,
    required this.mdSetupCommands,
    required this.mdSetupCommand,
    required this.mdSetupDescription,
    required this.mdCoreFeatures,
    required this.mdPhases,
    required this.mdPhaseLabel,
    required this.mdAcceptanceCriteria,
    required this.mdWhatToDo,
    required this.mdWhatNotToDo,
    required this.mdDocumentationReferences,
    required this.sectionCustomAgents,
    required this.fieldAgentName,
    required this.hintAgentName,
    required this.fieldAgentFilename,
    required this.hintAgentFilename,
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
    sectionPhases: 'Fases do Projeto',
    fieldPhaseName: 'Nome da fase',
    hintPhaseName: 'MVP, Beta, Lançamento…',
    fieldPhaseDescription: 'Descrição da fase',
    hintPhaseDescription: 'Objetivo desta fase',
    fieldPhaseTask: 'Tarefa',
    hintPhaseTask: 'Configurar CI',
    addPhase: 'Adicionar fase',
    sectionAcceptanceCriteria: 'Critérios de Aceite',
    fieldCriterion: 'Critério',
    hintCriterion: 'Testes de integração passando',
    sectionWhatToDo: 'O Que Fazer',
    fieldGuideline: 'Diretriz',
    hintGuideline: 'Sempre validar entrada do usuário',
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
    settingsTheme: 'Tema',
    themeSystem: 'Sistema',
    themeLight: 'Claro',
    themeDark: 'Escuro',
    templatesLabel: 'Templates',
    templateApply: 'Aplicar',
    templateNamePlaceholder: 'Nome do template',
    templateSave: 'Salvar template',
    templateDelete: 'Excluir template',
    templateEmpty: 'Nenhum template salvo',
    templatesManageTitle: 'Gerenciar Templates',
    templatesManageIntro:
        'Crie, edite e apague templates de seção reutilizáveis. Aplique-os no formulário do projeto.',
    templateNew: 'Novo template',
    templateEdit: 'Editar',
    templateSection: 'Seção',
    templateCancel: 'Cancelar',
    templateApplyLabel: 'Aplicar template',
    templateExport: 'Exportar backup',
    templateImport: 'Importar backup',
    mdProjectOverview: 'Visão Geral do Projeto',
    mdTechStack: 'Tech Stack',
    mdTechCategory: 'Categoria',
    mdTechTechnology: 'Tecnologia',
    mdTechVersionNotes: 'Versão / Notas',
    mdSetupCommands: 'Comandos de Setup',
    mdSetupCommand: 'Comando',
    mdSetupDescription: 'Descrição',
    mdCoreFeatures: 'Funcionalidades Principais',
    mdPhases: 'Fases do Projeto',
    mdPhaseLabel: 'Fase',
    mdAcceptanceCriteria: 'Critérios de Aceite',
    mdWhatToDo: 'O Que Fazer',
    mdWhatNotToDo: 'O Que Não Fazer',
    mdDocumentationReferences: 'Documentações de Referência',
    sectionCustomAgents: 'Agentes Personalizados',
    fieldAgentName: 'Nome do agente',
    hintAgentName: 'Meu Agente',
    fieldAgentFilename: 'Nome do arquivo',
    hintAgentFilename: 'MEUAGENTE.md',
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
    sectionPhases: 'Project Phases',
    fieldPhaseName: 'Phase name',
    hintPhaseName: 'MVP, Beta, Launch…',
    fieldPhaseDescription: 'Phase description',
    hintPhaseDescription: 'Goal of this phase',
    fieldPhaseTask: 'Task',
    hintPhaseTask: 'Set up CI',
    addPhase: 'Add phase',
    sectionAcceptanceCriteria: 'Acceptance Criteria',
    fieldCriterion: 'Criterion',
    hintCriterion: 'Integration tests passing',
    sectionWhatToDo: 'What To Do',
    fieldGuideline: 'Guideline',
    hintGuideline: 'Always validate user input',
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
    settingsTheme: 'Theme',
    themeSystem: 'System',
    themeLight: 'Light',
    themeDark: 'Dark',
    templatesLabel: 'Templates',
    templateApply: 'Apply',
    templateNamePlaceholder: 'Template name',
    templateSave: 'Save template',
    templateDelete: 'Delete template',
    templateEmpty: 'No saved templates',
    templatesManageTitle: 'Manage Templates',
    templatesManageIntro:
        'Create, edit and delete reusable section templates. Apply them from the project form.',
    templateNew: 'New template',
    templateEdit: 'Edit',
    templateSection: 'Section',
    templateCancel: 'Cancel',
    templateApplyLabel: 'Apply template',
    templateExport: 'Export backup',
    templateImport: 'Import backup',
    mdProjectOverview: 'Project Overview',
    mdTechStack: 'Tech Stack',
    mdTechCategory: 'Category',
    mdTechTechnology: 'Technology',
    mdTechVersionNotes: 'Version / Notes',
    mdSetupCommands: 'Setup Commands',
    mdSetupCommand: 'Command',
    mdSetupDescription: 'Description',
    mdCoreFeatures: 'Core Features',
    mdPhases: 'Project Phases',
    mdPhaseLabel: 'Phase',
    mdAcceptanceCriteria: 'Acceptance Criteria',
    mdWhatToDo: 'What To Do',
    mdWhatNotToDo: 'What Not To Do',
    mdDocumentationReferences: 'Documentation References',
    sectionCustomAgents: 'Custom Agents',
    fieldAgentName: 'Agent name',
    hintAgentName: 'My Agent',
    fieldAgentFilename: 'Filename',
    hintAgentFilename: 'MYAGENT.md',
  );
}
