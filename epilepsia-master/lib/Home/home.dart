import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epilepsia/config/router.dart';

import 'package:epilepsia/config/widget/widget.dart';

import 'package:epilepsia/model/healthy/stimmung.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../model/meeting.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class Home extends StatefulWidget {
  Home({
    Key key,
  }) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

final timeController = TextEditingController();
final timeController1 = TextEditingController();
final dateController = TextEditingController();
TextEditingController nameController = TextEditingController();
String fullName = '';
DateFormat format = DateFormat('dd.MM.yyyy');
TimeOfDay von;
TimeOfDay bis;
DateTime datum;
List<StatusIcons> statusList = <StatusIcons>[];


class _HomeState extends State<Home> {
  List<StatusIcons> statusList = <StatusIcons>[];
  @override
  Widget build(BuildContext context) {
    final AlertDialog dialog = AlertDialog(
      title: Text('Termin hinzufügen'),
      content: Form(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.drive_file_rename_outline),
                    border: OutlineInputBorder(),
                    labelText: 'Terminname',
                  ),
                  onChanged: (text) {
                    setState(() {
                      fullName = text;
                    });
                  }),
              Container(
                child: TextField(
                  readOnly: true,
                  controller: dateController,
                  decoration: InputDecoration(
                      hoverColor: Colors.blue[200], hintText: 'Datum'),
                  onTap: () async {
                    var date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100));
                    dateController.value =
                        TextEditingValue(text: format.format(date));

                    setState(() {
                      datum = date;
                    });
                  },
                ),
              ),
              TextField(
                readOnly: true,
                controller: timeController,
                decoration: InputDecoration(
                    hoverColor: Colors.blue[200], hintText: 'Von'),
                onTap: () async {
                  var time = await showTimePicker(
                    initialTime: TimeOfDay.now(),
                    context: context,
                  );

                  timeController.text = time.format(context);

                  setState(() {
                    von = time;
                  });
                },
              ),
              TextField(
                readOnly: true,
                controller: timeController1,
                decoration: InputDecoration(
                    hoverColor: Colors.blue[200], hintText: 'Bis'),
                onTap: () async {
                  var time = await showTimePicker(
                    initialTime: TimeOfDay.now(),
                    context: context,
                  );

                  timeController1.text = time.format(context);

                  setState(() {
                    bis = time;
                  });
                },
              ),
              Row(
                children: [
                  StatusWidget(
                    widget.key,
                    'farbe',
                    '',
                    57594,
                    Colors.green,
                    statusList,
                  ),
                  StatusWidget(
                    widget.key,
                    'farbe',
                    '',
                    57594,
                    Colors.blue,
                    statusList,
                  ),
                  StatusWidget(
                    widget.key,
                    'farbe',
                    '',
                    57594,
                    Colors.yellow,
                    statusList,
                  ),
                  StatusWidget(
                    widget.key,
                    'farbe',
                    '',
                    57594,
                    Colors.red,
                    statusList,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Abbrechen'),
        ),
        TextButton(
          onPressed: () {
            print(statusList);
            saveTermin(null, fullName, datum, von, bis, statusList);
            Navigator.pop(context);
          },
          child: Text("Hinzufügen"),
        ),
      ],
    );

    return Container(
      padding: EdgeInsets.only(bottom: 2),
      color: Colors.blueGrey[50],
      child: Column(
        children: <Widget>[
          Container(
           alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 5),
          ),
       
         Column(
            children: [
                Container(
                  width: 400,
                  margin:
                      EdgeInsets.only(top: 40, bottom: 5, left: 1, right: 1),
                  height: 100,
                  //decoration: BoxDecoration(border: Border.all(),borderRadius: BorderRadius.all(Radius.circular(20)),),
                  child: Row(children: [
    Container(
                    alignment: Alignment.bottomLeft,
                    margin:
                      EdgeInsets.only(left: 10),
                  child: TextButton(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.eco,
                          size: 50,
                          color: Colors.white,
                        ),
                        Text(
                          "Gesundheit",
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, routeSymptoms);
                    },
                  ), 
    ),
                  Container(
                    margin: const EdgeInsets.only(left: 100,),
                     alignment: Alignment.centerRight,
                    child: Image.asset('assets/image/health.png',
                        width: 140,
                        height: 100,),),
                  ],
                  ),
                    color: Colors.indigo[200],
                  ),
                   
                
              
                
          
                Container(
                  width: 400,
                  margin:
                      EdgeInsets.only(top: 10, bottom: 5, left: 1, right: 1),
                  height: 100,
                  child: TextButton(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.av_timer,
                          size: 50,
                          color: Colors.white,
                        ),
                        Text(
                          "Tagesablauf",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, routeDaily);
                    },
                  ),
                  color: Colors.blueGrey[200],
                ),
       
                Container(
                  width: 400,
                  margin:
                      EdgeInsets.only(top: 10, bottom: 5, left: 1, right: 1),
                  height: 100,
                  child: TextButton(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.medical_services_outlined,
                          size: 50,
                          color: Colors.white,
                        ),
                        Text(
                          "Medikation",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, routeMedication);
                    },
                  ),
                  color: Colors.blue[100],
                ),
           
            Container(
            width: 400,
                  margin:
                      EdgeInsets.only(top: 30, bottom: 5, left: 1, right: 1),
                       child: TextButton(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 50,
                          color: Colors.white,
                        ),
                        Text(
                          "Termin eintragen",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    onPressed: () {
                      showDialog<void>(
                          context: context, builder: (context) => dialog);
                    },
                  ),
            color: Colors.teal,
          ),
           
            ],

          ),
         
        ],
      ),
    );
  }
}

void saveTermin(
  String userid,
  String name,
  DateTime tagesauswahl,
  TimeOfDay von,
  TimeOfDay bis,
  List<StatusIcons> statusList,
  
) {
  DateTime from = new DateTime(tagesauswahl.year, tagesauswahl.month,
      tagesauswahl.day, von.hour, von.minute);
  DateTime to = new DateTime(tagesauswahl.year, tagesauswahl.month,
      tagesauswahl.day, bis.hour, bis.minute);
  Meeting termin = new Meeting(
    eventName: name,
    from: from,
    to: to,
    isAllDay: false,
    background: statusList[0].color,
    userId: FirebaseAuth.instance.currentUser.uid
  );
  terminSetup(termin);
}

Future<void> terminSetup(Meeting termin) async {
  CollectionReference terminref =
      FirebaseFirestore.instance.collection('termin');
  terminref.add(termin.toJson());
}
