import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_management/PDF/PdfApi.dart';
import 'package:gym_management/Server/Services.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Address extends StatefulWidget {
  const Address({super.key});

  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  String address = "NO Address";
  TextEditingController first = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAddress();
  }
  @override
  Widget build(BuildContext context) {
    double unitwidth = MediaQuery.of(context).size.width / 100;
    double unitheight = MediaQuery.of(context).size.height / 100;
    return Scaffold(appBar: AppBar(title: Text("Change Address")),
      body: Container(
      width: unitwidth*100,height: unitheight*80,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Text(address,  style: GoogleFonts.montserrat(
      textStyle: TextStyle(
       color: Colors.black,
        fontSize: unitwidth*4,fontWeight: FontWeight.w600 )),textScaleFactor: 1),
        SizedBox(height: unitheight*5,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           Container(width: unitwidth*80,height: unitwidth*25, margin:EdgeInsets.symmetric(horizontal: unitwidth*0, vertical: unitwidth*2),child: TextFormField(
      textInputAction: TextInputAction.done,
      style: GoogleFonts.montserrat(
      textStyle: TextStyle(
       color: Colors.black,
        fontSize: 18 * 1)),
  decoration:InputDecoration(
     border: OutlineInputBorder(
     borderRadius: BorderRadius.all(
     Radius.circular(4))),
    hintText: '192.192.192.192',
    hintStyle: GoogleFonts.montserrat(
                                          textStyle: TextStyle(
                                              color: Colors.black.withOpacity(0.4),
                                              fontSize: unitwidth *
                                                  1 *
                                                  3)),
                                                  prefixIcon:  Icon(FontAwesomeIcons.rupeeSign ,  color: Colors.blue,size:unitwidth* 4),
                                                  
  ),controller: first,
    autovalidateMode: AutovalidateMode.always, 
  keyboardType: TextInputType.number,
),),
        ],),

        SizedBox(height: unitheight*2,),
        MaterialButton(onPressed: (){
          //collectAddress();
          collectAddress();
          } , child: Container(width: unitwidth*40,height: unitheight*5,alignment: Alignment.center,decoration: BoxDecoration(color: Colors.blue , borderRadius: BorderRadius.all(Radius.circular(unitwidth*2))),child: Text("Submit",style: GoogleFonts.montserrat(
                                          textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: unitwidth *
                                                  1 *
                                                  3)),),),),
        //Container(width: unitwidth*100 , height: unitheight*10, color: Colors.cyan,)
      ],),
    ),
    );
  }
  collectAddress()async{
    //await Services().gettestUserData();
    String address = first.text;
     //http://192.168.29.253:8089
     print("Address "+address);
     Services.BASE_URL = "http://$address:8888";
     print("Address "+ Services.BASE_URL);
     //SharedPr
     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
     sharedPreferences.setString("serverAddress", "http://$address:8888");
     Navigator.pop(context);
  }

   getAddress()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
   setState(() {
      address = preferences.getString("serverAddress")??"NO Address";
   });

  }


}