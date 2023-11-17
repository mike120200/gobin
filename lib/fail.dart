import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:zombie/game.dart';

class FailPage extends Component
    with TapCallbacks, HasGameReference<RouterGame> {
  FailPage();
  @override
  Future<void> onLoad() async {
    addAll([
      TextComponent(
        text: 'Fail',
        position: game.canvasSize / 2,
        anchor: Anchor.center,
        children: [
          ScaleEffect.to(
            //放大缩小的效果
            Vector2.all(1.1),
            EffectController(
              duration: 0.3,
              alternate: true,
              infinite: true,
            ),
          ),
        ],
      ),
      TextComponent(
          text: 'Click anywhere to restart',
          anchor: Anchor.center,
          position: game.canvasSize / 2 - Vector2(0, 80))
    ]);
  }

  @override
  bool containsLocalPoint(Vector2 point) => true; //整个页面所有地方点击都会被当初触发点

  @override
  void onTapUp(TapUpEvent event) {
    game.router.pushReplacementNamed("Theater${game.TheaterNumber}");
    game.overlays.remove('BackHome');
    game.overlays.add('Pause');
  }
}
