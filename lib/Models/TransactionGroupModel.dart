// class transactionGroupModel {
//   String? groupName;
//   String? totalExpense;
//   DateTime? timeStamp;
//   DateTime? completeTime;
//   List<CurrentMonthTransactions>? currentMonthTransactions;

//   transactionGroupModel(
//       {this.groupName,
//       this.totalExpense,
//       this.timeStamp,
//       this.completeTime,
//       this.currentMonthTransactions});

//   transactionGroupModel.fromJson(Map<String, dynamic> json) {
//     groupName = json['groupName'];
//     totalExpense = json['totalExpense'];
//     timeStamp = json['timeStamp'];
//     completeTime = json['completeTime'];
//     if (json['currentMonthTransactions'] != null) {
//       currentMonthTransactions = <CurrentMonthTransactions>[];
//       json['currentMonthTransactions'].forEach((v) {
//         currentMonthTransactions!.add(new CurrentMonthTransactions.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['groupName'] = this.groupName;
//     data['totalExpense'] = this.totalExpense;
//     data['timeStamp'] = this.timeStamp;
//     data['completeTime'] = this.completeTime;
//     if (this.currentMonthTransactions != null) {
//       data['currentMonthTransactions'] =
//           this.currentMonthTransactions!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class CurrentMonthTransactions {
//   String? name;
//   String? phoneNumber;
//   String? expense;
//   String? spends;

//   CurrentMonthTransactions(
//       {this.name, this.phoneNumber, this.expense, this.spends});

//   CurrentMonthTransactions.fromJson(Map<String, dynamic> json) {
//     name = json['Name'];
//     phoneNumber = json['phoneNumber'];
//     expense = json['expense'];
//     spends = json['spends'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['Name'] = this.name;
//     data['phoneNumber'] = this.phoneNumber;
//     data['expense'] = this.expense;
//     data['spends'] = this.spends;
//     return data;
//   }
// }

class TransactionGroupModel {
  String? groupName;
  String? totalExpense;
  DateTime? timeStamp;
  DateTime? completeTime;
  List<CurrentMonthTransactions>? currentMonthTransactions;
  List<dynamic>? transactionList;

  TransactionGroupModel(
      {this.groupName,
      this.totalExpense,
      this.timeStamp,
      this.completeTime,
      this.currentMonthTransactions,
      this.transactionList});

  TransactionGroupModel.fromJson(Map<String, dynamic> json) {
    groupName = json['groupName'];
    totalExpense = json['totalExpense'];
    // Convert timestamp and completeTime from milliseconds to DateTime
    timeStamp = json['timeStamp'] != null
        ? DateTime.fromMillisecondsSinceEpoch(json['timeStamp'])
        : null;
    completeTime = json['completeTime'] != null
        ? DateTime.fromMillisecondsSinceEpoch(json['completeTime'])
        : null;

    if (json['currentMonthTransactions'] != null) {
      currentMonthTransactions = <CurrentMonthTransactions>[];
      json['currentMonthTransactions'].forEach((v) {
        currentMonthTransactions!.add(CurrentMonthTransactions.fromJson(v));
      });
    }
    transactionList = json['transactions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['groupName'] = this.groupName;
    data['totalExpense'] = this.totalExpense;
    // Convert DateTime to milliseconds for serialization
    data['timeStamp'] = this.timeStamp?.millisecondsSinceEpoch;
    data['completeTime'] = this.completeTime?.millisecondsSinceEpoch;
    if (this.currentMonthTransactions != null) {
      data['currentMonthTransactions'] =
          this.currentMonthTransactions!.map((v) => v.toJson()).toList();
    }
    data['transactions'] = this.transactionList;
    return data;
  }
}

class CurrentMonthTransactions {
  String? name;
  String? phoneNumber;
  String? expense;
  String? spends;

  CurrentMonthTransactions(
      {this.name, this.phoneNumber, this.expense, this.spends});

  CurrentMonthTransactions.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    phoneNumber = json['phoneNumber'];
    expense = json['expense'];
    spends = json['spends'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['phoneNumber'] = this.phoneNumber;
    data['expense'] = this.expense;
    data['spends'] = this.spends;
    return data;
  }
}
