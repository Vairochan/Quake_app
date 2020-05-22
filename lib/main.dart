import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Map _data;
List _features;
void main() async{


   _data = await getJSON();
   _features = _data['features'];

  print(_data);

  runApp(new MaterialApp(
    title: 'Quakes',
    home: new Quakes(),
  ),
  );
}

class Quakes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Qukaes"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: new Center(
        child: new ListView.builder(
            itemCount: _features.length ,
            padding: const EdgeInsets.all(16.0),


            itemBuilder: (BuildContext context, int position){
              var format = new DateFormat.yMMMMd("en_US").add_jm();
              var date = format.format(new DateTime.fromMicrosecondsSinceEpoch(_features[position]['properties']['time']*1000,
              isUtc: true));

              return Card(
                elevation: 10,
                child: ListTile(
                title: new Text("At $date"),
                  subtitle: new Text("${_features[position]['properties']['place']}",
                  style: new TextStyle(
                    fontStyle: FontStyle.italic
                  ),),
                  leading: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.green,
                    child: new Text("${_features[position]['properties']['mag']}",
                    style: new TextStyle(
                      color: Colors.white
                    ),),


                  ),
                  onTap: (){_showAlertMesssage(context, "${_features[position]['properties']['title']}");},
                ),
              );
      },
      ),
    ),);
  }

  void _showAlertMesssage(BuildContext context, String message) {
    var alertDialog = new AlertDialog(
      title: Text("QUAKES"),
      content: Text(message),
      actions: <Widget>[
        FlatButton(
          onPressed: ()=> Navigator.of(context).pop() ,
          child: Text("ok"),
        ),
      ],
    );
    showDialog(context: context, builder: (context){
      return alertDialog;
    });
  }
}
Future<Map> getJSON() async{
  String apiURL = 'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson';
  http.Response response = await http.get(apiURL);
  return json.decode(response.body);
}

