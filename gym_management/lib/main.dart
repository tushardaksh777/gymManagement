import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gym_management/AddExpenses.dart';
import 'package:gym_management/AddUser/createUser.dart';
import 'package:gym_management/Expendure.dart';
import 'package:gym_management/Home.dart';
import 'package:gym_management/Login.dart';
import 'package:gym_management/MonthlyTransaction.dart';
import 'package:gym_management/Profile.dart';
import 'package:gym_management/Search.dart';
import 'package:gym_management/Server/Services.dart';
import 'package:gym_management/Server/address.dart';
import 'package:gym_management/attandance.dart';
import 'package:gym_management/globalData.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  // ByteData data = await PlatformAssetBundle().load('assets/certificate/lets-encrypt-r3.pem');
  // SecurityContext.defaultContext.setTrustedCertificatesBytes(data.buffer.asUint8List());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        //GlobalMaterialLocalizations.delegate,
        //  MonthYearPickerLocalizations.delegate,
        localizationsDelegates: const [MonthYearPickerLocalizations.delegate],
        title: 'Gym Management',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
            future: checkLogin(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              // if(!snapshot.hasData)
              // return Login();
              // else
              return MyHomePage(title: "Gym");
            })

        //MyHomePage(title: 'Flutter Demo Home Page'),
        );
  }

  Future<bool> checkLogin() async {
    //t("Server address " +Services.BASE_URL);
    var status = await Permission.storage.status;
    PermissionStatus? req;
    if (status.isDenied) {
      req = await Permission.storage.request();
    }

    if (status.isPermanentlyDenied) {
      req = await Permission.storage.request();
    }
    if (req!.isDenied) {
      print(req.toString());
    } else {
      print("Else " + req.toString());
    }
    return await true;
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int _selectedIndex = 0;

//   @override
//   void initState() {
//   // TODO: implement initState
//   super.initState();

//  //http://192.168.29.253:8089

//   }
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      //_counter++;
    });
  }

  static List<Widget> _widgetOptions = <Widget>[
    Home(),
    Attandance(),
    Expendure(),
    Profile()
  ];
  @override
  Widget build(BuildContext context) {
    double unitwidth = MediaQuery.of(context).size.width / 100;
    double unitheight = MediaQuery.of(context).size.height / 100;

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      resizeToAvoidBottomInset: true,

      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: [
          if (_selectedIndex == 0)
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => MonthlyTransaction())));
                    },
                    icon: const Icon(Icons.receipt)),
                IconButton(
                    onPressed: () async {
                      global.allUser = await Services().getAllUser();
                      showSearch(context: context, delegate: Search());
                    },
                    icon: const Icon(Icons.search)),
              ],
            ),
          if (_selectedIndex == 3)
            IconButton(
                onPressed: () {
                  askForPermission();
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => Address())));
                },
                icon: const Icon(FontAwesomeIcons.server))
        ],
      ),
      //here we use future builder for authentication
      body: Container(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      // Center(
      //   // Center is a layout widget. It takes a single child and positions it
      //   // in the middle of the parent.
      //   child: Column(
      //     // Column is also a layout widget. It takes a list of children and
      //     // arranges them vertically. By default, it sizes itself to fit its
      //     // children horizontally, and tries to be as tall as its parent.
      //     //
      //     // Invoke "debug painting" (press "p" in the console, choose the
      //     // "Toggle Debug Paint" action from the Flutter Inspector in Android
      //     // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
      //     // to see the wireframe for each widget.
      //     //
      //     // Column has various properties to control how it sizes itself and
      //     // how it positions its children. Here we use mainAxisAlignment to
      //     // center the children vertically; the main axis here is the vertical
      //     // axis because Columns are vertical (the cross axis would be
      //     // horizontal).
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       const Text(
      //         'You have pushed the button this many times:',
      //       ),
      //       Text(
      //         '$_counter',
      //         style: Theme.of(context).textTheme.headline4,
      //       ),
      //     ],
      //   ),
      // ),

      floatingActionButton: (_selectedIndex == 0 || _selectedIndex == 2)
          ? FloatingActionButton(
              onPressed: () {
                if (_selectedIndex == 0) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => CreateUser())));
                }
                if (_selectedIndex == 2) {
                  // await Services().gettestUserData();
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => AddExpenses())));
                }
              },
              child:
                  (_selectedIndex == 1) ? Icon(Icons.check) : Icon(Icons.add),
            )
          : null,

      bottomNavigationBar: SizedBox(
          height: unitheight * 8,
          child: Column(
              //alignment: AlignmentDirectional.bottomEnd,
              children: [
                Container(
                    height: unitheight * 8,
                    child: BottomNavigationBar(
                      type: BottomNavigationBarType.fixed,
                      items: const <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                          icon: Icon(Icons.home),
                          label: 'Home',
                          //title: Text()
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.calendar_today),
                          label: 'Attandace',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(FontAwesomeIcons.cashRegister),
                          label: 'Expendure',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.person),
                          label: 'Profile',
                        ),
                      ],
                      showUnselectedLabels: true,
                      unselectedItemColor: Colors.grey,
                      unselectedLabelStyle: TextStyle(color: Colors.grey),
                      currentIndex: _selectedIndex,
                      selectedItemColor: Colors.grey[900],
                      onTap: _onItemTapped,
                    )),
              ])), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _onItemTapped(int index) async {
    //print("Test date "+ DateTime.now().toIso8601String());
    setState(() {
      getConnectivity();
      _selectedIndex = index;
    });

    //var data = await Services().gettestUserData();
    //print("object "+data.toString());
//     final connectivityResult = await (Connectivity().checkConnectivity());
//     print("connectivityResult " +connectivityResult.toString());
// if (connectivityResult == ConnectivityResult.mobile) {
//   // I am connected to a mobile network.
//   print("Internet connected");
// } else if (connectivityResult == ConnectivityResult.wifi) {
//   // I am connected to a wifi network.
//     print("Internet connected wifi");
// }else{
//     print("Internet not connected");
// }
  }

  getConnectivity() {
    StreamSubscription subscription;
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) async {
      var isDeviceConnected = await InternetConnectionChecker().hasConnection;
      if (!isDeviceConnected) {
      } else {}
    });
  }

  askForPermission() async {
    var status = await Permission.storage.status;
    PermissionStatus req = status;
    if (status.isDenied) {
      req = await Permission.storage.request();
    }

    if (status.isPermanentlyDenied) {
      req = await Permission.storage.request();
    }
    if (req!.isDenied) {
      print(req.toString());
    } else {
      print("Else " + req.toString());
    }
  }
}
