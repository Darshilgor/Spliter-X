import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spliter_x/Models/UserProfileModel.dart';
import 'package:spliter_x/Services/Conts.dart';
import 'package:spliter_x/Services/Functions.dart';
import 'package:spliter_x/Services/Widgets.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String mobilenumber = '';

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    mobilenumber = FirebaseAuth.instance.currentUser!.phoneNumber.toString();
  }

  @override
  Widget build(BuildContext context) {
    late Stream<QuerySnapshot<Map<String, dynamic>>> getuserdata =
        FirebaseFirestore.instance
            .collection('Users')
            .where('phoneNumber', isEqualTo: mobilenumber)
            .snapshots();
    return Scaffold(
      body: StreamBuilder<List<UserProfileModel>>(
        stream: getUserDataStream(mobilenumber),
        builder: (context, AsyncSnapshot<List<UserProfileModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: bgSecondry1, 
                valueColor: AlwaysStoppedAnimation<Color>(
                  bgSecondry2,
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Padding(
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      formField(
                        context,
                        'First Name',
                        'Darshil',
                        TextEditingController(
                            text: snapshot.data![index].firstName.toString()),
                        false,
                        TextInputType.none,
                        onchange,
                        (value) =>
                            validatorInput(value, 'Please Enter Description'),
                      ),
                      formField(
                        context,
                        'Last Name',
                        'Gor',
                        TextEditingController(
                            text: snapshot.data![index].lastName.toString()),
                        false,
                        TextInputType.none,
                        onchange,
                        (value) =>
                            validatorInput(value, 'Please Enter Description'),
                      ),
                      formField(
                        context,
                        'Phone Number',
                        '+919409529203',
                        TextEditingController(
                            text:
                                snapshot.data![index].mobileNumber.toString()),
                        false,
                        TextInputType.none,
                        onchange,
                        (value) =>
                            validatorInput(value, 'Please Enter Description'),
                      ),
                      formField(
                        context,
                        'Gender',
                        'Male',
                        TextEditingController(
                            text: snapshot.data![index].gender.toString()),
                        false,
                        TextInputType.none,
                        onchange,
                        (value) =>
                            validatorInput(value, 'Please Enter Description'),
                      ),
                      formField(
                        context,
                        'SignUp Date',
                        '15/11/2002 05:00:00',
                        TextEditingController(
                            text: DateFormat('dd/MM/yyyy   HH:mm:ss')
                                .format(
                                    snapshot.data![index].timeStamp as DateTime)
                                .toString()),
                        false,
                        TextInputType.none,
                        onchange,
                        (value) =>
                            validatorInput(value, 'Please Enter Description'),
                      ),
                      formField(
                        context,
                        'Expense',
                        '1000',
                        TextEditingController(
                            text: snapshot.data![index].expense.toString()),
                        false,
                        TextInputType.none,
                        onchange,
                        (value) =>
                            validatorInput(value, 'Please Enter Description'),
                      ),
                      formField(
                        context,
                        'Spends',
                        '2000',
                        TextEditingController(
                            text: snapshot.data![index].spends.toString()),
                        false,
                        TextInputType.none,
                        onchange,
                        (value) =>
                            validatorInput(value, 'Please Enter Description'),
                      ),
                      GestureDetector(
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
                        child: buttonwidget(
                          context,
                          'LogOut',
                          bgSecondry1,
                          bgSecondry2,
                          Colors.white,
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }

  void onchange(String value) {
    // Perform any actions you want with the changed text
  }
  validatorInput(String? value, String s) {}
}
