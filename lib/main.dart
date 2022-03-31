import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:wakelock/wakelock.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //向き指定
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, //縦固定
  ]);

  runApp(const MyApp());

  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
  );

  final AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    iOS: initializationSettingsIOS,
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Po Timer',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      darkTheme: ThemeData(
          primarySwatch: Colors.lightGreen, brightness: Brightness.dark),
      themeMode: ThemeMode.system,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('ja', 'JP'),
      ],
      home: const TopPage(title: 'Po Timer 🍅'),
    );
  }
}

class TopPage extends StatefulWidget {
  const TopPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '1 set 25min, break time 5min',
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Text('Tap to start',
                  style: Theme.of(context).textTheme.headline4),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 20),
              child: Column(children: <Widget>[
                SizedBox(
                  width: 120,
                  child: ElevatedButton.icon(
                    onPressed: () => _pushTimerPage(1),
                    icon: const Icon(Icons.play_circle),
                    label: const Text('1 set'),
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: ElevatedButton.icon(
                    onPressed: () => _pushTimerPage(2),
                    icon: const Icon(Icons.play_circle),
                    label: const Text('2 sets'),
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: ElevatedButton.icon(
                    onPressed: () => _pushTimerPage(3),
                    icon: const Icon(Icons.play_circle),
                    label: const Text('3 sets'),
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: ElevatedButton.icon(
                    onPressed: () => _pushTimerPage(4),
                    icon: const Icon(Icons.play_circle),
                    label: const Text('4 sets'),
                  ),
                ),
              ]),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: OutlinedButton(
                onPressed: _pushExplainPage,
                child: const Text('ポモドーロ・テクニックとは'),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _pushExplainPage() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (context) => const ExplainPage()),
    );
  }

  void _pushTimerPage(int maxPo) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
          builder: (context) => TimerStartPage(maxPo: maxPo)),
    );
  }
}

class ExplainPage extends StatefulWidget {
  const ExplainPage({Key? key}) : super(key: key);

  @override
  State<ExplainPage> createState() => _ExplainPageState();
}

class _ExplainPageState extends State<ExplainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Po ?')),
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: Text('Wikipediaより',
                      style: Theme.of(context).textTheme.headline6)),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: const Text(
                  'ポモドーロ・テクニック（英: Pomodoro Technique、ポモドーロ法）とは、時間管理術のひとつ。 1980年代にイタリア人のフランチェスコ・シリロによって考案された。このテクニックではタイマーを使用し、一般的には25分の作業と短い休息で作業時間と休息時間を分割する。 1セットを「ポモドーロ」と呼ぶ。これは、イタリア語で「トマト」を意味する言葉で、シリロが大学生時代にトマト型のキッチンタイマーを使用していたことにちなむ...',
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: OutlinedButton.icon(
                  onPressed: _launchInBrowser,
                  icon: const Icon(Icons.smartphone),
                  label: const Text('続きをWikipediaで見る'),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                child: OutlinedButton(
                  child: const Text('TOPへ戻る'),
                  onPressed: _goBack,
                ),
              )
            ],
          ),
        ));
  }

  // 外部ブラウザで開く
  void _launchInBrowser() async {
    const _url = 'https://w.wiki/Rva';
    if (await canLaunch(_url)) {
      await launch(
        _url,
        forceSafariVC: false,
        forceWebView: false,
      );
    } else {
      throw 'このURLにはアクセスできません';
    }
  }

  void _goBack() {
    Navigator.pop(context);
  }
}

class TimerStartPage extends StatefulWidget {
  const TimerStartPage({Key? key, required this.maxPo}) : super(key: key);
  final int maxPo;

  @override
  State<TimerStartPage> createState() => _TimerStartPageState();
}

class _TimerStartPageState extends State<TimerStartPage> {
  late Timer _timer;

  final _poTime = 25 * 60; // 25分 sec
  final _breakTime = 5 * 60; // 25分 sec
  // final _poTime = 10; // test sec
  // final _breakTime = 5; // test sec

  int _maxPo = 2;
  int _counter = 0;
  int _poCounter = 1;
  int _currentSeconds = 0;
  int _currentBaseTime = 0;
  double _remainingTimeRatio = 1.0;
  late String _messageAbove;
  String _messageBelow = 'Pomodoro 🍅';

  Timer _countTimer() {
    return Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (_currentSeconds < 1) {
          timer.cancel();
          _handleTimeout();
        } else {
          setState(() {
            _currentSeconds = _currentSeconds - 1;
            _remainingTimeRatio = _currentSeconds / _currentBaseTime;
          });
        }
      },
    );
  }

  void _handleTimeout() {
    if (_poCounter >= _maxPo) {
      _setNotification3();
      setState(() {
        _messageBelow = 'Finished 🎉';
      });
      return;
    }
    if (_counter.isEven) {
      _setNotification1();
      setState(() {
        _messageBelow = 'Break Time ☕️';
        _remainingTimeRatio = 1.0;
      });
      _currentBaseTime = _breakTime;
      _currentSeconds = _breakTime;
      _countTimer();
    } else {
      _setNotification2();
      setState(() {
        _poCounter++;
        _messageAbove = '$_poCounter / $_maxPo';
        _messageBelow = 'Pomodoro 🍅';
        _remainingTimeRatio = 1.0;
      });
      _currentBaseTime = _poTime;
      _currentSeconds = _poTime;
      _countTimer();
    }
    _counter++;
  }

  String _timerString(int leftSeconds) {
    final _minutes = (leftSeconds / 60).floor().toString().padLeft(2, '0');
    final _seconds = (leftSeconds % 60).floor().toString().padLeft(2, '0');
    return '$_minutes:$_seconds';
  }

  void _setNotification1() async {
    const IOSNotificationDetails iOSPlatformChannelSpecifics =
        IOSNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'channel_description',
      importance: Importance.high,
      priority: Priority.high,
    );
    NotificationDetails platformChannelSpecifics = const NotificationDetails(
      iOS: iOSPlatformChannelSpecifics,
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
        0, 'Po Timer', '25分経過しました。休憩しましょう☕️', platformChannelSpecifics);
  }

  void _setNotification2() async {
    const IOSNotificationDetails iOSPlatformChannelSpecifics =
        IOSNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'channel_description',
      importance: Importance.high,
      priority: Priority.high,
    );
    NotificationDetails platformChannelSpecifics = const NotificationDetails(
      iOS: iOSPlatformChannelSpecifics,
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
        0, 'Po Timer', '休憩が終わりました。再開しましょう📝', platformChannelSpecifics);
  }

  void _setNotification3() async {
    const IOSNotificationDetails iOSPlatformChannelSpecifics =
        IOSNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'channel_description',
      importance: Importance.high,
      priority: Priority.high,
    );
    NotificationDetails platformChannelSpecifics = const NotificationDetails(
      iOS: iOSPlatformChannelSpecifics,
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
        0, 'Po Timer', '終了です、お疲れ様でした！🍅', platformChannelSpecifics);
  }

  @override
  Widget build(BuildContext context) {
    final double _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(title: Text('Po $_maxPo Sets 🚀')),
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '$_messageAbove',
                style: Theme.of(context).textTheme.headline6,
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Text('$_messageBelow',
                    style: Theme.of(context).textTheme.headline5),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Text(_timerString(_currentSeconds),
                    style: const TextStyle(fontFamily: 'Roboto', fontSize: 60)),
              ),
              Container(
                margin: const EdgeInsets.only(top: 40),
                alignment: Alignment.centerLeft,
                height: 4,
                width: double.infinity,
                child: Column(children: <Widget>[
                  Container(
                    height: 1,
                    width: _deviceWidth * _remainingTimeRatio,
                    color: Colors.lightGreen,
                  ),
                  Container(
                    height: 3,
                    width: _deviceWidth * _remainingTimeRatio,
                    color: Colors.black,
                  ),
                ]),
              ),
              Container(
                margin: const EdgeInsets.only(top: 50),
                child: OutlinedButton(
                  child: const Text('Quit'),
                  onPressed: _goBack,
                ),
              )
            ],
          ),
        ));
  }

  void _goBack() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    _maxPo = widget.maxPo;
    _messageAbove = '1 / $_maxPo';
    _currentBaseTime = _poTime;
    _currentSeconds = _poTime;
    _timer = _countTimer();
  }

  @override
  void dispose() {
    super.dispose();
    Wakelock.disable();
    _timer.cancel();
  }
}
