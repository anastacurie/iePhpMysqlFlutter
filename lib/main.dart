import "dart:convert";

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.red),
        home: WriteSQLdata());
  }
}

class WriteSQLdata extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WriteSQLdataState();
  }
}

class WriteSQLdataState extends State<WriteSQLdata> {
  TextEditingController namectl = TextEditingController();
  TextEditingController addressctl = TextEditingController();
  TextEditingController classctl = TextEditingController();
  TextEditingController rollnoctl = TextEditingController();
  late bool error, sending, success;
  late String msg;
  String phpurl = "http://192.168.105.84/test/write.php";
  @override
  void initState() {
    error = false;
    sending = false;
    success = false;
    msg = "";
    super.initState();
  }

  Future<void> sendData() async {
    var res = await http.post(Uri.parse(phpurl), body: {
      "name": namectl.text,
      "address": addressctl.text,
      "class": classctl.text,
      "rollno": rollnoctl.text,
    });
    if (res.statusCode == 200) {
      print(res.body);
      var data = json.decode(res.body);
      if (data["error"]) {
        setState(() {
          sending = false;
          error = true;
          msg = data["message"];
        });
      } else {
        namectl.text = "";
        addressctl.text = "";
        rollnoctl.text = "";
        classctl.text = "";
        setState(() {
          sending = false;
          success = true;
        });
      }
    } else {
      setState(() {
        error = true;
        msg = "Error during sending data";
        sending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Write Data PHP&MySQL"),
        backgroundColor: Colors.redAccent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              child: Text(error ? msg : "Enter Student Information"),
            ),
            Container(
              child: Text(success ? "Write success" : "Send data"),
            ),
            Container(
              child: TextField(
                controller: namectl,
                decoration: InputDecoration(
                    labelText: "Full Name", hintText: "Enter Full Name"),
              ),
            ),
            Container(
              child: TextField(
                controller: addressctl,
                decoration: InputDecoration(
                    labelText: "Full Address", hintText: "Enter Full Address"),
              ),
            ),
            Container(
              child: TextField(
                controller: classctl,
                decoration: InputDecoration(
                    labelText: "Class", hintText: "Enter Class"),
              ),
            ),
            Container(
              child: TextField(
                controller: rollnoctl,
                decoration: InputDecoration(
                    labelText: "Roll Number", hintText: "Enter Roll Number"),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: RaisedButton(
                onPressed: () {
                  setState(() {
                    sending = true;
                  });
                  sendData();
                },
                child: Text(
                  sending ? "Sending ..." : "SEND DATA",
                ),
                color: Colors.redAccent,
                colorBrightness: Brightness.dark,
              ),
            )
          ],
        ),
      ),
    );
  }
}
