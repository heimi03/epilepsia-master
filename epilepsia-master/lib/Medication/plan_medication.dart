import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epilepsia/config/widget/widget.dart';
import 'package:epilepsia/model/healthy/stimmung.dart';
import 'package:epilepsia/model/medication/medication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
 final User user = FirebaseAuth.instance.currentUser;
 

class PlanMedication extends StatefulWidget {
  PlanMedication({
    Key key,
  }) : super(key: key);
  @override
  _PlanMedicationState createState() => _PlanMedicationState();
}

var result;

class _PlanMedicationState extends State<PlanMedication> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getMedicationData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return CupertinoActivityIndicator(
              radius: 20,
            );
          } else {
            var data = snapshot.data as List<Medication>;
            return Scaffold(
              body: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    Medication item = data[index];
                    return Card(
                      color: item.farbe.color,
                      margin: const EdgeInsets.only(right: 30, left: 30, top: 20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: Text("Medikamentenname:  " + item.name)), 
                              Expanded(child: Container(
                                child: Icon(IconData(item.icon.iconData , fontFamily: 'MaterialIcons'),)),),
                              
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text("Dosis:  " + item.dosis)),
                              Expanded(
                                child: Text("Wiederholung:  " + item.wiederholungen)), 
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
            );
          }
        });
  }
}

Future<List<Medication>> getMedicationData() async {
  List<Medication> list = <Medication>[];
  print("list");
  result = await firestore
      .collection("medication")
      //.where("datum", isEqualTo: date)
      .where("userId", isEqualTo: user.uid)
      .get();

  result.docs.forEach((result) {
    var data = result.data();
    print(data);
    Medication medication = new Medication.fromJson(data);
    print(medication.toJson());
    list.add(medication);
  });

  // setState(() {
  //   getDataBoolMedication = true;
  // });
  print(list);
  return list;
}
