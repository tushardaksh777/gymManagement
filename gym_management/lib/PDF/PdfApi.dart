import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/animation.dart';
import 'package:gym_management/AddUser/createUser.dart';
import 'package:gym_management/DTO/User.dart';
import 'package:gym_management/globalData.dart';
import 'package:in_date_utils/in_date_utils.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:gym_management/globalData.dart' as global;
import 'package:flutter/material.dart' as material;

class PdfApis {
  static Future<File> candidatePdf(List<UserModel> list, var profile) {
    final pdf = Document();
    List<Page> pages = userPage(list, profile);
    for (var p in pages) {
      pdf.addPage(p);
    }

    return genratePdf("User", pdf);
  }

  static Future<File> attandancePdf(
      var list, DateTime month, pdf time, var profile) {
    final pdf = Document();
    //   print("List "+list.toString());
//  String m = DateFormat("MMMM").format(month);
    int u = DTU.getDaysInMonth(month.year, month.month);
// print("Days in month $u");
    //attandanceSeprator(list[1], u);
    List<Page> pages = attandanceMonthlyPage(profile, list, month);
    for (var p in pages) {
      pdf.addPage(p);
    }

    return genratePdf("Attandance", pdf);
  }

  static Future<File> userFeePdf(
      var list, String month, pdf time, var profile, DateTime date) {
    final pdf = Document();
    List<Page> pages = [];
    String d = getTimeForTitle(date, time);
    if (time.name == "monthly") {
      pages = userMonthlyFeePage(list, month, profile, d);
    } else {
      pages = userYearlyFeePage(list, profile, d);
    }
    for (var p in pages) {
      pdf.addPage(p);
    }

    return genratePdf(
        (time.name == "monthly") ? "$month Fees_pdf" : "YearlyPdf", pdf);
  }

  static Future<File> expensesPdf(
      var list, DateTime month, pdf time, var profile, expense exp) {
    final pdf = Document();
    String d = getTimeForTitle(month, time);
    List<Page> pages;
    if (time.name == "monthly") {
      if (exp == expense.both) {
        pages = monthlyBothExpensesPage(list, d, profile);
      } else {
        pages = monthlyExpensesPage(list, d, profile);
      }
    } else {
      pages = expensesYearlyFeePage(list, profile, d);
    }
    for (var p in pages) {
      pdf.addPage(p);
    }

    return genratePdf(
        (time.name == "monthly") ? "$month" + "_expenses" : "YearlyPdf", pdf);
  }

  static Future<File> profitandlossPdf(
      var data, DateTime month, pdf time, var profile) {
    final pdf = Document();

    List<Page> pages = [];
    String d = getTimeForTitle(month, time);
    pages = profitandlosspage(data, profile, d);

    for (var p in pages) {
      pdf.addPage(p);
    }

    return genratePdf(
        (time.name == "monthly") ? "$month Profit and Loss" : "YearlyPdf", pdf);
  }

  static Future<File> genratePdf(String text, Document pdf) {
    //final pdf = Document();

    // pdf.addPage(userPage()
    // );
    // pdf.addPage(userPage());
    DateTime now = DateTime.now();
    return saveDocument(name: "$text$now.pdf", pdf: pdf);
  }

  static Future<File> saveDocument(
      {required name, required Document pdf}) async {
    final byts = await pdf.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(byts);
    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }

  static List<Page> userPage(List<UserModel> user, var p) {
    List<Page> pages = [];

    List<UserModel> s = [];

    for (var i = 0; i < user.length; i++) {
      s.add(user[i]);

      if (i == user.length - 1 || (i != 0 && i % 49 == 0)) {
        final data = s.map(
          (e) {
            return [
              (1 + user.indexWhere((element) => element.id == e.id)),
              e.registrationNo,
              e.name,
              e.fatherName,
              (e.husbandName == null) ? "-" : e.husbandName,
              "+91-${e.phoneNo}",
              e.address
            ];
          },
        ).toList();
        pages.add(singleUserPage(data, p));
        s = [];
      }
    }

    // List<List<dynamic>> s = [];
    // List<dynamic> table =["1", "Tushar" , "ajksdnajk" , "asdjnad" , "2328342", "asdakds"];

    // s.add(table);

    return pages;
  }

  static Page singleUserPage(var data, var profile) {
    final header = [
      "S.No.",
      "Reg. No.",
      "Name",
      "Father Name",
      "Husband Name ",
      "Mobile No.",
      "Address"
    ];
    return Page(
      pageFormat: PdfPageFormat.a4,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      build: (context) {
        return Column(children: [
          Text(
              (profile["res"] == "true")
                  ? "" + profile["data"]["name"]
                  : "Fitness Hub",
              style: TextStyle(fontSize: 20)),
          SizedBox(height: 5),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Column(children: [
              Text(
                  (profile["res"] == "true")
                      ? "Phone No.- " + profile["data"]["phoneNo"]
                      : "Phone No.-" + "9234294234",
                  style: TextStyle(fontSize: 8)),
              Text(
                  (profile["res"] == "true")
                      ? "Address - " + profile["data"]["businessAddress"]
                      : "Address - Amba Vihar , near Prakash City",
                  style: TextStyle(fontSize: 8)),
              //Text("Fitness Hub" , style: TextStyle(fontSize: 8)),
            ]),
            Column(children: [
              Text(
                  (profile["res"] == "true")
                      ? "GSTIN - " + profile["data"]["gstin"]
                      : "GSTIN - 9234294234",
                  style: TextStyle(fontSize: 8)),
              Text(
                  (profile["res"] == "true")
                      ? "UDYOG No. - " + profile["data"]["udyogRegistration"]
                      : "UDYOG No. - asdnakjsnkas",
                  style: TextStyle(fontSize: 8)),
              //Text("" , style: TextStyle(fontSize: 8)),
            ]),
          ]),
          // Text("Fitness Hub" , style: TextStyle(fontSize: 30)),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //   Container(width: 35 , height: 30, alignment: Alignment.center ,child: Text("S.No."), decoration: BoxDecoration(border: Border.all(width: 2))),
          //   Container(width: 80 , height: 30, alignment: Alignment.center ,child: Text("Name"),decoration: BoxDecoration(border: Border.all(width: 2)) ),
          //   Container(width:  100 , height: 30, alignment: Alignment.center ,child: Text("Father Name"),decoration: BoxDecoration(border: Border.all(width: 2)) ),
          //   Container(width: 100 , height: 30, alignment: Alignment.center ,child: Text("Husband Name"), decoration: BoxDecoration(border: Border.all(width: 2))),
          //   Container(width: 100 , height: 30, alignment: Alignment.center ,child: Text("Mobile No."), decoration: BoxDecoration(border: Border.all(width: 2))),
          //   Container(width: 100 , height: 30, alignment: Alignment.center ,child: Text("Address"),decoration: BoxDecoration(border: Border.all(width: 2)) ),
          // ])

          SizedBox(height: 10),
          Table.fromTextArray(
              data: data,
              headers: header,
              cellStyle: TextStyle(fontSize: 8),
              columnWidths: {
                0: FlexColumnWidth(0.5),
                0: FlexColumnWidth(0.5),
                2: FlexColumnWidth(1.5),
                3: FlexColumnWidth(1),
                4: FlexColumnWidth(1),
                5: FlexColumnWidth(1.5),
                6: FlexColumnWidth(1.5)
              },
              cellAlignment: Alignment.center,
              cellHeight: 1,
              cellPadding: EdgeInsets.all(2))
        ]);
      },
    );
  }

  static List<Page> userMonthlyFeePage(
      List<dynamic> list, String month, var p, String date) {
    List<Page> pages = [];

    List<dynamic> s = [];
    int totalfee = 0;
    int online = 0;
    int offline = 0;
    int onlineCount = 0;
    int offlineCount = 0;

    for (var i = 0; i < list.length; i++) {
      s.add(list[i]);

      if (i == list.length - 1 || (i != 0 && i % 54 == 0)) {
        var data = s.map(
          (e) {
            int fee = e["registrationfee"] +
                e["monthlyFee"] +
                e["trademilFee"] +
                e["lightCharges"] +
                e["personalTraining"] +
                e["otherFee"];
            totalfee = totalfee + fee;

            int fee1 = e["amount"];

            if (e["paymentMode"] == "online") {
              online = online + fee1;
              onlineCount = onlineCount + 1;
            } else {
              offline = offline + fee1;
              offlineCount = offlineCount + 1;
            }

            return [
              (1 + list.indexWhere((element) => element["id"] == e["id"])),
              e["user"]["registrationNo"],
              e["user"]["name"],
              e["date"],
              e["registrationfee"],
              e["monthlyFee"],
              e["trademilFee"],
              e["lightCharges"],
              e["personalTraining"],
              e["otherFee"],
              e["paymentMode"],
              fee.toString()
            ];
          },
        ).toList();
        pages.add(singleMonthlyUserFeePage(data, date, totalfee, online,
            offline, onlineCount, offlineCount, p));
        s = [];
      }
    }

    // List<List<dynamic>> s = [];
    // List<dynamic> table =["1", "Tushar" , "ajksdnajk" , "asdjnad" , "2328342", "asdakds"];

    // s.add(table);

    return pages;
  }

  static Page singleMonthlyUserFeePage(
      var data,
      String month,
      int totalfee,
      int onlinefee,
      int offlinefee,
      int onlineCount,
      int offlineCount,
      var profile) {
    final header = [
      "S.No.",
      "Rg.No.",
      "Name",
      "Date",
      "Reg.Fee",
      "Monthly",
      "Trademil",
      "Lights",
      "personal",
      "Other",
      "Mode",
      "Total"
    ];
    return Page(
      //sr.no , reg , date , name ,
      pageFormat: PdfPageFormat.a4,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      build: (context) {
        return Column(children: [
          Text(
              (profile["res"] == "true")
                  ? "" + profile["data"]["name"]
                  : "Fitness Hub",
              style: TextStyle(fontSize: 20)),
          SizedBox(height: 5),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Column(children: [
              Text(
                  (profile["res"] == "true")
                      ? "Phone No.- " + profile["data"]["phoneNo"]
                      : "Phone No.-" + "9234294234",
                  style: TextStyle(fontSize: 8)),
              Text(
                  (profile["res"] == "true")
                      ? "Address - " + profile["data"]["businessAddress"]
                      : "Address - Amba Vihar , near Prakash City",
                  style: TextStyle(fontSize: 8)),
              //Text("Fitness Hub" , style: TextStyle(fontSize: 8)),
            ]),
            Column(children: [
              Text(
                  (profile["res"] == "true")
                      ? "GSTIN - " + profile["data"]["gstin"]
                      : "GSTIN - 9234294234",
                  style: TextStyle(fontSize: 8)),
              Text(
                  (profile["res"] == "true")
                      ? "UDYOG No. - " + profile["data"]["udyogRegistration"]
                      : "UDYOG No. - asdnakjsnkas",
                  style: TextStyle(fontSize: 8)),
              //Text("" , style: TextStyle(fontSize: 8)),
            ]),
          ]),
          // Text("Fitness Hub" , style: TextStyle(fontSize: 30)),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //   Container(width: 35 , height: 30, alignment: Alignment.center ,child: Text("S.No."), decoration: BoxDecoration(border: Border.all(width: 2))),
          //   Container(width: 80 , height: 30, alignment: Alignment.center ,child: Text("Name"),decoration: BoxDecoration(border: Border.all(width: 2)) ),
          //   Container(width:  100 , height: 30, alignment: Alignment.center ,child: Text("Father Name"),decoration: BoxDecoration(border: Border.all(width: 2)) ),
          //   Container(width: 100 , height: 30, alignment: Alignment.center ,child: Text("Husband Name"), decoration: BoxDecoration(border: Border.all(width: 2))),
          //   Container(width: 100 , height: 30, alignment: Alignment.center ,child: Text("Mobile No."), decoration: BoxDecoration(border: Border.all(width: 2))),
          //   Container(width: 100 , height: 30, alignment: Alignment.center ,child: Text("Address"),decoration: BoxDecoration(border: Border.all(width: 2)) ),
          // ])
          Text("Month - $month", style: TextStyle(fontSize: 12)),

          SizedBox(height: 10),
          Table.fromTextArray(
              data: data,
              headers: header,
              headerPadding: EdgeInsets.all(1),
              headerStyle: TextStyle(fontSize: 10),
              cellStyle: TextStyle(fontSize: 7),
              cellAlignment: Alignment.center,
              cellHeight: 1,
              cellPadding: EdgeInsets.all(2)),
          Table.fromTextArray(data: [], headers: [
            "Online Fee($onlineCount) - $onlinefee",
            "Offline Fee($offlineCount) - $offlinefee",
            "Grand Total - $totalfee"
          ]),
          // Table.fromTextArray(data: [] , headers: ["Offline Fee" , offlinefee.toString()] , columnWidths: {0:FlexColumnWidth(1) , 1:FlexColumnWidth(0.1)} ),
          // Table.fromTextArray(data: [] , headers: ["Grand Total" , totalfee.toString()] , columnWidths: {0:FlexColumnWidth(1) , 1:FlexColumnWidth(0.1)} )
          //"S.No." ,"Date" ,"Name" , "Rg.No." , "Reg.Fee","Monthly","Trademil","Lights","personal","Other" ,"Mode" ,"Total"
        ]);
      },
    );
  }

  static List<Page> userYearlyFeePage(List<dynamic> list, var p, String date) {
    List<Page> pages = [];
    int endMonth = 15;
    int monthTracker = 1;
    List<dynamic> s = [];
    int totalfee = 0;

    DateTime currentMonth = DateTime.now();
    list.sort(
      (a, b) {
        DateTime aDT = DateTime.parse(a["date"]);
        DateTime bDT = DateTime.parse(b["date"]);

        return aDT.compareTo(bDT);
      },
    );

    print("object month " + list[0]["date"].toString());
    DateTime firstDate = DateTime.parse(list[0]["date"]);
    int value = DateTime.parse(list[0]["date"]).month;

    currentMonth = DateTime.parse(list[0]["date"]);

    int monthlyfee = 0;
    int online = 0;
    int offline = 0;

    for (var i = 0; i < list.length; i++) {
      DateTime time = DateTime.parse(list[i]["date"]);
      int month = time.month;
      int fee1 = list[i]["amount"];
      // if (list[i]["paymentMode"] == "online") {
      //   online = online + fee1;
      // } else {
      //   offline = offline + fee1;
      // }
      //For Month Change
      if (currentMonth.month == month) {
        monthlyfee = monthlyfee + int.parse(list[i]["amount"].toString());
        if (list[i]["paymentMode"] == "online") {
          online = online + fee1;
        } else {
          offline = offline + fee1;
        }
      }

      if (i != list.length - 1 && currentMonth.month != month) {
        totalfee = totalfee + monthlyfee;
        var val = {
          "SR.No.": s.length.toString(),
          "date": DateFormat("MMMM").format(currentMonth),
          "fees": monthlyfee.toString(),
          "onlinefees": online.toString(),
          "offlinefees": offline.toString(),
          "total": totalfee.toString()
        };
        s.add(val);

        //For New Month
        currentMonth = time;
        monthTracker++;
        monthlyfee = int.parse(list[i]["amount"].toString());
        if (list[i]["paymentMode"] == "online") {
          online = online + fee1;
        } else {
          offline = offline + fee1;
        }
      } else if (i == list.length - 1 && currentMonth.month != month) {
        totalfee = totalfee + monthlyfee;
        var val = {
          "SR.No.": s.length.toString(),
          "date": DateFormat("MMMM").format(currentMonth),
          "fees": monthlyfee.toString(),
          "onlinefees": online.toString(),
          "offlinefees": offline.toString(),
          "total": totalfee.toString()
        };
        s.add(val);

        //For New Month
        currentMonth = time;
        monthTracker++;
        monthlyfee = int.parse(list[i]["amount"].toString());
        if (list[i]["paymentMode"] == "online") {
          online = online + fee1;
        } else {
          offline = offline + fee1;
        }
        totalfee = totalfee + monthlyfee;
        var val1 = {
          "SR.No.": (s.length + 1).toString(),
          "date": DateFormat("MMMM").format(currentMonth),
          "fees": monthlyfee.toString(),
          "onlinefees": online.toString(),
          "offlinefees": offline.toString(),
          "total": totalfee.toString()
        };
        s.add(val1);
      } else if (i == list.length - 1 && currentMonth.month == month) {
        totalfee = totalfee + monthlyfee;
        var val = {
          "SR.No.": (s.length + 1).toString(),
          "date": DateFormat("MMMM").format(currentMonth),
          "fees": monthlyfee.toString(),
          "onlinefees": online.toString(),
          "offlinefees": offline.toString(),
          "total": totalfee.toString()
        };
        s.add(val);
      }

      // var val = {
      //     "SR.No.": s.length.toString(),
      //     "date": DateFormat("MMMM").format(currentMonth),
      //     "fees": monthlyfee.toString(),
      //     "onlinefees": online.toString(),
      //     "offlinefees": offline.toString(),
      //     "total": totalfee.toString()
      //   };
      //   s.add(val);

      // /print("Month "+month.toString());
      //if(mon)
      //print("data "+ i.toString());
    }
    print("Last object " + s[s.length - 1].toString());
    if (currentMonth.month + 1 > 12 || currentMonth.month <= 3) {
      endMonth = 3;
    }

    int initalMonth = DateTime(currentMonth.year, currentMonth.month, 26)
        .add(const Duration(days: 28))
        .month;
    for (int j = initalMonth; j <= endMonth; j++) {
      int m = j;
      if (j > 12) {
        m = j - 12;
      }
      monthTracker++;
      DateTime v = DateTime(firstDate.year, m);
      var val = {
        "SR.No.": monthTracker.toString(),
        "date": DateFormat("MMMM").format(v),
        "fees": "0",
        "onlinefees": "0",
        "offlinefees": "0",
        "total": totalfee.toString()
      };
      s.add(val);
    }
    // if (currentMonth.month <= 3) {
    //   endMonth = 3;
    // }

    // for (int j = currentMonth.month + 1; j <= endMonth; j++) {
    //   int m = j % endMonth;
    //   monthTracker++;
    //   DateTime v = DateTime(firstDate.year, m);
    //   var val = {
    //     "SR.No.": j.toString(),
    //     "date": DateFormat("MMMM").format(v),
    //     "fees": "0",
    //     "onlinefees": "0",
    //     "offlinefees": "0",
    //     "total": totalfee.toString()
    //   };
    //   s.add(val);
    // }
    //data.add(s);
    var data = s.map((e) {
      return [
        e["SR.No."],
        e["date"],
        e["onlinefees"],
        e["offlinefees"],
        e["fees"],
        e["total"]
      ];
    }).toList();

    //List<dynamic> adandas =  [["1", "January", "0", "0"], ["2", "February", "0", "0"], ["2", "March", "10000", "10000"], [3, "April", "51300", "61300"]];
    pages
        .add(singleYearlyUserFeePage(data, totalfee, online, offline, p, date));
    //print("List Pages "+ pages.length.toString());

    // List<List<dynamic>> s = [];
    // List<dynamic> table =["1", "Tushar" , "ajksdnajk" , "asdjnad" , "2328342", "asdakds"];

    // s.add(table);

    return pages;
  }

  static Page singleYearlyUserFeePage(var data, int totalfee, int onlinefee,
      int offlinefee, var profile, String date) {
    final header = [
      "S.No.",
      "Months",
      "Online Fees",
      "Offline Fees",
      "Monthly Total",
      "Grand Total"
    ];
    return Page(
      pageFormat: PdfPageFormat.a4,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      build: (context) {
        return Column(children: [
          Text(
              (profile["res"] == "true")
                  ? "" + profile["data"]["name"]
                  : "Fitness Hub",
              style: TextStyle(fontSize: 20)),
          SizedBox(height: 5),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Column(children: [
              Text(
                  (profile["res"] == "true")
                      ? "Phone No.- " + profile["data"]["phoneNo"]
                      : "Phone No.-" + "9234294234",
                  style: TextStyle(fontSize: 8)),
              Text(
                  (profile["res"] == "true")
                      ? "Address - " + profile["data"]["businessAddress"]
                      : "Address - Amba Vihar , near Prakash City",
                  style: TextStyle(fontSize: 8)),
              //Text("Fitness Hub" , style: TextStyle(fontSize: 8)),
            ]),
            Column(children: [
              Text(
                  (profile["res"] == "true")
                      ? "GSTIN - " + profile["data"]["gstin"]
                      : "GSTIN - 9234294234",
                  style: TextStyle(fontSize: 8)),
              Text(
                  (profile["res"] == "true")
                      ? "UDYOG No. - " + profile["data"]["udyogRegistration"]
                      : "UDYOG No. - asdnakjsnkas",
                  style: TextStyle(fontSize: 8)),
              //Text("" , style: TextStyle(fontSize: 8)),
            ]),
          ]),
          SizedBox(height: 5),
          Text("Year -: " + date, style: TextStyle(fontSize: 10)),

          // Text("Fitness Hub" , style: TextStyle(fontSize: 30)),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //   Container(width: 35 , height: 30, alignment: Alignment.center ,child: Text("S.No."), decoration: BoxDecoration(border: Border.all(width: 2))),
          //   Container(width: 80 , height: 30, alignment: Alignment.center ,child: Text("Name"),decoration: BoxDecoration(border: Border.all(width: 2)) ),
          //   Container(width:  100 , height: 30, alignment: Alignment.center ,child: Text("Father Name"),decoration: BoxDecoration(border: Border.all(width: 2)) ),
          //   Container(width: 100 , height: 30, alignment: Alignment.center ,child: Text("Husband Name"), decoration: BoxDecoration(border: Border.all(width: 2))),
          //   Container(width: 100 , height: 30, alignment: Alignment.center ,child: Text("Mobile No."), decoration: BoxDecoration(border: Border.all(width: 2))),
          //   Container(width: 100 , height: 30, alignment: Alignment.center ,child: Text("Address"),decoration: BoxDecoration(border: Border.all(width: 2)) ),
          // ])
          //Text("Month - $month" , style: TextStyle(fontSize: 12)),

          SizedBox(height: 10),
          Table.fromTextArray(
              data: data,
              headers: header,
              cellStyle: TextStyle(fontSize: 8),
              columnWidths: {
                0: FlexColumnWidth(0.5),
                1: FlexColumnWidth(1.5),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1),
                4: FlexColumnWidth(1.5),
                5: FlexColumnWidth(1.5)
              },
              cellAlignment: Alignment.center,
              cellHeight: 1,
              cellPadding: EdgeInsets.all(2)),
          // Table.fromTextArray(data: [] , headers: ["Online Fee" , onlinefee.toString()] , columnWidths: {0:FlexColumnWidth(1) , 1:FlexColumnWidth(0.1)} ),
          // Table.fromTextArray(data: [] , headers: ["Offline Fee" , offlinefee.toString()] , columnWidths: {0:FlexColumnWidth(1) , 1:FlexColumnWidth(0.1)} )
          //Table.fromTextArray(data: [] , headers: ["Grand Total" , totalfee.toString()] , columnWidths: {0:FlexColumnWidth(1) , 1:FlexColumnWidth(0.1)} )
        ]);
      },
    );
  }

  static List<Page> monthlyBothExpensesPage(
      List<dynamic> list, String month, var p) {
    List<Page> pages = [];

    List<dynamic> s = [];
    int totalfee = 0;
    int online = 0;
    int offline = 0;
    int onlineCount = 0;
    int offlineCount = 0;
    var gymData = [];
    var otherData = [];

    //"S.No.","Date","Gym Expenses","Amount","Date","Other Expenses","Amount"
    for (var i = 0; i < list.length; i++) {
      if (list[i]["expenses"] == "gym") {
        gymData.add(list[i]);
      } else {
        otherData.add(list[i]);
      }
    }

    int times =
        (gymData.length > otherData.length) ? gymData.length : otherData.length;

    for (var i = 0; i < times; i++) {
      var collectData = {};

      if (gymData.isNotEmpty && gymData.length > i) {
        collectData.putIfAbsent("gymDate", () => gymData[i]["date"]);
        collectData.putIfAbsent("gymtitle", () => gymData[i]["title"]);
        collectData.putIfAbsent("gymAmount", () => gymData[i]["amount"]);
      } else {
        collectData.putIfAbsent("gymDate", () => "-");
        collectData.putIfAbsent("gymtitle", () => "-");
        collectData.putIfAbsent("gymAmount", () => "-");
      }

      if (otherData.isNotEmpty && otherData.length > i) {
        collectData.putIfAbsent("otherDate", () => otherData[i]["date"]);
        collectData.putIfAbsent("othertitle", () => otherData[i]["title"]);
        collectData.putIfAbsent("otherAmount", () => otherData[i]["amount"]);
      } else {
        collectData.putIfAbsent("otherDate", () => "-");
        collectData.putIfAbsent("othertitle", () => "-");
        collectData.putIfAbsent("otherAmount", () => "-");
      }
      // if (otherData.isNotEmpty && otherData.length < i) {
      //   collectOtherData["otherDate"] = otherData[i]["date"];
      //   collectOtherData["othertitle"] = otherData[i]["title"];
      //   collectOtherData["otherAmount"] = otherData[i]["amount"];
      //}
      collectData.putIfAbsent("sno", () => i + 1);
      s.add(collectData);

      if (i == times - 1 || (i != 0 && i % 54 == 0)) {
        var data = s.map(
          (e) {
            int fee = (e["gymAmount"].toString() != "-") ? e["gymAmount"] : 0;
            int fee2 =
                (e["otherAmount"].toString() != "-") ? e["otherAmount"] : 0;

            totalfee = totalfee + (fee + fee2);

            // if (e["paymentMode"] == "online") {
            //   online = online + fee;
            //   onlineCount = onlineCount + 1;
            // } else {
            //   offline = offline + fee;
            //   offlineCount = offlineCount + 1;
            // }

            return [
              e["sno"],
              e["gymDate"],
              e["gymtitle"],
              e["gymAmount"],
              e["otherDate"],
              e["othertitle"],
              e["otherAmount"]
            ];
          },
        ).toList();
        pages.add(singleMonthlyBothexpensesPage(data, month, totalfee, online,
            offline, onlineCount, offlineCount, p));
        s = [];
      }
    }

    // List<List<dynamic>> s = [];
    // List<dynamic> table =["1", "Tushar" , "ajksdnajk" , "asdjnad" , "2328342", "asdakds"];

    // s.add(table);

    return pages;
  }

  static Page singleMonthlyBothexpensesPage(
      var data,
      String month,
      int totalfee,
      int onlinefee,
      int offlinefee,
      int onlineCount,
      int offlineCount,
      var profile) {
    final header = [
      "S.No.",
      "Date",
      "Gym Expenses",
      "Amount",
      "Date",
      "Other Expenses",
      "Amount"
    ];
    return Page(
      pageFormat: PdfPageFormat.a4,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      build: (context) {
        return Column(children: [
          Text(
              (profile["res"] == "true")
                  ? "" + profile["data"]["name"]
                  : "Fitness Hub",
              style: TextStyle(fontSize: 20)),
          SizedBox(height: 5),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Column(children: [
              Text(
                  (profile["res"] == "true")
                      ? "Phone No.- " + profile["data"]["phoneNo"]
                      : "Phone No.-" + "9234294234",
                  style: TextStyle(fontSize: 8)),
              Text(
                  (profile["res"] == "true")
                      ? "Address - " + profile["data"]["businessAddress"]
                      : "Address - Amba Vihar , near Prakash City",
                  style: TextStyle(fontSize: 8)),
              //Text("Fitness Hub" , style: TextStyle(fontSize: 8)),
            ]),
            Column(children: [
              Text(
                  (profile["res"] == "true")
                      ? "GSTIN - " + profile["data"]["gstin"]
                      : "GSTIN - 9234294234",
                  style: TextStyle(fontSize: 8)),
              Text(
                  (profile["res"] == "true")
                      ? "UDYOG No. - " + profile["data"]["udyogRegistration"]
                      : "UDYOG No. - asdnakjsnkas",
                  style: TextStyle(fontSize: 8)),
              //Text("" , style: TextStyle(fontSize: 8)),
            ]),
          ]),
          // Text("Fitness Hub" , style: TextStyle(fontSize: 30)),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //   Container(width: 35 , height: 30, alignment: Alignment.center ,child: Text("S.No."), decoration: BoxDecoration(border: Border.all(width: 2))),
          //   Container(width: 80 , height: 30, alignment: Alignment.center ,child: Text("Name"),decoration: BoxDecoration(border: Border.all(width: 2)) ),
          //   Container(width:  100 , height: 30, alignment: Alignment.center ,child: Text("Father Name"),decoration: BoxDecoration(border: Border.all(width: 2)) ),
          //   Container(width: 100 , height: 30, alignment: Alignment.center ,child: Text("Husband Name"), decoration: BoxDecoration(border: Border.all(width: 2))),
          //   Container(width: 100 , height: 30, alignment: Alignment.center ,child: Text("Mobile No."), decoration: BoxDecoration(border: Border.all(width: 2))),
          //   Container(width: 100 , height: 30, alignment: Alignment.center ,child: Text("Address"),decoration: BoxDecoration(border: Border.all(width: 2)) ),
          // ])
          Text("Month - $month", style: TextStyle(fontSize: 12)),

          SizedBox(height: 10),

          Table.fromTextArray(
              data: data,
              headers: header,
              headerPadding: EdgeInsets.all(1),
              headerStyle: TextStyle(fontSize: 10),
              cellStyle: TextStyle(fontSize: 10),
              cellAlignment: Alignment.center,
              cellHeight: 1,
              cellPadding: EdgeInsets.all(2),
              columnWidths: {
                0: FlexColumnWidth(0.5),
                1: FlexColumnWidth(0.75),
                2: FlexColumnWidth(1.5),
                3: FlexColumnWidth(0.5),
                4: FlexColumnWidth(0.75),
                5: FlexColumnWidth(1.5),
                6: FlexColumnWidth(0.5),
              }),
          Table.fromTextArray(
              data: [],
              headers: [
                "Online($onlineCount) - $onlinefee",
                "Offline($offlineCount) - $offlinefee",
                "Grand Total - $totalfee"
              ],
              headerStyle: TextStyle(fontSize: 10),
              cellStyle: TextStyle(fontSize: 10)),
          // Table.fromTextArray(data: [] , headers: ["Offline" , offlinefee.toString()] , columnWidths: {0:FlexColumnWidth(0.8) , 1:FlexColumnWidth(0.2)} , headerStyle: TextStyle(fontSize: 10),cellStyle: TextStyle(fontSize: 10) ),
          // Table.fromTextArray(data: [] , headers: ["Grand Total" , totalfee.toString()] , columnWidths: {0:FlexColumnWidth(0.8) , 1:FlexColumnWidth(0.2)}  , headerStyle: TextStyle(fontSize: 10),cellStyle: TextStyle(fontSize: 10))
          //"S.No." ,"Date" ,"Name" , "Rg.No." , "Reg.Fee","Monthly","Trademil","Lights","personal","Other" ,"Mode" ,"Total"
        ]);
      },
    );
  }

  static List<Page> monthlyExpensesPage(
      List<dynamic> list, String month, var p) {
    List<Page> pages = [];

    List<dynamic> s = [];
    int totalfee = 0;
    int online = 0;
    int offline = 0;
    int onlineCount = 0;
    int offlineCount = 0;
    for (var i = 0; i < list.length; i++) {
      s.add(list[i]);

      if (i == list.length - 1 || (i != 0 && i % 54 == 0)) {
        var data = s.map(
          (e) {
            int fee = e["amount"];
            totalfee = totalfee + fee;

            if (e["paymentMode"] == "online") {
              online = online + fee;
              onlineCount = onlineCount + 1;
            } else {
              offline = offline + fee;
              offlineCount = offlineCount + 1;
            }

            return [
              (1 + list.indexWhere((element) => element["id"] == e["id"])),
              e["date"],
              e["title"],
              e["paymentMode"],
              fee.toString()
            ];
          },
        ).toList();
        pages.add(singleMonthlyexpensesPage(data, month, totalfee, online,
            offline, onlineCount, offlineCount, p));
        s = [];
      }
    }

    // List<List<dynamic>> s = [];
    // List<dynamic> table =["1", "Tushar" , "ajksdnajk" , "asdjnad" , "2328342", "asdakds"];

    // s.add(table);

    return pages;
  }

  static Page singleMonthlyexpensesPage(
      var data,
      String month,
      int totalfee,
      int onlinefee,
      int offlinefee,
      int onlineCount,
      int offlineCount,
      var profile) {
    final header = ["S.No.", "Date", "Title", "Payment Mode", "Amount"];
    return Page(
      pageFormat: PdfPageFormat.a4,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      build: (context) {
        return Column(children: [
          Text(
              (profile["res"] == "true")
                  ? "" + profile["data"]["name"]
                  : "Fitness Hub",
              style: TextStyle(fontSize: 20)),
          SizedBox(height: 5),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Column(children: [
              Text(
                  (profile["res"] == "true")
                      ? "Phone No.- " + profile["data"]["phoneNo"]
                      : "Phone No.-" + "9234294234",
                  style: TextStyle(fontSize: 8)),
              Text(
                  (profile["res"] == "true")
                      ? "Address - " + profile["data"]["businessAddress"]
                      : "Address - Amba Vihar , near Prakash City",
                  style: TextStyle(fontSize: 8)),
              //Text("Fitness Hub" , style: TextStyle(fontSize: 8)),
            ]),
            Column(children: [
              Text(
                  (profile["res"] == "true")
                      ? "GSTIN - " + profile["data"]["gstin"]
                      : "GSTIN - 9234294234",
                  style: TextStyle(fontSize: 8)),
              Text(
                  (profile["res"] == "true")
                      ? "UDYOG No. - " + profile["data"]["udyogRegistration"]
                      : "UDYOG No. - asdnakjsnkas",
                  style: TextStyle(fontSize: 8)),
              //Text("" , style: TextStyle(fontSize: 8)),
            ]),
          ]),
          // Text("Fitness Hub" , style: TextStyle(fontSize: 30)),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //   Container(width: 35 , height: 30, alignment: Alignment.center ,child: Text("S.No."), decoration: BoxDecoration(border: Border.all(width: 2))),
          //   Container(width: 80 , height: 30, alignment: Alignment.center ,child: Text("Name"),decoration: BoxDecoration(border: Border.all(width: 2)) ),
          //   Container(width:  100 , height: 30, alignment: Alignment.center ,child: Text("Father Name"),decoration: BoxDecoration(border: Border.all(width: 2)) ),
          //   Container(width: 100 , height: 30, alignment: Alignment.center ,child: Text("Husband Name"), decoration: BoxDecoration(border: Border.all(width: 2))),
          //   Container(width: 100 , height: 30, alignment: Alignment.center ,child: Text("Mobile No."), decoration: BoxDecoration(border: Border.all(width: 2))),
          //   Container(width: 100 , height: 30, alignment: Alignment.center ,child: Text("Address"),decoration: BoxDecoration(border: Border.all(width: 2)) ),
          // ])
          Text("Month - $month", style: TextStyle(fontSize: 12)),

          SizedBox(height: 10),
          Table.fromTextArray(
              data: data,
              headers: header,
              headerPadding: EdgeInsets.all(1),
              headerStyle: TextStyle(fontSize: 10),
              cellStyle: TextStyle(fontSize: 10),
              cellAlignment: Alignment.center,
              cellHeight: 1,
              cellPadding: EdgeInsets.all(2),
              columnWidths: {
                0: FlexColumnWidth(0.5),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1.5),
                3: FlexColumnWidth(0.7),
                4: FlexColumnWidth(0.8)
              }),
          Table.fromTextArray(
              data: [],
              headers: [
                "Online($onlineCount) - $onlinefee",
                "Offline($offlineCount) - $offlinefee",
                "Grand Total - $totalfee"
              ],
              headerStyle: TextStyle(fontSize: 10),
              cellStyle: TextStyle(fontSize: 10)),
          // Table.fromTextArray(data: [] , headers: ["Offline" , offlinefee.toString()] , columnWidths: {0:FlexColumnWidth(0.8) , 1:FlexColumnWidth(0.2)} , headerStyle: TextStyle(fontSize: 10),cellStyle: TextStyle(fontSize: 10) ),
          // Table.fromTextArray(data: [] , headers: ["Grand Total" , totalfee.toString()] , columnWidths: {0:FlexColumnWidth(0.8) , 1:FlexColumnWidth(0.2)}  , headerStyle: TextStyle(fontSize: 10),cellStyle: TextStyle(fontSize: 10))
          //"S.No." ,"Date" ,"Name" , "Rg.No." , "Reg.Fee","Monthly","Trademil","Lights","personal","Other" ,"Mode" ,"Total"
        ]);
      },
    );
  }

  static List<Page> expensesYearlyFeePage(
      List<dynamic> list, var p, String date) {
    List<Page> pages = [];

    List<dynamic> s = [];
    int totalfee = 0;

    int currentMonth = 0;
    list.sort(
      (a, b) {
        DateTime aDT = DateTime.parse(a["date"]);
        DateTime bDT = DateTime.parse(b["date"]);

        return aDT.compareTo(bDT);
      },
    );

    DateTime firstDate = DateTime.parse(list[0]["date"]);
    int value = DateTime.parse(list[0]["date"]).month;
    DateTime now = DateTime(DateTime.now().year, 4, 5);
    // if (value > 1 ) {
    //   for (int j = 1; j < value; j++) {
    //     DateTime v = DateTime(firstDate.year, j);
    //     var val = {
    //       "SR.No.": s.length.toString(),
    //       "date": DateFormat("MMMM").format(v),
    //       "gymOnline": "0",
    //       "gymOffline": "0",
    //       "gymtotal": "0",
    //       "otherOnline": "0",
    //       "otherOffline": "0",
    //       "othertotal": "0",
    //       "expenses": "0",
    //       "total": totalfee.toString()
    //     };

    //     s.add(val);
    //   }
    // }
    currentMonth = now.month;

    int othermonthlyfee = 0;
    int Otheronline = 0;
    int Otheroffline = 0;
    int monthlyfee = 0;
    int gymmonthlyfee = 0;
    int gymonline = 0;
    int gymoffline = 0;
    int online = 0;
    int offline = 0;

    for (var i = 0; i < list.length; i++) {
      DateTime time = DateTime.parse(list[i]["date"]);
      int month = time.month;

      int fee1 = list[i]["amount"];

      if (list[i]["paymentMode"] == "online") {
        online = online + fee1;
      } else {
        offline = offline + fee1;
      }

      if (i != list.length - 1 && currentMonth == month) {
        monthlyfee = monthlyfee + int.parse(list[i]["amount"].toString());

        if (list[i]["expenses"] == "gym") {
          gymmonthlyfee =
              gymmonthlyfee + int.parse(list[i]["amount"].toString());
          if (list[i]["paymentMode"] == "online") {
            gymonline = gymonline + int.parse(list[i]["amount"].toString());
          } else {
            gymoffline = gymoffline + int.parse(list[i]["amount"].toString());
          }
        } else {
          othermonthlyfee =
              othermonthlyfee + int.parse(list[i]["amount"].toString());
          if (list[i]["paymentMode"] == "online") {
            Otheronline = Otheronline + int.parse(list[i]["amount"].toString());
          } else {
            Otheroffline =
                Otheroffline + int.parse(list[i]["amount"].toString());
          }
        }
      } else if (i != list.length - 1) {
        totalfee = totalfee + monthlyfee;

        if (list[i]["expenses"] == "gym") {
          gymmonthlyfee =
              gymmonthlyfee + int.parse(list[i]["amount"].toString());
          if (list[i]["paymentMode"] == "online") {
            gymonline = gymonline + int.parse(list[i]["amount"].toString());
          } else {
            gymoffline = gymoffline + int.parse(list[i]["amount"].toString());
          }
        } else {
          othermonthlyfee =
              othermonthlyfee + int.parse(list[i]["amount"].toString());
          if (list[i]["paymentMode"] == "online") {
            Otheronline = Otheronline + int.parse(list[i]["amount"].toString());
          } else {
            Otheroffline =
                Otheroffline + int.parse(list[i]["amount"].toString());
          }
        }
        var val = {
          "SR.No.": s.length.toString(),
          "date": DateFormat("MMMM").format(DateTime(time.year, currentMonth)),
          "gymOnline": gymonline.toString(),
          "gymOffline": gymoffline.toString(),
          "gymtotal": gymmonthlyfee.toString(),
          "otherOnline": Otheronline.toString(),
          "otherOffline": Otheroffline.toString(),
          "othertotal": othermonthlyfee.toString(),
          "total": totalfee.toString()
        };
        s.add(val);

        currentMonth = currentMonth + 1;
        monthlyfee = int.parse(list[i]["amount"].toString());
        gymmonthlyfee = 0;
        gymoffline = 0;
        gymonline = 0;
        Otheronline = 0;
        Otheroffline = 0;
        othermonthlyfee = 0;
      } else if (i == list.length - 1 && currentMonth == month) {
        monthlyfee = monthlyfee + int.parse(list[i]["amount"].toString());

        totalfee = totalfee + monthlyfee;

        var val = {
          "SR.No.": s.length.toString(),
          "date": DateFormat("MMMM").format(DateTime(time.year, currentMonth)),
          "gymOnline": gymonline.toString(),
          "gymOffline": gymoffline.toString(),
          "gymtotal": gymmonthlyfee.toString(),
          "otherOnline": Otheronline.toString(),
          "otherOffline": Otheroffline.toString(),
          "othertotal": othermonthlyfee.toString(),
          "expenses": monthlyfee.toString(),
          "total": totalfee.toString()
        };
        s.add(val);

        //monthlyfee = int.parse(list[i]["amount"].toString());

      }

      // /print("Month "+month.toString());
      //if(mon)
      //print("data "+ i.toString());
    }
    //add extra month

    for (int j = currentMonth; j < 16; j++) {
      DateTime v = DateTime(firstDate.year, j);
      var val = {
        "SR.No.": currentMonth.toString(),
        "date": DateFormat("MMMM").format(v),
        "gymOnline": "0",
        "gymOffline": "0",
        "gymtotal": "0",
        "otherOnline": "0",
        "otherOffline": "0",
        "othertotal": "0",
        "expenses": "0",
        "total": totalfee.toString()
      };

      s.add(val);
    }

    var data = s.map((e) {
      return [
        e["SR.No."],
        e["date"],
        e["gymOnline"],
        e["gymOffline"],
        e["gymtotal"],
        e["otherOnline"],
        e["otherOffline"],
        e["othertotal"],
        e["total"]
      ];
    }).toList();
    //List<dynamic> adandas =  [["1", "January", "0", "0"], ["2", "February", "0", "0"], ["2", "March", "10000", "10000"], [3, "April", "51300", "61300"]];
    pages.add(
        singleYearlyexpensesPage(data, totalfee, online, offline, p, date));
    //print("List Pages "+ pages.length.toString());

    // List<List<dynamic>> s = [];
    // List<dynamic> table =["1", "Tushar" , "ajksdnajk" , "asdjnad" , "2328342", "asdakds"];

    // s.add(table);

    return pages;
  }

  static Page singleYearlyexpensesPage(var data, int totalfee, int onlinefee,
      int offlinefee, var profile, String date) {
    final header = [
      "S.No.",
      "Months",
      "Online(GYM)",
      "Offline(GYM)",
      "Monthly Exp(GYM)",
      "Online(Other) ",
      "Offline(Other)",
      "Monthly Exp(Other)",
      "Grand Total"
    ];
    return Page(
      pageFormat: PdfPageFormat.a4,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      build: (context) {
        return Column(children: [
          Text(
              (profile["res"] == "true")
                  ? "" + profile["data"]["name"]
                  : "Fitness Hub",
              style: TextStyle(fontSize: 20)),
          SizedBox(height: 5),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Column(children: [
              Text(
                  (profile["res"] == "true")
                      ? "Phone No.- " + profile["data"]["phoneNo"]
                      : "Phone No.-" + "9234294234",
                  style: TextStyle(fontSize: 8)),
              Text(
                  (profile["res"] == "true")
                      ? "Address - " + profile["data"]["businessAddress"]
                      : "Address - Amba Vihar , near Prakash City",
                  style: TextStyle(fontSize: 8)),
              //Text("Fitness Hub" , style: TextStyle(fontSize: 8)),
            ]),
            Column(children: [
              Text(
                  (profile["res"] == "true")
                      ? "GSTIN - " + profile["data"]["gstin"]
                      : "GSTIN - 9234294234",
                  style: TextStyle(fontSize: 8)),
              Text(
                  (profile["res"] == "true")
                      ? "UDYOG No. - " + profile["data"]["udyogRegistration"]
                      : "UDYOG No. - asdnakjsnkas",
                  style: TextStyle(fontSize: 8)),
              //Text("" , style: TextStyle(fontSize: 8)),
            ]),
          ]),
          SizedBox(height: 5),
          Text("Year :- " + date, style: TextStyle(fontSize: 10)),

          // Text("Fitness Hub" , style: TextStyle(fontSize: 30)),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //   Container(width: 35 , height: 30, alignment: Alignment.center ,child: Text("S.No."), decoration: BoxDecoration(border: Border.all(width: 2))),
          //   Container(width: 80 , height: 30, alignment: Alignment.center ,child: Text("Name"),decoration: BoxDecoration(border: Border.all(width: 2)) ),
          //   Container(width:  100 , height: 30, alignment: Alignment.center ,child: Text("Father Name"),decoration: BoxDecoration(border: Border.all(width: 2)) ),
          //   Container(width: 100 , height: 30, alignment: Alignment.center ,child: Text("Husband Name"), decoration: BoxDecoration(border: Border.all(width: 2))),
          //   Container(width: 100 , height: 30, alignment: Alignment.center ,child: Text("Mobile No."), decoration: BoxDecoration(border: Border.all(width: 2))),
          //   Container(width: 100 , height: 30, alignment: Alignment.center ,child: Text("Address"),decoration: BoxDecoration(border: Border.all(width: 2)) ),
          // ])
          //Text("Month - $month" , style: TextStyle(fontSize: 12)),

          SizedBox(height: 10),
          Table.fromTextArray(
              data: data,
              headerStyle: TextStyle(fontSize: 8),
              headers: header,
              cellStyle: TextStyle(fontSize: 8),
              columnWidths: {
                0: FlexColumnWidth(0.5),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1),
                4: FlexColumnWidth(1),
                5: FlexColumnWidth(1)
              },
              cellAlignment: Alignment.center,
              cellHeight: 1,
              cellPadding: EdgeInsets.all(2)),
          // Table.fromTextArray(data: [] , headers: ["Online Fee" , onlinefee.toString()] , columnWidths: {0:FlexColumnWidth(1) , 1:FlexColumnWidth(0.1)} ),
          // Table.fromTextArray(data: [] , headers: ["Offline Fee" , offlinefee.toString()] , columnWidths: {0:FlexColumnWidth(1) , 1:FlexColumnWidth(0.1)} )
          //Table.fromTextArray(data: [] , headers: ["Grand Total" , totalfee.toString()] , columnWidths: {0:FlexColumnWidth(1) , 1:FlexColumnWidth(0.1)} )
        ]);
      },
    );
  }

  static List<Page> attandanceMonthlyPage(
      var profile, var data, DateTime month) {
    List<Page> pages = [];
    int days = material.DateUtils.getDaysInMonth(month.year, month.month);
    List<List<dynamic>> s = [];

    for (var i = 0; i < data.length; i++) {
      //s.add(data[i]);
      s.add(attandanceSeprator(i + 1, data[i], days));

      if (i == data.length - 1 || (i != 0 && i % 49 == 0)) {
        pages.add(attandancePage(s.toList(), profile, month));
        s = [];
      }
    }

    return pages;
  }

  static Page attandancePage(var data, var profile, DateTime time) {
    //print("Total days "+ d.toString());
    // DateTime time = DateTime(2023 , 2);
    final h = [];
    h.add("S.N");
    h.add("Reg.N.");
    h.add("Name");
    int days = material.DateUtils.getDaysInMonth(time.year, time.month);
    for (var i = 0; i < days; i++) {
      h.add((i + 1).toString());
    }

    // final header = ["S.N" ,"Reg.N." , "Name" ];
    // for (var i = 0; i < d; i++) {
    //   header.add((i+1).toString());
    // }
    return Page(
      pageFormat: PdfPageFormat.a4,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      build: (context) {
        return Column(children: [
          Text(
              (profile["res"] == "true")
                  ? "" + profile["data"]["name"]
                  : "Fitness Hub",
              style: TextStyle(fontSize: 20)),
          SizedBox(height: 5),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Column(children: [
              Text(
                  (profile["res"] == "true")
                      ? "Phone No.- " + profile["data"]["phoneNo"]
                      : "Phone No.-" + "9234294234",
                  style: TextStyle(fontSize: 8)),
              Text(
                  (profile["res"] == "true")
                      ? "Address - " + profile["data"]["businessAddress"]
                      : "Address - Amba Vihar , near Prakash City",
                  style: TextStyle(fontSize: 8)),
              //Text("Fitness Hub" , style: TextStyle(fontSize: 8)),
            ]),
            Column(children: [
              Text(
                  (profile["res"] == "true")
                      ? "GSTIN - " + profile["data"]["gstin"]
                      : "GSTIN - 9234294234",
                  style: TextStyle(fontSize: 8)),
              Text(
                  (profile["res"] == "true")
                      ? "UDYOG No. - " + profile["data"]["udyogRegistration"]
                      : "UDYOG No. - asdnakjsnkas",
                  style: TextStyle(fontSize: 8)),
              //Text("" , style: TextStyle(fontSize: 8)),
            ]),
          ]),
          Text("Month - ${DateFormat("MMMM").format(time)}",
              style: TextStyle(fontSize: 10)),
          SizedBox(height: 10),
          Table.fromTextArray(
              data: data,
              headers: h,
              cellStyle: TextStyle(fontSize: 7),
              headerStyle: TextStyle(fontSize: 8),
              cellAlignment: Alignment.center,
              cellHeight: 1,
              cellPadding: EdgeInsets.all(2))
        ]);
      },
    );
  }

  static List<Page> profitandlosspage(var data, var profile, String time) {
    List<Page> pages = [];
    List<List<dynamic>> value = [];

    Map<String, dynamic> totalfees = data["totalFee"];
    Map<String, dynamic> gymExp = data["gymExp"];
    Map<String, dynamic> otherExp = data["otherExp"];

    DateTime now = DateTime(DateTime.now().year, 4, 5);
    int grandtotal = 0;
    for (var i = 0; i < 12; i++) {
      List<String> list = [];
      String month = DateFormat("MMMM").format(now).toUpperCase();
      var monthlyFee;
      var monthlygymExp;
      var monthlyotherExp;
      if (totalfees.containsKey(month)) {
        monthlyFee = totalfees[month];
      }

      if (gymExp.containsKey(month)) {
        monthlygymExp = gymExp[month];
      }

      if (otherExp.containsKey(month)) {
        monthlyotherExp = otherExp[month];
      }
      list = [(i + 1).toString(), month];
      list.add((monthlyFee != null) ? monthlyFee["totalOnlineFees"] : "0");
      list.add((monthlyFee != null) ? monthlyFee["totalOfflineFees"] : "0");
      list.add((monthlyFee != null) ? monthlyFee["totalFees"] : "0");
      list.add((monthlygymExp != null) ? monthlygymExp["gymOnlineExp"] : "0");
      list.add((monthlygymExp != null) ? monthlygymExp["gymOfflineExp"] : "0");
      list.add((monthlygymExp != null) ? monthlygymExp["gymTotalExp"] : "0");
      list.add(
          (monthlyotherExp != null) ? monthlyotherExp["otherOnlineExp"] : "0");
      list.add(
          (monthlyotherExp != null) ? monthlyotherExp["otherOfflineExp"] : "0");
      list.add(
          (monthlyotherExp != null) ? monthlyotherExp["otherTotalExp"] : "0");

      int finalamount =
          int.parse((monthlyFee != null) ? monthlyFee["totalFees"] : "0") -
              (int.parse((monthlygymExp != null)
                      ? monthlygymExp["gymTotalExp"]
                      : "0") +
                  int.parse((monthlyotherExp != null)
                      ? monthlyotherExp["otherTotalExp"]
                      : "0"));
      list.add(finalamount.toString());
      grandtotal = grandtotal + finalamount;
      list.add(grandtotal.toString());

      value.add(list.toList());
      if (now.month + 1 > 13) {
        now = DateTime(now.year + 1, 1);
      } else {
        now = DateTime(now.year, now.month + 1);
      }
    }
    String month = DateFormat("MMMM").format(now);
    // print("Month value "+ month.toUpperCase());

    pages.add(singleProfitandLossPage(value.toList(), profile, time));

    return pages;
  }

  static Page singleProfitandLossPage(var data, var profile, String time) {
    //print("Total days "+ d.toString());
    // DateTime time = DateTime(2023 , 2);
    final h = [
      "Sr.No.",
      "Month",
      "Online Fees",
      "Offline Fees",
      "Total Fees",
      "Gym Online Expenses",
      "Gym Offline Expenses",
      "Gym Total Expenses",
      "Other Online Expenses",
      "Other Offline Expenses",
      "Other Total Expenses",
      "Final Amount",
      "Grand Total"
    ];

    return Page(
      pageFormat: PdfPageFormat.a4,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      build: (context) {
        return Column(children: [
          Text(
              (profile["res"] == "true")
                  ? "" + profile["data"]["name"]
                  : "Fitness Hub",
              style: TextStyle(fontSize: 20)),
          SizedBox(height: 5),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Column(children: [
              Text(
                  (profile["res"] == "true")
                      ? "Phone No.- " + profile["data"]["phoneNo"]
                      : "Phone No.-" + "9234294234",
                  style: TextStyle(fontSize: 8)),
              Text(
                  (profile["res"] == "true")
                      ? "Address - " + profile["data"]["businessAddress"]
                      : "Address - Amba Vihar , near Prakash City",
                  style: TextStyle(fontSize: 8)),
              //Text("Fitness Hub" , style: TextStyle(fontSize: 8)),
            ]),
            Column(children: [
              Text(
                  (profile["res"] == "true")
                      ? "GSTIN - " + profile["data"]["gstin"]
                      : "GSTIN - 9234294234",
                  style: TextStyle(fontSize: 8)),
              Text(
                  (profile["res"] == "true")
                      ? "UDYOG No. - " + profile["data"]["udyogRegistration"]
                      : "UDYOG No. - asdnakjsnkas",
                  style: TextStyle(fontSize: 8)),
              //Text("" , style: TextStyle(fontSize: 8)),
            ]),
          ]),
          Text("Year - $time", style: TextStyle(fontSize: 10)),
          SizedBox(height: 10),
          Table.fromTextArray(
              data: data,
              headers: h,
              cellStyle: TextStyle(fontSize: 7),
              columnWidths: {
                0: FlexColumnWidth(0.2),
                1: FlexColumnWidth(0.8),
                2: FlexColumnWidth(0.5),
                3: FlexColumnWidth(0.5),
                4: FlexColumnWidth(0.5),
                5: FlexColumnWidth(1),
                6: FlexColumnWidth(1),
                7: FlexColumnWidth(1),
                8: FlexColumnWidth(1),
                9: FlexColumnWidth(1),
                10: FlexColumnWidth(1),
                11: FlexColumnWidth(0.5),
                12: FlexColumnWidth(0.5)
              },
              headerStyle: TextStyle(fontSize: 8),
              cellAlignment: Alignment.center,
              cellHeight: 1,
              cellPadding: EdgeInsets.all(2))
        ]);
      },
    );
  }

  static List<dynamic> attandanceSeprator(int srNo, var data, int days) {
    Map<String, String> value;
    List<dynamic> s = [];

    List<dynamic> attandance = data["Attandances"];
    s.add("$srNo");
    s.add(data["User"]["registrationNo"].toString());
    s.add(data["User"]["name"].toString());
    //print("One person data" + attandance.toString());
    for (var i = 0; i < 31; i++) {
      if (attandance != null && attandance.length > 0) {
        var a = attandance.indexWhere((element) {
          DateTime time = DateTime.parse(element["date"].toString());
          return time.day == i + 1;
        });

        if (a != -1) {
          var att = attandance[a];
          DateTime time = DateTime.parse(att["date"].toString());
          if (time.day == i + 1 && att["attandanceStatus"] == "present") {
            //print("Day $i and status present" );
            s.add("P");
          } else {
            //print("Day $i and status absent" );
            s.add("A");
          }
        } else {
          s.add("A");
        }
      } else {
        s.add("A");
      }
    }
    return s.toList();
  }

  static String getTimeForTitle(DateTime time, pdf pdftime) {
    String date = "";
    if (time.month <= 3) {
      if (pdftime == pdf.monthly) {
        date = DateFormat("MMMM").format(time) +
            " " +
            DateFormat("y").format(time);
      } else {
        date = DateFormat("y").format(DateTime(time.year - 1)) +
            " - " +
            DateFormat("y").format(time);
      }
    } else {
      if (pdftime == pdf.monthly) {
        date = DateFormat("MMMM").format(time) +
            " " +
            DateFormat("y").format(time);
      } else {
        date = DateFormat("y").format(time) +
            " - " +
            DateFormat("y").format(DateTime(time.year + 1));
      }
    }

    return date;
  }
}
