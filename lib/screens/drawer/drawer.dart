import 'package:flutter/material.dart';
import 'package:sapp/common/user.dart';
import 'package:sapp/utils/network.dart';

class DrawerPage extends StatelessWidget {
  DrawerPage({Key key}) : super(key: key);

  final itemList = [
    DrawerItem('Trang chính', Icons.home, '/home', ['USER']),
    DrawerItem('Thuê - trả phòng', Icons.sync, '/rent', ['RENT']),
    // DrawerItem('Quản lý kho', Icons.data_usage, '/inventory', ['INVENTORY']),
    DrawerItem('Quản lý hệ thống', Icons.settings, '/manager',
        ['MASTER', 'HISTORY', 'REPORT', 'SETTING']),
    DrawerItem('Tài khoản', Icons.account_circle, '/account', ['USER']),
    DrawerItem('Đăng xuất', Icons.power_settings_new, '/login', ['USER']),
  ];

  List filterItem() {
    var itemReturn = [];
    itemList.forEach((item) {
      if (Session.hasRole(item.roles)) {
        itemReturn.add((item));
      }
    });
    return itemReturn;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> renderItem() {
      var listItem = new List<Widget>();
      filterItem().forEach((item) {
        listItem.add(ListTile(
            title: Text(item.text),
            leading: Icon(
              item.icon,
              color: Colors.blue,
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(item.link);
              if (item.link == '/login') {
                User.removeUserInfo();
              }
            }));
        listItem.add(Divider(height: 1.0));
      });
      return listItem;
    }

    Widget renderHeader() {
      return DrawerHeader(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 25.0,
                // child: Image.asset('assets/logo.png'),
                child: Icon(
                  Icons.business,
                  size: 50.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 3.0),
              child: Text(
                Session.userInfo.username,
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        decoration: BoxDecoration(
            color: Colors.blueAccent[100],
            image: DecorationImage(
                image: AssetImage('assets/background.jpg'), fit: BoxFit.fill)),
      );
    }

    List<Widget> renderPage() {
      var list = new List<Widget>();
      list.add(renderHeader());
      list.addAll(renderItem());
      return list;
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: renderPage(),
      ),
    );
  }
}

class DrawerItem {
  DrawerItem(text, icon, link, roles) {
    this.text = text;
    this.icon = icon;
    this.link = link;
    this.roles = roles;
  }

  String text;

  IconData icon;

  String link;

  List<String> roles;
}
