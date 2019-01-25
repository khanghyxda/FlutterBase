import 'package:flutter/material.dart';
import 'package:sapp/utils/color.dart';

class InputDesign {
  static InputDecoration decorationTextField(String label) {
    return new InputDecoration(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: new BorderSide(width: 0.5, color: Colors.grey)),
      contentPadding: const EdgeInsets.all(12.0),
      labelText: label,
      labelStyle: new TextStyle(fontSize: 16.0),
    );
  }

  static InputDecoration decorationTextFieldSuffix(String label, suffix) {
    return new InputDecoration(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: new BorderSide(width: 0.5, color: Colors.grey)),
      contentPadding: const EdgeInsets.all(12.0),
      labelText: label,
      labelStyle: new TextStyle(fontSize: 16.0),
      suffixText: suffix
    );
  }

  static InputDecoration decorationTextFieldMoney(String label) {
    return new InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: new BorderSide(width: 0.5, color: Colors.grey)),
        contentPadding: const EdgeInsets.all(12.0),
        labelText: label,
        labelStyle: new TextStyle(fontSize: 16.0),
        suffixText: '.000 ₫');
  }
}

class MainStack extends StatelessWidget {
  MainStack({this.isLoading, this.child});

  final bool isLoading;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return isLoading ? CenterCircularProgress() : child;
  }
}

class ProgressBar extends StatelessWidget {
  ProgressBar({Key key, this.visible, this.top});

  final bool visible;

  final double top;

  @override
  Widget build(BuildContext context) {
    return visible
        ? Positioned(
            top: top == null ? 5.0 : top,
            left: 0.0,
            child: Container(
              height: 3.0,
              width: MediaQuery.of(context).size.width,
              child: LinearProgressIndicator(
                  // backgroundColor: const Color.fromRGBO(253, 174, 168, 1.0),
                  // valueColor: new AlwaysStoppedAnimation<Color>(Colors.amber),
                  ),
            ),
          )
        : Container();
  }
}

class CenterCircularProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}

class LoadingBar extends StatelessWidget {
  LoadingBar({Key key, this.visible, this.top});

  final bool visible;

  final double top;

  @override
  Widget build(BuildContext context) {
    return visible
        ? Positioned(
            top: top == null ? 5.0 : top,
            left: MediaQuery.of(context).size.width / 2 - 15,
            child: Container(
              width: 30.0,
              height: 30.0,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage('assets/loading.gif'),
              )),
            ),
          )
        : Container();
  }
}

class LogoAnimation extends StatefulWidget {
  @override
  _LogoAnimationState createState() => _LogoAnimationState();
}

class _LogoAnimationState extends State<LogoAnimation>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

  initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
    animation = Tween(begin: 0.0, end: 200.0).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    controller.forward();
  }

  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        height: animation.value,
        width: animation.value,
        child: Image.asset(
          'assets/logo.png',
        ),
      ),
    );
  }

  dispose() {
    controller.dispose();
    super.dispose();
  }
}

class PopupMenuModel {
  PopupMenuModel(this.name, this.value);
  final String name;
  final int value;
}

class PopupMenuCommon extends StatelessWidget {
  PopupMenuCommon({this.choices, this.value, this.onSelected});
  final List<PopupMenuModel> choices;
  final dynamic value;
  final dynamic onSelected;
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<PopupMenuModel>(onSelected: (choice) {
      onSelected(choice);
    }, itemBuilder: (BuildContext context) {
      return choices.map((PopupMenuModel choice) {
        return PopupMenuItem<PopupMenuModel>(
          value: choice,
          child: Row(
            children: <Widget>[
              value == choice.value
                  ? Icon(
                      Icons.check,
                      size: 18.0,
                      color: AppColors.primary,
                    )
                  : Container(
                      width: 18.0,
                    ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(choice.name),
              ),
            ],
          ),
        );
      }).toList();
    });
  }
}

class MonthSelect extends StatefulWidget {
  MonthSelect({this.year, this.month, this.onSelected});
  final int year;
  final int month;
  final dynamic onSelected;
  @override
  _MonthSelectState createState() => _MonthSelectState();
}

class _MonthSelectState extends State<MonthSelect> {
  int year;
  int month;
  final List listMonth = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  @override
  void initState() {
    super.initState();
    year = widget.year ?? DateTime.now().year;
    month = widget.month ?? DateTime.now().month;
  }

  changeYear(value) {
    setState(() {
      year += value;
    });
  }

  getBackColor(m) {
    if (widget.year == year && m == widget.month) {
      return Colors.blueAccent;
    }
    if (year == DateTime.now().year && m == DateTime.now().month) {
      return Colors.grey[200];
    }
    return Colors.white;
  }

  getColor(m) {
    if (widget.year == year && m == widget.month) {
      return Colors.white;
    }
    if (year == DateTime.now().year && m == DateTime.now().month) {
      return Colors.black;
    }
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width / 3;
    return Container(
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                year.toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Container(),
              ),
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 20.0,
                  color: Colors.grey,
                ),
                onPressed: () {
                  changeYear(-1);
                },
              ),
              SizedBox(
                width: 5.0,
              ),
              SizedBox(
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    size: 20.0,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    changeYear(1);
                  },
                ),
                width: 20.0,
              ),
            ],
          ),
          SizedBox(height: 10.0,),
          Divider(),
          GridView.count(
            crossAxisCount: 3,
            childAspectRatio: (width / 50),
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: listMonth.map((m) {
              return Chip(
                label: InkWell(
                  child: Text(
                    "THG" +
                        m.toString() +
                        (m.toString().length == 1 ? "  " : ""),
                    style: TextStyle(color: getColor(m)),
                  ),
                  onTap: () {
                    widget.onSelected(year, m);
                  },
                ),
                backgroundColor: getBackColor(m),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
