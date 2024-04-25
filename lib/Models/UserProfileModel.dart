class UserProfileModel {
  String? firstName;
  String? lastName;
  String? mobileNumber;
  String? gender;
  DateTime? timeStamp;
  String? expense;
  String? spends;

  UserProfileModel(
      {this.firstName,
      this.lastName,
      this.mobileNumber,
      this.gender,
      this.timeStamp,
      this.expense,
      this.spends});

  UserProfileModel.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    mobileNumber = json['mobileNumber'];
    gender = json['gender'];
    timeStamp = json['timeStamp'];
    expense = json['expense'];
    spends = json['spends'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['mobileNumber'] = this.mobileNumber;
    data['gender'] = this.gender;
    data['timeStamp'] = this.timeStamp;
    data['expense'] = this.expense;
    data['spends'] = this.spends;
    return data;
  }
}
