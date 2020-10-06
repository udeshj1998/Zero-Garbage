import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:qrcode/qrcode.dart';
import 'package:zerogarbage/Controllers/PairController/PairController.dart';

class PairDevice extends StatefulWidget {
  PairDevice({Key key}) : super(key: key);

  @override
  _PairDeviceState createState() => _PairDeviceState();
}

class _PairDeviceState extends State<PairDevice> {
  QRCaptureController _captureController = QRCaptureController();

  bool _isTorchOn = false;

  PairController pairController;

  String macAddress = "";

  @override
  void initState() {
    super.initState();

    _captureController.onCapture((data) async {
      _captureController.pause();
      macAddress = data;
      if (pairController != null) {
        pairController.checkExists(macAddress);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    pairController = new PairController(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            QRCaptureView(controller: _captureController),
            Align(
              alignment: Alignment.bottomCenter,
              child: _buildToolBar(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildToolBar() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(
          color: Colors.black,
          textColor: Colors.green,
          onPressed: () {
            _captureController.pause();
          },
          child: Icon(MaterialCommunityIcons.pause),
        ),
        FlatButton(
          color: Colors.black,
          textColor: Colors.green,
          onPressed: () {
            if (_isTorchOn) {
              _captureController.torchMode = CaptureTorchMode.off;
            } else {
              _captureController.torchMode = CaptureTorchMode.on;
            }
            _isTorchOn = !_isTorchOn;
          },
          child: Icon(MaterialCommunityIcons.lightbulb_on),
        ),
        FlatButton(
          color: Colors.black,
          textColor: Colors.green,
          onPressed: () {
            _captureController.resume();
          },
          child: Icon(MaterialCommunityIcons.play),
        ),
      ],
    );
  }
}
