import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'package:zombie/Button.dart';
import 'package:zombie/game.dart';

//开始的页面
class StartPage extends Component with HasGameReference<RouterGame> {
  late Sprite StartBackground;
  final world = World();
  late final CameraComponent camera;
  final _MainText = TextPaint(
      style: TextStyle(
          color: Color.fromRGBO(155, 149, 39, 1),
          fontSize: 100,
          fontWeight: FontWeight.w600));
  StartPage();
  //文本

  @override
  void render(Canvas canvas) {
    // 渲染背景图片
    StartBackground.render(canvas, size: Vector2(game.size.x, game.size.y));
  }

  @override
  Future<void> onLoad() async {
    final StartImage = await game.images.load('startpage.webp');
    StartBackground = Sprite(StartImage);
    addAll([
      TextComponent(
          priority: 1,
          text: "2D Defend Homeland",
          textRenderer: _MainText,
          anchor: Anchor.center,
          position: Vector2(game.size.x / 2, 172)),
      StartButton(position: Vector2(game.size.x / 2, game.size.y / 2)),
    ]);
  }
}
