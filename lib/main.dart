import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zombie/game.dart';
import 'package:zombie/level.dart';
import './Button.dart';

void main() {
  runApp(ProviderScope(
      child: GameWidget<RouterGame>.controlled(
          gameFactory: RouterGame.new,
          overlayBuilderMap: {
        'BackHome': (_, game) => MyBackButton(game: game),
        'BackHomePop': (_, game) => MyBackButton(game: game, IfPop: true),
        'level': (_, game) => LevelChoice(game: game),
        'Pause': (_, game) => PauseButton(game: game),
        'Music1': (_, game) => OpenOrCloseMusic(
              MusicName: 'BattleTheme1.mp3',
              game: game,
            ),
        'Music2': (_, game) =>
            OpenOrCloseMusic(MusicName: 'BattleTheme2.mp3', game: game),
        'Music3': (_, game) =>
            OpenOrCloseMusic(MusicName: 'BattleTheme3.mp3', game: game),
        'Music4': (_, game) =>
            OpenOrCloseMusic(MusicName: 'BattleTheme4.mp3', game: game)
      })));
}
