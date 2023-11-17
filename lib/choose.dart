import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:zombie/game.dart';

//人物选项展示
class choice extends SpriteAnimationComponent
    with HasGameRef<RouterGame>, TapCallbacks {
  static final Paint _the1 = Paint()
    ..color = Color.fromRGBO(255, 255, 255, 1); //未点击颜色
  static final Paint _the2 = Paint()
    ..color = Color.fromRGBO(47, 79, 79, 1); //点击后颜色
  final charactertext = TextPaint(
      style: TextStyle(
    color: Color.fromRGBO(155, 149, 39, 1),
    fontSize: 20,
    fontWeight: FontWeight.w600,
  ));
  bool IsTap = true; //是否给点击
  final String name;
  final int HeroNumber;
  choice(
      {required super.position, required this.name, required this.HeroNumber})
      : super(anchor: Anchor.center, size: Vector2(150, 170));
  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), IsTap ? _the1 : _the2);
    add(TextComponent(
        text: name,
        textRenderer: charactertext,
        anchor: Anchor.center,
        position: Vector2(size.x / 2, 10)));
    super.render(canvas);
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    IsTap = false;
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    IsTap = true;
    Future.delayed(Duration(milliseconds: 300), () {
      game.router.pushReplacementNamed('level${HeroNumber}'); //跳转到关卡选择页面，替代本页
    });
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    super.onTapCancel(event);
    IsTap = true;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    animation = SpriteAnimation.fromFrameData(
      //人物选项动画
      game.images.fromCache(name + '.png'),
      SpriteAnimationData.sequenced(
          amount: 4,
          textureSize: Vector2(128, 128),
          stepTime: 0.15,
          loop: false),
    );
  }
}

//人物选择页面
class ChoosePage extends Component with HasGameReference<RouterGame> {
  ChoosePage();
  late Sprite ChooseBackground;
  final world = World();
  final DarkenFilter =
      ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.srcOver);
  @override
  void render(Canvas canvas) {
    // 渲染背景图片
    ChooseBackground.render(canvas,
        size: Vector2(game.size.x, game.size.y),
        overridePaint: Paint()..colorFilter = DarkenFilter);
  }

  @override
  Future<void> onLoad() async {
    final ChooseBackgroundImage = await game.images.load('startpage.webp');
    ChooseBackground = Sprite(ChooseBackgroundImage);
    addAll([
      choice(position: Vector2(375, 269), name: "character1", HeroNumber: 1),
      choice(position: Vector2(633, 269), name: "character2", HeroNumber: 2),
      choice(position: Vector2(375, 545), name: "character3", HeroNumber: 3)
    ]);
  }
}
