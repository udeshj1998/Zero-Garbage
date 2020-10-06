import 'package:flushbar/flushbar.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zerogarbage/Models/Common/Common.dart';
import 'package:zerogarbage/Models/HttpModels/HttpCommon.dart';
import 'package:zerogarbage/Models/HttpModels/HttpRoutes.dart';

class PairController {
  ModelCommon common = new ModelCommon();

  HttpCommon httpCommon = new HttpCommon(methodget: true);

  BuildContext context;

  PairController(BuildContext buildContext) {
    this.context = buildContext;
  }

  Future<void> checkExists(String macAddress) async {
    common.showLoader(context);
    if (common.validateMac(macAddress)) {
      httpCommon
          .process(HttpRoutes.checkpair + "?mac=" + macAddress)
          .then((value) async {
        if (value.statusCode == 204) {
          common.hideLoaderCurrrent(context);
          Flushbar(
            message: "Please Wait, Processing : " + macAddress,
            duration: Duration(seconds: 3),
          ).show(context);

          Position position = await Geolocator()
              .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

          registerDevice(macAddress, position.longitude.toString(),
              position.latitude.toString());
        } else if (value.statusCode == 200) {
          common.hideLoaderCurrrent(context);
          Flushbar(
            message: "Already Paired",
            duration: Duration(seconds: 3),
          ).show(context);
        } else {
          common.hideLoaderCurrrent(context);
          Flushbar(
            message: "Something Wrong",
            duration: Duration(seconds: 3),
          ).show(context);
        }
      });
    } else {
      common.hideLoaderCurrrent(context);
      Flushbar(
        message: "Pair Error, Invalid Mac",
        duration: Duration(seconds: 3),
      ).show(context);
    }
  }

  Future<void> registerDevice(
      String mac, String longitude, String latitude) async {
    print("Pairing");

    common.showLoader(context);
    httpCommon
        .process(HttpRoutes.createDevice +
            "?mac=" +
            mac +
            "&longitude=" +
            longitude +
            "&latitude=" +
            latitude)
        .then((value) {
      if (value.statusCode == 200) {
        common.hideLoaderCurrrent(context);
        Flushbar(
          message: "Successfully Paired",
          duration: Duration(seconds: 3),
        ).show(context);
      } else {
        common.hideLoaderCurrrent(context);
        Flushbar(
          message: "Error",
          duration: Duration(seconds: 3),
        ).show(context);
      }
    });
  }
}
