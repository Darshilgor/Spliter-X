import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:spliter_x/Models/AmountSplitModel.dart';
import 'package:spliter_x/Models/ShowTransactionListModel.dart';
import 'package:spliter_x/Models/TransactionGroupModel.dart';
import 'package:spliter_x/Pages/TransactionGroupPage.dart';
import 'package:spliter_x/Services/Conts.dart';
import 'package:spliter_x/Services/Functions.dart';
import 'package:spliter_x/Services/Widgets.dart';

class TransactionListPage extends StatefulWidget {
  String roomid;
  String groupid;
  bool isadmin;
  TransactionListPage(
      {super.key,
      required this.roomid,
      required this.groupid,
      required this.isadmin});

  @override
  State<TransactionListPage> createState() => _TransactionListPageState();
}

class _TransactionListPageState extends State<TransactionListPage> {
  bool addtransaction = true;
  bool loading = true;

  List<TransactionGroupModel> transactionDetailsListAfterClose = [];
  List<ShowTransactionListModel> transactionListAfterClose = [];
  List<String> leftNameList = [];
  List<String> rightNameList = [];
  List<double> leftAmountList = [];
  List<double> rightAmountList = [];
  List<AmountSplitModel> amountSplitList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkcompletiontime();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: bgSecondry2,
        title: const Text(
          'Transaction List',
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 20,
            ),
            child: GestureDetector(
              onTap: () {
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
                                      itemCount: 1,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            formField(
                                              context,
                                              'Group Name',
                                              'April-1',
                                              TextEditingController(
                                                  text:
                                                      transactionListAfterClose[
                                                              index]
                                                          .groupName),
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
                                              '1000',
                                              TextEditingController(
                                                  text:
                                                      transactionListAfterClose[
                                                              index]
                                                          .totalExpanse),
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
                                              '15/04/2024 09:30:30',
                                              TextEditingController(
                                                  text: DateFormat(
                                                          'dd/MM/yyyy   HH:mm:ss')
                                                      .format(
                                                          transactionListAfterClose[
                                                                  index]
                                                              .createionTime!)),
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
                                              'Closing Time',
                                              '16/04/2024 09:30:30',
                                              TextEditingController(
                                                  text: addtransaction == false
                                                      ? DateFormat(
                                                              'dd/MM/yyyy   HH:mm:ss')
                                                          .format(
                                                              transactionListAfterClose[
                                                                      index]
                                                                  .completedTime!)
                                                      : 'null'),
                                              false,
                                              TextInputType.none,
                                              onchange,
                                              (value) => validatorInput(
                                                value,
                                                'Please Enter Description',
                                              ),
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
      body: loading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: bgSecondry1,
                valueColor: AlwaysStoppedAnimation<Color>(
                  bgSecondry2,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    if (addtransaction == false &&
                        transactionDetailsListAfterClose.isNotEmpty &&
                        transactionListAfterClose.isNotEmpty)
                      Column(
                        children: [
                          Center(
                              child: Text(
                            'Who Pays Whom How Much',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          )),
                          SizedBox(
                            height: 5,
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: transactionDetailsListAfterClose.length,
                            itemBuilder: (context, index) {
                              amountSplitList = calculateAmountSplit(
                                  transactionDetailsListAfterClose[index]);
                              if (amountSplitList.isNotEmpty) {
                                return Column(
                                  children: [
                                    Column(
                                      children: [
                                        for (int i = 0;
                                            i < amountSplitList.length;
                                            i++)
                                          Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  bottom: 10,
                                                ),
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                  ),
                                                  width: double.infinity,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Colors.white,
                                                        style:
                                                            BorderStyle.solid),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Flexible(
                                                              child: Text(
                                                                amountSplitList[
                                                                        i]
                                                                    .leftMember
                                                                    .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 18,
                                                                ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Flexible(
                                                              child: Text(
                                                                amountSplitList[
                                                                        i]
                                                                    .amount
                                                                    .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 18,
                                                                ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Flexible(
                                                              child: Text(
                                                                amountSplitList[
                                                                        i]
                                                                    .rightMember
                                                                    .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 18,
                                                                ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Members Group Details',
                                          style: TextStyle(fontSize: 16),
                                        )),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    if (amountSplitList.isNotEmpty)
                                      for (int i = 0;
                                          i <
                                              transactionDetailsListAfterClose[
                                                      index]
                                                  .currentMonthTransactions!
                                                  .length;
                                          i++)
                                        Column(
                                          children: [
                                            Container(
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                              width: double.infinity,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 1,
                                                    color: Colors.white,
                                                    style: BorderStyle.solid),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    transactionDetailsListAfterClose[
                                                            index]
                                                        .currentMonthTransactions![
                                                            i]
                                                        .name
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10, right: 5),
                                                    child: formField(
                                                      context,
                                                      'Expense',
                                                      '1000',
                                                      TextEditingController(
                                                          text: double.parse(
                                                                  transactionDetailsListAfterClose[
                                                                          index]
                                                                      .currentMonthTransactions![
                                                                          i]
                                                                      .expense
                                                                      .toString())
                                                              .toStringAsFixed(
                                                                  2)),
                                                      false,
                                                      TextInputType.number,
                                                      onchange,
                                                      (value) => validatorInput(
                                                          value,
                                                          'Please Enter Amount'),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5, right: 10),
                                                    child: formField(
                                                      context,
                                                      'Spends',
                                                      '1000',
                                                      TextEditingController(
                                                          text: double.parse(
                                                                  transactionDetailsListAfterClose[
                                                                          index]
                                                                      .currentMonthTransactions![
                                                                          i]
                                                                      .spends
                                                                      .toString())
                                                              .toStringAsFixed(
                                                                  2)),
                                                      false,
                                                      TextInputType.number,
                                                      onchange,
                                                      (value) => validatorInput(
                                                          value,
                                                          'Please Enter Amount'),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (i !=
                                                transactionDetailsListAfterClose[
                                                            index]
                                                        .currentMonthTransactions!
                                                        .length -
                                                    1)
                                              subDivider()
                                          ],
                                        ),
                                  ],
                                );
                              }
                              if (amountSplitList.isEmpty) {
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
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Transactions List',
                                style: TextStyle(fontSize: 16),
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: transactionListAfterClose.length,
                            itemBuilder: (context, index) {
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: transactionListAfterClose[index]
                                    .transactionList!
                                    .length,
                                itemBuilder: (context, index1) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 10,
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        // callnextscreen(
                                        //   context,
                                        //   TransactionDetailsPage(
                                        //     roomid: widget.roomid!,
                                        //     groupid: widget.groupid!,
                                        //     transactionid:
                                        //         transactionListAfterClose[index]
                                        //             .transactionList![index1]
                                        //             .id
                                        //             .toString(),
                                        //     addtransaction: addtransaction,
                                        //     isadmin: widget.isadmin!,
                                        //   ),
                                        // );
                                        Navigator.pushNamed(context,
                                            '/roomList/transactionGroupList/transactionList/transactionListDetails',
                                            arguments: {
                                              'roomid': widget.roomid,
                                              'groupid': widget.groupid,
                                              'transactionid':
                                                  transactionListAfterClose[
                                                          index]
                                                      .transactionList![index1]
                                                      .id
                                                      .toString(),
                                              'addtransaction': addtransaction,
                                              'isadmin': widget.isadmin,
                                            });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          // border: Border.all(color: bgSecondry2),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: ListTile(
                                          title: Text(
                                              transactionListAfterClose[index]
                                                  .transactionList![index1]
                                                  .description
                                                  .toString()),
                                          subtitle: Text(DateFormat(
                                                  'dd/MM/yyyy   HH:mm:ss')
                                              .format(transactionListAfterClose[
                                                      index]
                                                  .transactionList![index1]
                                                  .timeStamp!)),
                                          trailing: Text(
                                            transactionListAfterClose[index]
                                                .transactionList![index1]
                                                .totalAmount
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    if (addtransaction == true)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: transactionListAfterClose.length,
                        itemBuilder: (context, index) {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: transactionListAfterClose[index]
                                .transactionList!
                                .length,
                            itemBuilder: (context, index1) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 10,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context,
                                        '/roomList/transactionGroupList/transactionList/transactionListDetails',
                                        arguments: {
                                          'roomid': widget.roomid,
                                          'groupid': widget.groupid,
                                          'transactionid':
                                              transactionListAfterClose[index]
                                                  .transactionList![index1]
                                                  .id
                                                  .toString(),
                                          'addtransaction': addtransaction,
                                          'isadmin': widget.isadmin
                                        });
                                    // callnextscreen(
                                    //     context,
                                    //     TransactionDetailsPage(
                                    //       roomid: widget.roomid!,
                                    //       groupid: widget.groupid!,
                                    //       transactionid:
                                    //           transactionListAfterClose[index]
                                    //               .transactionList![index1]
                                    //               .id
                                    //               .toString(),
                                    //       addtransaction: addtransaction,
                                    //       isadmin: widget.isadmin!,
                                    //     ));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      // border: Border.all(color: bgSecondry2),
                                      borderRadius: BorderRadius.circular(
                                        6,
                                      ),
                                    ),
                                    child: ListTile(
                                      title: Text(
                                          transactionListAfterClose[index]
                                              .transactionList![index1]
                                              .description
                                              .toString()),
                                      subtitle: Text(DateFormat(
                                              'dd/MM/yyyy   HH:mm:ss')
                                          .format(
                                              transactionListAfterClose[index]
                                                  .transactionList![index1]
                                                  .timeStamp!)),
                                      trailing: Text(
                                        transactionListAfterClose[index]
                                            .transactionList![index1]
                                            .totalAmount
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: loading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: bgSecondry1,
                valueColor: AlwaysStoppedAnimation<Color>(
                  bgSecondry2,
                ),
              ),
            )
          : Visibility(
              visible: widget.isadmin == true,
              child: BottomAppBar(
                color: Colors.white,
                child: Column(
                  children: [
                    Visibility(
                      visible: addtransaction == true,
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
                                                'Are you sure,You want to close and calculate this transaction group',
                                                style: TextStyle(
                                                    color: Colors.black),
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
                                                        showprocessindicator(
                                                            context);

                                                        if (widget.roomid
                                                                .isNotEmpty &&
                                                            widget.groupid
                                                                .isNotEmpty) {
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'TransactionGroups')
                                                              .doc(widget
                                                                  .groupid)
                                                              .update({
                                                            'completeTime':
                                                                DateTime.now(),
                                                          }).then((value) async {
                                                            DocumentSnapshot
                                                                snapshot =
                                                                await FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'Rooms')
                                                                    .doc(widget
                                                                        .roomid)
                                                                    .get();
                                                            if (snapshot
                                                                .exists) {
                                                              print(
                                                                  'inside the rooms collection!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
                                                              List
                                                                  transactionlist =
                                                                  snapshot[
                                                                      'transactionGroups'];
                                                              transactionlist
                                                                  .forEach(
                                                                      (element) async {
                                                                if (element[
                                                                        'Id'] ==
                                                                    widget
                                                                        .groupid) {
                                                                  element['Active'] =
                                                                      false;
                                                                }
                                                              });
                                                              print(
                                                                  'inside the rooms collection!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
                                                              await snapshot
                                                                  .reference
                                                                  .update({
                                                                'transactionGroups':
                                                                    transactionlist
                                                              });
                                                            }
                                                            addtransaction =
                                                                false;
                                                          }).whenComplete(() {
                                                            Navigator.pop(
                                                                context);

                                                            hindprocessindicator(
                                                                context);

                                                            Navigator
                                                                .pushReplacementNamed(
                                                                    context,
                                                                    '/roomList/transactioGroupList/transactionList',
                                                                    arguments: {
                                                                  'roomid': widget
                                                                      .roomid,
                                                                  'groupid': widget
                                                                      .groupid,
                                                                  'isadmin': widget
                                                                      .isadmin,
                                                                });
                                                          });
                                                        }
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

                          // removeandcallnextscreen(
                          //     context,
                          //     TransactionListPage(
                          //       roomid: widget.roomid,
                          //       groupid: widget.groupid,
                          //       isadmin: widget.isadmin,
                          //     ));
                        },
                        child: buttonwidget(
                          context,
                          'Close Group and Calculate',
                          bgSecondry1,
                          bgSecondry2,
                          Colors.white,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: addtransaction == false,
                      child: GestureDetector(
                        onTap: () {
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
                                                'Are you sure,You want to delete this transaction group',
                                                style: TextStyle(
                                                    color: Colors.black),
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
                                                        showprocessindicator(
                                                            context);
                                                        await deleteTransactionGroup(
                                                                widget.groupid,
                                                                widget.roomid)
                                                            .whenComplete(() {
                                                          Navigator.pop(
                                                              context);
                                                              Navigator.pop(
                                                              context);
                                                          hindprocessindicator(
                                                              context);
                                                          Navigator.pushReplacementNamed(
                                                              context,
                                                              '/roomList/transactioGroupList',
                                                              arguments: {
                                                                'roomId': widget
                                                                    .roomid,
                                                              });
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
                          'Delete Transaction Group',
                          bgSecondry1,
                          bgSecondry2,
                          Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
      resizeToAvoidBottomInset: false,
      floatingActionButton: loading
          ? Container()
          : Visibility(
              visible: addtransaction && widget.isadmin!,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context,
                      '/roomList/transactioGroupList/transactionList/addTransaction',
                      arguments: {
                        'roomid': widget.roomid,
                        'groupid': widget.groupid,
                        'isadmin': widget.isadmin,
                      });
                  // callnextscreen(
                  //   context,
                  //   AddTransactionPage(
                  //     roomid: widget.roomid!,
                  //     groupid: widget.groupid!,
                  //     isadmin: widget.isadmin!,
                  //   ),
                  // );
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 10,
                    bottom: 20,
                  ),
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
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  Future checkcompletiontime() async {
    await FirebaseFirestore.instance
        .collection('TransactionGroups')
        .doc(widget.groupid)
        .get()
        .then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        if (snapshot['completeTime'] != null) {
          addtransaction = false;
          setState(() {});
        } else {
          addtransaction = true;
          setState(() {});
        }
      }
    }).whenComplete(() async {
      transactionListAfterClose =
          await gettransactionlist(widget.groupid!, addtransaction);
      setState(() {});
      print(
          'showTransactionList/////////////////////!!!!!!!!!!!!!!!!!!${transactionListAfterClose}');
      if (addtransaction == false && transactionDetailsListAfterClose.isEmpty) {
        transactionDetailsListAfterClose =
            await gettransactiongroupdetailsafterclose(widget.groupid!);
      }
      loading = false;
    });
    setState(() {});
  }

  void onchange(String value) {}

  validatorInput(String? value, String s) {}

  List<AmountSplitModel> calculateAmountSplit(
      TransactionGroupModel transactionDetailsListAfterClose) {
    if (rightNameList.isEmpty) {
      for (final currentTransaction
          in transactionDetailsListAfterClose.currentMonthTransactions!) {
        if (double.parse(currentTransaction.expense!) <
            double.parse(currentTransaction.spends!)) {
          rightNameList.add(currentTransaction.name!);
          rightAmountList.add(double.parse(currentTransaction.spends!) -
              double.parse(currentTransaction.expense!));
        } else if (double.parse(currentTransaction.expense!) >
            double.parse(currentTransaction.spends!)) {
          leftNameList.add(currentTransaction.name!);
          leftAmountList.add(double.parse(currentTransaction.expense!) -
              double.parse(currentTransaction.spends!));
        }
      }
    }
    if (amountSplitList.isEmpty && rightAmountList.isNotEmpty) {
      for (int i = 0; i < rightAmountList.length; i++) {
        for (int j = 0; j < leftAmountList.length; j++) {
          if (leftAmountList[j] < rightAmountList[i]) {
            rightAmountList[i] = rightAmountList[i] - leftAmountList[j];
            amountSplitList.add(AmountSplitModel(
              leftMember: leftNameList[j],
              rightMember: rightNameList[i],
              amount: double.parse(leftAmountList[j].toStringAsFixed(2)),
            ));
            leftAmountList[j] = 0;
          } else if (leftAmountList[j] > rightAmountList[i]) {
            leftAmountList[j] = leftAmountList[j] - rightAmountList[i];
            amountSplitList.add(
              AmountSplitModel(
                leftMember: leftNameList[j],
                rightMember: rightNameList[i],
                amount: double.parse(rightAmountList[i].toStringAsFixed(2)),
              ),
            );
            rightAmountList[i] = 0;
          } else if (leftAmountList[j] == rightAmountList[i] &&
              leftAmountList[j] != 0 &&
              rightAmountList[i] != 0) {
            amountSplitList.add(AmountSplitModel(
              leftMember: leftNameList[j],
              rightMember: rightNameList[i],
              amount: double.parse(rightAmountList[i].toStringAsFixed(2)),
            ));
            leftAmountList[j] = 0;
            rightAmountList[i] = 0;
          }
        }
      }
    }
    return amountSplitList;
  }
}
