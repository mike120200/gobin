import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//控制进行下一步、暂停、更新、恢复、维持状态
final gameControllerProvider =
    StateNotifierProvider<_GameController, _GameState>(
  (ref) => _GameController(),
);

@immutable
class _GameState {
  const _GameState({this.game, this.paused = false});

  final Game? game;
  final bool paused;
//创建副本，防止游戏状态改变
  _GameState copyWith({
    Game? game,
    bool? paused,
  }) {
    return _GameState(
      game: game ?? this.game,
      paused: paused ?? this.paused,
    );
  }

  @override //对比两个游戏状态是否相等
  bool operator ==(Object other) =>
      other is _GameState && game == other.game && paused == other.paused;

  @override
  int get hashCode => Object.hash(game, paused); //为对象生成哈希代码,比较是否相等
}

class _GameController extends StateNotifier<_GameState> {
  _GameController() : super(const _GameState()) {
    //确保flutter所需组件资源在其他操作之前就被初始化
    WidgetsFlutterBinding.ensureInitialized();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final game = _findGame();
      useGame(game);
    });
  }

  bool get isPaused => state.paused;

  void useGame(Game? game) {
    state = state.copyWith(game: game);
  }

  void pauseGame() {
    state.game!.pauseEngine();
    state = state.copyWith(paused: true);
  }

  void resumeGame() {
    state.game!.resumeEngine();
    state = state.copyWith(paused: false);
  }

  void stepGame() {
    state.game!.stepEngine();
  }

  static Game? _findGame() {
    Game? game;
    void visitor(Element element) {
      //遍历所有属于GameWidget的组件，是的话就修改它的状态
      if (element.widget is GameWidget) {
        final dynamic state = (element as StatefulElement).state;
        // ignore: avoid_dynamic_calls
        game = state.currentGame as Game;
      } else {
        element.visitChildElements(visitor);
      }
    }

    WidgetsBinding.instance.rootElement?.visitChildElements(visitor);
    return game;
  }
}
