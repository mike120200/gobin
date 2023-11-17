import 'dart:async';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:zombie/game.dart';

//显示玩家剩余子弹
class BulletShow extends PositionComponent with HasGameRef<RouterGame> {
  BulletShow() : super(size: Vector2.all(120));
  late TextComponent BulletNumber;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    BulletNumber = TextComponent(
        text: "${game.RemainingBullet}",
        size: Vector2.all(20),
        anchor: Anchor.center,
        position: Vector2(1456, 180));
    add(BulletNumber);
  }

  @override
  void update(double dt) {
    super.update(dt);
    BulletNumber.text = "${game.RemainingBullet}";
  }

  static final Paint _BackgroundColor = Paint()
    ..color = Color.fromARGB(255, 144, 144, 13);
  @override
  void render(Canvas canvas) {
    canvas.drawCircle(Offset(1456, 180), 60, _BackgroundColor);
    super.render(canvas);
  }
}

//显示玩家血量
class Blood extends PositionComponent with HasGameRef<RouterGame> {
  Blood() : super(size: Vector2(188, 70), position: Vector2(20, 30));
  static final Paint RedColor = Paint()
    ..color = Color.fromRGBO(230, 82, 48, 0.8);

  static final Paint BoderColor = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 5.0;

  late Picture healthBarPicture;
  static final Paint TransparentColor = Paint()..color = Colors.transparent;
  @override
  Future<void> onLoad() async {
    super.onLoad();
  }

//按生命值占总生命值的份数来绘画红色
  void ShowHealth() {
    PictureRecorder recorder = PictureRecorder();
    Canvas canvas = Canvas(recorder);
    Rect RoundedRect = Rect.fromPoints(
      Offset(0, 0),
      Offset(width, height),
    );
    Rect LeftRect = Rect.fromPoints(
      Offset(0, 0),
      Offset(width * game.UserHealth / 150, height),
    );
    Rect RightRect = Rect.fromPoints(
      Offset(width * game.UserHealth / 150, 0),
      Offset(width, height),
    );

    canvas.drawRect(RoundedRect, BoderColor);
    canvas.drawRect(LeftRect, RedColor);
    canvas.drawRect(RightRect, TransparentColor);
    healthBarPicture = recorder.endRecording();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawPicture(healthBarPicture);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (game.UserHealth >= 0) ShowHealth(); //时刻更新
  }
}

//显示所有信息的类
class Hud extends PositionComponent with HasGameRef<RouterGame> {
  Hud() : super(anchor: Anchor.topLeft);
  late BulletShow ShowBullet;
  late Blood blood;
  @override
  Future<void> onLoad() async {
    super.onLoad();
    ShowBullet = BulletShow();
    blood = Blood();
    TextComponent(
        text: "${game.RemainingBullet}",
        size: Vector2.all(20),
        anchor: Anchor.center,
        position: Vector2(1436, 690),
        priority: 10);
    addAll([ShowBullet, blood]);
  }
}
