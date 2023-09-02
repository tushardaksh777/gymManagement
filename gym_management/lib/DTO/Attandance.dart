import 'package:gym_management/DTO/User.dart';

class AttandanceModel {
  int? id;
  UserModel? user;
  String? date;
  String? attandanceStatus;
  String? attandanceTime;

  AttandanceModel(
      {this.id, this.user, this.date,this.attandanceStatus , this.attandanceTime});

  AttandanceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
date = json['date'];
    attandanceStatus = json['attandanceStatus'];
    attandanceTime = json['attandanceTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.user != null) {
      data['user'] = UserModel().toJson(user!);
    }
    data['date'] = this.date;
    data['attandanceStatus'] = this.attandanceStatus;
    data['attandanceTime'] = this.attandanceTime;
    return data;
  }
}