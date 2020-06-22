import 'dart:convert';

import 'package:covid19/model/details.dart';
import 'package:covid19/model/global_details.dart';
import 'package:covid19/screens/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  List<String> countries = [];
  getCountries() async {
    var url = 'https://api.covid19api.com/countries';
    var response = await http.get(url);
    var decode = jsonDecode(response.body);
    for (var i = 0; i < decode.length; i++) {
      countries.add(decode[i]["Country"]);
    }

    countries.sort();

    url = "https://api.covid19api.com/total/dayone/country/india";
    response = await http.get(url);
    decode = jsonDecode(response.body);
    int length = decode.length;
    decode = decode[length - 1];
    CountryDetails countryDetails = CountryDetails(
        decode["Date"],
        decode["Confirmed"].toString(),
        decode["Deaths"].toString(),
        decode["Recovered"].toString(),
        decode["Active"].toString());

    url = "https://api.covid19api.com/summary";
    response = await http.get(url);
    decode = jsonDecode(response.body);
    decode = decode["Global"];

    GlobalDetails globalDetails = GlobalDetails(
        decode["NewConfirmed"],
        decode["TotalConfirmed"],
        decode["NewDeaths"],
        decode["TotalDeaths"],
        decode["NewRecovered"],
        decode["TotalRecovered"]);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) =>
                HomeScreen(countries, countryDetails, globalDetails)));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCountries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitFoldingCube(
          color: Colors.blue,
        ),
      ),
    );
  }
}
