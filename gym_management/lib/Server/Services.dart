import 'dart:convert';
import 'dart:io';
import 'package:gym_management/DTO/Attandance.dart';
import 'package:gym_management/DTO/User.dart';
import 'package:gym_management/globalData.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Services{//192.168.105.166 - jioPhone , //192.168.29.253
  static String BASE_URL = "http://192.168.29.3:8888";
  static String TEST_USER = "/User/testUser";
  static String ADD_USER = "/User/addUser";
  static String GET_ACTIVE_USER = "/User/getActiveUser";
  static String GET_INACTIVE_USER = "/User/getInactiveUser";
  static String GET_ALL_USER = "/User/getAllUser";
  static String GET_USER = "/User/getUser";
  static String EDIT_USER = "/User/editUser";
  static String CHANGE_USER_STATUS = "/User/userStatus";
  static String DELETE_USER =  "/User/deleteUser";
  static String PROFIT_AND_LOSS =  "/User/getProfitLoss";
  static String GET_USER_FEES_DETAILS = "/Transaction/getUserfeesDetails";
  static String SUBMIT_USER_FEE =  "/Transaction/feeSubmit";
  static String DELETE_USER_FEE =  "/Transaction/deletefee";
  static String EDIT_USER_FEE =  "/Transaction/editUserfee";
  static String GET_MONTHLY_FEE =  "/Transaction/getMonthlyTransaction";//getYearlyTransaction
  static String GET_YEARLY_FEE =  "/Transaction/getYearlyTransaction";
  static String ADD_EXPENSES = "/Expenses/addExpenses";
  static String GET_GYM_EXPENSES = "/Expenses/gymExpenses";
  static String GET_OTHER_EXPENSES = "/Expenses/otherExpenses";
  static String GET_TOTAL_EXPENSES = "/Expenses/totalExpenses";//getpdfExpenses
  static String GET_PDF_EXPENSES = "/Expenses/getpdfExpenses";
  static String EDIT_EXPENSES = "/Expenses/editExpenses";
  static String DELETE_EXPENSES = "/Expenses/deleteExpenses";
  static String SUBMIT_ATTANDANCE = "/Attandance/submitAttandance";
  static String DELETE_USER_ATTANDANCE =  "/Attandance/deleteAttandance";//DELETE_ATTANDANCE_LIST
  static String DELETE_ATTANDANCE_LIST =  "/Attandance/deleteByList";//DELETE_ATTANDANCE_LIST
  static String GET_USER_BY_ATTANDANCE_STATUS =  "/Attandance/getUserByAttandanceStatus";//getAttandanceForPdf
  static String GET_USER_BY_ATTANDANCE_PDF =  "/Attandance/getAttandanceForPdf";
  static String FINISH_DAY =  "/Attandance/finishDay";
  static String USER_ATTANDANCE = "/Attandance/getUserAttandance";
  static String EDIT_PROFILE = "/profile/editProfile";
  static String GET_PROFILE = "/profile/getProfile";
      


    Future<dynamic> gettestUserData() async {
      BASE_URL = await getAddress();
    var dataRequest = await sendpost(BASE_URL + TEST_USER);

    return await jsonDecode(dataRequest.body);
    }

    Future<List<UserModel>> getActiveUser()async{
      BASE_URL = await getAddress();

     var dataRequest = await sendpost(BASE_URL + GET_ACTIVE_USER);
    //  print("Get active user "+dataRequest.toString());
     var response = jsonDecode(dataRequest.body);
    // print("Get active user "+response.toString());
      List<UserModel> userList = [];
      for(var user in response){
        userList.add(UserModel.fromJson(user));
      }
     return await userList;
    }
    
    Future<List<UserModel>> getInactiveUser()async{
 BASE_URL = await getAddress();

     var dataRequest = await sendpost(BASE_URL + GET_INACTIVE_USER);
     var response = jsonDecode(dataRequest.body);
    // print("Get active user "+response.toString());
      List<UserModel> userList = [];
      for(var user in response){
        userList.add(UserModel.fromJson(user));
      }
     return await userList;
    }
    Future<List<UserModel>> getAllUser()async{
 BASE_URL = await getAddress();
     var dataRequest = await sendpost(BASE_URL + GET_ALL_USER);
     var response = jsonDecode(dataRequest.body);
    // print("Get active user "+response.toString());
      List<UserModel> userList = [];
      for(var user in response){
        userList.add(UserModel.fromJson(user));
      }
     return await userList;
    }

    Future<UserModel> getUser(int userId)async{
       BASE_URL = await getAddress();
       var map = new Map<dynamic, dynamic>();
     map["userId"] = userId.toString();
     var dataRequest = await sendpost(BASE_URL + GET_USER , body: map);
      //print("Get active user "+dataRequest.toString());
     var response = await jsonDecode(dataRequest.body);
   //  print("user re "+response.toString());
     return UserModel.fromJson(response);
    }


    Future<dynamic> addUser(UserModel user )async{
       BASE_URL = await getAddress();
    var map = new Map<dynamic, dynamic>();
     map["registrationNo"] = user.registrationNo.toString();
     map["name"] = user.name;
     map["fatherName"] = user.fatherName;
     map["phoneNo"] = user.phoneNo;
     map["address"] = user.address;
     map["joiningDate"] = DateFormat("yyyy-MM-dd").format(DateTime.parse(user.joiningDate!));
     map["status"] = user.status;
    //  if(user.status == "active"){
    //   map["paymentMode"] = mode;
    //  map["registrationFee"] = user.registraionFee.toString();
    //   map["monthlyFee"] = user.monthlyFee.toString();
    //  map["trademilFee"] = user.trademilFee.toString();
    //   map["lightsChargesFee"] = user.lightsChargesFee.toString();
    //  map["personalTrainingFee"] = user.personalTrainingFee.toString();
    //  map["feeNote"] = user.feeNote;

    //  }


    var dataRequest = await sendpost(BASE_URL + ADD_USER  , body: map);
     //print("dataRequest "+ dataRequest);
     return await jsonDecode(dataRequest.body);
    }

  Future<dynamic> deleteUser(String id)async{
       BASE_URL = await getAddress();
    var map = new Map<dynamic, dynamic>();
    map["id"] = id;

    var dataRequest = await sendpost(BASE_URL + DELETE_USER , body: map);
    return await jsonDecode(dataRequest.body);
    }

    Future<dynamic> editUser(UserModel user)async{
       BASE_URL = await getAddress();
    var map = new Map<dynamic, dynamic>();
    map["id"] = user.id.toString();
    map["registrationNo"] = user.registrationNo.toString();
     map["name"] = user.name;
     map["fatherName"] = user.fatherName;
     map["husbandName"] = user.husbandName;
     map["phoneNo"] = user.phoneNo;
     map["address"] = user.address;
     map["joiningDate"] = DateFormat("yyyy-MM-dd").format(DateTime.parse(user.joiningDate!));
     map["status"] = user.status;
    //  if(user.status == "active"){
    
    //  map["registrationFee"] = user.registraionFee.toString();
    //   map["monthlyFee"] = user.monthlyFee.toString();
    //  map["trademilFee"] = user.trademilFee.toString();
    //   map["lightsChargesFee"] = user.lightsChargesFee.toString();
    //  map["personalTrainingFee"] = user.personalTrainingFee.toString();
    //  map["feeNote"] = user.feeNote;
    
    // }else{
    //    map["registrationFee"] = "0";
    //   map["monthlyFee"] = "0";
    //  map["trademilFee"] = "0";
    //   map["lightsChargesFee"] = "0";
    //  map["personalTrainingFee"] = "0";
    //  map["feeNote"] = "";
    // }
    var dataRequest = await sendpost(BASE_URL + EDIT_USER , body: map);
   // print("Edit user "+ dataRequest.body.toString());
    return await jsonDecode(dataRequest.body);
    }

    Future<UserModel> changeUserStatus(int registationNo , value status , DateTime date)async{
       BASE_URL = await getAddress();
    var map = new Map<dynamic, dynamic>();
    map["registationNo"] = registationNo.toString();
    map["status"] = status.name;
    map["date"] = DateFormat("yyyy-MM-dd").format(date);

    var dataRequest = await sendpost(BASE_URL + CHANGE_USER_STATUS , body: map);
    var request = await jsonDecode(dataRequest.body);
    return UserModel.fromJson(request);
    }

    Future<dynamic> getProfitLossPdfData(String date)async{
       BASE_URL = await getAddress();
      var map = new Map<dynamic, dynamic>();
      map["date"] = DateFormat("yyyy-MM-dd").format(DateTime.parse(date));
    var dataRequest = await sendpost(BASE_URL + PROFIT_AND_LOSS , body: map);
    return await jsonDecode(dataRequest.body);
    }

    Future<dynamic> getUserFeesDetails(int registrationNo)async{
       BASE_URL = await getAddress();
    var map = new Map<dynamic, dynamic>();
    map["registrationNo"] = registrationNo.toString();

    var dataRequest = await sendpost(BASE_URL + GET_USER_FEES_DETAILS , body: map);
    return await jsonDecode(dataRequest.body);
    }
    
    Future<dynamic> deleteTransaction(String id)async{
       BASE_URL = await getAddress();
    var map = new Map<dynamic, dynamic>();
    map["id"] = id;

    var dataRequest = await sendpost(BASE_URL + DELETE_USER_FEE , body: map);
    return await jsonDecode(dataRequest.body);
    }

    sendGet(String url)async{
      var reply = await http.get(Uri.parse(url));
      return  reply;

  }
  Future<bool> editUserFee(int id , paymentMode mode, int registraionFee , int monthlyFee , int trademilFee , int lightsChargesFee , int personalTrainingFee , int otherFee , String feeNote , String date)async{
     BASE_URL = await getAddress();
  var map = new Map<dynamic, dynamic>();
  map["id"] = id.toString();
  map["registrationFee"] = registraionFee.toString();
  map["monthlyFee"] = monthlyFee.toString();
  map["trademilFee"] = trademilFee.toString();
  map["lightsCharges"] = lightsChargesFee.toString();
  map["personalTraining"] = personalTrainingFee.toString();
  map["otherFee"] = otherFee.toString();
  map["note"] = feeNote;
  map["mode"] = mode.name;
  map["date"] = date;

  

    var dataRequest = await sendpost(BASE_URL + EDIT_USER_FEE , body: map);
    return await jsonDecode(dataRequest.body);
  }
  
  Future<dynamic> getMonthlyFees(String date)async{
     BASE_URL = await getAddress();
      var map = new Map<dynamic, dynamic>();
      map["date"] = DateFormat("yyyy-MM-dd").format(DateTime.parse(date));
    var dataRequest = await sendpost(BASE_URL + GET_MONTHLY_FEE , body: map);
    return await jsonDecode(dataRequest.body);
  }
  
  Future<dynamic> getYearlyFees(String date)async{
     BASE_URL = await getAddress();
      var map = new Map<dynamic, dynamic>();
      map["date"] = DateFormat("yyyy-MM-dd").format(DateTime.parse(date));
    var dataRequest = await sendpost(BASE_URL + GET_YEARLY_FEE , body: map);
    return await jsonDecode(dataRequest.body);
  }

  Future<bool> submitUserFee(int registrationNo , paymentMode mode, int registraionFee , int monthlyFee , int trademilFee , int lightsChargesFee , int personalTrainingFee , int otherFee , String feeNote , String date)async{
     BASE_URL = await getAddress();
  var map = new Map<dynamic, dynamic>();
  map["registrationNo"] = registrationNo.toString();
  map["registrationFee"] = registraionFee.toString();
  map["monthlyFee"] = monthlyFee.toString();
  map["trademilFee"] = trademilFee.toString();
  map["lightsCharges"] = lightsChargesFee.toString();
  map["personalTraining"] = personalTrainingFee.toString();
  map["otherFee"] = otherFee.toString();
  map["note"] = feeNote;
  map["mode"] = mode.name;
  map["date"] = DateFormat("yyyy-MM-dd").format(DateTime.parse(date));

  

    var dataRequest = await sendpost(BASE_URL + SUBMIT_USER_FEE , body: map);
    return await jsonDecode(dataRequest.body);
  }

    Future<dynamic> addExpenses(expense expenses , String title  ,int amount  , paymentMode mode , String note , String date , String? expCategory )async{
       BASE_URL = await getAddress();
  var map = new Map<dynamic, dynamic>();
  map["expenses"] = expenses.name;
  map["title"] = title;
  map["amount"] = amount.toString();
  map["paymentMode"] = mode.name;
  map["note"] = note;
  map["date"] = DateFormat("yyyy-MM-dd").format(DateTime.parse(date));
  map["expensesCategory"] = expCategory.toString();


    var dataRequest = await sendpost(BASE_URL + ADD_EXPENSES , body: map);
    return await jsonDecode(dataRequest.body);
  }
  
  Future<dynamic> editExpenses(String id , expense expenses , String title  ,int amount  , paymentMode mode , String note , String date , String? expCategory)async{
       BASE_URL = await getAddress();
  var map = new Map<dynamic, dynamic>();
  map["id"] = id;
  map["expenses"] = expenses.name;
  map["title"] = title;
  map["amount"] = amount.toString();
  map["paymentMode"] = mode.name;
  map["note"] = note;
  map["expensesCategory"] = expCategory.toString();
  map["date"] = DateFormat("yyyy-MM-dd").format(DateTime.parse(date));


    var dataRequest = await sendpost(BASE_URL + EDIT_EXPENSES , body: map);
    return await jsonDecode(dataRequest.body);
  }

  Future<dynamic> getGymExpenses(String date)async{
     BASE_URL = await getAddress();
         var map = new Map<dynamic, dynamic>();
      map["date"] = DateFormat("yyyy-MM-dd").format(DateTime.parse(date));
    var dataRequest = await sendpost(BASE_URL + GET_GYM_EXPENSES , body: map);
    return await jsonDecode(dataRequest.body);
  }
  
  Future<dynamic> getOtherExpenses(String date)async{
     BASE_URL = await getAddress();
     var map = new Map<dynamic, dynamic>();
     map["date"] = DateFormat("yyyy-MM-dd").format(DateTime.parse(date));
    var dataRequest = await sendpost(BASE_URL + GET_OTHER_EXPENSES , body: map);
    return await jsonDecode(dataRequest.body);
  }
    Future<dynamic> getTotalExpenses(String date)async{
     BASE_URL = await getAddress();
      var map = new Map<dynamic, dynamic>();
      map["date"] = DateFormat("yyyy-MM-dd").format(DateTime.parse(date));
    var dataRequest = await sendpost(BASE_URL + GET_TOTAL_EXPENSES , body: map);
    return await jsonDecode(dataRequest.body);
  }
  
  Future<dynamic> getExpensesForPdf(String date , pdf time , expense exp)async{
     BASE_URL = await getAddress();
     var map = new Map<dynamic, dynamic>();
     map["date"] = DateFormat("yyyy-MM-dd").format(DateTime.parse(date));
     map["time"] = time.name;
     map["expense"] = exp.name;
    var dataRequest = await sendpost(BASE_URL + GET_PDF_EXPENSES , body: map);
    return await jsonDecode(dataRequest.body);
  }
  Future<dynamic> deleteExpenses(String id)async{
       BASE_URL = await getAddress();
    var map = new Map<dynamic, dynamic>();
    map["id"] = id;

    var dataRequest = await sendpost(BASE_URL + DELETE_EXPENSES , body: map);
    return await jsonDecode(dataRequest.body);
    }

  Future<dynamic> submitAttandance(List<int> registationNo , String date , String time)async{
     BASE_URL = await getAddress();
    var map = new Map<dynamic, dynamic>();
    String reg ="";
    for (var i = 0; i < registationNo.length; i++) {
      if(i == registationNo.length -1){
        reg =reg + registationNo[i].toString();
      }else{
        reg =reg + registationNo[i].toString() +",";
      }
       
    }
   // print("submit attandacne "+reg);
    map["registrationNo"] = reg;
    map["date"] = DateFormat("yyyy-MM-dd").format(DateTime.parse(date));
    map["time"] = time;
    var dataRequest = await sendpost(BASE_URL + SUBMIT_ATTANDANCE , body: map);
    return await jsonDecode(dataRequest.body);
  }


  Future<dynamic> deleteAttandanceList(List<int> list , String date , attandance value)async{
     BASE_URL = await getAddress();
    var map = new Map<dynamic, dynamic>();
    String reg ="";
    for (var i = 0; i < list.length; i++) {
      if(i == list.length -1){
        reg =reg + list[i].toString();
      }else{
        reg =reg + list[i].toString() +",";
      }
       
    }
   // print("submit attandacne "+reg);
    map["deletelist"] = reg;
    map["date"] = DateFormat("yyyy-MM-dd").format(DateTime.parse(date));
    map["status"] = value.name;

    var dataRequest = await sendpost(BASE_URL + DELETE_ATTANDANCE_LIST , body: map);
    return await jsonDecode(dataRequest.body);
  }
  
  Future<dynamic> deleteAttandance(String id)async{
       BASE_URL = await getAddress();
    var map = new Map<dynamic, dynamic>();
    map["id"] = id;

    var dataRequest = await sendpost(BASE_URL + DELETE_USER_ATTANDANCE , body: map);
    return await jsonDecode(dataRequest.body);
    }


  Future<List<AttandanceModel>> getUserAttandanceByStatus(attandanceStatus status , String date)async{
     BASE_URL = await getAddress();
    var map = new Map<dynamic, dynamic>();
    map["status"] = status.name;
    map["date"] = DateFormat("yyyy-MM-dd").format(DateTime.parse(date));
    var dataRequest = await sendpost(BASE_URL + GET_USER_BY_ATTANDANCE_STATUS , body: map);
    var response = await jsonDecode(dataRequest.body);
   // print("ATTANDANCE "+response.toString());
    List<AttandanceModel> list= [];
     for(var user in response){
        list.add(AttandanceModel.fromJson(user));
      }  
     return list;
  }

    Future<dynamic> getUserAttandancepdf(String date)async{
     BASE_URL = await getAddress();
    var map = new Map<dynamic, dynamic>();
    map["date"] = DateFormat("yyyy-MM-dd").format(DateTime.parse(date));
    var dataRequest = await sendpost(BASE_URL + GET_USER_BY_ATTANDANCE_PDF , body: map);
    var response = await jsonDecode(dataRequest.body);
   // print("ATTANDANCE "+response.toString());
    return response;
  }

  Future<dynamic> finishDay(String date , String time)async{
     BASE_URL = await getAddress();
    var map = new Map<dynamic, dynamic>();
     map["date"] = DateFormat("yyyy-MM-dd").format(DateTime.parse(date));
     map["time"] = time;
    var dataRequest = await sendpost(BASE_URL + FINISH_DAY , body: map);
    return await jsonDecode(dataRequest.body);
  }

  Future<dynamic> getUserAttandance(int registration , String date)async{
  BASE_URL = await getAddress();
  var map = new Map<dynamic, dynamic>();
  map["registrationNo"] = registration.toString();
  map["date"] = DateFormat("yyyy-MM-dd").format(DateTime.parse(date));

  var dataRequest = await sendpost(BASE_URL + USER_ATTANDANCE , body: map);
  return await jsonDecode(dataRequest.body);
  }

  Future<dynamic> editUserProfile(String name , String phoneNo , String email , String busAddress, String gstin , String udyogReg , String busDes, String state, String type , String busCategory )async{
    BASE_URL = await getAddress();
    var map = new Map<dynamic, dynamic>();
    map["name"] =name;
    map["phoneNo"] =phoneNo;
    map["email"] =email;
    map["busAddress"] =busAddress;
    map["gstin"] =gstin;
    map["udyogReg"] =udyogReg;
    map["busDes"] =busDes;
    map["state"] =state;
    map["type"] =type;
    map["busCategory"] =busCategory;
    var dataRequest = await sendpost(BASE_URL + EDIT_PROFILE , body: map);
  return await jsonDecode(dataRequest.body);
  }

  Future<dynamic> getProfile()async{
       BASE_URL = await getAddress();
    
     var dataRequest = await sendpost(BASE_URL + GET_PROFILE );
      //print("Get active user "+dataRequest.toString());
    
     return await jsonDecode(dataRequest.body);
    }

  // sendpost(String url  , dynamic body)async{
  //    HttpClient client = new HttpClient();
  //     client.badCertificateCallback = ((cert, host, port) => true);
  //     HttpClientRequest request = await client.postUrl(Uri.parse(url));
  //     request.headers.set('content-type', 'application/json');

  //     request.add(utf8.encode(body));

  //     HttpClientResponse response = await request.close();

  //     String reply = await response.transform(utf8.decoder).join();

  //     print(reply);
      
  //     return reply;
  // }

    Future<http.Response> sendpost(dynamic url,
      {Map<String, String>? headers, dynamic body, Encoding? encoding}) {
    String message = "";
    //headers = new Map<String, String>();
    //   encoding = Encoding.getByName("UTF-8");
    if (body != null) {
      body.forEach((key, value) {
        message += key + "=" + value;
      });
    }
   
      print(message);
      print("url " + url.toString());
 
    // String digest = digester(message);
    // headers['digest'] = digest;
    // headers['token'] = GameUtils().needleArt.toString();
    // headers['version'] = GameUtils().versionNo;
    //  var json1 = json.encode(body);
    //  headers['Content-Type'] = "application/json";
    return http.post(Uri.parse(url), headers: headers, body: body);
  }

 getAddress()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return  await preferences.getString("serverAddress")??"";
  }

  //   Future<HttpClientResponse> foo(dynamic url , {}) async {
  //   String jsonString = json.encode(jsonMap); // encode map to json
  //   String paramName = 'param'; // give the post param a name
  //   String formBody = paramName + '=' + Uri.encodeQueryComponent(jsonString);
  //   List<int> bodyBytes = utf8.encode(formBody); // utf8 encode
  //   HttpClientRequest request =
  //       await _httpClient.post(_host, _port, '/a/b/c');
  //   // it's polite to send the body length to the server
  //   request.headers.set('Content-Length', bodyBytes.length.toString());
  //   // todo add other headers here
  //   request.add(bodyBytes);
  //   return await request.close();
  // }
}