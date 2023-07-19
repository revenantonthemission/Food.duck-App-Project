import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


List<dynamic> listfood = [];
Map name = {};
Map category ={};
Map trav_time ={};
Map tag = {};
Map listmeta = {};



void makelist(var parsed_list){
  int idx = 1;
  for(var i in parsed_list){
    name[i["name"]] = idx;
    if(category.containsKey(i["category"])){
      category[i["category"]].add(idx);
    }else{
      category[i["category"]] = <int>[];
      category[i["category"]].add(idx);
    }
    if(trav_time.containsKey(i["trav_time"])){
      trav_time[i["trav_time"]].add(idx);
    }else {
      trav_time[i["trav_time"]] = <int>[];
      trav_time[i["trav_time"]].add(idx);
    }

    for(var j in i["tag"]){
      if(tag.containsKey(j)){
        tag[j].add(idx);
      }else{
        tag[j] = <int>[];
        tag[j].add(idx);
      }
    }
    idx++;
  }
}



Future<int> init(CounterStorage cs) async {
  bool result = await InternetConnectionChecker().hasConnection;
  if(result == true) {
    try {

      /*
        fetch data from firebase
      */

      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;
      final file = File('$path/food.json');
      final meta_file = File('$path/meta_food.json');
      final contents = await file.readAsString();
      final meta = await meta_file.readAsString();
      listfood = jsonDecode(contents);
      listmeta = jsonDecode(meta);
      makelist(listfood);



      return 0;
    }catch(e){
      return -1;
    }
  } else {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;
      final file = File('$path/food.json');
      final meta_file = File('$path/meta_food.json');
      final contents = await file.readAsString();
      final meta = await meta_file.readAsString();
      listfood = jsonDecode(contents);
      listmeta = jsonDecode(meta);
      makelist(listfood);


      return 0;
    }catch(e){
      return -1;
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if(init(CounterStorage())==-1){
    throw 'Error';
  }


  runApp(
    MaterialApp(
      title: 'I Copied the flutter demo page lol',
      home: FlutterDemo(storage: CounterStorage()),
    ),
  );
}

class CounterStorage {

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.json');
  }


}

class FlutterDemo extends StatefulWidget {
  const FlutterDemo({super.key, required this.storage});

  final CounterStorage storage;

  @override
  State<FlutterDemo> createState() => _FlutterDemoState();
}

class _FlutterDemoState extends State<FlutterDemo> {
  int _counter = 0;
  var _LocalContent;



  int _incrementCounter() {
    setState(() {
      _counter++;
    });

    // Write the variable as a string to the file.
    //return widget.storage.writeCounter(_counter); //Future<file> type needed.
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reading and Writing Files'),
      ),
      body: Center(
        child: Text(
          'listfood',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}