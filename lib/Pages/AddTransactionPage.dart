import 'package:flutter/material.dart';
import 'package:spliter_x/Models/UserModel.dart';
import 'package:spliter_x/Services/Conts.dart';
import 'package:spliter_x/Services/Functions.dart';
import 'package:spliter_x/Services/Widgets.dart';

class AddTransactionPage extends StatefulWidget {
  String roomid;
  String groupid;
  bool isadmin;
  AddTransactionPage(
      {super.key,
      required this.roomid,
      required this.groupid,
      required this.isadmin});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController paymentAmountController = TextEditingController();

  List<TextEditingController> expanseControllerList = [];
  List<TextEditingController> spentControllerList = [];

  String paymentModeController = 'Online';

  bool getdata = false;

  List<UserModel> list = [];
  bool getsnapshot = false;

  List<UserModel> memberList = [];
  List<UserModel> selectedMemberList = [];

  String radioButtonSelectedValue = 'No';

  List<FocusNode> expenseFocusNodes = [];
  List<FocusNode> spendsFocusNodes = [];

  List<bool> isselected1 = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Transaction'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              formField(
                context,
                'Enter Description',
                'Shopping',
                descriptionController,
                true,
                TextInputType.name,
                onchange,
                (value) => validatorInput(value, 'Please Enter Description'),
              ),
              formField(
                context,
                'Enter Amount',
                '1000',
                paymentAmountController,
                true,
                TextInputType.number,
                onchange,
                (value) => validatorInput(value, 'Please Enter Amount'),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  left: 13,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(
                    6,
                  ),
                ),
                child: Expanded(
                  child: DropdownButton<String>(
                    underline: Container(),
                    value: paymentModeController, // Currently selected item
                    onChanged: (String? newValue) {
                      setState(() {
                        paymentModeController =
                            newValue!; // Set the selected item
                      });
                    },
                    items: <String>[
                      'Online',
                      'Card',
                      'Cash'
                    ] // List of dropdown items
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                            value), // Text displayed for each dropdown item
                      );
                    }).toList(),
                    icon: Icon(null),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                'Split Equally',
                textAlign: TextAlign.left,
              ),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile(
                      value: 'Yes',
                      groupValue: radioButtonSelectedValue,
                      onChanged: (value) {
                        setState(() {
                          radioButtonSelectedValue = value.toString();
                        });
                      },
                      title: Text('Yes'),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile(
                      value: 'No',
                      groupValue: radioButtonSelectedValue,
                      onChanged: (value) {
                        setState(() {
                          radioButtonSelectedValue = value.toString();
                        });
                      },
                      title: Text('No'),
                    ),
                  ),
                ],
              ),
              if (radioButtonSelectedValue == 'No')
                ListView.builder(
                  shrinkWrap: true, // Added this line
                  physics: NeverScrollableScrollPhysics(), // Added this line
                  itemCount: selectedMemberList.length,
                  itemBuilder: (context, index) {
                    if (expenseFocusNodes.isEmpty || spendsFocusNodes.isEmpty) {
                      expenseFocusNodes = List.generate(
                        selectedMemberList.length,
                        (index) => FocusNode(),
                      );

                      spendsFocusNodes = List.generate(
                        selectedMemberList.length,
                        (index) => FocusNode(),
                      );
                    }
                    return Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            left: 10,
                          ),
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color: Colors.white,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(
                              6,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                textAlign: TextAlign.start,
                                selectedMemberList[index].name.toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                  right: 5,
                                ),
                                child: formField(
                                  context,
                                  'Expense',
                                  '1000',
                                  expanseControllerList[index],
                                  true,
                                  TextInputType.number,
                                  onchange,
                                  (value) => validatorInput(
                                      value, 'Please Enter Amount'),
                                  onFieldSubmitted: () {
                                    FocusScope.of(context)
                                        .requestFocus(spendsFocusNodes[index]);
                                  },
                                  focusNode: expenseFocusNodes[index],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 5,
                                  right: 10,
                                ),
                                child: formField(
                                  context,
                                  'Spends',
                                  '1000',
                                  spentControllerList[index],
                                  true,
                                  TextInputType.number,
                                  onchange,
                                  (value) => validatorInput(
                                      value, 'Please Enter Amount'),
                                  onFieldSubmitted: () {
                                    if (index ==
                                        selectedMemberList.length - 1) {
                                    } else {
                                      // Request focus on the next "Expense" field
                                      FocusScope.of(context).requestFocus(
                                          expenseFocusNodes[index + 1]);
                                    }
                                  },
                                  focusNode: spendsFocusNodes[index],
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (index != selectedMemberList.length - 1)
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: 15,
                              left: 40,
                              right: 40,
                            ),
                            child: Divider(
                              height: 2,
                              thickness: 1,
                              color: Colors.white,
                            ),
                          ),
                      ],
                    );
                  },
                ),
              if (radioButtonSelectedValue == 'Yes')
                ListView.builder(
                  shrinkWrap: true, // Added this line
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: selectedMemberList.length,
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              bottom: 15,
                            ),
                            child: Container(
                              padding: EdgeInsets.only(
                                left: 10,
                              ),
                              height: 50,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    textAlign: TextAlign.start,
                                    selectedMemberList[index].name.toString(),
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color: Colors.white,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(
                                  6,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 5,
                              right: 10,
                            ),
                            child: formField(
                                context,
                                'Spends',
                                '1000',
                                spentControllerList[index],
                                true,
                                TextInputType.number,
                                onchange,
                                (value) => validatorInput(
                                    value, 'Please Enter Amount')),
                          ),
                        ),
                      ],
                    );
                  },
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: GestureDetector(
          onTap: () async {
            showprocessindicator(context);
            setState(() {});

            if (descriptionController.text.isEmpty) {
              showtoast(context, 'Enter Description', 3);
              hindprocessindicator(context);
              return;
            } else if (paymentAmountController.text.isEmpty) {
              showtoast(context, 'Enter Amount', 3);
              hindprocessindicator(context);
              return;
            }
            if (selectedMemberList.length == 1) {
              showtoast(context, 'Please select atlease 2 member', 3);
              hindprocessindicator(context);
              return;
            }
            if (selectedMemberList.length < 2) {
              showtoast(context, 'Please Select Member', 3);
              hindprocessindicator(context);
              return;
            }
            if (radioButtonSelectedValue == 'Yes') {
              bool isspendnull = false;
              spentControllerList.forEach((element) {
                if (element.text.isEmpty) {
                  isspendnull = true;
                  return;
                }
              });
              setState(() {});
              if (isspendnull == true) {
                showtoast(context, 'Enter Spends Amount', 3);
                hindprocessindicator(context);
                return;
              } else {
                int amount = int.parse(paymentAmountController.text);
                for (int i = 0; i < selectedMemberList.length; i++) {
                  selectedMemberList[i].spends =
                      spentControllerList[i].text.toString();

                  selectedMemberList[i].expense =
                      (amount / selectedMemberList.length).toString();
                }
                double totalspendamount = 0.0;
                spentControllerList.forEach((element) {
                  totalspendamount += double.parse(element.text.toString());
                });
                if (totalspendamount !=
                    double.parse(paymentAmountController.text.toString())) {
                  showtoast(context, 'Enter Valid Spend Amount', 3);
                  hindprocessindicator(context);
                  return;
                } else {
                  showprocessindicator(context);
                  addTransaction(
                          widget.roomid,
                          widget.groupid,
                          paymentAmountController.text,
                          paymentModeController,
                          selectedMemberList,
                          descriptionController.text)
                      .whenComplete(() {
                    hindprocessindicator(context);
                    // removeandcallnextscreen(
                    // context,
                    // TransactionListPage(
                    //   roomid: widget.roomid,
                    //   groupid: widget.groupid,
                    //   isadmin: widget.isadmin,
                    // ));
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context,
                        '/roomList/transactioGroupList/transactionList',
                        arguments: {
                          'roomid': widget.roomid,
                          'groupid': widget.groupid,
                          'isadmin': widget.isadmin,
                        });
                  });
                }
              }
              hindprocessindicator(context);
            }
            if (radioButtonSelectedValue == 'No') {
              bool isspendnull = false;
              bool isexpansenull = false;
              spentControllerList.forEach((element) async {
                if (element.text.isEmpty) {
                  isspendnull = true;
                  return;
                }
              });
              expanseControllerList.forEach((element) {
                if (element.text.isEmpty) {
                  isexpansenull = true;
                  return;
                }
              });
              setState(() {});
              if (isexpansenull == true && isexpansenull == true) {
                showtoast(context, 'Please Enter Expanse And Spend Amout', 3);
                hindprocessindicator(context);
                return;
              } else if (isexpansenull == true) {
                showtoast(context, 'Please Enter Expanse Amount', 3);
                hindprocessindicator(context);
                return;
              } else if (isspendnull == true) {
                showtoast(context, 'Please Enter Spend Amount', 3);
                hindprocessindicator(context);
                return;
              } else {
                for (int i = 0; i < selectedMemberList.length; i++) {
                  selectedMemberList[i].spends =
                      spentControllerList[i].text.toString();

                  selectedMemberList[i].expense =
                      expanseControllerList[i].text.toString();
                }
                double totalexpanse = 0.0;
                double totalspend = 0.0;
                expanseControllerList.forEach((element) {
                  totalexpanse += double.parse(element.text.toString());
                });
                spentControllerList.forEach((element) {
                  totalspend += double.parse(element.text.toString());
                });
                if (totalspend !=
                    double.parse(paymentAmountController.text.toString())) {
                  showtoast(context, 'Please Enter Valid Spend Amount', 3);
                  hindprocessindicator(context);
                  return;
                }
                if (totalexpanse !=
                    double.parse(paymentAmountController.text.toString())) {
                  showtoast(context, 'Please Enter Valid Expanse Amount', 3);
                  hindprocessindicator(context);
                  return;
                } else {
                  Navigator.pop(context);
                  showprocessindicator(context);
                  addTransaction(
                          widget.roomid,
                          widget.groupid,
                          paymentAmountController.text,
                          paymentModeController,
                          selectedMemberList,
                          descriptionController.text)
                      .whenComplete(() {
                    // removeandcallnextscreen(
                    //   context,
                    //   TransactionListPage(
                    //     roomid: widget.roomid,
                    //     groupid: widget.groupid,
                    //     isadmin: widget.isadmin,
                    //   ),
                    // );
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context,
                        '/roomList/transactioGroupList/transactionList',
                        arguments: {
                          'roomid': widget.roomid,
                          'groupid': widget.groupid,
                          'isadmin': widget.isadmin,
                        });
                  });
                }
              }
              hindprocessindicator(context);
            }
          },
          child: buttonwidget(
            context,
            'Add Transaction',
            bgSecondry1,
            bgSecondry2,
            Colors.white,
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool update = false;
          List<bool> isselected = [];
          isselected = List.from(isselected1);
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  
                  return Dialog(
                    child: SizedBox(
                      height: 500,
                      child: Material(
                        color: Colors.white,
                        child: FutureBuilder(
                          future: getmemberlist(widget.roomid, widget.groupid),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (memberList.isEmpty) {
                                memberList = snapshot.data!;
                              }
                              if (isselected.isEmpty) {
                                isselected = List.generate(
                                    snapshot.data!.length, (_) => false);
                              }
                              if (isselected1.isEmpty) {
                                isselected1 = List.generate(
                                    snapshot.data!.length, (index) => false);
                              }
                              return Column(
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: memberList.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            top: 10,
                                            bottom: 5,
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              isselected[index] =
                                                  !isselected[index];
                                              
                                              setState(() {});
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: double.infinity,
                                              height: 50,
                                              child: Text(
                                                memberList[index]
                                                    .name
                                                    .toString(),
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                color: isselected[index]
                                                    ? Colors.red
                                                    : Colors.white,
                                                border: Border.all(
                                                    width: 1,
                                                    color: Colors.black,
                                                    style: BorderStyle.solid),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  6,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            bottom: 10,
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                             
                                              update = false;
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
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            bottom: 10,
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              selectedMemberList.clear();
                                              for (int i = 0;
                                                  i < isselected.length;
                                                  i++) {
                                                if (isselected[i] == true) {
                                                  selectedMemberList
                                                      .add(memberList[i]);

                                                  expanseControllerList =
                                                      List.generate(
                                                    selectedMemberList.length,
                                                    (index) =>
                                                        TextEditingController(),
                                                  );
                                                  spentControllerList =
                                                      List.generate(
                                                    selectedMemberList.length,
                                                    (index) =>
                                                        TextEditingController(),
                                                  );
                                                }
                                              }
                                              update = true;
                                              

                                              expenseFocusNodes = [];
                                              spendsFocusNodes = [];

                                              Navigator.pop(context);
                                            },
                                            child: buttonwidget(
                                              context,
                                              'Submit',
                                              bgSecondry1,
                                              bgSecondry2,
                                              Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              );
                            } else {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ).then((value) {
            if (update == true) {
              isselected1 = List.from(isselected);
            }
            setState(() {});
          });
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
    );
  }

  onchange(String p1) {}

  String? validatorInput(String? value, String message) {
    if (value == null || value.isEmpty) {
      showtoast(context, message.toString(), 3);
    }
    return null;
  }
}
