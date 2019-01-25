import 'package:flutter/material.dart';
import 'package:sapp/common/common.dart';
import 'package:sapp/common/component.dart';
import 'package:sapp/services/user.dart';
import 'package:sapp/utils/common.dart';
import 'package:sapp/utils/constant.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends AbstractState<ChangePasswordPage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController passwordController = new TextEditingController();
  TextEditingController newPasswordController = new TextEditingController();
  TextEditingController reNewPasswordController = new TextEditingController();

  changePassword() {
    var data = {};
    data['password'] = emptyToNull(passwordController.text);
    data['newPassword'] = emptyToNull(newPasswordController.text);
    data['reNewPassword'] = emptyToNull(reNewPasswordController.text);
    UserService.changePassword(data).then((data) async{
      showMessage(Constants.changePasswordSuccess);
      await new Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacementNamed(context, "/login");
    }).catchError((error){
      showErrorMessage(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              changePassword();
            },
          )
        ],
        title: Text('Đổi mật khẩu'),
      ),
      body: Stack(
        children: <Widget>[
          ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 30.0),
                    Icon(
                      Icons.vpn_key,
                      size: 45.0,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 30.0),
                    new Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: buildTextPassword(
                          'Mật khẩu cũ', passwordController, true),
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: buildTextPassword(
                          'Mật khẩu mới', newPasswordController, true),
                    ),
                    new Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: buildTextPassword('Xác nhận mật khẩu mới',
                          reNewPasswordController, true),
                    ),
                  ],
                ),
              )
            ],
          ),
          ProgressBar(
            visible: isProgress,
            top: 0.0,
          )
        ],
      ),
    );
  }
}
