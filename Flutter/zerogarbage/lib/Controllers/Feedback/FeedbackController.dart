import 'dart:convert';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:zerogarbage/Models/Common/Common.dart';
import 'package:zerogarbage/Models/Feedback.dart';
import 'package:zerogarbage/Models/HttpModels/HttpCommon.dart';
import 'package:zerogarbage/Models/HttpModels/HttpRoutes.dart';

class FeedbackController {
  BuildContext context;

  ModelCommon modelCommon = new ModelCommon();

  FeedbackController(BuildContext context) {
    this.context = context;
  }

  void storeFeedback(FeedbackModel feedbackModel) {
    modelCommon.showLoader(context);

    var dataContext;

    if (feedbackModel.path != null) {
      String base64Image = base64Encode(feedbackModel.path.readAsBytesSync());

      dataContext = {
        'device_id': feedbackModel.device_id,
        'feedback': feedbackModel.feedback,
        'image': base64Image,
      };
    } else {
      dataContext = {
        'device_id': feedbackModel.device_id,
        'feedback': feedbackModel.feedback,
      };
    }
    new HttpCommon(methodget: false, data: dataContext)
        .process(HttpRoutes.createFeedback)
        .then((value) {
      modelCommon.hideLoaderCurrrent(context);
      if (value.statusCode == 200) {
        Navigator.pop(context);
        Flushbar(
          message: "Your feedback submitted",
          duration: Duration(seconds: 3),
        ).show(context);
      } else if (value.statusCode == 401) {
        Flushbar(
          message: "Something wrong, Please try again later",
          duration: Duration(seconds: 3),
        ).show(context);
      }
    });
  }

  Future<List<FeedbackModel>> getAllDevicesAsync(String id) async {
    List<FeedbackModel> deviceList = [];
    await new HttpCommon(methodget: true)
        .process(HttpRoutes.getAllFeedbacks + "?id=" + id)
        .then((value) async {
      if (value.statusCode == 200) {
        deviceList.clear();

        var jsonData = json.decode(value.body);

        for (var jsonObj in jsonData['data']) {
          deviceList.add(new FeedbackModel(
            id: jsonObj['id'],
            feedback: jsonObj['feedback'].toString(),
            path: "http://nsbm.sselk.com/public/" + jsonObj['path'].toString(),
            created_at: jsonObj['date'].toString(),
          ));
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

  Future<void> deleteDevice(id) async {
    await new HttpCommon(methodget: true)
        .process(HttpRoutes.dropFeedback + "?id=" + id.toString())
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
}
