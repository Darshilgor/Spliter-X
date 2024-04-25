class UserModel {
  String? mobileNumber;
  String? name;
  String? spends;
  String? expense;  

  UserModel({this.mobileNumber, this.name, this.spends, this.expense});

  UserModel.fromJson(Map<String, dynamic> json) {
    mobileNumber = json['phoneNumber'];
    name = json['Name'];
    spends = json['spends'];
    expense = json['expense'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phoneNumber'] = this.mobileNumber;
    data['Name'] = this.name;
    data['spends'] = this.spends;
    data['expense'] = this.expense;
    return data;
  }
}
