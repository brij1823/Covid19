import 'package:flutter/material.dart';
class ChatScreen extends StatelessWidget {
  //temp
   

  var data;
  var confirmed = [];
  var death = [];
  var recovered = [];
  var date = [];
  ChatScreen(data) {
    this.data = data;
    for (var i = 0; i < data.length; i++) {
      var temp = DateTime.parse(data[i]['Date']);
      confirmed.add([
        temp.day.toString() + "/" + temp.month.toString(),
        data[i]["Confirmed"]
      ]);
      death.add([
        temp.day.toString() + "/" + temp.month.toString(),
        data[i]["Deaths"]
      ]);
      recovered.add([
        temp.day.toString() + "/" + temp.month.toString(),
        data[i]["Recovered"]
      ]);
    }
    print(confirmed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: <Widget>[
        
      ],),
    );
  }
}
