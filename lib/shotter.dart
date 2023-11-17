import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:try1/loadall.dart';

enum RobotState { idle, running, shot }

class Shotactions extends SpriteAnimationGroupComponent
    with KeyboardHandler, CollisionCallbacks, HasGameRef<EmberQuestGame> {
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation shotAnimation;
  late final SpriteAnimation rechargeAnimation;
  late final SpriteAnimationGroupComponent<RobotState> robot;
  int count = 10;
  int horizontalDirection = 0;
  int verticalDirection = 0;
  final Vector2 velocity = Vector2.zero();
  final double moveSpeed = 50;
  Shotactions({
    required super.position,
  }) : super(size: Vector2(128, 128), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    runningAnimation = await loadSpriteAnimation('Run.png', 7);
    idleAnimation = await loadSpriteAnimation('Idle.png', 7);
    shotAnimation = await loadSpriteAnimation('Shot_2.png', 4);
    robot = SpriteAnimationGroupComponent<RobotState>(
      animations: {
        RobotState.running: runningAnimation,
        RobotState.idle: idleAnimation,
        RobotState.shot: shotAnimation
      },
      current: RobotState.idle,
    );

    add(robot);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (horizontalDirection < 0 && scale.x > 0) {
      flipHorizontally();
    } else if (horizontalDirection > 0 && scale.x < 0) {
      flipHorizontally();
    }
    velocity.x = horizontalDirection * moveSpeed;
    velocity.y = verticalDirection * moveSpeed;
    position += velocity * dt;
  }

  //键盘事件移动
  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalDirection = 0;
    verticalDirection = 0;
    if (event is RawKeyDownEvent) {
      if (keysPressed.contains(LogicalKeyboardKey.space) &&
          robot.current != RobotState.shot) {
        robot.current = RobotState.shot;
        count--;
        return true;
      }
      if (keysPressed.contains(LogicalKeyboardKey.keyA) ||
          keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
        horizontalDirection += -1;
        if (robot.current != RobotState.running) {
          robot.current = RobotState.running;
        }
      } else if (keysPressed.contains(LogicalKeyboardKey.keyD) ||
          keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
        horizontalDirection += 1;
        if (robot.current != RobotState.running) {
          robot.current = RobotState.running;
        }
      }
      if (keysPressed.contains(LogicalKeyboardKey.keyW) ||
          keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
        verticalDirection += -1;
        if (robot.current != RobotState.running) {
          robot.current = RobotState.running;
        }
      } else if (keysPressed.contains(LogicalKeyboardKey.keyS) ||
          keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
        verticalDirection += 1;
        if (robot.current != RobotState.running) {
          robot.current = RobotState.running;
        }
      }
    } else if (event is RawKeyUpEvent) {
      if (keysPressed.isNotEmpty) {
        if (keysPressed.contains(LogicalKeyboardKey.keyA) ||
            keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
          horizontalDirection += -1;
        } else if (keysPressed.contains(LogicalKeyboardKey.keyD) ||
            keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
          horizontalDirection += 1;
        }
        if (keysPressed.contains(LogicalKeyboardKey.keyW) ||
            keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
          verticalDirection += -1;
        } else if (keysPressed.contains(LogicalKeyboardKey.keyS) ||
            keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
          verticalDirection += 1;
        }
        if (robot.current != RobotState.running) {
          robot.current = RobotState.running;
        }
      } else if (robot.current != RobotState.idle) {
        robot.current = RobotState.idle;
      }
    }
    return true;
  }

  loadSpriteAnimation(String s, int i) {
    final animation = SpriteAnimation.fromFrameData(
      game.images.fromCache(s),
      SpriteAnimationData.sequenced(
        amount: i,
        textureSize: Vector2(128, 128),
        stepTime: 0.1,
      ),
    );
    return animation;
  }
}
