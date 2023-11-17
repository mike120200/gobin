// import 'dart:ui';

// import 'package:flame/collisions.dart';
// import 'package:flame/components.dart';
// import 'package:flutter/painting.dart';
// import 'package:flutter/services.dart';

// import './loadall.dart';

// enum playerState {
//   idle,
//   running,
// }

// class EmberPlayer extends SpriteAnimationGroupComponent
//     with KeyboardHandler, CollisionCallbacks, HasGameRef<EmberQuestGame> {
//   int horizontalDirection = 0;
//   int verticalDirection = 0;
//   final Vector2 velocity = Vector2.zero();
//   final double moveSpeed = 50;
//   late final SpriteAnimation running;
//   late final SpriteAnimation idle;

//   EmberPlayer({
//     required super.position,
//   }) : super(size: Vector2(128, 128), anchor: Anchor.center);

//   @override
//   void update(double dt) {
//     super.update(dt);
//     velocity.x = horizontalDirection * moveSpeed;
//     velocity.y = verticalDirection * moveSpeed;
//     position += velocity * dt;
//     if (horizontalDirection < 0 && scale.x > 0) {
//       flipHorizontally();
//     } else if (horizontalDirection > 0 && scale.x < 0) {
//       flipHorizontally();
//     }
//   }

// // 键盘事件移动
//   @override
//   bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
//     horizontalDirection = 0;
//     verticalDirection = 0;
//     if (keysPressed.contains(LogicalKeyboardKey.keyA) ||
//         keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
//       horizontalDirection += -1;
//     }
//     if (keysPressed.contains(LogicalKeyboardKey.keyD) ||
//         keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
//       horizontalDirection += 1;
//     }
//     if (keysPressed.contains(LogicalKeyboardKey.keyW) ||
//         keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
//       verticalDirection += -1;
//     }
//     if (keysPressed.contains(LogicalKeyboardKey.keyS) ||
//         keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
//       verticalDirection += 1;
//     }

//     return true;
//   }

// //动作切换
//   SpriteAnimation loadSpriteAnimation(String photoname) {
//     final animation = SpriteAnimation.fromFrameData(
//       game.images.fromCache(photoname),
//       SpriteAnimationData.sequenced(
//         amount: 8,
//         textureSize: Vector2(128, 128),
//         stepTime: 0.1,
//       ),
//     );
//     return animation;
//   }

//   Future<void> onload() async {
//     animation = loadSpriteAnimation('Idle.png');
//   }
// }
