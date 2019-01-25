import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sapp/common/common.dart';
import 'package:sapp/common/component.dart';
import 'package:sapp/common/transition.dart';
import 'package:sapp/common/user.dart';
import 'package:sapp/screens/account/account.dart';
import 'package:sapp/screens/home/home.dart';
import 'package:sapp/screens/manager/manager.dart';
import 'package:sapp/screens/room/room.dart';
import 'package:sapp/screens/roomtype/roomtype.dart';
import 'package:sapp/screens/rule/rule.dart';
import 'package:sapp/screens/user/forgot_password.dart';
import 'package:sapp/screens/user/login.dart';
import 'package:sapp/screens/user/register.dart';
import 'package:sapp/services/user.dart';
import 'package:sapp/utils/network.dart';
import 'package:sapp/utils/string.dart';

void main() => runApp(new SHotel());

class SHotel extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SHOTEL',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Scaffold(
        body: MainPage(),
      ),
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/main':
            return new FadeRoute(
              builder: (_) => new Scaffold(body: new MainPage()),
              settings: settings,
            );
          case '/login':
            return new FadeRoute(
              builder: (_) => new Scaffold(body: new LoginPage()),
              settings: settings,
            );
          case '/register':
            return new SlideRoute(
              builder: (_) => new Scaffold(body: new RegisterPage()),
              settings: settings,
            );
          case '/forgot_password':
            return new FadeRoute(
              builder: (_) => new Scaffold(body: new ForgotPasswordPage()),
              settings: settings,
            );
          case '/home':
            return new FadeRoute(
              builder: (_) => new Scaffold(body: new HomePage()),
              settings: settings,
            );
          case '/manager':
            return new FadeRoute(
              builder: (_) => new Scaffold(body: new ManagerPage()),
              settings: settings,
            );
          case '/account':
            return new FadeRoute(
              builder: (_) => new Scaffold(body: new AccountPage()),
              settings: settings,
            );
          case '/roomtype':
            return new FadeRoute(
              builder: (_) => new Scaffold(body: new RoomTypePage()),
              settings: settings,
            );
          case '/rule':
            return new FadeRoute(
              builder: (_) => new Scaffold(body: new RulePage()),
              settings: settings,
            );
          case '/room':
            return new FadeRoute(
              builder: (_) => new Scaffold(body: new RoomPage()),
              settings: settings,
            );
        }
      },
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('vi', 'VN'),
      ],
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => new _MainPageState();
}

class _MainPageState extends AbstractState<MainPage> {
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    checkNetwork();
  }

  checkNetwork() async {
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      showMessage('Không có kết nối mạng.', 5);
      setState(() {
        hasError = true;
      });
    } else {
      init();
    }
  }

  init() async {
    String username = await User.getUserName();
    String password = await User.getPassword();
    if (username != null && password != null) {
      UserService.login(username, password).then((resp) async {
        var roles = Str.toListString(resp['roles']);
        await User.setUserInfo(username, password);
        Session.userInfo = new UserInfo(username, password,
            resp['userInfo']['userId'], resp['userInfo']['mainUserId'], roles);
        Session.token = resp['token'];
        if (Session.hasRole(['RENT'])) {
          Navigator.of(context).pushReplacementNamed('/home');
        } else {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      }).catchError((error) {
        Navigator.of(context).pushReplacementNamed('/login');
      });
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: hasError
          ? new Container(
              child: Column(
                children: <Widget>[
                  new Center(
                    child: new IconButton(
                      onPressed: () {
                        checkNetwork();
                      },
                      icon: new Icon(
                        Icons.refresh,
                        color: Colors.blueAccent,
                      ),
                    ),
                  )
                ],
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            )
          : LogoAnimation(),
    );
  }
}
