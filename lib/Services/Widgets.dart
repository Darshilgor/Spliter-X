import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:spliter_x/Services/Conts.dart'; // Import your constants

Widget formField(
    BuildContext context,
    String label,
    String hinttext,
    TextEditingController controller,
    bool condition,
    TextInputType textInputType,
    Function(String) onchange,
    String? Function(String?) validator,
    {Function()? onFieldSubmitted,
    FocusNode? focusNode}) {
  return Column(
    children: [
      SizedBox(
        height: 50,
        child: TextFormField(
          cursorColor: bgSecondry2,
          controller: controller,
          enabled: condition,
          keyboardType: textInputType,
          validator: validator,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            // If onFieldSubmitted is provided and not null, call it
            if (onFieldSubmitted != null) {
              onFieldSubmitted();
            }
          },
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: hinttext,
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: bgSecondry2),
            ),
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.teal),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: bgSecondry2, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: bgSecondry2, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 2),
            ),
            labelText: label,
            labelStyle: const TextStyle(fontSize: 16, color: Colors.white),
          ),
          inputFormatters: label == "Phone No."
              ? [
                  LengthLimitingTextInputFormatter(10),
                  FilteringTextInputFormatter.digitsOnly,
                ]
              : label == "OTP"
                  ? [
                      LengthLimitingTextInputFormatter(6),
                      FilteringTextInputFormatter.digitsOnly,
                    ]
                  : label == 'Enter Mobile Number'
                      ? [
                          LengthLimitingTextInputFormatter(10),
                          FilteringTextInputFormatter.digitsOnly
                        ]
                      : [],
        ),
      ),
      const SizedBox(height: 15),
    ],
  );
}

Widget otptextformfield(
  BuildContext context,
  TextEditingController controller,
  bool bool,
  int count,
) {
  List<FocusNode> focusNodes = [
    FocusNode(debugLabel: '1'),
    FocusNode(debugLabel: '2'),
    FocusNode(debugLabel: '3'),
    FocusNode(debugLabel: '4'),
    FocusNode(debugLabel: '5'),
    FocusNode(debugLabel: '6'),
  ];
  return Expanded(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: TextFormField(
        // focusNode: focusNodes[count],
        textInputAction: TextInputAction.done,
        textAlign: TextAlign.center,
        maxLength: 1,
        keyboardType: TextInputType.number,
        controller: controller,
        // onEditingComplete: () {
        //   if (count < 5) {
        //     FocusScope.of(context).requestFocus(focusNodes[count + 1]);
        //   } else {
        //     FocusScope.of(context).unfocus();
        //   }
        // },
        decoration: InputDecoration(
          counter: Text(''),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: bgSecondry2),
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: bgSecondry2, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: bgSecondry2, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 2),
          ),
          labelStyle: const TextStyle(fontSize: 16, color: Colors.white),
        ),
        onTap: () {},
        onChanged: (value) {
          if (value.isNotEmpty) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    ),
  );
}

showprocessindicator(context) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: bgSecondry1, // Background color
          valueColor: AlwaysStoppedAnimation<Color>(
            bgSecondry2, // Color at the center of the gradient
          ),
        ),
      );
    },
  );
}

hindprocessindicator(context) {
  return Navigator.pop(context);
}

Widget buttonwidget(BuildContext context, String btntext, Color bgSecondry1,
    Color bgSecondry2, Color textcolor) {
  return Container(
    height: 50,
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [bgSecondry1, bgSecondry2],
        ),
        borderRadius: BorderRadius.circular(3)),
    child: Center(
      child: Text(
        btntext,
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

void showtoast(BuildContext context, String msg, int duration) {
  showToast(
    context: context,
    msg,
    backgroundColor: bgSecondry2,
    isHideKeyboard: true,
    duration: Duration(seconds: duration),
  );
}

Widget mainDivider() {
  return Padding(
    padding: const EdgeInsets.only(
      left: 10,
      right: 10,
      top: 10,
      bottom: 20,
    ),
    child: Divider(
      height: 2,
      thickness: 2,
      color: Colors.white,
    ),
  );
}

Widget subDivider() {
  return Padding(
    padding: const EdgeInsets.only(
      left: 60,
      right: 60,
      top: 0,
      bottom: 15,
    ),
    child: Divider(
      height: 1,
      thickness: 1,
      color: Colors.white,
    ),
  );
}
