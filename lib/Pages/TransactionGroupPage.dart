import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spliter_x/Models/RoomsTransactionGroups.dart';
import 'package:spliter_x/Models/ShowRoomDetailsModel.dart';
import 'package:spliter_x/Models/TransactionListModel.dart';
import 'package:spliter_x/Services/Conts.dart';
import 'package:spliter_x/Services/Functions.dart';
import 'package:spliter_x/Services/Widgets.dart';

class TransactionGroupPage extends StatefulWidget {
  String roomId;
  TransactionGroupPage({super.key, required this.roomId});

  @override
  State<TransactionGroupPage> createState() => _TransactionGroupPageState();
}

class _TransactionGroupPageState extends State<TransactionGroupPage> {
  List<TransactionListModel> trnasactionlist = [];
  TextEditingController transactiongroupnamecontroller =
      TextEditingController();
  String adminPhoneNumber = '';
  String loginPhoneNumber = '';
  bool isadmin = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getadmindata();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(
          'Transaction Group',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 20,
            ),
            child: GestureDetector(
              onTap: () async {
                List<ShowRoomDetailsModel> list =
                    await getroomdetails(widget.roomId!);
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              8,
                            ),
                          ),
                          child: Dialog(
                            child: SingleChildScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                              child: Material(
                                color: Colors.black,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                    right: 10,
                                    top: 20,
                                    bottom: 20,
                                  ),
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: list.length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            formField(
                                              context,
                                              'Room Name',
                                              'April-1',
                                              TextEditingController(
                                                  text: list[index].roomName),
                                              false,
                                              TextInputType.none,
                                              onchange,
                                              (value) => validatorInput(
                                                value,
                                                'Please Enter Description',
                                              ),
                                            ),
                                            formField(
                                              context,
                                              'Admin Name',
                                              '1000',
                                              TextEditingController(
                                                  text: list[index].adminName),
                                              false,
                                              TextInputType.none,
                                              onchange,
                                              (value) => validatorInput(
                                                value,
                                                'Please Enter Description',
                                              ),
                                            ),
                                            formField(
                                              context,
                                              'Admin Phone Number',
                                              '15/04/2024 09:30:30',
                                              TextEditingController(
                                                  text: list[index]
                                                      .adminPhoneNumber),
                                              false,
                                              TextInputType.none,
                                              onchange,
                                              (value) => validatorInput(
                                                value,
                                                'Please Enter Description',
                                              ),
                                            ),
                                            formField(
                                              context,
                                              'Total Expanse',
                                              '16/04/2024 09:30:30',
                                              TextEditingController(
                                                  text:
                                                      list[index].totalExpanse),
                                              false,
                                              TextInputType.none,
                                              onchange,
                                              (value) => validatorInput(
                                                value,
                                                'Please Enter Description',
                                              ),
                                            ),
                                            formField(
                                              context,
                                              'Creation Time',
                                              '16/04/2024 09:30:30',
                                              TextEditingController(
                                                  text: DateFormat(
                                                          'dd/MM/yyyy   HH:mm:ss')
                                                      .format(list[index]
                                                          .timeStamp!)),
                                              false,
                                              TextInputType.none,
                                              onchange,
                                              (value) => validatorInput(
                                                value,
                                                'Please Enter Description',
                                              ),
                                            ),
                                            ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount: list[index]
                                                  .memberList!
                                                  .length,
                                              itemBuilder: (context, index1) {
                                                return formField(
                                                  context,
                                                  'Room Member',
                                                  '16/04/2024 09:30:30',
                                                  TextEditingController(
                                                      text: list[index]
                                                          .memberList![index1]
                                                          .memberName),
                                                  false,
                                                  TextInputType.none,
                                                  onchange,
                                                  (value) => validatorInput(
                                                    value,
                                                    'Please Enter Description',
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        );
                                      }),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
              child: Text(
                'Details',
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<RoomsTransactionGroups>>(
          stream: getTransactionGroupListStream(widget.roomId),
          builder: (context, snapshot) {
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
              return Center(child: Text(snapshot.error.toString()));
            } else if (snapshot.hasData) {
              List<RoomsTransactionGroups> roomTransactionGroupList = [];

              roomTransactionGroupList = snapshot.data!;
              roomTransactionGroupList =
                  roomTransactionGroupList.reversed.toList();
              return ListView.builder(
                itemCount: roomTransactionGroupList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 10,
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        setState(() {
                          // callnextscreen(
                          //   context,
                          //   TransactionListPage(
                          //     roomid: widget.roomId!,
                          //     groupid: list[index]['Id'],
                          //     isadmin: isadmin,
                          //   ),
                          // );
                          Navigator.pushNamed(context,
                              '/roomList/transactioGroupList/transactionList',
                              arguments: {
                                'roomid': widget.roomId,
                                'groupid': roomTransactionGroupList[index].id,
                                'isadmin': isadmin,
                              });
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(
                            6,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: ListTile(
                                title: Text(roomTransactionGroupList[index]
                                    .name
                                    .toString()),
                                subtitle: Text(roomTransactionGroupList[index]
                                    .timestamp
                                    .toString()),
                                trailing: (roomTransactionGroupList[index]
                                            .active ==
                                        true)
                                    ? Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(
                                            100,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(
                                            100,
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      bottomNavigationBar: Visibility(
        visible: isadmin,
        child: BottomAppBar(
          child: GestureDetector(
            onTap: () async {
              List<RoomsTransactionGroups> roomTransactionGroupList = [];
              bool isactive = false;
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return Dialog(
                        child: SizedBox(
                          child: Material(
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: 10,
                                right: 10,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Are you sure,You want to delete this room',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: buttonwidget(
                                            context,
                                            'No',
                                            bgSecondry1,
                                            bgSecondry2,
                                            Colors.white,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () async {
                                            showprocessindicator(context);
                                            await gettransactiongrouplist(
                                                    widget.roomId)
                                                .then((value) {
                                              roomTransactionGroupList = value;
                                              for (int i = 0;
                                                  i <
                                                      roomTransactionGroupList
                                                          .length;
                                                  i++) {
                                                if (roomTransactionGroupList[i]
                                                        .active ==
                                                    true) {
                                                  isactive = true;
                                                  break;
                                                }
                                              }
                                              if (isactive == true) {
                                                showtoast(
                                                    context,
                                                    'Transaction Group is Active Please Close the Group',
                                                    3);
                                              }
                                              if (isactive == false) {
                                                deleteRoom(widget.roomId);
                                              }
                                            }).whenComplete(() {
                                              Navigator.pop(context);
                                              Navigator.pop(context);

                                              hindprocessindicator(context);
                                              Navigator.pushReplacementNamed(
                                                  context, '/');
                                            });
                                          },
                                          child: buttonwidget(
                                            context,
                                            'Yes',
                                            bgSecondry1,
                                            bgSecondry2,
                                            Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
            child: buttonwidget(
              context,
              'Delete Transaction Room',
              bgSecondry1,
              bgSecondry2,
              Colors.white,
            ),
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      floatingActionButton: (isadmin)
          ? Padding(
              padding: const EdgeInsets.only(
                right: 10,
                bottom: 10,
              ),
              child: InkWell(
                onTap: () async {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                8,
                              ),
                            ),
                            child: Dialog(
                              child: SingleChildScrollView(
                                physics: AlwaysScrollableScrollPhysics(),
                                child: Material(
                                  color: Colors.black,
                                  child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                        top: 20,
                                        bottom: 20,
                                      ),
                                      child: Column(
                                        children: [
                                          formField(
                                            context,
                                            'Transaction Group Name',
                                            'April-1',
                                            transactiongroupnamecontroller,
                                            true,
                                            TextInputType.name,
                                            onchange,
                                            (value) => validatorInput(
                                              value,
                                              'Please Enter Description',
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    transactiongroupnamecontroller
                                                        .clear();
                                                    Navigator.pop(context);
                                                    Navigator.pushReplacementNamed(
                                                        context,
                                                        '/roomList/transactioGroupList',
                                                        arguments: {
                                                          'roomId':
                                                              widget.roomId,
                                                        });
                                                  },
                                                  child: buttonwidget(
                                                    context,
                                                    'Cancel',
                                                    bgSecondry1,
                                                    bgSecondry2,
                                                    Colors.white,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    if (transactiongroupnamecontroller
                                                        .text.isNotEmpty) {
                                                      await addTransactionGroup(
                                                              widget.roomId!,
                                                              transactiongroupnamecontroller
                                                                  .text)
                                                          .whenComplete(() {
                                                        Navigator.pushNamed(
                                                            context,
                                                            '/roomList/transactioGroupList',
                                                            arguments: {
                                                              'roomId':
                                                                  widget.roomId,
                                                            });
                                                      }
                                                              // removeandcallnextscreen(
                                                              //     context,
                                                              //     TransactionGroupPage(
                                                              //       roomId:
                                                              //           widget.roomId,
                                                              //     )),
                                                              );
                                                      transactiongroupnamecontroller
                                                          .clear();
                                                      hindprocessindicator(
                                                          context);
                                                      Navigator.pop(context);
                                                    } else {
                                                      showtoast(
                                                          context,
                                                          'Please Enter Group Name',
                                                          3);
                                                    }
                                                  },
                                                  child: buttonwidget(
                                                      context,
                                                      'Submit',
                                                      bgSecondry1,
                                                      bgSecondry2,
                                                      Colors.white),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      )),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ).then((value) {
                    setState(() {});
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
            )
          : Container(),
    );
  }

  void onchange(String value) {}

  validatorInput(String? value, String s) {}

  Future getadmindata() async {
    await FirebaseFirestore.instance
        .collection('Rooms')
        .doc(widget.roomId)
        .get()
        .then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        adminPhoneNumber = snapshot['admin']['phoneNumber'];
      }
      print(adminPhoneNumber);
    });
    loginPhoneNumber =
        FirebaseAuth.instance.currentUser!.phoneNumber.toString();
    if (loginPhoneNumber == adminPhoneNumber) {
      isadmin = true;
    } else {
      isadmin = false;
    }
    setState(() {});
  }
}
