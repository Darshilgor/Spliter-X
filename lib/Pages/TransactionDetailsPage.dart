import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spliter_x/Models/TransactionDetailsModel.dart';
import 'package:spliter_x/Services/Conts.dart';
import 'package:spliter_x/Services/Functions.dart';
import 'package:spliter_x/Services/Widgets.dart';

class TransactionDetailsPage extends StatefulWidget {
  String roomid;
  String groupid;
  String transactionid;
  bool addtransaction;
  bool isadmin;
  TransactionDetailsPage(
      {super.key,
      required this.roomid,
      required this.groupid,
      required this.transactionid,
      required this.addtransaction,
      required this.isadmin});

  @override
  State<TransactionDetailsPage> createState() => _TransactionDetailsPageState();
}

class _TransactionDetailsPageState extends State<TransactionDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction Details'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        child: FutureBuilder(
          future: getTransactionDetails(widget.transactionid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<transactionDetailsModel> list;
              list = snapshot.data!;
              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      formField(
                        context,
                        'Description',
                        'Shopping',
                        TextEditingController(
                            text: list[index].description.toString()),
                        false,
                        TextInputType.none,
                        onchange,
                        (value) =>
                            validatorInput(value, 'Please Enter Description'),
                      ),
                      formField(
                        context,
                        'Amount',
                        '1000',
                        TextEditingController(
                            text: list[index].totalAmount.toString()),
                        false,
                        TextInputType.none,
                        onchange,
                        (value) =>
                            validatorInput(value, 'Please Enter Description'),
                      ),
                      formField(
                        context,
                        'Payment Mode',
                        'Online',
                        TextEditingController(
                            text: list[index].paymentMode.toString()),
                        false,
                        TextInputType.none,
                        onchange,
                        (value) =>
                            validatorInput(value, 'Please Enter Description'),
                      ),
                      formField(
                        context,
                        'Transaction Date',
                        '15/04/2024',
                        TextEditingController(
                            text: DateFormat('dd/MM/yyyy   HH:mm:ss')
                                .format(list[index].timeStamp as DateTime)
                                .toString()),
                        false,
                        TextInputType.none,
                        onchange,
                        (value) =>
                            validatorInput(value, 'Please Enter Description'),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Transaction Details',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: list[index].members!.length,
                        itemBuilder: (context, index1) {
                          return Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 10),
                                width: double.infinity,
                                height: 50,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      textAlign: TextAlign.start,
                                      list[index]
                                          .members![index1]
                                          .name
                                          .toString(),
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
                                    style: BorderStyle.solid,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
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
                                        TextEditingController(
                                          text: list[index]
                                              .members![index1]
                                              .expense
                                              .toString(),
                                        ),
                                        false,
                                        TextInputType.none,
                                        onchange,
                                        (value) => validatorInput(
                                            value, 'Please Enter Amount'),
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
                                        TextEditingController(
                                          text: list[index]
                                              .members![index1]
                                              .spends
                                              .toString(),
                                        ),
                                        false,
                                        TextInputType.none,
                                        onchange,
                                        (value) => validatorInput(
                                            value, 'Please Enter Amount'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (index1 != list[index].members!.length - 1)
                                subDivider(),
                            ],
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: bgSecondry1,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    bgSecondry2,
                  ),
                ),
              );
            }
          },
        ),
      ),
      bottomNavigationBar: Visibility(
        visible: widget.addtransaction && widget.isadmin,
        child: BottomAppBar(
          color: Colors.white,
          child: GestureDetector(
            onTap: () async {
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
                                    'Are you sure,You want to delete this transaction',
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
                                            await deleteTransaction(
                                                    widget.isadmin,
                                                    widget.roomid,
                                                    widget.groupid,
                                                    widget.transactionid)
                                                .whenComplete(
                                              () {
                                                if (widget.roomid.isNotEmpty &&
                                                    widget.groupid.isNotEmpty &&
                                                    widget.isadmin == true) {
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);

                                                  hindprocessindicator(context);

                                                  Navigator.pushNamed(context,
                                                      '/roomList/transactioGroupList/transactionList',
                                                      arguments: {
                                                        'roomid': widget.roomid,
                                                        'groupid':
                                                            widget.groupid,
                                                        'isadmin':
                                                            widget.isadmin,
                                                      });
                                                }
                                              },
                                            );
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
              setState(() {});
            },
            child: buttonwidget(
              context,
              'Delete Transaction',
              bgSecondry1,
              bgSecondry2,
              Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void onchange(String value) {
    // Perform any actions you want with the changed text
  }

  validatorInput(String? value, String s) {}
}
