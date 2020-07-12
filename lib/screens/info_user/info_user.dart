import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lolipop_book_store/models/userModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lolipop_book_store/viewmodels/CRUDUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class InfoUser extends StatefulWidget {
  final String idUser;
  InfoUser({Key key, @required this.idUser}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return InfoUserState();
  }
}

class InfoUserState extends State<InfoUser> {
  String title = '';
  TextEditingController _userNameController = new TextEditingController();
  TextEditingController _phoneNumbController = new TextEditingController();
  TextEditingController _provinceController = new TextEditingController();
  TextEditingController _districtController = new TextEditingController();
  TextEditingController _wardController = new TextEditingController();
  TextEditingController _streetController = new TextEditingController();
  TextEditingController _noteController = new TextEditingController();

  TextEditingController _gioiTinhController = new TextEditingController();
  TextEditingController _ngaySinhController = new TextEditingController();
  CRUDUser crudUser = new CRUDUser();

  DateTime dateTime;
  String valueGioiTinh = 'Chưa chọn';
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    title = 'Thông tin cá nhân';

    dateTime = DateTime.now();
    super.initState();
  }

  Future<String> _getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _userEmail = prefs.getString('userEmail');

    if (_userEmail != null) {
      print('User email: ' + _userEmail);

      return _userEmail;
    } else
      return '';
  }

  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  _showListAlert(BuildContext context) {
    showPlatformDialog(
      context: context,
      builder: (_) => BasicDialogAlert(
        title: Text("Chọn giới tính"),
        content: Container(
          height: 100,
          child: Column(
            children: <Widget>[
              _buildListSampleItem('Nam', 'images/user/icon_male.png'),
              _buildListSampleItem('Nữ', 'images/user/icon_female.png'),
            ],
          ),
        ),
        actions: <Widget>[
          BasicDialogAction(
            title: Text(
              "Huỷ",
              style: TextStyle(
                  fontFamily: 'RobotoSlab',
                  fontSize: 17.0,
                  color: Colors.black),
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListSampleItem(String title, String image) {
    return Container(
        height: 30,
        margin: EdgeInsets.only(bottom: 15),
        child: InkWell(
          child: Row(
            children: <Widget>[
              Image.asset(
                image,
                width: 20.0,
                height: 20.0,
              ),
              SizedBox(width: 15),
              Text(
                title,
                style: TextStyle(fontFamily: 'RobotoSlab', fontSize: 17.0),
              ),
            ],
          ),
          onTap: () {
            _gioiTinhController.text = title;
            Navigator.of(context, rootNavigator: true).pop();
          },
        ));
  }

  String showGioiTinh(bool value) {
    if (value == true)
      return 'Nam';
    else
      return 'Nữ';
  }

  bool gioiTinhTypeBool(String value) {
    if (value == "Nam")
      return true;
    else
      return false;
  }

  void showToast(message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        textColor: Colors.white,
        fontSize: 15.0);
  }

  _changeAvatar() {}

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: new AppBar(
          backgroundColor: Colors.amber[700],
          title: new Text(title, style: TextStyle(fontFamily: 'RobotoSlab')),
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            child: Container(
              child: FutureBuilder(
                  future: _getUserEmail(),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.hasData && snapshot.data != '') {
                      return new StreamBuilder(
                          stream: crudUser.fetchOneUserAsStream(snapshot.data),
                          builder: (BuildContext context,
                              AsyncSnapshot<DocumentSnapshot> snapshotStream) {
                            if (snapshotStream.hasData) {
                              return KeyboardDismisser(
                                child: KeyboardDismisser(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height,
                                    child: Stack(
                                      children: <Widget>[
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                          color: Colors.grey[850],
                                        ),
                                        ClipPath(
                                          child: Container(
                                            color: Colors.yellow[700],
                                            // child: BlurHash(
                                            //   hash: "LISp{vr=B@\$z%FV|t8of9QV@JWs8",
                                            // ),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.4,
                                            //color: Colors.blue,
                                          ),
                                          clipper: CustomClipPath(),
                                        ),
                                        Center(
                                            child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.85,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.75,
                                                child: Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 30),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.0),
                                                          color: Colors.white
                                                              .withOpacity(
                                                                  0.9)),
                                                      child: Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 70),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Container(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            0.0,
                                                                        left:
                                                                            20.0,
                                                                        bottom:
                                                                            5.0),
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                      'Họ và tên:',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'RobotoSlab',
                                                                          fontSize:
                                                                              15.0)),
                                                                ),
                                                              ),
                                                              Container(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            20),
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.78,
                                                                height: 33,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10.0),
                                                                  // color: Colors
                                                                  //     .grey[200],
                                                                ),
                                                                child:
                                                                    TextFormField(
                                                                  controller:
                                                                      _userNameController,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14.0,
                                                                      fontFamily:
                                                                          'RobotoSlab'),
                                                                  decoration:
                                                                      InputDecoration(
                                                                          hintText: snapshotStream.data[
                                                                              'userName'],
                                                                          hintStyle: TextStyle(
                                                                              color: Colors.grey[
                                                                                  800],
                                                                              fontSize:
                                                                                  14,
                                                                              fontFamily:
                                                                                  'RobotoSlab'),
                                                                          fillColor: Colors.grey[
                                                                              300],
                                                                          focusColor: Colors.grey[
                                                                              300],
                                                                          contentPadding: EdgeInsets.only(
                                                                              top: 0.0,
                                                                              bottom: 0.0,
                                                                              left: 20,
                                                                              right: 20), //here your padding
                                                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
                                                                  enabled: true,
                                                                ),
                                                              ),
                                                              Container(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            5.0,
                                                                        left:
                                                                            20.0,
                                                                        bottom:
                                                                            5.0),
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                      'Email:',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'RobotoSlab',
                                                                          fontSize:
                                                                              15.0)),
                                                                ),
                                                              ),
                                                              Container(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            20),
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.78,
                                                                height: 33,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10.0),
                                                                  // color: Colors
                                                                  //         .grey[
                                                                  //     800],
                                                                ),
                                                                child:
                                                                    TextFormField(
                                                                  controller:
                                                                      _phoneNumbController,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14.0,
                                                                      fontFamily:
                                                                          'RobotoSlab'),
                                                                  decoration:
                                                                      InputDecoration(
                                                                          hintText: snapshotStream.data[
                                                                              'email'],
                                                                          hintStyle: TextStyle(
                                                                              color: Colors.grey[
                                                                                  800],
                                                                              fontSize:
                                                                                  14,
                                                                              fontFamily:
                                                                                  'RobotoSlab'),
                                                                          fillColor: Colors.grey[
                                                                              300],
                                                                          contentPadding: EdgeInsets.only(
                                                                              top: 0.0,
                                                                              bottom: 0.0,
                                                                              left: 20,
                                                                              right: 20), //here your padding
                                                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
                                                                  enabled:
                                                                      false,
                                                                ),
                                                              ),
                                                              Container(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            5.0,
                                                                        left:
                                                                            20.0,
                                                                        bottom:
                                                                            5.0),
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                      'Giới tính:',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'RobotoSlab',
                                                                          fontSize:
                                                                              15.0)),
                                                                ),
                                                              ),
                                                              Container(
                                                                height: 33,
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            20),
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.78,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10.0),
                                                                  color: Colors
                                                                          .grey[
                                                                      200],
                                                                ),
                                                                child: InkWell(
                                                                  child:
                                                                      TextFormField(
                                                                    controller:
                                                                        _gioiTinhController,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14.0,
                                                                        fontFamily:
                                                                            'RobotoSlab'),
                                                                    decoration: InputDecoration(
                                                                        hintText: showGioiTinh(snapshotStream.data['gioiTinh']),
                                                                        hintStyle: TextStyle(color: Colors.grey[800], fontSize: 14, fontFamily: 'RobotoSlab'),
                                                                        fillColor: Colors.grey[300],
                                                                        contentPadding: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 20, right: 20), //here your padding
                                                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
                                                                    enabled:
                                                                        false,
                                                                    onTap: () {
                                                                      _showListAlert(
                                                                          context);
                                                                    },
                                                                  ),
                                                                  onTap: () {
                                                                    _showListAlert(
                                                                        context);
                                                                  },
                                                                ),
                                                              ),
                                                              Container(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            5.0,
                                                                        left:
                                                                            20.0,
                                                                        bottom:
                                                                            5.0),
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Text(
                                                                      'Ngày sinh:',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'RobotoSlab',
                                                                          fontSize:
                                                                              15.0)),
                                                                ),
                                                              ),
                                                              InkWell(
                                                                child:
                                                                    Container(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              20),
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.78,
                                                                  height: 33,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.0),
                                                                    color: Colors
                                                                            .grey[
                                                                        200],
                                                                  ),
                                                                  child:
                                                                      TextFormField(
                                                                    controller:
                                                                        _ngaySinhController,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14.0,
                                                                        fontFamily:
                                                                            'RobotoSlab'),
                                                                    decoration: InputDecoration(
                                                                        hintText: snapshotStream.data['ngaySinh'] == '' ? 'xin hãy chọn ngày sinh' : snapshotStream.data['ngaySinh'],
                                                                        //hintText: DateTime.now().toString(),
                                                                        hintStyle: TextStyle(color: Colors.grey[800], fontSize: 14, fontFamily: 'RobotoSlab'),
                                                                        fillColor: Colors.grey[300],
                                                                        contentPadding: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 20, right: 20),
                                                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
                                                                    enabled:
                                                                        false,
                                                                  ),
                                                                ),
                                                                onTap:
                                                                    () async {
                                                                  DateTime
                                                                      newDateTime =
                                                                      await showRoundedDatePicker(
                                                                    context:
                                                                        context,
                                                                    //theme: ThemeData(primarySwatch: Colors.amber),
                                                                    imageHeader:
                                                                        AssetImage(
                                                                            "images/background/background_getTime.jpg"),
                                                                    description:
                                                                        "Việc đọc rất quan trọng. Nếu bạn biết cách đọc, cả thế giới sẽ mở ra cho bạn - Barack Obama",
                                                                    initialDate:
                                                                        DateTime
                                                                            .now(),
                                                                    // initialDate:
                                                                    //     snapshotStream.data['ngaySinh'] != ""
                                                                    //         ? DateTime.parse(
                                                                    //             snapshotStream.data['ngaySinh'])
                                                                    //         : DateTime.now(),
                                                                    // initialDate:
                                                                    //     snapshotStream.data['ngaySinh'] != null
                                                                    //         ? (snapshotStream.data['ngaySinh']
                                                                    //                 as Timestamp)
                                                                    //             .toDate()
                                                                    //         : DateTime.now(),
                                                                    firstDate: DateTime(
                                                                        DateTime.now().year -
                                                                            100),
                                                                    lastDate: DateTime(
                                                                        DateTime.now().year +
                                                                            1),
                                                                    borderRadius:
                                                                        16,
                                                                  );
                                                                  if (newDateTime !=
                                                                      null) {
                                                                    setState(() => _ngaySinhController
                                                                        .text = DateFormat(
                                                                            'dd-MM-yyyy')
                                                                        .format(
                                                                            newDateTime)
                                                                        .toString());
                                                                    print(
                                                                        '${dateTime.toString()} + YESSSSSSSSS');
                                                                  } else {
                                                                    setState(
                                                                        () {
                                                                      // dateTime = (snapshotStream.data['ngaySinh']
                                                                      //         as Timestamp)
                                                                      //     .toDate();
                                                                      dateTime =
                                                                          DateTime
                                                                              .now();
                                                                      print(
                                                                          '${dateTime.toString()} + NOOOOOOOOO');
                                                                    });
                                                                  }
                                                                },
                                                              ),
                                                              SizedBox(
                                                                  height: 20),
                                                              Center(
                                                                  child: Row(
                                                                      children: [
                                                                    FlatButton(
                                                                        onPressed:
                                                                            () async {
                                                                          await resetPassword(
                                                                              snapshot.data);
                                                                          showToast(
                                                                              "Một thư đã được gửi đến email của bạn. Vui lòng kiểm tra để đổi mật khẩu");
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              MediaQuery.of(context).size.width * 0.32,
                                                                          height:
                                                                              38,
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              color: Colors.yellow[700]),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                new Text('ĐỔI MẬT KHẨU', style: TextStyle(fontSize: 14.0, fontFamily: 'RobotoSlab', fontWeight: FontWeight.bold, color: Colors.white)),
                                                                          ),
                                                                        )),
                                                                    FlatButton(
                                                                        onPressed:
                                                                            () async {
                                                                          await crudUser.updateUser(
                                                                              snapshotStream.data['email'].trim(),
                                                                              data: User(userName: _userNameController.text != "" ? _userNameController.text : snapshotStream.data['userName'], diaChi: snapshotStream.data['diaChi'], imageURL: snapshotStream.data['imageURL'], role: snapshotStream.data['role'], soDienThoai: snapshotStream.data['soDienThoai'], soSachDaMua: snapshotStream.data['soSachDaMua'], verification: snapshotStream.data['verification'], email: snapshotStream.data['email'], ngaySinh: _ngaySinhController.text != "" ? _ngaySinhController.text : snapshotStream.data['ngaySinh'], gioiTinh: gioiTinhTypeBool(_gioiTinhController.text.trim())),
                                                                              fieldName: null,
                                                                              fieldValue: null);
                                                                          showToast(
                                                                              "Lưu thông tin thành công");
                                                                          print(
                                                                              snapshotStream.data['email']);
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              MediaQuery.of(context).size.width * 0.32,
                                                                          height:
                                                                              38,
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              color: Colors.yellow[700]),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                new Text('CẬP NHẬT', style: TextStyle(fontSize: 14.0, fontFamily: 'RobotoSlab', fontWeight: FontWeight.bold, color: Colors.white)),
                                                                          ),
                                                                        )),
                                                                  ]))
                                                            ],
                                                          )),
                                                    )))),
                                        Container(
                                          padding: EdgeInsets.only(top: 20),
                                          height: 130,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Container(
                                              child: Stack(children: [
                                            Center(
                                              child: Container(
                                                width: 100,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          snapshotStream.data[
                                                              'imageURL']),
                                                      fit: BoxFit.cover),
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  color: Colors.grey,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey[300]
                                                          .withOpacity(0.3),
                                                      spreadRadius: 5,
                                                      blurRadius: 5,
                                                      offset: Offset(0,
                                                          3), // changes position of shadow
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Center(
                                                child: Container(
                                                    width: 100,
                                                    height: 100,
                                                    padding: EdgeInsets.only(
                                                        top: 65),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30)),
                                                    child: Center(
                                                        child: IconButton(
                                                      icon: Icon(
                                                          Icons.camera_alt,
                                                          color: Colors.white),
                                                      onPressed:
                                                          _changeAvatar(),
                                                    )))),
                                          ])),
                                        )
                                      ],
                                    ),

                                    //child: _showScreen(),
                                  ),
                                ),
                              );
                            } else {
                              return Container(height: 0.0, width: 0.0);
                            }
                          });
                    } else {
                      return new Container(height: 0.0, width: 0.0);
                    }
                  }),
            )));
  }
}

class CustomClipPath extends CustomClipper<Path> {
  var radius = 10.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 4, size.height - 40, size.width / 2, size.height - 20);
    path.quadraticBezierTo(
        3 / 4 * size.width, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
