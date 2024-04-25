class TransactionListModel {
  late String groupName;
  late String totalExpanse;
  late DateTime createionTime;
  late DateTime? completedTime;
  late String transactionId;
  late String description;
  late String timeStamp;
  late String paymentMode;
  late String totalAmount;
  TransactionListModel(
      {required this.transactionId,
      required this.description,
      required this.timeStamp,
      required this.paymentMode,
      required this.totalAmount,
      required this.groupName,
      required this.totalExpanse,
      required this.createionTime,
      this.completedTime});

  TransactionListModel.fromJson(Map<String, dynamic> json) {
    transactionId = json['transactionId'];
    description = json['description'];
    timeStamp = json['timeStamp'];
    paymentMode = json['paymentMode'];
    totalAmount = json['totalAmount'];
    groupName = json['groupName'];
    totalExpanse = json['totalExpense'];
    createionTime = json['creationTime'];
    completedTime = json['completedTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'transactionId': transactionId,
      'description': description,
      'timeStamp': timeStamp,
      'paymentMode': paymentMode,
      'totalAmount': totalAmount,
      'groupName': groupName,
      'totalExpense': totalExpanse,
      'creationTime': createionTime,
      'completedTime': completedTime,
    };
    return data;
  }
}
