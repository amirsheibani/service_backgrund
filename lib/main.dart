import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:service_background/src/global.dart';
import 'package:service_background/src/pages/home_page.dart';
import 'package:service_background/src/theme/theme.dart';
import 'package:service_background/src/theme/theme_notifier.dart';
import 'package:service_background/src/utils/utility.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

void main() async{
  HttpOverrides.global = new MyHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations( Device.get().isPhone ?
  [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown,] :
  [DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]
  ).then((_) async {
    var path = await getApplicationDocumentsDirectory();
    Hive.init(path.path);
  });
  SharedPreferences.getInstance().then((prefs) {
    Global.darkMode = prefs.getBool('darkMode') ?? false;
    runApp(
      ChangeNotifierProvider<ThemeNotifier>(
        create: (_) => ThemeNotifier(Global.darkMode ? darkTheme : lightTheme),
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const MethodChannel _platform = const MethodChannel('com.amirsheibani.service_background');
  Key key = new UniqueKey();

  void restartApp() {
    this.setState(() {
      key = new UniqueKey();
    });
  }
  var routes = <String, WidgetBuilder>{
    Routes.SPLASH: (BuildContext context) => HomePage(),
  };

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    startServiceInBackground(minimumLatency: 60000,deadline : 60000);
    return MaterialApp(
      key: key,
      title: 'Empty Project',
      debugShowCheckedModeBanner: false,
      theme: themeNotifier.getTheme(),
      routes: routes,
    );
  }


  @override
  void initState() {
    _platform.setMethodCallHandler(_platformCallHandler);
    super.initState();
  }

  Future<dynamic> _platformCallHandler(MethodCall call) async {
    switch (call.method) {
      case 'runMe':
        print('call callMe : time = ${DateTime.now()}');
        return Future.value('called from platform!');
    //return Future.error('error message!!');
      default:
        print('Unknowm method ${call.method}');
        throw MissingPluginException();
        break;
    }
  }

  void startServiceInBackground({int minimumLatency,int deadline}) async {
    if(Platform.isAndroid){
      var methodChannel = MethodChannel('com.amirsheibani.service_background');
      var arguments = {};
      if(minimumLatency != null){
        arguments['minimumLatency'] = '$minimumLatency';
      }
      if(deadline != null){
        arguments['deadline'] = '$deadline';
      }
      String data = await methodChannel.invokeMethod('startBackgroundService',arguments);
      debugPrint(data);
    }
  }

}
class Routes {
  static const String SPLASH = "/";
  static const String HOME = "/home";
  static const String SETTING = "/setting";
}

