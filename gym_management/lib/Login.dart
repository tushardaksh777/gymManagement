import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_management/main.dart';

class Login extends StatefulWidget {
   const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    double unitwidth = MediaQuery.of(context).size.width / 100;
    double unitheight = MediaQuery.of(context).size.height / 100;

  final phoneNoController = TextEditingController();
  final nameController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
    double textscalefactor = 1;
    return Container(width: unitwidth * 100 ,height: unitheight*100 , child: 
    ListView(children: [
      // Container(width:  unitwidth*30,height: unitwidth*15, alignment: Alignment.center,child: Text("Login Or Sign Up" , style: TextStyle(color: Colors.blue , fontSize: unitwidth*7),),),
      // Container(width: unitwidth*30, height: unitheight*10,alignment: Alignment.center,child: TextField(
                     
      //   style: GoogleFonts.montserrat(textStyle: TextStyle()),
      //                               decoration: InputDecoration(
      //                                 // border: OutlineInputBorder(
      //                                 //   borderRadius: BorderRadius.all(
      //                                 //       Radius.circular(10)),
      //                                 // ),
      //                                 filled: true,
      //                                 fillColor: Colors.white.withOpacity(0.4),
      //                                 hintText: "Enter Your Number",
      //                                 hintStyle: GoogleFonts.montserrat(
      //                                     textStyle: TextStyle(
      //                                         color: Colors.white,
      //                                         fontSize: unitwidth *
      //                                             textscalefactor *
      //                                             5)),
      //                                 prefixIcon: Icon(
      //                                   FontAwesomeIcons.phoneAlt,
      //                                   color: Colors.white,
      //                                   size: unitwidth * 8,
      //                                 ),
      //                               ),
      //                               keyboardType: TextInputType.number,
      //                               // inputFormatters: [
      //                               //   FilteringTextInputFormatter.digitsOnly,
      //                               // ],
      //                               maxLength: 10,
      //                               textInputAction: TextInputAction.done,
      //                               controller: phoneNoController,
      //                             ),)
      Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Fitness Hub',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                )),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  '',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'User Name',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            SizedBox(height: unitheight*3,),
            // TextButton(
            //   onPressed: () {
            //     //forgot password screen
            //   },
            //   child: const Text('Forgot Password',),
            // ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: const Text('Login'),
                  onPressed: () {
                        Navigator.push(
        this.context,
        MaterialPageRoute(
            maintainState: false,
            builder: (context) => MyHomePage(title: "Gym Management")));       //this.onlogin = false;
  
                    print(nameController.text);
                    print(passwordController.text);
                  },
                )
    )])
    ,);

  }
}