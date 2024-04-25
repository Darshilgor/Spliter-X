class RoomsTransactionGroups {
  bool? active;
  String? id;
  String? name;
  String? timestamp;

  RoomsTransactionGroups({this.active, this.id, this.name, this.timestamp});

  RoomsTransactionGroups.fromJson(Map<String, dynamic> json) {
    active = json['Active'];
    id = json['Id'];
    name = json['Name'];
    timestamp = json['Timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Active'] = this.active;
    data['Id'] = this.id;
    data['Name'] = this.name;
    data['Timestamp'] = this.timestamp;
    return data;
  }
}
