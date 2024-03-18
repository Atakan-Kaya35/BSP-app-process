import 'package:bsp/user_model.dart';
import 'package:flutter/material.dart';


class UserHolder{

  List<UserModel> users = [];

  UserHolder () {
    print("heal yeah");
  }

  void addUser(
    String name, 
    String graphLink,
    String jsonLink
  ) {
    this.users.add(UserModel(name: name, graphLink: graphLink, jsonLink: jsonLink, bgColor: Colors.green));
  }

  List<UserModel> giveEm () {
    return this.users;
  }

  Container showUsers () {
    List<UserModel> all = this.users;
    return Container(
      width: 720,
      child: ListView.separated(
        itemCount: all.length,
        scrollDirection: Axis.vertical,
        separatorBuilder: (context, index) => SizedBox(height: 50,),
        padding: EdgeInsets.only(
          left: 20,
          right: 20
        ),
        itemBuilder: (context, index){
          return Container(
            height: 500,
            decoration: BoxDecoration(
              color:  Colors.pink,
            ),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: all[index].getUpdatedImage(),
                ),
                Text(
                  all[index].name,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    fontSize: 14
                  ),
                )
              ]),
          );
        }),
    );
  }

}