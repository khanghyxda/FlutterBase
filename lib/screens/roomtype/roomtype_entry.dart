import 'package:flutter/material.dart';
import 'package:sapp/common/common.dart';
import 'package:sapp/services/roomtype.dart';
import 'package:sapp/utils/constant.dart';
import 'package:sapp/utils/convert.dart';

class RoomTypeEntry extends StatefulWidget {
  RoomTypeEntry({Key key, this.mode, this.data});

  final Mode mode;

  final dynamic data;

  @override
  _RoomTypeEntryState createState() => _RoomTypeEntryState();
}

class _RoomTypeEntryState extends AbstractState<RoomTypeEntry> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  final nameController = new TextEditingController();
  final descriptionController = new TextEditingController();
  final priorityController = new TextEditingController();
  int roomTypeId = 0;
  bool reload = false;

  @override
  void initState() {
    super.initState();
    if (widget.mode == Mode.update) {
      initData();
    }
  }

  initData() {
    nameController.text = widget.data['name'];
    descriptionController.text = widget.data['description'];
    priorityController.text = convertIntNull(widget.data['priority']);
    roomTypeId = widget.data['roomTypeId'];
  }

  delete() {
    showYesNo(Constants.deleteConfirm).then((value) {
      if (value) {
        RoomTypeService.delete(roomTypeId).then((resp) {
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
    if (widget.mode == Mode.update) {
      data['roomTypeId'] = roomTypeId;
      RoomTypeService.update(data).then((resp) {
        showMessage(Constants.updateSuccess);
        reload = true;
      }).catchError((error) {
        showErrorMessage(error);
      });
    } else {
      RoomTypeService.create(data).then((resp) {
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
              buildText('Tên loại phòng', nameController, true),
              SizedBox(
                height: 15.0,
              ),
              buildText('Mô tả', descriptionController, true),
              SizedBox(
                height: 15.0,
              ),
              buildTextNumber('Ưu tiên hiển thị', priorityController, true),
            ],
          ),
        ));
  }
}
