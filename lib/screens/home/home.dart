import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sapp/common/common.dart';
import 'package:sapp/common/component.dart';
import 'package:sapp/screens/drawer/drawer.dart';
import 'package:sapp/services/master.dart';
import 'package:sapp/services/report.dart';
import 'package:sapp/services/room.dart';
import 'package:sapp/utils/color.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:sapp/utils/date.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends AbstractState<HomePage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  var systemInfos = [
    {
      'name': 'Thuê trong ngày',
      'icon': Icons.show_chart,
      'iconColor': AppColors.info,
      'number': ""
    },
    {
      'name': 'Phòng chờ',
      'icon': Icons.vpn_key,
      'iconColor': AppColors.info,
      'number': ""
    },
    {
      'name': 'Phòng đang thuê',
      'icon': Icons.local_hotel,
      'iconColor': AppColors.info,
      'number': ""
    },
    {
      'name': 'Phòng cần dọn',
      'icon': Icons.clear_all,
      'iconColor': AppColors.info,
      'number': ""
    },
  ];

  List<charts.Series<dynamic, DateTime>> seriesList =
      new List<charts.Series<dynamic, DateTime>>();

  String timePoint;
  String rentTimesPoint;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    showProgress();
    var getRooms = RoomService.getList();
    var getUser = MasterService.getUser();
    var getRoomWaiting = RoomService.getWaiting();
    var getReportRentTimes = ReportService.getRentTimes();
    var results = await Future.wait(
            [getRooms, getRoomWaiting, getReportRentTimes, getUser])
        .catchError((error) {
      showErrorMessage(error);
    });
    if (results != null) {
      List roomList = results[0]['rooms'];
      List roomWaiting = results[1]['rooms'];
      int totalRoom = roomList.length;
      int roomCleanNum =
          roomList.where((o) => o['cleaned'] != 1).toList().length;
      List reportRentTimes = results[2]['reports'];
      List<DayRow> data = new List<DayRow>();
      reportRentTimes.forEach((report) {
        data.add(
            new DayRow(DateTime.parse(report['date']), report['rentTimes']));
      });
      if (mounted) {
        setState(() {
          systemInfos[0]['number'] =
              reportRentTimes[reportRentTimes.length - 1]['rentTimes'];
          systemInfos[1]['number'] = roomWaiting.length;
          systemInfos[2]['number'] = totalRoom - roomWaiting.length;
          systemInfos[3]['number'] = roomCleanNum;
          seriesList = [
            new charts.Series<DayRow, DateTime>(
              id: 'times',
              colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
              domainFn: (DayRow row, _) => row.timeStamp,
              measureFn: (DayRow row, _) => row.rentTimes,
              data: data,
            )
          ];
          timePoint =
              DT.dateToString(data[data.length - 1].timeStamp, DT.formatDate);
          rentTimesPoint = data[data.length - 1].rentTimes.toString();
        });
      }
    }
    hideLoading();
    hideProgress();
    return results;
  }

  onSelectionChanged(charts.SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    DateTime time;
    final measures = <String, num>{};

    if (selectedDatum.isNotEmpty) {
      time = selectedDatum.first.datum.timeStamp;
      selectedDatum.forEach((charts.SeriesDatum datumPair) {
        measures[datumPair.series.displayName] = datumPair.datum.rentTimes;
      });
    }
    setState(() {
      timePoint = DT.dateToString(time, DT.formatDate);
      rentTimesPoint = measures["times"].toString();
    });
  }

  getInfo() {
    if (timePoint == null) {
      return Container();
    }
    return Center(
      child: Row(
        children: <Widget>[
          Icon(
            Icons.calendar_today,
            size: 20.0,
            color: Colors.blue,
          ),
          SizedBox(
            width: 3.0,
          ),
          Text(timePoint),
          SizedBox(
            width: 15.0,
          ),
          Icon(
            Icons.local_hotel,
            size: 20.0,
            color: Colors.blue,
          ),
          SizedBox(
            width: 3.0,
          ),
          Text(rentTimesPoint),
        ],
        mainAxisSize: MainAxisSize.min,
      ),
    );
  }

  Future<Null> onRefresh() {
    Completer<Null> completer = new Completer<Null>();
    getData().then((results) {
      return completer.complete();
    });
    return completer.future;
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
        title: Text('Thông tin hệ thống'),
      ),
      drawer: DrawerPage(),
      backgroundColor: Colors.white,
      body: MainStack(
        isLoading: isLoading,
        child: Stack(
          children: <Widget>[
            RefreshIndicator(
              onRefresh: onRefresh,
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: (width / 115),
                    padding: EdgeInsets.all(5.0),
                    crossAxisSpacing: 2.0,
                    mainAxisSpacing: 2.0,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    children: systemInfos.map((info) {
                      return Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero),
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30.0),
                                    child: Icon(
                                      info['icon'],
                                      color: info['iconColor'],
                                      size: 35.0,
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      info['number'].toString(),
                                      style: TextStyle(
                                          fontSize: 30.0,
                                          color: AppColors.dark),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 30.0, bottom: 10.0),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      info['name'],
                                      style: TextStyle(fontSize: 15.0),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ),
                              height: 40.0,
                            )
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  Container(
                    height: 280.0,
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 5.0),
                                  child: Icon(
                                    Icons.timeline,
                                    color: Colors.blue,
                                  ),
                                ),
                                Text(
                                  "Lượt thuê phòng",
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 0.0),
                              child: charts.TimeSeriesChart(seriesList,
                                  animate: true,
                                  selectionModels: [
                                    new charts.SelectionModelConfig(
                                        type: charts.SelectionModelType.info,
                                        changedListener: onSelectionChanged)
                                  ],
                                  primaryMeasureAxis:
                                      new charts.NumericAxisSpec(),
                                  domainAxis: new charts.DateTimeAxisSpec(
                                      tickFormatterSpec: new charts
                                              .AutoDateTimeTickFormatterSpec(
                                          day: new charts.TimeFormatterSpec(
                                              format: 'd',
                                              transitionFormat: 'dd/MM'),
                                          month: new charts.TimeFormatterSpec(
                                              format: 'M',
                                              transitionFormat: 'M/y')))),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 15.0, top: 5.0),
                            child: Center(
                              child: getInfo(),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
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

class DayRow {
  final DateTime timeStamp;

  final int rentTimes;

  DayRow(this.timeStamp, this.rentTimes);
}
