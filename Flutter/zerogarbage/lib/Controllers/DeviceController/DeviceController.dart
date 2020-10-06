import 'dart:convert';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zerogarbage/Models/Common/Common.dart';
import 'package:zerogarbage/Models/Device.dart';
import 'package:zerogarbage/Models/HttpModels/HttpCommon.dart';
import 'package:zerogarbage/Models/HttpModels/HttpRoutes.dart';

class DeviceController {
  ModelCommon common = new ModelCommon();

  HttpCommon httpCommon = new HttpCommon(methodget: true);

  BuildContext context;

  DeviceController(BuildContext context) {
    this.context = context;
  }

  Future<List<DeviceModel>> getAllDevices() async {
    List<DeviceModel> deviceList = [];
    common.showLoader(context);
    await httpCommon
        .process(
            HttpRoutes.getPairedDevices + "?type=" + ModelCommon.userModel.type)
        .then((value) async {
      if (value.statusCode == 200) {
        deviceList.clear();

        common.hideLoaderCurrrent(context);

        var jsonData = json.decode(value.body);

        for (var jsonObj in jsonData['data']) {
          deviceList.add(new DeviceModel(
              id: jsonObj['id'],
              mac: jsonObj['mac'].toString(),
              latitude: double.parse(jsonObj['latitude']),
              longitude: double.parse(jsonObj['longitude']),
              status: jsonObj['status'].toString(),
              type: jsonObj['type']));
        }
      } else {
        common.hideLoaderCurrrent(context);
        Flushbar(
          message: "Error, Try again Later",
          duration: Duration(seconds: 3),
        ).show(context);
      }
    });

    return deviceList;
  }

  Future<List<DeviceModel>> getAllDevicesAsync() async {
    List<DeviceModel> deviceList = [];
    await httpCommon
        .process(
            HttpRoutes.getPairedDevices + "?type=" + ModelCommon.userModel.type)
        .then((value) async {
      if (value.statusCode == 200) {
        deviceList.clear();

        var jsonData = json.decode(value.body);

        for (var jsonObj in jsonData['data']) {
          deviceList.add(new DeviceModel(
              id: jsonObj['id'],
              mac: jsonObj['mac'].toString(),
              latitude: double.parse(jsonObj['latitude']),
              longitude: double.parse(jsonObj['longitude']),
              status: jsonObj['status'].toString(),
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

  Future<void> deleteDevice(int id) async {
    await httpCommon
        .process(HttpRoutes.deleteDevice + "?id=" + id.toString())
        .then((value) async {
      if (value.statusCode == 200) {
        Flushbar(
          message: "Successfully Deleted",
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

  Future<void> updateTypeDevice(int id, int type) async {
    await httpCommon
        .process(HttpRoutes.updateDeviceType +
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
