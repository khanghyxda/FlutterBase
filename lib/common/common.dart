import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sapp/common/component.dart';
import 'package:sapp/utils/date.dart';
import 'package:sapp/utils/string.dart';

abstract class AbstractState<T extends StatefulWidget> extends State<T> {
  bool isProgress = false;

  bool isLoading = true;

  bool isSubmit = false;

  bool isShowBottomSheet = false;

  @override
  void initState() {
    super.initState();
    connectivity();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void resumeCallback() {}

  void showProgress() {
    setState(() {
      isProgress = true;
    });
  }

  void hideProgress() {
    setState(() {
      isProgress = false;
    });
  }

  void showLoading() {
    setState(() {
      isLoading = true;
    });
  }

  void hideLoading() {
    setState(() {
      isLoading = false;
    });
  }

  void setSubmit(value) {
    setState(() {
      isSubmit = value;
    });
  }

  void setShowBottomSheet(value) {
    setState(() {
      isShowBottomSheet = value;
    });
  }

  void connectivity() async {
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      showMessage('Không có kết nối mạng.', 3);
    }
  }

  void showErrorMessage(dynamic error, [int duration = 3]) async {
    setSubmit(false);
    if (error.message == '401') {
      Navigator.of(context).pushReplacementNamed('/main');
      return;
    }
    var listErrors = await getErrors(error);
    Scaffold.of(context).removeCurrentSnackBar();
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Container(
        child: new Column(
          children: listErrors,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
        ),
      ),
      duration: Duration(seconds: duration),
    ));
  }

  void showErrorMessageScaffoldKey(
      GlobalKey<ScaffoldState> scaffoldKey, dynamic error,
      [int duration = 3]) async {
    setSubmit(false);
    if (error.message == '401') {
      Navigator.of(context).pushReplacementNamed('/main');
      return;
    }
    var listErrors = await getErrors(error);
    scaffoldKey.currentState.removeCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Container(
        child: new Column(
          children: listErrors,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
        ),
      ),
      duration: Duration(seconds: duration),
    ));
  }

  static Future getErrors(dynamic error) async {
    List<Widget> listErrors = new List<Widget>();
    final JsonDecoder _decoder = new JsonDecoder();
    try {
      dynamic errorMessage = _decoder.convert(error.message);
      errorMessage.forEach((key, messages) {
        messages.forEach((message) {
          listErrors.add(new Text(Str.capitalize(message)));
        });
      });
    } catch (e) {
      var connectivityResult = await (new Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        listErrors.add(new Text('Không có kết nối mạng.'));
        return listErrors;
      }
      listErrors.add(new Text('Lỗi chưa xác định, vui lòng thử lại sau.'));
    }
    return listErrors;
  }

  void showMessage(String str, [int duration = 3]) {
    Scaffold.of(context).removeCurrentSnackBar();
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Container(
        child: new Column(
          children: <Widget>[new Text(str)],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
        ),
      ),
      duration: Duration(seconds: duration),
    ));
  }

  void showMessageScaffoldKey(GlobalKey<ScaffoldState> scaffoldKey, String str,
      [int duration = 3]) {
    scaffoldKey.currentState.removeCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Container(
        child: new Column(
          children: <Widget>[new Text(str)],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
        ),
      ),
      duration: Duration(seconds: duration),
    ));
  }

  Future<bool> showYesNo(String message) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(content: new Text(message), actions: <Widget>[
            new FlatButton(
                child: new Text('Đồng ý'),
                onPressed: () {
                  Navigator.pop(context, true);
                }),
            new FlatButton(
                child: new Text('Hủy bỏ'),
                onPressed: () {
                  Navigator.pop(context, false);
                })
          ]);
        });
  }

  showDateController(TextEditingController controller, [callback]) {
    showDatePicker(
      context: context,
      initialDate: DT.toDate(controller.text),
      firstDate: DT.toDate(controller.text).add(new Duration(days: -300)),
      lastDate: DT.toDate(controller.text).add(new Duration(days: 300)),
    ).then((date) {
      if (date != null) {
        controller.text = DT.replaceDate(controller.text, date);
        if (callback != null) {
          callback();
        }
      }
    });
  }

  showTimeController(TextEditingController controller, [callback]) {
    showTimePicker(
            context: context,
            initialTime: new TimeOfDay(
                hour: DT.getHour(controller.text),
                minute: DT.getMinute(controller.text)))
        .then((time) {
      if (time != null) {
        controller.text = DT.replaceTime(controller.text, time);
        if (callback != null) {
          callback();
        }
      }
    });
  }

  Widget buildText(
      String label, TextEditingController controller, bool enabled) {
    return Theme(
      data: Theme.of(context).copyWith(primaryColor: Colors.grey),
      child: new TextField(
        controller: controller,
        enabled: enabled,
        decoration: InputDesign.decorationTextField(label),
        style: new TextStyle(color: Colors.black, fontSize: 14.0),
      ),
    );
  }

  Widget buildTextPassword(
      String label, TextEditingController controller, bool enabled) {
    return Theme(
      data: Theme.of(context).copyWith(primaryColor: Colors.grey),
      child: new TextField(
        controller: controller,
        enabled: enabled,
        obscureText: true,
        decoration: InputDesign.decorationTextField(label),
        style: new TextStyle(color: Colors.black, fontSize: 14.0),
      ),
    );
  }

  Widget buildTextNumber(
      String label, TextEditingController controller, bool enabled) {
    return Theme(
      data: Theme.of(context).copyWith(primaryColor: Colors.grey),
      child: new TextField(
        controller: controller,
        enabled: enabled,
        keyboardType: TextInputType.number,
        decoration: InputDesign.decorationTextField(label),
        style: new TextStyle(color: Colors.black, fontSize: 14.0),
      ),
    );
  }

  Widget buildTextNumberSuffix(
      String label, TextEditingController controller, bool enabled, suffix) {
    return Theme(
      data: Theme.of(context).copyWith(primaryColor: Colors.grey),
      child: Row(
        children: <Widget>[
          Expanded(
            child: new TextField(
              controller: controller,
              enabled: enabled,
              keyboardType: TextInputType.number,
              decoration: InputDesign.decorationTextFieldSuffix(label, suffix),
              style: new TextStyle(color: Colors.black, fontSize: 14.0),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextMoney(String label, TextEditingController controller,
      [bool enabled = true, onEditingComplete]) {
    return Theme(
      data: Theme.of(context).copyWith(primaryColor: Colors.grey),
      child: Row(
        children: <Widget>[
          Expanded(
            child: new TextField(
              controller: controller,
              enabled: enabled,
              keyboardType: TextInputType.number,
              decoration: InputDesign.decorationTextFieldMoney(label),
              style: new TextStyle(color: Colors.black, fontSize: 14.0),
              textAlign: TextAlign.end,
              onEditingComplete:
                  onEditingComplete != null ? onEditingComplete() : () {},
            ),
          )
        ],
      ),
    );
  }
}
