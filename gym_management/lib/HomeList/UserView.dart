import 'dart:developer';

import 'package:achievement_view/achievement_view.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_management/DTO/User.dart';
import 'package:gym_management/EditUser.dart';
import 'package:gym_management/Paid.dart';
import 'package:gym_management/Server/Services.dart';
import 'package:gym_management/editPayment.dart';
import 'package:gym_management/globalData.dart';
import 'package:intl/intl.dart';

class UserView extends StatefulWidget {
  UserModel user;
  UserView({super.key, required this.user});

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> with TickerProviderStateMixin {
  bool waitingForStatusResponse = false;
  bool waitForTransactionResponse = false;
  TabController? _tabController;
  int tabIndex = 0;

  final List<NeatCleanCalendarEvent> _eventList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setAttandance(DateTime.now());
    getUserById(widget.user.id!);
  }

  @override
  Widget build(BuildContext context) {
    //UserModel u = widget.user;
    _tabController =
        new TabController(length: 2, vsync: this, initialIndex: tabIndex);
    bool isActive = false;
    double unitwidth = MediaQuery.of(context).size.width / 100;
    double unitheight = MediaQuery.of(context).size.height / 100;
    double textscale = 0.9;
    return Scaffold(
      appBar: AppBar(title: Text("User Details"), actions: [
        Container(
          width: unitwidth * 7,
          height: unitheight * 5,
          alignment: Alignment.center,
          child: MaterialButton(
              minWidth: unitwidth * 6,
              height: unitheight * 5,
              padding: EdgeInsets.zero,
              onPressed: () {
                //deleteTransactionasking(context , data);
                deleteUserasking(context);
              },
              child: Icon(
                Icons.delete,
                color: Colors.red,
              )),
        ),
        SizedBox(
          width: unitwidth * 6,
        ),
      ]),
      bottomNavigationBar: Container(
          color: Colors.grey[900],
          alignment: Alignment.center,
          height: unitheight * 9,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Container(width: unitwidth*30,height: unitwidth*10,decoration: BoxDecoration(
              //   color: Colors.green, borderRadius: BorderRadius.all(Radius.circular(unitwidth*2))

              // ),alignment: Alignment.center,
              // child: Text("Due" , style:  GoogleFonts.montserrat(
              //             textStyle: TextStyle(
              //                 color: Colors.white,fontWeight: FontWeight.w600,
              //                 fontSize: unitwidth *
              //                     1 *
              //                     4)),),
              // ),
              MaterialButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => PaidForFee(
                                user: widget.user,
                              ))));
                },
                child: Container(
                  width: unitwidth * 80,
                  height: unitwidth * 10,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius:
                          BorderRadius.all(Radius.circular(unitwidth * 2))),
                  alignment: Alignment.center,
                  child: AutoSizeText("Pay",
                      style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: unitwidth * 1 * 4)),
                      textScaleFactor: textscale),
                ),
              ),
            ],
          )),
      body: Container(
          color: Colors.grey[900],
          child: RefreshIndicator(
            onRefresh: reload,
            child: ListView(
              children: [
                Column(
                  children: [
                    SizedBox(height: unitheight * 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: unitwidth * 20,
                          height: unitwidth * 20,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade800,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          margin: EdgeInsets.only(
                              left: unitwidth * 10, right: unitwidth * 5),
                          child: Icon(
                            Icons.people,
                            color: Colors.white,
                          ),
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    width: unitwidth * 2,
                                    height: unitheight * 2,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: (widget.user.status == "active")
                                            ? Colors.green
                                            : Colors.red)),
                                SizedBox(
                                  width: unitwidth * 2,
                                ),
                                Container(
                                  width: unitwidth * 30,
                                  height: unitheight * 5,
                                  alignment: Alignment.center,
                                  child: AutoSizeText(
                                    widget.user.name!,
                                    style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: unitwidth * 1 * 5.5)),
                                    textScaleFactor: textscale,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: unitheight * 1.5,
                            ),
                            AutoSizeText(
                                "Registration No. " +
                                    widget.user.registrationNo.toString(),
                                style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.6),
                                        fontWeight: FontWeight.w600,
                                        fontSize: unitwidth * 1 * 3)),
                                textScaleFactor: textscale)
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: unitwidth * 4,
                            ),
                            MaterialButton(
                              padding: EdgeInsets.zero,
                              minWidth: unitwidth * 6.5,
                              height: unitwidth * 7,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            EditUser(user: widget.user))));
                              },
                              child: Container(
                                width: unitwidth * 7,
                                height: unitwidth * 7,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade800,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                margin: EdgeInsets.symmetric(
                                    horizontal: unitwidth * 0),
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: unitheight * 2,
                    ),
                    Divider(
                        thickness: unitwidth * 0.9,
                        color: Colors.grey.shade800),
                    SizedBox(
                      height: unitheight * 1.5,
                    ),

                    //Active User and Unactive User

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: unitwidth * 30,
                          height: unitwidth * 10,
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(unitwidth * 2))),
                          child: MaterialButton(
                            onPressed: () {
                              if (widget.user.status != "active") {
                                userStatusasking(context, value.active);
                              } else {
                                Fluttertoast.showToast(
                                    msg: "User Already Active");
                              }
                            },
                            child: AutoSizeText("Active",
                                style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: unitwidth * 1 * 3)),
                                textScaleFactor: textscale),
                          ),
                        ),
                        Container(
                          width: unitwidth * 30,
                          height: unitwidth * 10,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(unitwidth * 2))),
                          child: MaterialButton(
                            onPressed: () {
                              if (widget.user.status != "inactive") {
                                userStatusasking(context, value.inactive);
                              } else {
                                Fluttertoast.showToast(
                                    msg: "User Already Inactive");
                              }
                            },
                            child: Text("InActive",
                                style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: unitwidth * 1 * 3)),
                                textScaleFactor: textscale),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: unitheight * 2,
                    ),
                    if (widget.user.status != "inactive" &&
                        checkForActiveDate())
                      Column(
                        children: [
                          Divider(
                              thickness: unitwidth * 0.9,
                              color: Colors.grey.shade800),
                          //SizedBox(height: unitheight*1.5,),
                          Container(
                            width: unitwidth * 100,
                            height: unitheight * 7.5,
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                AutoSizeText("Due Date",
                                    style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.w600,
                                            fontSize: unitwidth * 1 * 5.5)),
                                    textScaleFactor: textscale),
                                SizedBox(
                                  height: unitheight * 1,
                                ),
                                FutureBuilder(
                                    future:
                                        getDueDate(widget.user.feeSubmitDate!),
                                    builder: ((context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return Text("NA");
                                      } else {
                                        return AutoSizeText(
                                            snapshot.data.toString(),
                                            style: GoogleFonts.montserrat(
                                                textStyle: TextStyle(
                                                    color: Colors.white
                                                        .withOpacity(0.7),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize:
                                                        unitwidth * 1 * 5.5)),
                                            textScaleFactor: textscale);
                                      }
                                    }))
                              ],
                            ),
                          ),
                          // Divider(thickness: unitwidth*0.9,color: Colors.grey.shade800),

                          Divider(
                              thickness: unitwidth * 0.9,
                              color: Colors.grey.shade800),
                        ],
                      ),
                    if (widget.user.inactiveDate != null &&
                        calculateForLastDay(widget.user.feeSubmitDate!,
                            widget.user.inactiveDate!))
                      Column(
                        children: [
                          Divider(
                              thickness: unitwidth * 0.9,
                              color: Colors.grey.shade800),
                          //SizedBox(height: unitheight*1.5,),
                          Container(
                            width: unitwidth * 100,
                            height: unitheight * 9.5,
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                AutoSizeText("Last Due",
                                    style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.w600,
                                            fontSize: unitwidth * 1 * 5.5)),
                                    textScaleFactor: textscale),
                                SizedBox(
                                  height: unitheight * 0.5,
                                ),
                                FutureBuilder(
                                    future: getLastDueDayForInactive(
                                        widget.user.feeSubmitDate!,
                                        widget.user.inactiveDate!),
                                    builder: ((context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return Text("NA");
                                      } else {
                                        return Column(
                                          children: [
                                            AutoSizeText(
                                                snapshot.data.toString(),
                                                style: GoogleFonts.montserrat(
                                                    textStyle: TextStyle(
                                                        color: Colors.red
                                                            .withOpacity(0.7),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: unitwidth *
                                                            1 *
                                                            5.5)),
                                                textScaleFactor: textscale),
                                            SizedBox(
                                              height: unitheight * 1,
                                            ),
                                            AutoSizeText(
                                                DateFormat("dd-MMM-yyy").format(
                                                        DateTime.parse(widget
                                                            .user
                                                            .feeSubmitDate!)) +
                                                    " To " +
                                                    DateFormat("dd-MMM-yyy")
                                                        .format(DateTime.parse(
                                                            widget.user
                                                                .inactiveDate!)),
                                                style: GoogleFonts.montserrat(
                                                    textStyle: TextStyle(
                                                        color: Colors.white.withOpacity(0.5),
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: unitwidth * 1 * 4.5)),
                                                textScaleFactor: textscale)
                                          ],
                                        );
                                      }
                                    }))
                              ],
                            ),
                          ),
                          // Divider(thickness: unitwidth*0.9,color: Colors.grey.shade800),

                          Divider(
                              thickness: unitwidth * 0.9,
                              color: Colors.grey.shade800),
                        ],
                      ),

                    Container(
                        width: unitwidth * 100,
                        height: unitheight * 6,
                        child: TabBar(
                          automaticIndicatorColorAdjustment: false,
                          tabs: [
                            Tab(
                              child: AutoSizeText("Fees Details",
                                  style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                          color: Colors.white.withOpacity(0.7),
                                          fontWeight: FontWeight.w600,
                                          fontSize: unitwidth * 1 * 3.5)),
                                  textScaleFactor: textscale),
                            ),
                            Tab(
                              child: AutoSizeText("Attandance",
                                  style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                          color: Colors.white.withOpacity(0.7),
                                          fontWeight: FontWeight.w600,
                                          fontSize: unitwidth * 1 * 3.5)),
                                  textScaleFactor: textscale),
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
                    if (tabIndex == 0)
                      Container(
                          width: unitwidth * 100,
                          height: unitheight * 40,
                          child: ListView(
                            children: [
                              Column(
                                children: [
                                  FutureBuilder(
                                      future: getFeeDetails(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return CircularProgressIndicator();
                                        } else {
                                          return Column(
                                            children: [
                                              for (var data in snapshot.data)
                                                feeDetailsList(
                                                    unitwidth, unitheight, data)
                                            ],
                                          );
                                        }
                                      }),
                                  //Transaction List
                                  // for(int i = 0 ; i < 4;i++ )
                                  // feeDetailsList(unitwidth ,unitheight) //TODO  ////Fees Details API
                                ],
                              ),
                            ],
                          )),
                    if (tabIndex == 1)
                      Container(
                        color: Colors.white,

                        ///TODO Attandance API
                        width: unitwidth * 100, height: unitheight * 50,
                        child: Calendar(
                          startOnMonday: true,
                          weekDays: [
                            'Monday',
                            'Tuseday',
                            'Wednesday',
                            'Thursday',
                            'Friday',
                            'Saturday',
                            'Sunday'
                          ],
                          eventsList: _eventList,
                          // isExpandable: true,
                          displayMonthTextStyle: TextStyle(
                              color: Colors.black, fontSize: unitwidth * 3),
                          hideTodayIcon: false,
                          hideArrows: false,
                          bottomBarArrowColor: Colors.white,
                          eventDoneColor: Colors.green,
                          selectedColor: Colors.pink,
                          selectedTodayColor: Colors.red,
                          todayColor: Colors.blue,
                          onDateSelected: (value) {
                            // setState(() {
                            //   print("Month change " + value.toString());
                            //   setAttandance(value);
                            // });
                          },
                          //locale: 'de_DE',
                          //todayButtonText: 'Heute',
                          allDayEventText: 'Ganztägig',
                          multiDayEndText: 'Ende',
                          isExpanded: true,

                          //expandableDateFormat: 'EEEE, dd. MMMM yyyy',
                          datePickerType: DatePickerType.date,
                          defaultDayColor: Colors.black,
                          initialDate: DateTime.now(),

                          onMonthChanged: ((value) {}),
                          dayOfWeekStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontSize: unitwidth * 2.5),
                        ),
                      )
                  ],
                )
              ],
            ),
          )),
    );
  }

  _onItemTapped(int index) {
    setState(() {
      tabIndex = index;
    });
  }

  Future<void> reload() async {
    getUserById(widget.user.id!);
    return setState(() {});
  }

  userStatusasking(BuildContext context, value status) {
    DateTime submitDate = DateTime.now();
    String submitingDateShow = DateFormat("dd").format(submitDate) +
        "  " +
        DateFormat("MMMM").format(submitDate) +
        "  " +
        DateFormat("y").format(submitDate);
    double textscalefactor = 0.8;
    double unitwidth = MediaQuery.of(context).size.width / 100;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Change User Status ",
                style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                        color: Colors.black, fontSize: unitwidth * 5)),
                textScaleFactor: 1),
            content: StatefulBuilder(
              builder: (context, setState) {
                return Container(
                  width: unitwidth * 100,
                  height: unitwidth * 40,
                  child: Column(
                    children: [
                      Container(
                        width: unitwidth * 100,
                        height: unitwidth * 13,
                        margin: EdgeInsets.symmetric(
                            horizontal: unitwidth * 7, vertical: unitwidth * 2),
                        child: Row(
                          children: [
                            SizedBox(
                              width: unitwidth * 3,
                            ),
                            Icon(Icons.date_range,
                                color: Colors.blue, size: unitwidth * 4),
                            SizedBox(
                              width: unitwidth * 2,
                            ),
                            AutoSizeText(
                              "Submit Date",
                              style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: unitwidth * 3)),
                            ),
                            SizedBox(
                              width: unitwidth * 5,
                            ),
                            Container(
                              width: unitwidth * 18,
                              height: unitwidth * 8.5,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(unitwidth * 1.5))),
                              child: MaterialButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(
                                                DateTime.now().year - 1),
                                            lastDate: DateTime(
                                                DateTime.now().year + 1))
                                        .then((value) => {
                                              setState(() {
                                                // print("Date "+value.toString());
                                                submitDate = value!;
                                                submitingDateShow =
                                                    DateFormat("dd")
                                                            .format(value) +
                                                        "  " +
                                                        DateFormat("MMMM")
                                                            .format(value) +
                                                        "  " +
                                                        DateFormat("y")
                                                            .format(value);
                                              })
                                            });
                                  },
                                  child: Text(
                                    "Pick A Date",
                                    style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: unitwidth * 2.5,
                                            fontWeight: FontWeight.w600)),
                                  )),
                            ),
                          ],
                        ),
                      ),

                      //SizedBox(height: unitwidth*5,),
                      Text(
                        submitingDateShow,
                        style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: unitwidth * 3,
                                fontWeight: FontWeight.w500)),
                      ),
                      SizedBox(
                        height: unitwidth * 5,
                      ),
                      Text("Are You sure want to Submit",
                          style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: unitwidth * 5,
                                  fontWeight: FontWeight.w500)))
                    ],
                  ),
                );
              },
            ),
            actions: [
              MaterialButton(
                onPressed: () async {
                  if (!waitingForStatusResponse) {
                    waitingForStatusResponse = true;
                    setUserStatus(status, submitDate);
                  }

                  //addUser(context);
                },
                child: Container(
                  width: unitwidth * 17,
                  height: unitwidth * 8,
                  color: Colors.blue,
                  alignment: Alignment.center,
                  child: AutoSizeText("Yes",
                      style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                              color: Colors.white, fontSize: unitwidth * 4)),
                      textScaleFactor: textscalefactor),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: unitwidth * 17,
                  height: unitwidth * 8,
                  color: Colors.blue,
                  alignment: Alignment.center,
                  child: Text(
                    "No",
                    style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                            color: Colors.white, fontSize: unitwidth * 4)),
                    textScaleFactor: 1,
                  ),
                ),
              )
            ],
          );
        });

    /// return mergeAccount;
  }

  setUserStatus(value u, DateTime date) async {
    UserModel request;
    request =
        await Services().changeUserStatus(widget.user.registrationNo!, u, date);
    //print("User status "+ UserModel().toJson(request).toString());
    if (request.registrationNo != null) {
      waitingForStatusResponse = false;
      Navigator.pop(context);
      setState(() {
        widget.user = request;
      });

      // ignore: use_build_context_synchronously
      AchievementView(context,
              title: (u == value.active) ? "Active User" : "Inactive User",
              subTitle: (u == value.active)
                  ? "User Activated Successfully"
                  : "User Inactivated  Successfully",
              //onTab: _onTabAchievement,
              icon: const Icon(
                Icons.check,
                color: Colors.white,
              ),
              //typeAnimationContent: AnimationTypeAchievement.fadeSlideToUp,
              //borderRadius: 5.0,
              color: (u == value.active) ? Colors.green : Colors.red,
              //textStyleTitle: TextStyle(),
              //textStyleSubTitle: TextStyle(),
              alignment: Alignment.bottomCenter,
              duration: const Duration(seconds: 2),
              isCircle: true,
              listener: ((p0) {}))
          .show();
    } else {
      waitingForStatusResponse = false;
      Fluttertoast.showToast(msg: "Please try Again");
    }
  }

  Future<dynamic> getFeeDetails() async {
    //print("User id "+widget.user.id!.toString() +"  no "+widget.user.registrationNo!.toString() );
    var data = [];
    //if(tabIndex == 0){
    data = await Services().getUserFeesDetails(widget.user.registrationNo!);
    //print("Get details ${widget.user.registrationNo}"+ "  data "+data.toString());
    //}else{
    //data = await Services().getUserFeesDetails(widget.user.registrationNo!);
    //print("Get details "+data.toString());
    //}
    print("Tab data " + data.toString());
    return data;
  }

  getAttandance() {}

  feeDetailsList(double width, double height, var data) {
    //print("Fees details "+data.toString());
    bool active = true;
    if (data["paymentMode"] == "offline") {
      active = false;
    } else {}
    //print("Fee details mode "+active.toString());

    DateTime paidDate = DateTime.now();
    return Container(
      width: width * 100,
      height: height * 10,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: width * 70,
            height: height * 8,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.5),
                borderRadius: BorderRadius.all(Radius.circular(width * 3))),
            margin: EdgeInsets.symmetric(
                horizontal: width * 1, vertical: height * 0.7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: width * 17,
                  height: height * 8,
                  decoration: BoxDecoration(
                      color: (active) ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(width * 3),
                          bottomLeft: Radius.circular(width * 3))),
                  alignment: Alignment.center,
                  child: AutoSizeText(
                      (data["paymentMode"].toString() == "online")
                          ? "Online"
                          : "Offline",
                      style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontWeight: FontWeight.w600,
                              fontSize: width * 1 * 3.5)),
                      textScaleFactor: 1),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: width * 30,
                      height:
                          (data["feeNote"] != null) ? height * 2 : height * 7.5,
                      alignment: Alignment.center,
                      child: AutoSizeText(
                          DateFormat("dd-MMM-yyy")
                              .format(DateTime.parse(data["date"])),
                          style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontWeight: FontWeight.w600,
                                  fontSize: width * 1 * 3)),
                          textScaleFactor: 1),
                    ),
                    if ((data["feeNote"] != null))
                      Container(
                        width: width * 30,
                        height: height * 3,
                        alignment: Alignment.center,
                        child: AutoSizeText(data["feeNote"],
                            style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontWeight: FontWeight.w600,
                                    fontSize: width * 1 * 3)),
                            textScaleFactor: 1),
                      ),
                  ],
                ),
                Container(
                  width: width * 20,
                  height: height * 8,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AutoSizeText("₹ ${data["amount"]}",
                          style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontWeight: FontWeight.w600,
                                  fontSize: width * 1 * 5)),
                          textScaleFactor: 1),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Container(
                width: width * 7,
                height: height * 5,
                alignment: Alignment.center,
                child: MaterialButton(
                    minWidth: width * 6,
                    height: height * 5,
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => EditPayment(
                                    data: data,
                                  ))));
                    },
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                    )),
              ),
              SizedBox(
                width: width * 5,
              ),
              Container(
                width: width * 7,
                height: height * 5,
                alignment: Alignment.center,
                child: MaterialButton(
                    minWidth: width * 6,
                    height: height * 5,
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      deleteTransactionasking(context, data);
                    },
                    child: Icon(
                      Icons.delete,
                      color: Colors.red,
                    )),
              )
            ],
          ),
        ],
      ),
    );
  }

  deleteUserasking(BuildContext context) {
    bool waitForResponse = false;
    double textscalefactor = 0.8;
    double unitwidth = MediaQuery.of(context).size.width / 100;
    AlertDialog alertDialog = AlertDialog(
      title: Text("Delete User",
          style: GoogleFonts.montserrat(
              textStyle:
                  TextStyle(color: Colors.black, fontSize: unitwidth * 5)),
          textScaleFactor: 1),
      content: Text(
        "Are You sure to Delete User Name - ${widget.user.name} \n Registration No. ${widget.user.registrationNo}",
        textAlign: TextAlign.center,
        style: GoogleFonts.montserrat(
            textStyle:
                TextStyle(color: Colors.grey, fontSize: unitwidth * 3.1)),
        textScaleFactor: textscalefactor,
      ),
      actions: [
        MaterialButton(
          onPressed: () async {
            if (!waitForResponse) {
              var value = await deleteUser();
              if (value) {
                waitForResponse = false;
                Navigator.pop(context);
                Navigator.pop(context);
                setState(() {});
              } else {
                waitForResponse = false;
                Fluttertoast.showToast(msg: "User Not deleted");
              }
            }

            //addUser(context);
          },
          child: Container(
            width: unitwidth * 17,
            height: unitwidth * 8,
            color: Colors.blue,
            alignment: Alignment.center,
            child: AutoSizeText("Yes",
                style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                        color: Colors.white, fontSize: unitwidth * 4)),
                textScaleFactor: textscalefactor),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Container(
            width: unitwidth * 17,
            height: unitwidth * 8,
            color: Colors.blue,
            alignment: Alignment.center,
            child: Text(
              "No",
              style: GoogleFonts.montserrat(
                  textStyle:
                      TextStyle(color: Colors.white, fontSize: unitwidth * 4)),
              textScaleFactor: 1,
            ),
          ),
        )
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });

    /// return mergeAccount;
  }

  //Container(width: width*10,height: height*5, child: Icon(Icons.delete),)
  deleteTransactionasking(BuildContext context, var data) {
    double textscalefactor = 0.8;
    double unitwidth = MediaQuery.of(context).size.width / 100;
    AlertDialog alertDialog = AlertDialog(
      title: Text("Submit",
          style: GoogleFonts.montserrat(
              textStyle:
                  TextStyle(color: Colors.black, fontSize: unitwidth * 5)),
          textScaleFactor: 1),
      content: Text(
        "Are You sure to submit",
        textAlign: TextAlign.center,
        style: GoogleFonts.montserrat(
            textStyle:
                TextStyle(color: Colors.grey, fontSize: unitwidth * 3.1)),
        textScaleFactor: textscalefactor,
      ),
      actions: [
        MaterialButton(
          onPressed: () async {
            if (!waitForTransactionResponse) {
              bool value = await deleteTransaction(data);
              if (value) {
                waitForTransactionResponse = false;
                Navigator.pop(context);
                setState(() {});
              } else {
                waitForTransactionResponse = false;
                Fluttertoast.showToast(msg: "Transaction Not deleted");
              }
            }

            //addUser(context);
          },
          child: Container(
            width: unitwidth * 17,
            height: unitwidth * 8,
            color: Colors.blue,
            alignment: Alignment.center,
            child: AutoSizeText("Yes",
                style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                        color: Colors.white, fontSize: unitwidth * 4)),
                textScaleFactor: textscalefactor),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Container(
            width: unitwidth * 17,
            height: unitwidth * 8,
            color: Colors.blue,
            alignment: Alignment.center,
            child: Text(
              "No",
              style: GoogleFonts.montserrat(
                  textStyle:
                      TextStyle(color: Colors.white, fontSize: unitwidth * 4)),
              textScaleFactor: 1,
            ),
          ),
        )
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });

    /// return mergeAccount;
  }

  deleteUser() async {
    var respones = await Services().deleteUser(widget.user.id.toString());
    //  print("resppnse User "+ respones.toString());
    if (respones.toString() == "true") {
      return true;
    }
    return false;
  }

  deleteTransaction(var value) async {
    var response = await Services().deleteTransaction(value["id"].toString());
// print("Response Transact  "+ response.toString());
    if (response.toString() == "true") {
      return true;
    }
    return false;
  }

  setAttandance(DateTime date) async {
    NeatCleanCalendarEvent e;
    var a = await Services()
        .getUserAttandance(widget.user.registrationNo!, date.toString());
    print("Request " + a.toString());

    if (a != null) {
      for (int i = 0; i < a.length; i++) {
        if (a[i]["attandanceStatus"] == "present") {
          e = NeatCleanCalendarEvent('',
              startTime: DateTime.parse(a[i]["date"]),
              endTime: DateTime.parse(a[i]["date"]),
              color: Colors.green,
              isMultiDay: false);

          //if(i > 0 && _eventList[i-1].startTime != DateTime.parse(a[i]["date"])){
          _eventList.add(e);
          //}

        } else {
          e = NeatCleanCalendarEvent('',
              startTime: DateTime.parse(a[i]["date"]),
              endTime: DateTime.parse(a[i]["date"]),
              color: Colors.red,
              isMultiDay: false);
          //if(i > 0 && _eventList[i-1].startTime != DateTime.parse(a[i]["date"])){
          _eventList.add(e);
          //}

        }
      }
    }
  }

  checkForActiveDate() {
    if (widget.user.activeDate == null) {
      return true;
    }
    DateTime activeDate = DateTime.parse(widget.user.activeDate!);
    DateTime fee = DateTime.parse(widget.user.feeSubmitDate!);

    if (fee.isAfter(activeDate)) {
      return true;
    }
    return false;
  }

  Future<String> getDueDate(String date) async {
    // DateTime d  = DateTime.parse("2023-03-06");
    // print("Date of attandance "+d.toString());
    return DateFormat("dd-MMM-yyy").format(DateTime.parse(date));
  }

  calculateForLastDay(String date, String inactiveDate) {
    DateTime now = DateTime.parse(date);
    DateTime inactive = DateTime.parse(inactiveDate);

    if (now.isAfter(inactive)) {
      return false;
    }

    return true;
  }

  getLastDueDayForInactive(String date, String inactiveDate) async {
    DateTime now = DateTime.parse(date);
    DateTime inactive = DateTime.parse(inactiveDate);

    int day = inactive.difference(now).inDays;

    return day.toString() + " Days";
  }

  getUserById(int id) async {
    UserModel u = await Services().getUser(id);
    setState(() {
      widget.user = u;
    });
  }
}
