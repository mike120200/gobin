import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/services.dart';

import 'package:zombie/enemy.dart';
import 'package:zombie/game.dart';

enum heroState { idle, running, shot, recharge, dead } //玩家状态

class hero extends SpriteAnimationGroupComponent
    with KeyboardHandler, CollisionCallbacks, HasGameRef<RouterGame> {
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation shotAnimation;
  late final SpriteAnimation rechargeAnimation;
  late final SpriteAnimation deadAnimation;
  late final SpriteAnimationGroupComponent<heroState> character;
  final Vector2 velocity = Vector2.zero();
  final double moveSpeed = 35;

  bool HitByEnemy = false;
  bool IfRight = true;
  int count = 10;
  int UserHorizontalDirection = 0;
  int UserVerticalDirection = 0;

  ShapeHitbox CloseHero = PolygonHitbox(
      [Vector2(45, 85), Vector2(45, 108), Vector2(83, 108), Vector2(83, 85)])
    ..isSolid = true;

  hero({
    required super.position,
  }) : super(size: Vector2(128, 128), anchor: Anchor.center);

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (CloseHero.isColliding &&
        other is enemy &&
        other.character.current == enemyState.attack) hit();

    super.onCollision(intersectionPoints, other);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    UserHorizontalDirection = 0;
    UserVerticalDirection = 0;

    if (event is RawKeyDownEvent && character.current != heroState.dead) {
      //换弹
      if (keysPressed.contains(LogicalKeyboardKey.keyZ)) {
        if (game.IsMusicOpen) game.Pool8.start();
        character.current = heroState.recharge;
      }
      //攻击
      if (keysPressed.contains(LogicalKeyboardKey.space) &&
          game.RemainingBullet > 0 &&
          character.current != heroState.recharge) {
        if (character.current != heroState.shot)
          character.current = heroState.shot;
        return true;
      }
      //上下左右移动站立
      if (keysPressed.contains(LogicalKeyboardKey.arrowLeft) &&
          !keysPressed.contains(LogicalKeyboardKey.space) &&
          character.current != heroState.recharge) {
        UserHorizontalDirection += -1;
        if (character.current != heroState.running) {
          character.current = heroState.running;
        }
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight) &&
          !keysPressed.contains(LogicalKeyboardKey.space) &&
          character.current != heroState.recharge) {
        UserHorizontalDirection += 1;
        if (character.current != heroState.running) {
          character.current = heroState.running;
        }
      }
      if (keysPressed.contains(LogicalKeyboardKey.arrowUp) &&
          !keysPressed.contains(LogicalKeyboardKey.space) &&
          character.current != heroState.recharge) {
        UserVerticalDirection += -1;
        if (character.current != heroState.running) {
          character.current = heroState.running;
        }
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowDown) &&
          character.current != heroState.recharge &&
          !keysPressed.contains(LogicalKeyboardKey.space)) {
        UserVerticalDirection += 1;
        if (character.current != heroState.running) {
          character.current = heroState.running;
        }
      }
    } else if (event is RawKeyUpEvent && character.current != heroState.dead) {
      if (keysPressed.isNotEmpty) {
        if (keysPressed.contains(LogicalKeyboardKey.arrowLeft) &&
            !keysPressed.contains(LogicalKeyboardKey.space) &&
            character.current != heroState.recharge) {
          UserHorizontalDirection += -1;
        } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight) &&
            !keysPressed.contains(LogicalKeyboardKey.space) &&
            character.current != heroState.recharge) {
          UserHorizontalDirection += 1;
        }
        if (keysPressed.contains(LogicalKeyboardKey.arrowUp) &&
            !keysPressed.contains(LogicalKeyboardKey.space) &&
            character.current != heroState.recharge) {
          UserVerticalDirection += -1;
        } else if (keysPressed.contains(LogicalKeyboardKey.arrowDown) &&
            !keysPressed.contains(LogicalKeyboardKey.space) &&
            character.current != heroState.recharge) {
          UserVerticalDirection += 1;
        }
        if (character.current != heroState.running &&
            !keysPressed.contains(LogicalKeyboardKey.space) &&
            character.current != heroState.recharge) {
          character.current = heroState.running;
        }
      } else if (character.current != heroState.idle &&
          !keysPressed.contains(LogicalKeyboardKey.space) &&
          character.current != heroState.recharge) {
        character.current = heroState.idle;
      }
    }

    return true;
  }

//加载人物动画
  loadSpriteAnimation(String s, int i, bool IfLoop, {double time = 0.1}) {
    final animation = SpriteAnimation.fromFrameData(
      game.images.fromCache(s),
      SpriteAnimationData.sequenced(
          amount: i,
          textureSize: Vector2(128, 128),
          stepTime: time,
          loop: IfLoop),
    );
    return animation;
  }

//人物受到伤害后触发的
  void hit() {
    if (character.current != heroState.dead) {
      if (!HitByEnemy) {
        HitByEnemy = true;
      }
      character.add(OpacityEffect.fadeOut(
        EffectController(
          alternate: true,
          duration: 0.1,
          repeatCount: 5,
        ),
      )..onComplete = () {
          HitByEnemy = false;
        });
    }
  }

  @override
  Future<void> onLoad() async {
    runningAnimation = await loadSpriteAnimation(
        'character${game.HeroNumber}_Run.png', game.RunFrame, true);
    idleAnimation = await loadSpriteAnimation(
        'character${game.HeroNumber}_Idle.png', 6, true);
    shotAnimation = await loadSpriteAnimation(
        'character${game.HeroNumber}_shot.png', 4, true);
    deadAnimation = await loadSpriteAnimation(
        'character${game.HeroNumber}_Dead.png', 4, false,
        time: 2);
    rechargeAnimation = await loadSpriteAnimation(
        'character${game.HeroNumber}_Recharge.png', game.RechargeFrame, true,
        time: 0.2);
    character = SpriteAnimationGroupComponent<heroState>(
      animations: {
        heroState.running: runningAnimation,
        heroState.idle: idleAnimation,
        heroState.shot: shotAnimation,
        heroState.recharge: rechargeAnimation,
        heroState.dead: deadAnimation
      },
      current: heroState.idle,
    );

    //换弹进行到倒数第二帧的操作的操作
    character.animationTickers?[heroState.recharge]?.onFrame = (index) {
      if (index == game.RechargeFrame - 1) {
        character.current = heroState.idle;
        if (game.Hero1Bullet != 0)
          game.RemainingBullet = game.Hero1Bullet;
        else if (game.Hero2Bullet != 0)
          game.RemainingBullet = game.Hero2Bullet;
        else if (game.Hero3Bullet != 0) game.RemainingBullet = game.Hero3Bullet;
      }
    };
    //射击进行到第一帧的操作
    character.animationTickers?[heroState.shot]?.onFrame = (index) {
      if (index == 1) {
        if (game.IsMusicOpen) game.HeroPool.start();
        game.RemainingBullet--;
      }
    };

    add(CloseHero);
    add(character);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (game.UserHealth == 0) {
      //检测玩家生命值
      character.current = heroState.dead;
    }
    if (game.RemainingBullet <= 0) {
      //检测玩家子弹数量

      if (character.current != heroState.recharge) {
        character.current = heroState.recharge;
      }
    }
    position.x = position.x.clamp(20, 1530); //限制玩家范围
    position.y = position.y.clamp(560, 650);
    //玩家左右方向转变
    if (UserHorizontalDirection < 0 && scale.x > 0) {
      flipHorizontally();
      IfRight = false;
    } else if (UserHorizontalDirection > 0 && scale.x < 0) {
      flipHorizontally();
      IfRight = true;
    }
    velocity.x = UserHorizontalDirection * moveSpeed;
    velocity.y = UserVerticalDirection * moveSpeed;
    position += velocity * dt;
  }
}
