import '../engine/rule_modifier.dart';

/// Passed as the match route argument to launch a **sandbox** game: a normal
/// solo match (vs the AI, classic 3×4 board) but with a set of [RuleModifier]s
/// active, so any power/joker can be tried by hand. Debug-only for now.
class SandboxConfig {
  const SandboxConfig(this.modifiers);

  final List<RuleModifier> modifiers;
}
