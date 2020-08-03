import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:jiffy/jiffy.dart';
import 'package:potholedetection/ANewLogin/login.dart';
import 'package:potholedetection/screens/alertmode.dart';
import 'package:potholedetection/screens/cameramode.dart';
import 'package:potholedetection/screens/fixedpots.dart';
import 'package:potholedetection/screens/maps.dart';
import 'package:potholedetection/screens/mypotholes.dart';
import 'package:potholedetection/screens/newtravel.dart';

Color primaryColor = Color(0xff0074ff);

class MainDashboard extends StatefulWidget {
  final String uid;
  MainDashboard(this.uid);
  @override
  _MainDashboardState createState() => _MainDashboardState(uid);
}

class _MainDashboardState extends State<MainDashboard> {
  final String uid;
  _MainDashboardState(this.uid);

  int _selectedItemIndex = 0;

  List<DocumentSnapshot> listtravel = List();
  List<DocumentSnapshot> newlist = List();
  List<DocumentSnapshot> newlist2 = List();
  List<DocumentSnapshot> listimage = List();
  List<DocumentSnapshot> listfixed = List();
  List<DocumentSnapshot> newfixed = List();

  int shownotif=0;

  bool isLoading = false;
  int count1 = 0;
  int count2 = 0;
  int count3 = 0;
  int count4 = 0;
  int count5 = 0;
  int count6 = 0;
  int count7 = 0;
  List<DocumentSnapshot> notif = List();
  List<Countbyuser> countlist = List();
  List<Countbyuser> newcount = List();
  int _currentIndex = 0;

  List<charts.Series<Countbyuser, String>> _seriesBarData;

  filterdata() {
    countlist = [];
    List<String> uids = List();
var rng = new Random();
                        var code = rng.nextInt(9000) + 1000;
                        // var docid;
    // for(int i=0; i<newlist.length; i++)
    // {
    //   docid = "POT"+code.toString()+newlist[i].data["userid"].toString().substring(0,3);
    // }

    for (int i = 0; i < newlist.length; i++) {
      for (int j = 0;
          j < newlist[i].data["userid"].toString().split(',').length;
          j++) {
        if (newlist[i].data["userid"].toString().split(',')[j].trim() == uid.trim()) {
          newlist2.add(newlist[i]);
        }
      }
    }


    for (int i = 0; i < listfixed.length; i++) {
       
      for (int j = 0;
          j < listfixed[i].data["userid"].toString().split(',').length;
          j++) {
        if (listfixed[i].data["userid"].toString().split(',')[j].trim() == uid.trim()) {
          newfixed.add(listfixed[i]);
        }
      }
    }
print("fixed");
    print(newfixed.length);
notif = [];
    for(int i =0; i<newfixed.length; i++)
    {
      if(newfixed[i].data["seen"]=="no")
      {
        setState(() {
          shownotif = 1;
        });
        notif.add(newfixed[i]);
      }
    }

    a = newlist2.length + newfixed.length;
    print(newlist.length);
    print("lenn");
    for (int i = 0; i < newlist2.length; i++) {
      if (newlist2[i].data["timeStamp"].toDate().toString().split(' ')[0] ==
          DateTime.now().toString().split(' ')[0]) {
        count1++;
      }
      if (newlist2[i].data["timeStamp"].toDate().toString().split(' ')[0] ==
          DateTime.now()
              .subtract(const Duration(days: 1))
              .toString()
              .split(' ')[0]) {
        count2++;
      }
      if (newlist2[i].data["timeStamp"].toDate().toString().split(' ')[0] ==
              DateTime.now()
                  .subtract(const Duration(days: 2))
                  .toString()
                  .split(' ')[0]
          //  &&
          // newlist[i].data["userid"] == uid
          ) {
        count3++;
      }
      if (newlist2[i].data["timeStamp"].toDate().toString().split(' ')[0] ==
          DateTime.now()
              .subtract(const Duration(days: 3))
              .toString()
              .split(' ')[0]) {
        count4++;
      }
      if (newlist2[i].data["timeStamp"].toDate().toString().split(' ')[0] ==
          DateTime.now()
              .subtract(const Duration(days: 4))
              .toString()
              .split(' ')[0]) {
        count5++;
      }
      if (newlist2[i].data["timeStamp"].toDate().toString().split(' ')[0] ==
          DateTime.now()
              .subtract(const Duration(days: 5))
              .toString()
              .split(' ')[0]) {
        count6++;
      }
      if (newlist2[i].data["timeStamp"].toDate().toString().split(' ')[0] ==
          DateTime.now()
              .subtract(const Duration(days: 6))
              .toString()
              .split(' ')[0]) {
        count7++;
      }
    }
    print("count");
    print(count1);
    print(count2);
    print(count3);
    print(count4);
    print(count5);
    print(count6);
    print(count7);
    print("first");
    print(countlist);
    countlist.add(Countbyuser(uid, DateTime.now(), count1));
    countlist.add(Countbyuser(
        uid, DateTime.now().subtract(const Duration(days: 1)), count2));
    countlist.add(Countbyuser(
        uid, DateTime.now().subtract(const Duration(days: 2)), count3));
    countlist.add(Countbyuser(
        uid, DateTime.now().subtract(const Duration(days: 3)), count4));
    countlist.add(Countbyuser(
        uid, DateTime.now().subtract(const Duration(days: 4)), count5));
    countlist.add(Countbyuser(
        uid, DateTime.now().subtract(const Duration(days: 5)), count6));
    countlist.add(Countbyuser(
        uid, DateTime.now().subtract(const Duration(days: 6)), count7));

    countlist = countlist.reversed.toList();
    print("done");
    for (int i = 0; i < countlist.length; i++) print(countlist[i].count);
  }

  // sortbydate(listn) {
    Comparator<DocumentSnapshot> sortById =
        (a, b) => a.data["timeStamp"].compareTo(b.data["timeStamp"]);
    // newlist2.sort(sortById);
    // print(listn);
    // print(listn[0].data["timeStamp"].toDate());
    // return listn;
  // }

  _generateData(countlist) {
    _seriesBarData = List<charts.Series<Countbyuser, String>>();
    _seriesBarData.add(
      charts.Series(
        // displayName: " ",
        domainFn: (Countbyuser potbyme, _) =>
            Jiffy(potbyme.date).MEd.split(',')[0] +
            "\n" +
            Jiffy(potbyme.date).MEd.split(',')[1],
        measureFn: (Countbyuser potbyme, _) => potbyme.count,
        fillColorFn: (_, __) => charts.Color.fromHex(code: '#940068'),
        id: 'Potholes',
        data: countlist,
      ),
    );
  }

  void initState() {
    getlist();
    super.initState();
  }

  getlist() async {
    QuerySnapshot querySnapshottravel =
        await Firestore.instance.collection("location_travel").getDocuments();
    listtravel = querySnapshottravel.documents;

    newlist = listtravel.reversed.toList();
    QuerySnapshot querySnapshotfixed =
        await Firestore.instance.collection("fixed_potholes").getDocuments();
    listfixed = querySnapshotfixed.documents;
    setState(() {
      isLoading = true;
    });
    print(listtravel);
    filterdata();
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  var a;
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      // bottomNavigationBar: _buildBottomBar(),
      body: (!isLoading)
          ? Center(child: CircularProgressIndicator())
          : _buildBody(context),
    );
  }

  void nopotalert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          contentPadding: EdgeInsets.only(top: 10.0),
          content: Container(
            width: 300.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "Yay!",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.0,
                ),
                Divider(
                  color: Colors.grey,
                  height: 4.0,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: 12.0, right: 12.0, top: 10.0, bottom: 10.0),
                  child: Text(
                      notif.length.toString() + " potholes that you reported have been fxed!" ,
                      textAlign: TextAlign.center),
                ),
                InkWell(
                  onTap: () {
                    for(int i=0; i<notif.length; i++)
                    {
                     Firestore.instance
                  .collection("fixed_potholes")
                  .document(notif[i].documentID)
                  .updateData({
                "seen":"yes",
              }).then((_) {
                print("Success");
                
                    });
                    }
                    getlist();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FixedPotholes(uid: uid, fixed: notif)));
                  },
                  child: Container(
                    padding: EdgeInsets.only(top: 17.0, bottom: 17.0),
                    decoration: BoxDecoration(
                      color: Color(0xFF89216B),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(32.0),
                          bottomRight: Radius.circular(32.0)),
                    ),
                    child: Text(
                      "View Details",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: (shownotif==1) ?Icon(Icons.notifications) : Icon(Icons.notifications_off),
        onPressed: () {
          (shownotif==1)? 
          nopotalert() : null;
        }
        ),
      // automaticallyImplyLeading: false,
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
      title: Text('Dashboard'),
      elevation: 0,
      actions: <Widget>[
        GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(28.0))),
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                      title: Text('Warning'),
                      content: Text('Are you sure you want to log out?'),
                      actions: [
                        FlatButton(
                            child: Text(
                              'Yes',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            onPressed: () {
                              FirebaseAuth.instance
                                  .signOut()
                                  .then((result) => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage())))
                                  .catchError((err) => print(err));
                            }),
                        FlatButton(
                          child: Text(
                            'No',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  });
            },
            child: Icon(Icons.exit_to_app)),
        SizedBox(width: 10),
      ],
    );
  }

  Widget _buildChart(BuildContext context, List<Countbyuser> potholes) {
    countlist = potholes;
    _generateData(countlist);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'Potholes recorded by you',
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: charts.BarChart(
                  _seriesBarData,
                  barGroupingType: charts.BarGroupingType.grouped,
                  // defaultRenderer: new charts.BarRendererConfig(
                  //     cornerStrategy: const charts.ConstCornerStrategy(60)),
                  animate: true,
                  animationDuration: Duration(seconds: 2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Flexible(
          flex: 2,
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xFFDA4453),
                  Color(0xFF89216B),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            height: 200.0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 35),
                  Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(children: <Widget>[
                          Text(listtravel.length.toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 55.0,
                                  fontWeight: FontWeight.w400)),
                          SizedBox(height: 10.0),
                          Text("Total Potholes\nrecorded in India",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400),
                              textAlign: TextAlign.center),
                        ]),
                        Column(children: <Widget>[
                          Text(listfixed.length.toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 55.0,
                                  fontWeight: FontWeight.w400)),
                          SizedBox(height: 10.0),
                          Text("Total Potholes\nfixed in India",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w400),
                              textAlign: TextAlign.center),
                        ])
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 200.0,
            child: _buildChart(context, countlist),
          ),
        ),
        GestureDetector(
          
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyPotholes(uid: uid,list: newlist2, fixed: newfixed)));
          },
          child: ListTile(
            leading: Icon(Icons.location_on, color: Colors.black),
            title: Text("MY POTHOLES",
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(a.toString() + " potholes"),
          ),
        ),
      ],
    );
  }

  Widget buildNavBarItem(IconData icon, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedItemIndex = index;
        });
      },
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width / 5,
        decoration: BoxDecoration(
          color: index == _selectedItemIndex ? Colors.red : Colors.white,
        ),
        child: Icon(
          icon,
          color: index == _selectedItemIndex ? Colors.black : Colors.grey,
          size: 25.0,
        ),
      ),
    );
  }
}

class Countbyuser {
  final String uid;
  final DateTime date;
  final int count;

  Countbyuser(this.uid, this.date, this.count);
}
