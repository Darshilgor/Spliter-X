class UsetsTransactions {
  String? expense;
  String? spends;

  UsetsTransactions({this.expense, this.spends});

  UsetsTransactions.fromJson(Map<String, dynamic> json) {
    expense = json['expense'];
    spends = json['spends'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['expense'] = this.expense;
    data['spends'] = this.spends;
    return data;
  }
}
