class ShowRoomDetailsModel {
  String? adminName;
  String? adminPhoneNumber;
  String? roomName;
  String? totalExpanse;
  DateTime? timeStamp;
  List<MemberList>? memberList;

  ShowRoomDetailsModel(
      {this.adminName,
      this.adminPhoneNumber,
      this.roomName,
      this.totalExpanse,
      this.timeStamp,
      this.memberList});

  ShowRoomDetailsModel.fromJson(Map<String, dynamic> json) {
    adminName = json['adminName'];
    adminPhoneNumber = json['adminPhoneNumber'];
    roomName = json['roomName'];
    totalExpanse = json['totalExpanse'];
    timeStamp = json['timeStamp'];
    if (json['memberList'] != null) {
      memberList = <MemberList>[];
      json['memberList'].forEach((v) {
        memberList!.add(new MemberList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['adminName'] = this.adminName;
    data['adminPhoneNumber'] = this.adminPhoneNumber;
    data['roomName'] = this.roomName;
    data['totalExpanse'] = this.totalExpanse;
    data['timeStamp'] = this.timeStamp;
    if (this.memberList != null) {
      data['memberList'] = this.memberList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MemberList {
  String? memberName;
  String? memberPhoneNumber;
  String? expanse;
  String? spends;

  MemberList(
      {this.memberName, this.memberPhoneNumber, this.expanse, this.spends});

  MemberList.fromJson(Map<String, dynamic> json) {
    memberName = json['memberName'];
    memberPhoneNumber = json['memberPhoneNumber'];
    expanse = json['expense'];
    spends = json['spends'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['memberName'] = this.memberName;
    data['memberPhoneNumber'] = this.memberPhoneNumber;
    data['expense'] = this.expanse;
    data['spends'] = this.spends;
    return data;
  }
}
