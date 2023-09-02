import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_management/Server/Services.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

class MonthlyTransaction extends StatefulWidget {
  const MonthlyTransaction({super.key});

  @override
  State<MonthlyTransaction> createState() => _MonthlyTransactionState();
}

class _MonthlyTransactionState extends State<MonthlyTransaction> {
  DateTime? dateTime = DateTime.now();
  @override
  Widget build(BuildContext context) {
    double texscale =0.9;
        double unitwidth = MediaQuery.of(context).size.width / 100;
    double unitheight = MediaQuery.of(context).size.height / 100;
    return  Scaffold(appBar: AppBar(title: Text("Monthly Transaction")),
      body: Container(
      width: unitwidth*100,height: unitheight*100,color: Colors.grey[900],
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      Container(width: unitwidth*30,height: unitheight*5 ,alignment: Alignment.center, child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Text("Selected Date ", style:  GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                                color: Colors.white.withOpacity(0.7),fontWeight: FontWeight.w600,
                                                fontSize: unitwidth *
                                                    1 *
                                                    3.5)),textScaleFactor: texscale,), 
                                                    Icon(Icons.calendar_month , color: Colors.white.withOpacity(0.7),)
      ],),),

      MaterialButton(  onPressed: ()async{
         final selected = await showMonthYearPicker(
   context: context,
   initialDate:dateTime!,
   firstDate: DateTime(2019 , 1),
   lastDate: DateTime.now(),

 );
 if(selected != null){
dateTime = selected;
 }
 
 setState(() {
   
 });
      },child: Container(width: unitwidth*20,height: unitheight*4, alignment: Alignment.center,color: Colors.white,child:         Text("select date", style:  GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                                color: Colors.black.withOpacity(0.7),fontWeight: FontWeight.w600,
                                                fontSize: unitwidth *
                                                    1 *
                                                    3.5)),textScaleFactor: texscale,))),
      Container(width: unitwidth*25 ,alignment: Alignment.center, height: unitheight*5,child:         AutoSizeText(DateFormat("MMMM-yyyy").format(dateTime!), style:  GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                                color: Colors.white.withOpacity(0.7),fontWeight: FontWeight.w600,
                                                fontSize: unitwidth *
                                                    1 *
                                                    3.5)),textScaleFactor: texscale,),)
    ],),


            FutureBuilder( future: getMonthlyTransaction(), builder: (context, snapshot) {
      if(!snapshot.hasData){
        return CircularProgressIndicator();

      }else{
       return Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [
       

          SizedBox(height: unitheight*5,),



           Container(width: unitwidth*100,height: unitheight*22, alignment: Alignment.center, child: 
            Row( 
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Column( 
                children: [
                    AutoSizeText("Total Month Fees ", textAlign: TextAlign.center,style:  GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                                color: Colors.white.withOpacity(0.7),fontWeight: FontWeight.w600,
                                                
                                                fontSize: unitwidth *
                                                    1 *
                                                    6.5)),textScaleFactor: texscale,),
                       
                    SizedBox(height: unitheight*1,),
                    Divider(thickness: unitwidth*0.9,color: Colors.white),
                    //Divider(color:Colors.white.withOpacity(0.7) ,height: unitheight*0.5 , ),
                    SizedBox(height: unitheight*1,),
                    Row(  mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                     Container(width: unitwidth*40 ,height: unitheight*7,alignment: Alignment.center, child: 
                      Column(children: [
                        AutoSizeText("Online", textAlign: TextAlign.center,style:  GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                                color: Colors.green.withOpacity(0.7),fontWeight: FontWeight.w600,
                                                
                                                fontSize: unitwidth *
                                                    1 *
                                                    4.5)),textScaleFactor: texscale,),

                      SizedBox(height: unitheight*1,),
                      AutoSizeText("${snapshot.data!["Online"]}", textAlign: TextAlign.center,style:  GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                                color: Colors.white.withOpacity(0.7),fontWeight: FontWeight.w600,
                                                
                                                fontSize: unitwidth *
                                                    1 *
                                                    4.5)),textScaleFactor: texscale,)
                      ],),),
                      Container(width: unitwidth*40 ,height: unitheight*7,alignment: Alignment.center, child: 
                      Column(children: [
                        AutoSizeText("offline", textAlign: TextAlign.center,style:  GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                                color: Colors.red.withOpacity(0.7),fontWeight: FontWeight.w600,
                                                
                                                fontSize: unitwidth *
                                                    1 *
                                                    4.5)),textScaleFactor: texscale,),

                      SizedBox(height: unitheight*1,),
                      AutoSizeText("${snapshot.data!["Offline"]}", textAlign: TextAlign.center,style:  GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                                color: Colors.white.withOpacity(0.7),fontWeight: FontWeight.w600,
                                                
                                                fontSize: unitwidth *
                                                    1 *
                                                    4.5)),textScaleFactor: texscale,)
                      ],),),
                      

                    ],),
                    SizedBox(height: unitheight*3,),
                     Container(width: unitwidth*90 ,height: unitheight*5,alignment: Alignment.center, child: 
                      Column(children: [
                        AutoSizeText("Grand Total - ${snapshot.data!["total"]}", textAlign: TextAlign.center,style:  GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                                color: Colors.white.withOpacity(0.7),fontWeight: FontWeight.w600,
                                                
                                                fontSize: unitwidth *
                                                    1 *
                                                    4.5)),textScaleFactor: texscale,),

                      
                      // AutoSizeText("${snapshot.data!["gym"]}", textAlign: TextAlign.center,style:  GoogleFonts.montserrat(
                      //                       textStyle: TextStyle(
                      //                           color: Colors.white.withOpacity(0.7),fontWeight: FontWeight.w600,
                                                
                      //                           fontSize: unitwidth *
                      //                               1 *
                      //                               4.5)),textScaleFactor: texscale,)
                      ],),),
              ],),
              
            ],)  ),

        
        ],
       );
      }
    })

        //Container(width: unitwidth*100 , height: unitheight*10, color: Colors.cyan,)
      ],),
    ),
    );
  }
  Future<Map<String, String>> getMonthlyTransaction()async{
    var respones;
    String date = DateTime(dateTime!.year ,dateTime!.month ).toString();
    respones = await Services().getMonthlyFees(date);
    int online = 0;
    int offline =0;
    int grandTotal =0;
    
    for(var data in respones){
      if(data["paymentMode"] == "online"){
        online = online + int.parse(data["amount"].toString());
      }else{
        offline = offline + int.parse(data["amount"].toString());
      }
      grandTotal = grandTotal + int.parse(data["amount"].toString());
    }
    //grandTotal = online + offline;
    print("Monthly fees "+respones.toString());
    return {"total":"$grandTotal" , "Online":"$online" ,"Offline":"$offline"};
  }
}