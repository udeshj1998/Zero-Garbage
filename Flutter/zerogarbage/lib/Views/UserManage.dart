import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zerogarbage/Controllers/Auth/AuthController.dart';
import 'package:zerogarbage/Controllers/DeviceController/DeviceController.dart';
import 'package:zerogarbage/Controllers/User/UserController.dart';
import 'package:zerogarbage/Models/Common/Common.dart';
import 'package:zerogarbage/Models/Device.dart';
import 'package:zerogarbage/Models/User.dart';

class UserManage extends StatefulWidget {
  UserManage({Key key}) : super(key: key);

  @override
  _UserManageState createState() => _UserManageState();
}

class _UserManageState extends State<UserManage> {
  ModelCommon common = ModelCommon();

  UserController deviceController;

  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    deviceController = new UserController(context);

    return Container(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SafeArea(
            child: Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              Container(
                padding: EdgeInsets.all(15.0),
                child: GestureDetector(
                  onTap: () {
                    _showRegisterModal();
                  },
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(15.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {});
                  },
                  child: Icon(
                    MaterialCommunityIcons.refresh,
                    color: Colors.white,
                  ),
                ),
              ),
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
            title: Text("Manage User"),
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

    await deviceController.getAllUsersAsync().then((value) {
      for (UserModel data in value) {
        tempList.add(Card(
          child: ListTile(
            onTap: () {
              _showData(data);
            },
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.person,
                  color: Colors.green,
                )
              ],
            ),
            title: Text(data.name +
                " ( " +
                common.getType(int.parse(data.type)) +
                " )"),
            subtitle: Text(data.email),
          ),
        ));
      }
    });

    return tempList;
  }

  void _showRegisterModal() {
    TextEditingController emailController = new TextEditingController();
    TextEditingController nameController = new TextEditingController();
    TextEditingController passwordController = new TextEditingController();
    TextEditingController rePasswordController = new TextEditingController();

    int typeVal = 0;

    List<DropdownMenuItem<int>> userTypesDropDownList = [];

    userTypesDropDownList.add(new DropdownMenuItem(
      child: Text(common.getType(0)),
      value: 0,
    ));

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
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                padding: EdgeInsets.all(20.0),
                child: Form(
                    key: _registerFormKey,
                    child: new Wrap(
                      children: <Widget>[
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          "Name",
                          style: TextStyle(color: Colors.green, fontSize: 15.0),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          controller: nameController,
                          autocorrect: true,
                          initialValue: null,
                          validator: (v) {
                            if (v.isEmpty) {
                              return "Fill this field";
                            }
                          },
                          decoration: new InputDecoration(
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
                        ),
                        SizedBox(
                          height: 70.0,
                        ),
                        Text(
                          "Email Address",
                          style: TextStyle(color: Colors.green, fontSize: 15.0),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          validator: (v) {
                            if (v.isEmpty) {
                              return "Fill this field";
                            }
                          },
                          controller: emailController,
                          autocorrect: true,
                          initialValue: null,
                          decoration: new InputDecoration(
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
                        ),
                        SizedBox(
                          height: 70.0,
                        ),
                        Text(
                          "Password",
                          style: TextStyle(color: Colors.green, fontSize: 15.0),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          validator: (v) {
                            if (v.isEmpty) {
                              return "Fill this field";
                            }
                          },
                          controller: passwordController,
                          autocorrect: true,
                          initialValue: null,
                          decoration: new InputDecoration(
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
                        ),
                        SizedBox(
                          height: 70.0,
                        ),
                        Text(
                          "Retype Password",
                          style: TextStyle(color: Colors.green, fontSize: 15.0),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          validator: (v) {
                            if (v.isEmpty) {
                              return "Fill this field";
                            } else {
                              if (passwordController.text != v) {
                                return "Passwords not match";
                              }
                            }
                          },
                          controller: rePasswordController,
                          autocorrect: true,
                          initialValue: null,
                          decoration: new InputDecoration(
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
                              errorStyle: GoogleFonts.openSans(
                                  fontSize: 12, color: common.greenColor),
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: new EdgeInsets.fromLTRB(
                                  5.0, 10.0, 10.0, 10.0),
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
                            if (_registerFormKey.currentState.validate()) {
                              Navigator.pop(context);
                              await new AuthController(context).registerProcess(
                                  new UserModel(
                                      email: emailController.text,
                                      name: nameController.text,
                                      password: passwordController.text,
                                      type: typeVal.toString()));
                              setState(() {});
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
                            child: Text("Register",
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

  void _showData(data) {
    int typeVal = int.parse(data.type);

    List<DropdownMenuItem<int>> userTypesDropDownList = [];

    userTypesDropDownList.add(new DropdownMenuItem(
      child: Text(common.getType(0)),
      value: 0,
    ));

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
                      "Name",
                      style: TextStyle(color: Colors.green, fontSize: 15.0),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      autocorrect: true,
                      enabled: false,
                      initialValue: data.name.toString(),
                      decoration: new InputDecoration(
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
                      "Email Address",
                      style: TextStyle(color: Colors.green, fontSize: 15.0),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      autocorrect: true,
                      enabled: false,
                      initialValue: data.email.toString(),
                      decoration: new InputDecoration(
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
                        await deviceController.updateTypeUser(data.id, typeVal);
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
                        child: Text("Update Colletor",
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
