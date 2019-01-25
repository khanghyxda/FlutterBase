import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sapp/common/common.dart';
import 'package:sapp/common/component.dart';
import 'package:sapp/common/transition.dart';
import 'package:sapp/screens/account/change_password.dart';
import 'package:sapp/screens/drawer/drawer.dart';
import 'package:sapp/services/role.dart';
import 'package:sapp/services/user.dart';
import 'package:sapp/utils/date.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends AbstractState<AccountPage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  String name = '';
  String type = '';
  String lastActivity = '';
  String registerDate = '';
  String validDate = '';
  List roles = new List();
  dynamic userInfo;
  dynamic userRoles;
  dynamic hotel;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    showProgress();
    var getRoles = RoleService.getList();
    var getUserInfo = UserService.getInfo();
    var results =
        await Future.wait([getRoles, getUserInfo]).catchError((error) {
      showErrorMessage(error);
    });
    if (results != null) {
      setState(() {
        roles = results[0]['roles'];
        userInfo = results[1]['user'];
        userRoles = results[1]['userRoles'];
        hotel = results[1]['hotel'];
        name = userInfo['username'];
        type = 'Tài khoản chính';
        if (userInfo['mainUserId'] != userInfo['userId']) {
          type = 'Tài khoản phụ';
        }
        lastActivity = DT.dateToString(
            DateTime.parse(userInfo['lastActivity']), DT.timeToSecond);
        registerDate = DT.dateToString(
            DateTime.parse(userInfo['createdAt']), DT.timeToSecond);
        validDate = DT.dateToString(
            DateTime.parse(hotel['validDate']), DT.formatDate);
      });
    }
    hideLoading();
    hideProgress();
    return results;
  }

  getStatusCheckbox(roleId) {
    if (userInfo['mainUserId'] == userInfo['userId']) {
      return true;
    }
    var hasRole = false;
    userRoles.forEach((role) {
      if (role['roleId'] == roleId) {
        hasRole = true;
      }
    });
    return hasRole;
  }

  Future<Null> onRefresh() {
    Completer<Null> completer = new Completer<Null>();
    getData().then((results) {
      return completer.complete();
    });
    return completer.future;
  }

  Widget renderRole() {
    return Column(
      children: <Widget>[
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                  child: Icon(
                    Icons.settings,
                    color: Colors.grey,
                  ),
                  width: 60.0,
                  padding: EdgeInsets.only(top: 10.0),
                  alignment: Alignment.topCenter),
              Expanded(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: roles.map((role) {
                      return Row(
                        children: <Widget>[
                          Checkbox(
                            value: getStatusCheckbox(role['roleId']),
                            onChanged: (value) {},
                            activeColor: Colors.pink[300],
                          ),
                          Text(role['name'])
                        ],
                      );
                    }).toList()),
              )
            ],
          ),
        ),
        Divider(
          height: 1.0,
        )
      ],
    );
  }

  Widget buildRow(name, info, icon) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              child: Icon(
                icon,
                color: Colors.grey,
              ),
              width: 60.0,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(name,
                              style: TextStyle(
                                  fontSize: 14.0, color: Colors.grey)),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 4.0, bottom: 10.0),
                          child: Text(
                            info,
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        Divider(
          height: 1.0,
        )
      ],
    );
  }

  redirectChangePassword() {
    Navigator.push(
        context,
        SlideRoute(
          builder: (context) => Scaffold(
                body: ChangePasswordPage(),
              ),
        )).then((result) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            scaffoldKey.currentState.openDrawer();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.vpn_key),
            onPressed: () {
              redirectChangePassword();
            },
          )
        ],
        title: Text('Thông tin tài khoản'),
      ),
      drawer: DrawerPage(),
      body: MainStack(
        isLoading: isLoading,
        child: Stack(
          children: <Widget>[
            RefreshIndicator(
              onRefresh: onRefresh,
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  buildRow('Tên tài khoản', name, Icons.account_circle),
                  buildRow('Loại tài khoản', type, Icons.person),
                  renderRole(),
                  buildRow('Ngày hết hạn', validDate, Icons.timer),
                  buildRow('Đăng nhập gần nhất', lastActivity, Icons.input),
                  buildRow('Thời gian tạo tài khoản', registerDate, Icons.create),
                ],
              ),
            ),
            ProgressBar(
              visible: isProgress,
              top: 0.0,
            )
          ],
        ),
      ),
    );
  }
}
