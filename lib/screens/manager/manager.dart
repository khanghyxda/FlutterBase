import 'package:flutter/material.dart';
import 'package:sapp/common/common.dart';
import 'package:sapp/screens/drawer/drawer.dart';
import 'package:sapp/utils/color.dart';
import 'package:sapp/utils/network.dart';

class ManagerPage extends StatefulWidget {
  @override
  _ManagerPageState createState() => _ManagerPageState();
}

class _ManagerPageState extends AbstractState<ManagerPage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  final menuList = [
    MenuItem('Cách tính tiền', Icons.memory, AppColors.primary, '/rule',
        ['MASTER']),
    MenuItem(
        'Loại phòng', Icons.spa, AppColors.warning, '/roomtype', ['MASTER']),
    MenuItem('Phòng', Icons.hotel, AppColors.info, '/room', ['MASTER']),
    MenuItem('Menu', Icons.restaurant, AppColors.danger, '/menu', ['MASTER']),
    MenuItem('Lịch sử', Icons.history, AppColors.success, '/history', ['HISTORY']),
    MenuItem('Thống kê', Icons.equalizer, Colors.amber, '/report', ['REPORT']),
    // MenuItem('Tài khoản phụ', Icons.supervised_user_circle, AppColors.primary, '/usersub', ['MAIN']),
  ];

  List filterItem() {
    var itemReturn = [];
    menuList.forEach((item) {
      if (Session.hasRole(item.roles)) {
        itemReturn.add((item));
      }
    });
    return itemReturn;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width / 2;
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              scaffoldKey.currentState.openDrawer();
            },
          ),
          title: Text('Quản lý hệ thống'),
        ),
        drawer: DrawerPage(),
        body: Center(
          child: Container(
            padding: const EdgeInsets.only(right: 10.0, left: 10.0, top: 10.0),
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: (width / 125),
              children: filterItem().map((menu) {
                return InkWell(
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Center(
                            child: Icon(
                              menu.icon,
                              size: 35.0,
                              color: menu.color,
                            ),
                          ),
                        ),
                        Container(
                          child: Center(
                            child: Text(
                              menu.text,
                              style:
                                  TextStyle(fontSize: 15.0, color: Colors.grey),
                            ),
                          ),
                          height: 30.0,
                        ),
                        SizedBox(
                          height: 10.0,
                        )
                      ],
                    ),
                  ),
                  onTap: (){
                    Navigator.of(context).pushNamed(menu.link);
                  },
                );
              }).toList(),
            ),
          ),
        ));
  }
}

class MenuItem {
  MenuItem(text, icon, color, link, roles) {
    this.text = text;
    this.icon = icon;
    this.color = color;
    this.link = link;
    this.roles = roles;
  }

  String text;

  IconData icon;

  Color color;

  String link;

  List<String> roles;
}
