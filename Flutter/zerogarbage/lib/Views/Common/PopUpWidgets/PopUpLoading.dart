import 'package:flutter/material.dart';
import 'package:zerogarbage/Models/Common/Common.dart';

class PopUpLoading extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PopUpLoadingState();
}

class PopUpLoadingState extends State<PopUpLoading>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

  ModelCommon commonProfile = new ModelCommon();

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            alignment: Alignment.center,
            child: new CircularProgressIndicator(
              valueColor:
                  new AlwaysStoppedAnimation<Color>(commonProfile.greenColor),
            ),
          ),
        ),
      ),
    );
  }
}
