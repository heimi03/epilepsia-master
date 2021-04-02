import 'package:epilepsia/Medication/add_medication.dart';
import 'package:epilepsia/Medication/plan_medication.dart';
import 'package:flutter/material.dart';



class MedicationWidget extends StatefulWidget {
   MedicationWidget({Key key,}) : super(key: key);
  @override
  _MedicationState createState() => _MedicationState();
}



class _MedicationState extends State<MedicationWidget> {
  @override
  Widget build(BuildContext context) {
   return DefaultTabController(
  length: 2,
  child: Scaffold(
    appBar: AppBar(
      bottom: TabBar(
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: Colors.white,
        tabs: [
          Tab(icon: Icon(Icons.medical_services), text: 'Medikament hinzufügen',),
          Tab(icon: Icon(Icons.medical_services_sharp), text: 'Arzneimittelplan',),
         
        ],
      ),
    ),
  body: TabBarView(
           children:[
             AddMedication(),
             PlanMedication(), ]
 
  ),
),
          );
   
  }
}