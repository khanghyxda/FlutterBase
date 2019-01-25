import 'package:flutter/material.dart';
import 'package:sapp/common/common.dart';
import 'package:sapp/common/component.dart';
import 'package:sapp/common/transition.dart';
import 'package:sapp/screens/rule/rule_entry.dart';
import 'package:sapp/services/rule.dart';
import 'package:sapp/utils/common.dart';
import 'package:sapp/utils/constant.dart';

class RulePage extends StatefulWidget {
  @override
  _RulePageState createState() => _RulePageState();
}

class _RulePageState extends AbstractState<RulePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  List<dynamic> list = new List<dynamic>();

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    showProgress();
    var result = await RuleService.getList().catchError((error) {
      showErrorMessage(error);
    });
    if (result != null) {
      setState(() {
        list = result['rules'];
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
              body: RuleEntry(
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
        title: new Text("Cách tính tiền"),
        leading: new IconButton(
          icon: new BackButton(),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
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
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Row(
                            children: <Widget>[
                              getIconType(1, 18.0),
                              SizedBox(
                                width: 3.0,
                              ),
                              Expanded(
                                child: Text(item['gM1'].toString() + "k"),
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              getIconType(2, 18.0),
                              SizedBox(
                                width: 3.0,
                              ),
                              Expanded(
                                child: Text(item['qdM'].toString() + "k"),
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              getIconType(3, 18.0),
                              SizedBox(
                                width: 3.0,
                              ),
                              Expanded(
                                child: Text(item['nm'].toString() + "k"),
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
