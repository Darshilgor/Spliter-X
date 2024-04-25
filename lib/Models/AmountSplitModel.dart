class AmountSplitModel {
  String? leftMember;
  String? rightMember;
  double? amount;

  AmountSplitModel({this.leftMember, this.rightMember, this.amount});

  AmountSplitModel.fromJson(Map<String, dynamic> json) {
    leftMember = json['leftMember'];
    rightMember = json['rightMember'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['leftMember'] = this.leftMember;
    data['rightMember'] = this.rightMember;
    data['amount'] = this.amount;
    return data;
  }
}
