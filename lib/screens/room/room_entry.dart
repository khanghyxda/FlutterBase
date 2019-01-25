import 'package:flutter/material.dart';
import 'package:sapp/common/common.dart';
import 'package:sapp/services/room.dart';
import 'package:sapp/utils/color.dart';
import 'package:sapp/utils/constant.dart';
import 'package:sapp/utils/convert.dart';

class RoomEntry extends StatefulWidget {
  RoomEntry({Key key, this.mode, this.data, this.ruleList, this.roomTypeList});

  final Mode mode;

  final dynamic data;

  final List ruleList;

  final List roomTypeList;

  @override
  _RoomEntryState createState() => _RoomEntryState();
}

class _RoomEntryState extends AbstractState<RoomEntry> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  final nameController = new TextEditingController();
  final descriptionController = new TextEditingController();
  final priorityController = new TextEditingController();
  int roomId = 0;
  int type;
  int ruleId;
  bool reload = false;

  List<DropdownMenuItem<int>> listType = [];
  List<DropdownMenuItem<int>> listRule = [];

  @override
  void initState() {
    super.initState();
    if (widget.mode == Mode.update) {
      initData();
    }
    widget.roomTypeList.forEach((obj) {
      listType.add(new DropdownMenuItem(
          child: Text(obj['name'].toString()), value: obj['roomTypeId']));
    });
    widget.ruleList.forEach((obj) {
      listRule.add(new DropdownMenuItem(
          child: Text(obj['name'].toString()), value: obj['ruleId']));
    });
  }

  initData() {
    nameController.text = widget.data['name'];
    descriptionController.text = widget.data['description'];
    priorityController.text = convertIntNull(widget.data['priority']);
    type = widget.data['type'];
    ruleId = widget.data['ruleId'];
    roomId = widget.data['roomId'];
  }

  delete() {
    showYesNo(Constants.deleteConfirm).then((value) {
      if (value) {
        RoomService.delete(roomId).then((resp) {
          showMessage(Constants.deleteSuccess);
          Navigator.pop(context, {'reload': true});
        }).catchError((error) {
          showErrorMessage(error);
        });
      }
    });
  }

  save() {
    var data = {};
    data['name'] = nameController.text;
    data['description'] = descriptionController.text;
    data['priority'] = priorityController.text;
    data['type'] = type;
    data['ruleId'] = ruleId;
    if (widget.mode == Mode.update) {
      data['roomId'] = roomId;
      RoomService.update(data).then((resp) {
        showMessage(Constants.updateSuccess);
        reload = true;
      }).catchError((error) {
        showErrorMessage(error);
      });
    } else {
      RoomService.create(data).then((resp) {
        showMessage(Constants.insertSuccess);
        reload = true;
      }).catchError((error) {
        showErrorMessage(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomPadding: false,
        appBar: new AppBar(
          title:
              new Text(widget.mode == Mode.update ? "Chỉnh sửa" : "Thêm mới"),
          leading: new IconButton(
            icon: BackButtonIcon(),
            onPressed: () {
              Navigator.pop(context, {'reload': reload});
            },
          ),
          actions: <Widget>[
            widget.mode == Mode.update
                ? new IconButton(
                    icon: new Icon(Icons.delete),
                    onPressed: () {
                      delete();
                    },
                  )
                : new Container(),
            new IconButton(
              icon: new Icon(Icons.save),
              onPressed: () {
                save();
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 5.0,
              ),
              buildText('Tên phòng', nameController, true),
              Row(
                children: <Widget>[
                  Icon(Icons.spa, color: AppColors.warning, size: 22.0),
                  SizedBox(
                    width: 5.0,
                  ),
                  Expanded(
                    child: DropdownButton<int>(
                      value: type,
                      items: listType,
                      iconSize: 30.0,
                      isExpanded: true,
                      hint: Text(
                        'Loại phòng',
                      ),
                      onChanged: (value) {
                        setState(() {
                          type = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Icon(Icons.memory, color: AppColors.primary, size: 22.0),
                  SizedBox(
                    width: 5.0,
                  ),
                  Expanded(
                    child: DropdownButton<int>(
                      value: ruleId,
                      items: listRule,
                      iconSize: 30.0,
                      isExpanded: true,
                      hint: Text(
                        'Cách tính tiền',
                      ),
                      onChanged: (value) {
                        setState(() {
                          ruleId = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5.0,
              ),
              buildText('Mô tả', descriptionController, true),
              SizedBox(
                height: 15.0,
              ),
              buildTextNumber('Ưu tiên hiển thị', priorityController, true),
              widget.roomTypeList.length == 0
                  ? Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.warning, color: Colors.red, size: 22.0),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text("Bạn chưa tạo loại phòng")
                        ],
                      ),
                    )
                  : Container(),
              widget.ruleList.length == 0
                  ? Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.warning, color: Colors.red, size: 22.0),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text("Bạn chưa tạo cách tính tiền")
                        ],
                      ),
                    )
                  : Container()
            ],
          ),
        ));
  }
}
