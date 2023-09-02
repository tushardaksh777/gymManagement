import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_management/DTO/User.dart';
import 'package:gym_management/HomeList/DueUserList.dart';
import 'package:gym_management/globalData.dart';

import 'SearchList.dart';

class Search extends SearchDelegate {
  List<UserModel>? users = global.allUser;
  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    // return [
    //   IconButton(onPressed: (){
    //     users
    //   }, icon: Icon(Icons.clear))
    // ]
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
   return IconButton(onPressed: (){
    close(context, null);
   }, icon: Icon(Icons.arrow_back)); 
  }

  @override
  Widget buildResults(BuildContext context) {
    
    List<UserModel> matchedUser = [];
    // TODO: implement buildResults
  for(var user in users!){
    if(user.name!.toLowerCase().contains(query.toLowerCase())){
      matchedUser.add(user);
    }
  }
    if(matchedUser.isEmpty){
      var nu = int.parse(query);
     for(var user in users!){
    if(user.registrationNo! == nu){
      matchedUser.add(user);
    }
  }
  }

  return ListView.builder(itemCount: matchedUser.length, itemBuilder: (context, index) {
    UserModel user = matchedUser[index];
    return SearchList(user: user);
  });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
        double unitwidth = MediaQuery.of(context).size.width / 100;
    double unitheight = MediaQuery.of(context).size.height / 100;    
    List<UserModel> matchedUser = [];
    // TODO: implement buildSuggestions
      for(var user in users!){
    if(user.name!.toLowerCase().contains(query.toLowerCase()) || user.registrationNo.toString().contains(query)){
      matchedUser.add(user);
    }
  }
  //     if(matchedUser.isEmpty){
  //     var nu = int.parse(query);
  //    for(var user in users!){
  //   if(user.registrationNo! == nu){
  //     matchedUser.add(user);
  //   }
  // }
  // }

  
  
   if(matchedUser.length == 0){
    return Container(height:unitheight*18 , alignment: Alignment.center, child: Text("Not Found",style: GoogleFonts.montserrat(
                                                  textStyle: TextStyle(
                                                      color: Colors.white,fontWeight: FontWeight.w600,
                                                      fontSize: unitwidth *
                                                          1 *
                                                          3)),),);
   }
  return ListView.builder(itemCount: matchedUser.length, itemBuilder: (context, index) {
    UserModel user = matchedUser[index];
    return SearchList(user: user);
  });
  }
  
}