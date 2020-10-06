import 'package:flutter/material.dart';
import 'package:zerogarbage/Models/User.dart';
import 'package:zerogarbage/Views/Common/PopUpWidgets/PopUpLoading.dart';

class ModelCommon {
  static UserModel userModel;

  //Colors
  Color themeColor = Color.fromRGBO(13, 71, 161, 1);
  Color backgroundColor = Colors.black;
  Color whiteColor = Colors.white;
  Color blackColor = Colors.black;
  Color pinkColor = Colors.pink;
  Color greenColor = Colors.green;
  Color splashScreenPrrogressColor = Color.fromRGBO(0, 11, 16, 1);
  Color blackShadow500Color = Color.fromRGBO(55, 71, 79, 1);

  String FACEBOOK_APP_ID = "595644534661945";
  String GOOGLE_WEB_CLIENT_ID = "AIzaSyBEboJZjFMPL6hzFn97S6IE99PBp1AyYqk";
  String TWITTER_CONSUMER_KEY = "LfNAorWdEOHjjz3ugRd3v3Fyu";
  String TWITTER_CONSUMER_SECRET =
      "fomJMRxC1XzqLYTaFLqEcknLqfuJBG6naIS1BL3Umma4t4I6et";

  //Display Width
  static double displayWidth;
  static double displayHeight;

  BuildContext parentLoadingContext;
  bool checkShowLoader = false;

  getLoading() {
    return Container(
      alignment: Alignment.center,
      child: new CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(greenColor),
      ),
    );
  }

  Future showLoader(context) async {
    await showDialog(
      context: context,
      builder: (_) => PopUpLoading(),
    ).then((onValue) {
      parentLoadingContext = context;
      checkShowLoader = true;
    });
  }

  Future hideLoader() async {
    if (checkShowLoader == true && parentLoadingContext != null) {
      Navigator.pop(parentLoadingContext);
      parentLoadingContext = null;
    }
  }

  Future hideLoaderCurrrent(context) async {
    Navigator.pop(context);
    parentLoadingContext = null;
  }

  bool validateMac(String mac) {
    return RegExp(r"^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$").hasMatch(mac);
  }

  String getType(int id) {
    String data = "";
    switch (id) {
      case 0:
        data = "Administrator";
        break;
      case 1:
        data = "Food";
        break;
      case 2:
        data = "Plastic";
        break;
      case 3:
        data = "Glass";
        break;
      default:
        data = "Not Identified";
        break;
    }
    return data;
  }
}
