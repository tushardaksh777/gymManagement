import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'DTO/User.dart';
import 'HomeList/UserView.dart';

class SearchList extends StatefulWidget {
  UserModel user;
  SearchList({super.key, required this.user});

  @override
  State<SearchList> createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  @override
  Widget build(BuildContext context) {
    double unitwidth = MediaQuery.of(context).size.width / 100;
    double unitheight = MediaQuery.of(context).size.height / 100;
    double textscale = 0.9;
    return MaterialButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => UserView(
                      user: widget.user,
                    ))));
      },
      child: Container(
        width: unitwidth * 100,
        height: unitheight * 11.5,
        decoration: BoxDecoration(
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        margin: EdgeInsets.symmetric(
            horizontal: unitwidth * 2, vertical: unitheight * 1.2),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: unitwidth * 15,
              height: unitwidth * 20.5,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.all(Radius.circular(unitwidth * 7)),
                  color: Colors.black.withOpacity(0.1)),
              child: Icon(Icons.people, color: Colors.white),
            ),
            Container(
              width: unitwidth * 40,
              height: unitwidth * 20.5,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AutoSizeText(widget.user.name.toString(),
                      style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: unitwidth * 1 * 3.5)),
                      textScaleFactor: textscale),
                  SizedBox(
                    height: unitwidth * 1,
                  ),
                  AutoSizeText(
                    "Registration No - ${widget.user.registrationNo}",
                    style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontWeight: FontWeight.w600,
                            fontSize: unitwidth * 1 * 3.2)),
                    textScaleFactor: textscale,
                  ),
                  SizedBox(
                    height: unitwidth * 1,
                  ),
                  AutoSizeText(
                    "Phone No - ${widget.user.phoneNo}",
                    style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontWeight: FontWeight.w600,
                            fontSize: unitwidth * 1 * 3)),
                    textScaleFactor: textscale,
                  ),
                  SizedBox(
                    height: unitwidth * 1,
                  ),
                  AutoSizeText(
                    "Address - ${widget.user.address}",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontWeight: FontWeight.w600,
                            overflow: TextOverflow.fade,
                            fontSize: unitwidth * 1 * 2)),
                    textScaleFactor: textscale,
                  ),
                ],
              ),
            ),
            if (widget.user.status == "active")
              FutureBuilder(
                  future: getDueDate(widget.user.feeSubmitDate!),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    } else {
                      return Container(
                        width: unitwidth * 22,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                AutoSizeText(
                                  snapshot.data["days"],
                                  style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                          color: Colors.red.withOpacity(0.6),
                                          fontWeight: FontWeight.w900,
                                          fontSize: unitwidth *
                                              snapshot.data["size"])),
                                  textScaleFactor: textscale,
                                ),
                                AutoSizeText(
                                  snapshot.data["des"],
                                  style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                          color: Colors.red.withOpacity(0.6),
                                          fontWeight: FontWeight.w900,
                                          fontSize:
                                              (snapshot.data["sI"] != "day")
                                                  ? unitwidth * 2
                                                  : unitwidth * 4)),
                                  textScaleFactor: textscale,
                                ),
                              ],
                            ),
                            AutoSizeText(
                              getDate(widget.user.feeSubmitDate!),
                              style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.6),
                                      fontWeight: FontWeight.w900,
                                      fontSize: unitwidth * 1 * 3.2)),
                              textScaleFactor: textscale,
                            ),
                          ],
                        ),
                      );
                    }
                  })
            else
              Column(
                children: [
                  AutoSizeText(
                    "0",
                    style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                            color: Colors.red.withOpacity(0.6),
                            fontWeight: FontWeight.w900,
                            fontSize: unitwidth * 10.2)),
                    textScaleFactor: textscale,
                  ),
                  AutoSizeText(
                    "Inactive\n User",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                            color: Colors.red.withOpacity(0.6),
                            fontWeight: FontWeight.w900,
                            fontSize: unitwidth * 4)),
                    textScaleFactor: textscale,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  getDate(String sd) {
    return DateFormat("dd-MMM-yyy").format(DateTime.parse(sd));
  }

  getDueDate(String date) async {
    DateTime d = DateTime.parse(date);
    DateTime dueDate = DateTime(d.year, d.month, d.day);
    DateTime now = DateTime.now();
    DateTime nowDate = DateTime(now.year, now.month, now.day);
    //  print("Due Date "+dueDate.toString() + " Now "+ nowDate.toString());
    //  print("Due date after "+dueDate.isAfter(nowDate).toString());
    //  print("Due date before "+dueDate.isBefore(nowDate).toString());
    int remainingDays = 0;

    bool remain = false;
    if (remainingDays != 0) {
    } else {
      remain = true;
    }
    if (dueDate.isAfter(nowDate)) {
      remain = true;
    } else if (dueDate.isBefore(nowDate)) {
      remain = false;
    }

    String s = "DAY DUE";
    String sizeIdentifier = "day";
    if (remain) {
      var f = dueDate.difference(nowDate).inDays;
      // print("User "+widget.user.name! + "  $f");
      remainingDays = f;
    } else {
      var f = nowDate.difference(dueDate).inDays;
      //print("User "+widget.user.name! + "  $f");
      remainingDays = f;
      s = "DAY OVERDUE";
      sizeIdentifier = "over";
    }
    //  if(remainingDays.isNegative){

    //  }

    if (remainingDays == 0) {
      return await {"days": "Today", "size": 5.2, "des": s};
    } else {
      return await {
        "days": remainingDays.toString(),
        "size": 9.2,
        "des": s,
        "sI": sizeIdentifier
      };
    }
  }

  getInfoDesign(double width, double height, String title, String value) {
    return Container(
      width: width * 40,
      height: height * 5,
      margin: EdgeInsets.symmetric(vertical: 5),
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(
            "$title:",
            style: GoogleFonts.alegreyaSc(
                textStyle: TextStyle(color: Colors.blue.shade900)),
          ),
          Text("$value")
        ],
      ),
    );
  }
}
