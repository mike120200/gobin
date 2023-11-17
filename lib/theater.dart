import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zombie/Bullet.dart';
import 'package:zombie/enemy.dart';
import 'package:zombie/game.dart';
import 'package:zombie/hero.dart';
import 'package:zombie/hud.dart';

class Theater extends Component
    with KeyboardHandler, HasGameReference<RouterGame>, HasCollisionDetection {
  Theater({
    required this.WarNumber,
  });
  List<Bullet> Bullets1 = []; //存放子弹碰撞箱的列表
  List<Bullet> Bullets2 = [];
  List<Bullet> Bullets3 = [];
  List<SpawnComponent> EnemyBox = [];
  late Sprite TheaterBackground;
  late hero user;
  late bool CreateWhatEnemy = true;
  late enemy zomble1;
  late Hud GameHud;
  final int WarNumber;
  @override
  void render(Canvas canvas) {
    // 渲染背景图片
    super.render(canvas);
    TheaterBackground.render(canvas,
        size: Vector2(game.size.x, game.size.y - 20));
  }

  void CreateEnemy() {
    if (game.CreateEnemyNumber1)
      Future.delayed(Duration(seconds: game.EnemyBox1Time), () {
        add(EnemyBox[0]);
      });
    if (game.CreateEnemyNumber2)
      Future.delayed(Duration(seconds: game.EnemyBox2Time), () {
        add(EnemyBox[1]);
      });
    if (game.CreateEnemyNumber3)
      Future.delayed(Duration(seconds: game.EnemyBox3Time), () {
        add(EnemyBox[2]);
      });
    if (game.CreateBossNumber1)
      Future.delayed(Duration(seconds: game.EnemyBoss1Time), () {
        add(
          enemy(
              Pool: game.Pool4,
              MoveSpeed: 0.45,
              CloseEnemy: PolygonHitbox([
                Vector2(0, 80),
                Vector2(0, 110),
                Vector2(128, 110),
                Vector2(128, 80)
              ])
                ..isSolid = true
                ..collisionType = CollisionType.passive
              //只攻击active的碰撞箱
              ,
              size: Vector2.all(128),
              RunFrame: 9,
              AttackFrame: 7,
              DeadFrame: 2,
              position: Vector2(1530, game.canvasSize.y - 100),
              shot: user,
              EnemyNumber: 4,
              EnemyHealth: 30,
              Aggressivity: 3),
        );
      });

    if (game.CreateBossNumber2)
      Future.delayed(Duration(seconds: game.EnemyBoss2Time), () {
        add(
          enemy(
              Pool: game.Pool4,
              CloseEnemy: PolygonHitbox([
                Vector2(0, 80),
                Vector2(0, 110),
                Vector2(128, 110),
                Vector2(128, 80)
              ])
                ..isSolid = true
                ..collisionType = CollisionType.passive, //只攻击active的碰撞箱
              MoveSpeed: 0.40,
              size: Vector2.all(128),
              position: Vector2(1530, game.canvasSize.y - 200),
              RunFrame: 9,
              AttackFrame: 7,
              DeadFrame: 2,
              shot: user,
              EnemyNumber: 5,
              EnemyHealth: 30,
              Aggressivity: 5),
        );
      });

    if (game.CreateBossNumber3)
      Future.delayed(Duration(seconds: game.EnemyBoss3Time), () {
        add(
          enemy(
              Pool: game.Pool4,
              CloseEnemy: PolygonHitbox([
                Vector2(0, 80),
                Vector2(0, 110),
                Vector2(128, 110),
                Vector2(128, 80)
              ])
                ..isSolid = true
                ..collisionType = CollisionType.passive, //只攻击active的碰撞箱
              MoveSpeed: 0.5,
              size: Vector2.all(128),
              RunFrame: 9,
              AttackFrame: 7,
              DeadFrame: 2,
              position: Vector2(1530, game.canvasSize.y - 300),
              shot: user,
              EnemyNumber: 6,
              EnemyHealth: 50,
              Aggressivity: 6),
        );
      });
  }

  void RemoveBox() {
    if (game.CreateEnemyNumber1)
      Future.delayed(Duration(seconds: game.EnemyBox1TimeOut), () {
        EnemyBox[0].removeFromParent();
        game.CreateEnemyNumber1 = false;
      });
    if (game.CreateEnemyNumber2)
      Future.delayed(Duration(seconds: game.EnemyBox2TimeOut), () {
        EnemyBox[1].removeFromParent();
        game.CreateEnemyNumber2 = false;
      });
    if (game.CreateEnemyNumber2)
      Future.delayed(Duration(seconds: game.EnemyBox3TimeOut), () {
        EnemyBox[2].removeFromParent();
        game.CreateEnemyNumber3 = false;
      });
  }

//发射碰撞箱的触发按键
  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (keysPressed.contains(LogicalKeyboardKey.space) &&
        game.RemainingBullet > 0) {
      switch (game.HeroNumber) {
        case 1:
          Bullets1[game.RemainingBullet - 1].position =
              user.position + Vector2(0, 16);
          add(Bullets1[game.RemainingBullet - 1]);
          Bullets1[game.RemainingBullet - 1].IfBulletExist = true;
          if (user.IfRight) {
            Bullets1[game.RemainingBullet - 1].BulletHorizontalDirection = 1;
          } else
            Bullets1[game.RemainingBullet - 1].BulletHorizontalDirection = -1;
          break;
        case 2:
          Bullets2[game.RemainingBullet - 1].position =
              user.position + Vector2(0, 16);
          add(Bullets2[game.RemainingBullet - 1]);
          Bullets2[game.RemainingBullet - 1].IfBulletExist = true;
          if (user.IfRight) {
            Bullets2[game.RemainingBullet - 1].BulletHorizontalDirection = 1;
          } else
            Bullets2[game.RemainingBullet - 1].BulletHorizontalDirection = -1;
          break;
        case 3:
          Bullets3[game.RemainingBullet - 1].position =
              user.position + Vector2(0, 16);
          add(Bullets3[game.RemainingBullet - 1]);
          Bullets3[game.RemainingBullet - 1].IfBulletExist = true;
          if (user.IfRight) {
            Bullets3[game.RemainingBullet - 1].BulletHorizontalDirection = 1;
          } else
            Bullets3[game.RemainingBullet - 1].BulletHorizontalDirection = -1;
          break;
      }
    }

    return true;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    //初始化生成怪物的盒子
    EnemyBox = [
      SpawnComponent.periodRange(
        factory: (_) {
          return enemy(
              Pool: game.Pool1,
              MoveSpeed: 0.30,
              CloseEnemy: PolygonHitbox([
                Vector2(30, 50),
                Vector2(30, 70),
                Vector2(76, 70),
                Vector2(76, 50)
              ])
                ..isSolid = true
                ..collisionType = CollisionType.passive, //只攻击active的碰撞箱
              size: Vector2.all(96),
              position: Vector2(100, game.canvasSize.y - 100),
              shot: user,
              EnemyNumber: 1,
              Aggressivity: 1,
              EnemyHealth: 5,
              AttackFrame: 4,
              RunFrame: 8,
              DeadFrame: 5);
        },
        minPeriod: 0.5,
        maxPeriod: 2,
        area: game.EnemyBox1Area,
      ),
      SpawnComponent.periodRange(
        factory: (_) {
          return enemy(
              Pool: game.Pool2,
              CloseEnemy: PolygonHitbox([
                Vector2(30, 50),
                Vector2(30, 70),
                Vector2(76, 70),
                Vector2(76, 50)
              ])
                ..isSolid = true
                ..collisionType = CollisionType.passive, //只攻击active的碰撞箱
              MoveSpeed: 0.25,
              size: Vector2.all(96),
              position: Vector2(100, game.canvasSize.y - 100),
              shot: user,
              RunFrame: 8,
              AttackFrame: 5,
              DeadFrame: 5,
              Aggressivity: 2,
              EnemyNumber: 2,
              EnemyHealth: 5);
        },
        minPeriod: 0.5,
        maxPeriod: 2,
        area: game.EnemyBox2Area,
      ),
      SpawnComponent.periodRange(
        factory: (_) {
          return enemy(
              Pool: game.Pool3,
              CloseEnemy: PolygonHitbox([
                Vector2(30, 50),
                Vector2(30, 70),
                Vector2(76, 70),
                Vector2(76, 50)
              ])
                ..isSolid = true
                ..collisionType = CollisionType.passive, //只攻击active的碰撞箱
              MoveSpeed: 0.35,
              size: Vector2.all(96),
              AttackFrame: 4,
              RunFrame: 6,
              DeadFrame: 5,
              position: Vector2(100, game.canvasSize.y - 100),
              shot: user,
              Aggressivity: 1,
              EnemyNumber: 3,
              EnemyHealth: 5);
        },
        minPeriod: 0.5,
        maxPeriod: 2,
        area: game.EnemyBox3Area,
      )
    ];
    game.overlays.add('Pause');
    final TheaterImage = await game.images.load('War${WarNumber}.png');
    TheaterBackground = Sprite(TheaterImage);
    GameHud = Hud();
    user = hero(
      position: Vector2(game.canvasSize.x / 2, game.canvasSize.y - 100),
    );
//检测是使用哪一种子弹
    switch (game.HeroNumber) {
      case 1:
        Bullets1 = List.generate(game.RemainingBullet,
            (index) => Bullet(User: user, Aggressivity: 2));
        break;
      case 2:
        Bullets2 = List.generate(game.RemainingBullet,
            (index) => Bullet(User: user, Aggressivity: 1));
        break;
      case 3:
        Bullets3 = List.generate(game.RemainingBullet,
            (index) => Bullet(User: user, Aggressivity: 3));
        break;
    }
    CreateEnemy();
    RemoveBox();
    addAll([user, GameHud]);
  }

  Future<void> MoveBullets1(double dt) async {
    for (int index = game.Hero1Bullet - 1; index >= 0; index--) {
      if (Bullets1[index].IfBulletExist) {
        if ((Bullets1[index].position.x - user.position.x) > -232 &&
            (Bullets1[index].position.x - user.position.x) < 232) {
          Bullets1[index].BulletMoveDistance =
              dt * Bullets1[index].BulletHorizontalDirection * 250;
          Bullets1[index].position.x += Bullets1[index].BulletMoveDistance;
        } else {
          Bullets1[index].IfBulletExist = false;
          Bullets1[index].removeFromParent();
        }
      }
    }
  }

  Future<void> MoveBullets2(double dt) async {
    for (int index = game.Hero2Bullet - 1; index >= 0; index--) {
      if (Bullets2[index].IfBulletExist) {
        if ((Bullets2[index].position.x - user.position.x) > -200 &&
            (Bullets2[index].position.x - user.position.x) < 200) {
          Bullets2[index].BulletMoveDistance =
              dt * Bullets2[index].BulletHorizontalDirection * 300;
          Bullets2[index].position.x += Bullets2[index].BulletMoveDistance;
        } else {
          Bullets2[index].IfBulletExist = false;
          Bullets2[index].removeFromParent();
        }
      }
    }
  }

  Future<void> MoveBullets3(double dt) async {
    for (int index = game.Hero3Bullet - 1; index >= 0; index--) {
      if (Bullets3[index].IfBulletExist) {
        if ((Bullets3[index].position.x - user.position.x) > -260 &&
            (Bullets3[index].position.x - user.position.x) < 260) {
          Bullets3[index].BulletMoveDistance =
              dt * Bullets3[index].BulletHorizontalDirection * 250;
          Bullets3[index].position.x += Bullets3[index].BulletMoveDistance;
        } else {
          Bullets3[index].IfBulletExist = false;
          Bullets3[index].removeFromParent();
        }
      }
    }
  }

  Future<void> Victory() async {
    if (game.CreateBossNumber1 ||
        game.CreateBossNumber2 ||
        game.CreateBossNumber3 ||
        game.CreateEnemyNumber1 ||
        game.CreateEnemyNumber2 ||
        game.CreateEnemyNumber3) {
      return;
    } else {
      if (game.EnemyCount <= 0) {
        game.TheaterNumber++;
        game.router.pushReplacementNamed('victory');
        game.overlays.add('BackHome');
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    switch (game.HeroNumber) {
      case 1:
        MoveBullets1(dt);
        break;
      case 2:
        MoveBullets2(dt);
        break;
      case 3:
        MoveBullets3(dt);
        break;
    }
    if (game.UserHealth <= 0) {
      Future.delayed(Duration(milliseconds: 500), () {
        user.removeFromParent();
        game.router.pushReplacementNamed("fail");
        game.overlays.add("BackHome");
      });
    }
    Victory();
  }
}
