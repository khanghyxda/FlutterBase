import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sapp/common/common.dart';
import 'package:sapp/common/component.dart';
import 'package:sapp/common/user.dart';
import 'package:sapp/services/user.dart';
import 'package:sapp/utils/color.dart';
import 'package:sapp/utils/common.dart';
import 'package:sapp/utils/network.dart';
import 'package:sapp/utils/string.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends AbstractState<RegisterPage> {
  final usernameController = new TextEditingController();
  final emailController = new TextEditingController();
  final passwordController = new TextEditingController();
  final rePasswordController = new TextEditingController();

  void initState() {
    super.initState();
    User.removeUserInfo();
  }

  register() async {
    final username = emptyToNull(usernameController.text);
    final password = emptyToNull(passwordController.text);
    var data = {
      'username': username,
      'email': emptyToNull(emailController.text),
      'password': password,
      'repassword': emptyToNull(rePasswordController.text),
      'isMobile': true
    };
    showProgress();
    await UserService.register(data).then((resp) async {
      var roles = Str.toListString(resp['roles']);
      await User.setUserInfo(username, password);
      Session.userInfo = new UserInfo(username, password,
          resp['userInfo']['userId'], resp['userInfo']['mainUserId'], roles);
      Session.token = resp['token'];
      Navigator.of(context).pushReplacementNamed('/manager');
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
      primary: false,
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Stack(children: <Widget>[
          Platform.isAndroid
              ? Container(
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 18.0),
                            child: _buildTextField(
                                'Tên đăng nhập', usernameController, false),
                          ),
                          SizedBox(height: 18.0),
                          new Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 18.0),
                            child: _buildTextField(
                                'Email', emailController, false),
                          ),
                          SizedBox(height: 18.0),
                          new Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 18.0),
                            child: _buildTextField(
                                'Mật khẩu', passwordController, true),
                          ),
                          SizedBox(height: 18.0),
                          new Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 18.0),
                            child: _buildTextField('Xác nhận mật khẩu',
                                rePasswordController, true),
                          ),
                          SizedBox(height: 18.0),
                          new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              new Expanded(
                                child: new Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18.0),
                                  child: RaisedButton(
                                    child: Text(
                                      'Đăng ký',
                                      style: new TextStyle(fontSize: 15.0),
                                    ),
                                    textColor: Colors.white,
                                    color: AppColors.warning,
                                    onPressed: () {
                                      register();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Image.asset(
                          'assets/logo.png',
                          width: 60.0,
                          height: 60.0,
                        ),
                        SizedBox(
                          height: 50.0,
                        ),
                        Text(
                          "Do điều khoản ứng dụng của Apple nên SHOTEL bị hạn chế chức năng đăng ký.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15.0),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "Bạn sử dụng thiết bị iOS vui lòng đăng ký tại trang chủ SHOTEL để có thể sử dụng dịch vụ.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15.0),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          "Xin lỗi vì sự bất tiện này.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 15.0),
                        ),
                      ],
                    ),
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
