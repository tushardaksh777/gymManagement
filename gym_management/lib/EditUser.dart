import 'package:achievement_view/achievement_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_management/AddUser/createUser.dart';
import 'package:gym_management/DTO/User.dart';
import 'package:gym_management/Server/Services.dart';
import 'package:gym_management/globalData.dart';
import 'package:intl/intl.dart';

class EditUser extends StatefulWidget {
  UserModel user;

  EditUser({super.key, required this.user});

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
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

  String joiningDateShow = "00-00-0000";
  DateTime? joiningDate;
  activeMode _activeMode = activeMode.inactive;
  paymentMode mode = paymentMode.online;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setexistingData();
  }

  @override
  Widget build(BuildContext context) {
    double unitwidth = MediaQuery.of(context).size.width / 100;
    double unitheight = MediaQuery.of(context).size.height / 100;
    return Scaffold(
      appBar: AppBar(title: Text("Add Member")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          collectAllData(context);
          //UserModel userModel = new UserModel();

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
            //   //picker.pickImage(source: ImageSource.gallery);
            // } ,),
            // ),
            SizedBox(
              height: unitheight * 2,
            ),
            Text(
              "Registration No",
              style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                      color: Colors.black, fontSize: unitwidth * 1 * 4)),
            ),
            SizedBox(
              height: unitheight * 2,
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
            SizedBox(
              height: unitheight * 2,
            ),
            Text(
              "Name",
              style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                      color: Colors.black, fontSize: unitwidth * 1 * 4)),
            ),
            Container(
              width: unitwidth * 100,
              height: unitwidth * 15,
              margin: EdgeInsets.symmetric(
                  horizontal: unitwidth * 7, vertical: unitwidth * 2),
              child: TextFormField(
                textInputAction: TextInputAction.done,
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
            SizedBox(
              height: unitheight * 2,
            ),
            Text(
              "Father's Name",
              style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                      color: Colors.black, fontSize: unitwidth * 1 * 4)),
            ),
            Container(
              width: unitwidth * 100,
              height: unitwidth * 15,
              margin: EdgeInsets.symmetric(
                  horizontal: unitwidth * 7, vertical: unitwidth * 2),
              child: TextFormField(
                textInputAction: TextInputAction.done,
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
            SizedBox(
              height: unitheight * 2,
            ),
            Text(
              "Husband's Name",
              style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                      color: Colors.black, fontSize: unitwidth * 1 * 4)),
            ),
            Container(
              width: unitwidth * 100,
              height: unitwidth * 15,
              margin: EdgeInsets.symmetric(
                  horizontal: unitwidth * 7, vertical: unitwidth * 2),
              child: TextFormField(
                textInputAction: TextInputAction.done,
                style: GoogleFonts.montserrat(
                    textStyle:
                        TextStyle(color: Colors.black, fontSize: 18 * 1)),
                decoration: InputDecoration(
                  border: UnderlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  hintText: "Husband's name",
                  hintStyle: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                          color: Colors.black, fontSize: unitwidth * 1 * 3)),
                  prefixIcon: Icon(Icons.person,
                      color: Colors.blue, size: unitwidth * 4),
                ),
                controller: husbandNameController,
                autovalidateMode: AutovalidateMode.always,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter Your Husband's Name";
                  } else {
                    return "";
                  }
                },
                keyboardType: TextInputType.text,
              ),
            ),
            SizedBox(
              height: unitheight * 2,
            ),
            Text(
              "Phone No.",
              style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                      color: Colors.black, fontSize: unitwidth * 1 * 4)),
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

            SizedBox(
              height: unitheight * 2,
            ),
            Text(
              "Address",
              style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                      color: Colors.black, fontSize: unitwidth * 1 * 4)),
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
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  hintText: 'Address',
                  hintStyle: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                          color: Colors.black, fontSize: unitwidth * 1 * 3)),
                  prefixIcon: Icon(FontAwesomeIcons.addressBook,
                      color: Colors.blue, size: unitwidth * 4),
                ),
                controller: addressController,
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
                  Text(
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
                                  firstDate: DateTime(DateTime.now().year - 1),
                                  lastDate: DateTime(DateTime.now().year,
                                      DateTime.now().month + 1))
                              .then((value) => {
                                    setState(() {
                                      joiningDate = value;
                                      joiningDateShow = "" +
                                          DateFormat("dd")
                                              .format(joiningDate!) +
                                          "  " +
                                          DateFormat("MMMM")
                                              .format(joiningDate!) +
                                          "  " +
                                          DateFormat("y").format(joiningDate!);
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

// Container(width: unitwidth*100,height: unitwidth*13, margin:EdgeInsets.symmetric(horizontal: unitwidth*7, vertical: unitwidth*2), child: Row(
//   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// children: [

// Row(children: [
//   Radio(value: activeMode.active, groupValue: _activeMode, onChanged: (onChanged){
// setState(() {
//   print("Radio 1" + onChanged!.toString());
//   _activeMode = onChanged;
// });
// } , activeColor: Colors.green),
// Text("Active" , style: GoogleFonts.montserrat(
//                                           textStyle: TextStyle(
//                                               color: Colors.black,
//                                               fontSize: unitwidth *
//                                                   1 *
//                                                   3)),)
// ],),
// Row(children: [
//   Radio(value: activeMode.inactive, groupValue: _activeMode, onChanged: (onChanged){
// setState(() {
//   print("Radio 1" + onChanged!.toString());
//   _activeMode = onChanged;
// });
// } , activeColor: Colors.red),
// Text("Inactive" , style: GoogleFonts.montserrat(
//                                           textStyle: TextStyle(
//                                               color: Colors.black,
//                                               fontSize: unitwidth *
//                                                   1 *
//                                                   3)),)
// ],)
// ],

// )),

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
                                        color: Colors.black,
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
                                        color: Colors.black,
                                        fontSize: unitwidth * 1 * 3)),
                              )
                            ],
                          )
                        ],
                      )),
                  Row(
                    children: [
                      Container(
                        width: unitwidth * 35,
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
                          textInputAction: TextInputAction.done,
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
                          textInputAction: TextInputAction.done,
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
                          textInputAction: TextInputAction.done,
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
                      textInputAction: TextInputAction.done,
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

  setexistingData() {
    registrationNoController.text = widget.user.registrationNo!.toString();
    nameController.text = widget.user.name!;
    fatherNameController.text =
        (widget.user.fatherName != null) ? widget.user.fatherName! : "";
    phoneNoController.text = widget.user.phoneNo!;
    addressController.text = widget.user.address!;
    husbandNameController.text =
        ((widget.user.husbandName != null) ? widget.user.husbandName! : "");
    //registration_Fees_Controller.text = widget.user.registraionFee!.toString();
    _activeMode = (widget.user.status == "active")
        ? activeMode.active
        : activeMode.inactive;
    joiningDate = DateTime.parse(widget.user.joiningDate!);
    joiningDateShow =
        "${DateFormat("dd").format(joiningDate!)}  ${DateFormat("MMMM").format(joiningDate!)}  ${DateFormat("y").format(joiningDate!)}";
    //if(widget.user.status == "active"){

    //   monthly_Fees_Controller.text = widget.user.monthlyFee!.toString();
    //  trademil_Fees_Controller.text = widget.user.trademilFee.toString();
    //  lights_Fees_Controller.text = widget.user.lightsChargesFee.toString();
    //  personal_Fees_Controller.text = widget.user.personalTrainingFee.toString();
    //  fees_note_Controller.text =  widget.user.feeNote!;
    // }
  }

  collectAllData(BuildContext context) async {
    String registrationNo = (registrationNoController.text.isEmpty)
        ? widget.user.registrationNo.toString()
        : registrationNoController.text;
    String Name =
        (nameController.text).isEmpty ? widget.user.name! : nameController.text;
    String fatherName = "";
    if (fatherNameController.text.isEmpty) {
      if (widget.user.fatherName != null) {
        fatherName = widget.user.fatherName!;
      } else {
        fatherName = " ";
      }
    } else {
      fatherName = fatherNameController.text;
    }
    String phoneNo = (phoneNoController.text.isEmpty)
        ? widget.user.phoneNo!
        : phoneNoController.text;
    String Address = (addressController.text.isEmpty)
        ? widget.user.address!
        : addressController.text;
    String husbandName = "";
    if (husbandNameController.text.isEmpty) {
      if (widget.user.husbandName != null) {
        husbandName = widget.user.husbandName!;
      } else {
        husbandName = " ";
      }
    } else {
      husbandName = husbandNameController.text;
    }

    // int dif = joiningDate!.difference(DateTime.parse(widget.user.joiningDate!)).inDays;
    //print("User date "+widget.user.joiningDate! +" joining date "+ joiningDate!.toIso8601String() +" diff "+dif.toString() +" Manual "+ DateTime(joiningDate!.year , joiningDate!.month , joiningDate!.day).toString());
    String joinDate =
        DateTime(joiningDate!.year, joiningDate!.month, joiningDate!.day)
            .toString();
    // String registration_Fees = (registration_Fees_Controller.text.isEmpty)?widget.user.registrationNo!.toString():registration_Fees_Controller.text;
    // String monthly_Fees = (monthly_Fees_Controller.text.isEmpty)?widget.user.monthlyFee!.toString():monthly_Fees_Controller.text;
    // String trademil_fees = (trademil_Fees_Controller.text.isEmpty)?widget.user.trademilFee!.toString():trademil_Fees_Controller.text;
    // String lights_Fees = (lights_Fees_Controller.text.isEmpty)?widget.user.lightsChargesFee!.toString():lights_Fees_Controller.text;

    // String feesNote = (fees_note_Controller.text.isEmpty)?widget.user.feeNote!.toString():fees_note_Controller.text;
    // String personalTrainingfees =(personal_Fees_Controller.text.isEmpty)?widget.user.personalTrainingFee!.toString():personal_Fees_Controller.text;
    //String feesDespositeMode = mode.name;//(pay == feesMode.online)? "online":"Offline";
    activeMode userActivity = _activeMode;

    UserModel userModel = UserModel();
    userModel.id = widget.user.id;
    userModel.registrationNo = int.parse(registrationNo);
    userModel.name = Name;
    userModel.fatherName = fatherName;
    userModel.phoneNo = phoneNo;
    userModel.address = Address;
    userModel.status = _activeMode.name;
    userModel.joiningDate = joinDate;
    userModel.husbandName = husbandName;
    // if(_activeMode == activeMode.active){
    //   userModel.registraionFee = int.parse(registration_Fees);
    // //userModel.annualFee = int.parse(annual_fees);
    // userModel.monthlyFee = int.parse(monthly_Fees);
    // userModel.trademilFee = int.parse(trademil_fees);
    // userModel.lightsChargesFee = int.parse(lights_Fees);
    // userModel.personalTrainingFee = int.parse(personalTrainingfees);
    // userModel.feeNote = feesNote;
    // }

    askingDialog(context, userModel);
  }
  // submitUser(UserModel userModel)async{
  //  var request = await Services().editUser(userModel);
  // //  print("Submit user "+ request.toString());
  // //  if(request.toString() == "true"){

  // //   Navigator.pop(context);
  // //   setState(() {

  // //   });

  //  }else{
  //   Fluttertoast.showToast(msg: "Please Try Again");
  //  }

  askingDialog(BuildContext context, UserModel user) {
    bool response = false;
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
              response = true;
              var u = await Services()
                  .editUser(user); //await Services().addUser(user);
              print("Add user " + u.toString());

              if (u["response"].toString() == "true") {
                response = false;
                Navigator.pop(context);
                Navigator.pop(context);
                setState(() {});
              } else {
                if (u["msg"] != null) {
                  Fluttertoast.showToast(msg: u["msg"]);
                }
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
}
