import 'package:flutter/material.dart';
import 'package:sapp/common/common.dart';
import 'package:sapp/common/component.dart';
import 'package:sapp/common/user.dart';
import 'package:sapp/services/user.dart';
import 'package:sapp/utils/color.dart';
import 'package:sapp/utils/common.dart';
import 'package:sapp/utils/constant.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends AbstractState<ForgotPasswordPage> {
  final usernameController = new TextEditingController();
  final passwordController = new TextEditingController();

  void initState() {
    super.initState();
    User.removeUserInfo();
  }

  submit() async {
    final username = emptyToNull(usernameController.text);
    var data = {
      'username': username,
    };
    showProgress();
    await UserService.forgotPassword(data).then((resp) async {
      showMessage(
          "Hệ thống đã gửi email cho bạn qua hộp thư đã đăng ký với SHOTEL. \nVui lòng làm theo hướng dẫn trong email để lấy lại mật khẩu.",
          5);
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
              border: OutlineInputBorder(),
              contentPadding: const EdgeInsets.all(12.0),
              labelStyle: TextStyle(fontSize: 15.0)),
          obscureText: isPassword,
          style: TextStyle(height: 1.0, color: Colors.black, fontSize: 14.0),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Stack(children: <Widget>[
          Center(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              children: <Widget>[
                SizedBox(height: 90.0),
                Icon(
                  Icons.lock_open,
                  size: 50.0,
                  color: Colors.grey,
                ),
                SizedBox(height: 60.0),
                Column(
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: _buildTextField(
                          'Tên đăng nhập', usernameController, false),
                    ),
                    SizedBox(height: 18.0),
                    new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        new Expanded(
                          child: new Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18.0),
                            child: RaisedButton(
                              child: Text(
                                'Lấy lại mật khẩu',
                                style: new TextStyle(fontSize: 15.0),
                              ),
                              textColor: Colors.white,
                              color: AppColors.primary,
                              onPressed: () {
                                submit();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 25.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      child: Text('Đăng nhập',
                          style: TextStyle(
                              fontSize: 15.0,
                              color: AppColors.info,
                              fontWeight: FontWeight.bold)),
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed('/login');
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
