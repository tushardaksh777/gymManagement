import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_management/AddUser/createUser.dart';
import 'package:gym_management/DTO/User.dart';
import 'package:gym_management/HomeList/DueUserList.dart';
import 'package:gym_management/Server/Services.dart';

import 'globalData.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkforLength();
  }

  TabController? _tabController;
  int tabIndex = 0;
  value _value = value.active;

  int activeUser = 0;
  int inactiveUser = 0;
  int allUser = 0;
  int remainingUser = 0;
  int overdueUser = 0;
  @override
  Widget build(BuildContext context) {
    _tabController =
        new TabController(length: 2, vsync: this, initialIndex: tabIndex);
    double unitwidth = MediaQuery.of(context).size.width / 100;
    double unitheight = MediaQuery.of(context).size.height / 100;
    return Container(
        color: Colors.grey[900],
        child: RefreshIndicator(
            onRefresh: reload,
            child: ListView(
              shrinkWrap: true,
              children: [
                Container(
                    width: unitwidth * 100,
                    height: unitwidth * 13,
                    color: Colors.grey[900],
                    margin: EdgeInsets.symmetric(
                        horizontal: unitwidth * 7, vertical: unitwidth * 2),
                    child: Theme(
                        data: Theme.of(context).copyWith(
                            unselectedWidgetColor: Colors.white,
                            disabledColor: Colors.blue),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
// Container(width: unitwidth* 40,height: unitwidth*4,child:
// Row(children: [
//     Checkbox(value: true, onChanged: (onChanged){

//   }),
//   Text("Online Fee Deposit" , style: GoogleFonts.montserrat(
//                                           textStyle: TextStyle(
//                                               color: Colors.black,
//                                               fontSize: unitwidth *
//                                                   1 *
//                                                   3)),)

// ],)
// ,),

                            Row(
                              children: [
                                Radio(
                                    value: value.active,
                                    groupValue: _value,
                                    onChanged: (onChanged) {
                                      setState(() {
                                        //print("Radio 1" + onChanged!.toString());
                                        _value = onChanged!;
                                      });
                                    },
                                    activeColor: Colors.white),
                                Text(
                                  "Active ($activeUser)",
                                  style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: unitwidth * 1 * 3)),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                    value: value.inactive,
                                    groupValue: _value,
                                    onChanged: (onChanged) {
                                      setState(() {
                                        //print("Radio 1" + onChanged!.toString());
                                        _value = onChanged!;
                                      });
                                    },
                                    activeColor: Colors.white),
                                Text(
                                  "Inactive ($inactiveUser)",
                                  style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: unitwidth * 1 * 3)),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                    value: value.all,
                                    groupValue: _value,
                                    onChanged: (onChanged) {
                                      setState(() {
                                        //print("Radio 1" + onChanged!.toString());
                                        _value = onChanged!;
                                      });
                                    },
                                    activeColor: Colors.white),
                                Text(
                                  "All User ($allUser)",
                                  style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: unitwidth * 1 * 3)),
                                )
                              ],
                            ),
                          ],
                        ))),
                Divider(
                  height: unitwidth * 2,
                  thickness: unitwidth * 1,
                ),
                if (_value == value.active)
                  Column(
                    children: [
                      Container(
                          width: unitwidth * 100,
                          height: unitheight * 5,
                          child: TabBar(
                            automaticIndicatorColorAdjustment: false,
                            tabs: [
                              Tab(
                                child: Text(
                                  "Remaining Days ($remainingUser)",
                                  style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                          color: Colors.white.withOpacity(0.7),
                                          fontWeight: FontWeight.w600,
                                          fontSize: unitwidth * 1 * 3.5)),
                                ),
                              ),
                              Tab(
                                child: Text(
                                  "OverDue Days ($overdueUser)",
                                  style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                          color: Colors.white.withOpacity(0.7),
                                          fontWeight: FontWeight.w600,
                                          fontSize: unitwidth * 1 * 3.5)),
                                ),
                              ),
                            ],
                            controller: _tabController,
                            onTap: _onItemTapped,
                            indicatorColor: Colors.blue,
                            indicatorWeight: unitwidth * 0.5,
                          )),
                      SizedBox(
                        height: unitheight * 1,
                      ),
                      FutureBuilder(
                          future: getUser(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                              return CircularProgressIndicator();
                            } else {
                              return Column(
                                children: [
                                  for (var user in snapshot.data)
                                    if (checkForUser(user))
                                      DueUser(
                                        user: user,
                                      )
                                ],
                              );
                            }
                          })
                    ],
                  )
                else
                  FutureBuilder(
                      future: getUser(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        } else {
                          return Column(
                            children: [
                              for (var user in snapshot.data)
                                //if(checkForUser(user))
                                DueUser(
                                  user: user,
                                )
                            ],
                          );
                        }
                      })

                // for(int i =0 ; i<2 ;i++)
                // DueUser()
              ],
            )));
  }

  Future<void> reload() async {
    checkforLength();
    return setState(() {});
  }

  getUser() async {
    // var s = await Services().gettestUserData();
    //print("Start "+s.toString());
    List<UserModel> userList = new List<UserModel>.empty(growable: true);
    if (_value == value.active) {
      userList = await Services().getActiveUser();
      activeUser = userList.length;
      userList.sort((a, b) {
        DateTime aDT = DateTime.parse(a.feeSubmitDate!);
        DateTime bDT = DateTime.parse(b.feeSubmitDate!);

        return aDT.compareTo(bDT);
      });

      //  userList.sort((a, b) {
      //    //bool status = false;
      //   activeMode status1 = activeMode.active;
      //   activeMode status2 = activeMode.active;
      //   if(a.status! == "inactive"){
      //     status1 = activeMode.inactive;
      //   }
      //   if(b.status == "inactive"){
      //     status2 == activeMode.inactive;
      //   }

      //   if(status1 == activeMode.active && status2 == activeMode.active){
      //     return 0;
      //   }else if(status1 == activeMode.active && status2 == activeMode.inactive){
      //     return -1;
      //   }else{
      //     return 1;
      //   }

      // });

      //print("Active User "+userList.toString());
    } else if (_value == value.all) {
      userList = await Services().getAllUser();
      userList.sort((a, b) {
        return a.name!.toLowerCase().compareTo(b.name!.toLowerCase());
      });
      // print("Active User "+userList.toString());
    } else {
      userList = await Services().getInactiveUser();
      userList.sort((a, b) {
        return a.name!.toLowerCase().compareTo(b.name!.toLowerCase());
      });
    }
    return userList;
  }

  checkForUser(UserModel user) {
    String joiningDate = user.feeSubmitDate!;
    DateTime d = DateTime.parse(joiningDate);
    DateTime now = DateTime.now();

    //  print("Dates "+d.toString() + "  "+now.toString());

    int remainingDays = 0;
    bool remain = false;

    if (d.isAfter(now)) {
      remain = true;

      // print("before");
    }

    if (tabIndex == 0) {
      //Remaining Days  current date is before fee submit date
      if (remain) {
        //remainingUser = remainingUser+1;
        return true;
      }
    } else {
      //Due Days current date is after fee submit date
      if (!remain) {
        //overdueUser = overdueUser+1;
        return true;
      }
    }

    return false;
  }

  refresh() {
    checkforLength();

    setState(() {
      // print("refresh done");
    });
  }

  _onItemTapped(int index) {
    setState(() {
      tabIndex = index;
    });
  }

  checkforLength() async {
    List<UserModel> i = await Services().getAllUser();
    List<UserModel> userList = await Services().getActiveUser();
    List<UserModel> Inactive = await Services().getInactiveUser();

    int r = 0;
    int due = 0;
    int ina = Inactive.length;

    for (var i = 0; i < userList.length; i++) {
      String joiningDate = userList[i].feeSubmitDate!;
      DateTime d = DateTime.parse(joiningDate);
      DateTime now = DateTime.now();

      //print("Dates "+d.toString() + "  "+now.toString());

      int remainingDays = 0;
      bool remain = false;

      if (d.isAfter(now)) {
        remain = true;

        // print("before");
      }

      if (remain) {
        r = r + 1;
      } else {
        due = due + 1;
      }

      //  if(tabIndex == 0){    //Remaining Days  current date is before fee submit date

      //  }else{    //Due Days current date is after fee submit date
      //     if(!remain){
      //       //overdueUser = overdueUser+1;
      //     return true;
      //   }
      //  }
    }
    // print("Active ${userList.length.toString()} All ${i.length.toString()} Remain $r OverDue $due");

    setState(() {
      if (i.isNotEmpty) {
        allUser = i.length;
      }

      remainingUser = r;
      overdueUser = due;
      inactiveUser = ina;
    });
  }
}
