import 'dart:convert';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zerogarbage/Models/Common/Common.dart';
import 'package:zerogarbage/Models/HttpModels/HttpCommon.dart';
import 'package:zerogarbage/Models/HttpModels/HttpRoutes.dart';
import 'package:zerogarbage/Models/User.dart';
import 'package:zerogarbage/Views/Home.dart';

class AuthController {
  BuildContext context;
  ModelCommon common;

  AuthController(BuildContext context) {
    this.context = context;
    this.common = ModelCommon();
  }

  Future<void> loginProcess(UserModel userModel) async {
    this.common.showLoader(context);
    await new HttpCommon(
            methodget: false,
            data: {'email': userModel.email, 'password': userModel.password})
        .process(HttpRoutes.login)
        .then((value) async {
      this.common.hideLoaderCurrrent(context);
      if (value.statusCode == 200) {
        var jsonData = json.decode(value.body);

        ModelCommon.userModel = new UserModel(
            id: jsonData['user']['id'],
            name: jsonData['user']['name'],
            email: jsonData['user']['email'],
            type: jsonData['user']['type']);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      } else if (value.statusCode == 401) {
        Flushbar(
          message: "Auth Error,  Please Check Email & Password",
          duration: Duration(seconds: 3),
        ).show(context);
      } else if (value.statusCode == 400) {
        Flushbar(
          message: "Params Empty",
          duration: Duration(seconds: 3),
        ).show(context);
      } else {
        Flushbar(
          message: "Something wrong, Please try again later" +
              value.statusCode.toString(),
          duration: Duration(seconds: 3),
        ).show(context);
      }
    });
  }

  Future registerProcess(UserModel userModel) async {
    this.common.showLoader(context);
    await new HttpCommon(methodget: false, data: {
      'name': userModel.name,
      'email': userModel.email,
      'password': userModel.password,
      'repassword': userModel.password,
      'type': userModel.type
    })
        .process(
      HttpRoutes.register,
    )
        .then((value) {
      this.common.hideLoaderCurrrent(context);
      if (value.statusCode == 200) {
        Flushbar(
          message: "Registration Succeed",
          duration: Duration(seconds: 3),
        ).show(context);
      } else if (value.statusCode == 401) {
        Flushbar(
          message: "Auth Error,  Please Check Email & Password",
          duration: Duration(seconds: 3),
        ).show(context);
      } else if (value.statusCode == 400) {
        Flushbar(
          message: "Params Empty",
          duration: Duration(seconds: 3),
        ).show(context);
      } else {
        Flushbar(
          message: "Something wrong, Please try again later" +
              value.statusCode.toString(),
          duration: Duration(seconds: 3),
        ).show(context);
      }
    });
  }
}
