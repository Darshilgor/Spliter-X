import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Color bgPrimary = Color.fromARGB(255, 21, 20, 77);
Color backgroundColor = Color.fromARGB(255, 10, 0, 40);
Color bgSecondry1 = Color.fromARGB(255, 201, 29, 141);
Color bgSecondry2 = Color.fromARGB(255, 248, 140, 41);
Color whitecolor = Colors.white;
var fire = FirebaseFirestore.instance;
var auth = FirebaseAuth.instance;


double screenwidth = 0;
double screenheight = 0;

class size {
  static screensize(context) {
    screenwidth = MediaQuery.of(context).size.width;
    screenheight = MediaQuery.of(context).size.height;
  }
}

List<String> monthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];
