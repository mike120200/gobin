import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zombie/game.dart';
import 'package:zombie/gamecontroller.dart';

//使用了riverpod库的类的按钮
class GeneralgameControlButton extends ConsumerStatefulWidget {
  GeneralgameControlButton(
      {required this.icon,
      this.onClick1,
      required this.size,
      super.key,
      this.game});
  final void Function()? onClick1; //按第一次的效果
  final IconData icon;
  final game;
  final double size;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      GeneralgameControlButtonState();
}

class GeneralgameControlButtonState
    extends ConsumerState<GeneralgameControlButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
          child: Icon(
            widget.icon,
            color: Colors.white,
            size: widget.size,
          ),
          onTapDown: (_) {
            widget.onClick1?.call();
          }),
    );
  }
}

//原生flutter的按钮
class GeneralRouterButton extends StatelessWidget {
  const GeneralRouterButton(
      {super.key,
      required this.icon,
      required this.work,
      required this.onClick,
      this.disabled = false});
  final IconData icon;
  final String work;
  final bool disabled;
  final void Function()? onClick;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(work),
      onPressed: onClick,
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
              const Color.fromARGB(255, 130, 120, 27))),
    );
  }
}

//返回按钮
class MyBackButton extends ConsumerWidget {
  const MyBackButton({super.key, required this.game, this.IfPop = false});
  final game;
  final bool IfPop;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GameState = ref.watch(gameControllerProvider);
    return Positioned(
        left: 20,
        top: 20,
        child: GeneralRouterButton(
            disabled: GameState.paused,
            icon: Icons.arrow_back,
            work: "BackHome",
            onClick: () {
              if (IfPop) game.router.pop();
              game.router.pushReplacementNamed('home'); //替换本页面并且跳转回开始界面
              game.overlays //移除这几个flutter原生按钮
                  .removeAll(['BackHome', 'level', 'Pause', 'BackHomePop']);
            }));
  }
}

//开始页码的开始的按钮
class StartButton extends PositionComponent
    with HasGameRef<RouterGame>, TapCallbacks {
  StartButton({required super.position})
      : super(size: Vector2(280, 100), anchor: Anchor.center);
  static final Paint _The1Color = Paint() //未点击时的颜色
    ..color = Color.fromRGBO(232, 170, 56, 0.8);
  static final Paint _The2Color = Paint() //点击时的颜色
    ..color = Color.fromARGB(232, 170, 56, 1);
  bool _BeenPressed = true; //判断是否被点击
  final _ButtonText = TextPaint(
      style: TextStyle(fontSize: 28, color: Color.fromRGBO(255, 42, 55, 1)));
  @override
  Future<void>? onLoad() async {}

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    _BeenPressed = true;
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    _BeenPressed = false;
    Future.delayed(Duration(milliseconds: 300), () {
      game.router.pushReplacementNamed('choose'); //替换本页跳转到选人界面
      game.overlays.add('BackHome'); //加上返回按钮
    });
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    _BeenPressed = true;
  }

  @override
  void render(Canvas canvas) {
    // 渲染当前按钮状态的精灵
    super.render(canvas);
    RRect RoundedRect =
        RRect.fromRectAndRadius(size.toRect(), Radius.circular(30));
    canvas.drawRRect(RoundedRect, _BeenPressed ? _The1Color : _The2Color);
    add(TextComponent(
        priority: 1,
        text: "Start",
        textRenderer: _ButtonText,
        anchor: Anchor.center,
        position: Vector2(size.x / 2, size.y / 2)));
  }
}

//游戏期间的暂停按钮
class PauseButton extends ConsumerWidget {
  final game;
  const PauseButton({required this.game});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Positioned(
        top: 20,
        right: 20,
        child: GeneralgameControlButton(
          icon: Icons.pause_circle,
          size: 85,
          onClick1: () {
            game.router.pushNamed('stop'); //跳转到暂停页面，但是不替换
            game.overlays.add('BackHomePop');
            game.overlays.remove('Pause');
          },
        ));
  }
}

//游戏音乐播放按钮
class OpenOrCloseMusic extends ConsumerWidget {
  final String MusicName;
  final game;

  OpenOrCloseMusic({required this.MusicName, required this.game});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Positioned(
        right: game.size.x / 2,
        top: 20,
        child: GeneralgameControlButton(
          icon: Icons.music_note_rounded,
          size: 50,
          onClick1: () {
            if (!game.IsMusicOpen) {
              FlameAudio.bgm.play(MusicName, volume: 0.5);
              game.IsMusicOpen = true;
            } else {
              FlameAudio.bgm.stop();
              game.IsMusicOpen = false;
            }
          },
        ));
  }
}
