import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class AreaAndLineChart extends StatefulWidget {
  var completeData;
  AreaAndLineChart(this.completeData);
  @override
  _AreaAndLineChartState createState() => _AreaAndLineChartState();
}

class _AreaAndLineChartState extends State<AreaAndLineChart> {
  List<charts.Series<Sales, int>> _seriesLineData;
  List<Sales> linesaldata1 = [];

  List<Sales> linesaldata12 = [];

  List<Sales> linesaldata13 = [];
  var counter = 0;

  _generateData() {
    for (var i = widget.completeData.length - 10;
        i < widget.completeData.length;
        i++) {
      var temp = DateTime.parse(widget.completeData[i]['Date']);
      linesaldata1.add(Sales(counter, widget.completeData[i]["Confirmed"]));

      linesaldata12.add(Sales(counter, widget.completeData[i]["Deaths"]));

      linesaldata13.add(Sales(counter, widget.completeData[i]["Recovered"]));
      counter += 1;
    }
    _seriesLineData.add(charts.Series(
      colorFn: (datum, index) =>
          charts.ColorUtil.fromDartColor(Colors.orange[900]),
      id: 'Confirmed Cases',
      data: linesaldata1,
      domainFn: (datum, index) => datum.yearval,
      measureFn: (datum, index) => datum.salesval,
    ));

    _seriesLineData.add(charts.Series(
      colorFn: (datum, index) => charts.ColorUtil.fromDartColor(Colors.black),
      id: 'Deaths',
      data: linesaldata12,
      domainFn: (datum, index) => datum.yearval,
      measureFn: (datum, index) => datum.salesval,
    ));

    _seriesLineData.add(charts.Series(
      colorFn: (datum, index) =>
          charts.ColorUtil.fromDartColor(Colors.green[900]),
      id: 'Deaths',
      data: linesaldata13,
      domainFn: (datum, index) => datum.yearval,
      measureFn: (datum, index) => datum.salesval,
    ));
  }

  @override
  void initState() {
    super.initState();
    _seriesLineData = List<charts.Series<Sales, int>>();
    _generateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.completeData[0]["Country"]),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
                width: double.infinity,
                height: 100,
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 20)
                    ]),
                child: Row(
                  children: <Widget>[
                    Expanded(child: Labels(Colors.orange, 'Confirmed\n Cases')),
                    Expanded(child: Labels(Colors.black, 'Death\n Cases')),
                    Expanded(child: Labels(Colors.green, 'Recovered\n Cases')),
                  ],
                )),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.black45, blurRadius: 20)
                    ]),
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Text(
                        'Past 10 days record',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Expanded(
                      child: charts.LineChart(
                        _seriesLineData,
                        defaultRenderer: charts.LineRendererConfig(
                            includeArea: true, stacked: false),
                        animate: true,
                        animationDuration: Duration(seconds: 2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Sales {
  int yearval;
  int salesval;

  Sales(this.yearval, this.salesval);
}

class Labels extends StatelessWidget {
  var color;
  var labels;

  Labels(this.color, this.labels);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 15,
          height: 15,
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        Text(labels, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}
