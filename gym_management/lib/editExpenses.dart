import 'package:achievement_view/achievement_view.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_management/Server/Services.dart';
import 'package:gym_management/globalData.dart';
import 'package:intl/intl.dart';

class EditExpenses extends StatefulWidget {
  var data;
  EditExpenses({super.key, required this.data});

  @override
  State<EditExpenses> createState() => _EditExpensesState();
}

class _EditExpensesState extends State<EditExpenses> {
  String selectDateShow = "00-00-0000";
  DateTime? selectDate = DateTime.now();
  expense exp = expense.gym;
  paymentMode payment = paymentMode.online;
  List<String> items = [
    'Grocery',
    'Offline Shopping',
    'Online Shopping',
    'Home And Electricity',
    'Oil',
    'EMI',
    'Recharge',
    'Other',
  ];
  List<String> category = [
    'grocery',
    'offlineShopping',
    'onlineShopping',
    'homeAndElectricity',
    'Oil',
    'EMI',
    'Recharge',
    'Other',
  ];
  String? selectedValue;
  TextEditingController titleController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    collectValues();
  }

  @override
  Widget build(BuildContext context) {
    List<String> list = <String>['One', 'Two', 'Three', 'Four'];
    String dropdownValue = list.first;

    double unitwidth = MediaQuery.of(context).size.width / 100;
    double unitheight = MediaQuery.of(context).size.height / 100;
    return Scaffold(
        appBar: AppBar(
            title: Text("Add Expenses"),
            backgroundColor: Colors.grey[900],
            shadowColor: Colors.transparent),
        backgroundColor: Colors.grey[900],
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            checkForValues(context);

            //validateData();
            //askingDialog(context);
          },
          child: const Icon(Icons.check),
        ),
        body: Container(
            color: Colors.grey[900],
            child: ListView(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Container(
                    width: unitwidth * 100,
                    height: unitwidth * 13,
                    child: Theme(
                        data: Theme.of(context).copyWith(
                            unselectedWidgetColor: Colors.white,
                            disabledColor: Colors.blue),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                    value: expense.gym,
                                    groupValue: exp,
                                    onChanged: (onChanged) {
                                      setState(() {
                                        print(
                                            "Radio 1" + onChanged!.toString());
                                        exp = onChanged;
                                      });
                                    },
                                    activeColor: Colors.white),
                                Text(
                                  "Gym Expenses",
                                  style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: unitwidth * 1 * 3)),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                    value: expense.other,
                                    groupValue: exp,
                                    onChanged: (onChanged) {
                                      setState(() {
                                        print(
                                            "Radio 1" + onChanged!.toString());
                                        exp = onChanged;
                                      });
                                    },
                                    activeColor: Colors.white),
                                Text(
                                  "Other Expenses",
                                  style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: unitwidth * 1 * 3)),
                                )
                              ],
                            ),
                          ],
                        ))),

                Container(
                    width: unitwidth * 100,
                    height: unitwidth * 10,
                    margin: EdgeInsets.symmetric(
                        horizontal: unitwidth * 7, vertical: unitwidth * 2),
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: DropdownButton(
                      dropdownColor: Colors.grey[900],
                      menuMaxHeight: unitwidth * 80,
                      items: items.map(
                        (String e) {
                          return DropdownMenuItem(
                              value: e,
                              child: AutoSizeText(
                                e,
                                style: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontWeight: FontWeight.w600,
                                        fontSize: unitwidth * 1 * 3.5)),
                              ));
                        },
                      ).toList(),
                      hint: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AutoSizeText(
                            "Select Category",
                            style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontWeight: FontWeight.w600,
                                    fontSize: unitwidth * 1 * 3.5)),
                          )
                        ],
                      ),
                      value: selectedValue,
                      isExpanded: true,
                      onChanged: (value) {
                        print("Value change " + value.toString());
                        setState(() {
                          selectedValue = value!;
                        });
                        // print("after changing value "+selectedValue.toString());
                      },
                    )),

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
                            TextStyle(color: Colors.white, fontSize: 18 * 1)),
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      hintText: 'Title',
                      hintStyle: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: unitwidth * 1 * 3)),
                      prefixIcon: Icon(FontAwesomeIcons.shoppingBag,
                          color: Colors.blue, size: unitwidth * 4),
                    ),
                    controller: titleController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter Title";
                      } else {
                        return "";
                      }
                    },
                    keyboardType: TextInputType.text,
                  ),
                ),
                Container(
                  width: unitwidth * 100,
                  height: unitwidth * 15,
                  margin: EdgeInsets.symmetric(
                      horizontal: unitwidth * 7, vertical: unitwidth * 2),
                  child: TextFormField(
                    textInputAction: TextInputAction.next,
                    style: GoogleFonts.montserrat(
                        textStyle:
                            TextStyle(color: Colors.white, fontSize: 18 * 1)),
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      hintText: 'Amount',
                      hintStyle: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: unitwidth * 1 * 3)),
                      prefixIcon: Icon(
                        FontAwesomeIcons.rupeeSign,
                        size: unitwidth * 4,
                        color: Colors.blue,
                      ),
                    ),
                    controller: amountController,
                    autovalidateMode: AutovalidateMode.always,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter Amount";
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
                    child: Theme(
                        data: Theme.of(context).copyWith(
                            unselectedWidgetColor: Colors.white,
                            disabledColor: Colors.blue),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                Radio(
                                    value: paymentMode.online,
                                    groupValue: payment,
                                    onChanged: (onChanged) {
                                      setState(() {
                                        payment = onChanged!;
                                      });
                                    },
                                    activeColor: Colors.white),
                                Text(
                                  "Online",
                                  style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: unitwidth * 1 * 3)),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                    value: paymentMode.offline,
                                    groupValue: payment,
                                    onChanged: (onChanged) {
                                      setState(() {
                                        payment = onChanged!;
                                      });
                                    },
                                    activeColor: Colors.white),
                                Text(
                                  "Offline",
                                  style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: unitwidth * 1 * 3)),
                                )
                              ],
                            ),
                          ],
                        ))),
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
                                color: Colors.white, fontSize: unitwidth * 3)),
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
                                          // print("Date "+value.toString());
                                          if (value != null) {
                                            selectDate = value;
                                            selectDateShow = "" +
                                                DateFormat("dd").format(value) +
                                                "  " +
                                                DateFormat("MMMM")
                                                    .format(value) +
                                                "  " +
                                                DateFormat("y").format(value);
                                          }
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
                        selectDateShow,
                        style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: unitwidth * 3,
                                fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                ),

//Note

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
                            TextStyle(color: Colors.white, fontSize: 18 * 1)),
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      hintText: 'Note*',
                      hintStyle: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: unitwidth * 1 * 3)),
                      prefixIcon: Icon(Icons.note,
                          color: Colors.blue, size: unitwidth * 4),
                    ),
                    controller: noteController,
                    keyboardType: TextInputType.text,
                  ),
                ),
              ])
            ])));
  }

  collectValues() {
    String title = (widget.data["title"] != null) ? widget.data["title"] : "";
    int amount = (widget.data["amount"] != null)
        ? int.parse(widget.data["amount"].toString())
        : 0;
    String note = (widget.data["note"] != null) ? widget.data["note"] : "";
    String date = (widget.data["date"] != null)
        ? DateTime.parse(widget.data["date"]).toString()
        : DateTime.now().toString();
    expense e =
        (widget.data["expenses"] == "gym") ? expense.gym : expense.other;
    paymentMode p = (widget.data["paymentMode"] == "online")
        ? paymentMode.online
        : paymentMode.offline;
    String expCategory = (widget.data["expensesCategory"] == null)
        ? "Other"
        : widget.data["expensesCategory"].toString();
    //print("Items "+items.toString());
    //print("Items "+widget.data.toString());
    //print("Cat "+category.toString() + " $expCategory "+ category.indexOf(expCategory).toString());

    setState(() {
      titleController.text = title;
      amountController.text = amount.toString();
      noteController.text = note;
      selectDate = DateTime.parse(date.toString());
      selectDateShow = "" +
          DateFormat("dd").format(selectDate!) +
          "  " +
          DateFormat("MMMM").format(selectDate!) +
          "  " +
          DateFormat("y").format(selectDate!);
      exp = e;
      payment = p;
    });
  }

  checkForValues(BuildContext context) {
    String title = titleController.text;
    int amount = int.parse(amountController.text);
    String note = noteController.text;
    String date = selectDate.toString();
    selectedValue ??= items.last;
    String? expCategory = category[items.indexOf(selectedValue!)];

    if (title.isNotEmpty && amount != 0) {
      askingDialog(context, widget.data["id"].toString(), title, amount, note,
          exp, payment, date, expCategory);
    } else {
      AchievementView(
        context,
        title: "Add Expenses",
        subTitle: "Please Enter all Requird Details",
        icon: Icon(
          Icons.error,
          color: Colors.white,
        ),
        color: Colors.red,
        alignment: Alignment.bottomCenter,
        duration: Duration(seconds: 2),
        isCircle: true,
      )..show();
    }
  }

  askingDialog(
      BuildContext context,
      String id,
      String title,
      int amount,
      String note,
      expense e,
      paymentMode fm,
      String date,
      String? expCategory) {
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
            // print("GYM OR OTHER "+e.name);
            var u = await Services().editExpenses(id, e, title, amount, fm,
                note, date, expCategory); //await Services().addUser(user);
            //  print("Add user "+u.toString());
            if (u.toString() == "true") {
              Navigator.pop(context);
              Navigator.pop(context);
              setState(() {});
            }
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

    /// return mergeAccount;
  }
}
