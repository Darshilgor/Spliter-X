
class transactionDetailsModel {
  String? description;
  String? totalAmount;
  String? paymentMode;
  DateTime?  timeStamp;
  List<Members>? members;

  transactionDetailsModel(
      {this.description,
      this.totalAmount,
      this.paymentMode,
      this.timeStamp,
      this.members});

  transactionDetailsModel.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    totalAmount = json['totalAmount'];
    paymentMode = json['paymentMode'];
    timeStamp = json['timeStamp'];
    if (json['members'] != null) {
      members = <Members>[];
      json['members'].forEach((v) {
        members!.add(new Members.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['totalAmount'] = this.totalAmount;
    data['paymentMode'] = this.paymentMode;
    data['timeStamp'] = this.timeStamp;
    if (this.members != null) {
      data['members'] = this.members!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Members {
  String? name;
  String? phoneNumber;
  String? expense;
  String? spends;

  Members({this.name, this.phoneNumber, this.expense, this.spends});

  Members.fromJson(Map<String, dynamic> json) {
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
