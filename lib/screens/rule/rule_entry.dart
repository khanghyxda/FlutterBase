import 'package:flutter/material.dart';
import 'package:sapp/common/common.dart';
import 'package:sapp/common/component.dart';
import 'package:sapp/services/rule.dart';
import 'package:sapp/utils/common.dart';
import 'package:sapp/utils/constant.dart';
import 'package:sapp/utils/convert.dart';
import 'package:sapp/utils/date.dart';

class RuleEntry extends StatefulWidget {
  RuleEntry({Key key, this.mode, this.data});

  final Mode mode;

  final dynamic data;

  @override
  _RuleEntryState createState() => _RuleEntryState();
}

class _RuleEntryState extends AbstractState<RuleEntry> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  final nameController = new TextEditingController();
  final ghController = new TextEditingController();
  final gM1Controller = new TextEditingController();
  final gM2Controller = new TextEditingController();
  final qdStController = new TextEditingController();
  final qdEtController = new TextEditingController();
  final qdMController = new TextEditingController();
  final nStController = new TextEditingController();
  final nEtController = new TextEditingController();
  final nmController = new TextEditingController();
  final ptMController = new TextEditingController();
  int ruleId = 0;
  bool reload = false;

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() {
    if (widget.mode == Mode.update) {
      nameController.text = widget.data['name'];
      ghController.text = widget.data['gh'].toString();
      gM1Controller.text = widget.data['gM1'].toString();
      gM2Controller.text = widget.data['gM2'].toString();
      qdStController.text = widget.data['qdSt'].toString();
      qdEtController.text = widget.data['qdEt'].toString();
      qdMController.text = widget.data['qdM'].toString();
      nStController.text = widget.data['nSt'].toString();
      nEtController.text = widget.data['nEt'].toString();
      nmController.text = widget.data['nm'].toString();
      ptMController.text = widget.data['ptM'].toString();
      ruleId = widget.data['ruleId'];
    } else {
      ghController.text = 2.toString();
      gM1Controller.text = 80.toString();
      gM2Controller.text = 20.toString();
      qdMController.text = 150.toString();
      qdStController.text = '20:00';
      qdEtController.text = '09:00';
      nmController.text = 250.toString();
      nStController.text = '12:00';
      nEtController.text = '12:00';
      ptMController.text = 10.toString();
    }
  }

  delete() {
    showYesNo(Constants.deleteConfirm).then((value) {
      if (value) {
        RuleService.delete(ruleId).then((resp) {
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
    data['gh'] = ghController.text;
    data['gM1'] = gM1Controller.text;
    data['gM2'] = gM2Controller.text;
    data['qdM'] = qdMController.text;
    data['qdSt'] = qdStController.text;
    data['qdEt'] = qdEtController.text;
    data['nm'] = nmController.text;
    data['nSt'] = nStController.text;
    data['nEt'] = nEtController.text;
    data['ptM'] = ptMController.text;
    if (widget.mode == Mode.update) {
      data['ruleId'] = ruleId;
      RuleService.update(data).then((resp) {
        showMessage(Constants.updateSuccess);
        reload = true;
      }).catchError((error) {
        showErrorMessage(error);
      });
    } else {
      RuleService.create(data).then((resp) {
        showMessage(Constants.insertSuccess);
        reload = true;
      }).catchError((error) {
        showErrorMessage(error);
      });
    }
  }

  showTime(TextEditingController controller) {
    showTimePicker(
            context: context,
            initialTime: new TimeOfDay(
                hour: int.parse(controller.text.substring(0, 2)),
                minute: int.parse(controller.text.substring(3, 5))))
        .then((time) {
      if (time != null) {
        controller.text = time.hour.toString().padLeft(2, '0') +
            ':' +
            time.minute.toString().padLeft(2, '0');
      }
    });
  }

  Widget buildRowTime(String inputName, TextEditingController controller) {
    return Row(
      children: <Widget>[
        Expanded(
          child: buildText(inputName, controller, false),
        ),
        SizedBox(
          width: 30.0,
          height: 20.0,
          child: IconButton(
            icon: new Icon(Icons.timer),
            color: Colors.blueAccent,
            iconSize: 28.0,
            onPressed: () {
              showTime(controller);
            },
            padding: const EdgeInsets.only(left: 5.0),
          ),
        ),
      ],
    );
  }

  InputDecoration decorationTextFieldMoneyTime(String label, String dram) {
    return new InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: new BorderSide(width: 0.5, color: Colors.grey)),
        contentPadding: const EdgeInsets.all(12.0),
        labelText: label,
        labelStyle: new TextStyle(fontSize: 16.0),
        suffixText: dram);
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
            shrinkWrap: true,
            children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: buildText('Tên cách tính', nameController, true),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Row(
                      children: <Widget>[
                        getIconType(1, 25.0),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text("Thuê theo giờ")
                      ],
                    ),
                  ),
                  buildTextNumberSuffix("Block đầu", ghController, true, "Giờ"),
                  SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: buildTextMoney('Giá block đầu', gM1Controller),
                      ),
                      Container(
                        width: 10.0,
                      ),
                      Expanded(
                        child: buildTextMoney('Giá giờ sau', gM2Controller),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Row(
                      children: <Widget>[
                        getIconType(2, 25.0),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text("Thuê qua đêm")
                      ],
                    ),
                  ),
                  buildTextMoney('Giá qua đêm', qdMController),
                  SizedBox(
                    height: 15.0,
                  ),
                  buildRowTime('Giờ nhận phòng (QĐ)', qdStController),
                  SizedBox(
                    height: 15.0,
                  ),
                  buildRowTime('Giờ trả phòng (QĐ)', qdEtController),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Row(
                      children: <Widget>[
                        getIconType(3, 25.0),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text("Thuê theo ngày")
                      ],
                    ),
                  ),
                  buildTextMoney('Giá ngày', nmController),
                  SizedBox(
                    height: 15.0,
                  ),
                  buildRowTime('Giờ nhận phòng (Ngày)', nStController),
                  SizedBox(
                    height: 15.0,
                  ),
                  buildRowTime('Giờ trả phòng (Ngày)', nEtController),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.attach_money,
                          size: 25.0,
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text("Phụ thu")
                      ],
                    ),
                  ),
                  buildTextNumberSuffix(
                      "Phụ thu quá giờ", ptMController, true, '.000 ₫/giờ'),
                ],
              ),
            ],
          ),
        ));
  }
}
