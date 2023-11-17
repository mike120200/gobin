import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:zombie/game.dart';

class VictoryPage extends Component
    with TapCallbacks, HasGameReference<RouterGame> {
  VictoryPage();
  @override
  Future<void> onLoad() async {
    add(
      TextComponent(
        text: 'Victory',
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
    );
    if (game.TheaterNumber != 8)
      add(TextComponent(
          text: 'Click anywhere to next level',
          anchor: Anchor.center,
          position: game.canvasSize / 2 - Vector2(0, 80)));
    else
      add(TextComponent(
          text:
              'You have passed all levels,please click anywhere to go back home',
          anchor: Anchor.center,
          position: game.canvasSize / 2 - Vector2(0, 80)));
  }

  @override
  bool containsLocalPoint(Vector2 point) => true; //整个页面所有地方点击都会被当初触发点

  @override
  void onTapUp(TapUpEvent event) {
    if (game.TheaterNumber != 8) {
      game.router.pushReplacementNamed("Theater${game.TheaterNumber}");
      game.overlays.remove('BackHome');
      game.overlays.add('Pause');
    } else {
      game.router.pushReplacementNamed("home");
      game.overlays.remove('BackHome');
    }
  }
}
