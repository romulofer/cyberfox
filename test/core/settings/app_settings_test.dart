import 'package:cyberfox/core/models/ai_target.dart';
import 'package:cyberfox/core/settings/app_settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppSettings', () {
    late AppSettings settings;

    setUp(() => settings = AppSettings());
    tearDown(() => settings.dispose());

    // ── language ────────────────────────────────────────────────────────────

    group('language', () {
      test('defaults to ptBR', () {
        expect(settings.language, AppLanguage.ptBR);
      });

      test('setLanguage updates the language', () {
        settings.setLanguage(AppLanguage.en);
        expect(settings.language, AppLanguage.en);
      });

      test('setLanguage notifies listeners', () {
        var count = 0;
        settings.addListener(() => count++);
        settings.setLanguage(AppLanguage.en);
        expect(count, 1);
      });

      test('setLanguage with the same value does not notify', () {
        var count = 0;
        settings.addListener(() => count++);
        settings.setLanguage(AppLanguage.ptBR); // already ptBR
        expect(count, 0);
      });

      test('strings returns ptBR instance when language is ptBR', () {
        expect(settings.strings.mdProjectOverview, 'Visão Geral do Projeto');
      });

      test('strings returns en instance after switching to en', () {
        settings.setLanguage(AppLanguage.en);
        expect(settings.strings.mdProjectOverview, 'Project Overview');
      });
    });

    // ── custom agents ───────────────────────────────────────────────────────

    group('custom agents', () {
      const agentA = AiTarget(name: 'My Agent', filename: 'MY.md');
      const agentB = AiTarget(name: 'Other Agent', filename: 'OTHER.md');

      test('customAgents is empty on creation', () {
        expect(settings.customAgents, isEmpty);
      });

      test('addCustomAgent adds the agent to customAgents', () {
        settings.addCustomAgent(agentA);
        expect(settings.customAgents, contains(agentA));
      });

      test('addCustomAgent notifies listeners', () {
        var count = 0;
        settings.addListener(() => count++);
        settings.addCustomAgent(agentA);
        expect(count, 1);
      });

      test('multiple agents are preserved in insertion order', () {
        settings.addCustomAgent(agentA);
        settings.addCustomAgent(agentB);
        expect(settings.customAgents[0], agentA);
        expect(settings.customAgents[1], agentB);
      });

      test('removeCustomAgent removes the agent', () {
        settings.addCustomAgent(agentA);
        settings.removeCustomAgent(agentA);
        expect(settings.customAgents, isEmpty);
      });

      test('removeCustomAgent notifies listeners', () {
        settings.addCustomAgent(agentA);
        var count = 0;
        settings.addListener(() => count++);
        settings.removeCustomAgent(agentA);
        expect(count, 1);
      });

      test('removeCustomAgent only removes the target agent', () {
        settings.addCustomAgent(agentA);
        settings.addCustomAgent(agentB);
        settings.removeCustomAgent(agentA);
        expect(settings.customAgents, isNot(contains(agentA)));
        expect(settings.customAgents, contains(agentB));
      });

      test('customAgents list is unmodifiable', () {
        expect(() => settings.customAgents.add(agentA), throwsUnsupportedError);
      });
    });

    // ── allAgents ───────────────────────────────────────────────────────────

    group('allAgents', () {
      const custom = AiTarget(name: 'Custom', filename: 'CUSTOM.md');

      test('contains all built-in agents', () {
        expect(settings.allAgents, containsAll(aiTargets));
      });

      test('has the same length as built-ins when no custom agents added', () {
        expect(settings.allAgents.length, aiTargets.length);
      });

      test('includes custom agents after adding', () {
        settings.addCustomAgent(custom);
        expect(settings.allAgents, contains(custom));
      });

      test('custom agents appear after built-ins', () {
        settings.addCustomAgent(custom);
        final all = settings.allAgents;
        final lastBuiltInIndex = all.indexOf(aiTargets.last);
        final customIndex = all.indexOf(custom);
        expect(customIndex, greaterThan(lastBuiltInIndex));
      });

      test('length equals built-ins plus custom agents count', () {
        settings.addCustomAgent(custom);
        expect(settings.allAgents.length, aiTargets.length + 1);
      });
    });
  });
}
