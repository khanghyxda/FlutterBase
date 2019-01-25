import 'package:flutter/material.dart';
import 'package:sapp/common/common.dart';
import 'package:sapp/common/component.dart';
import 'package:sapp/common/user.dart';
import 'package:sapp/services/user.dart';
import 'package:sapp/utils/color.dart';
import 'package:sapp/utils/common.dart';
import 'package:sapp/utils/network.dart';
import 'package:sapp/utils/string.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends AbstractState<LoginPage> {
  final usernameController = new TextEditingController();
  final passwordController = new TextEditingController();

  void initState() {
    super.initState();
  }

  login() async {
    final username = emptyToNull(usernameController.text);
    final password = emptyToNull(passwordController.text);
    showProgress();
    await UserService.login(username, password).then((resp) async {
      var roles = Str.toListString(resp['roles']);
      await User.setUserInfo(username, password);
      Session.userInfo = new UserInfo(username, password,
          resp['userInfo']['userId'], resp['userInfo']['mainUserId'], roles);
      Session.token = resp['token'];
      if (Session.hasRole(['RENT'])) {
        Navigator.of(context).pushReplacementNamed('/rent');
      } else {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    }).catchError((error) {
      showErrorMessage(error);
    });
    hideProgress();
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildTextField(
        String label, TextEditingController controller, bool isPassword) {
      return Theme(
        data: Theme.of(context).copyWith(primaryColor: Colors.grey),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(2.0)),
              ),
              contentPadding: const EdgeInsets.all(12.0),
              labelStyle: TextStyle(fontSize: 15.0)),
          obscureText: isPassword,
          style: TextStyle(height: 1.0, color: Colors.black, fontSize: 14.0),
        ),
      );
    }

    return Scaffold(
      primary: false,
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Stack(children: <Widget>[
          Container(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              children: <Widget>[
                SizedBox(height: 90.0),
                Image.asset(
                  'assets/logo.png',
                  width: 60.0,
                  height: 60.0,
                ),
                SizedBox(height: 50.0),
                Column(
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: _buildTextField(
                          'Tên đăng nhập', usernameController, false),
                    ),
                    SizedBox(height: 18.0),
                    new Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child:
                          _buildTextField('Mật khẩu', passwordController, true),
                    ),
                    SizedBox(height: 18.0),
                    new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        new Expanded(
                          child: new Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 18.0),
                            child: RaisedButton(
                              child: Text(
                                'Đăng nhập',
                                style: new TextStyle(fontSize: 15.0),
                              ),
                              textColor: Colors.white,
                              color: Theme.of(context).accentColor,
                              onPressed: () {
                                login();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Bạn chưa có tài khoản?',
                        style: TextStyle(fontSize: 15.0)),
                    GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('Đăng ký',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 15.0,
                                color: AppColors.warning,
                                fontWeight: FontWeight.bold)),
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed('/register');
                      },
                    ),
                  ],
                ),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      child: Text('Quên mật khẩu?',
                          style: TextStyle(
                              fontSize: 15.0,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold)),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed('/forgot_password');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          ProgressBar(
            visible: isProgress,
            top: 0.0,
          )
        ]),
      ),
    );
  }
}
