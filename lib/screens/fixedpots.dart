import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

import 'TestNew/mypotdetails.dart';

class FixedPotholes extends StatefulWidget {
  final String uid;
  final List<DocumentSnapshot> fixed;

  const FixedPotholes({Key key, this.uid, this.fixed}) : super(key: key);
  @override
  _MyPotholesState createState() => _MyPotholesState(fixed);
}

class _MyPotholesState extends State<FixedPotholes> {
  final List<DocumentSnapshot> fixed;
  _MyPotholesState(this.fixed);

  List<String> dropdown = [
    'View all potholes',
    'Ward',
  ];
  String _selectedLocation;
  int all = 1;
  List<LocalityCount> listuni = List();
  List<LocalityCount> listloc = List();
  List<DocumentSnapshot> listtravel = List();
  List<DocumentSnapshot> list2 = List();

  void initState() {
    // for(int i=0; i<fixed.length; i++)
    // {
    //   Firestore.instance.collection("fixed_potholes").document(fixed[i].documentID).updateData({
    //     "fixedstatus": "YES"
    //   });
    // }

    // listtravel = list;
    // list2 = list;
    list2.addAll(fixed);
    // listtravel = list2;
    // print(list2.length);
  }

  //   getlocfilteredlist(String sublocality) {
  //   List<DocumentSnapshot> retlist = List();
  //   for (int i = 0; i < list2.length; i++) {
  //     print(list2[i].data["subLocality"]);
  //     if (list2[i].data["subLocality"] == sublocality) {
  //       retlist.add(list2[i]);
  //     }
  //   }
  //   return retlist;
  // }

  // checkdata(newlist) {
  //   List<String> list1 = List();
  //   List<LocalityCount> listlocret = List();
  //   for (int i = 0; i < newlist.length; i++) {
  //     list1.add(newlist[i].data["subLocality"]);
  //   }

  //   var map = Map();

  //   list1.forEach((element) {
  //     if (!map.containsKey(element)) {
  //       map[element] = 1;
  //     } else {
  //       map[element] += 1;
  //     }
  //   });

  //   print(map);
  //   map.forEach((k, v) => listlocret.add(LocalityCount(k, v)));
  //   print(listlocret);
  //   return listlocret;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xFFDA4453),
                  Color(0xFF89216B),
                ],
              ),
            ),
          ),
          title: Text('My fixed potholes'),
          elevation: 0,
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: <Widget>[
              Expanded(
                child: Container(
                  child: ListView.builder(
                      shrinkWrap: false,
                      itemCount: list2.length,
                      itemBuilder: (context, i) {
                        return Column(
                          children: <Widget>[
                            ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyPotDetails(
                                            uid: widget.uid, list: list2[i])));
                              },

                              title: Text(
                                list2[i].data["address"]
                                // list2[i].data["address"].toString().split(',')[0]+", "+list2[i].data["address"].toString().split(',')[1] + ", " + list2[i].data["address"].toString().split(',')[2]+", "+ list2[i].data["address"].toString().split(',')[3]
                                ,
                                style: TextStyle(fontSize: 13.0),
                              ),
                              subtitle: Text(
                                  Jiffy(list2[i].data["timeStamp"].toDate())
                                      .yMMMEdjm),
                              trailing: Icon(Icons.check_circle,
                                  color: Colors.green, size: 16.0),
                              // trailing: (list[i].data["status"]== null)? Icon(Icons.brightness_1) : (list[i].data["status"]=="STARTED") ? Icon(Icons.build) : (list[i].data["status"]=="ERSEEN") ? Icon(Icons.check) : (list[i].data["status"]=="FIXED") ? Icon(Icons.check_circle_outline) : Icon(Icons.brightness_1)
                            ),
                            // Divider(color: Colors.grey),
                          ],
                        );
                      }),
                ),
              ),
            ])));
  }
}

class LocalityCount {
  final String locality;
  final int count;

  LocalityCount(this.locality, this.count);
}
