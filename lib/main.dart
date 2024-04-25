import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:spliter_x/Pages/AddRoomPage.dart';
import 'package:spliter_x/Pages/AddTransactionPage.dart';
import 'package:spliter_x/Pages/HomeScreenView.dart';
import 'package:spliter_x/Pages/LoginPage.dart';
import 'package:spliter_x/Pages/OtpPage.dart';
import 'package:spliter_x/Pages/SignupPage.dart';
import 'package:spliter_x/Pages/TransactionDetailsPage.dart';
import 'package:spliter_x/Pages/TransactionGroupPage.dart';
import 'package:spliter_x/Pages/TransactionListPage.dart';
import 'package:spliter_x/Services/Conts.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    size.screensize(context);
    return MaterialApp(
      title: 'Spliter X',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      // initialRoute: '/',
      // Define the routes for the app
      routes: {
        '/': (context) => (FirebaseAuth.instance.currentUser != null)
            ? HomeScreenView()
            : LoginPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/signupPage') {
          final Map<String, dynamic>? args =
              settings.arguments as Map<String, dynamic>;
          final phonenumber = args?['phoneNumber'];
          return MaterialPageRoute(
            builder: (context) => SignupPage(phonenumber: phonenumber),
          );
        }
        if (settings.name == '/otpPage') {
          final Map<String, dynamic>? args =
              settings.arguments as Map<String, dynamic>;

          final phonenumber = args?['phonenumber'];
          return MaterialPageRoute(
            builder: (context) => OtpPage(
              phonenumber: phonenumber,
            ),
          );
        }
        if (settings.name == '/roomList/transactioGroupList') {
          final Map<String, dynamic>? args =
              settings.arguments as Map<String, dynamic>?;
          final roomId = args?['roomId'];
          // final groupid=args?['groupid'];
          // final isadmin=args?['isadmin'];
          return MaterialPageRoute(
            builder: (context) => TransactionGroupPage(roomId: roomId),
          );
        }
        if (settings.name == '/roomList/addRoom') {
          final Map<String, dynamic>? args =
              settings.arguments as Map<String, dynamic>;
          final name = args?['name'];
          final mobilenumber = args?['mobilenumber'];
          return MaterialPageRoute(
            builder: (context) => AddRoomPage(
              name: name,
              mobilenumber: mobilenumber,
            ),
          );
        }
        if (settings.name ==
            '/roomList/transactioGroupList/transactionList/addTransaction') {
          final Map<String, dynamic>? args =
              settings.arguments as Map<String, dynamic>?;
          final roomid = args?['roomid'];
          final groupid = args?['groupid'];
          final isadmin = args?['isadmin'];
          return MaterialPageRoute(
            builder: (context) => AddTransactionPage(
                roomid: roomid, groupid: groupid, isadmin: isadmin),
          );
        }
        if (settings.name ==
            '/roomList/transactionGroupList/transactionList/transactionListDetails') {
          final Map<String, dynamic>? args =
              settings.arguments as Map<String, dynamic>?;

          final roomid = args?['roomid'];
          final groupid = args?['groupid'];
          final transactionid = args?['transactionid'];
          final addtransaction = args?['addtransaction'];
          final isadmin = args?['isadmin'];

          return MaterialPageRoute(
            builder: (context) => TransactionDetailsPage(
                roomid: roomid,
                groupid: groupid,
                transactionid: transactionid,
                addtransaction: addtransaction,
                isadmin: isadmin),
          );
        }
        if (settings.name == '/roomList/transactioGroupList/transactionList') {
          final Map<String, dynamic>? args =
              settings.arguments as Map<String, dynamic>?;

          final roomid = args?['roomid']!;
          final groupid = args?['groupid']!;
          final isadmin = args?['isadmin']!;

          return MaterialPageRoute(
            builder: (context) => TransactionListPage(
                roomid: roomid, groupid: groupid, isadmin: isadmin),
          );
        }
      },
      // home: (FirebaseAuth.instance.currentUser != null)
      //     ? HomeScreenView()
      //     : LoginPage(),
    );
  }
}
