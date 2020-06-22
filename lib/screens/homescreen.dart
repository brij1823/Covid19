import 'dart:convert';

import 'package:covid19/model/details.dart';
import 'package:covid19/model/global_details.dart';
import 'package:covid19/screens/charscreen.dart';
import 'package:covid19/screens/infoscreen.dart';
import 'package:covid19/screens/temp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;

class HomeScreen extends StatefulWidget {
  List<String> countries = [];
  CountryDetails countryDetails;
  GlobalDetails globalDetails;
  HomeScreen(this.countries, this.countryDetails, this.globalDetails);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String current_country = 'India';
  bool showSpinner = false;
  var completeData;
  updateCountry(newCountry) async {
    try {
      var url = "https://api.covid19api.com/total/dayone/country/" + newCountry;
      var response = await http.get(url);
      var decode = jsonDecode(response.body);
      completeData = decode;
      int length = decode.length;
      decode = decode[length - 1];

      this.setState(() {
        widget.countryDetails = CountryDetails(
            decode["Date"],
            decode["Confirmed"].toString(),
            decode["Deaths"].toString(),
            decode["Recovered"].toString(),
            decode["Active"].toString());
        showSpinner = false;
      });
    } catch (e) {
      this.setState(() {
        showSpinner = false;
      });
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ClipPath(
                  clipper: OvalBottomBorderClipper(),
                  child: Container(
                      height: 300,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [Color(0xff00b7e0), Color(0xff0b18d6)]),
                        image: DecorationImage(
                            image: AssetImage('assets/images/virus.png')),
                      ),
                      child: SafeArea(
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  icon: Icon(Icons.menu),
                                  color: Colors.white,
                                  iconSize: 30,
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => InfoScreen()));
                                  },
                                ),
                              ),
                            ),
                            Positioned(
                              top: 70,
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: SvgPicture.asset(
                                  'assets/icons/Drcorona.svg',
                                  width: 150,
                                  height: 300,
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                'Stay Home \n Stay Safe',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30),
                              ),
                            )
                          ],
                        ),
                      )),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.grey[500])),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.location_on,
                          color: Colors.blue,
                          size: 30,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: DropdownButton<String>(
                            value: current_country,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                letterSpacing: 1.2),
                            icon: Icon(Icons.arrow_drop_down),
                            isExpanded: true,
                            underline: SizedBox(),
                            items: widget.countries.map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(value),
                              );
                            }).toList(),
                            onChanged: (new_country) {
                              this.setState(() {
                                current_country = new_country;
                                showSpinner = true;
                                updateCountry(new_country);
                              });
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Case Update',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                letterSpacing: 1.2),
                          ),
                          Text(
                            'Newest Update on ' +
                                widget.countryDetails.lastDate.substring(0, 10),
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          )
                        ],
                      ),
                      FlatButton(
                        onPressed: () {
                          if (completeData != null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        AreaAndLineChart(completeData)));
                          } else {
                            this.setState(() async {
                              current_country = 'India';
                              showSpinner = true;
                              await updateCountry('India');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          AreaAndLineChart(completeData)));
                            });
                          }
                        },
                        child: Text(
                          'See details',
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.black45, blurRadius: 18)
                        ]),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Statistics(Colors.orange[800],
                                widget.countryDetails.confirmed, 'Confirmed'),
                            Statistics(Colors.red[900],
                                widget.countryDetails.deaths, 'Deaths'),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            Statistics(Colors.green[800],
                                widget.countryDetails.recovered, 'Recovered'),
                            Statistics(Colors.teal,
                                widget.countryDetails.active, 'Active'),
                          ],
                        ),
                      ],
                    )),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Spread of Virus globally',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        'See details',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.black45, blurRadius: 20)
                      ]),
                  child: Image.asset('assets/images/map.png'),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.black45, blurRadius: 18)
                        ]),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            GlobalStatistics(
                                Colors.orange[800],
                                widget.globalDetails.newConfirmed.toString(),
                                'New Confirmed'),
                            GlobalStatistics(
                                Colors.orange[900],
                                widget.globalDetails.totalConfirmed.toString(),
                                'Total Confirmed'),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            GlobalStatistics(
                                Colors.red[800],
                                widget.globalDetails.newDeaths.toString(),
                                'New Deaths'),
                            GlobalStatistics(
                                Colors.red[900],
                                widget.globalDetails.totalDeaths.toString(),
                                'Total Deaths'),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            GlobalStatistics(
                                Colors.green[800],
                                widget.globalDetails.newRecovered.toString(),
                                'New Recovered'),
                            GlobalStatistics(
                                Colors.green[900],
                                widget.globalDetails.totalRecovered.toString(),
                                'Total Recovered'),
                          ],
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Statistics extends StatelessWidget {
  var colors;
  var record;
  var category;
  Statistics(this.colors, this.record, this.category);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.withOpacity(0.4),
            ),
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  border: Border.all(color: colors, width: 2)),
            ),
          ),
          Text(
            record,
            style: TextStyle(
                color: colors, fontSize: 30, fontWeight: FontWeight.w400),
          ),
          Text(
            category,
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class GlobalStatistics extends StatelessWidget {
  var colors;
  var record;
  var category;
  GlobalStatistics(this.colors, this.record, this.category);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.withOpacity(0.4),
            ),
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  border: Border.all(color: colors, width: 2)),
            ),
          ),
          Text(
            record,
            style: TextStyle(
                color: colors, fontSize: 30, fontWeight: FontWeight.w400),
          ),
          Text(
            category,
            style: TextStyle(
                color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
