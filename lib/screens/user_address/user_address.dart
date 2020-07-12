import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lolipop_book_store/viewmodels/CRUDUser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class UserAddress extends StatefulWidget {
  UserAddress();

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<UserAddress> {
  int _currentStep = 0;
  String title = '';
  TextEditingController _userNameController = new TextEditingController();
  TextEditingController _phoneNumbController = new TextEditingController();
  TextEditingController _provinceController = new TextEditingController();
  TextEditingController _districtController = new TextEditingController();
  TextEditingController _wardController = new TextEditingController();
  TextEditingController _streetController = new TextEditingController();
  TextEditingController _noteController = new TextEditingController();
  CRUDUser crudUser = new CRUDUser();
  @override
  void initState() {
    super.initState();
    title = 'Địa chỉ giao hàng';
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

  Widget _showDiaChiScreen() {
    return KeyboardDismisser(
      child: SingleChildScrollView(
          child: FutureBuilder(
              future: _getUserEmail(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData && snapshot.data != '') {
                  return new StreamBuilder(
                      stream: crudUser.fetchOneUserAsStream(snapshot.data),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshotStream) {
                        if (snapshotStream.hasData) {
                          return new Container(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(
                                    top: 0.0, left: 10.0, bottom: 5.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Họ và tên:',
                                      style: TextStyle(
                                          fontFamily: 'RobotoSlab',
                                          fontSize: 15.0)),
                                ),
                              ),
                              Container(
                                height: 33,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.grey[200],
                                ),
                                child: TextFormField(
                                  controller: _userNameController,
                                  style: TextStyle(
                                      fontSize: 14.0, fontFamily: 'RobotoSlab'),
                                  decoration: InputDecoration(
                                      hintText: snapshotStream.data['userName'],
                                      hintStyle: TextStyle(
                                          color: Colors.grey[500],
                                          fontSize: 14,
                                          fontFamily: 'RobotoSlab'),
                                      fillColor: Colors.grey[300],
                                      contentPadding: EdgeInsets.only(
                                          top: 0.0,
                                          bottom: 0.0,
                                          left: 20,
                                          right: 20), //here your padding
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0))),
                                  enabled: false,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    top: 5.0, left: 10.0, bottom: 5.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Số điện thoại:',
                                      style: TextStyle(
                                          fontFamily: 'RobotoSlab',
                                          fontSize: 15.0)),
                                ),
                              ),
                              Container(
                                height: 33,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.grey[200],
                                ),
                                child: TextFormField(
                                  controller: _phoneNumbController,
                                  style: TextStyle(
                                      fontSize: 14.0, fontFamily: 'RobotoSlab'),
                                  decoration: InputDecoration(
                                      hintText:
                                          snapshotStream.data['soDienThoai'],
                                      hintStyle: TextStyle(
                                          color: Colors.grey[500],
                                          fontSize: 14,
                                          fontFamily: 'RobotoSlab'),
                                      fillColor: Colors.grey[300],
                                      contentPadding: EdgeInsets.only(
                                          top: 0.0,
                                          bottom: 0.0,
                                          left: 20,
                                          right: 20), //here your padding
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0))),
                                  enabled: false,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    top: 5.0, left: 10.0, bottom: 5.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Quốc gia:',
                                      style: TextStyle(
                                          fontFamily: 'RobotoSlab',
                                          fontSize: 15.0)),
                                ),
                              ),
                              Container(
                                height: 33,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.grey[200],
                                ),
                                child: TextFormField(
                                  style: TextStyle(
                                      fontSize: 14.0, fontFamily: 'RobotoSlab'),
                                  decoration: InputDecoration(
                                      hintText: "Viet Nam",
                                      hintStyle: TextStyle(
                                          color: Colors.grey[500],
                                          fontSize: 14,
                                          fontFamily: 'RobotoSlab'),
                                      fillColor: Colors.grey[300],
                                      contentPadding: EdgeInsets.only(
                                          top: 0.0,
                                          bottom: 0.0,
                                          left: 20,
                                          right: 20), //here your padding
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0))),
                                  enabled: false,
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(
                                            top: 5.0, left: 10.0, bottom: 5.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text('Tỉnh thành:',
                                              style: TextStyle(
                                                  fontFamily: 'RobotoSlab',
                                                  fontSize: 15.0)),
                                        ),
                                      ),
                                      InkWell(
                                          onTap: () {},
                                          child: Container(
                                            height: 33,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              color: Colors.grey[200],
                                            ),
                                            child: TextFormField(
                                              controller: _provinceController,
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontFamily: 'RobotoSlab'),
                                              decoration: InputDecoration(
                                                  hintText: "Phú Lộc",
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey[500],
                                                      fontSize: 14,
                                                      fontFamily: 'RobotoSlab'),
                                                  fillColor: Colors.grey[300],
                                                  contentPadding: EdgeInsets.only(
                                                      top: 0.0,
                                                      bottom: 0.0,
                                                      left: 20,
                                                      right:
                                                          20), //here your padding
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0))),
                                              enabled: false,
                                            ),
                                          ))
                                    ],
                                  ),
                                  Padding(padding: EdgeInsets.only(right: 20)),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(
                                            top: 5.0, left: 10.0, bottom: 5.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text('Quận huyện:',
                                              style: TextStyle(
                                                  fontFamily: 'RobotoSlab',
                                                  fontSize: 15.0)),
                                        ),
                                      ),
                                      InkWell(
                                          child: Container(
                                            height: 33,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              color: Colors.grey[200],
                                            ),
                                            child: TextFormField(
                                              controller: _districtController,
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontFamily: 'RobotoSlab'),
                                              decoration: InputDecoration(
                                                  hintText: "Lộc Bổn",
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey[500],
                                                      fontSize: 14,
                                                      fontFamily: 'RobotoSlab'),
                                                  fillColor: Colors.grey[300],
                                                  contentPadding: EdgeInsets.only(
                                                      top: 0.0,
                                                      bottom: 0.0,
                                                      left: 20,
                                                      right:
                                                          20), //here your padding
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0))),
                                              enabled: false,
                                            ),
                                          ),
                                          onTap: () {})
                                    ],
                                  )
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    top: 5.0, left: 10.0, bottom: 5.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Phường xã:',
                                      style: TextStyle(
                                          fontFamily: 'RobotoSlab',
                                          fontSize: 15.0)),
                                ),
                              ),
                              Container(
                                height: 33,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.grey[200],
                                ),
                                child: TextFormField(
                                  controller: _wardController,
                                  style: TextStyle(
                                      fontSize: 14.0, fontFamily: 'RobotoSlab'),
                                  decoration: InputDecoration(
                                      hintText: 'Lộc Bổn',
                                      hintStyle: TextStyle(
                                          color: Colors.grey[500],
                                          fontSize: 14,
                                          fontFamily: 'RobotoSlab'),
                                      fillColor: Colors.grey[300],
                                      contentPadding: EdgeInsets.only(
                                          top: 0.0,
                                          bottom: 0.0,
                                          left: 20,
                                          right: 20), //here your padding
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0))),
                                  enabled: false,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    top: 5.0, left: 10.0, bottom: 5.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Số nhà - đường :',
                                      style: TextStyle(
                                          fontFamily: 'RobotoSlab',
                                          fontSize: 15.0)),
                                ),
                              ),
                              Container(
                                height: 33,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.grey[200],
                                ),
                                child: TextFormField(
                                  controller: _streetController,
                                  style: TextStyle(
                                      fontSize: 14.0, fontFamily: 'RobotoSlab'),
                                  decoration: InputDecoration(
                                      hintText: '',
                                      hintStyle: TextStyle(
                                          color: Colors.grey[500],
                                          fontSize: 14,
                                          fontFamily: 'RobotoSlab'),
                                      fillColor: Colors.grey[300],
                                      contentPadding: EdgeInsets.only(
                                          top: 0.0,
                                          bottom: 0.0,
                                          left: 20,
                                          right: 20),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0))),
                                  enabled: true,
                                ),
                              ),
                              SizedBox(height: 20),
                              FlatButton(
                                  onPressed: () {},
                                  child: Container(
                                    height: 40.0,
                                    width: 400.0,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.yellow[700]),
                                    child: Center(
                                      child: new Text('LƯU THÔNG TIN',
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              fontFamily: 'RobotoSlab',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[800])),
                                    ),
                                  )),
                            ],
                          ));
                        } else {
                          return Container(height: 0.0, width: 0.0);
                        }
                      });
                } else {
                  return new Container(height: 0.0, width: 0.0);
                }
              })),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.amber[700],
        title: new Text(title, style: TextStyle(fontFamily: 'RobotoSlab')),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 30.0, left: 10.0, right: 10.0),
        child: _showDiaChiScreen(),
      ),
    );
  }
}
