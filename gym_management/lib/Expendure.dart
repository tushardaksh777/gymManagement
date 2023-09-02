import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_management/Server/Services.dart';
import 'package:gym_management/editExpenses.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

class Expendure extends StatefulWidget {
  const Expendure({super.key});

  @override
  State<Expendure> createState() => _ExpendureState();
}

class _ExpendureState extends State<Expendure> with TickerProviderStateMixin{
       TabController? _tabController;
        int tabIndex = 0;
        DateTime? totalExpendureDateTime = DateTime.now();
        int gymLength =0;
        int otherLength =0;
        int totalLength =0;
        DateTime expenseDate = DateTime.now();


        @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkforLength();
  }
  @override
  Widget build(BuildContext context) {
            String  expenseDateShow =""+ DateFormat("dd").format(expenseDate) + "  "  +DateFormat("MMMM").format(expenseDate)+"  "+ DateFormat("y").format(expenseDate);


    double texscale =0.9;
    _tabController =  new TabController(length: 3, vsync: this , initialIndex: tabIndex);
        double unitwidth = MediaQuery.of(context).size.width / 100;
    double unitheight = MediaQuery.of(context).size.height / 100;
    return Container(width: unitwidth*100,height: unitheight*100, color: Colors.grey[900] , child:RefreshIndicator(
              onRefresh: reload,
              child: Column(children: [
                if(tabIndex != 2)
                        Container(width: unitwidth*90,height: unitwidth*13, margin:EdgeInsets.symmetric(horizontal: unitwidth*7, vertical: unitwidth*2),child: 
Row(children: [
  SizedBox(width: unitwidth*3,),
  Icon(Icons.date_range , color: Colors.white,size:unitwidth* 4),
    SizedBox(width: unitwidth*2,),
  AutoSizeText("Expenses Date",
      style: GoogleFonts.montserrat(
      textStyle: TextStyle(
       color: Colors.white,
        fontSize: unitwidth*3)),textScaleFactor: texscale,
  
),
SizedBox(width: unitwidth* 5,),
Container(width: unitwidth*18,height: unitheight*3.5,alignment: Alignment.center,decoration: BoxDecoration(color: Colors.white.withOpacity(0.7) , borderRadius: BorderRadius.all(Radius.circular(unitwidth*1.5))),
child: MaterialButton(padding: EdgeInsets.zero,onPressed: ()async{

final selected = await showMonthYearPicker(
   context: context,
   initialMonthYearPickerMode:MonthYearPickerMode.month,
   initialDate:expenseDate,
   firstDate: DateTime(2019 , 1),
   lastDate: DateTime.now(),

 );
 if(selected != null){
  setState(() {
        expenseDate = selected;
 expenseDateShow =""+ DateFormat("dd").format(expenseDate) + "  "  +DateFormat("MMMM").format(expenseDate)+"  "+ DateFormat("y").format(expenseDate);
       });

       checkforLength();

 }

}, child: Text("Pick A Date" , style: GoogleFonts.montserrat(
      textStyle: TextStyle(
       color: Colors.black,
        fontSize: unitwidth*2.5 , fontWeight: FontWeight.w600)),textScaleFactor: texscale)),
),
  SizedBox(width: unitwidth*8,),
  Text(expenseDateShow,
      style: GoogleFonts.montserrat(
      textStyle: TextStyle(
       color: Colors.white,
        fontSize: unitwidth*3 , fontWeight: FontWeight.w500)),textScaleFactor: texscale
  
),
],),
),
      Column(
        children: [
          Container(width: unitwidth*100,height: unitheight*8,
            child: TabBar(
              automaticIndicatorColorAdjustment: false,
              tabs: [
  Tab(child: Text("Gym Expenses ($gymLength)" , style:  GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                                color: Colors.white.withOpacity(0.7),fontWeight: FontWeight.w500,
                                                fontSize: unitwidth *
                                                    1 *
                                                    3)),textScaleFactor: texscale),),
Tab(child:AutoSizeText("Other Expenses ($otherLength)" , style:  GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                                color: Colors.white.withOpacity(0.7),fontWeight: FontWeight.w500,
                                                fontSize: unitwidth *
                                                    1 *
                                                    2.4)),textScaleFactor: texscale,),),
        Tab(child:Text("Total Expenses" , style:  GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                                color: Colors.white.withOpacity(0.7),fontWeight: FontWeight.w500,
                                                fontSize: unitwidth *
                                                    1 *
                                                    3.5)),textScaleFactor: texscale),),
] , controller: _tabController, onTap: _onItemTapped , indicatorColor: Colors.blue ,indicatorWeight: unitwidth*0.5,)
            ),
if(tabIndex != 2)
FutureBuilder(future: getExpenses() ,builder: (context, snapshot) {
  if(!snapshot.hasData)
  return CircularProgressIndicator();
  else {
    return Container(width: unitwidth*100 , height: unitheight*65,child: 
    ListView(
      shrinkWrap: true,
      children: [
    Column(
      children: [
        for (var i = 0; i < snapshot.data!.length; i++) 
         getExpenseList(unitwidth, unitheight  , snapshot.data![i])
      ],
    )
    ],)
    ,);
    
      
    
   
  }
  }),
  if(tabIndex == 2)
  Column(children: [
    SizedBox(height: unitheight*2,),
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
   initialDate:totalExpendureDateTime!,
   firstDate: DateTime(2019 , 1),
   lastDate: DateTime.now(),

 );
 if(selected != null){
totalExpendureDateTime = selected;
 }
 
 setState(() {
   
 });
      },child: Container(width: unitwidth*20,height: unitheight*4, alignment: Alignment.center,color: Colors.white,child:         Text("select date", style:  GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                                color: Colors.black.withOpacity(0.7),fontWeight: FontWeight.w600,
                                                fontSize: unitwidth *
                                                    1 *
                                                    3.5)),textScaleFactor: texscale,))),
      Container(width: unitwidth*25 ,alignment: Alignment.center, height: unitheight*5,child:         AutoSizeText(DateFormat("MMMM-yyyy").format(totalExpendureDateTime!), style:  GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                                color: Colors.white.withOpacity(0.7),fontWeight: FontWeight.w600,
                                                fontSize: unitwidth *
                                                    1 *
                                                    3.5)),textScaleFactor: texscale,),)
    ],),


    FutureBuilder( future: getTotalExpensesList(), builder: (context, snapshot) {
      //print("total exp "+snapshot.data.toString());
      if(!snapshot.hasData){
        return CircularProgressIndicator();

      }else{
       return Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [
       
          Container(width: unitwidth*100,height: unitheight*65,
            child: ListView(shrinkWrap: true,
              children: [
                          SizedBox(height: unitheight*5,),
          
          
          
             Container(width: unitwidth*100,height: unitheight*22, alignment: Alignment.center, child: 
              Row( 
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Column( 
                  children: [
                      AutoSizeText("Total Gym Expenses ", textAlign: TextAlign.center,style:  GoogleFonts.montserrat(
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
                        AutoSizeText("${snapshot.data!["gymOnline"]}", textAlign: TextAlign.center,style:  GoogleFonts.montserrat(
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
                        AutoSizeText("${snapshot.data!["gymOffline"]}", textAlign: TextAlign.center,style:  GoogleFonts.montserrat(
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
                          AutoSizeText("Grand Total - ${snapshot.data!["gym"]}", textAlign: TextAlign.center,style:  GoogleFonts.montserrat(
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
            SizedBox(height: unitheight*2,),
             Container(width: unitwidth*100,height: unitheight*22, alignment: Alignment.center, child: 
              Row( 
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Column( 
                  children: [
                      AutoSizeText("Total Other Expenses ", textAlign: TextAlign.center,style:  GoogleFonts.montserrat(
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
                        AutoSizeText("${snapshot.data!["otherOnline"]}", textAlign: TextAlign.center,style:  GoogleFonts.montserrat(
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
                        AutoSizeText("${snapshot.data!["otherOffline"]}", textAlign: TextAlign.center,style:  GoogleFonts.montserrat(
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
                          AutoSizeText("Grand Total - ${snapshot.data!["other"]}", textAlign: TextAlign.center,style:  GoogleFonts.montserrat(
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
            Divider(color: Colors.white,),
          
            Container(width: unitwidth*100,height: unitheight*70,
            
            child: Column(children: [
              
               Container(width: unitwidth*100,height: unitheight*5,child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                
               Container(width: unitwidth*20,height: unitheight*5,alignment: Alignment.center, child: AutoSizeText("Category", textAlign: TextAlign.center,style:  GoogleFonts.montserrat(
                                              textStyle: TextStyle(
                                                  color: Colors.white.withOpacity(0.7),fontWeight: FontWeight.w600,
                                                  
                                                  fontSize: unitwidth *
                                                      1 *
                                                      4.5)),textScaleFactor: texscale,),),
                                                      
              Container(width: unitwidth*20,height: unitheight*5,alignment: Alignment.center, child: AutoSizeText("Online", textAlign: TextAlign.center,style:  GoogleFonts.montserrat(
                                              textStyle: TextStyle(
                                                  color: Colors.green.withOpacity(0.7),fontWeight: FontWeight.w600,
                                                  
                                                  fontSize: unitwidth *
                                                      1 *
                                                      4.5)),textScaleFactor: texscale,),),
              Container(width: unitwidth*20,height: unitheight*5,alignment: Alignment.center, child: AutoSizeText("Offline", textAlign: TextAlign.center,style:  GoogleFonts.montserrat(
                                              textStyle: TextStyle(
                                                  color: Colors.red.withOpacity(0.7),fontWeight: FontWeight.w600,
                                                  
                                                  fontSize: unitwidth *
                                                      1 *
                                                      4.5)),textScaleFactor: texscale,),),

              Container(width: unitwidth*20,height: unitheight*5,alignment: Alignment.center, child: AutoSizeText("Total", textAlign: TextAlign.center,style:  GoogleFonts.montserrat(
                                              textStyle: TextStyle(
                                                  color: Colors.white.withOpacity(0.7),fontWeight: FontWeight.w600,
                                                  
                                                  fontSize: unitwidth *
                                                      1 *
                                                      4.5)),textScaleFactor: texscale,),),

              ],),),
              Divider(color: Colors.white,),
              getCategoryExpensesLitview("Grocery", "${snapshot.data!["grocery_online"]}", "${snapshot.data!["grocery_offline"]}", "${snapshot.data!["grocery"]}", unitwidth, unitheight, texscale),
              getCategoryExpensesLitview("Offline Shopping", "${snapshot.data!["offlineshopping_online"]}", "${snapshot.data!["offlineshopping_offline"]}", "${snapshot.data!["offlineshopping"]}", unitwidth, unitheight, texscale),
              getCategoryExpensesLitview("Online Shopping", "${snapshot.data!["onlineshoppong_online"]}", "${snapshot.data!["onlineshoppong_offline"]}", "${snapshot.data!["onlineshoppong"]}", unitwidth, unitheight, texscale),
              getCategoryExpensesLitview("Home And Electricity", "${snapshot.data!["homeAndElc_online"]}", "${snapshot.data!["homeAndElc_offline"]}", "${snapshot.data!["homeAndElc"]}", unitwidth, unitheight, texscale),
              getCategoryExpensesLitview("Oil", "${snapshot.data!["oil_online"]}", "${snapshot.data!["oil_offline"]}", "${snapshot.data!["oil"]}", unitwidth, unitheight, texscale),
              getCategoryExpensesLitview("EMI", "${snapshot.data!["emi_online"]}", "${snapshot.data!["emi_offline"]}", "${snapshot.data!["emi"]}", unitwidth, unitheight, texscale),
              getCategoryExpensesLitview("Recharge", "${snapshot.data!["recharge_online"]}", "${snapshot.data!["recharge_offline"]}", "${snapshot.data!["recharge"]}", unitwidth, unitheight, texscale),
              getCategoryExpensesLitview("Other", "${snapshot.data!["othercategory_online"]}", "${snapshot.data!["othercategory_offline"]}", "${snapshot.data!["othercategory"]}", unitwidth, unitheight, texscale),

            ],),
            ),
          
              ],
            ),
          ),

        ],
       );
      }
    })
  ],)
            
        ],
      )
    ],)));

  }
      Future<void> reload() async {
     checkforLength();
   
    return setState(() {});
  }
      _onItemTapped(int index){
    setState(() {
      tabIndex =index;
    });

  }
    checkforLength()async{
    var i = await Services().getGymExpenses(expenseDate.toString());
    var other = await Services().getOtherExpenses(expenseDate.toString());
    
    print("Gym length "+i.length.toString());
       print("Other length "+other.length.toString());
    
    setState(() {
       if(i !=null){
      gymLength = i.length;
       }
     
    if(other !=null ){
    otherLength = other.length;
    }
    });



  }

  Future<Map> getTotalExpensesList()async{
    var respones;
    String date = DateTime(totalExpendureDateTime!.year ,totalExpendureDateTime!.month ).toString();
    respones = await Services().getTotalExpenses(date);
   // print("Total expendure "+respones.toString());
    int? gymTotal = 0;
    int gymtotalonline =0;
    int gymtotaloffline =0;
    int othertotalonline =0;
    int othertotaloffline =0;
    int? otherTotal =0 ;

        int grocery =0;
    int offlineshopping =0;
    int onlineshoppong =0;
    int homeAndElc =0;
    int oil =0;
    int emi =0;
    int recharge =0;
    int othercategory=0;
    
    int grocery_online =0;
    int offlineshopping_online =0;
    int onlineshoppong_online =0;
    int homeAndElc_online =0;
    int oil_online =0;
    int emi_online =0;
    int recharge_online =0;
    int othercategory_online=0;

    int grocery_offline =0;
    int offlineshopping_offline =0;
    int onlineshoppong_offline =0;
    int homeAndElc_offline =0;
    int oil_offline =0;
    int emi_offline =0;
    int recharge_offline =0;
    int othercategory_offline =0;


    if(respones != null){
      for(var data in respones){

      if(data["expenses"] == "gym"){
        gymTotal = gymTotal! + int.parse(data["amount"].toString());
        if(data["paymentMode"]=="offline"){
           gymtotaloffline = gymtotaloffline + int.parse(data["amount"].toString());
        }else{
          gymtotalonline = gymtotalonline + int.parse(data["amount"].toString());
        }
      }else{
        otherTotal = otherTotal! + int.parse(data["amount"].toString());
        if(data["paymentMode"]=="offline"){
           othertotaloffline = othertotaloffline + int.parse(data["amount"].toString());
        }else{
          othertotalonline = othertotalonline + int.parse(data["amount"].toString());
        }
      }


      //calculating category
       var cat = data["expensesCategory"];
       switch (cat) {
         case "grocery":
           if(data["paymentMode"]=="offline"){
           grocery_offline = grocery_offline + int.parse(data["amount"].toString());
           }else{
           grocery_online = grocery_online + int.parse(data["amount"].toString());
           }
           grocery = grocery + int.parse(data["amount"].toString());
           break;
        case "offlineShopping":
           if(data["paymentMode"]=="offline"){
           offlineshopping_offline = offlineshopping_offline + int.parse(data["amount"].toString());
           }else{
           offlineshopping_online = offlineshopping_online + int.parse(data["amount"].toString());            
           }
           offlineshopping = offlineshopping + int.parse(data["amount"].toString());
           break;
        case "onlineShopping":
           if(data["paymentMode"]=="offline"){
           onlineshoppong_offline = onlineshoppong_offline + int.parse(data["amount"].toString());
           }else{
           onlineshoppong_online = onlineshoppong_online + int.parse(data["amount"].toString());            
           }
           onlineshoppong = onlineshoppong + int.parse(data["amount"].toString());
           break;
        case "homeAndElectricity":
           if(data["paymentMode"]=="offline"){
           homeAndElc_offline = homeAndElc_offline + int.parse(data["amount"].toString());
           }else{
           homeAndElc_online = homeAndElc_online + int.parse(data["amount"].toString());            
           }
           homeAndElc = homeAndElc + int.parse(data["amount"].toString());
           break;
        case "Oil":
           if(data["paymentMode"]=="offline"){
           oil_offline = oil_offline + int.parse(data["amount"].toString());
           }else{
           oil_online = oil_online + int.parse(data["amount"].toString());            
           }
           oil = oil + int.parse(data["amount"].toString());
           break;
        case "EMI":
           if(data["paymentMode"]=="offline"){
           emi_offline = emi_offline + int.parse(data["amount"].toString());
           }else{
           emi_online = emi_online + int.parse(data["amount"].toString());            
           }
           emi = emi + int.parse(data["amount"].toString());
           break;      
        case "Recharge":
           if(data["paymentMode"]=="offline"){
           recharge_offline = recharge_offline + int.parse(data["amount"].toString());
           }else{
           recharge_online = recharge_online + int.parse(data["amount"].toString());            
           }
           recharge = recharge + int.parse(data["amount"].toString());
           break;
        case "Other":
           if(data["paymentMode"]=="offline"){
           othercategory_offline = othercategory_offline + int.parse(data["amount"].toString());
           }else{
           othercategory_online = othercategory_online + int.parse(data["amount"].toString());            
           }
           othercategory = othercategory + int.parse(data["amount"].toString());
           break;   
         default:
       }
    

    }
    }



  //rint("Category map "+ categoryMap.toString());
    return {"gym":"$gymTotal" , "other":"$otherTotal" , "gymOnline":"$gymtotalonline" , "gymOffline":"$gymtotaloffline" , "otherOnline":"$othertotalonline" , "otherOffline":"$othertotaloffline" , "grocery":grocery.toString() ,"offlineshopping":offlineshopping.toString() ,"onlineshoppong":onlineshoppong.toString() , "homeAndElc":homeAndElc.toString() ,"oil":oil.toString() , "emi":emi.toString() , "recharge":"$recharge"  ,"othercategory":"$othercategory" , "grocery_online":grocery_online.toString() ,"offlineshopping_online":offlineshopping_online.toString() ,"onlineshoppong_online":onlineshoppong_online.toString() , "homeAndElc_online":homeAndElc_online.toString() ,"oil_online":oil_online.toString() , "emi_online":emi_online.toString() , "recharge_online":"$recharge_online"  ,"othercategory_online":"$othercategory_online" ,"grocery_offline":grocery_offline.toString() ,"offlineshopping_offline":offlineshopping_offline.toString() ,"onlineshoppong_offline":onlineshoppong_offline.toString() , "homeAndElc_offline":homeAndElc_offline.toString() ,"oil_offline":oil_offline.toString() , "emi_offline":emi_offline.toString() , "recharge_offline":"$recharge_offline"  ,"othercategory_offline":"$othercategory_offline"   };
  }

   getCategoryMap(var data)async{
    int grocery =0;
    int offlineshopping =0;
    int onlineshoppong =0;
    int homeAndElc =0;
    int oil =0;
    int emi =0;
    int recharge =0;
    int othercategory=0;
    
    int grocery_online =0;
    int offlineshopping_online =0;
    int onlineshoppong_online =0;
    int homeAndElc_online =0;
    int oil_online =0;
    int emi_online =0;
    int recharge_online =0;
    int othercategory_online=0;

    int grocery_offline =0;
    int offlineshopping_offline =0;
    int onlineshoppong_offline =0;
    int homeAndElc_offline =0;
    int oil_offline =0;
    int emi_offline =0;
    int recharge_offline =0;
    int othercategory_offline =0;
 
    

     for(var item in data){
     


    }
    print("grocy "+ othercategory.toString());

    return {"grocery":grocery.toString() ,"offlineshopping":offlineshopping.toString() ,"onlineshoppong":onlineshoppong.toString() , "homeAndElc":homeAndElc.toString() ,"oil":oil.toString() , "emi":emi.toString() , "recharge":"$recharge"  ,"othercategory":"$othercategory" , "grocery_online":grocery_online.toString() ,"offlineshopping_online":offlineshopping_online.toString() ,"onlineshoppong_online":onlineshoppong_online.toString() , "homeAndElc_online":homeAndElc_online.toString() ,"oil_online":oil.toString() , "emi_online":emi_online.toString() , "recharge_online":"$recharge_online"  ,"othercategory_online":"$othercategory_online" ,"grocery_offline":grocery_offline.toString() ,"offlineshopping_offline":offlineshopping_offline.toString() ,"onlineshoppong_offline":onlineshoppong_offline.toString() , "homeAndElc_offline":homeAndElc_offline.toString() ,"oil_offline":oil_offline.toString() , "emi_offline":emi_offline.toString() , "recharge_offline":"$recharge_offline"  ,"othercategory_offline":"$othercategory_offline"   };

  }




  Future<List<dynamic>> getExpenses()async {
     
     var data;
    if(tabIndex == 0){
    data = await Services().getGymExpenses(expenseDate.toString());
    }else{
    data = await Services().getOtherExpenses(expenseDate.toString());
    }
    //     data.sort((a, b) {
    //   DateTime aDT = DateTime.parse(data["date"]);
    //   DateTime bDT = DateTime.parse(data["date"]);
     
    //   return aDT.compareTo(bDT);
    // });
   // print("Expense "+ data.toString());
    return data;

  }

  getExpenseList(double width , double height , Map<dynamic , dynamic> data){
    double textscale =0.9;
 // print("Expenses "+data.toString() +" title "+data["title"]);
  return Container(width: width*100,height: height*10,child: 
  Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Container(width: width*70,height: height*10, decoration: BoxDecoration(color: Colors.grey.shade800 ,  borderRadius: BorderRadius.all(Radius.circular(10)),) , alignment: Alignment.center,margin:EdgeInsets.symmetric(horizontal: width*1 , vertical: height*1.2) ,
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    //crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Column(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
      Text(DateFormat("dd").format(DateTime.parse(data["date"])), style:  GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                                color: Colors.white.withOpacity(0.7),fontWeight: FontWeight.w600,
                                                fontSize: width *
                                                    1 *
                                                    3.5)) , textScaleFactor: textscale),
SizedBox(height: height*0.2,),
Text(DateFormat("MMMM").format(DateTime.parse(data["date"])), style:  GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                                color: Colors.white.withOpacity(0.7),fontWeight: FontWeight.w600,
                                                fontSize: width *
                                                    1 *
                                                    3)), textScaleFactor: textscale),
                                                    SizedBox(height: height*0.2,),
Text(DateFormat("yyyy").format(DateTime.parse(data["date"])), style:  GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                                color: Colors.white.withOpacity(0.7),fontWeight: FontWeight.w600,
                                                fontSize: width *
                                                    1 *
                                                    3))),
    // Text("Note -  fix for trademil motor", style:  GoogleFonts.montserrat(
    //                                         textStyle: TextStyle(
    //                                             color: Colors.white.withOpacity(0.7),fontWeight: FontWeight.w600,
    //                                             fontSize: width *
    //                                                 1 *
    //                                                 2.5)))     
],)  ,
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
      Text(data["title"].toString(), style:  GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                                color: Colors.white.withOpacity(0.7),fontWeight: FontWeight.w600,
                                                fontSize: width *
                                                    1 *
                                                    4.5)), textScaleFactor: textscale),
SizedBox(height: height*1,),
    Text("Note - ${data["note"]}", style:  GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                                color: Colors.white.withOpacity(0.7),fontWeight: FontWeight.w600,
                                                fontSize: width *
                                                    1 *
                                                    3)))     
],)    ,
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
      Text("₹ ${data["amount"]}", style:  GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                                color: Colors.white.withOpacity(0.7),fontWeight: FontWeight.w600,
                                                fontSize: width *
                                                    1 *
                                                    5))),
SizedBox(height: height*0.2,),
    Text(data["paymentMode"].toString(), style:  GoogleFonts.montserrat(
                                            textStyle: TextStyle(
                                                color: Colors.white.withOpacity(0.7),fontWeight: FontWeight.w600,
                                                fontSize: width *
                                                    1 *
                                                    3)))     
],),
             
  ],),
  ),
  MaterialButton(onPressed: (){
    Navigator.push(context, MaterialPageRoute(builder: ((context) => EditExpenses(data: data,))));
  }, minWidth: width*5, height: height*5 , padding: EdgeInsets.zero  ,child: Container(width: width*5,height: height*5,child: Icon(Icons.edit , color: Colors.white.withOpacity(0.7),),)),
MaterialButton( onPressed: (){
  removeDialog(context, data);
},minWidth: width*5, height: height*5 , padding: EdgeInsets.zero  ,child: Container(width: width*5,height: height*5,child: Icon(Icons.delete , color: Colors.white.withOpacity(0.7)),)),       
  ],)
  );  
  }

       removeDialog(BuildContext context , var data) {
    double textscalefactor = 0.8;
    double unitwidth = MediaQuery.of(context).size.width / 100;
    AlertDialog alertDialog = AlertDialog(
      title: Text(
        "Remove attandance",
        style: GoogleFonts.montserrat(
            textStyle: TextStyle(color: Colors.black, fontSize: unitwidth * 5)),
      ),
      content: Text(
        "Are You sure ! You want to remove ?\n Expense Title . ${data["title"]} \n Amount - ${data["amount"]} \n Date - ${data["date"]}",
        textAlign: TextAlign.center,
        style: GoogleFonts.montserrat(
            textStyle:
                TextStyle(color: Colors.black, fontSize: unitwidth * 3.1 , fontWeight: FontWeight.w500)),
        textScaleFactor: textscalefactor,
      ),
      actions: [
        MaterialButton(
          onPressed: () async {
            deleteExpenses(data["id"]);
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
    deleteExpenses(int id)async{
   var response = await Services().deleteExpenses(id.toString());
   //print("Delete Attandace "+ response.toString());
   Navigator.pop(context);
   setState(() {
     
   });
  }

  getCategoryExpensesLitview(String cat , String online, String offline , String total , double unitwidth , double unitheight , double texscale){
    return Container(width: unitwidth*100,height: unitheight*5,child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                
               Container(width: unitwidth*20,height: unitheight*5,alignment: Alignment.center,child: FittedBox(fit: BoxFit.fill,child: 
              AutoSizeText(cat, textAlign: TextAlign.center,style:  GoogleFonts.montserrat(
                                              textStyle: TextStyle(
                                                  color: Colors.white.withOpacity(0.7),fontWeight: FontWeight.w600,
                                                  
                                                  fontSize: unitwidth *
                                                      1 *
                                                      4.5)),textScaleFactor: texscale,)
              ,),),
              Container(width: unitwidth*20,height: unitheight*5,alignment: Alignment.center,child: FittedBox(fit: BoxFit.fill,child: 
              AutoSizeText(online, textAlign: TextAlign.center,style:  GoogleFonts.montserrat(
                                              textStyle: TextStyle(
                                                  color: Colors.white.withOpacity(0.7),fontWeight: FontWeight.w600,
                                                  
                                                  fontSize: unitwidth *
                                                      1 *
                                                      4.5)),textScaleFactor: texscale,)
              ,),),
              Container(width: unitwidth*20,height: unitheight*5,alignment: Alignment.center, child: FittedBox(fit: BoxFit.fill,child: 
              AutoSizeText(offline, textAlign: TextAlign.center,style:  GoogleFonts.montserrat(
                                              textStyle: TextStyle(
                                                  color: Colors.white.withOpacity(0.7),fontWeight: FontWeight.w600,
                                                  
                                                  fontSize: unitwidth *
                                                      1 *
                                                      4.5)),textScaleFactor: texscale,)
              ,),),

              Container(width: unitwidth*20,height: unitheight*5,alignment: Alignment.center,child: FittedBox(fit: BoxFit.fill,child: 
              AutoSizeText(total, textAlign: TextAlign.center,style:  GoogleFonts.montserrat(
                                              textStyle: TextStyle(
                                                  color: Colors.white.withOpacity(0.7),fontWeight: FontWeight.w600,
                                                  
                                                  fontSize: unitwidth *
                                                      1 *
                                                      4.5)),textScaleFactor: texscale,)
              ,),),

              ],),);
  }
}