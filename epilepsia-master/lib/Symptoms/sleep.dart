import 'package:epilepsia/model/healthy/sleep.dart';
import 'package:epilepsia/model/healthy/stimmung.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../config/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
final timeController = TextEditingController();
final timeController1 = TextEditingController();
final dateController = TextEditingController();

class SleepWidget extends StatefulWidget {
  SleepWidget({
    Key key,
  }) : super(key: key);
  @override
  _SleepState createState() => _SleepState();
}

class _SleepState extends State<SleepWidget> {
  List<StatusIcons> statusList = <StatusIcons>[];
  TimeOfDay timeOfDayTime;
  DateTime dateTimeDay;

  TimeOfDay startDate= TimeOfDay.now();
  TimeOfDay endDate = TimeOfDay.now();
  String minute = "";
  String hours = "";
  String zeit = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateFormat format = DateFormat('dd.MM.yyyy');
     if (hours != "" && minute != "") {
      zeit = "Dauer: " + hours + ":" + minute;
    } else if (hours == "" && minute != "") {
      zeit = "Dauer: " + "00:" + minute;
    } else if (hours != "" && minute == "") {
      zeit = "Dauer: " + hours + ":00";
    } else {
      zeit = "";
    }
   

    return Container(
        margin: const EdgeInsets.all(15.0),
        child: Column(children: [
          Container(
            child: TextField(
              readOnly: true,
              controller: dateController,
              decoration: InputDecoration(
                  hoverColor: Colors.blue[200], hintText: 'Tag auswählen'),
              onTap: () async {
                var date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100));

                dateController.value =
                    TextEditingValue(text: format.format(date));

                setState(() {
                  dateTimeDay = date;
                });
              },
            ),
          ),
          TextField(
            readOnly: true,
            controller: timeController,
            decoration: InputDecoration(
                hoverColor: Colors.blue[200], hintText: 'Eingeschlafen'),
            onTap: () async {
              var time = await showTimePicker(
                initialTime: TimeOfDay.now(),
                context: context,
              );
              timeController.text = time.format(context);
              setState(() {
               // if (startDate != null && endDate != null){
                   if (startDate.hour <= endDate.hour) {
                  hours = (endDate.hour - startDate.hour).toString();
                } else {
                  hours = (startDate.hour - endDate.hour).toString();
                }
                if (startDate.minute <= endDate.minute) {
                  minute = (endDate.minute - startDate.minute).toString();
                } else {
                  minute = (startDate.minute - endDate.minute).toString();
                }
              //}
              //else{ } 	
              });
  }         ),
          TextField(
            readOnly: true,
            controller: timeController1,
            decoration: InputDecoration(
                hoverColor: Colors.blue[200], hintText: 'Aufgestanden'),
            onTap: () async {
              endDate = await showTimePicker(
                initialTime: TimeOfDay.now(),
                context: context,
              );
              timeController1.text = endDate.format(context);
              setState(() {
               // if (startDate != null && endDate != null){
                   if (startDate.hour <= endDate.hour) {
                  hours = (endDate.hour - startDate.hour).toString();
                } else {
                  hours = (startDate.hour - endDate.hour).toString();
                }
                if (startDate.minute <= endDate.minute) {
                  minute = (endDate.minute - startDate.minute).toString();
                } else {
                  minute = (startDate.minute - endDate.minute).toString();
                }
              //}
              //else{}
              });
            },
          ),
          Divider(
            height: 15,
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              zeit,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ),
          Divider(
            height: 15,
            thickness: 5,
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              'Schlafqualität',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            children: [
              StatusWidget(
                widget.key,
                'schlaf',
                'Ausgeruht',
                0xeae2,
                Colors.blue,
                statusList,
              ),
              StatusWidget(
                widget.key,
                'schlaf',
                'Neutral',
                0xe42d,
                Colors.blue,
                statusList,
              ),
              StatusWidget(
                widget.key,
                'schlaf',
                'Insomnie',
                59566,
                Colors.blue,
                statusList,
              ),
              StatusWidget(
                widget.key,
                'schlaf',
                'Albträume',
                59222,
                Colors.blue,
                statusList,
              ),
            ],
          ),
          ElevatedButton.icon(
            onPressed: () {
              saveSleep(statusList, dateTimeDay, zeit);
              // Respond to button press
            },
            icon: Icon(Icons.add, size: 18),
            label: Text("Hinzufügen"),
            style: ElevatedButton.styleFrom(
              primary: Colors.blue[200],
              onPrimary: Colors.white,
              onSurface: Colors.grey,
            ),
          )
        ])
        
        
        );



  }

  void saveSleep(
      List<StatusIcons> statusList, DateTime dateTimeDay, String dauerSchlaf) {
         final User user = FirebaseAuth.instance.currentUser;
      final uid= user.uid;
    StatusIcons sleep =
        statusList.firstWhere((element) => element.id == "schlaf");
    Sleep sleepi = new Sleep(
        userid: uid,
        datum: dateTimeDay,
        dauerSchlaf: dauerSchlaf,
        sleepicon: sleep);
    print(sleepi);
    print(sleepi.toJson());
    sleepSetup(sleepi);
    print(statusList[0].toJson());
  }
}

Future<void> sleepSetup(Sleep sleep) async {
  CollectionReference sleepref = FirebaseFirestore.instance.collection('sleep');
  sleepref.add(sleep.toJson());
}
