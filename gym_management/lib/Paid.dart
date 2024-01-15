import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_management/AddUser/createUser.dart';
import 'package:gym_management/DTO/User.dart';
import 'package:gym_management/Server/Services.dart';
import 'package:gym_management/globalData.dart';
import 'package:intl/intl.dart';

class PaidForFee extends StatefulWidget {
  UserModel user;
  PaidForFee({super.key, required this.user});

  @override
  State<PaidForFee> createState() => _PaidForFeeState();
}

class _PaidForFeeState extends State<PaidForFee> {
  bool waitingForResponse = false;
  TextEditingController registration_Fees_Controller = TextEditingController();
  //  TextEditingController annual_Fees_Controller = TextEditingController();
  TextEditingController monthly_Fees_Controller = TextEditingController();
  TextEditingController trademil_Fees_Controller = TextEditingController();
  TextEditingController lights_Fees_Controller = TextEditingController();
  TextEditingController personal_Fees_Controller = TextEditingController();
  TextEditingController other_Fees_Controller = TextEditingController();
  TextEditingController fees_note_Controller = TextEditingController();
  paymentMode mode = paymentMode.online;
  String joiningDateShow = "00-00-0000";
  DateTime? joiningDate = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double unitwidth = MediaQuery.of(context).size.width / 100;
    double unitheight = MediaQuery.of(context).size.height / 100;
    return Scaffold(
        appBar: AppBar(title: Text("Pay Fee")),
        body: Container(
          color: Colors.grey[900],
          child: ListView(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [

                Container(
                  width: unitwidth * 100,
                  height: unitheight * 15,
                  child: Column(
                    children: [
                      SizedBox(
                        height: unitwidth * 4,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: unitwidth * 7,
                          ),
                          Text(
                            "Registration Fee",
                            style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: unitwidth * 1 * 4)),
                          ),
                        ],
                      ),
                      //SizedBox(height: unitheight*,),
                      Container(
                        width: unitwidth * 100,
                        height: unitwidth * 20,
                        margin: EdgeInsets.symmetric(
                            horizontal: unitwidth * 7, vertical: unitwidth * 2),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: Colors.white, fontSize: 18 * 1)),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4))),
                            hintText: 'Registration Fee',
                            hintStyle: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: unitwidth * 1 * 3)),
                            prefixIcon: Icon(
                              FontAwesomeIcons.rupeeSign,
                              size: unitwidth * 4,
                              color: Colors.blue,
                            ),
                          ),
                          controller: registration_Fees_Controller,
                          autovalidateMode: AutovalidateMode.always,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter Registration charges";
                            } else {
                              return "";
                            }
                          },
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ),

//          Container(width: unitwidth*50,height: unitheight*15,
//         child: Column(children: [
//                     SizedBox(height: unitwidth*4,),
//          Row(children: [
//           SizedBox(width: unitwidth*7,),
//            Text("Annual Fee" ,style: GoogleFonts.montserrat(
//                                           textStyle: TextStyle(
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.w600,
//                                               fontSize: unitwidth *
//                                                   1 *
//                                                   4)),),
//          ],),
//                                                   //SizedBox(height: unitheight*,),
//       Container(width: unitwidth*50,height: unitwidth*20, margin:EdgeInsets.symmetric(horizontal: unitwidth*7, vertical: unitwidth*2),child: TextFormField(
//       textInputAction: TextInputAction.next,

//       style: GoogleFonts.montserrat(
//       textStyle: TextStyle(
//        color: Colors.black,
//         fontSize: 18 * 1)),
//   decoration:InputDecoration(
//      border: OutlineInputBorder(
//      borderRadius: BorderRadius.all(
//      Radius.circular(4))),
//     hintText: 'Annual Fee',

//     hintStyle: GoogleFonts.montserrat(
//                                           textStyle: TextStyle(
//                                               color: Colors.black,
//                                               fontSize: unitwidth *
//                                                   1 *
//                                                   3)),
//                                                   prefixIcon:  Icon(FontAwesomeIcons.rupeeSign , size:unitwidth* 4, color: Colors.blue,),

//   ),controller: registration_Fees_Controller,
//     autovalidateMode: AutovalidateMode.always, validator: (value) {
//     if(value == null|| value.isEmpty){
// return "Please enter Annual fee";
//     }else{
//       return "";
//     }
//   },
//   keyboardType: TextInputType.number,
// ),),
//         ],),
//         ),

//           ]),
//if(widget.user.monthlyFee! != 0)
                Container(
                  width: unitwidth * 100,
                  height: unitheight * 15,
                  child: Column(
                    children: [
                      SizedBox(
                        height: unitwidth * 4,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: unitwidth * 7,
                          ),
                          Text(
                            "Monthly Fee",
                            style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: unitwidth * 1 * 4)),
                          ),
                        ],
                      ),
                      //SizedBox(height: unitheight*,),
                      Container(
                        width: unitwidth * 100,
                        height: unitwidth * 20,
                        margin: EdgeInsets.symmetric(
                            horizontal: unitwidth * 7, vertical: unitwidth * 2),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: Colors.white, fontSize: 18 * 1)),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4))),
                            hintText: 'Monthly Fee',
                            hintStyle: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: unitwidth * 1 * 3)),
                            prefixIcon: Icon(
                              FontAwesomeIcons.rupeeSign,
                              size: unitwidth * 4,
                              color: Colors.blue,
                            ),
                          ),
                          controller: monthly_Fees_Controller,
                          autovalidateMode: AutovalidateMode.always,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter Registration charges";
                            } else {
                              return "";
                            }
                          },
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ),
                // if(widget.user.trademilFee! != 0)
                Container(
                  width: unitwidth * 100,
                  height: unitheight * 15,
                  child: Column(
                    children: [
                      SizedBox(
                        height: unitwidth * 4,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: unitwidth * 7,
                          ),
                          Text(
                            "Trademil Fee",
                            style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: unitwidth * 1 * 4)),
                          ),
                        ],
                      ),
                      //SizedBox(height: unitheight*,),
                      Container(
                        width: unitwidth * 100,
                        height: unitwidth * 20,
                        margin: EdgeInsets.symmetric(
                            horizontal: unitwidth * 7, vertical: unitwidth * 2),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: Colors.white, fontSize: 18 * 1)),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4))),
                            hintText: 'Trademil Fee',
                            hintStyle: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: unitwidth * 1 * 3)),
                            prefixIcon: Icon(
                              FontAwesomeIcons.rupeeSign,
                              size: unitwidth * 4,
                              color: Colors.blue,
                            ),
                          ),
                          controller: trademil_Fees_Controller,
                          autovalidateMode: AutovalidateMode.always,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter Trademil Fee";
                            } else {
                              return "";
                            }
                          },
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ),
//if(widget.user.lightsChargesFee! != 0)
                Container(
                  width: unitwidth * 100,
                  height: unitheight * 15,
                  child: Column(
                    children: [
                      SizedBox(
                        height: unitwidth * 4,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: unitwidth * 7,
                          ),
                          Text(
                            "Lights Charges",
                            style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: unitwidth * 1 * 4)),
                          ),
                        ],
                      ),
                      //SizedBox(height: unitheight*,),
                      Container(
                        width: unitwidth * 100,
                        height: unitwidth * 20,
                        margin: EdgeInsets.symmetric(
                            horizontal: unitwidth * 7, vertical: unitwidth * 2),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: Colors.white, fontSize: 18 * 1)),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4))),
                            hintText: 'Lights Charges',
                            hintStyle: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: unitwidth * 1 * 3)),
                            prefixIcon: Icon(
                              FontAwesomeIcons.rupeeSign,
                              size: unitwidth * 4,
                              color: Colors.blue,
                            ),
                          ),
                          controller: lights_Fees_Controller,
                          autovalidateMode: AutovalidateMode.always,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter Lights Charges";
                            } else {
                              return "";
                            }
                          },
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ),

                // if(widget.user.personalTrainingFee! != 0)
                Container(
                  width: unitwidth * 100,
                  height: unitheight * 15,
                  child: Column(
                    children: [
                      SizedBox(
                        height: unitwidth * 4,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: unitwidth * 7,
                          ),
                          Text(
                            "Personal Training Fee",
                            style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: unitwidth * 1 * 4)),
                          ),
                        ],
                      ),
                      //SizedBox(height: unitheight*,),
                      Container(
                        width: unitwidth * 100,
                        height: unitwidth * 20,
                        margin: EdgeInsets.symmetric(
                            horizontal: unitwidth * 7, vertical: unitwidth * 2),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: Colors.white, fontSize: 18 * 1)),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4))),
                            hintText: 'Personal Training Fee',
                            hintStyle: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: unitwidth * 1 * 3)),
                            prefixIcon: Icon(
                              FontAwesomeIcons.rupeeSign,
                              size: unitwidth * 4,
                              color: Colors.blue,
                            ),
                          ),
                          controller: personal_Fees_Controller,
                          autovalidateMode: AutovalidateMode.always,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter Personal Training Fee";
                            } else {
                              return "";
                            }
                          },
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  width: unitwidth * 100,
                  height: unitheight * 15,
                  child: Column(
                    children: [
                      SizedBox(
                        height: unitwidth * 4,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: unitwidth * 7,
                          ),
                          Text(
                            "Other Fee",
                            style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: unitwidth * 1 * 4)),
                          ),
                        ],
                      ),
                      //SizedBox(height: unitheight*,),
                      Container(
                        width: unitwidth * 100,
                        height: unitwidth * 20,
                        margin: EdgeInsets.symmetric(
                            horizontal: unitwidth * 7, vertical: unitwidth * 2),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: Colors.white, fontSize: 18 * 1)),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4))),
                            hintText: 'Other Fee',
                            hintStyle: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: unitwidth * 1 * 3)),
                            prefixIcon: Icon(
                              FontAwesomeIcons.rupeeSign,
                              size: unitwidth * 4,
                              color: Colors.blue,
                            ),
                          ),
                          controller: other_Fees_Controller,
                          autovalidateMode: AutovalidateMode.always,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter Other  Fee";
                            } else {
                              return "";
                            }
                          },
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: unitwidth * 100,
                  height: unitheight * 15,
                  child: Column(
                    children: [
                      SizedBox(
                        height: unitwidth * 4,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: unitwidth * 7,
                          ),
                          Text(
                            "Fee Note",
                            style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: unitwidth * 1 * 4)),
                          ),
                        ],
                      ),
                      //SizedBox(height: unitheight*,),
                      Container(
                        width: unitwidth * 100,
                        height: unitwidth * 20,
                        margin: EdgeInsets.symmetric(
                            horizontal: unitwidth * 7, vertical: unitwidth * 2),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: Colors.white, fontSize: 18 * 1)),
                          decoration: InputDecoration(
                            //fillColor: Colors.red,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4))),
                            hintText: 'Note*',

                            hintStyle: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: unitwidth * 1 * 3)),
                            prefixIcon: Icon(
                              FontAwesomeIcons.rupeeSign,
                              size: unitwidth * 4,
                              color: Colors.blue,
                            ),
                          ),
                          controller: fees_note_Controller,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "";
                            } else {
                              return "";
                            }
                          },
                          autovalidateMode: AutovalidateMode.always,
                          keyboardType: TextInputType.text,
                        ),
                      ),
                    ],
                  ),
                ),
//if(widget.user.monthlyFee! == 0 &&  widget.user.trademilFee! == 0 && widget.user.lightsChargesFee! == 0 && widget.user.personalTrainingFee! ==0)
// Container()
// else
                Column(
                  children: [
                    Container(
                        width: unitwidth * 100,
                        height: unitwidth * 13,
                        margin: EdgeInsets.symmetric(
                            horizontal: unitwidth * 7, vertical: unitwidth * 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                Radio(
                                    value: paymentMode.online,
                                    groupValue: mode,
                                    onChanged: (onChanged) {
                                      setState(() {
                                        //print("Radio 1" + onChanged!.toString());
                                        mode = onChanged!;
                                      });
                                    },
                                    activeColor: Colors.green),
                                Text(
                                  "Online",
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
                                    value: paymentMode.offline,
                                    groupValue: mode,
                                    onChanged: (onChanged) {
                                      setState(() {
                                        //print("Radio 1" + onChanged!.toString());
                                        mode = onChanged!;
                                      });
                                    },
                                    activeColor: Colors.red),
                                Text(
                                  "Offline",
                                  style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: unitwidth * 1 * 3)),
                                )
                              ],
                            )
                          ],
                        )),
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
                                    color: Colors.white,
                                    fontSize: unitwidth * 3)),
                          ),
                          SizedBox(
                            width: unitwidth * 5,
                          ),
                          Container(
                            width: unitwidth * 18,
                            height: unitheight * 3.5,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
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
                                              //print("Date "+value.toString());
                                              joiningDate = value;
                                              joiningDateShow = DateFormat("dd")
                                                      .format(value!) +
                                                  "  " +
                                                  DateFormat("MMMM")
                                                      .format(value) +
                                                  "  " +
                                                  DateFormat("y").format(value);
                                            })
                                          });
                                },
                                child: Text(
                                  "Pick A Date",
                                  style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: unitwidth * 2.5,
                                          fontWeight: FontWeight.w600)),
                                )),
                          ),
                          SizedBox(
                            width: unitwidth * 10,
                          ),
                          Text(
                            joiningDateShow,
                            style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: unitwidth * 3,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                    ),
                    if (joiningDateShow == "00-00-0000")
                      Text(
                        "Please pick a date",
                        style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                                color: Colors.red,
                                fontSize: unitwidth * 2.5,
                                fontWeight: FontWeight.w600)),
                      ),
                    Container(
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
                                if (!waitingForResponse) {
                                  submitFee();
                                }
                              },
                              child: Container(
                                width: unitwidth * 80,
                                height: unitwidth * 13,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(unitwidth * 2))),
                                alignment: Alignment.center,
                                child: Text(
                                  "Pay",
                                  style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: unitwidth * 1 * 4)),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ],
                )
              ],
            )
          ]),
        ));
  }

  submitFee() async {
    String registraionFee = registration_Fees_Controller.text;
    String other_Fees = other_Fees_Controller.text;
    String monthly_Fees = monthly_Fees_Controller.text;
    String trademil_fees = trademil_Fees_Controller.text;
    String lights_Fees = lights_Fees_Controller.text;
    String personal_Fees = personal_Fees_Controller.text;
    String Note = fees_note_Controller.text;
    if (monthly_Fees_Controller.text.isEmpty) {
      monthly_Fees = "0";
    }
    if (trademil_Fees_Controller.text.isEmpty) {
      trademil_fees = "0";
    }
    if (lights_Fees_Controller.text.isEmpty) {
      lights_Fees = "0";
    }
    if (personal_Fees_Controller.text.isEmpty) {
      personal_Fees = "0";
    }
    if (registration_Fees_Controller.text.isEmpty) {
      registraionFee = "0";
    }
    if (other_Fees_Controller.text.isEmpty) {
      other_Fees = "0";
    }
    if (fees_note_Controller.text.isEmpty) {
      Note = "";
    }

//int amount = int.parse(monthly_Fees)+int.parse(trademil_fees)+int.parse(lights_Fees)+int.parse(personal_Fees) + int.parse(registraionFee) +int.parse(other_Fees);
    var request = await Services().submitUserFee(
        widget.user.registrationNo!,
        mode,
        int.parse(registraionFee),
        int.parse(monthly_Fees),
        int.parse(trademil_fees),
        int.parse(lights_Fees),
        int.parse(personal_Fees),
        int.parse(other_Fees),
        Note,
        joiningDate.toString());
    //print("Paid response "+ request.toString());
    if (request.toString() == "true") {
      Navigator.pop(context);
      waitingForResponse = false;
      setState(() {});
    } else {
      waitingForResponse = false;
      Fluttertoast.showToast(msg: "You need to fill all field");
    }
    // if(monthly_Fees_Controller.text.isNotEmpty && trademil_Fees_Controller.text.isNotEmpty && lights_Fees_Controller.text.isNotEmpty && personal_Fees_Controller.text.isNotEmpty){

    // }else{
    //   Fluttertoast.showToast(msg: "You need to fill all field");
    // }
  }
}
