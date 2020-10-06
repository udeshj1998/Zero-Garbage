import 'dart:convert';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zerogarbage/Models/Common/Common.dart';
import 'package:zerogarbage/Models/Device.dart';
import 'package:zerogarbage/Models/HttpModels/HttpCommon.dart';
import 'package:zerogarbage/Models/HttpModels/HttpRoutes.dart';
import 'package:zerogarbage/Models/User.dart';

class UserController {
  ModelCommon common = new ModelCommon();

  HttpCommon httpCommon = new HttpCommon(methodget: true);

  BuildContext context;

  UserController(BuildContext context) {
    this.context = context;
  }

  Future<List<UserModel>> getAllUsersAsync() async {
    List<UserModel> deviceList = [];
    await httpCommon.process(HttpRoutes.getUsers).then((value) async {
      if (value.statusCode == 200) {
        deviceList.clear();

        var jsonData = json.decode(value.body);

        for (var jsonObj in jsonData['data']) {
          deviceList.add(new UserModel(
              id: jsonObj['id'],
              name: jsonObj['name'].toString(),
              email: jsonObj['email'].toString(),
              type: jsonObj['type']));
        }
      } else {
        Flushbar(
          message: "Error, Try again Later",
          duration: Duration(seconds: 3),
        ).show(context);
      }
    });

    return deviceList;
  }

  Future<void> updateTypeUser(int id, int type) async {
    await httpCommon
        .process(HttpRoutes.updateUserType +
            "?id=" +
            id.toString() +
            "&type=" +
            type.toString())
        .then((value) async {
      if (value.statusCode == 200) {
        Flushbar(
          message: "Successfully Updated",
          duration: Duration(seconds: 3),
        ).show(context);
      } else {
        Flushbar(
          message: "Error, Try again Later",
          duration: Duration(seconds: 3),
        ).show(context);
      }
    });
  }
}
