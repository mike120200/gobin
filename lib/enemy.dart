import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:zombie/Bullet.dart';
import 'package:zombie/game.dart';
import 'package:zombie/hero.dart';

enum enemyState { running, attack, dead } //敌人的不同状态

//僵尸的基类
class enemy extends SpriteAnimationGroupComponent
    with HasGameRef<RouterGame>, CollisionCallbacks {
  late int EnemyHealth;
  late int EnemyNumber; //哪一种僵尸
  final int Aggressivity;
  final int RunFrame;
  final int AttackFrame;
  final int DeadFrame;
  final AudioPool Pool;
  late final SpriteAnimation runningAnimation; //跑步动画
  late final SpriteAnimation attackAnimation; //攻击动画
  late final SpriteAnimation deadAnimation; //死亡动画
  late final SpriteAnimationGroupComponent<enemyState> character; //僵尸图
  final hero shot; //用于追踪玩家的位置
  late double MoveSpeed = 0.25;
  bool attacked = false;
  bool Left = true; //判断是否人物向着左边
  final ShapeHitbox CloseEnemy;
  enemy(
      {required super.position,
      required this.Pool,
      required this.shot,
      required this.EnemyHealth,
      required this.EnemyNumber,
      required this.Aggressivity,
      required this.AttackFrame,
      required this.DeadFrame,
      required this.RunFrame,
      required super.size,
      required this.MoveSpeed,
      required this.CloseEnemy})
      : super(anchor: Anchor.center);
//碰撞后触发的效果
  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    if (other is hero) {
      character.current = enemyState.attack;
    }
    if (other is Bullet) {
      hit();
      other.removeFromParent();
      EnemyHealth -= other.Aggressivity;
    }
    super.onCollisionStart(intersectionPoints, other);
  }

//碰撞结束触发的效果
  @override
  void onCollisionEnd(PositionComponent other) {
    if (!CloseEnemy.isColliding) character.current = enemyState.running;
    super.onCollisionEnd(other);
  }

//加载每个状态对应的精灵图
  loadSpriteAnimation(String s, int i, {double time = 0.1}) {
    final animation = SpriteAnimation.fromFrameData(
      game.images.fromCache(s),
      SpriteAnimationData.sequenced(
        amount: i,
        textureSize: size,
        stepTime: time,
      ),
    );
    return animation;
  }

//受到伤害后触发的效果
  void hit() {
    if (!attacked) {
      attacked = true;
      MoveSpeed -= 0.1;
    }
    character.add(OpacityEffect.fadeOut(
      EffectController(
        alternate: true,
        duration: 0.1,
        repeatCount: 3,
      ),
    )..onComplete = () {
        attacked = false;
        MoveSpeed = 0.25;
      });
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    game.EnemyCount++;
    runningAnimation =
        await loadSpriteAnimation('enemy${EnemyNumber}_Run.png', RunFrame);
    attackAnimation = await loadSpriteAnimation(
        'enemy${EnemyNumber}_Attack.png', AttackFrame);
    deadAnimation = await loadSpriteAnimation(
        'enemy${EnemyNumber}_Dead.png', DeadFrame,
        time: 0.5);
    character = SpriteAnimationGroupComponent<enemyState>(
      animations: {
        enemyState.running: runningAnimation,
        enemyState.attack: attackAnimation,
        enemyState.dead: deadAnimation
      },
      current: enemyState.running,
    );
    character.animationTickers?[enemyState.attack]?.onFrame = (index) {
      if (index == 3) {
        game.UserHealth -= Aggressivity;
      }
    };
    character.animationTickers?[enemyState.running]?.onFrame = (index) {
      if (index == 1) if (game.IsMusicOpen) Pool.start();
    };
    character.animationTickers?[enemyState.dead]?.onFrame = (index) {
      if (index == 1) game.EnemyCount--;
    };
    add(CloseEnemy);
    add(character);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (EnemyHealth <= 0) {
      //检测怪物生命值
      character.current = enemyState.dead;
      Future.delayed(Duration(milliseconds: 500), () {
        removeFromParent();
      });
    }
    position.x = position.x.clamp(20, 1530); //限制僵尸移动范围
    position.y = position.y.clamp(560, 650);
    //跟随玩家走
    Vector2 direction = shot.position - position - Vector2(0, -16);
    if (!(character.current == enemyState.attack)) {
      if (direction.x > 0) {
        if (!Left) {
          flipHorizontally();
          Left = true;
        }
      } else if (direction.x < 0) {
        if (Left) {
          flipHorizontally();
          Left = false;
        }
      }
    }
    direction.normalize();
    position += direction * MoveSpeed;
  }
}
