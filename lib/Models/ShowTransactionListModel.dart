class ShowTransactionListModel {
  String? groupName;
  String? totalExpanse;
  DateTime? createionTime;
  DateTime? completedTime;
  List<TransactionList>? transactionList;

  ShowTransactionListModel(
      {this.groupName,
      this.totalExpanse,
      this.createionTime,
      this.completedTime,
      this.transactionList});

  ShowTransactionListModel.fromJson(Map<String, dynamic> json) {
    groupName = json['groupName'];
    totalExpanse = json['totalExpanse'];
    createionTime = json['createionTime'];
    completedTime = json['completedTime'];
    if (json['transactionList'] != null) {
      transactionList = <TransactionList>[];
      json['transactionList'].forEach((v) {
        transactionList!.add(new TransactionList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['groupName'] = this.groupName;
    data['totalExpanse'] = this.totalExpanse;
    data['createionTime'] = this.createionTime;
    data['completedTime'] = this.completedTime;
    if (this.transactionList != null) {
      data['transactionList'] =
          this.transactionList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TransactionList {
  String? id;
  String? description;
  String? totalAmount;
  DateTime? timeStamp;

  TransactionList(
      {this.id, this.description, this.totalAmount, this.timeStamp});

  TransactionList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    totalAmount = json['totalAmount'];
    timeStamp = json['timeStamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['totalAmount'] = this.totalAmount;
    data['timeStamp'] = this.timeStamp;
    return data;
  }
}
