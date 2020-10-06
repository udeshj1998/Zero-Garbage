import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zerogarbage/Controllers/Auth/AuthController.dart';
import 'package:zerogarbage/Models/Common/Common.dart';
import 'package:zerogarbage/Models/User.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  ModelCommon common = new ModelCommon();

  AuthController authController;

  @override
  Widget build(BuildContext context) {
    Size displaySize = MediaQuery.of(context).size;

    authController = new AuthController(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.black,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          child: Align(
            alignment: Alignment.center,
            child: Wrap(
              alignment: WrapAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20.0),
                  width: displaySize.width * 0.9,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 0.1),
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 40.0,
                      ),
                      Image.asset(
                        'assets/images/logo.png',
                        height: displaySize.width * 0.20,
                        width: displaySize.width * 0.20,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        "Zero Garbage",
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        "Please Login To Unlock Features",
                        style: TextStyle(color: Colors.white, fontSize: 15.0),
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      getLoginForm(),
                      SizedBox(
                        height: 40.0,
                      ),
                      getAuthButtons(),
                      SizedBox(
                        height: 40.0,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  getLoginForm() {
    return Form(
        key: _loginFormKey,
        child: Container(
          padding: EdgeInsets.only(
              left: ModelCommon.displayWidth * 0.01,
              right: ModelCommon.displayWidth * 0.01),
          child: Column(
            children: <Widget>[
              Container(
                child: TextFormField(
                  controller: emailController,
                  decoration: new InputDecoration(
                    prefixIcon: Icon(
                      MaterialCommunityIcons.email,
                      color: Colors.green,
                    ),
                    hintText: "Email",
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
                        borderSide:
                            BorderSide(color: common.greenColor, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    errorBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: common.greenColor, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  ),
                  cursorColor: Colors.green,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Email cannot be empty";
                    }
                  },
                  initialValue: null,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Container(
                child: TextFormField(
                  controller: passwordController,
                  decoration: new InputDecoration(
                    prefixIcon: Icon(
                      MaterialCommunityIcons.lock,
                      color: Colors.green,
                    ),
                    hintText: "Password",
                    errorStyle: GoogleFonts.openSans(
                        fontSize: 12, color: common.greenColor),
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding:
                        new EdgeInsets.fromLTRB(5.0, 10.0, 10.0, 10.0),
                    errorBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: common.greenColor, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: common.greenColor, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: common.greenColor, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  ),
                  cursorColor: Colors.green,
                  obscureText: true,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Password cannot be empty";
                    }
                  },
                  initialValue: null,
                ),
              ),
            ],
          ),
        ));
  }

  getAuthButtons() {
    return GestureDetector(
      onTap: () async {
        if (_loginFormKey.currentState.validate()) {
          await AuthController(context).loginProcess(UserModel(
              email: emailController.text, password: passwordController.text));
        }
      },
      child: Container(
        width: ModelCommon.displayWidth * 0.9,
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.green,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        padding: EdgeInsets.only(top: 13.0, bottom: 13.0),
        child: Text("Login now",
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(fontSize: 15, color: Colors.white)),
      ),
    );
  }
}
