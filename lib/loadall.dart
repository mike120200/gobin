import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:try1/shotter.dart';

class EmberQuestGame extends FlameGame with HasKeyboardHandlerComponents {
  EmberQuestGame();

  final world = World();
  late final CameraComponent cameraComponent;
  late Shotactions shot;
  @override
  Future<void> onLoad() async {
    await images.loadAll(["Run.png", "Idle.png", "Shot_2.png"]);
    cameraComponent = CameraComponent(world: world);
    cameraComponent.viewfinder.anchor = Anchor.topLeft;
    addAll([cameraComponent, world]);
    shot = Shotactions(
      position: Vector2(300, canvasSize.y - 500),
    );
    world.add(shot);
  }

  Color backgroundColor() {
    return Color.fromARGB(250, 230, 236, 241);
  }
}
