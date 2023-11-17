import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/rendering.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:zombie/choose.dart';
import 'package:zombie/fail.dart';
import 'package:zombie/startpage.dart';
import 'package:zombie/theater.dart';
import 'package:zombie/victory.dart';
import './level.dart';
import './pausepage.dart';

void InitMusic() {
  FlameAudio.audioCache.loadAll([
    'character1shotmusic.ogg',
    'character2shotmusic.ogg',
    'character3shotmusic.ogg',
    'rechargemusic.mp3',
    'BattleTheme1.mp3',
    'BattleTheme2.mp3',
    'BattleTheme3.mp3',
    'BattleTheme4.mp3',
    'wolfmusic.ogg',
    'zombie1music.ogg',
    'zombie2music.ogg',
    'zombie3music.ogg',
  ]);
}

//游戏主体
class RouterGame extends FlameGame with HasKeyboardHandlerComponents {
  late final RouterComponent router;
  int RemainingBullet = 0; //子弹数量
  int EnemyCount = 0;
  int UserHealth = 150; //玩家生命
  int Hero1Bullet = 0;
  int Hero2Bullet = 0;
  int Hero3Bullet = 0;
  int HeroNumber = 1;
  int RunFrame = 8;
  int RechargeFrame = 13;
  int EnemyBox1Time = 0;
  int EnemyBox1TimeOut = 0;
  int EnemyBox2Time = 0;
  int EnemyBox2TimeOut = 0;
  int EnemyBox3Time = 0;
  int EnemyBox3TimeOut = 0;
  int EnemyBoss1Time = 0;
  int EnemyBoss2Time = 0;
  int EnemyBoss3Time = 0;
  late AudioPool Pool1; //限制播放器的数量，防止过载
  late AudioPool Pool2;
  late AudioPool Pool3;
  late AudioPool Pool4;
  late AudioPool Pool5;
  late AudioPool Pool6;
  late AudioPool Pool7;
  late AudioPool Pool8;
  late AudioPool HeroPool;
  Circle CreateArea1 = Circle(Vector2(100, 650), 150); //生成怪物的地方
  Circle CreateArea2 = Circle(Vector2(1436, 600), 150);
  Circle EnemyBox1Area = Circle(Vector2(0, 0), 0);
  Circle EnemyBox2Area = Circle(Vector2(0, 0), 0);
  Circle EnemyBox3Area = Circle(Vector2(0, 0), 0);
  bool CreateEnemyNumber1 = false;
  bool CreateEnemyNumber2 = false;
  bool CreateEnemyNumber3 = false;
  bool CreateBossNumber1 = false;
  bool CreateBossNumber2 = false;
  bool CreateBossNumber3 = false;
  int TheaterNumber = 0;
  bool IsMusicOpen = false;
  @override
  Future<void> onLoad() async {
    Pool1 = await FlameAudio.createPool(
      'zombie1music.ogg',
      minPlayers: 2,
      maxPlayers: 3,
    );
    Pool2 = await FlameAudio.createPool(
      'zombie2music.ogg',
      minPlayers: 3,
      maxPlayers: 4,
    );
    Pool3 = await FlameAudio.createPool(
      'zombie3music.ogg',
      minPlayers: 3,
      maxPlayers: 4,
    );
    Pool4 = await FlameAudio.createPool(
      'wolfmusic.ogg',
      minPlayers: 3,
      maxPlayers: 4,
    );
    Pool5 = await FlameAudio.createPool(
      'character1shotmusic.ogg',
      minPlayers: 3,
      maxPlayers: 4,
    );
    Pool6 = await FlameAudio.createPool(
      'character2shotmusic.ogg',
      minPlayers: 3,
      maxPlayers: 4,
    );
    Pool7 = await FlameAudio.createPool(
      'character3shotmusic.ogg',
      minPlayers: 3,
      maxPlayers: 4,
    );
    Pool8 = await FlameAudio.createPool(
      'rechargemusic.mp3',
      minPlayers: 3,
      maxPlayers: 4,
    );
    await images.loadAll([
      "startpage.webp",
      "character1.png",
      "character1_Recharge.png",
      "character1_Idle.png",
      "character1_Run.png",
      "character1_shot.png",
      "character2.png",
      "character2_Idle.png",
      "character2_Run.png",
      "character2_shot.png",
      "character2_Recharge.png",
      "character3.png",
      "character3_Recharge.png",
      "character3_Idle.png",
      "character3_Run.png",
      "character3_shot.png",
      "War1.png",
      "war2.png",
      "war3.png",
      "war4.png",
      "enemy1_Run.png",
      "enemy1_Attack.png",
      "character1_Dead.png",
      "character2_Dead.png",
      "character3_Dead.png",
      "enemy1_Dead.png",
      "enemy2_Attack.png",
      "enemy2_Dead.png",
      "enemy2_Run.png",
      "enemy3_Attack.png",
      "enemy3_Dead.png",
      "enemy3_Run.png",
      "enemy4_Attack.png",
      "enemy4_Dead.png",
      "enemy4_Run.png",
      "enemy5_Attack.png",
      "enemy5_Dead.png",
      "enemy5_Run.png",
      "enemy6_Attack.png",
      "enemy6_Dead.png",
      "enemy6_Run.png",
    ]);
    InitMusic();
    add(
      router = RouterComponent(
        routes: {
          'home': Route(() {
            if (IsMusicOpen) {
              FlameAudio.bgm.stop();
              FlameAudio.bgm.play('BattleTheme1.mp3', volume: 0.5);
            }
            overlays.removeAll([
              'BackHome',
              'BackHomePop',
              'level',
              'pasue',
              'Music2' 'Music3',
              'Music4'
            ]);
            overlays.add('Music1');
            TheaterNumber = 0;
            CreateEnemyNumber1 = false;
            CreateEnemyNumber2 = false;
            CreateEnemyNumber3 = false;
            CreateBossNumber1 = false;
            CreateBossNumber2 = false;
            CreateBossNumber3 = false;
            return StartPage();
          }, maintainState: false),
          'choose': Route(() {
            overlays.add('BackHome');
            return ChoosePage.new();
          }, maintainState: false),
          'level1': Route(
            () {
              overlays.add('level');
              overlays.add('BackHome');
              HeroPool = Pool5;
              HeroNumber = 1;
              Hero1Bullet = 15;
              Hero2Bullet = 0;
              Hero3Bullet = 0;
              RemainingBullet = Hero1Bullet;
              return LevelPage.new();
            },
            maintainState: false,
          ),
          'level2': Route(
            () {
              overlays.add('level');
              overlays.add('BackHome');
              RechargeFrame = 8;
              HeroPool = Pool6;
              Hero1Bullet = 0;
              Hero2Bullet = 30;
              Hero3Bullet = 0;
              RemainingBullet = Hero2Bullet;
              RunFrame = 7;
              HeroNumber = 2;
              return LevelPage.new();
            },
            maintainState: false,
          ),
          'level3': Route(
            () {
              overlays.add('level');
              overlays.add('BackHome');
              RechargeFrame = 7;
              HeroPool = Pool7;
              Hero1Bullet = 0;
              Hero2Bullet = 0;
              Hero3Bullet = 10;
              RemainingBullet = Hero3Bullet;
              RunFrame = 6;
              HeroNumber = 3;
              return LevelPage.new();
            },
            maintainState: false,
          ),
          'Theater1': Route(() {
            if (IsMusicOpen) {
              FlameAudio.bgm.stop();
              FlameAudio.bgm.play('BattleTheme2.mp3', volume: 0.5);
            }
            overlays
                .removeAll(['BackHome', 'level', 'Music1', 'Music3', 'Music4']);
            overlays.add("Music2");
            overlays.add('Pause');
            TheaterNumber = 1;
            UserHealth = 150;
            CreateEnemyNumber1 = true;
            EnemyBox1Area = CreateArea1;
            EnemyBox1Time = 5;
            EnemyBox1TimeOut = 35;
            if (Hero1Bullet != 0) //判断初始化那个英雄的子弹
              RemainingBullet = Hero1Bullet;
            else if (Hero2Bullet != 0)
              RemainingBullet = Hero2Bullet;
            else if (Hero3Bullet != 0) RemainingBullet = Hero3Bullet;
            return Theater.new(WarNumber: 1);
          }, maintainState: false),
          'Theater2': Route(() {
            if (IsMusicOpen) {
              FlameAudio.bgm.stop();
              FlameAudio.bgm.play('BattleTheme2.mp3', volume: 0.5);
            }
            overlays
                .removeAll(['BackHome', 'level', 'Music1', 'Music3', 'Music4']);
            overlays.add("Music2");
            overlays.add('Pause');
            TheaterNumber = 2;
            UserHealth = 150;
            CreateEnemyNumber1 = true;
            CreateEnemyNumber2 = true;
            EnemyBox1Area = CreateArea1;
            EnemyBox2Area = CreateArea2;
            EnemyBox1Time = 5;
            EnemyBox1TimeOut = 30;
            EnemyBox2Time = 50;
            EnemyBox2TimeOut = 80;
            if (Hero1Bullet != 0)
              RemainingBullet = Hero1Bullet;
            else if (Hero2Bullet != 0)
              RemainingBullet = Hero2Bullet;
            else if (Hero3Bullet != 0) RemainingBullet = Hero3Bullet;
            return Theater.new(WarNumber: 1);
          }, maintainState: false),
          'Theater3': Route(() {
            if (IsMusicOpen) {
              FlameAudio.bgm.stop();
              FlameAudio.bgm.play('BattleTheme2.mp3', volume: 0.5);
            }
            overlays
                .removeAll(['BackHome', 'level', 'Music1', 'Music3', 'Music4']);
            overlays.add("Music2");
            overlays.add('Pause');
            TheaterNumber = 3;
            UserHealth = 150;
            CreateEnemyNumber1 = true;
            CreateEnemyNumber2 = true;
            CreateEnemyNumber3 = true;
            EnemyBox1Area = CreateArea1;
            EnemyBox2Area = CreateArea1;
            EnemyBox3Area = CreateArea2;
            EnemyBox1Time = 5;
            EnemyBox1TimeOut = 30;
            EnemyBox2Time = 15;
            EnemyBox2TimeOut = 35;
            EnemyBox3Time = 60;
            EnemyBox3TimeOut = 80;
            if (Hero1Bullet != 0)
              RemainingBullet = Hero1Bullet;
            else if (Hero2Bullet != 0)
              RemainingBullet = Hero2Bullet;
            else if (Hero3Bullet != 0) RemainingBullet = Hero3Bullet;
            return Theater.new(WarNumber: 2);
          }, maintainState: false),
          'Theater4': Route(() {
            if (IsMusicOpen) {
              FlameAudio.bgm.stop();
              FlameAudio.bgm.play('BattleTheme2.mp3', volume: 0.5);
            }
            overlays
                .removeAll(['BackHome', 'level', 'Music1', 'Music3', 'Music4']);
            overlays.add("Music2");
            overlays.add('Pause');
            TheaterNumber = 4;
            UserHealth = 150;
            CreateEnemyNumber1 = true;
            CreateEnemyNumber2 = true;
            CreateEnemyNumber3 = true;
            CreateBossNumber1 = true;
            EnemyBox1Area = CreateArea1;
            EnemyBox2Area = CreateArea2;
            EnemyBox3Area = CreateArea1;
            EnemyBox1Time = 5;
            EnemyBox1TimeOut = 30;
            EnemyBox2Time = 8;
            EnemyBox2TimeOut = 35;
            EnemyBox3Time = 50;
            EnemyBox3TimeOut = 80;
            EnemyBoss1Time = 80;
            if (Hero1Bullet != 0)
              RemainingBullet = Hero1Bullet;
            else if (Hero2Bullet != 0)
              RemainingBullet = Hero2Bullet;
            else if (Hero3Bullet != 0) RemainingBullet = Hero3Bullet;
            return Theater.new(WarNumber: 2);
          }, maintainState: false),
          'Theater5': Route(() {
            if (IsMusicOpen) {
              FlameAudio.bgm.stop();
              FlameAudio.bgm.play('BattleTheme3.mp3', volume: 0.5);
            }
            overlays
                .removeAll(['BackHome', 'level', 'Music1', 'Music2', 'Music4']);
            overlays.add("Music3");
            overlays.add('Pause');
            TheaterNumber = 5;
            UserHealth = 150;
            CreateEnemyNumber1 = true;
            CreateEnemyNumber2 = true;
            CreateEnemyNumber3 = true;
            EnemyBox1Area = CreateArea1;
            EnemyBox2Area = CreateArea2;
            EnemyBox3Area = CreateArea2;
            EnemyBox1Time = 5;
            EnemyBox1TimeOut = 30;
            EnemyBox2Time = 10;
            EnemyBox2TimeOut = 25;
            EnemyBox3Time = 15;
            EnemyBox3TimeOut = 35;
            if (Hero1Bullet != 0)
              RemainingBullet = Hero1Bullet;
            else if (Hero2Bullet != 0)
              RemainingBullet = Hero2Bullet;
            else if (Hero3Bullet != 0) RemainingBullet = Hero3Bullet;
            return Theater.new(WarNumber: 3);
          }, maintainState: false),
          'Theater6': Route(() {
            if (IsMusicOpen) {
              FlameAudio.bgm.stop();
              FlameAudio.bgm.play('BattleTheme3.mp3', volume: 0.5);
            }
            overlays
                .removeAll(['BackHome', 'level', 'Music1', 'Music2', 'Music4']);
            overlays.add("Music3");
            overlays.add('Pause');
            TheaterNumber = 6;
            UserHealth = 150;
            CreateEnemyNumber1 = true;
            CreateEnemyNumber2 = true;
            CreateEnemyNumber3 = true;
            CreateBossNumber2 = true;
            EnemyBox1Area = CreateArea2;
            EnemyBox2Area = CreateArea1;
            EnemyBox3Area = CreateArea1;
            EnemyBox1Time = 5;
            EnemyBox1TimeOut = 25;
            EnemyBox2Time = 5;
            EnemyBox2TimeOut = 25;
            EnemyBox3Time = 15;
            EnemyBox3TimeOut = 30;
            EnemyBoss2Time = 40;
            if (Hero1Bullet != 0)
              RemainingBullet = Hero1Bullet;
            else if (Hero2Bullet != 0)
              RemainingBullet = Hero2Bullet;
            else if (Hero3Bullet != 0) RemainingBullet = Hero3Bullet;
            return Theater.new(WarNumber: 3);
          }, maintainState: false),
          'Theater7': Route(() {
            if (IsMusicOpen) {
              FlameAudio.bgm.stop();
              FlameAudio.bgm.play('BattleTheme3.mp3', volume: 0.5);
            }
            overlays
                .removeAll(['BackHome', 'level', 'Music1', 'Music2', 'Music4']);
            overlays.add("Music3");
            overlays.add('Pause');
            TheaterNumber = 7;
            UserHealth = 150;
            CreateEnemyNumber1 = true;
            CreateEnemyNumber2 = true;
            CreateBossNumber1 = true;
            CreateBossNumber2 = true;
            EnemyBox1Area = CreateArea2;
            EnemyBox2Area = CreateArea1;
            EnemyBox1Time = 5;
            EnemyBox1TimeOut = 30;
            EnemyBox2Time = 8;
            EnemyBox2TimeOut = 30;
            EnemyBoss1Time = 45;
            EnemyBoss2Time = 45;
            if (Hero1Bullet != 0)
              RemainingBullet = Hero1Bullet;
            else if (Hero2Bullet != 0)
              RemainingBullet = Hero2Bullet;
            else if (Hero3Bullet != 0) RemainingBullet = Hero3Bullet;
            return Theater.new(WarNumber: 4);
          }, maintainState: false),
          'Theater8': Route(() {
            if (IsMusicOpen) {
              FlameAudio.bgm.stop();
              FlameAudio.bgm.play('BattleTheme4.mp3', volume: 0.5);
            }
            overlays
                .removeAll(['BackHome', 'level', 'Music1', 'Music2', 'Music3']);
            overlays.add("Music4");
            overlays.add('Pause');
            TheaterNumber = 8;
            UserHealth = 150;
            CreateEnemyNumber1 = true;
            CreateEnemyNumber2 = true;
            CreateEnemyNumber3 = true;
            CreateBossNumber1 = true;
            CreateBossNumber2 = true;
            CreateBossNumber3 = true;
            EnemyBox1Area = CreateArea2;
            EnemyBox2Area = CreateArea1;
            EnemyBox3Area = CreateArea1;
            EnemyBox1Time = 5;
            EnemyBox1TimeOut = 25;
            EnemyBox2Time = 5;
            EnemyBox2TimeOut = 25;
            EnemyBox3Time = 15;
            EnemyBox3TimeOut = 30;
            EnemyBoss1Time = 60;
            EnemyBoss2Time = 60;
            EnemyBoss3Time = 65;
            if (Hero1Bullet != 0)
              RemainingBullet = Hero1Bullet;
            else if (Hero2Bullet != 0)
              RemainingBullet = Hero2Bullet;
            else if (Hero3Bullet != 0) RemainingBullet = Hero3Bullet;
            return Theater.new(WarNumber: 4);
          }, maintainState: false),
          'stop': PauseRoute(),
          'fail': Route(() => FailPage.new()),
          'victory': Route(() => VictoryPage())
        },
        initialRoute: 'home',
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}

//暂停的路由
class PauseRoute extends Route {
  PauseRoute()
      : super(() => PausePage.new(), transparent: true, maintainState: false);

  @override
  void onPush(Route? previousRoute) {
    previousRoute!
      ..stopTime()
      ..addRenderEffect(
        PaintDecorator.grayscale(opacity: 0.5)..addBlur(3.0),
      );
  }

  @override
  void onPop(Route nextRoute) {
    nextRoute
      ..resumeTime()
      ..removeRenderEffect();
  }
}
