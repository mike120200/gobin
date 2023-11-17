import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import './loadall.dart';

void main() {
  runApp(
    const GameWidget<EmberQuestGame>.controlled(
      gameFactory: EmberQuestGame.new,
    ),
  );
}
