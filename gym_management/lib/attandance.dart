import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_management/DTO/Attandance.dart';
import 'package:gym_management/DTO/User.dart';
import 'package:gym_management/Server/Services.dart';
import 'package:gym_management/globalData.dart';
import 'package:intl/intl.dart';

class Attandance extends StatefulWidget {
  const Attandance({super.key});

  @override
  State<Attandance> createState() => _AttandanceState();
}

class _AttandanceState extends State<Attandance> with TickerProviderStateMixin {
  TabController? _tabController;
  TextEditingController searchController = TextEditingController();
  int tabIndex = 0;
  static List<String>? attandancePresentUser;
  List<UserModel> searchedUser = [];
  List<AttandanceModel> presentUser = [];
  List<AttandanceModel> absentUser = [];
  bool waitForFinishResponse = false;
  bool waitForSubmitResponse = false;
  bool waitFordeleteList = false;

  DateTime attandanceDate = DateTime.now();
  String attandanceDateShow = "00-00-0000";

  var alluser = {
    {"name": "Tushar", "registrationNo": "111"},
    {"name": "Daksh", "registrationNo": "112"},
    {"name": "Pheonix", "registrationNo": "113"},
    {"name": "thunder", "registrationNo": "114"},
    {"name": "Slayer", "registrationNo": "115"},
    {"name": "Logan", "registrationNo": "116"}
  };
  int activeUserlength = 0;
  int presentUserlength = 0;
  int absentUserlength = 0;
  bool isSelect = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // checkForValue();
    getList();
    attandanceDateShow = DateFormat("dd").format(attandanceDate) +
        "  " +
        DateFormat("MMMM").format(attandanceDate) +
        "  " +
        DateFormat("y").format(attandanceDate);
  }

  getList() async {
    global.userList = await getactiveUserList();

    List<AttandanceModel> present = await getPresentUserList();
    global.presentList = present;

    List<AttandanceModel> absentList = await getAbsentUserList();
    global.absentList = absentList;

    print("User Present List " + global.presentList.toString());
    print("User absent List " + global.absentList.toString());

    setState(() {
      activeUserlength = global.userList!.length;
      presentUserlength = presentUser.length;
      absentUserlength = absentList.length;
      searchedUser = global.userList!;
      presentUser = present;
      absentUser = absentList;
    });
  }

  @override
  Widget build(BuildContext context) {
    double textscale = 0.9;

    _tabController =
        new TabController(length: 3, vsync: this, initialIndex: tabIndex);

    double unitwidth = MediaQuery.of(context).size.width / 100;
    double unitheight = MediaQuery.of(context).size.height / 100;
    return Container(
      width: unitwidth * 100,
      height: unitheight * 90,
      color: Colors.grey[900],
      child: ListView(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: unitwidth * 90,
                  height: unitwidth * 13,
                  margin: EdgeInsets.symmetric(
                      horizontal: unitwidth * 7, vertical: unitwidth * 2),
                  child: Row(
                    children: [
                      SizedBox(
                        width: unitwidth * 3,
                      ),
                      Icon(Icons.date_range,
                          color: Colors.white, size: unitwidth * 4),
                      SizedBox(
                        width: unitwidth * 2,
                      ),
                      AutoSizeText(
                        "Attandance Date",
                        style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                                color: Colors.white, fontSize: unitwidth * 3)),
                        textScaleFactor: textscale,
                      ),
                      SizedBox(
                        width: unitwidth * 5,
                      ),
                      Container(
                        width: unitwidth * 18,
                        height: unitheight * 3.5,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.7),
                            borderRadius: BorderRadius.all(
                                Radius.circular(unitwidth * 1.5))),
                        child: MaterialButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate:
                                          DateTime(DateTime.now().year - 1),
                                      lastDate:
                                          DateTime(DateTime.now().year + 1))
                                  .then((value) => {
                                        setState(() {
                                          print("Date " + value.toString());
                                          if (value != null) {
                                            attandanceDate = value;
                                            attandanceDateShow = "" +
                                                DateFormat("dd").format(value) +
                                                "  " +
                                                DateFormat("MMMM")
                                                    .format(value) +
                                                "  " +
                                                DateFormat("y").format(value);
                                          }
                                        }),
                                        checkForLength()
                                      });
                            },
                            child: Text("Pick A Date",
                                style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: unitwidth * 2.5,
                                        fontWeight: FontWeight.w600)),
                                textScaleFactor: textscale)),
                      ),
                      SizedBox(
                        width: unitwidth * 8,
                      ),
                      Text(attandanceDateShow,
                          style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: unitwidth * 3,
                                  fontWeight: FontWeight.w500)),
                          textScaleFactor: textscale),
                    ],
                  ),
                ),
                if (tabIndex == 0)
                  Container(
                    width: unitwidth * 100,
                    height: unitheight * 5,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MaterialButton(
                          onPressed: () {
                            if (global.addUserTopresentList != null &&
                                global.addUserTopresentList!.isNotEmpty) {
                              //global.presentList!.addAll(global.addUserTopresentList!);
                              submitAttandance(global.addUserTopresentList!);
                              //global.addUserTopresentList = [];

                              if (global.addUserTopresentList != null &&
                                  global.addUserTopresentList!.isNotEmpty) {
                                for (var i = 0;
                                    i < global.addUserTopresentList!.length;
                                    i++) {
                                  print(global.addUserTopresentList![i]);
                                }
                              }
                              setState(() {});
                            }
                          },
                          child: Container(
                            width: unitwidth * 30,
                            height: unitheight * 8,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(unitwidth * 2))),
                            child: Text("Submit",
                                style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: unitwidth * 4,
                                        fontWeight: FontWeight.w600)),
                                textScaleFactor: textscale),
                          ),
                        ),
                        MaterialButton(
                          onPressed: () {
                            finishDayDialog(context);
                          },
                          child: Container(
                            width: unitwidth * 30,
                            height: unitheight * 6,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(unitwidth * 2))),
                            child: Text("Finish Days",
                                style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: unitwidth * 4,
                                        fontWeight: FontWeight.w600)),
                                textScaleFactor: textscale),
                          ),
                        )
                      ],
                    ),
                  )
                else
                  Container(
                    width: unitwidth * 100,
                    height: unitheight * 5,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MaterialButton(
                          onPressed: () {
                            if (tabIndex == 1) {
                              if (global.deleteUserPresentList != null &&
                                  global.deleteUserPresentList!.isNotEmpty) {
                                //global.presentList!.addAll(global.addUserTopresentList!);
                                deleteAttandance(global.deleteUserPresentList!,
                                    attandance.present);
                                //global.addUserTopresentList = [];

                                //      if(global.addUserTopresentList != null && global.addUserTopresentList!.isNotEmpty){
                                //   for (var i = 0; i < global.addUserTopresentList!.length; i++) {
                                //     print(global.addUserTopresentList![i]);
                                //   }
                                //  }
                                setState(() {});
                              }
                            } else if (tabIndex == 2) {
                              if (global.deleteUserAbsentList != null &&
                                  global.deleteUserAbsentList!.isNotEmpty) {
                                //global.presentList!.addAll(global.addUserTopresentList!);
                                deleteAttandance(global.deleteUserAbsentList!,
                                    attandance.absent);
                                //global.addUserTopresentList = [];

                                //      if(global.addUserTopresentList != null && global.addUserTopresentList!.isNotEmpty){
                                //   for (var i = 0; i < global.addUserTopresentList!.length; i++) {
                                //     print(global.addUserTopresentList![i]);
                                //   }
                                //  }
                                setState(() {});
                              }
                            }
                          },
                          child: Container(
                            width: unitwidth * 30,
                            height: unitheight * 6,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(unitwidth * 2))),
                            child: Text("Delete",
                                style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: unitwidth * 4,
                                        fontWeight: FontWeight.w600)),
                                textScaleFactor: textscale),
                          ),
                        )
                      ],
                    ),
                  ),
                if (attandanceDateShow == "00-00-0000")
                  Text("Please pick a date",
                      style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                              color: Colors.red,
                              fontSize: unitwidth * 2.5,
                              fontWeight: FontWeight.w600)),
                      textScaleFactor: textscale),
              ],
            ),
            Container(
              width: unitwidth * 100,
              height: unitheight * 5,
              margin: EdgeInsets.symmetric(vertical: unitwidth * 3),
              child: TabBar(
                tabs: [
                  Tab(
                    child: Text("Active User ($activeUserlength)",
                        style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                                color: Colors.white, fontSize: unitwidth * 3)),
                        textScaleFactor: textscale),
                  ),
                  Tab(
                    child: Text("Present User ($presentUserlength)",
                        style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                                color: Colors.white, fontSize: unitwidth * 3)),
                        textScaleFactor: textscale),
                  ),
                  Tab(
                    child: Text("Absent User ($absentUserlength)",
                        style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                                color: Colors.white, fontSize: unitwidth * 3)),
                        textScaleFactor: textscale),
                  ),
                ],
                controller: _tabController,
                onTap: _onItemTapped,
                indicatorColor: Colors.blue,
                indicatorWeight: unitwidth * 0.5,
              ),
            ),
            Container(
                width: unitwidth * 100,
                height: unitheight * 60,
                color: Colors.grey[900],
                child: ListView(shrinkWrap: true, children: [
                  FutureBuilder(
                      future: getUserList(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return CircularProgressIndicator();
                        } else {
                          return Column(
                            children: [
                              Column(
                                children: [
                                  Container(
                                    width: unitwidth * 100,
                                    height: unitwidth * 13,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(unitwidth * 2))),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: unitwidth * 7,
                                        vertical: unitwidth * 2),
                                    child: TextFormField(
                                      textInputAction: TextInputAction.next,
                                      style: GoogleFonts.montserrat(
                                          textStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18 * 1)),
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        border: UnderlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4))),
                                        hintText: 'Search',
                                        hintStyle: GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: unitwidth * 1 * 3)),
                                        prefixIcon: Icon(Icons.search,
                                            color: Colors.blue,
                                            size: unitwidth * 4),
                                      ),
                                      controller: searchController,
                                      onChanged: ((value) {
                                        print("Searched " + value.toString());
                                        runFilter(value);
                                        //if(user.name!.toLowerCase().contains(query.toLowerCase()) || user.registrationNo.toString().contains(query))
                                        // searchedUser = global.userList.where((element) => false)

                                        // if(element.name.toLowerCase().contains(value) || element.registrationNo.toString().contains(value)){

                                        //  }
                                      }),
                                      keyboardType: TextInputType.text,
                                    ),
                                  ),

                                  //  for(int i =0 ; i < searchedUser.length ; i++ )

                                  //if(checkForUserabsent(snapshot.data![i].registrationNo!))
                                ],
                              ),
                              if (tabIndex == 0)
                                for (int index = 0;
                                    index < searchedUser.length;
                                    index++)
                                  if (searchedUser.isNotEmpty &&
                                      searchedUser.isNotEmpty &&
                                      checkForUserPresent(
                                          searchedUser[index].registrationNo!))
                                    AttandanceList(
                                      name: searchedUser[index].name!,
                                      registrationNo: searchedUser[index]
                                          .registrationNo
                                          .toString(),
                                      a: attandance.active,
                                      notifyParent: refreshData,
                                      id: "1",
                                      time: "",
                                      select: isSelect,
                                    )
                                  else if (global.absentList.isNotEmpty)
                                    AttandanceList(
                                        name: searchedUser[index].name!,
                                        registrationNo: searchedUser[index]
                                            .registrationNo
                                            .toString(),
                                        a: attandance.active,
                                        notifyParent: refreshData,
                                        id: "1",
                                        time: '',
                                        select: isSelect)
                                  else
                                    Container(),

                              //  ListView.builder(itemCount: searchedUser.length,  scrollDirection: Axis.vertical,shrinkWrap: true,itemBuilder: ((context, index) {

                              //   })),

                              if (tabIndex == 1)
                                for (int i = 0; i < presentUser.length; i++)
                                  //if(checkForUserPresent())
                                  AttandanceList(
                                      name: presentUser[i].user!.name!,
                                      registrationNo: presentUser[i]
                                          .user!
                                          .registrationNo!
                                          .toString(),
                                      a: attandance.present,
                                      notifyParent: refreshData,
                                      id: presentUser[i].id.toString(),
                                      time: (presentUser[i].attandanceTime !=
                                              null)
                                          ? presentUser[i].attandanceTime!
                                          : AttandanceTime.morning.name,
                                      select: isSelect),

                              if (tabIndex == 2)
                                for (int i = 0; i < absentUser.length; i++)
                                  //if(checkForUserPresent())
                                  AttandanceList(
                                      name: absentUser[i].user!.name!,
                                      registrationNo: absentUser[i]
                                          .user!
                                          .registrationNo
                                          .toString(),
                                      a: attandance.absent,
                                      notifyParent: refreshData,
                                      id: absentUser[i].id.toString(),
                                      time:
                                          (absentUser[i].attandanceTime != null)
                                              ? absentUser[i].attandanceTime!
                                              : AttandanceTime.morning.name,
                                      select: isSelect)
                            ],
                          );
                        }
                      })
                ])),
          ]),
    );
  }

  _onItemTapped(int index) {
    searchController.clear();
    global.deleteUserAbsentList = [];
    global.deleteUserPresentList = [];
    setState(() {
      tabIndex = index;
    });
    checkForLength();

    print("Delete present user " + global.deleteUserPresentList.toString());
    print("Delete absent user " + global.deleteUserAbsentList.toString());
  }

  runFilter(String value) {
    List<UserModel> list = [];
    List<AttandanceModel> presentList = [];
    List<AttandanceModel> absentL = [];

    if (tabIndex == 0) {
      if (value.isEmpty) {
        list = global.userList!;
      } else {
        // for (var i = 0; i < global.userList!.length; i++) {
        //    if(global.userList![i].name!.toLowerCase().contains(value.toLowerCase())){
        //      list.add(global.userList![i]);
        //    }
        // }
        list = global.userList!
            .where((element) =>
                element.name!.toLowerCase().contains(value.toLowerCase()))
            .toList();
      }
    } else if (tabIndex == 1) {
      if (value.isEmpty) {
        presentList = global.presentList;
      } else {
        presentList = global.presentList
            .where((element) =>
                element.user!.name!.toLowerCase().contains(value.toLowerCase()))
            .toList();
      }
    } else {
      if (value.isEmpty) {
        absentL = global.absentList;
      } else {
        absentL = global.absentList
            .where((element) =>
                element.user!.name!
                    .toLowerCase()
                    .contains(value.toLowerCase()) ||
                element.user!.registrationNo.toString().contains(value))
            .toList();
      }
    }
    print("Searched List " + list.toString());
    setState(() {
      if (tabIndex == 0) {
        searchedUser = list;
      } else if (tabIndex == 1) {
        presentUser = presentList;
      } else {
        absentUser = absentL;
      }
    });
  }

  refreshData() async {
    List<AttandanceModel> list = [];
    if (tabIndex == 1) {
      list = await getPresentUserList();
    } else if (tabIndex == 2) {
      list = await getAbsentUserList();
    }

    setState(() {
      if (tabIndex == 1) {
        presentUser = list;
        global.presentList = list;
      } else if (tabIndex == 2) {
        absentUser = list;
        global.absentList = list;
      }
    });

    checkForLength();
  }

  submitAttandance(List<int> registationNo) async {
    print("List $registationNo");
    DateTime now = DateTime.now();
    DateTime t = DateTime(now.year, now.month, now.day, 12);
    AttandanceTime attandanceTime = AttandanceTime.morning;
    if (now.isAfter(t)) {
      print("After " + t.toString() + "  " + now.toString());
      attandanceTime = AttandanceTime.evening;
    } else {
      print("after false " + t.toString() + "  " + now.toString());
      attandanceTime = AttandanceTime.morning;
    }
    var data;
    if (!waitForSubmitResponse) {
      data = await Services().submitAttandance(
          registationNo, attandanceDate.toString(), attandanceTime.name);
    }

    print("submit attandance response $data");
    if (data.toString() == "true") {
      global.addUserTopresentList = [];
      setState(() {
        waitForSubmitResponse = false;
        getList();
      });
      _onItemTapped(1);
    } else {
      waitForSubmitResponse = false;
      Fluttertoast.showToast(
          msg: "Please submit again ", toastLength: Toast.LENGTH_LONG);
    }
  }

  deleteAttandance(List<int> list, attandance value) async {
    print("List $list");

    var data;
    if (!waitFordeleteList) {
      data = await Services()
          .deleteAttandanceList(list, attandanceDate.toString(), value);
    }

    print("submit attandance response $data");
    if (data.toString() == "true") {
      if (value == attandance.present) {
        global.deleteUserPresentList = [];
      } else {
        global.deleteUserAbsentList = [];
      }
      checkForLength();
      setState(() {
        waitFordeleteList = false;
        getList();
      });
    } else {
      waitForSubmitResponse = false;
      Fluttertoast.showToast(
          msg: "Please submit again ", toastLength: Toast.LENGTH_LONG);
    }
  }

  checkForLength() async {
    List<AttandanceModel> present = [];
    List<AttandanceModel> absent = [];
    present = await getPresentUserList();
    absent = await getAbsentUserList();

    absentUser = absent;
    presentUser = present;
    // if(tabIndex == 1){

    // }else if(tabIndex == 2){

    // }

    setState(() {
      presentUserlength = present.length;
      absentUserlength = absent.length;
    });
  }

  Future<dynamic> getUserList() async {
    var data = [];

    if (tabIndex == 0) {
      List<UserModel> ac = await getactiveUserList();
      //print("User Active List "+ data.toString());
      global.userList = ac;
      //searchedUser = global.userList!;

      //converting list
      List<AttandanceModel> present = await getPresentUserList();
      presentUser = present;
      //global.presentList = present;
      return data;
    } else if (tabIndex == 1) {
      List<AttandanceModel> pr = await getPresentUserList();
      //presentUser = pr;
      global.presentList = pr;
      //print("User Present List "+ data.toString());

      return pr;
    } else {
      List<AttandanceModel> ab = await getAbsentUserList();
      //absentUser  = ab;
      global.absentList = ab;
      // print("User Absent List "+ data.toString());
      return ab;
    }
  }

  getactiveUserList() async {
    List<UserModel> activeUsers = await Services().getActiveUser();
    // List<UserModel> data =[];
    // for (var i = 0; i < activeUsers.length; i++) {
    //   data.add(UserModel().toJson(activeUsers[i]));
    // }
    activeUsers.sort((a, b) {
      return a.name!.toLowerCase().compareTo(b.name!.toLowerCase());
    });
    return activeUsers;
  }

  getPresentUserList() async {
    List<AttandanceModel> attandance = await Services()
        .getUserAttandanceByStatus(
            attandanceStatus.present, attandanceDate.toString());
    print("Attandance present " + attandance.length.toString());
    return attandance;
  }

  getAbsentUserList() async {
    List<AttandanceModel> attandance = await Services()
        .getUserAttandanceByStatus(
            attandanceStatus.absent, attandanceDate.toString());

    return attandance;
  }

  checkForUserPresent(int registationNo) {
    if (global.presentList.isNotEmpty) {
      for (var i = 0; i < global.presentList.length; i++) {
        if (global.presentList[i].user!.registrationNo == registationNo) {
          return false;
        }
      }
    }
    return true;
  }

  checkForUserabsent(int registationNo) {
    if (global.absentList.isNotEmpty) {
      for (var i = 0; i < global.absentList.length; i++) {
        if (global.absentList[i].user!.registrationNo == registationNo) {
          return false;
        }
      }
    }
    return true;
  }

  list(double width, double height, String name) {
    return Container(
      width: width * 100,
      height: height * 7,
      color: Colors.blue.withOpacity(0.1),
      margin: EdgeInsets.symmetric(horizontal: width * 5, vertical: height * 1),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: width * 13,
              height: width * 13,
              color: Colors.white,
              child: Icon(Icons.people),
            ),
            Text(
              name,
              style: GoogleFonts.montserrat(
                  textStyle:
                      TextStyle(color: Colors.black, fontSize: width * 3)),
            ),
            Container(
                width: width * 16,
                height: width * 8,
                decoration: BoxDecoration(color: Colors.blue),
                child: MaterialButton(
                  onPressed: () {},
                  child: Text(
                    "Add",
                    style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                            color: Colors.black, fontSize: width * 3)),
                  ),
                ))
          ]),
    );
  }

  finishDayDialog(BuildContext context) {
    double textscalefactor = 0.8;
    double unitwidth = MediaQuery.of(context).size.width / 100;
    AlertDialog alertDialog = AlertDialog(
      title: Text(
        "Finishing today",
        style: GoogleFonts.montserrat(
            textStyle: TextStyle(color: Colors.black, fontSize: unitwidth * 5)),
      ),
      content: Text(
        "Are You sure ! Finishing day ?\n it means which user not present this day , will automatically turn into absent",
        textAlign: TextAlign.center,
        style: GoogleFonts.montserrat(
            textStyle:
                TextStyle(color: Colors.grey, fontSize: unitwidth * 3.1)),
        textScaleFactor: textscalefactor,
      ),
      actions: [
        MaterialButton(
          onPressed: () async {
            AttandanceTime attandanceTime = AttandanceTime.evening;
            attandanceTime = getAttandanceTime();
            var res;
            if (!waitForFinishResponse) {
              waitForFinishResponse = true;
              res = await Services()
                  .finishDay(attandanceDate.toString(), attandanceTime.name);
            }

            //List<AttandanceModel> absentList = await getAbsentUserList();

            //global.absentList = absentList;    //await Services().addUser(user);
            print("Add user " + res.toString());
            if (res.toString() == "true") {
              Navigator.pop(context);
              waitForFinishResponse = false;
              _onItemTapped(2);
            } else {
              waitForFinishResponse = false;
            }
            //addUser(context);
          },
          child: Container(
            width: unitwidth * 17,
            height: unitwidth * 8,
            color: Colors.blue,
            alignment: Alignment.center,
            child: Text(
              "Yes",
              style: GoogleFonts.montserrat(
                  textStyle:
                      TextStyle(color: Colors.white, fontSize: unitwidth * 4)),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            if (!waitForFinishResponse) {
              Navigator.pop(context);
            }
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
  }

  getAttandanceTime() {
    DateTime now = DateTime.now();
    DateTime t = DateTime(now.year, now.month, now.day, 12);
    AttandanceTime attandanceTime = AttandanceTime.morning;
    if (now.isAfter(t)) {
      print("After " + t.toString() + "  " + now.toString());
      attandanceTime = AttandanceTime.evening;
    } else {
      print("after false " + t.toString() + "  " + now.toString());
      attandanceTime = AttandanceTime.morning;
    }
    return attandanceTime;
  }
}

class AttandanceList extends StatefulWidget {
  String time;
  String name;
  String id;
  String registrationNo;
  attandance a;
  final Function() notifyParent;
  bool select;
  AttandanceList(
      {super.key,
      required this.id,
      required this.name,
      required this.registrationNo,
      required this.a,
      required this.time,
      required this.notifyParent,
      required this.select});

  @override
  State<AttandanceList> createState() => _AttandanceListState();
}

class _AttandanceListState extends State<AttandanceList> {
  bool select = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    select = false;
    print("sdankfbjabd");
  }

  @override
  Widget build(BuildContext context) {
    double textscale = 0.9;
    double width = MediaQuery.of(context).size.width / 100;
    double height = MediaQuery.of(context).size.height / 100;
    return Container(
      width: width * 100,
      height: height * 7,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      margin: EdgeInsets.symmetric(horizontal: width * 5, vertical: height * 1),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.a != attandance.active)
              Container(
                width: width * 13,
                height: width * 13,
                alignment: Alignment.center,
                color: Colors.white.withOpacity(0.1),
                child: Text(
                  (widget.time.isNotEmpty &&
                          widget.time == AttandanceTime.morning.name)
                      ? "Morning"
                      : "Evening",
                  style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black.withOpacity(0.9),
                          fontSize: width * 2.8)),
                  textScaleFactor: textscale,
                ),
              ),
            if (widget.a == attandance.active)
              Container(
                width: width * 13,
                height: width * 13,
                alignment: Alignment.center,
                color: Colors.white.withOpacity(0.1),
                child: Icon(Icons.people),
              ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AutoSizeText(widget.name,
                    style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: width * 4)),
                    textScaleFactor: textscale),
                SizedBox(
                  height: height * 0.5,
                ),
                Text(
                  "Registration no -" + widget.registrationNo,
                  style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black.withOpacity(0.6),
                          fontSize: width * 2.8)),
                  textScaleFactor: textscale,
                ),
              ],
            ),
            if (widget.a == attandance.active)
              Container(
                  width: width * 16,
                  height: width * 8,
                  child: Checkbox(
                    activeColor: Colors.black,
                    checkColor: Colors.white,
                    onChanged: ((value) => {
                          setState(() {
                            select = value!;
                            if (value) {
                              global.addUserTopresentList!
                                  .add(int.parse(widget.registrationNo));
                            } else {
                              if (global.addUserTopresentList != null &&
                                  global.addUserTopresentList!.isNotEmpty) {
                                if (global.addUserTopresentList!.contains(
                                    int.parse(widget.registrationNo))) {
                                  global.addUserTopresentList!
                                      .remove(int.parse(widget.registrationNo));
                                }
                                // for (var i = 0; i < global.presentList!.length; i++) {
                                //    if(global.presentList![i] == widget.name){

                                //    }
                                // }
                              }
                              //remove this list from present List
                            }
                            if (global.addUserTopresentList != null &&
                                global.addUserTopresentList!.length != 0) {
                              for (var i = 0;
                                  i < global.addUserTopresentList!.length;
                                  i++) {
                                print(global.addUserTopresentList![i]);
                              }
                            }
                          })
                        }),
                    value: select,
                  )),
            if (widget.a != attandance.active)
              Container(
                  width: width * 16,
                  height: width * 8,
                  child: Checkbox(
                    activeColor: Colors.black,
                    checkColor: Colors.white,
                    onChanged: ((value) => {
                          setState(() {
                            select = value!;
                            if (widget.a == attandance.present) {
                              if (value) {
                                global.deleteUserPresentList!
                                    .add(int.parse(widget.id));
                              } else {
                                if (global.deleteUserPresentList != null &&
                                    global.deleteUserPresentList!.isNotEmpty) {
                                  if (global.deleteUserPresentList!
                                      .contains(int.parse(widget.id))) {
                                    global.deleteUserPresentList!
                                        .remove(int.parse(widget.id));
                                  }
                                }
                              }
                            } else if (widget.a == attandance.absent) {
                              if (value) {
                                global.deleteUserAbsentList!
                                    .add(int.parse(widget.id));
                              } else {
                                if (global.deleteUserAbsentList != null &&
                                    global.deleteUserAbsentList!.isNotEmpty) {
                                  if (global.deleteUserAbsentList!
                                      .contains(int.parse(widget.id))) {
                                    global.deleteUserAbsentList!
                                        .remove(int.parse(widget.id));
                                  }
                                }
                              }
                            }
                            //  if(global.addUserTopresentList != null && global.addUserTopresentList!.length != 0){
                            //   for (var i = 0; i < global.addUserTopresentList!.length; i++) {
                            //     print(global.addUserTopresentList![i]);
                            //   }
                            //  }
                          })
                        }),
                    value: select,
                  )),

            // Container(width: width*16,height: width*8,decoration: BoxDecoration(color: Colors.blue),   child: MaterialButton(onPressed: (){
            // setState(() {
            //   if(select){
            //     select = false;
            //   }else{
            //     select = true;
            //   }

            // });
            // }, child: Text((select)?"Added":"Add" ,style: GoogleFonts.montserrat(
            // textStyle: TextStyle(
            //  color: Colors.black,
            //   fontSize: width*3)), ),))
          ]),
    );
  }

  deleteAttandance() async {
    var response = await Services().deleteAttandance(widget.id);
    print("Delete Attandace " + response.toString());
    Navigator.pop(context);
    widget.notifyParent();
  }

  removeDialog(BuildContext context) {
    double textscalefactor = 0.8;
    double unitwidth = MediaQuery.of(context).size.width / 100;
    AlertDialog alertDialog = AlertDialog(
      title: Text(
        "Remove attandance",
        style: GoogleFonts.montserrat(
            textStyle: TextStyle(color: Colors.black, fontSize: unitwidth * 5)),
      ),
      content: Text(
        "Are You sure ! You want to remove ?\n Registration No . ${widget.registrationNo} \n Name - ${widget.name}",
        textAlign: TextAlign.center,
        style: GoogleFonts.montserrat(
            textStyle:
                TextStyle(color: Colors.grey, fontSize: unitwidth * 3.1)),
        textScaleFactor: textscalefactor,
      ),
      actions: [
        MaterialButton(
          onPressed: () async {
            deleteAttandance();
            //addUser(context);
          },
          child: Container(
            width: unitwidth * 17,
            height: unitwidth * 8,
            color: Colors.blue,
            alignment: Alignment.center,
            child: Text(
              "Yes",
              style: GoogleFonts.montserrat(
                  textStyle:
                      TextStyle(color: Colors.white, fontSize: unitwidth * 4)),
            ),
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
  }
}
