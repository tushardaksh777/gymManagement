import 'dart:collection';

import 'package:gym_management/DTO/Attandance.dart';
import 'package:gym_management/DTO/User.dart';

 enum expense{gym , other}
 enum paymentMode{online , offline}
 enum attandanceStatus{present , absent}
 enum value {active , inactive , all}
 enum attandance{active , present , absent}
 enum pdf{monthly , yearly}
 //enum attandacemonth{leap , }
 enum AttandanceTime {
    morning,evening
  }
class global {
 
  static List<int>? addUserTopresentList = [];
  static List<int>? deleteUserPresentList = [];
  static List<int>? deleteUserAbsentList = [];
  //static List<String>? presentList = [];
  static List<UserModel>? userList;
  static List<UserModel> allUser=[];
  static List<AttandanceModel> presentList=[];
  static List<AttandanceModel> absentList=[];
}