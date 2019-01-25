import 'package:flutter/material.dart';
import 'package:sapp/common/common.dart';
import 'package:sapp/common/component.dart';
import 'package:sapp/common/transition.dart';
import 'package:sapp/screens/room/room_entry.dart';
import 'package:sapp/services/master.dart';
import 'package:sapp/services/room.dart';
import 'package:sapp/utils/color.dart';
import 'package:sapp/utils/common.dart';
import 'package:sapp/utils/constant.dart';

class RoomPage extends StatefulWidget {
  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends AbstractState<RoomPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  List<dynamic> list = new List<dynamic>();
  List<dynamic> listDisplay = new List<dynamic>();
  List<PopupMenuModel> choices = [
    PopupMenuModel('Tất cả', 0),
  ];
  int selectedValue = 0;

  dynamic ruleListObj;
  dynamic roomTypeListObj;

  List ruleList;
  List roomTypeList;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    showProgress();
    Future getRooms = RoomService.getList();
    Future getMaster = MasterService.getInfo();
    var results = await Future.wait([getMaster, getRooms]).catchError((error) {
      showErrorMessage(error);
    });
    if (results != null) {
      ruleList = results[0]['rules'];
      ruleListObj = arrayToObj(ruleList, 'ruleId');
      roomTypeList = results[0]['roomTypes'];
      roomTypeListObj = arrayToObj(roomTypeList, 'roomTypeId');
      List data = results[1]['rooms'];
      List dataRoom = data.map((room) {
        var obj = room;
        room['roomTypeInfo'] = roomTypeListObj[room['type']] ?? {};
        room['ruleInfo'] = ruleListObj[room['ruleId']] ?? {};
        return obj;
      }).toList();
      roomTypeList.forEach((roomType) {
        choices.add(PopupMenuModel(roomType['name'], roomType['roomTypeId']));
      });
      dataRoom.sort(sortPriority);
      setState(() {
        list = dataRoom;
        listDisplay = list.where((o) => o['type'] == selectedValue || selectedValue == 0).toList();
      });
    }
    hideLoading();
    hideProgress();
    return results;
  }

  redirectEntry(Mode mode, dynamic data) {
    Navigator.of(context)
        .push(SlideRoute(
      builder: (_) => Scaffold(
              body: RoomEntry(
            mode: mode,
            data: data,
            ruleList: ruleList,
            roomTypeList: roomTypeList,
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
        title: new Text("Phòng"),
        leading: BackButton(),
        actions: <Widget>[
          PopupMenuCommon(
            choices: choices,
            value: selectedValue,
            onSelected: (choice) {
              setState(() {
                selectedValue = choice.value;
                listDisplay = list.where((o) => o['type'] == selectedValue || selectedValue == 0).toList();
              });
            },
          ),
        ],
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
                itemCount: listDisplay.length,
                itemBuilder: (BuildContext context, int index) {
                  dynamic item = listDisplay[index];
                  return new InkWell(
                    child: Container(
                      child: ListTile(
                        title: new Text(item["name"]),
                        leading: CircleAvatar(
                          child: Text((index + 1).toString()),
                          radius: 15.0,
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.spa,
                                  color: AppColors.warning, size: 22.0),
                              SizedBox(
                                width: 3.0,
                              ),
                              Expanded(
                                child: Text(item['roomTypeInfo']['name'] ?? ""),
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Icon(Icons.memory,
                                  color: AppColors.primary, size: 22.0),
                              SizedBox(
                                width: 3.0,
                              ),
                              Expanded(
                                child: Text(item['ruleInfo']['name'] ?? ""),
                              ),
                            ],
                          ),
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
