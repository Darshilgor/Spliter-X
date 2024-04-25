import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spliter_x/Models/RoomsTransactionGroups.dart';
import 'package:spliter_x/Models/ShowRoomDetailsModel.dart';
import 'package:spliter_x/Models/ShowTransactionListModel.dart';
import 'package:spliter_x/Models/TransactionDetailsModel.dart';
import 'package:spliter_x/Models/TransactionGroupModel.dart';
import 'package:spliter_x/Models/UserModel.dart';
import 'package:spliter_x/Models/TransactionListModel.dart';
import 'package:spliter_x/Models/UserProfileModel.dart';
import 'package:spliter_x/Models/UsersTransaction.dart';
import 'package:spliter_x/Services/Conts.dart';
import 'package:spliter_x/Services/Widgets.dart';
import 'package:intl/intl.dart';

class GetRoomListMode {
  List<String>? roomIdList;
  List<String>? roomNameList;
  List<dynamic>? roomMemberLength;

  GetRoomListMode(
      {required this.roomIdList,
      required this.roomNameList,
      required this.roomMemberLength});
}

Stream<GetRoomListMode> getRoomListStream(String phoneNumber) {
  return FirebaseFirestore.instance.collection('Rooms').snapshots().map(
    (QuerySnapshot snapshot) {
      List<String> roomIdList = [];
      List<String> roomNameList = [];
      List<dynamic> roomMemberLength = [];

      snapshot.docs.forEach(
        (DocumentSnapshot document) {
          List<dynamic> currentMonthTransactions =
              document['currentMonthTransactions'];
          String roomId = document['roomId'];
          String roomName = document['name'];
          int memberLength = currentMonthTransactions.length;

          // Add data to lists if it matches your condition
          // For example, if you want to filter based on user's phone number
          // you can include your filtering logic here

          roomIdList.add(roomId);
          roomNameList.add(roomName);
          roomMemberLength.add(memberLength);
        },
      );

      return GetRoomListMode(
        roomIdList: roomIdList,
        roomNameList: roomNameList,
        roomMemberLength: roomMemberLength,
      );
    },
  );
}

// Future<GetRoomListMode> getroomlist(String phonenumber) async {
//   List<String>? roomIdList = [];
//   List<String>? roomNameList = [];
//   List<dynamic>? roomMemberLength = [];
//   await FirebaseFirestore.instance.collection('Rooms').get().then(
//     (QuerySnapshot snapshot) {
//       snapshot.docs.forEach(
//         (element) {
//           for (var i in element['currentMonthTransactions']) {
//             if (i['phoneNumber'] == phonenumber) {
//               roomIdList.add(element['roomId']);
//               roomNameList.add(element['name']);
//               roomMemberLength.add(element['currentMonthTransactions'].length);
//             }
//           }
//         },
//       );
//     },
//   );
//   return GetRoomListMode(
//       roomIdList: roomIdList,
//       roomNameList: roomNameList,
//       roomMemberLength: roomMemberLength);
//   // return roomIdList;
// }

Future adduserdetails(BuildContext context, String firstname, String lastnae,
    String gender, String phonenumber) async {
  await FirebaseFirestore.instance.collection('Users').doc(phonenumber).set({
    'firstName': firstname,
    'lastName': lastnae,
    'joinningDate': DateTime.now(),
    'gender': gender,
    'phoneNumber': phonenumber,
    'rooms': []
  }).then(
    (value) async {
      await Future.delayed(
        Duration(
          seconds: 2,
        ),
      );
      hindprocessindicator(context);
      // pushAndRemoveUntil(
      //   context,
      //   HomeScreenView(),
      // );
      Navigator.pushNamed(context, '/');
    },
  ).whenComplete(
    () async {
      List<String> roomid = [];
      await FirebaseFirestore.instance
          .collection('Rooms')
          .where('members', arrayContains: phonenumber)
          .get()
          .then(
        (QuerySnapshot snapshot) async {
          snapshot.docs.forEach(
            (element) async {
              roomid.add(element.id);
              await FirebaseFirestore.instance
                  .collection('Users')
                  .doc(phonenumber)
                  .update(
                {
                  'rooms': roomid,
                },
              );
            },
          );
        },
      );
    },
  );
}

Future<void> signUp(String phoneNumber, String firstname, String lastName,
    {String email = ''}) async {
  Map<String, String> transaction = {
    "spends": "0.0",
    "expense": "0.0",
  };
  await fire.collection("Users").doc(phoneNumber).set({
    'phoneNumber': phoneNumber,
    'firstName': firstname,
    'lastName': lastName,
    'email': email,
    'profileUrl': "",
    'rooms': [],
    'transactions': transaction,
    'timeStamp': DateTime.now()
  });
}

Future<void> addRoom(
  BuildContext context,
  String adminPhoneNumber,
  String adminName,
  String roomName,
  List<UserModel> memberlist,
) async {
  List<Map> tempList = [];

  for (int i = 0; i < memberlist.length; i++) {
    Map<String, String> temp = {};
    temp["phoneNumber"] = memberlist[i].mobileNumber.toString();
    temp["Name"] = memberlist[i].name.toString();
    temp["spends"] = memberlist[i].spends.toString();
    temp["expense"] = memberlist[i].expense.toString();
    tempList.add(temp);
  }
  DocumentReference docRef = fire.collection("Rooms").doc();
  await docRef.set({
    'roomProfileUrl': '',
    'roomId': docRef.id.toString(),
    'name': roomName,
    'admin': {'name': adminName, 'phoneNumber': adminPhoneNumber},
    'totalExpenseOfCurrentMonth': '0.0',
    'currentMonthTransactions': tempList,
    'transactionGroups': [],
    'timeStamp': DateTime.now(),
  }).whenComplete(() async {
    for (int i = 0; i < memberlist.length; i++) {
      await fire
          .collection('Users')
          .doc(memberlist[i].mobileNumber.toString())
          .update({
        'rooms': FieldValue.arrayUnion([docRef.id.toString()])
      });
    }
  });
}

Future gettransactiongrouplist(String roomId) async {
  List<RoomsTransactionGroups> transactiongrouplist = [];
  await FirebaseFirestore.instance.collection('Rooms').doc(roomId).get().then(
    (DocumentSnapshot snapshot) {
      // transactiongrouplist = snapshot['transactionGroups'];
      snapshot['transactionGroups'].forEach((element) {
        transactiongrouplist.add(RoomsTransactionGroups(
          active: element['Active'],
          id: element['Id'],
          name: element['Name'],
          timestamp: element['Timestamp'],
        ));
      });
    },
  );
  return transactiongrouplist;
}

Stream<List<RoomsTransactionGroups>> getTransactionGroupListStream(
    String roomId) {
  return FirebaseFirestore.instance
      .collection('Rooms')
      .doc(roomId)
      .snapshots()
      .map(
    (snapshot) {
      List<RoomsTransactionGroups> transactionGroupList = [];
      snapshot['transactionGroups'].forEach((element) {
        transactionGroupList.add(RoomsTransactionGroups(
          active: element['Active'],
          id: element['Id'],
          name: element['Name'],
          timestamp: element['Timestamp'],
        ));
      });
      return transactionGroupList;
    },
  );
}

Future<List<ShowTransactionListModel>> gettransactionlist(
    String id, bool addtransaction) async {
  List<TransactionListModel> transactionlistwithdetails = [];
  List<ShowTransactionListModel> showTransactionList = [];

  DocumentSnapshot snapshot = await FirebaseFirestore.instance
      .collection('TransactionGroups')
      .doc(id)
      .get();
  if (snapshot.exists) {
    String groupName = snapshot['groupName'];
    String totalExpense = snapshot['totalExpense'];
    DateTime creationTime = snapshot['timeStamp'].toDate();
    DateTime? completedTime =
        addtransaction == true ? null : snapshot['completeTime'].toDate();
    List<dynamic> transactionIds = [];
    List<TransactionList> list = [];
    transactionIds = snapshot['transactions'];
    transactionIds.forEach((element) {
      list.add(TransactionList(
        description: element['description'],
        id: element['id'],
        timeStamp: element['timeStamp'].toDate(),
        totalAmount: element['totalAmount'],
      ));
    });

    print('transactionIdstransactionIdstransactionIds$list');

    showTransactionList.add(ShowTransactionListModel(
      groupName: groupName,
      totalExpanse: totalExpense,
      createionTime: creationTime,
      completedTime: completedTime,
      transactionList: list,
    ));

    // final String timeStamp = DateFormat('dd/MM/yyyy   HH:mm:ss')
    //     .format(transactionIds['timeStamp'].toDate());
    // showTransactionList.add(
    //   ShowTransactionListModel(),
    // );
    // for (int i = 0; i < transactionIds.length; i++) {

    // }

    //   await Future.wait(
    //     transactionIds.map(
    //       (e) async {
    //         final DocumentSnapshot transactionSnapshot = await FirebaseFirestore
    //             .instance
    //             .collection('Transactions')
    //             .doc(e)
    //             .get();
    //         if (transactionSnapshot.exists) {
    //           final String timeStamp = DateFormat('dd/MM/yyyy   HH:mm:ss')
    //               .format(transactionSnapshot['timeStamp'].toDate());
    //           transactionlistwithdetails.add(
    //             TransactionListModel(
    //               transactionId: e,
    //               description: transactionSnapshot['description'],
    //               timeStamp: timeStamp,
    //               paymentMode: transactionSnapshot['paymentMode'],
    //               totalAmount: transactionSnapshot['totalAmount'],
    //               groupName: groupName,
    //               totalExpanse: totalExpense,
    //               createionTime: creationTime,
    //               completedTime: completedTime,
    //             ),
    //           );
    //         }
    //       },
    //     ).toList(),
    //   );
  }
  // .whenComplete(
  //   () {
  //     transactionlist.forEach(
  //       (id) async {
  //         await FirebaseFirestore.instance
  //             .collection('Transaction')
  //             .doc(id)
  //             .get()
  //             .then(
  //           (DocumentSnapshot snapshot) {
  //             if (snapshot.exists) {
  //               late String timeStamp;
  //               Timestamp timestamp =
  //                   snapshot['timeStamp']; // Retrieve the Firestore Timestamp
  //               DateTime dateTime = timestamp
  //                   .toDate(); // Convert Firestore Timestamp to DateTime
  //               timeStamp = DateFormat('dd/MM/yyyy').format(dateTime);
  //               print(timeStamp);
  //               print(snapshot['description']);
  //               print(id);
  //               transactionlistwithdetails.add(
  //                 TransactionListModel(
  //                   transactionId: id,
  //                   description: snapshot['description'],
  //                   timeStamp: timeStamp,
  //                 ),
  //               );
  //             }
  //           },
  //         );
  //       },
  //     );
  //   },
  // );

  showTransactionList.forEach((element) {
    if (element.transactionList != null) {
      element.transactionList!.sort((a, b) {
        // Compare the timeStamp of each TransactionList in descending order
        DateTime? timeStampA = a.timeStamp;
        DateTime? timeStampB = b.timeStamp;
        return timeStampB!.compareTo(timeStampA!);
      });
    }
  });
  return showTransactionList;
}

Future getroomdetails(String roomId) async {
  List<ShowRoomDetailsModel> list = [];
  await FirebaseFirestore.instance
      .collection('Rooms')
      .doc(roomId)
      .get()
      .then((DocumentSnapshot snapshot) {
    List<MemberList> memberList = [];
    if (snapshot.exists) {
      for (int i = 0; i < snapshot['currentMonthTransactions'].length; i++) {
        memberList.add(
          MemberList(
            memberName: snapshot['currentMonthTransactions'][i]['Name'],
            memberPhoneNumber: snapshot['currentMonthTransactions'][i]
                ['phoneNumber'],
            expanse: snapshot['currentMonthTransactions'][i]['expense'],
            spends: snapshot['currentMonthTransactions'][i]['spends'],
          ),
        );
      }
    }

    list.add(
      ShowRoomDetailsModel(
          adminName: snapshot['admin']['name'],
          adminPhoneNumber: snapshot['admin']['phoneNumber'],
          roomName: snapshot['name'],
          totalExpanse: snapshot['totalExpenseOfCurrentMonth'],
          timeStamp: snapshot['timeStamp'].toDate(),
          memberList: memberList),
    );
  });
  return list;
}

Future<void> addTransactionGroup(String roomId, String? groupName) async {
  List tempList = [];
  await fire.collection("Rooms").doc(roomId).get().then((snap) {
    tempList = snap['currentMonthTransactions'];
  });
  for (var element in tempList) {
    element["spends"] = "0.0";
    element["expense"] = "0.0";
  }
  DocumentReference docRef = fire.collection("TransactionGroups").doc();
  await docRef.set({
    'groupId': docRef.id.toString(),
    'groupName': groupName ??
        "${monthNames[DateTime.now().month - 1]} ${DateTime.now().year} ${docRef.id}",
    'totalExpense': '0.0',
    'currentMonthTransactions': tempList,
    'transactions': [],
    'timeStamp': DateTime.now(),
    'completeTime': null
  }).whenComplete(() async {
    Map<String, dynamic> temp = {};
    temp["Id"] = docRef.id.toString();
    temp["Name"] = groupName;
    temp["Active"] = true;
    temp["Timestamp"] =
        DateFormat('dd/MM/yyyy   HH:mm:ss').format(DateTime.now());
    await fire.collection("Rooms").doc(roomId).update({
      'transactionGroups': FieldValue.arrayUnion([temp])
    });
  });
}

Future<void> addTransaction(String roomid, String groupId, String totalAmount,
    String paymentMode, List<UserModel> membersList, String description) async {
  List<Map> tempList = [];
  List<UserModel> currentMonthTransactionsRoomList = [];
  List<UsetsTransactions> usersTranactionList = [];

  double roomTotalAmount = 0.0;
  for (int i = 0; i < membersList.length; i++) {
    Map<String, String> temp = {};

    double spend = double.parse(membersList[i].spends.toString());
    String formattedSpends = spend.toStringAsFixed(2);

    double expanse = double.parse(membersList[i].expense.toString());
    String formattedExpanses = expanse.toStringAsFixed(2);

    temp["phoneNumber"] = membersList[i].mobileNumber.toString();
    temp["Name"] = membersList[i].name.toString();
    temp["spends"] = formattedSpends;
    temp["expense"] = formattedExpanses;
    tempList.add(temp);
  }
  await FirebaseFirestore.instance
      .collection('Rooms')
      .doc(roomid)
      .get()
      .then((value) {
    if (value.exists) {
      roomTotalAmount =
          double.parse(value['totalExpenseOfCurrentMonth'].toString());
      for (int i = 0; i < value['currentMonthTransactions'].length; i++) {
        currentMonthTransactionsRoomList.add(UserModel(
          name: value['currentMonthTransactions'][i]['Name'],
          mobileNumber: value['currentMonthTransactions'][i]['phoneNumber'],
          expense: value['currentMonthTransactions'][i]['expense'],
          spends: value['currentMonthTransactions'][i]['spends'],
        ));
      }
    }
  });
  DocumentReference docRef = fire.collection("Transactions").doc();
  var timeStamp = DateTime.now();
  await docRef.set({
    'transactionId': docRef.id.toString(),
    'groupId': groupId,
    'description': description,
    'totalAmount': totalAmount,
    'paymentMode': paymentMode,
    'members': tempList,
    'timeStamp': timeStamp,
  }).whenComplete(() async {
    List<dynamic> temp = [];
    double total = 0.0;
    await fire.collection("TransactionGroups").doc(groupId).get().then((value) {
      temp = value["currentMonthTransactions"];
      total = double.parse(value["totalExpense"].toString());
    });
    for (int i = 0; i < membersList.length; i++) {
      total = total + double.parse(membersList[i].spends.toString());
      for (var j in temp) {
        if (j["phoneNumber"] == membersList[i].mobileNumber) {
          double tempSpends = double.parse(j["spends"].toString());
          j["spends"] =
              (tempSpends + double.parse(membersList[i].spends.toString()))
                  .toString();
          double tempExpense = double.parse(j["expense"].toString());
          j["expense"] =
              (tempExpense + double.parse(membersList[i].expense.toString()))
                  .toString();
        }
      }
    }
    var transactionsobject = {
      "description": description,
      "id": docRef.id.toString(),
      "timeStamp": timeStamp,
      "totalAmount": totalAmount,
    };
    await fire.collection("TransactionGroups").doc(groupId).update({
      'currentMonthTransactions': temp,
      'transactions': FieldValue.arrayUnion([transactionsobject]),
      'totalExpense': total.toString()
    }).whenComplete(() async {
      for (int i = 0; i < membersList.length; i++) {
        for (int j = 0; j < currentMonthTransactionsRoomList.length; j++) {
          if (membersList[i].mobileNumber ==
              currentMonthTransactionsRoomList[j].mobileNumber) {
            currentMonthTransactionsRoomList[j].expense = (double.parse(
                        currentMonthTransactionsRoomList[j]
                            .expense
                            .toString()) +
                    double.parse(membersList[i].expense.toString()))
                .toString();
            currentMonthTransactionsRoomList[j].spends = (double.parse(
                        currentMonthTransactionsRoomList[j].spends.toString()) +
                    double.parse(membersList[i].spends.toString()))
                .toString();
          }
        }
      }
      await FirebaseFirestore.instance.collection('Rooms').doc(roomid).update({
        'currentMonthTransactions': currentMonthTransactionsRoomList
            .map((usermodel) => usermodel.toJson())
            .toList(),
        'totalExpenseOfCurrentMonth':
            (roomTotalAmount + double.parse(totalAmount.toString())).toString(),
      });
    });
    for (int i = 0; i < membersList.length; i++) {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(membersList[i].mobileNumber)
          .get()
          .then((DocumentSnapshot snapshot) {
        if (snapshot.exists) {
          usersTranactionList.add(
            UsetsTransactions(
              expense: snapshot['transactions']['expense'].toString(),
              spends: snapshot['transactions']['spends'].toString(),
            ),
          );
        }
      });
    }
    for (int i = 0; i < usersTranactionList.length; i++) {
      usersTranactionList[i].expense =
          (double.parse(usersTranactionList[i].expense.toString()) +
                  double.parse(membersList[i].expense.toString()))
              .toString();
      usersTranactionList[i].spends =
          (double.parse(usersTranactionList[i].spends.toString()) +
                  double.parse(membersList[i].spends.toString()))
              .toString();
    }

    for (int i = 0; i < membersList.length; i++) {
      print(usersTranactionList[i].expense);
      print(usersTranactionList[i].spends);

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(membersList[i].mobileNumber)
          .update({
        'transactions': usersTranactionList[i].toJson(),
      });
    }
  });
}

Future deleteTransaction(
    bool isadmin, String roomid, String groupid, String transactionid) async {
  double roomtotalamount = 0.0;
  double transactionTotalAmount = 0.0;
  double transactiongrouptotalamount = 0.0;
  List<UserModel> transactionMemberList = [];
  List<UserModel> currentMonthTransactionsRoomList = [];
  List<UserModel> currentMonthTransactionsGroupList = [];
  List<TransactionList> transactionGroupTransactionList = [];
  List<UsetsTransactions> usersTransactionList = [];

  await FirebaseFirestore.instance
      .collection('Transactions')
      .doc(transactionid)
      .get()
      .then(
    (value) async {
      transactionTotalAmount = double.parse(value['totalAmount'].toString());

      for (var i in value['members']) {
        transactionMemberList.add(UserModel(
          mobileNumber: i['phoneNumber'],
          name: i['name'],
          spends: i['spends'],
          expense: i['expense'],
        ));
      }
      print('transctions collection is geted......');
    },
  );

  await FirebaseFirestore.instance.collection('Rooms').doc(roomid).get().then(
    (DocumentSnapshot snapshot) {
      roomtotalamount =
          double.parse(snapshot['totalExpenseOfCurrentMonth'].toString());

      for (var i in snapshot['currentMonthTransactions']) {
        currentMonthTransactionsRoomList.add(UserModel(
          mobileNumber: i['phoneNumber'],
          name: i['Name'],
          spends: i['spends'],
          expense: i['expense'],
        ));
      }
      print('rooms collection is geted......');
    },
  );

  await fire.collection("TransactionGroups").doc(groupid).get().then(
    (value) {
      transactiongrouptotalamount =
          double.parse(value["totalExpense"].toString());

      for (var i in value["currentMonthTransactions"]) {
        currentMonthTransactionsGroupList.add(UserModel(
          mobileNumber: i['phoneNumber'],
          name: i['Name'],
          spends: i['spends'],
          expense: i['expense'],
        ));
      }

      for (var i in value['transactions']) {
        transactionGroupTransactionList.add(TransactionList(
          id: i['id'],
          description: i['description'],
          totalAmount: i['totalAmount'],
          timeStamp: i['timeStamp'].toDate(),
        ));
      }
      for (int i = 0; i < transactionGroupTransactionList.length; i++) {
        if (transactionGroupTransactionList[i].id == transactionid) {
          transactionGroupTransactionList.removeAt(i);
        }
      }
      print('transctionsgroup collection is geted......');
    },
  );

  for (int i = 0; i < transactionMemberList.length; i++) {
    for (int j = 0; j < currentMonthTransactionsRoomList.length; j++) {
      if (transactionMemberList[i].mobileNumber ==
          currentMonthTransactionsRoomList[j].mobileNumber) {
        currentMonthTransactionsRoomList[j].expense = (double.parse(
                    currentMonthTransactionsRoomList[j].expense.toString()) -
                double.parse(transactionMemberList[i].expense.toString()))
            .toString();
        currentMonthTransactionsRoomList[j].spends = (double.parse(
                    currentMonthTransactionsRoomList[j].spends.toString()) -
                double.parse(transactionMemberList[i].spends.toString()))
            .toString();
      }
    }
    for (int j = 0; j < currentMonthTransactionsGroupList.length; j++) {
      if (transactionMemberList[i].mobileNumber ==
          currentMonthTransactionsGroupList[j].mobileNumber) {
        currentMonthTransactionsGroupList[j].expense = (double.parse(
                    currentMonthTransactionsGroupList[j].expense.toString()) -
                double.parse(transactionMemberList[i].expense.toString()))
            .toString();
        currentMonthTransactionsGroupList[j].spends = (double.parse(
                    currentMonthTransactionsGroupList[j].spends.toString()) -
                double.parse(transactionMemberList[i].spends.toString()))
            .toString();
      }
    }
  }
  print('group');
  currentMonthTransactionsGroupList.forEach((element) {
    print(element.name);
    print(element.mobileNumber);
    print(element.expense);
    print(element.spends);
  });
  print('calculated expanse and spends......');
  await FirebaseFirestore.instance.collection('Rooms').doc(roomid).update({
    'currentMonthTransactions': currentMonthTransactionsRoomList
        .map((userModel) => userModel.toJson())
        .toList(),
    'totalExpenseOfCurrentMonth':
        (roomtotalamount - transactionTotalAmount).toString(),
  });
  print('update rooms collectoin,,,,,,,,,,,,,,,,,');
  await FirebaseFirestore.instance
      .collection('TransactionGroups')
      .doc(groupid)
      .update({
    'currentMonthTransactions': currentMonthTransactionsGroupList
        .map((userModel) => userModel.toJson())
        .toList(),
    'transactions': transactionGroupTransactionList
        .map((usermodel) => usermodel.toJson())
        .toList(),
    'totalExpense':
        (transactiongrouptotalamount - transactionTotalAmount).toString(),
  });
  for (int i = 0; i < transactionMemberList.length; i++) {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(transactionMemberList[i].mobileNumber)
        .get()
        .then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        usersTransactionList.add(
          UsetsTransactions(
            expense: snapshot['transactions']['expense'],
            spends: snapshot['transactions']['spends'],
          ),
        );
      }
    });
    usersTransactionList[i].expense =
        (double.parse(usersTransactionList[i].expense.toString()) -
                double.parse(transactionMemberList[i].expense.toString()))
            .toString();
    usersTransactionList[i].spends =
        (double.parse(usersTransactionList[i].spends.toString()) -
                double.parse(transactionMemberList[i].spends.toString()))
            .toString();
  }
  for (int i = 0; i < usersTransactionList.length; i++) {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(transactionMemberList[i].mobileNumber)
        .update({
      'transactions': usersTransactionList[i].toJson(),
    });
  }

  await FirebaseFirestore.instance
      .collection('Transactions')
      .doc(transactionid)
      .delete();
}

// Future<void> deleteTransaction(String transactionId, String groupId) async {

// List<dynamic> temp = [];
// double total = 0.0;
// await fire.collection("TransactionGroups").doc(groupId).get().then((value) {
//   temp = value["currentMonthTransactions"];
//   total = double.parse(value["totalExpense"].toString());
// });
// for (var i in tempList) {
//   total = total - double.parse(i["expense"].toString());
//   for (var j in temp) {
//     if (j["phoneNumber"] == i["phoneNumber"]) {
//       double tempSpends = double.parse(j["spends"].toString());
//       j["spends"] = (tempSpends - double.parse(i["spends"])).toString();
//       double tempExpense = double.parse(j["expense"].toString());
//       j["expense"] = (tempExpense - double.parse(i["expense"])).toString();
//     }
//   }
// }
// await fire.collection("TransactionGroups").doc(groupId).update({
//   'currentMonthTransactions': temp,
//   'transactions': FieldValue.arrayRemove([transactionId]),
//   'totalExpense': total.toString()
// });
// await fire.collection("Transactions").doc(transactionId).delete();
// }

Future<void> deleteTransactionGroup(String groupId, String roomId) async {
  List<TransactionList> transactionGroupTransactionList = [];
  List<UserModel> transactionGroupUserList = [];
  List<UserModel> transactionRoomUserList = [];
  List<TransactionList> transactionRoomTransactionGroupList = [];
  List<UsetsTransactions> usersTransactionList = [];
  double transactionroomtotalamount = 0.0;
  double transactiongrouptotalamount = 0.0;
  await fire
      .collection("TransactionGroups")
      .doc(groupId)
      .get()
      .then((DocumentSnapshot snapshot) async {
    if (snapshot.exists) {
      transactiongrouptotalamount =
          double.parse(snapshot['totalExpense'].toString());
      for (int i = 0; i < snapshot['currentMonthTransactions'].length; i++) {
        transactionGroupUserList.add(UserModel(
          name: snapshot['currentMonthTransactions'][i]['Name'],
          mobileNumber: snapshot['currentMonthTransactions'][i]['phoneNumber'],
          expense: snapshot['currentMonthTransactions'][i]['expense'],
          spends: snapshot['currentMonthTransactions'][i]['spends'],
        ));
      }
      // for (int i = 0; i < snapshot['transactions'].length; i++) {
      //   transactionGroupTransactionList
      //       .add(TransactionList(id: snapshot['transactions'][i]['']));
      // }
      // snapshot['currentMonthTransactions'].forEach((element) {
      //   transactionGroupUserList.add(UserModel(
      //       name: element['Name'],
      //       mobileNumber: element['phoneNumber'],
      //       expense: element['expense'],
      //       spends: element['spends']));
      // });
      snapshot['transactions'].forEach((element) {
        transactionGroupTransactionList.add(
          TransactionList(
            id: element['id'],
          ),
        );
      });
      if (transactionGroupUserList.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('Rooms')
            .doc(roomId)
            .get()
            .then((DocumentSnapshot snapshot) {
          if (snapshot.exists) {
            transactionroomtotalamount =
                double.parse(snapshot['totalExpenseOfCurrentMonth'].toString());
            snapshot['currentMonthTransactions'].forEach((element) {
              transactionRoomUserList.add(UserModel(
                mobileNumber: element['phoneNumber'],
                expense: element['expense'],
                spends: element['spends'],
                name: element['Name'],
              ));
            });
            snapshot['transactionGroups'].forEach((element) {
              transactionRoomTransactionGroupList.add(
                TransactionList(
                  id: element['Id'],
                ),
              );
            });
          }
        });
      }
      for (int i = 0; i < transactionRoomTransactionGroupList.length; i++) {
        if (transactionRoomTransactionGroupList[i].id == groupId) {
          transactionRoomTransactionGroupList.removeAt(i);
        }
      }
      for (int i = 0; i < transactionGroupUserList.length; i++) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(transactionGroupUserList[i].mobileNumber)
            .get()
            .then((DocumentSnapshot snapshot) {
          if (snapshot.exists) {
            usersTransactionList.add(
              UsetsTransactions(
                expense: snapshot['transactions']['expense'],
                spends: snapshot['transactions']['spends'],
              ),
            );
          }
        });
        usersTransactionList[i].expense = (double.parse(
                    usersTransactionList[i].expense.toString()) -
                double.parse(transactionGroupUserList[i].expense.toString()))
            .toString();
        usersTransactionList[i].spends =
            (double.parse(usersTransactionList[i].spends.toString()) -
                    double.parse(transactionGroupUserList[i].spends.toString()))
                .toString();
      }

      if (transactionRoomUserList.isNotEmpty &&
          transactionGroupUserList.isNotEmpty) {
        for (int i = 0; i < transactionGroupUserList.length; i++) {
          for (int j = 0; j < transactionRoomUserList.length; j++) {
            if (transactionGroupUserList[i].mobileNumber ==
                transactionRoomUserList[j].mobileNumber) {
              transactionRoomUserList[j].expense =
                  (double.parse(transactionRoomUserList[j].expense.toString()) -
                          double.parse(
                              transactionGroupUserList[i].expense.toString()))
                      .toString();
              transactionRoomUserList[j].spends =
                  (double.parse(transactionRoomUserList[j].spends.toString()) -
                          double.parse(
                              transactionGroupUserList[i].spends.toString()))
                      .toString();
            }
          }
        }
      }
      transactionGroupTransactionList.forEach((element) async {
        await FirebaseFirestore.instance
            .collection('Transactions')
            .doc(element.id)
            .delete();
      });
      for (int i = 0; i < transactionGroupUserList.length; i++) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(transactionGroupUserList[i].mobileNumber)
            .update({
          'transactions': usersTransactionList[i].toJson(),
        });
      }
      await FirebaseFirestore.instance.collection('Rooms').doc(roomId).update({
        'totalExpenseOfCurrentMonth':
            (double.parse(transactionroomtotalamount.toString()) -
                    double.parse(transactiongrouptotalamount.toString()))
                .toString(),
        'currentMonthTransactions': transactionRoomUserList
            .map((usermodel) => usermodel.toJson())
            .toList(),
        'transactionGroups': transactionRoomTransactionGroupList
            .map((transaction) => transaction.toJson())
            .toList(),
      });
      transactionRoomTransactionGroupList.forEach((element) async {
        await FirebaseFirestore.instance
            .collection('TransactionGroups')
            .doc(element.id)
            .delete();
      });
      FirebaseFirestore.instance
          .collection('TransactionGroups')
          .doc(groupId)
          .delete();
    }
  });

  // DocumentReference documentReference =
  //     FirebaseFirestore.instance.collection('Rooms').doc(roomId);
  // DocumentSnapshot documentSnapshot = await documentReference.get();
  // Map<String, dynamic>? data = documentSnapshot.data() as Map<String, dynamic>?;
  // if (data != null && data.containsKey('transactionGroups')) {
  //   List<dynamic>? groupList = data['transactionGroups'];
  //   if (groupList != null) {
  //     await documentReference.update({
  //       'transactionGroups': FieldValue.arrayRemove([
  //         for (var map in groupList)
  //           if (map['Id'] == groupId) map
  //       ])
  //     });
  //   }
  // }
  // print('reacherdddddddddddddd//////////////////////////222222222222222222');

  // print(
  //     'reacherdddddddddddddd////////////////////////33333333333333333333333333');

  // for (var i in temp) {
  //   await fire.collection("Transactions").doc(i.toString()).delete();
  // }
  // print('reacherdddddddddddddd////////////////////////3444444444444444444');

  // await fire.collection("TransactionGroups").doc(groupId).delete();
}

Future<void> deleteRoom(String roomId) async {
  List<dynamic>? groupList;
  List<UserModel> memberList = [];
  List<UsetsTransactions> usersTransactionList = [];

  await fire.collection("Rooms").doc(roomId).get().then((value) {
    groupList = value["transactionGroups"];
    for (int i = 0; i < value['currentMonthTransactions'].length; i++) {}
    memberList = value["currentMonthTransactions"];
  });
  for (int i = 0; i < memberList.length; i++) {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(memberList[i].mobileNumber)
        .get()
        .then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        usersTransactionList.add(UsetsTransactions(
          expense: snapshot['transactions']['expense'],
          spends: snapshot['transactions']['spends'],
        ));
      }
    });
    usersTransactionList[i].expense =
        (double.parse(usersTransactionList[i].expense.toString()) -
                double.parse(memberList[i].expense.toString()))
            .toString();

    usersTransactionList[i].spends =
        (double.parse(usersTransactionList[i].spends.toString()) -
                double.parse(memberList[i].spends.toString()))
            .toString();
  }
  memberList.forEach((element) async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(element.mobileNumber)
        .update({
      'transactions':
          usersTransactionList[int.parse(element.toString())].toJson(),
    });
  });
  if (groupList != null) {
    for (var i in groupList!) {
      await deleteTransactionGroup(i["Id"], roomId);
    }
  }
  memberList.forEach((element) async {
    await fire.collection("Users").doc(element.mobileNumber).update({
      'rooms': FieldValue.arrayRemove([roomId])
    });
  });

  await fire.collection("Rooms").doc(roomId).delete();
}

class Log {
  final String phoneNumber;
  final String roomId;
  Log(this.phoneNumber, this.roomId);
}

// Future gettransactiondetails(String id) async {
//   try {
//     await FirebaseFirestore.instance
//         .collection('Transactions')
//         .doc(id)
//         .get()
//         .then((DocumentSnapshot snapshot) {
//       if (snapshot.exists) {
//         print('snapshot data is....... ${snapshot.data()}');
//         print(snapshot['description']);
//         print(snapshot['totalAmount']);
//         print(snapshot['paymentMode']);
//         print(snapshot['timeStamp']);
//         print(snapshot['members']);
//         transactiondetails.add(transactionDetailsModel(
//           description: snapshot['description'],
//           totalAmount: snapshot['totalAmount'],
//           paymentMode: snapshot['paymentMode'],
//           timeStamp: snapshot['timeStamp'],
//           members: snapshot['members'],
//         ));
//         print('object');
//         print(transactiondetails);
//       } else {}
//       return transactiondetails;
//     });
//   } catch (e) {
//     return;
//   }
// }

Future<List<transactionDetailsModel>> getTransactionDetails(String id) async {
  List<transactionDetailsModel> transactionDetails = [];
  try {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('Transactions')
        .doc(id)
        .get();

    if (snapshot.exists) {
      transactionDetails.add(transactionDetailsModel(
        description: snapshot['description'],
        totalAmount: snapshot['totalAmount'],
        paymentMode: snapshot['paymentMode'],
        timeStamp: snapshot['timeStamp'].toDate(),
        members: List<Members>.from(
            snapshot['members'].map((x) => Members.fromJson(x))),
      ));
    }
  } catch (e) {
    print("Error: $e");
  }
  return transactionDetails;
}

Future<List<UserModel>> getmemberlist(String roomid, String groupid) async {
  List<UserModel> memberlist = [];
  await FirebaseFirestore.instance
      .collection('Rooms')
      .doc(roomid)
      .get()
      .then((DocumentSnapshot snapshot) {
    if (snapshot.exists) {
      for (int i = 0; i < snapshot['currentMonthTransactions'].length; i++) {
        memberlist.add(UserModel(
            name: snapshot['currentMonthTransactions'][i]['Name'],
            mobileNumber: snapshot['currentMonthTransactions'][i]
                ['phoneNumber'],
            spends: "0",
            expense: "0"));
      }
    }
  });
  return memberlist;
}

Future gettransactiongroupdetailsafterclose(String id) async {
  List<TransactionGroupModel> transactiongroupdetailslist = [];

  await FirebaseFirestore.instance
      .collection('TransactionGroups')
      .doc(id)
      .get()
      .then((DocumentSnapshot snapshot) {
    try {
      if (snapshot.exists) {
        List<dynamic>? currentMonthTransactionsJson =
            snapshot['currentMonthTransactions'];
        List<CurrentMonthTransactions> currentMonthTransactions = [];

        if (currentMonthTransactionsJson != null) {
          currentMonthTransactions = currentMonthTransactionsJson
              .map((json) => CurrentMonthTransactions.fromJson(json))
              .toList();
        }

        transactiongroupdetailslist.add(
          TransactionGroupModel(
              groupName: snapshot['groupName'],
              totalExpense: snapshot['totalExpense'],
              timeStamp: snapshot['timeStamp'].toDate(),
              completeTime: snapshot['completeTime'].toDate(),
              currentMonthTransactions: currentMonthTransactions,
              transactionList: snapshot['transactions']),
        );
      }
    } catch (e) {
      print('Error is $e');
    }
  });

  return transactiongroupdetailslist;
}

// Future basicTransactionGroupDetails(String groupid) async {
//   List<dynamic> list = [];
//   await FirebaseFirestore.instance
//       .collection('TransactionGroups')
//       .doc(groupid)
//       .get()
//       .then((DocumentSnapshot snapshot) {
//     list.add(snapshot['groupName']);
//     list.add(snapshot['totalExpense']);
//     list.add(snapshot['timeStamp']);
//     list.add(snapshot['completeTime']);
//   });

//   return list;
// }

// Future getuserdata(String id) async {
//   List<UserProfileModel> userProfileList = [];
//   await FirebaseFirestore.instance
//       .collection('Users')
//       .doc(id)
//       .get()
//       .then((DocumentSnapshot snapshot) {
//     if (snapshot.exists) {
//       userProfileList.add(UserProfileModel(
//         firstName: snapshot['firstName'],
//         lastName: snapshot['lastName'],
//         mobileNumber: snapshot['phoneNumber'],
//         gender: snapshot['gender'],
//         expense: snapshot['transactions']['expense'],
//         spends: snapshot['transactions']['spends'],
//         timeStamp: snapshot['timeStamp'],
//       ));
//     }
//   });return userProfileList
// ;}

Stream<List<UserProfileModel>> getUserDataStream(String id) {
  return FirebaseFirestore.instance
      .collection('Users')
      .where('phoneNumber',
          isEqualTo: FirebaseAuth.instance.currentUser!.phoneNumber.toString())
      .snapshots()
      .map((snapshot) {
    List<UserProfileModel> userProfileList = [];
    print('object');

    snapshot.docs.forEach((element) {
      userProfileList.add(UserProfileModel(
        firstName: element['firstName'],
        lastName: element['lastName'],
        mobileNumber: element['phoneNumber'],
        gender: element['gender'],
        timeStamp: element['timeStamp'].toDate(),
        expense: element['transactions']['expense'],
        spends: element['transactions']['spends'],
      ));
    });
    return userProfileList;
  });
}
