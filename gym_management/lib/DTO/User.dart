import 'package:gym_management/AddUser/createUser.dart';

class UserModel {
  int? id;
  int? registrationNo;
  String? name;
  String? fatherName;
  String? husbandName;
  String? phoneNo;
  String? address;
  String? joiningDate;
  String? feeSubmitDate;
  String? status;
  String? inactiveDate;
  String? activeDate;

  // int? registraionFee;
  // //int? annualFee;
  // int? monthlyFee;
  // int? trademilFee;
  // int? lightsChargesFee;
  // int? personalTrainingFee;
  // String? feeNote;

  UserModel(
      {this.id,
      this.registrationNo,
      this.name,
      this.fatherName,
      this.husbandName,
      this.phoneNo,
      this.address,
      this.joiningDate,
      this.feeSubmitDate,
      this.status,
      this.inactiveDate,
      this.activeDate
      // this.registraionFee,
      // //this.annualFee,
      // this.monthlyFee,
      // this.trademilFee,
      // this.lightsChargesFee,
      // this.personalTrainingFee,
      // this.feeNote
      });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    registrationNo = json['registrationNo'];
    name = json['name'];
    fatherName = json['fatherName'];
    husbandName = json['husbandName'];
    phoneNo = json['phoneNo'];
    address = json['address'];
    joiningDate = json['joiningDate'];
    feeSubmitDate = json['feeSubmitDate'];
    status = json['status'];
    inactiveDate = json['inactiveDate'];
    activeDate = json['activeDate'];
    // registraionFee = json['registraionFee'];
    // //annualFee = json['annualFee'];
    // monthlyFee = json['monthlyFee'];
    // trademilFee = json['trademilFee'];
    // lightsChargesFee = json['lightsChargesFee'];
    // personalTrainingFee = json['personalTrainingFee'];
    // feeNote = json['feeNote'];
  }

  Map<String, dynamic> toJson(UserModel user) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = user.id;
    data['registrationNo'] = user.registrationNo;
    data['name'] = user.name;
    data['fatherName'] = user.fatherName;
    data['husbandName'] = user.husbandName;
    data['phoneNo'] = user.phoneNo;
    data['address'] = user.address;
    data['joiningDate'] = user.joiningDate;
    data['feeSubmitDate'] = user.feeSubmitDate;
    data['status'] = user.status;
    data['inactiveDate'] = user.inactiveDate;
    data['activeDate'] = user.activeDate;
    // data['registraionFee'] = user.registraionFee;
    // //data['annualFee'] = user.annualFee;
    // data['monthlyFee'] = user.monthlyFee;
    // data['trademilFee'] = user.trademilFee;
    // data['lightsChargesFee'] = user.lightsChargesFee;
    // data['personalTrainingFee'] = user.personalTrainingFee;
    // data['feeNote'] = user.feeNote;
    return data;
  }
}
