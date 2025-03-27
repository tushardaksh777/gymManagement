import 'package:achievement_view/achievement_view.dart';
import 'package:achievement_view/achievement_widget.dart';
import 'package:animated_radio_buttons/animated_radio_buttons.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_management/DTO/User.dart';
import 'package:gym_management/Server/Services.dart';
import 'package:gym_management/globalData.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:m_toast/m_toast.dart';

enum feesMode { online, offline }

enum activeMode { active, inactive }

class CreateUser extends StatefulWidget {
  const CreateUser({super.key});

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool personalTraining = false;
  String joiningDateShow = "00-00-0000";
  DateTime? joiningDate = DateTime.now();
  activeMode _activeMode = activeMode.inactive;
  paymentMode mode = paymentMode.online;
  bool response = false;
  //XFile? image;
  final ImagePicker picker = ImagePicker();
  TextEditingController registrationNoController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController husbandNameController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController registration_Fees_Controller = TextEditingController();
  TextEditingController annual_Fees_Controller = TextEditingController();
  TextEditingController monthly_Fees_Controller = TextEditingController();
  TextEditingController trademil_Fees_Controller = TextEditingController();
  TextEditingController lights_Fees_Controller = TextEditingController();
  TextEditingController personal_Fees_Controller = TextEditingController();
  TextEditingController other_Fees_Controller = TextEditingController();
  TextEditingController fees_note_Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double unitwidth = MediaQuery.of(context).size.width / 100;
    double unitheight = MediaQuery.of(context).size.height / 100;

    return Scaffold(
      appBar: AppBar(title: Text("Add Member")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          collectAllData(context);
          UserModel userModel = new UserModel();

          //validateData();
          //askingDialog(context);
        },
        child: const Icon(Icons.check),
      ),
      body: Container(
          child: ListView(children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Container(width: unitwidth*100,height: unitwidth*15,margin: EdgeInsets.symmetric(horizontal: unitwidth*35, vertical: unitwidth*2), decoration: BoxDecoration(color: Colors.grey[200],borderRadius: BorderRadius.all(Radius.circular(10))),
            // child: MaterialButton(onPressed: (){
            //   picker.pickImage(source: ImageSource.gallery);
            // } ,),
            // ),
            SizedBox(
              height: unitheight * 5,
            ),
            Container(
              width: unitwidth * 100,
              height: unitwidth * 13,
              margin: EdgeInsets.symmetric(
                  horizontal: unitwidth * 7, vertical: unitwidth * 2),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                style: GoogleFonts.montserrat(
                    textStyle:
                        TextStyle(color: Colors.black, fontSize: 18 * 1)),
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  hintText: 'Registration No.',
                  hintStyle: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                          color: Colors.black, fontSize: unitwidth * 1 * 3)),
                  prefixIcon: Icon(Icons.app_registration,
                      color: Colors.blue, size: unitwidth * 4),
                ),
                controller: registrationNoController,
                autovalidateMode: AutovalidateMode.always,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter Registration No.";
                  } else {
                    return "";
                  }
                },
                keyboardType: TextInputType.number,
              ),
            ),
            Container(
              width: unitwidth * 100,
              height: unitwidth * 13,
              margin: EdgeInsets.symmetric(
                  horizontal: unitwidth * 7, vertical: unitwidth * 2),
              child: TextFormField(
                maxLength: 40,
//maxLengthEnforcement: MaxLengthEnforcement.truncateAfterCompositionEnds,
                textInputAction: TextInputAction.next,
                style: GoogleFonts.montserrat(
                    textStyle:
                        TextStyle(color: Colors.black, fontSize: 18 * 1)),
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  hintText: 'Name',
                  hintStyle: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                          color: Colors.black, fontSize: unitwidth * 1 * 3)),
                  prefixIcon: Icon(Icons.person,
                      color: Colors.blue, size: unitwidth * 4),
                ),
                textCapitalization: TextCapitalization.words,
                controller: nameController,
                autovalidateMode: AutovalidateMode.always,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter Your Name";
                  } else {
                    return "";
                  }
                },
                keyboardType: TextInputType.text,
              ),
            ),
            Container(
              width: unitwidth * 100,
              height: unitwidth * 13,
              margin: EdgeInsets.symmetric(
                  horizontal: unitwidth * 7, vertical: unitwidth * 2),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                style: GoogleFonts.montserrat(
                    textStyle:
                        TextStyle(color: Colors.black, fontSize: 18 * 1)),
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  hintText: "Father's name",
                  hintStyle: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                          color: Colors.black, fontSize: unitwidth * 1 * 3)),
                  prefixIcon: Icon(Icons.person,
                      color: Colors.blue, size: unitwidth * 4),
                ),
                textCapitalization: TextCapitalization.words,
                controller: fatherNameController,
                autovalidateMode: AutovalidateMode.always,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter Your Father's Name";
                  } else {
                    return "";
                  }
                },
                keyboardType: TextInputType.text,
              ),
            ),
            Container(
              width: unitwidth * 100,
              height: unitwidth * 13,
              margin: EdgeInsets.symmetric(
                  horizontal: unitwidth * 7, vertical: unitwidth * 2),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                style: GoogleFonts.montserrat(
                    textStyle:
                        TextStyle(color: Colors.black, fontSize: 18 * 1)),
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  hintText: "Husbands's name",
                  hintStyle: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                          color: Colors.black, fontSize: unitwidth * 1 * 3)),
                  prefixIcon: Icon(Icons.person,
                      color: Colors.blue, size: unitwidth * 4),
                ),
                textCapitalization: TextCapitalization.words,
                controller: husbandNameController,
                autovalidateMode: AutovalidateMode.always,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter Your Father's Name";
                  } else {
                    return "";
                  }
                },
                keyboardType: TextInputType.text,
              ),
            ),
            Container(
              width: unitwidth * 100,
              height: unitwidth * 13,
              margin: EdgeInsets.symmetric(
                  horizontal: unitwidth * 7, vertical: unitwidth * 2),
              child: TextFormField(
                textInputAction: TextInputAction.done,
                style: GoogleFonts.montserrat(
                    textStyle:
                        TextStyle(color: Colors.black, fontSize: 18 * 1)),
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  //filled: true,
                  //fillColor: Colors.grey.withOpacity(0.4),
                  hintText: "Enter Your Number",
                  hintStyle: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                          color: Colors.black, fontSize: unitwidth * 1 * 3)),
                  prefixIcon: Icon(FontAwesomeIcons.phoneAlt,
                      color: Colors.blue, size: unitwidth * 4),
                  // prefixText: '+91 ',

                  // prefixStyle:  GoogleFonts.montserrat(
                  //     textStyle: TextStyle(
                  //         color: Colors.black,
                  //         fontSize: unitwidth *
                  //             1 *
                  //             5)),
                ),
                controller: phoneNoController,
                keyboardType: TextInputType.number,
                autovalidateMode: AutovalidateMode.always,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter Your Phone No.";
                  } else {
                    return "";
                  }
                },
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                maxLength: 10,
              ),
            ),
            Container(
              width: unitwidth * 100,
              height: unitwidth * 13,
              margin: EdgeInsets.symmetric(
                  horizontal: unitwidth * 6, vertical: unitwidth * 2),
              child: TextFormField(
                textInputAction: TextInputAction.next,
                maxLength: 35,
                style: GoogleFonts.montserrat(
                    textStyle:
                        TextStyle(color: Colors.black, fontSize: 18 * 1)),
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  hintText: 'Address',
                  hintStyle: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                          color: Colors.black, fontSize: unitwidth * 1 * 3)),
                  prefixIcon: Icon(FontAwesomeIcons.addressBook,
                      color: Colors.blue, size: unitwidth * 4),
                ),
                controller: addressController,
                textCapitalization: TextCapitalization.words,
                autovalidateMode: AutovalidateMode.always,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter Your Addres";
                  } else {
                    return "";
                  }
                },
                keyboardType: TextInputType.streetAddress,
              ),
            ),
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
                    "Joining Date",
                    style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                            color: Colors.black, fontSize: unitwidth * 3)),
                  ),
                  SizedBox(
                    width: unitwidth * 5,
                  ),
                  Container(
                    width: unitwidth * 18,
                    height: unitheight * 3.5,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.3),
                        borderRadius:
                            BorderRadius.all(Radius.circular(unitwidth * 1.5))),
                    child: MaterialButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(DateTime.now().year - 2),
                                  lastDate: DateTime(DateTime.now().year + 1))
                              .then((value) => {
                                    setState(() {
                                      //print("Date "+value.toString());
                                      joiningDate = value;
                                      joiningDateShow = "" +
                                          DateFormat("dd").format(value!) +
                                          "  " +
                                          DateFormat("MMMM").format(value) +
                                          "  " +
                                          DateFormat("y").format(value);
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
                  SizedBox(
                    width: unitwidth * 10,
                  ),
                  Text(
                    joiningDateShow,
                    style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                            color: Colors.black,
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
                            value: activeMode.active,
                            groupValue: _activeMode,
                            onChanged: (onChanged) {
                              setState(() {
                                //print("Radio 1" + onChanged!.toString());
                                _activeMode = onChanged!;
                              });
                            },
                            activeColor: Colors.green),
                        Text(
                          "Active",
                          style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: unitwidth * 1 * 3)),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                            value: activeMode.inactive,
                            groupValue: _activeMode,
                            onChanged: (onChanged) {
                              setState(() {
                                print("Radio 1" + onChanged!.toString());
                                _activeMode = onChanged;
                              });
                            },
                            activeColor: Colors.red),
                        Text(
                          "Inactive",
                          style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: unitwidth * 1 * 3)),
                        )
                      ],
                    )
                  ],
                )),

            if (false)
              Column(
                children: [
                  Divider(
                    thickness: 10,
                    height: unitheight * 5,
                    color: Colors.grey[300],
                  ),
                  Text(
                    "Plan Details",
                    style: GoogleFonts.montserrat(
                        textStyle: TextStyle(fontSize: unitwidth * 6)),
                  ),
// Container(width: unitwidth*100,height: unitwidth*13, margin:EdgeInsets.symmetric(horizontal: unitwidth*7, vertical: unitwidth*2), child: Row(
//   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// children: [

// Row(children: [
//   Radio(value: paymentMode.online, groupValue: mode, onChanged: (onChanged){
// setState(() {
//   //print("Radio 1" + onChanged!.toString());
//   mode = onChanged!;
// });
// } , activeColor: Colors.green),
// Text("Online" , style: GoogleFonts.montserrat(
//                                           textStyle: TextStyle(
//                                               color: Colors.black,
//                                               fontSize: unitwidth *
//                                                   1 *
//                                                   3)),)
// ],),
// Row(children: [
//   Radio(value: paymentMode.offline, groupValue: mode, onChanged: (onChanged){
// setState(() {
//   //print("Radio 1" + onChanged!.toString());
//   mode = onChanged!;
// });
// } , activeColor: Colors.red),
// Text("Offline" , style: GoogleFonts.montserrat(
//                                           textStyle: TextStyle(
//                                               color: Colors.black,
//                                               fontSize: unitwidth *
//                                                   1 *
//                                                   3)),)
// ],)
// ],

// )),
                  Row(
                    children: [
                      Container(
                        width: unitwidth * 35,
                        height: unitwidth * 15,
                        margin: EdgeInsets.symmetric(
                            horizontal: unitwidth * 7, vertical: unitwidth * 2),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: Colors.black, fontSize: 18 * 1)),
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4))),
                            hintText: 'Registration Fee',
                            hintStyle: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: unitwidth * 1 * 3)),
                            prefixIcon: Icon(FontAwesomeIcons.rupeeSign,
                                color: Colors.blue, size: unitwidth * 4),
                          ),
                          controller: registration_Fees_Controller,
                          autovalidateMode: AutovalidateMode.always,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter Registration fees";
                            } else {
                              return "";
                            }
                          },
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Container(
                        width: unitwidth * 35,
                        height: unitwidth * 15,
                        margin: EdgeInsets.symmetric(
                            horizontal: unitwidth * 7, vertical: unitwidth * 2),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: Colors.black, fontSize: 18 * 1)),
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4))),
                            hintText: 'Monthly Fee',
                            hintStyle: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: unitwidth * 1 * 3)),
                            prefixIcon: Icon(FontAwesomeIcons.rupeeSign,
                                color: Colors.blue, size: unitwidth * 4),
                          ),
                          controller: monthly_Fees_Controller,
                          autovalidateMode: AutovalidateMode.always,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter Monthly fees";
                            } else {
                              return "";
                            }
                          },
                          keyboardType: TextInputType.number,
                        ),
                      ),
// Container(width: unitwidth*35,height: unitwidth*15, margin:EdgeInsets.symmetric(horizontal: unitwidth*7, vertical: unitwidth*2),child: TextFormField(
//       textInputAction: TextInputAction.next,
//       style: GoogleFonts.montserrat(
//       textStyle: TextStyle(
//        color: Colors.black,
//         fontSize: 18 * 1)),
//   decoration:InputDecoration(
//      border: UnderlineInputBorder(
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

//   ),controller: annual_Fees_Controller,
//   autovalidateMode: AutovalidateMode.always, validator: (value) {
//     if(value == null|| value.isEmpty){
// return "Please enter Annual fees";
//     }else{
//       return "";
//     }
//   },
//   keyboardType: TextInputType.number,
// ),),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: unitwidth * 35,
                        height: unitwidth * 15,
                        margin: EdgeInsets.symmetric(
                            horizontal: unitwidth * 7, vertical: unitwidth * 2),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: Colors.black, fontSize: 18 * 1)),
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4))),
                            hintText: 'Trademil Fee',
                            hintStyle: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    color: Colors.black,
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
                              return "Please enter Treademil charges";
                            } else {
                              return "";
                            }
                          },
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Container(
                        width: unitwidth * 35,
                        height: unitwidth * 15,
                        margin: EdgeInsets.symmetric(
                            horizontal: unitwidth * 7, vertical: unitwidth * 2),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: Colors.black, fontSize: 18 * 1)),
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4))),
                            hintText: 'Lights Charges',
                            hintStyle: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: unitwidth * 1 * 3)),
                            prefixIcon: Icon(FontAwesomeIcons.rupeeSign,
                                color: Colors.blue, size: unitwidth * 4),
                          ),
                          controller: lights_Fees_Controller,
                          autovalidateMode: AutovalidateMode.always,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter Lights charges";
                            } else {
                              return "";
                            }
                          },
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: unitwidth * 80,
                        height: unitwidth * 15,
                        margin: EdgeInsets.symmetric(
                            horizontal: unitwidth * 7, vertical: unitwidth * 2),
                        child: TextFormField(
                          textInputAction: TextInputAction.done,
                          style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                  color: Colors.black, fontSize: 18 * 1)),
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4))),
                            hintText: 'Personal Fee',
                            hintStyle: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    color: Colors.black,
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
                              return "Please enter Personal fees";
                            } else {
                              return "";
                            }
                          },
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: unitwidth * 100,
                    height: unitwidth * 15,
                    margin: EdgeInsets.symmetric(
                        horizontal: unitwidth * 7, vertical: unitwidth * 2),
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      maxLength: 30,
                      style: GoogleFonts.montserrat(
                          textStyle:
                              TextStyle(color: Colors.black, fontSize: 18 * 1)),
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                        hintText: 'Note*',
                        hintStyle: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: unitwidth * 1 * 3)),
                        prefixIcon: Icon(Icons.note,
                            color: Colors.blue, size: unitwidth * 4),
                      ),
                      controller: fees_note_Controller,
                      keyboardType: TextInputType.text,
                    ),
                  ),

// Container(width: unitwidth*100, height: unitheight*10,margin:EdgeInsets.symmetric(horizontal: unitwidth*7, vertical: unitwidth*0),child:
// Row(children: [

// Row(mainAxisAlignment: MainAxisAlignment.center
// ,
//   children: [

//   Checkbox(value: personalTraining,materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,onChanged:((value) => {
//    setState(() {personalTraining = value!;})
//   })),
//  Text( "Personal Training" , style: GoogleFonts.montserrat(textStyle: TextStyle(fontSize: unitwidth*4, fontWeight: FontWeight.w500 )),),
// ],),
// SizedBox(width: unitwidth*5,),
// if(personalTraining)
// Container(width: unitwidth*35,height: unitwidth*15, margin:EdgeInsets.symmetric(horizontal: unitwidth*0, vertical: unitwidth*2),child: TextFormField(
//       textInputAction: TextInputAction.next,
//       style: GoogleFonts.montserrat(
//       textStyle: TextStyle(
//        color: Colors.black,
//         fontSize: 18 * 1)),
//   decoration:InputDecoration(
//      border: UnderlineInputBorder(
//      borderRadius: BorderRadius.all(
//      Radius.circular(4))),
//     hintText: "Personal Training Fee",
//     hintStyle: GoogleFonts.montserrat(
//                                           textStyle: TextStyle(
//                                               color: Colors.black,
//                                               fontSize: unitwidth *
//                                                   1 *
//                                                   3)),
//                                                   prefixIcon:  Icon(FontAwesomeIcons.rupeeSign ,  color: Colors.blue,size:unitwidth* 4,),

//   ),
//   keyboardType: TextInputType.number,
// ),),]),),

// Container(width: unitwidth*100,height: unitwidth*13, margin:EdgeInsets.symmetric(horizontal: unitwidth*7, vertical: unitwidth*2), child: Row(
// children: [
// // Container(width: unitwidth* 40,height: unitwidth*4,child:
// // Row(children: [
// //     Checkbox(value: true, onChanged: (onChanged){

// //   }),
// //   Text("Online Fee Deposit" , style: GoogleFonts.montserrat(
// //                                           textStyle: TextStyle(
// //                                               color: Colors.black,
// //                                               fontSize: unitwidth *
// //                                                   1 *
// //                                                   3)),)

// // ],)
// // ,),
// Row(children: [
//   Radio(value: feesMode.online, groupValue: _feesMode, onChanged: (onChanged){
// setState(() {
//   print("Radio 1" + onChanged!.toString());
//   _feesMode = onChanged;
// });
// } , activeColor: Colors.green),
// Text("Online Fee Deposit" , style: GoogleFonts.montserrat(
//                                           textStyle: TextStyle(
//                                               color: Colors.black,
//                                               fontSize: unitwidth *
//                                                   1 *
//                                                   3)),)
// ],),
// Row(children: [
//   Radio(value: feesMode.offline, groupValue: _feesMode, onChanged: (onChanged){
// setState(() {
//   print("Radio 1" + onChanged!.toString());
//   _feesMode = onChanged;
// });
// } , activeColor: Colors.red),
// Text("Offline Fee Deposit" , style: GoogleFonts.montserrat(
//                                           textStyle: TextStyle(
//                                               color: Colors.black,
//                                               fontSize: unitwidth *
//                                                   1 *
//                                                   3)),)
// ],)
// ],

// )),

                  Divider(
                    thickness: 10,
                    height: unitheight * 5,
                    color: Colors.grey[300],
                  ),
// Text("Attandance" , style: GoogleFonts.montserrat(textStyle: TextStyle(fontSize: unitwidth*6)),),

                  SizedBox(
                    height: unitheight * 5,
                  )
                ],
              )
          ],
        )
      ])),
    );
  }

  askingDialog(BuildContext context, UserModel user) {
    double textscalefactor = 0.8;
    double unitwidth = MediaQuery.of(context).size.width / 100;
    AlertDialog alertDialog = AlertDialog(
      title: Text(
        "Submit",
        style: GoogleFonts.montserrat(
            textStyle: TextStyle(color: Colors.black, fontSize: unitwidth * 5)),
      ),
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
            if (!response) {
              var u = await Services()
                  .addUser(user); //await Services().addUser(user);
              // print("Add user "+u.toString());
              response = true;
              if (u["response"] == "true") {
                response = false;
                Navigator.pop(context);
                Navigator.pop(context);
                setState(() {});
              } else {
                Fluttertoast.showToast(msg: u["msg"]);
                response = false;
              }
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
            if (!response) {
              Navigator.pop(context);
              //response = false;
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

    /// return mergeAccount;
  }

  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      //image = img;
    });
  }

  validateData() {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      //print('Form is valid');
    } else {
      // print('Form is invalid');
    }
  }

  collectAllData(BuildContext context) async {
    String registrationNo = registrationNoController.text;
    String Name = nameController.text;
    String fatherName =
        (fatherNameController.text.isEmpty) ? "" : fatherNameController.text;
    String phoneNo = phoneNoController.text;
    String Address = addressController.text;
    String joinDate = (joiningDate == null) ? "" : joiningDate.toString();
    String husbandName =
        (husbandNameController.text.isEmpty) ? "" : husbandNameController.text;
    // String registration_Fees = registration_Fees_Controller.text;
    // String annual_fees = annual_Fees_Controller.text;
    // String monthly_Fees = monthly_Fees_Controller.text;
    // String trademil_fees = trademil_Fees_Controller.text;
    // String lights_Fees = lights_Fees_Controller.text;
    // String other_Fees =other_Fees_Controller.text;
    // String feesNote = fees_note_Controller.text;
    // String personalTrainingfees =personal_Fees_Controller.text;
    // String feesDespositeMode = mode.name;//(pay == feesMode.online)? "online":"Offline";
    activeMode userActivity = _activeMode;

    bool validate = false;
    if (registrationNoController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        phoneNoController.text.isNotEmpty &&
        addressController.text.isNotEmpty) {
      validate = true;
    }

    // if(registrationNo.isNotEmpty && Name.isNotEmpty && phoneNo.isNotEmpty && Address.isNotEmpty ){

    //   if(joinDate.isEmpty){
    //     joinDate = DateTime.now().toString();
    //   }
    //   print("Joining Date "+ joinDate);

    //   validate = true;

    //   if(_activeMode == activeMode.active){
    //     if(registration_Fees.isEmpty){
    //       registration_Fees ="0";
    //     }
    //     if(monthly_Fees.isEmpty){
    //       monthly_Fees = "0";
    //     }
    //     if(trademil_fees.isEmpty){
    //       trademil_fees = "0";
    //     }
    //     if(lights_Fees.isEmpty){
    //       lights_Fees ="0";
    //     }
    //     if(personalTrainingfees.isEmpty){
    //       personalTrainingfees = "0";
    //     }
    //     validate = true;
    //     // if(registration_Fees.isNotEmpty && monthly_Fees.isNotEmpty && trademil_fees.isNotEmpty && lights_Fees.isNotEmpty && personalTrainingfees.isNotEmpty){

    //     //   validate = true;

    //     // }else{
    //     //   validate = false;
    //     // }
    //   }
    // }

    if (validate) {
      UserModel userModel = new UserModel();
      userModel.registrationNo = int.parse(registrationNo);
      userModel.name = Name;
      userModel.fatherName = fatherName;
      userModel.phoneNo = phoneNo;
      userModel.address = Address;
      userModel.status = _activeMode.name;
      userModel.husbandName = husbandName;
      userModel.joiningDate =
          (joinDate.isEmpty) ? DateTime.now().toString() : joinDate;
      // if(_activeMode == activeMode.active){
      //   userModel.registraionFee = int.parse(registration_Fees);
      // //userModel.annualFee = int.parse(annual_fees);
      // userModel.monthlyFee = int.parse(monthly_Fees);
      // userModel.trademilFee = int.parse(trademil_fees);
      // userModel.lightsChargesFee = int.parse(lights_Fees);
      // userModel.personalTrainingFee = int.parse(personalTrainingfees);
      // userModel.feeNote = feesNote;
      // }else{
      //   userModel.registraionFee = 0;
      //   userModel.monthlyFee = 0;
      //   userModel.trademilFee = 0;
      //   userModel.personalTrainingFee =0;
      //   userModel.feeNote="";
      //   userModel.lightsChargesFee =0;
      // }
      askingDialog(context, userModel);
    } else {
      AchievementView(
        title: "Add User",
        subTitle: "Please Enter all Details",
        icon: Icon(
          Icons.error,
          color: Colors.white,
        ),
        color: Colors.red,
        alignment: Alignment.bottomCenter,
        duration: Duration(seconds: 2),
        isCircle: true,
      ).show(context);
    }
  }

  addUser(BuildContext context) {
    AchievementView(
        title: "Add User",
        subTitle: "User Added SuccessFully",
        //onTab: _onTabAchievement,
        icon: Icon(
          Icons.check,
          color: Colors.white,
        ),
        //typeAnimationContent: AnimationTypeAchievement.fadeSlideToUp,
        //borderRadius: 5.0,
        color: Colors.green,
        //textStyleTitle: TextStyle(),
        //textStyleSubTitle: TextStyle(),
        alignment: Alignment.bottomCenter,
        duration: Duration(seconds: 2),
        isCircle: true,
        listener: ((p0) {
          if (p0 == AchievementState.closing) {
            backToHome(context);
          }
        })).show(
      context,
    );
  }

  backToHome(BuildContext context) {
    Navigator.pop(context);
    Navigator.pop(context);
    setState(() {});
  }
}
