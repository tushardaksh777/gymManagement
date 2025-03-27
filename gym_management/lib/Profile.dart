import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_management/DTO/User.dart';
import 'package:gym_management/PDF/PdfApi.dart';
import 'package:gym_management/Server/Services.dart';
import 'package:gym_management/globalData.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin {
  pdf attandancePdf = pdf.monthly;
  pdf feePdf = pdf.monthly;
  pdf expensesPdf = pdf.monthly;
  expense expenses = expense.gym;
  pdf profitandloss = pdf.monthly;
  DateTime feepdfDateTime = DateTime.now();
  DateTime attandancepdfDateTime = DateTime.now();
  DateTime expensespdfDateTime = DateTime.now();
  DateTime profitandlossDateTime = DateTime.now();

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController gstinController = TextEditingController();
  TextEditingController udyogRegController = TextEditingController();
  TextEditingController desController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  var profileRes;
  // File? image;
  // File? logo;
  bool editProfile = false;
  String logo = "logoImg";
  String signature = "SignImg";
  int tabIndex = 0;

  List<String> states = ["Uttrakhand", "MP", "Delhi"];
  TabController? tabController;
  var data = [
    {
      "title": "Bussiness Address",
      "des": "Amba vihar , near prakash city , kashipur"
    },
    {"title": "GSTIN", "des": "dkajdbahjbkasdkln"},
    {"title": "Udyog Reg", "des": "aidnajkbia"},
    {"title": "Business Description", "des": "Supplement"},
    {"title": "State", "des": "Uttrakhand"},
    {"title": "Business Type", "des": "Service"},
    {"title": "Business Category", "des": "Gym/Fitness"}
  ];
  @override
  Widget build(BuildContext context) {
    double textscal = 0.9;
    tabController =
        new TabController(length: 2, vsync: this, initialIndex: tabIndex);
    double unitwidth = MediaQuery.of(context).size.width / 100;
    double unitheight = MediaQuery.of(context).size.height / 100;
    return Container(
        color: Colors.grey[900],
        height: unitheight * 87,
        child: ListView(
          //shrinkWrap: true,
          children: [
            Container(
                width: unitwidth * 100,
                height: unitheight * 7,
                child: TabBar(
                  automaticIndicatorColorAdjustment: false,
                  tabs: [
                    Tab(
                      child: Text(
                        "Profile",
                        style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontWeight: FontWeight.w600,
                                fontSize: unitwidth * 1 * 3.5)),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Pdf",
                        style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontWeight: FontWeight.w600,
                                fontSize: unitwidth * 1 * 3.5)),
                      ),
                    ),
                  ],
                  controller: tabController,
                  onTap: _onItemTapped,
                  indicatorColor: Colors.blue,
                  indicatorWeight: unitwidth * 0.5,
                )),
            if (tabIndex == 0)
              Column(
                children: [
                  Column(children: [
                    // Stack(children: [
                    //   Container(width: unitwidth*50,color: Colors.white,)
                    // ]),

                    Container(
                      width: unitwidth * 100,
                      height: unitheight * 75,
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          FutureBuilder(
                              future: getProfile(),
                              builder: (context, snapshot) {
                                var value = snapshot.data;
                                if (!snapshot.hasData) {
                                  return const CircularProgressIndicator();
                                } else {
                                  if (value!["res"] == "true" && !editProfile) {
                                    profileRes = snapshot.data;
                                    return Column(
                                      children: [
                                        SizedBox(
                                          height: unitheight * 2,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            MaterialButton(
                                              onPressed: () {
                                                pickLogo();
                                              },
                                              child: Container(
                                                  width: unitwidth * 26,
                                                  height: unitheight * 15,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius
                                                          .all(Radius.circular(
                                                              unitwidth * 3))),
                                                  child: Column(
                                                    children: [
                                                      FutureBuilder(
                                                        future: getImage(logo),
                                                        builder: (context,
                                                            snapshot) {
                                                          if (!snapshot
                                                              .hasData) {
                                                            return const CircularProgressIndicator();
                                                          } else {
                                                            return Column(
                                                              children: [
                                                                Container(
                                                                  width:
                                                                      unitwidth *
                                                                          26,
                                                                  height:
                                                                      unitheight *
                                                                          1.5,
                                                                  alignment:
                                                                      Alignment
                                                                          .centerRight,
                                                                  child:
                                                                      const Icon(
                                                                    Icons
                                                                        .edit_rounded,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                                Container(
                                                                  width:
                                                                      unitwidth *
                                                                          26,
                                                                  height:
                                                                      unitheight *
                                                                          9,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: (snapshot
                                                                              .data !=
                                                                          null)
                                                                      ? snapshot
                                                                          .data
                                                                      : AutoSizeText(
                                                                          "Add Logo",
                                                                          style:
                                                                              GoogleFonts.montserrat(textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: unitwidth * 1 * 3)),
                                                                        ),
                                                                )
                                                              ],
                                                            );
                                                          }
                                                        },
                                                      )
                                                    ],
                                                  )),
                                            ),
                                            Column(
                                              children: [
                                                Container(
                                                    width: unitwidth * 50,
                                                    height: unitheight * 3,
                                                    alignment: Alignment.center,
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width: unitwidth * 40,
                                                          height:
                                                              unitheight * 3,
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: AutoSizeText(
                                                            "${value["data"]["name"]}",
                                                            style: GoogleFonts.montserrat(
                                                                textStyle: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        unitwidth *
                                                                            1 *
                                                                            5)),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: unitwidth * 8,
                                                          height: unitwidth * 8,
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius: BorderRadius.all(
                                                                  Radius.circular(
                                                                      unitwidth *
                                                                          2))),
                                                          alignment:
                                                              Alignment.center,
                                                          child: MaterialButton(
                                                              onPressed: () {
                                                                setState(() {
                                                                  editProfileOn();
                                                                });
                                                              },
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              child: const Icon(
                                                                Icons.edit,
                                                                color: Colors
                                                                    .black,
                                                              )),
                                                        ),
                                                      ],
                                                    )),
                                                Container(
                                                  width: unitwidth * 50,
                                                  height: unitheight * 3,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: AutoSizeText(
                                                    "+91-${value["data"]["phoneNo"]}",
                                                    style: GoogleFonts.montserrat(
                                                        textStyle: TextStyle(
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.8),
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize:
                                                                unitwidth *
                                                                    1 *
                                                                    3.5)),
                                                  ),
                                                ),
                                                Container(
                                                  width: unitwidth * 50,
                                                  height: unitheight * 3,
                                                  alignment: Alignment.topLeft,
                                                  child: AutoSizeText(
                                                    "${value["data"]["email"]}",
                                                    style: GoogleFonts.montserrat(
                                                        textStyle: TextStyle(
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.8),
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize:
                                                                unitwidth *
                                                                    1 *
                                                                    3.5)),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: unitheight * 1,
                                        ),
                                        Divider(
                                            color:
                                                Colors.white.withOpacity(0.3),
                                            height: unitwidth * 0.1),
                                        SizedBox(
                                          height: unitheight * 1,
                                        ),
                                        //Divider(color: Colors.white , height: unitwidth*2),

                                        addDetails(
                                            "Business Address",
                                            value["data"]["businessAddress"],
                                            unitwidth,
                                            unitheight),
                                        addDetails(
                                            "GSTIN",
                                            value["data"]["gstin"],
                                            unitwidth,
                                            unitheight),
                                        addDetails(
                                            "Udyog Registration No.",
                                            value["data"]["udyogRegistration"],
                                            unitwidth,
                                            unitheight),
                                        addDetails(
                                            "Business Description",
                                            value["data"]["businessDes"],
                                            unitwidth,
                                            unitheight),
                                        addDetails(
                                            "State ",
                                            value["data"]["state"],
                                            unitwidth,
                                            unitheight),
                                        addDetails(
                                            "Business Type",
                                            value["data"]["businessType"],
                                            unitwidth,
                                            unitheight),

                                        SizedBox(
                                          height: unitheight * 2,
                                        ),

                                        FutureBuilder(
                                            future: getImage(signature),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData) {
                                                return const CircularProgressIndicator();
                                              } else {
                                                return MaterialButton(
                                                  onPressed: () {
                                                    pickSignature();
                                                  },
                                                  child: (snapshot.data == null)
                                                      ? Container(
                                                          width:
                                                              unitwidth * 100,
                                                          height:
                                                              unitheight * 20,
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      unitwidth *
                                                                          3),
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: Colors
                                                                      .white
                                                                      .withOpacity(
                                                                          0.8),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .all(
                                                                    Radius.circular(
                                                                        unitwidth *
                                                                            3),
                                                                  )),
                                                          alignment:
                                                              Alignment.center,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  const Icon(Icons
                                                                      .create),
                                                                  AutoSizeText(
                                                                    "Add Signature",
                                                                    style: GoogleFonts.montserrat(
                                                                        textStyle: TextStyle(
                                                                            color: Colors.black.withOpacity(
                                                                                0.8),
                                                                            fontWeight: FontWeight
                                                                                .w600,
                                                                            fontSize: unitwidth *
                                                                                1 *
                                                                                3.5)),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height:
                                                                    unitwidth *
                                                                        2,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  const Icon(Icons
                                                                      .image),
                                                                  AutoSizeText(
                                                                    "Upload",
                                                                    style: GoogleFonts.montserrat(
                                                                        textStyle: TextStyle(
                                                                            color: Colors.black.withOpacity(
                                                                                0.8),
                                                                            fontWeight: FontWeight
                                                                                .w600,
                                                                            fontSize: unitwidth *
                                                                                1 *
                                                                                3.5)),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      : Container(
                                                          width:
                                                              unitwidth * 100,
                                                          height:
                                                              unitheight * 20,
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      unitwidth *
                                                                          3),
                                                          child: snapshot.data,
                                                        ),
                                                );
                                              }
                                            }),

                                        SizedBox(
                                          height: unitheight * 4,
                                        )
                                      ],
                                    );
                                  } else if (snapshot.data["res"] == "false") {
                                    return Container(
                                        width: unitwidth * 100,
                                        height: unitheight * 75,
                                        alignment: Alignment.center,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            MaterialButton(
                                              onPressed: () {
                                                setState(() {
                                                  editProfile = true;
                                                });
                                              },
                                              padding: EdgeInsets.zero,
                                              child: Container(
                                                width: unitwidth * 25,
                                                height: unitheight * 5,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius
                                                        .all(Radius.circular(
                                                            unitwidth * 2))),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(
                                                      Icons.add,
                                                      color: Colors.black,
                                                    ),
                                                    AutoSizeText(
                                                      " Add",
                                                      style: GoogleFonts.montserrat(
                                                          textStyle: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize:
                                                                  unitwidth *
                                                                      1 *
                                                                      4)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ));
                                  } else {
                                    return Column(
                                      children: [
                                        Container(
                                          height: unitheight * 63,
                                          width: unitwidth * 100,
                                          //color: Colors.white,
                                          child: ListView(
                                            children: [
                                              Column(
                                                children: [
                                                  Container(
                                                    width: unitwidth * 100,
                                                    height: unitwidth * 20,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                unitwidth * 7,
                                                            vertical:
                                                                unitwidth * 2),
                                                    child: TextField(
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      maxLength: 30,
                                                      style: GoogleFonts.montserrat(
                                                          textStyle:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      18 * 1)),
                                                      decoration:
                                                          InputDecoration(
                                                        disabledBorder: const OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .white),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            4))),
                                                        focusedBorder: const OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .white),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            4))),
                                                        enabledBorder: const OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .white),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            4))),
                                                        hintText: 'Name',
                                                        hintStyle: GoogleFonts.montserrat(
                                                            textStyle: TextStyle(
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.6),
                                                                fontSize:
                                                                    unitwidth *
                                                                        1 *
                                                                        3)),
                                                        prefixIcon: Icon(
                                                            FontAwesomeIcons
                                                                .idCard,
                                                            color: Colors.white,
                                                            size:
                                                                unitwidth * 4),
                                                      ),
                                                      controller:
                                                          nameController,
                                                      keyboardType:
                                                          TextInputType.text,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: unitwidth * 100,
                                                    height: unitwidth * 20,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                unitwidth * 7,
                                                            vertical:
                                                                unitwidth * 2),
                                                    child: TextField(
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      maxLength: 30,
                                                      style: GoogleFonts.montserrat(
                                                          textStyle:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      18 * 1)),
                                                      decoration:
                                                          InputDecoration(
                                                        disabledBorder: const OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .white),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            4))),
                                                        focusedBorder: const OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .white),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            4))),
                                                        enabledBorder: const OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .white),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            4))),
                                                        hintText: 'PhoneNo',
                                                        hintStyle: GoogleFonts.montserrat(
                                                            textStyle: TextStyle(
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.6),
                                                                fontSize:
                                                                    unitwidth *
                                                                        1 *
                                                                        3)),
                                                        prefixIcon: Icon(
                                                            FontAwesomeIcons
                                                                .phone,
                                                            color: Colors.white,
                                                            size:
                                                                unitwidth * 4),
                                                      ),
                                                      controller:
                                                          phoneNoController,
                                                      keyboardType:
                                                          TextInputType.number,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: unitwidth * 100,
                                                    height: unitwidth * 20,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                unitwidth * 7,
                                                            vertical:
                                                                unitwidth * 2),
                                                    child: TextField(
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      maxLength: 30,
                                                      style: GoogleFonts.montserrat(
                                                          textStyle:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      18 * 1)),
                                                      decoration:
                                                          InputDecoration(
                                                        disabledBorder: const OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .white),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            4))),
                                                        focusedBorder: const OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .white),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            4))),
                                                        enabledBorder: const OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .white),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            4))),
                                                        hintText: 'Email',
                                                        hintStyle: GoogleFonts.montserrat(
                                                            textStyle: TextStyle(
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.6),
                                                                fontSize:
                                                                    unitwidth *
                                                                        1 *
                                                                        3)),
                                                        prefixIcon: Icon(
                                                            FontAwesomeIcons
                                                                .mailBulk,
                                                            color: Colors.white,
                                                            size:
                                                                unitwidth * 4),
                                                      ),
                                                      controller:
                                                          emailController,
                                                      keyboardType:
                                                          TextInputType
                                                              .emailAddress,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: unitwidth * 100,
                                                    height: unitwidth * 20,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                unitwidth * 7,
                                                            vertical:
                                                                unitwidth * 2),
                                                    child: TextField(
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      maxLength: 30,
                                                      style: GoogleFonts.montserrat(
                                                          textStyle:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      18 * 1)),
                                                      decoration:
                                                          InputDecoration(
                                                        disabledBorder: const OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .white),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            4))),
                                                        focusedBorder: const OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .white),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            4))),
                                                        enabledBorder: const OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .white),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            4))),
                                                        hintText:
                                                            'Business Address',
                                                        hintStyle: GoogleFonts.montserrat(
                                                            textStyle: TextStyle(
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.6),
                                                                fontSize:
                                                                    unitwidth *
                                                                        1 *
                                                                        3)),
                                                        prefixIcon: Icon(
                                                            FontAwesomeIcons
                                                                .addressBook,
                                                            color: Colors.white,
                                                            size:
                                                                unitwidth * 4),
                                                      ),
                                                      controller:
                                                          addressController,
                                                      keyboardType:
                                                          TextInputType.text,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: unitwidth * 100,
                                                    height: unitwidth * 20,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                unitwidth * 7,
                                                            vertical:
                                                                unitwidth * 2),
                                                    child: TextField(
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      maxLength: 30,
                                                      style: GoogleFonts.montserrat(
                                                          textStyle:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      18 * 1)),
                                                      decoration:
                                                          InputDecoration(
                                                        disabledBorder: const OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .white),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            4))),
                                                        focusedBorder: const OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .white),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            4))),
                                                        enabledBorder: const OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .white),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            4))),
                                                        hintText: 'GSTIN',
                                                        hintStyle: GoogleFonts.montserrat(
                                                            textStyle: TextStyle(
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.6),
                                                                fontSize:
                                                                    unitwidth *
                                                                        1 *
                                                                        3)),
                                                        prefixIcon: Icon(
                                                            FontAwesomeIcons
                                                                .servicestack,
                                                            color: Colors.white,
                                                            size:
                                                                unitwidth * 4),
                                                      ),
                                                      controller:
                                                          gstinController,
                                                      keyboardType:
                                                          TextInputType.text,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: unitwidth * 100,
                                                    height: unitwidth * 20,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                unitwidth * 7,
                                                            vertical:
                                                                unitwidth * 2),
                                                    child: TextField(
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      maxLength: 30,
                                                      style: GoogleFonts.montserrat(
                                                          textStyle:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      18 * 1)),
                                                      decoration:
                                                          InputDecoration(
                                                        disabledBorder: const OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .white),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            4))),
                                                        focusedBorder: const OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .white),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            4))),
                                                        enabledBorder: const OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .white),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            4))),
                                                        hintText:
                                                            'Udyog Registation No',
                                                        hintStyle: GoogleFonts.montserrat(
                                                            textStyle: TextStyle(
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.6),
                                                                fontSize:
                                                                    unitwidth *
                                                                        1 *
                                                                        3)),
                                                        prefixIcon: Icon(
                                                            FontAwesomeIcons
                                                                .industry,
                                                            color: Colors.white,
                                                            size:
                                                                unitwidth * 4),
                                                      ),
                                                      controller:
                                                          udyogRegController,
                                                      keyboardType:
                                                          TextInputType.text,
                                                    ),
                                                  ),
                                                  Container(
                                                      width: unitwidth * 100,
                                                      height: unitwidth * 10,
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  unitwidth * 7,
                                                              vertical:
                                                                  unitwidth *
                                                                      2),
                                                      color: Colors.white,
                                                      alignment:
                                                          Alignment.center,
                                                      child: DropdownButton(
                                                        dropdownColor:
                                                            Colors.white,
                                                        menuMaxHeight:
                                                            unitwidth * 20,
                                                        items: [
                                                          DropdownMenuItem(
                                                              child:
                                                                  AutoSizeText(
                                                            "Uttrakhand",
                                                            style: GoogleFonts.montserrat(
                                                                textStyle: TextStyle(
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.8),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        unitwidth *
                                                                            1 *
                                                                            3.5)),
                                                          ))
                                                        ],
                                                        hint: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            AutoSizeText(
                                                              "Select State",
                                                              style: GoogleFonts.montserrat(
                                                                  textStyle: TextStyle(
                                                                      color: Colors
                                                                          .white
                                                                          .withOpacity(
                                                                              0.8),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          unitwidth *
                                                                              1 *
                                                                              3.5)),
                                                            )
                                                          ],
                                                        ),
                                                        onChanged: (value) {},
                                                      )),
                                                  Container(
                                                    width: unitwidth * 100,
                                                    height: unitwidth * 20,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                unitwidth * 7,
                                                            vertical:
                                                                unitwidth * 2),
                                                    child: TextField(
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      maxLength: 30,
                                                      style: GoogleFonts.montserrat(
                                                          textStyle:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      18 * 1)),
                                                      decoration:
                                                          InputDecoration(
                                                        disabledBorder: const OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .white),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            4))),
                                                        focusedBorder: const OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .white),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            4))),
                                                        enabledBorder: const OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .white),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            4))),
                                                        hintText: 'Description',
                                                        hintStyle: GoogleFonts.montserrat(
                                                            textStyle: TextStyle(
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.6),
                                                                fontSize:
                                                                    unitwidth *
                                                                        1 *
                                                                        3)),
                                                        prefixIcon: Icon(
                                                            FontAwesomeIcons
                                                                .idCard,
                                                            color: Colors.white,
                                                            size:
                                                                unitwidth * 4),
                                                      ),
                                                      controller:
                                                          descriptionController,
                                                      keyboardType:
                                                          TextInputType.text,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: unitwidth * 100,
                                                    height: unitwidth * 20,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                unitwidth * 7,
                                                            vertical:
                                                                unitwidth * 2),
                                                    child: TextField(
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      maxLength: 30,
                                                      style: GoogleFonts.montserrat(
                                                          textStyle:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      18 * 1)),
                                                      decoration:
                                                          InputDecoration(
                                                        disabledBorder: const OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .white),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            4))),
                                                        focusedBorder: const OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .white),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            4))),
                                                        enabledBorder: const OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .white),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            4))),
                                                        hintText: 'Type',
                                                        hintStyle: GoogleFonts.montserrat(
                                                            textStyle: TextStyle(
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.6),
                                                                fontSize:
                                                                    unitwidth *
                                                                        1 *
                                                                        3)),
                                                        prefixIcon: Icon(
                                                            FontAwesomeIcons
                                                                .idCard,
                                                            color: Colors.white,
                                                            size:
                                                                unitwidth * 4),
                                                      ),
                                                      controller:
                                                          typeController,
                                                      keyboardType:
                                                          TextInputType.text,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: unitwidth * 100,
                                                    height: unitwidth * 20,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                unitwidth * 7,
                                                            vertical:
                                                                unitwidth * 2),
                                                    child: TextField(
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      maxLength: 30,
                                                      style: GoogleFonts.montserrat(
                                                          textStyle:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      18 * 1)),
                                                      decoration:
                                                          InputDecoration(
                                                        disabledBorder: const OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .white),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            4))),
                                                        focusedBorder: const OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .white),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            4))),
                                                        enabledBorder: const OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .white),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            4))),
                                                        hintText: 'Category',
                                                        hintStyle: GoogleFonts.montserrat(
                                                            textStyle: TextStyle(
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0.6),
                                                                fontSize:
                                                                    unitwidth *
                                                                        1 *
                                                                        3)),
                                                        prefixIcon: Icon(
                                                            FontAwesomeIcons
                                                                .idCard,
                                                            color: Colors.white,
                                                            size:
                                                                unitwidth * 4),
                                                      ),
                                                      controller:
                                                          categoryController,
                                                      keyboardType:
                                                          TextInputType.text,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (editProfile)
                                          Container(
                                            width: unitwidth * 100,
                                            height: unitheight * 7,
                                            color: Colors.grey[900],
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                MaterialButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      editProfile = false;
                                                    });
                                                  },
                                                  child: Container(
                                                      width: unitwidth * 30,
                                                      height: unitheight * 7,
                                                      alignment:
                                                          Alignment.center,
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              vertical:
                                                                  unitheight *
                                                                      1.5),
                                                      decoration: BoxDecoration(
                                                          color: Colors.blue,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      unitwidth *
                                                                          4))),
                                                      child: AutoSizeText(
                                                        "Back",
                                                        style: GoogleFonts.montserrat(
                                                            textStyle: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize:
                                                                    unitwidth *
                                                                        1 *
                                                                        4)),
                                                      )),
                                                ),
                                                MaterialButton(
                                                  onPressed: () {
                                                    submitProfileInfo();
                                                  },
                                                  child: Container(
                                                      width: unitwidth * 30,
                                                      height: unitheight * 7,
                                                      alignment:
                                                          Alignment.center,
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              vertical:
                                                                  unitheight *
                                                                      1.5),
                                                      decoration: BoxDecoration(
                                                          color: Colors.blue,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      unitwidth *
                                                                          4))),
                                                      child: AutoSizeText(
                                                        "Submit",
                                                        style: GoogleFonts.montserrat(
                                                            textStyle: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize:
                                                                    unitwidth *
                                                                        1 *
                                                                        4)),
                                                      )),
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    );
                                  }
                                }
                              }),
                        ],
                      ),
                    ),
                  ])
                ],
              )
            else
              Column(
                children: [
                  Container(
                    width: unitwidth * 100,
                    height: unitheight * 10,
                    margin: EdgeInsets.symmetric(
                        vertical: unitheight * 2, horizontal: unitwidth * 4),
                    decoration: const BoxDecoration(
                        //color: Colors.white,
                        ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AutoSizeText(
                          "Candidate Pdf",
                          style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: unitwidth * 1 * 5)),
                          textScaleFactor: textscal,
                        ),
                        MaterialButton(
                          onPressed: () {
                            genratePdf();
                          },
                          child: Container(
                            width: unitwidth * 30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(unitwidth * 4))),
                            height: unitheight * 4,
                            child: AutoSizeText("Export",
                                style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: unitwidth * 1 * 4)),
                                textScaleFactor: textscal),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: unitwidth * 100,
                    height: unitheight * 25,
                    margin: EdgeInsets.symmetric(
                        vertical: unitheight * 2, horizontal: unitwidth * 4),
                    decoration: const BoxDecoration(
                        //color: Colors.white,
                        ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AutoSizeText(
                          "Fee Pdf",
                          style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: unitwidth * 1 * 5)),
                          textScaleFactor: textscal,
                        ),
                        Container(
                            width: unitwidth * 100,
                            height: unitwidth * 13,
                            color: Colors.grey[900],
                            margin: EdgeInsets.symmetric(
                                horizontal: unitwidth * 7,
                                vertical: unitwidth * 2),
                            child: Theme(
                                data: Theme.of(context).copyWith(
                                    unselectedWidgetColor: Colors.white,
                                    disabledColor: Colors.blue),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      children: [
                                        Radio(
                                            value: pdf.monthly,
                                            groupValue: feePdf,
                                            onChanged: (onChanged) {
                                              setState(() {
                                                //print("Radio 1" + onChanged!.toString());
                                                feePdf = onChanged!;
                                              });
                                            },
                                            activeColor: Colors.white),
                                        Text(
                                          "Monthly",
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
                                            value: pdf.yearly,
                                            groupValue: feePdf,
                                            onChanged: (onChanged) {
                                              setState(() {
                                                //print("Radio 1" + onChanged!.toString());
                                                feePdf = onChanged!;
                                              });
                                            },
                                            activeColor: Colors.white),
                                        Text(
                                          "Yearly",
                                          style: GoogleFonts.montserrat(
                                              textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: unitwidth * 1 * 3)),
                                        )
                                      ],
                                    ),
                                  ],
                                ))),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: unitwidth * 32,
                              height: unitheight * 5,
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Selected Date ",
                                    style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.7),
                                            fontWeight: FontWeight.w600,
                                            fontSize: unitwidth * 1 * 3.5)),
                                    textScaleFactor: textscal,
                                  ),
                                  Icon(
                                    Icons.calendar_month,
                                    color: Colors.white.withOpacity(0.7),
                                  )
                                ],
                              ),
                            ),
                            MaterialButton(
                                onPressed: () async {
                                  final selected = await showMonthYearPicker(
                                    context: context,
                                    initialMonthYearPickerMode:
                                        (feePdf == pdf.yearly)
                                            ? MonthYearPickerMode.year
                                            : MonthYearPickerMode.month,
                                    initialDate: feepdfDateTime,
                                    firstDate: DateTime(2019, 1),
                                    lastDate: DateTime.now(),
                                  );
                                  if (selected != null) {
                                    feepdfDateTime = selected;
                                  }

                                  setState(() {});
                                },
                                child: Container(
                                    width: unitwidth * 20,
                                    height: unitheight * 4,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(unitwidth * 1.5))),
                                    child: Text(
                                      "select date",
                                      style: GoogleFonts.montserrat(
                                          textStyle: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                              fontWeight: FontWeight.w600,
                                              fontSize: unitwidth * 1 * 3.5)),
                                      textScaleFactor: textscal,
                                    ))),
                            Container(
                              width: unitwidth * 25,
                              alignment: Alignment.center,
                              height: unitheight * 5,
                              child: AutoSizeText(
                                DateFormat("MMMM-yyyy").format(feepdfDateTime),
                                style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontWeight: FontWeight.w600,
                                        fontSize: unitwidth * 1 * 3.5)),
                                textScaleFactor: textscal,
                              ),
                            )
                          ],
                        ),
                        MaterialButton(
                          onPressed: () {
                            exportFeePdf();
                          },
                          child: Container(
                            width: unitwidth * 30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(unitwidth * 4))),
                            height: unitheight * 4,
                            child: AutoSizeText("Export",
                                style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: unitwidth * 1 * 4)),
                                textScaleFactor: textscal),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: unitwidth * 100,
                    height: unitheight * 25,
                    margin: EdgeInsets.symmetric(
                        vertical: unitheight * 2, horizontal: unitwidth * 4),
                    decoration: const BoxDecoration(
                        //color: Colors.white,
                        ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AutoSizeText(
                          "Attandance Pdf",
                          style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: unitwidth * 1 * 5)),
                          textScaleFactor: textscal,
                        ),
                        Container(
                            width: unitwidth * 100,
                            height: unitwidth * 13,
                            color: Colors.grey[900],
                            margin: EdgeInsets.symmetric(
                                horizontal: unitwidth * 7,
                                vertical: unitwidth * 2),
                            child: Theme(
                                data: Theme.of(context).copyWith(
                                    unselectedWidgetColor: Colors.white,
                                    disabledColor: Colors.blue),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
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
                                            value: pdf.monthly,
                                            groupValue: attandancePdf,
                                            onChanged: (onChanged) {
                                              setState(() {
                                                //print("Radio 1" + onChanged!.toString());
                                                feePdf = onChanged!;
                                              });
                                            },
                                            activeColor: Colors.white),
                                        Text(
                                          "Monthly",
                                          style: GoogleFonts.montserrat(
                                              textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: unitwidth * 1 * 3)),
                                        )
                                      ],
                                    ),
// Row(children: [
//   Radio(value: pdf.yearly, groupValue: attandancePdf, onChanged: (onChanged){
// setState(() {
//   //print("Radio 1" + onChanged!.toString());
//   feePdf = onChanged!;
// });
// } , activeColor: Colors.white),
// Text("Yearly" , style: GoogleFonts.montserrat(
//                                           textStyle: TextStyle(
//                                               color: Colors.white,
//                                               fontSize: unitwidth *
//                                                   1 *
//                                                   3)),)
// ],),
                                  ],
                                ))),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: unitwidth * 32,
                              height: unitheight * 5,
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Selected Date ",
                                    style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.7),
                                            fontWeight: FontWeight.w600,
                                            fontSize: unitwidth * 1 * 3.5)),
                                    textScaleFactor: textscal,
                                  ),
                                  Icon(
                                    Icons.calendar_month,
                                    color: Colors.white.withOpacity(0.7),
                                  )
                                ],
                              ),
                            ),
                            MaterialButton(
                                onPressed: () async {
                                  final selected = await showMonthYearPicker(
                                    context: context,
                                    initialMonthYearPickerMode:
                                        (attandancePdf == pdf.yearly)
                                            ? MonthYearPickerMode.year
                                            : MonthYearPickerMode.month,
                                    initialDate: attandancepdfDateTime,
                                    firstDate: DateTime(2019, 1),
                                    lastDate: DateTime.now(),
                                  );
                                  if (selected != null) {
                                    attandancepdfDateTime = selected;
                                  }

                                  setState(() {});
                                },
                                child: Container(
                                    width: unitwidth * 20,
                                    height: unitheight * 4,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(unitwidth * 1.5))),
                                    child: Text(
                                      "select date",
                                      style: GoogleFonts.montserrat(
                                          textStyle: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                              fontWeight: FontWeight.w600,
                                              fontSize: unitwidth * 1 * 3.5)),
                                      textScaleFactor: textscal,
                                    ))),
                            Container(
                              width: unitwidth * 25,
                              alignment: Alignment.center,
                              height: unitheight * 5,
                              child: AutoSizeText(
                                DateFormat("MMMM-yyyy")
                                    .format(attandancepdfDateTime),
                                style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontWeight: FontWeight.w600,
                                        fontSize: unitwidth * 1 * 3.5)),
                                textScaleFactor: textscal,
                              ),
                            )
                          ],
                        ),
                        MaterialButton(
                          onPressed: () {
                            exportAttandance();
                          },
                          child: Container(
                            width: unitwidth * 30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(unitwidth * 4))),
                            height: unitheight * 4,
                            child: AutoSizeText("Export",
                                style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: unitwidth * 1 * 4)),
                                textScaleFactor: textscal),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: unitwidth * 100,
                    height: unitheight * 29,
                    margin: EdgeInsets.symmetric(
                        vertical: unitheight * 2, horizontal: unitwidth * 4),
                    decoration: const BoxDecoration(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AutoSizeText(
                          "Expenses Pdf",
                          style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: unitwidth * 1 * 5)),
                          textScaleFactor: textscal,
                        ),
                        Container(
                            width: unitwidth * 100,
                            height: unitwidth * 10,
                            color: Colors.grey[900],
                            margin: EdgeInsets.symmetric(
                                horizontal: unitwidth * 7,
                                vertical: unitwidth * 2),
                            child: Theme(
                                data: Theme.of(context).copyWith(
                                    unselectedWidgetColor: Colors.white,
                                    disabledColor: Colors.blue),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      children: [
                                        Radio(
                                            value: pdf.monthly,
                                            groupValue: expensesPdf,
                                            onChanged: (onChanged) {
                                              setState(() {
                                                //print("Radio 1" + onChanged!.toString());
                                                expensesPdf = onChanged!;
                                              });
                                            },
                                            activeColor: Colors.white),
                                        Text(
                                          "Monthly",
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
                                            value: pdf.yearly,
                                            groupValue: expensesPdf,
                                            onChanged: (onChanged) {
                                              setState(() {
                                                //print("Radio 1" + onChanged!.toString());
                                                expensesPdf = onChanged!;
                                              });
                                            },
                                            activeColor: Colors.white),
                                        Text(
                                          "Yearly",
                                          style: GoogleFonts.montserrat(
                                              textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: unitwidth * 1 * 3)),
                                        )
                                      ],
                                    ),
                                  ],
                                ))),
                        if (expensesPdf == pdf.monthly)
                          Container(
                              width: unitwidth * 100,
                              height: unitwidth * 8,
                              color: Colors.grey[900],
                              margin: EdgeInsets.symmetric(
                                  horizontal: unitwidth * 0,
                                  vertical: unitwidth * 2),
                              child: Theme(
                                  data: Theme.of(context).copyWith(
                                      unselectedWidgetColor: Colors.white,
                                      disabledColor: Colors.blue),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Row(
                                        children: [
                                          Radio(
                                              value: expense.gym,
                                              groupValue: expenses,
                                              onChanged: (onChanged) {
                                                setState(() {
                                                  //print("Radio 1" + onChanged!.toString());
                                                  expenses = onChanged!;
                                                });
                                              },
                                              activeColor: Colors.white),
                                          Text(
                                            "Gym Expense",
                                            style: GoogleFonts.montserrat(
                                                textStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        unitwidth * 1 * 3)),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                              value: expense.other,
                                              groupValue: expenses,
                                              onChanged: (onChanged) {
                                                setState(() {
                                                  //print("Radio 1" + onChanged!.toString());
                                                  expenses = onChanged!;
                                                });
                                              },
                                              activeColor: Colors.white),
                                          Text(
                                            "Other Expense",
                                            style: GoogleFonts.montserrat(
                                                textStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        unitwidth * 1 * 3)),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                              value: expense.both,
                                              groupValue: expenses,
                                              onChanged: (onChanged) {
                                                setState(() {
                                                  //print("Radio 1" + onChanged!.toString());
                                                  expenses = onChanged!;
                                                });
                                              },
                                              activeColor: Colors.white),
                                          Text(
                                            "Both",
                                            style: GoogleFonts.montserrat(
                                                textStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        unitwidth * 1 * 3)),
                                          )
                                        ],
                                      ),
                                    ],
                                  ))),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: unitwidth * 32,
                              height: unitheight * 5,
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Selected Date ",
                                    style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.7),
                                            fontWeight: FontWeight.w600,
                                            fontSize: unitwidth * 1 * 3.5)),
                                    textScaleFactor: textscal,
                                  ),
                                  Icon(
                                    Icons.calendar_month,
                                    color: Colors.white.withOpacity(0.7),
                                  )
                                ],
                              ),
                            ),
                            MaterialButton(
                                onPressed: () async {
                                  final selected = await showMonthYearPicker(
                                    context: context,
                                    initialMonthYearPickerMode:
                                        (expensesPdf == pdf.yearly)
                                            ? MonthYearPickerMode.year
                                            : MonthYearPickerMode.month,
                                    initialDate: expensespdfDateTime,
                                    firstDate: DateTime(2019, 1),
                                    lastDate: DateTime.now(),
                                  );
                                  if (selected != null) {
                                    expensespdfDateTime = selected;
                                  }

                                  setState(() {});
                                },
                                child: Container(
                                    width: unitwidth * 20,
                                    height: unitheight * 4,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(unitwidth * 1.5))),
                                    child: Text(
                                      "select date",
                                      style: GoogleFonts.montserrat(
                                          textStyle: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                              fontWeight: FontWeight.w600,
                                              fontSize: unitwidth * 1 * 3.5)),
                                      textScaleFactor: textscal,
                                    ))),
                            Container(
                              width: unitwidth * 25,
                              alignment: Alignment.center,
                              height: unitheight * 5,
                              child: AutoSizeText(
                                DateFormat("MMMM-yyyy")
                                    .format(expensespdfDateTime),
                                style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontWeight: FontWeight.w600,
                                        fontSize: unitwidth * 1 * 3.5)),
                                textScaleFactor: textscal,
                              ),
                            )
                          ],
                        ),
                        MaterialButton(
                          onPressed: () {
                            exportExpensesPdf();
                          },
                          child: Container(
                            width: unitwidth * 30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(unitwidth * 4))),
                            height: unitheight * 4,
                            child: AutoSizeText("Export",
                                style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: unitwidth * 1 * 4)),
                                textScaleFactor: textscal),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: unitwidth * 100,
                    height: unitheight * 25,
                    margin: EdgeInsets.symmetric(
                        vertical: unitheight * 2, horizontal: unitwidth * 4),
                    decoration: const BoxDecoration(
                        //color: Colors.white,
                        ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AutoSizeText(
                          "Profit and Loss",
                          style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: unitwidth * 1 * 5)),
                          textScaleFactor: textscal,
                        ),

//              Container(width: unitwidth*100,height: unitwidth*13,color: Colors.grey[900], margin:EdgeInsets.symmetric(horizontal: unitwidth*7, vertical: unitwidth*2), child: Theme( data: Theme.of(context).copyWith(
//     unselectedWidgetColor: Colors.white,
//     disabledColor: Colors.blue),  child: Row(
//   mainAxisAlignment: MainAxisAlignment.spaceAround,
// children: [

// Row(children: [
//   Radio(value: pdf.monthly, groupValue: profitandloss, onChanged: (onChanged){
// setState(() {
//   //print("Radio 1" + onChanged!.toString());
//   feePdf = onChanged!;
// });
// } , activeColor: Colors.white),
// Text("Monthly" , style: GoogleFonts.montserrat(
//                                           textStyle: TextStyle(
//                                               color: Colors.white,
//                                               fontSize: unitwidth *
//                                                   1 *
//                                                   3)),)
// ],),
// Row(children: [
//   Radio(value: pdf.yearly, groupValue: profitandloss, onChanged: (onChanged){
// setState(() {
//   //print("Radio 1" + onChanged!.toString());
//   feePdf = onChanged!;
// });
// } , activeColor: Colors.white),
// Text("Yearly" , style: GoogleFonts.montserrat(
//                                           textStyle: TextStyle(
//                                               color: Colors.white,
//                                               fontSize: unitwidth *
//                                                   1 *
//                                                   3)),)
// ],),

// ],

// ))),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: unitwidth * 32,
                              height: unitheight * 5,
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Selected Date ",
                                    style: GoogleFonts.montserrat(
                                        textStyle: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.7),
                                            fontWeight: FontWeight.w600,
                                            fontSize: unitwidth * 1 * 3.5)),
                                    textScaleFactor: textscal,
                                  ),
                                  Icon(
                                    Icons.calendar_month,
                                    color: Colors.white.withOpacity(0.7),
                                  )
                                ],
                              ),
                            ),
                            MaterialButton(
                                onPressed: () async {
                                  final selected = await showMonthYearPicker(
                                    context: context,
                                    initialMonthYearPickerMode:
                                        MonthYearPickerMode.year,
                                    initialDate: profitandlossDateTime,
                                    firstDate: DateTime(2019, 1),
                                    lastDate: DateTime.now(),
                                  );
                                  if (selected != null) {
                                    profitandlossDateTime = selected;
                                  }

                                  setState(() {});
                                },
                                child: Container(
                                    width: unitwidth * 20,
                                    height: unitheight * 4,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(unitwidth * 1.5))),
                                    child: Text(
                                      "select date",
                                      style: GoogleFonts.montserrat(
                                          textStyle: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                              fontWeight: FontWeight.w600,
                                              fontSize: unitwidth * 1 * 3.5)),
                                      textScaleFactor: textscal,
                                    ))),
                            Container(
                              width: unitwidth * 25,
                              alignment: Alignment.center,
                              height: unitheight * 5,
                              child: AutoSizeText(
                                DateFormat("MMMM-yyyy")
                                    .format(profitandlossDateTime),
                                style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontWeight: FontWeight.w600,
                                        fontSize: unitwidth * 1 * 3.5)),
                                textScaleFactor: textscal,
                              ),
                            )
                          ],
                        ),

                        MaterialButton(
                          onPressed: () {
                            exportProfitandlossPdf();
                          },
                          child: Container(
                            width: unitwidth * 30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(unitwidth * 4))),
                            height: unitheight * 4,
                            child: AutoSizeText("Export",
                                style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: unitwidth * 1 * 4)),
                                textScaleFactor: textscal),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )
          ],
        ));
  }

  _onItemTapped(int index) {
    setState(() {
      tabIndex = index;
    });
  }

  pickLogo() async {
    try {
      var img = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (img == null) {
        return null;
      }

      var lo = File(img.path);
      storeImage(logo, lo);
      setState(() {});
    } on PlatformException catch (e) {}
  }

  pickSignature() async {
    try {
      var img = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (img == null) {
        return null;
      }

      var imageTemp = File(img.path);
      storeImage(signature, imageTemp);
      setState(() {});
    } on PlatformException catch (e) {}
  }

  storeImage(String key, File file) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String img = base64Encode(file.readAsBytesSync());
    preferences.setString(key, img);
  }

  Future<Image> getImage(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    if (preferences.containsKey(key)) {
      String? fi = await preferences.getString(key);
      Image img = Image.memory(base64Decode(fi!));
      return img;
    }
    return Image.asset("assets/images/noImage.png");
  }

  Future<dynamic> getProfile() async {
    var res = await Services().getProfile();
    if (editProfile && res["res"] == "false") {
      return {res: "true"};
    }
    return res;
  }

  submitProfileInfo() async {
    String name = nameController.text;
    String phoneNo = phoneNoController.text;
    String email = emailController.text;
    String busAddress = addressController.text;
    String gstin = gstinController.text;
    String udyog = udyogRegController.text;
    String state = "Uttrakhand";
    String busDes = descriptionController.text;
    String type = typeController.text;
    String category = categoryController.text;

    var res = await Services().editUserProfile(name, phoneNo, email, busAddress,
        gstin, udyog, busDes, state, type, category);
    setState(() {
      editProfile = false;
    });
  }

  addDetails(String title, String des, double unitwidth, double unitheight) {
    return Container(
        width: unitwidth * 100,
        height: unitheight * 9,
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(vertical: unitheight * 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: unitheight * 1,
            ),
            Container(
              width: unitwidth * 100,
              height: unitheight * 3,
              margin: EdgeInsets.symmetric(horizontal: unitwidth * 10),
              alignment: Alignment.topLeft,
              child: AutoSizeText(
                title,
                style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: unitwidth * 1 * 5)),
              ),
            ),
            SizedBox(
              height: unitheight * 0.3,
            ),
            Container(
              width: unitwidth * 100,
              height: unitheight * 3,
              margin: EdgeInsets.symmetric(horizontal: unitwidth * 10),
              alignment: Alignment.topLeft,
              child: AutoSizeText(
                des,
                style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.w600,
                        fontSize: unitwidth * 1 * 3.5)),
              ),
            ),
            SizedBox(
              height: unitheight * 1,
            ),
            Divider(
                color: Colors.white.withOpacity(0.3), height: unitwidth * 0.1),
          ],
        ));
  }

  genratePdf() async {
    // File pdffile = await pd
    List<UserModel> allUser = await Services().getAllUser();
    if (allUser.length != 0) {
      allUser.sort((a, b) {
        int aDT = a.registrationNo!;
        int bDT = b.registrationNo!;

        return aDT.compareTo(bDT);
      });
      var p = await getProfile();
      File pdffile = await PdfApis.candidatePdf(allUser, p);

      PdfApis.openFile(pdffile);
    }
  }

  exportProfitandlossPdf() async {
    DateTime time = profitandlossDateTime;
    var data;

    data =
        await Services().getProfitLossPdfData(profitandlossDateTime.toString());
    // if(feePdf == pdf.monthly){
    //  data = await Services().getMonthlyFees(time.toString());
    // }else{
    //  data = await Services().getYearlyFees(time.toString());
    // }

    // if(data == null || data.length == 0){
    //   Fluttertoast.showToast(msg: "No Data Found" , backgroundColor: Colors.white,toastLength: Toast.LENGTH_LONG);
    // }else{
    //  data.sort((a, b){
    //   DateTime aDT = DateTime.parse(a["date"]);
    //   DateTime bDT = DateTime.parse(b["date"]);

    //   return aDT.compareTo(bDT);
    //  });
    print("Profit Loss " + data.toString());
    var p = await getProfile();
    File pdffile = await PdfApis.profitandlossPdf(
        data, profitandlossDateTime, pdf.yearly, p);

    PdfApis.openFile(pdffile);
  }

  exportFeePdf() async {
    DateTime time = feepdfDateTime;
    List<dynamic> data;
    if (feePdf == pdf.monthly) {
      data = await Services().getMonthlyFees(time.toString());
    } else {
      data = await Services().getYearlyFees(time.toString());
    }

    if (data == null || data.length == 0) {
      Fluttertoast.showToast(
          msg: "No Data Found",
          backgroundColor: Colors.white,
          toastLength: Toast.LENGTH_LONG);
    } else {
      data.sort((a, b) {
        DateTime aDT = DateTime.parse(a["date"]);
        DateTime bDT = DateTime.parse(b["date"]);

        return aDT.compareTo(bDT);
      });
      var p = await getProfile();
      File pdffile = await PdfApis.userFeePdf(
          data, DateFormat("MMMM").format(time), feePdf, p, time);

      PdfApis.openFile(pdffile);
    }
  }

  exportExpensesPdf() async {
    var data = await Services().getExpensesForPdf(
        expensespdfDateTime.toString(), expensesPdf, expenses);
    print("Expenses pdf data " + data.toString());

    if (data.length == 0) {
      Fluttertoast.showToast(
          msg: "No Data Found",
          backgroundColor: Colors.white,
          toastLength: Toast.LENGTH_LONG);
    } else {
      data.sort((a, b) {
        DateTime aDT = DateTime.parse(a["date"]);
        DateTime bDT = DateTime.parse(b["date"]);

        return aDT.compareTo(bDT);
      });
      var p = await getProfile();
      File pdffile = await PdfApis.expensesPdf(
          data, expensespdfDateTime, expensesPdf, p, expenses);

      PdfApis.openFile(pdffile);
    }
  }

  exportAttandance() async {
    var data;
    data =
        await Services().getUserAttandancepdf(attandancepdfDateTime.toString());
    // print("Attandance pdf data "+ data.toString());

    if (data.length == 0) {
      Fluttertoast.showToast(
          msg: "No Data Found",
          backgroundColor: Colors.white,
          toastLength: Toast.LENGTH_LONG);
    }

    var p = await getProfile();

    //print("Profile "+ p.toString());
    File pdffile = await PdfApis.attandancePdf(
        data, attandancepdfDateTime, attandancePdf, p);

    PdfApis.openFile(pdffile);
  }

  editProfileOn() {
    editProfile = true;
    if (profileRes["res"] == "true") {
      var data = profileRes["data"];
      nameController.text = data["name"];
      phoneNoController.text = data["phoneNo"];
      emailController.text = data["email"];
      addressController.text = data["businessAddress"];
      gstinController.text = data["gstin"];
      udyogRegController.text = data["udyogRegistration"];
      descriptionController.text = data["businessDes"];
      typeController.text = data["businessType"];
      categoryController.text = data["businessCategory"];
    }

    setState(() {});
  }
}
