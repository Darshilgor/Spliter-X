import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spliter_x/Pages/HomePage.dart';
import 'package:spliter_x/Pages/ProfilePage.dart';
import 'package:spliter_x/Services/Conts.dart';
import 'package:spliter_x/Services/Widgets.dart';

class HomeScreenView extends StatefulWidget {
  const HomeScreenView({super.key});

  @override
  State<HomeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<HomeScreenView> {
  int index = 0;
  PageStorageBucket bucket = PageStorageBucket();
  final List screens = const [
    HomePage(),
    ProfilePage(),
  ];
  Widget currentScreen = const HomePage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: (index == 0)
            ? Text("Spliter X", style: TextStyle(fontWeight: FontWeight.bold))
            : Text(
                'Profile',
              ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 10,
            ),
            child: InkWell(
                onTap: () async {
                  showprocessindicator(context);
                  await Future.delayed(
                    Duration(
                      seconds: 1,
                    ),
                  );
                  await FirebaseAuth.instance.signOut();
                  Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.pushReplacementNamed(context, '/');
                },
                child: Icon(Icons.logout_outlined)),
          )
        ],
      ),
      body: screens[index],
      resizeToAvoidBottomInset: false,
      floatingActionButton: InkWell(
        onTap: () async {
          String name = '';
          DocumentSnapshot snapshot = await FirebaseFirestore.instance
              .collection('Users')
              .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
              .get();
          name = '${snapshot['firstName']} ${snapshot['lastName']}';
          print(name);
          print(FirebaseAuth.instance.currentUser!.phoneNumber.toString());
          Navigator.pushNamed(context, '/roomList/addRoom', arguments: {
            'name': name,
            'mobilenumber':
                FirebaseAuth.instance.currentUser!.phoneNumber.toString(),
          });
          // callnextscreen(
          //   context,
          //   AddRoomPage(
          //     mobilenumber:
          //         FirebaseAuth.instance.currentUser!.phoneNumber.toString(),
          //     name: name,
          //   ),
          // );
          // List<List<String>> temp = [
          //   ["+919909343073", "Darshan Bhalani", "0.0", "0.0"],
          //   ["+919879380239", "Bhargav", "Kavathiya", "0.0", "0.0"],
          //   ["+919409529203", "Darshil", "Gor", "0.0", "0.0"],
          //   ["+919510041494", "Manas", "Ardeshna", "0.0", "0.0"],
          // ];
          // await addRoom("+919909343073", "Temp Room 1", temp);
        },
        child: Container(
          width: screenwidth * 0.13,
          height: screenheight * 0.06,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(
              100,
            ),
          ),
          child: Icon(
            Icons.add,
            size: 30,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        showUnselectedLabels: false,
        currentIndex: index,
        onTap: (index) {
          this.index = index;
          currentScreen = screens[index];
          setState(() {});
        },
        backgroundColor: backgroundColor,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: Colors.orange),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment_ind),
              label: 'Profile',
              backgroundColor: Colors.orangeAccent),
        ],
      ),
    );
  }
}
