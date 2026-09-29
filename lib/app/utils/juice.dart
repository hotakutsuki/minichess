import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../modules/home/controllers/home_controller.dart';

/// Small "juice" helpers: one-shot sound effects + haptics for the match.
///
/// SFX respect the in-game sound toggle. The capture/victory clips currently
/// reuse `button.mp3` as placeholders — drop dedicated `assets/sounds/capture.mp3`
/// and `assets/sounds/victory.mp3` in and swap the asset paths below.
final AudioPlayer _sfxPlayer = AudioPlayer();

bool get _soundOn => Get.find<HomeController>().withSound.value;

void _sfx(String asset, double volume) {
  if (_soundOn) {
    _sfxPlayer.play(AssetSource(asset), volume: volume);
  }
}

class Juice {
  /// Picking up / selecting a piece.
  static void select() => HapticFeedback.selectionClick();

  /// A normal (non-capturing) move landed.
  static void move() => HapticFeedback.lightImpact();

  /// A piece was captured.
  static void capture() {
    HapticFeedback.mediumImpact();
    _sfx('sounds/button.mp3', 0.8); // TODO: dedicated capture SFX
  }

  /// The match ended (someone took the king).
  static void gameOver() {
    HapticFeedback.heavyImpact();
    _sfx('sounds/button.mp3', 1.0); // TODO: dedicated victory sting
  }
}
