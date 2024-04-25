import 'package:flutter/material.dart';
import 'package:spliter_x/Services/Conts.dart';
import 'package:spliter_x/Services/Functions.dart';
import 'package:spliter_x/Services/Widgets.dart';

class SignupPage extends StatefulWidget {
  final String phonenumber;
  const SignupPage({super.key, required this.phonenumber});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController firstnamecontroller = TextEditingController();
  TextEditingController lastnamecontroller = TextEditingController();
  TextEditingController gendercontrolller = TextEditingController(text: "Male");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(
          'Sign Up',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(
          10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            formField(context, 'Enter First Name','Darshil', firstnamecontroller, true,
                TextInputType.name, onchange,(value) => validatorInput(value, 'Please Enter Description'),),
            formField(context, 'Enter Last Name','Gor', lastnamecontroller, true,
                TextInputType.name, onchange,(value) => validatorInput(value, 'Please Enter Description'),),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.circular(
                  4,
                ),
              ),
              width: screenwidth,
              child: DropdownButton<String>(
                padding: EdgeInsets.only(
                  left: 15,
                ),
                dropdownColor: bgSecondry2,
                value: gendercontrolller.text, // Initially selected value
                onChanged: (value) {
                  setState(() {
                    gendercontrolller.text = value!;
                  });
                },
                items: <String>['Male', 'Female']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    alignment: Alignment.centerLeft,
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child:
                  Container(), // Empty Container to push buttonwidget to bottom
            ),
            InkWell(
              onTap: () {
                showprocessindicator(context);
                if (firstnamecontroller.text.isNotEmpty &&
                    lastnamecontroller.text.isNotEmpty &&
                    gendercontrolller.text.isNotEmpty) {
                  adduserdetails(
                      context,
                      firstnamecontroller.text,
                      lastnamecontroller.text,
                      gendercontrolller.text,
                      widget.phonenumber);
                } else {
                  if (firstnamecontroller.text.isEmpty &&
                      lastnamecontroller.text.isEmpty) {
                    showtoast(context, 'Please Enter details', 3);
                    hindprocessindicator(context);
                  } else if (firstnamecontroller.text.isEmpty &&
                      lastnamecontroller.text.isNotEmpty) {
                    showtoast(context, 'Please Enter FirstName', 5);
                    hindprocessindicator(context);
                  } else if (lastnamecontroller.text.isEmpty &&
                      firstnamecontroller.text.isNotEmpty) {
                    showtoast(context, 'Please Enter LastName', 5);
                    hindprocessindicator(context);
                  }
                }
              },
              child: buttonwidget(
                context,
                'Sign Up',
                bgSecondry1,
                bgSecondry2,
                Colors.white,
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  void onchange(String controller) {
  }

  validator(String p1) {
  }
  
  validatorInput(String? value, String s) {}
}
