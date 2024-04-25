import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:spliter_x/Models/UserModel.dart';
import 'package:spliter_x/Services/Conts.dart';
import 'package:spliter_x/Services/Functions.dart';
import 'package:spliter_x/Services/Widgets.dart';

class AddRoomPage extends StatefulWidget {
  String name;
  String mobilenumber;
  AddRoomPage({super.key, required this.mobilenumber, required this.name});

  @override
  State<AddRoomPage> createState() => _AddRoomPageState();
}

class _AddRoomPageState extends State<AddRoomPage> {
  TextEditingController roomnamecontroller = TextEditingController();
  List<TextEditingController> membernamecontroller = [];
  List<TextEditingController> membermobilenocontroller = [];
  TextEditingController mobilenumnercontroller = TextEditingController();
  TextEditingController memberfirstnamecontroller = TextEditingController();
  TextEditingController memberlastnamecontroller = TextEditingController();
  List<UserModel> memberlist = [];
  bool showTextField = false;
  bool showdatafield = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      widget.name = args['name'];
      widget.mobilenumber = args['mobilenumber'];
    }
    if (memberlist.isEmpty) {
      memberlist.add(UserModel(
        mobileNumber: widget.mobilenumber,
        name: widget.name,
        spends: '0',
        expense: '0',
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.name);
    print(widget.mobilenumber);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgPrimary,
        title: Text('Add Room'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(
          10,
        ),
        child: Column(
          children: [
            formField(
              context,
              'Enter Room Name',
              'Room Name',
              roomnamecontroller,
              true,
              TextInputType.name,
              onchange,
              (value) => validatorInput(value, 'Please Enter Description'),
            ),
            if (showTextField)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ListTile(
                      title: formField(
                        context,
                        'Enter Mobile Number',
                        '9409529203',
                        mobilenumnercontroller,
                        true,
                        TextInputType.phone,
                        onchange,
                        (value) =>
                            validatorInput(value, 'Please Enter Description'),
                      ),
                      trailing: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 10,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              showprocessindicator(context);
                              
                              if (mobilenumnercontroller.text.isEmpty) {
                                hindprocessindicator(context);
                                showtoast(context, 'Enter Mobile Number', 3);
                              } else if (mobilenumnercontroller.text.length !=
                                  10) {
                                hindprocessindicator(context);
                                showtoast(
                                    context, 'Enter valid mobile number', 3);
                              } else {
                                checkmobilenumner(
                                    '+91${mobilenumnercontroller.text}');
                              }
                            });
                          },
                          child: Icon(
                            Icons.add,
                            size: 26,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            if (showdatafield)
              Container(
                color: Colors.red,
                child: Column(
                  children: [
                    formField(
                        context,
                        'Enter First Name',
                        'Darshil',
                        memberfirstnamecontroller,
                        true,
                        TextInputType.name,
                        onchange,
                        (value) =>
                            validatorInput(value, 'Please Enter Description')),
                    formField(
                      context,
                      'Enter Last Name',
                      'Gor',
                      memberlastnamecontroller,
                      true,
                      TextInputType.name,
                      onchange,
                      (value) =>
                          validatorInput(value, 'Please Enter Description'),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: InkWell(
                              onTap: () {
                                memberfirstnamecontroller.text = '';
                                memberlastnamecontroller.text = '';
                                setState(() {
                                  showdatafield = !showdatafield;
                                  showTextField = !showTextField;
                                  mobilenumnercontroller.text = '';
                                });
                              },
                              child: Container(
                                width: screenwidth,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    2,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                    10,
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: InkWell(
                              onTap: () async {
                                if (memberfirstnamecontroller.text.isNotEmpty &&
                                    memberlastnamecontroller.text.isNotEmpty) {
                                  await FirebaseFirestore.instance
                                      .collection('Users')
                                      .doc('+91${mobilenumnercontroller.text}')
                                      .set(
                                    {
                                      'firstName':
                                          memberfirstnamecontroller.text,
                                      'lastName': memberlastnamecontroller.text,
                                      'gender': '',
                                      'timeStamp': DateTime.now(),
                                      'phoneNumber':
                                          '+91${mobilenumnercontroller.text}',
                                      'rooms': [],
                                      'transactions':{
                                        'expense':0.0,
                                        'spends':0.0,
                                      }
                                    },
                                  ).whenComplete(
                                    () {
                                      var data = UserModel(
                                        name:
                                            '${memberfirstnamecontroller.text} ${memberlastnamecontroller.text}',
                                        mobileNumber:
                                            '+91${mobilenumnercontroller.text}',
                                        spends: '0',
                                        expense: '0',
                                      );
                                      memberlist.add(data);
                                      showtoast(
                                          context, 'Meber add successfully', 5);
                                      memberfirstnamecontroller.text = '';
                                      memberlastnamecontroller.text = '';
                                      setState(() {
                                        showdatafield = !showdatafield;
                                        showTextField = !showTextField;
                                      });
                                    },
                                  );
                                } else {
                                  showtoast(context, 'Please Enter Name', 5);
                                }
                              },
                              child: Container(
                                width: screenwidth,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    2,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                    10,
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Submit',
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: memberlist.length,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Column(
                      children: [
                        Container(
                          color: Colors.red,
                          child: ListTile(
                            title: Text(memberlist[index].name.toString()),
                            subtitle:
                                Text(memberlist[index].mobileNumber.toString()),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return SwipeActionCell(
                      key: ValueKey(memberlist[index]),
                      child: Column(
                        children: [
                          Container(
                            color: Colors.red,
                            child: ListTile(
                              title: Text(memberlist[index].name.toString()),
                              subtitle: Text(
                                  memberlist[index].mobileNumber.toString()),
                            ),
                          ),
                        ],
                      ),
                      trailingActions: [
                        SwipeAction(
                            title: "Remove",
                            performsFirstActionWithFullSwipe: true,
                            // nestedAction: SwipeNestedAction(title: "confirm"),
                            onTap: (handler) async {
                              await handler(true);
                              memberlist.removeAt(index);
                              setState(() {});
                            }),
                      ],
                    );
                  }
                },
              ),
            ),
            GestureDetector(
              onTap: () async {
                if(roomnamecontroller.text.isEmpty)
                {
                  showtoast(context,'Enter room name', 3);
                }
                if (widget.mobilenumber != null &&
                    widget.name!.isNotEmpty &&
                    roomnamecontroller.text.isNotEmpty &&
                    memberlist.length >= 2) {

                  showprocessindicator(context);
                  addRoom(context, widget.mobilenumber!, widget.name!,
                          roomnamecontroller.text, memberlist)
                      .whenComplete(
                    () {
                      Navigator.pop(context);
                      hindprocessindicator(context);
                      Navigator.pushReplacementNamed(context, '/');
                    },
                  );
                }
              },
              child: buttonwidget(
                context,
                'Create Room',
                bgSecondry1,
                bgSecondry2,
                Colors.white,
              ),
            )
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            setState(() {
              showTextField = !showTextField;
            });
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void onchange(String value) {
    // Perform any actions you want with the changed text
  }

  Future checkmobilenumner(String id) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(id)
        .get()
        .then((DocumentSnapshot snapshot) async {
      if (snapshot.exists) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(id)
            .get()
            .then((DocumentSnapshot snapshot) {
          var data = UserModel(
            mobileNumber: id,
            name: '${snapshot['firstName']} ${snapshot['lastName']}',
            spends: '0',
            expense: '0',
          );

          // if (memberlist.isNotEmpty) {
          bool userAlreadyAdded = false;
          for (int i = 0; i < memberlist.length; i++) {
            if (memberlist[i].mobileNumber == data.mobileNumber) {
              userAlreadyAdded = true;
              break;
            }
            mobilenumnercontroller.text = '';
          }
          if (userAlreadyAdded == true) {
            showtoast(context, 'Already added...', 5);
            hindprocessindicator(context);
            mobilenumnercontroller.text = '';
            // showdatafield = !showdatafield;
          } else {
            memberlist.add(data);
            hindprocessindicator(context);
          }
          setState(() {
            showTextField = !showTextField;
          });
          // } else {
          //   memberlist.add(data);
          //   setState(() {});
          //   hindprocessindicator(context);
          //   return;
          // }
        });
      } else {
        showdatafield = !showdatafield;
        hindprocessindicator(context);

        setState(() {});
      }
    });
  }

  // Future createroom() async {
  //   if (roomnamecontroller.text.isNotEmpty && memberlist.length >= 2) {
  //     showprocessindicator(context);
  //     List<String> roomMates = [];
  //     for (int i = 0; i < memberlist.length; i++) {
  //       roomMates.add(memberlist[i].mobileNumber.toString());
  //     }
  //     await FirebaseFirestore.instance.collection('Rooms').doc().get().then(
  //       (DocumentSnapshot snapshot) async {
  //         await FirebaseFirestore.instance
  //             .collection('Rooms')
  //             .doc(snapshot.id)
  //             .set({
  //           'creationTime': DateTime.now(),
  //           'roomId': snapshot.id,
  //           'roomMates': roomMates,
  //           'roomName': roomnamecontroller.text,
  //           'roomTranscations': {}
  //         }).whenComplete(
  //           () {
  //             hindprocessindicator(context);
  //             Navigator.of(context).pop();
  //           },
  //         );
  //       },
  //     );
  //   } else if (roomnamecontroller.text.isEmpty) {
  //     showtoast(context, 'Enter Room Name', 3);
  //   } else {
  //     showtoast(context, 'Add Room Member', 3);
  //   }
  // }

  validator(String p1) {}

  validatorInput(String? value, String s) {}
}
