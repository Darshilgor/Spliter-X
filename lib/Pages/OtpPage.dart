import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spliter_x/Pages/HomeScreenView.dart';
import 'package:spliter_x/Pages/SignupPage.dart';
import 'package:spliter_x/Services/Conts.dart';
import 'package:spliter_x/Services/Navigator.dart';
import 'package:spliter_x/Services/OtpServices.dart';
import 'package:spliter_x/Services/Widgets.dart';

class OtpPage extends StatefulWidget {
  final String phonenumber;
  const OtpPage({super.key, required this.phonenumber});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  TextEditingController controller4 = TextEditingController();
  TextEditingController controller5 = TextEditingController();
  TextEditingController controller6 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(
          'Enter OTP',
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    otptextformfield(context, controller1, true, 0),
                    otptextformfield(context, controller2, true, 1),
                    otptextformfield(context, controller3, true, 2),
                    otptextformfield(context, controller4, true, 3),
                    otptextformfield(context, controller5, true, 4),
                    otptextformfield(context, controller6, true, 5),
                  ],
                ),
                InkWell(
                  onTap: () async {
                    showprocessindicator(context);
                    setState(() {});
                    if (controller1.text.isNotEmpty &&
                        controller2.text.isNotEmpty &&
                        controller3.text.isNotEmpty &&
                        controller4.text.isNotEmpty &&
                        controller5.text.isNotEmpty &&
                        controller6.text.isNotEmpty) {
                      User? user = await OTPService.verifyotp(
                        context,
                        '${controller1.text}${controller2.text}${controller3.text}${controller4.text}${controller5.text}${controller6.text}',
                      );
                      if (user != null) {
                        FirebaseFirestore.instance
                            .collection('Users')
                            .doc(widget.phonenumber)
                            .get()
                            .then((DocumentSnapshot snapshot) {
                          if (snapshot.exists) {
                            hindprocessindicator(context);
                            // pushAndRemoveUntil(
                            //   context,
                            //   HomeScreenView(),
                            // );
                            Navigator.popUntil(
                                context, (route) => route.isFirst);
                            Navigator.pushReplacementNamed(context, '/');
                          } else {
                            hindprocessindicator(context);
                            // pushAndRemoveUntil(
                            //   context,
                            //   SignupPage(phonenumber: widget.phonenumber,),
                            // );
                            Navigator.pushNamed(context, '/signupPage',
                                arguments: {
                                  'phoneNumber': widget.phonenumber,
                                });
                          }
                        });
                      }
                    } else {
                      showtoast(context, 'Enter Valid OTP', 5);
                      hindprocessindicator(context);
                    }
                  },
                  child: buttonwidget(
                    context,
                    'Varify OTP',
                    bgSecondry1,
                    bgSecondry2,
                    Colors.white,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                InkWell(
                  onTap: () {},
                  child: Text(
                    'Resend OTP',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
