import 'package:flutter/material.dart';
import 'package:rive/rive.dart' show RiveAnimation;
import 'package:spliter_x/Services/Conts.dart';
import 'package:spliter_x/Services/OtpServices.dart';
import 'package:spliter_x/Services/Widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phonenumbercontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 0, 40),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 250,
                width: 250,
                child: RiveAnimation.asset("assets/animation.riv"),
              ),
              ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [bgSecondry2, bgSecondry1],
                  ).createShader(bounds);
                },
                child: Text("Phone Verification",
                    style: TextStyle(
                        color: bgSecondry1,
                        fontSize: 30,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(
                height: 5,
              ),
              const Text("We need to verify you phone before getting started!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 15)),
              const SizedBox(
                height: 15,
              ),
              formField(context, "Phone No.",'9409529203', phonenumbercontroller, true,
                  TextInputType.phone, onchange,(value) => validatorInput(value, 'Please Enter Description'),),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                    showprocessindicator(context);
                    if (phonenumbercontroller.text.length == 10) {
                      showprocessindicator(context);
                      await OTPService.verifyphonenumber(
                          context, '+91${phonenumbercontroller.text}');
                    } else {
                      showtoast(context, 'please Enter Valid Number', 3);
                      hindprocessindicator(context);
                    }
              
                    // await signUp("+919909343073", "Darshan", "Bhalani");
                    // await signUp("+919879380239", "Bhargav", "Kavathiya");
                    // await signUp("+919409529203", "Darshil", "Gor");
                    // await signUp("+919510041494", "Manas", "Ardeshna");
                    //
              
                    // await addTransactionGroup("STToJE8zn51cirZR5TKt",null);
              
                    // List<List<String>> temp = [
                    //   ["+919909343073", "Darshan Bhalani", "200", "100"],
                    //   ["+919879380239", "Bhargav Kavathiya", "0.0", "100"],
                    //   ["+919409529203", "Darshil Gor", "0.0", "100"],
                    //   ["+919510041494", "Manas Ardeshna", "200", "100"],
                    // ];
                    // await addTransaction(
                    //     "HR1ARHvegoppxzneDK98", "400", "Online", temp);
              
                    // await deleteTransaction("MAS3cNGkKzNi2MftLj1R", "HR1ARHvegoppxzneDK98");
                    //await deleteTransactionGroup("HR1ARHvegoppxzneDK98","STToJE8zn51cirZR5TKt");
              
                    // await deleteRoom("STToJE8zn51cirZR5TKt");
              
                    // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomePage()),(route) => false,);
                  },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [bgSecondry1, bgSecondry2],
                      ),
                      borderRadius: BorderRadius.circular(3)),
                  child: const Center(
                        child: Text("Login",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold))),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  onchange(String value) {
  }

  validator(String p1) {
  }
  
  validatorInput(String? value, String s) {}
}
