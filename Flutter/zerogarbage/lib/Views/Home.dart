import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:zerogarbage/Controllers/DeviceController/DeviceController.dart';
import 'package:zerogarbage/Controllers/Feedback/FeedbackController.dart';
import 'package:zerogarbage/Models/Common/Common.dart';
import 'package:zerogarbage/Models/Device.dart';
import 'package:zerogarbage/Models/Feedback.dart';
import 'package:zerogarbage/Views/Devices.dart';
import 'package:zerogarbage/Views/Login.dart';
import 'package:zerogarbage/Views/PairDevice.dart';
import 'package:zerogarbage/Views/UserManage.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool chooserImageVal = false;
  File file;

  final GlobalKey<FormState> _feedbackFormKey = GlobalKey<FormState>();

  Completer<GoogleMapController> _controller = Completer();

  static CameraPosition _sriLanka = CameraPosition(
    target: LatLng(6.927079, 79.861244),
    zoom: 15,
  );

  static CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  DeviceController deviceController;

  static BitmapDescriptor fullIcon;

  static BitmapDescriptor emptyIcon;

  Set<Marker> markers = new Set();

  ModelCommon common = ModelCommon();

  @override
  void initState() {
    super.initState();
    if (deviceController != null) {
      deviceController.getAllDevices();
    }
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance
          .addPostFrameCallback((_) => _goToFirstGarbage());
    }
  }

  @override
  Widget build(BuildContext context) {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.5), 'assets/images/full.png')
        .then((onValue) {
      fullIcon = onValue;
    });

    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.5),
            'assets/images/empty.png')
        .then((onValue) {
      emptyIcon = onValue;
    });

    deviceController = new DeviceController(context);

    return Container(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(
            child: Scaffold(
          drawer: (ModelCommon.userModel.type.toString() == "0")
              ? Drawer(
                  child: ListView(
                    children: <Widget>[
                      Image.asset(
                        "assets/images/ecodrawer.jpg",
                        height: 150.0,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      ListTile(
                        leading: Icon(Icons.person),
                        title: Text("Users"),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserManage()));
                        },
                      ),
                      ListTile(
                        leading: Icon(MaterialCommunityIcons.devices),
                        title: Text("Devices"),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DevicesView()));
                        },
                      ),
                      ListTile(
                        leading: Icon(MaterialCommunityIcons.qrcode),
                        title: Text("QR Code"),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PairDevice()));
                        },
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: ListTile(
                          leading: Icon(MaterialCommunityIcons.logout),
                          title: Text("Logout"),
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()));
                          },
                        ),
                      )
                    ],
                  ),
                )
              : null,
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text("Garbage Detector"),
            centerTitle: true,
            actions: (ModelCommon.userModel.type.toString() == "0")
                ? <Widget>[]
                : <Widget>[
                    Container(
                      padding: EdgeInsets.all(20.0),
                      child: GestureDetector(
                        child: Icon(MaterialCommunityIcons.logout),
                        onTap: () {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        },
                      ),
                    )
                  ],
          ),
          body: SafeArea(
              child: Stack(
            children: <Widget>[
              SizedBox(
                child: GoogleMap(
                  mapType: MapType.hybrid,
                  compassEnabled: true,
                  myLocationEnabled: true,
                  markers: markers,
                  zoomControlsEnabled: false,
                  initialCameraPosition: _sriLanka,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
              )
            ],
          )),
          floatingActionButton: FloatingActionButton.extended(
            foregroundColor: Colors.green,
            backgroundColor: Colors.black,
            onPressed: _goToFirstGarbage,
            label: Text('Refine Bins'),
            icon: Icon(MaterialCommunityIcons.recycle),
          ),
        )),
      ),
    );
  }

  Future<void> _goToFirstGarbage() async {
    await deviceController.getAllDevices().then((value) async {
      markers.clear();
      for (DeviceModel data in value) {
        markers.add(Marker(
            markerId: MarkerId(data.id.toString()),
            onTap: () {
              _showBinMenu(context, data);
            },
            position: new LatLng(data.latitude, data.longitude),
            icon: (data.status == "1") ? fullIcon : emptyIcon));
      }

      if (value.length > 0) {
        _kLake = CameraPosition(
            bearing: 192.8334901395799,
            target: LatLng(value[0].latitude, value[0].longitude),
            tilt: 59.440717697143555,
            zoom: 19.151926040649414);

        setState(() {});

        final GoogleMapController controller = await _controller.future;
        controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
      } else {
        Flushbar(
          message: "No Bins Found",
          duration: Duration(seconds: 3),
        ).show(context);
      }
    });
  }

  void _showBinMenu(context, data) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.navigation),
                    title: new Text('Navigate'),
                    onTap: () {
                      MapsLauncher.launchCoordinates(
                          data.latitude, data.longitude);
                      Navigator.pop(context);
                    }),
                (data.status == "1")
                    ? new ListTile(
                        leading: new Icon(Icons.comment),
                        title: new Text('Manage Bin'),
                        onTap: () {
                          Navigator.pop(context);
                          _addComment(context, data);
                        },
                      )
                    : Container(),
              ],
            ),
          );
        });
  }

  void _addComment(context, data) {
    file = null;
    chooserImageVal = false;

    TextEditingController feedbackController = new TextEditingController();

    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                padding: EdgeInsets.all(20.0),
                child: Form(
                    key: _feedbackFormKey,
                    child: new Wrap(
                      children: <Widget>[
                        SizedBox(
                          height: 20.0,
                        ),
                        Center(
                          child: Text(
                            "Manage Bins",
                            style:
                                TextStyle(color: Colors.green, fontSize: 20.0),
                          ),
                        ),
                        SizedBox(
                          height: 50.0,
                        ),
                        Text(
                          "Feedback",
                          style: TextStyle(color: Colors.green, fontSize: 15.0),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          controller: feedbackController,
                          autocorrect: true,
                          initialValue: null,
                          minLines: 5,
                          maxLines: 5,
                          decoration: new InputDecoration(
                            hintText: "Place here",
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
                            errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: common.greenColor, width: 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0))),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please describe your issue or feedback";
                            }
                          },
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20.0),
                          child: Text(
                            "Image Evidence",
                            style:
                                TextStyle(color: Colors.green, fontSize: 15.0),
                          ),
                        ),
                        SizedBox(
                          height: 2.0,
                        ),
                        StatefulBuilder(builder: (con, state) {
                          return GestureDetector(
                            onTap: () async {
                              file = await FilePicker.getFile();
                              if (file != null) {
                                state(() {
                                  chooserImageVal = true;
                                });
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(top: 20.0),
                              decoration: BoxDecoration(
                                  color: (chooserImageVal == false)
                                      ? common.greenColor
                                      : common.pinkColor,
                                  border: Border.all(
                                    color: (chooserImageVal == false)
                                        ? common.greenColor
                                        : common.pinkColor,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              padding: EdgeInsets.only(top: 13.0, bottom: 13.0),
                              child: Text(
                                  (chooserImageVal == false)
                                      ? "Choose Image"
                                      : "Image Choosed",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.openSans(
                                      fontSize: 15, color: Colors.white)),
                            ),
                          );
                        }),
                        GestureDetector(
                          onTap: () async {
                            if (_feedbackFormKey.currentState.validate()) {
                              new FeedbackController(context).storeFeedback(
                                  new FeedbackModel(
                                      device_id: data.id.toString(),
                                      feedback: feedbackController.text,
                                      path: (file != null) ? file : null));
                            }
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
                            child: Text("Submit",
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
}
