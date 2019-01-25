import 'package:flutter/material.dart';
import 'package:sapp/common/common.dart';
import 'package:sapp/common/component.dart';
import 'package:sapp/common/transition.dart';
import 'package:sapp/screens/roomtype/roomtype_entry.dart';
import 'package:sapp/services/roomtype.dart';
import 'package:sapp/utils/common.dart';
import 'package:sapp/utils/constant.dart';

class RoomTypePage extends StatefulWidget {
  @override
  _RoomTypePageState createState() => _RoomTypePageState();
}

class _RoomTypePageState extends AbstractState<RoomTypePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  List<dynamic> list = new List<dynamic>();

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    showProgress();
    var result = await RoomTypeService.getList().catchError((error) {
      showErrorMessage(error);
    });
    if (result != null) {
      setState(() {
        list = result['roomTypes'];
        list.sort(sortPriority);
      });
    }
    hideLoading();
    hideProgress();
    return result;
  }

  redirectEntry(Mode mode, dynamic data) {
    Navigator.of(context)
        .push(SlideRoute(
      builder: (_) => Scaffold(
              body: RoomTypeEntry(
            mode: mode,
            data: data,
          )),
    ))
        .then((result) {
      if (result['reload']) {
        getData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        title: new Text("Loại phòng"),
        leading: BackButton(),
      ),
      floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.add),
          onPressed: () {
            redirectEntry(Mode.create, null);
          }),
      body: MainStack(
        isLoading: isLoading,
        child: Stack(
          children: <Widget>[
            ListView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  dynamic item = list[index];
                  return new InkWell(
                    child: Container(
                      child: ListTile(
                        title: new Text(item["name"]),
                        leading: CircleAvatar(
                          child: Text((index + 1).toString()),
                          radius: 15.0,
                        ),
                      ),
                      decoration: BoxDecoration(
                          border: new Border(
                              bottom: BorderSide(
                                  color: Colors.grey[300], width: 0.5))),
                    ),
                    onTap: () {
                      redirectEntry(Mode.update, item);
                    },
                  );
                }),
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
