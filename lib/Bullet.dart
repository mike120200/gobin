import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:zombie/game.dart';
import 'package:zombie/hero.dart';

//子弹类
class Bullet extends PositionComponent
    with KeyboardHandler, CollisionCallbacks, HasGameRef<RouterGame> {
  Bullet({required this.User, required this.Aggressivity})
      : super(
            size: Vector2(32, 5),
            anchor: Anchor.center,
            position: User.position + Vector2(0, 16));
  double BulletHorizontalDirection = 0;
  final int Aggressivity;
  final hero User;
  double BulletMoveDistance = 0;
  ShapeHitbox BulletBox = RectangleHitbox()..isSolid = true;
  bool IfBulletExist = false;
  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(BulletBox);
  }
}
