import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zerogarbage/Controllers/DeviceController/DeviceController.dart';
import 'package:zerogarbage/Controllers/Feedback/FeedbackController.dart';
import 'package:zerogarbage/Models/Common/Common.dart';
import 'package:zerogarbage/Models/Device.dart';
import 'package:zerogarbage/Models/Feedback.dart';

class DevicesView extends StatefulWidget {
  DevicesView({Key key}) : super(key: key);

  @override
  _DevicesViewState createState() => _DevicesViewState();
}

class _DevicesViewState extends State<DevicesView> {
  ModelCommon common = ModelCommon();

  DeviceController deviceController;
  FeedbackController feedbackController;

  @override
  Widget build(BuildContext context) {
    deviceController = new DeviceController(context);
    feedbackController = new FeedbackController(context);

    return Container(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(
            child: Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              Container(
                padding: EdgeInsets.all(20.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {});
                  },
                  child: Icon(
                    MaterialCommunityIcons.refresh,
                    color: Colors.white,
                  ),
                ),
              )
            ],
            backgroundColor: Colors.black,
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: Icon(Icons.arrow_back),
              ),
            ),
            title: Text("Devices"),
            centerTitle: true,
          ),
          body: Container(
            padding: EdgeInsets.all(10.0),
            child: FutureBuilder<List<Widget>>(
                future: getList(),
                builder: (contextSub, snapShot) {
                  if (snapShot.connectionState == ConnectionState.done) {
                    return ListView(
                      children: snapShot.data,
                    );
                  } else {
                    return common.getLoading();
                  }
                }),
          ),
        )),
      ),
    );
  }

  Future<List<Widget>> getList() async {
    List<Widget> tempList = [];
    tempList.clear();

    await deviceController.getAllDevicesAsync().then((value) {
      for (DeviceModel data in value) {
        tempList.add(Card(
          child: ListTile(
            onLongPress: () {
              _showData(data);
            },
            onTap: () {
              _showFeedbacks(data.id);
            },
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  MaterialCommunityIcons.devices,
                  color: (data.status == "0") ? Colors.green : Colors.red,
                )
              ],
            ),
            title: Text(data.mac.toString()),
            subtitle: Text(common.getType(int.parse(data.type))),
            trailing: (ModelCommon.userModel.type.toString() == "0")
                ? GestureDetector(
                    onTap: () {
                      deleteDevice(data.id);
                    },
                    child: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  )
                : (data.status == "1")
                    ? Text(
                        "FULL",
                        style: TextStyle(color: Colors.red),
                      )
                    : Text(""),
          ),
        ));
      }
    });

    return tempList;
  }

  Future<void> deleteDevice(id) async {
    await deviceController.deleteDevice(id);
    setState(() {});
  }

  void _showData(data) {
    int typeVal = int.parse(data.type);

    List<DropdownMenuItem<int>> userTypesDropDownList = [];

    userTypesDropDownList.add(new DropdownMenuItem(
      child: Text(common.getType(1)),
      value: 1,
    ));

    userTypesDropDownList.add(new DropdownMenuItem(
      child: Text(common.getType(2)),
      value: 2,
    ));

    userTypesDropDownList.add(new DropdownMenuItem(
      child: Text(common.getType(3)),
      value: 3,
    ));

    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                padding: EdgeInsets.all(20.0),
                child: Form(
                    child: new Wrap(
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      "Mac Address",
                      style: TextStyle(color: Colors.green, fontSize: 15.0),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      autocorrect: true,
                      enabled: false,
                      initialValue: data.mac.toString(),
                      decoration: new InputDecoration(
                        hintText: "Place your comment/feedback here",
                        errorStyle: GoogleFonts.openSans(
                            fontSize: 12, color: common.greenColor),
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding:
                            new EdgeInsets.fromLTRB(5.0, 10.0, 10.0, 10.0),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: common.greenColor, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: common.greenColor, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0))),
                        disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: common.greenColor, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0))),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: common.greenColor, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0))),
                      ),
                    ),
                    SizedBox(
                      height: 70.0,
                    ),
                    Text(
                      "Type",
                      style: TextStyle(color: Colors.green, fontSize: 15.0),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    StatefulBuilder(builder: (con, state) {
                      return DropdownButtonFormField<int>(
                        validator: (value) {
                          if (value == null) {
                            return 'Required';
                          }
                        },
                        value: typeVal,
                        decoration: new InputDecoration(
                          hintText: "Place your comment/feedback here",
                          errorStyle: GoogleFonts.openSans(
                              fontSize: 12, color: common.greenColor),
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding:
                              new EdgeInsets.fromLTRB(5.0, 10.0, 10.0, 10.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: common.greenColor, width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: common.greenColor, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0))),
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: common.greenColor, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0))),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: common.greenColor, width: 1.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0))),
                        ),
                        isExpanded: true,
                        onChanged: (value) {
                          state(() {
                            typeVal = value;
                          });
                        },
                        items: userTypesDropDownList,
                      );
                    }),
                    GestureDetector(
                      onTap: () async {
                        Navigator.pop(context);
                        await deviceController.updateTypeDevice(
                            data.id, typeVal);
                        setState(() {});
                      },
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 20.0),
                        decoration: BoxDecoration(
                            color: common.greenColor,
                            border: Border.all(
                              color: Colors.green,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        padding: EdgeInsets.only(top: 13.0, bottom: 13.0),
                        child: Text("Update Device",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.openSans(
                                fontSize: 15, color: Colors.white)),
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                  ],
                )),
              ));
        });
  }

  void _showFeedbacks(id) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                  padding: EdgeInsets.all(20.0),
                  child: StatefulBuilder(builder: (con, state) {
                    return FutureBuilder<List<Widget>>(
                        future: getDeviceFeedbacks(id.toString(), state),
                        builder: (contextSub, snapShotSub) {
                          if (snapShotSub.connectionState ==
                              ConnectionState.done) {
                            if (snapShotSub.data.length > 0) {
                              return ListView(
                                children: snapShotSub.data,
                              );
                            } else {
                              return Center(
                                child: Text(
                                  "Empty Feedbacks From This Bin",
                                  style: TextStyle(color: Colors.red),
                                ),
                              );
                            }
                          } else {
                            return common.getLoading();
                          }
                        });
                  })));
        });
  }

  Future<List<Widget>> getDeviceFeedbacks(id, state) async {
    List<Widget> listWidgets = [];
    listWidgets.clear();
    await feedbackController.getAllDevicesAsync(id).then((value) async {
      print(value.length);
      for (FeedbackModel data in value) {
        listWidgets.add(Card(
          child: ListTile(
            leading: Column(
              children: <Widget>[
                Image.network(
                  data.path,
                  height: 55.0,
                  width: 55.0,
                  fit: BoxFit.cover,
                ),
              ],
            ),
            title: Text("Feedback " + data.created_at),
            subtitle: Text(data.feedback),
            trailing: GestureDetector(
              onTap: () {
                feedbackController.deleteDevice(data.id);
                state(() {});
              },
              child: Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ),
        ));
      }
    });

    return listWidgets;
  }
}
