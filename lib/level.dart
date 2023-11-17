import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:zombie/game.dart';

//每个关卡选项圆点
class LevelChoice extends StatefulWidget {
  final game;
  const LevelChoice({super.key, required this.game});

  @override
  State<LevelChoice> createState() => _LevelChoiceState();
}

class _LevelChoiceState extends State<LevelChoice> {
  List ishover = List.filled(8, true); //判断圆点是否被hover的变量的列表
  //初始化圆点，并放到一个列表里
  List<Widget> initListData(int a) {
    List<Widget> ls = [];
    for (var i = a - 1; i < a + 3; i++) {
      ls.add(MouseRegion(
          onEnter: (_) {
            setState(() {
              ishover[i] = false;
            });
          },
          onExit: (event) {
            setState(() {
              ishover[i] = true;
            });
          },
          child: GestureDetector(
            onTapDown: (_) {
              widget.game.router.pushReplacementNamed('Theater${i + 1}');
            },
            child: Container(
              height: 100,
              width: 100,
              padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
              margin: EdgeInsets.fromLTRB(0, 0, 75, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: ishover[i]
                    ? Color.fromRGBO(170, 170, 170, 1)
                    : Color.fromRGBO(85, 85, 85, 0.5),
              ),
              child: Text(
                (i + 1).toString(),
                style: TextStyle(color: Colors.black, fontSize: 50),
                textAlign: TextAlign.center,
              ),
            ),
          )));
    }
    return ls;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: 175,
        top: 270,
        child: Column(
          children: [
            Wrap(
              runAlignment: WrapAlignment.start,
              children: initListData(1),
            ),
            SizedBox(height: 100),
            Wrap(
              runAlignment: WrapAlignment.start,
              children: initListData(5),
            )
          ],
        ));
  }
}

class LevelPage extends Component with HasGameReference<RouterGame> {
  LevelPage();

  final DarkenFilter =
      ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.srcOver);
  late Sprite LevelBackground;

  void render(Canvas canvas) {
    // 渲染背景图片
    LevelBackground.render(canvas,
        size: Vector2(game.size.x, game.size.y),
        overridePaint: Paint()..colorFilter = DarkenFilter);
  }

  @override
  Future<void> onLoad() async {
    final LevelImage = await game.images.load('startpage.webp');
    LevelBackground = Sprite(LevelImage);
  }
}
