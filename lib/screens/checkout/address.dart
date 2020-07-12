import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_radio_grouped_button/CustomButtons/CustomRadioButton.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lolipop_book_store/main.dart';
import 'package:lolipop_book_store/models/bookModel.dart';
import 'package:lolipop_book_store/models/orderAdminModel.dart';
import 'package:lolipop_book_store/models/orderModel.dart';
import 'package:lolipop_book_store/models/promocodeModel.dart';
import 'package:lolipop_book_store/screens/checkout/checkoutComplete.dart';
import 'package:lolipop_book_store/screens/checkout/momoCheckOut.dart';
import 'package:lolipop_book_store/viewmodels/CRUDBook.dart';
import 'package:lolipop_book_store/viewmodels/CRUDOrder.dart';
import 'package:lolipop_book_store/viewmodels/CRUDOrderAdminModel.dart';
import 'package:lolipop_book_store/viewmodels/CRUDPromoCode.dart';
import 'package:lolipop_book_store/viewmodels/CRUDUser.dart';
import 'package:momo_payment_plugin/momo_payment_data.dart';
import 'package:momo_payment_plugin/momo_payment_plugin.dart';
import 'package:momo_payment_plugin/momo_payment_result.dart';
import 'package:ntp/ntp.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:string_validator/string_validator.dart';

class Address extends StatefulWidget {
  Address();

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<Address> {
  int _currentStep = 0;
  String title = '';
  String paymentMethod;
  int _soLuong = 0;
  double _tongTien = 0;
  List _bookList2;
  String newID = '';
  String _userEmail;
  bool _isPromo;
  double _discountAmount = 0;
  PromoCodeModel promocode = new PromoCodeModel();
  TextEditingController _userNameController = new TextEditingController();
  TextEditingController _phoneNumbController = new TextEditingController();
  TextEditingController _provinceController = new TextEditingController();
  TextEditingController _districtController = new TextEditingController();
  TextEditingController _wardController = new TextEditingController();
  TextEditingController _streetController = new TextEditingController(); //
  TextEditingController _noteController = new TextEditingController();
  TextEditingController _saleController = new TextEditingController();
  CRUDUser crudUser = new CRUDUser();
  CRUDPromoCode crudPromoCode;
  CRUDOrder crudOrder;
  Firestore _db = Firestore.instance;
  CollectionReference reference;
  String _voucher = "";
  bool _isBought = false;
  @override
  void initState() {
    super.initState();
    title = 'Địa chỉ giao hàng';
    paymentMethod = '';
  }

  void _generateID() async {
    newID = randomAlphaNumeric(8).toUpperCase() +
        '-' +
        randomAlphaNumeric(8).toUpperCase() +
        '-' +
        randomAlphaNumeric(8).toUpperCase();
  }

  void showToast(message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        textColor: Colors.white,
        fontSize: 15.0);
  }

  Widget _CheckOutDialog(BuildContext context, String text) {
    return AlertDialog(
        title: new Text('Thông báo'),
        content: new Text(text),
        actions: [
          FlatButton(
              child: new Text('OK'),
              onPressed: () async {
                if (text == 'Đã đặt hàng thành công. Tiếp tục mua hàng?') {
                  SharedPreferences _prefs =
                      await SharedPreferences.getInstance();
                  _prefs.remove('bookListCart');

                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => MyApp()));
                } else {
                  Navigator.of(context).pop();
                }
              })
        ]);
  }

  _showDialog(text) async {
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return _CheckOutDialog(context, text);
        });
  }

  Future<List> _getBookInCart() async {
    if (_isBought == false) {
      List _bookList = [];
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      _userEmail = _prefs.getString('userEmail');
      _bookList = await json.decode(_prefs.get('bookListCart'));
      _bookList2 = List.from(_bookList);
      crudOrder = new CRUDOrder(_userEmail);
      crudPromoCode = new CRUDPromoCode(_userEmail);

      await setState(() {
        _soLuong = _bookList[_bookList.length - 1]['tongSL'];
        _tongTien = _bookList[_bookList.length - 1]['tongTien'].toDouble();
      });

      return _bookList;
    }
    return null;
  }

  Future<String> _getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _userEmail = prefs.getString('userEmail');

    if (_userEmail != null) {
      return _userEmail;
    } else
      return '';
  }

  void onStepCancel() {
    setState(() {
      if (this._currentStep > 0) {
        this._currentStep = this._currentStep - 1;
        if (_currentStep == 0) {
          title = 'Địa chỉ giao hàng';
        } else if (_currentStep == 1) {
          title = 'Phương thức thanh toán';
        } else {
          title = 'Xác nhận đơn hàng';
        }
      } else {
        this._currentStep = 0;
      }
    });
  }

  void onStepContinue() {
    setState(() {
      if (this._currentStep < this._mySteps().length - 1) {
        this._currentStep = this._currentStep + 1;
        if (_currentStep == 0) {
          title = 'Địa chỉ giao hàng';
        } else if (_currentStep == 1) {
          title = 'Phương thức thanh toán';
        } else {
          title = 'Xác nhận đơn hàng';
        }
      } else {
        //Logic to check if everything is completed
        print('Completed, check fields.');
      }
    });
  }

  Widget _showDiaChiScreen() {
    return SingleChildScrollView(
        child: FutureBuilder(
            future: _getUserEmail(),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData && snapshot.data != '') {
                return new StreamBuilder(
                    stream: crudUser.fetchOneUserAsStream(snapshot.data),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshotStream) {
                      if (snapshotStream.hasData) {
                        _userNameController.text =
                            snapshotStream.data['userName'];
                        _phoneNumbController.text =
                            snapshotStream.data['soDienThoai'];
                        return new SingleChildScrollView(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('ĐỊA CHỈ GIAO HÀNG',
                                style: TextStyle(
                                    fontFamily: 'RobotoSlab',
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold)),
                            Divider(
                              thickness: 1,
                            ),
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
                                    hintText: 'Nguyễn Văn A',
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
                                enabled: true,
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
                                    hintText: '123 456 789',
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
                                enabled: true,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                            enabled: true,
                                          ),
                                        ))
                                  ],
                                ),
                                Padding(padding: EdgeInsets.only(right: 20)),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                            enabled: true,
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
                                enabled: true,
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
                            Container(
                              padding: EdgeInsets.only(
                                  top: 5.0, left: 10.0, bottom: 5.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text('Ghi chú :',
                                    style: TextStyle(
                                        fontFamily: 'RobotoSlab',
                                        fontSize: 15.0)),
                              ),
                            ),
                            Container(
                              height: 120,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.grey[200],
                                  border: Border.all(color: Colors.grey)),
                              child: TextFormField(
                                controller: _noteController,
                                style: TextStyle(
                                    fontSize: 14.0, fontFamily: 'RobotoSlab'),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '',
                                  hintStyle: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 14,
                                      fontFamily: 'RobotoSlab'),
                                  contentPadding: EdgeInsets.only(
                                      top: 0.0,
                                      bottom: 0.0,
                                      left: 20,
                                      right: 20),
                                ),
                                enabled: true,
                                maxLines: 8,
                              ),
                            ),
                            SizedBox(height: 20),
                            SizedBox(
                              height: 40,
                              width: double.infinity,
                              child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Colors.yellow[700],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: FlatButton(
                                    onPressed: () {
                                      if (_userNameController.text.trim() !=
                                              '' &&
                                          _userNameController.text != null) {
                                        if (_phoneNumbController.text.trim() !=
                                                '' &&
                                            _phoneNumbController.text != null) {
                                          if (_provinceController.text.trim() !=
                                                  '' &&
                                              _provinceController.text !=
                                                  null) {
                                            if (_districtController.text
                                                        .trim() !=
                                                    '' &&
                                                _districtController.text !=
                                                    null) {
                                              if (_wardController.text.trim() !=
                                                      '' &&
                                                  _wardController.text !=
                                                      null) {
                                                if (_streetController.text
                                                            .trim() !=
                                                        '' &&
                                                    _streetController.text !=
                                                        null) {
                                                  onStepContinue();
                                                } else {
                                                  showToast(
                                                      'Hãy nhập Địa chỉ nhà');
                                                }
                                              } else {
                                                showToast('Hãy nhập Phường xã');
                                              }
                                            } else {
                                              showToast('Hãy nhập Quận huyện');
                                            }
                                          } else {
                                            showToast('Hãy nhập Thành phố');
                                          }
                                        } else {
                                          showToast('Hãy nhập Số điện thoại');
                                        }
                                      } else {
                                        showToast('Hãy nhập Họ và tên');
                                      }
                                    },
                                    child: Center(
                                      child: new Text('TIẾP TỤC',
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              fontFamily: 'RobotoSlab',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[800])),
                                    ),
                                  )),
                            )
                          ],
                        ));
                      } else {
                        return Container(height: 0.0, width: 0.0);
                      }
                    });
              } else {
                return new Container(height: 0.0, width: 0.0);
              }
            }));
  }

  Widget _showPaymentScreen() {
    return Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Text('PHƯƠNG THỨC THANH TOÁN',
              style: TextStyle(
                  fontFamily: 'RobotoSlab',
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold)),
          Divider(
            thickness: 1,
          ),
          SizedBox(height: 10),
          CustomRadioButton(
            elevation: 0,
            enableShape: true,
            horizontal: true,
            buttonColor: Theme.of(context).canvasColor,
            buttonLables: [
              "Giao hàng và thu tiền tận nơi",
              "Thanh toán qua ví điện tử Momo",
            ],
            buttonValues: [
              "Giao hàng và thu tiền tận nơi",
              "Thanh toán qua ví điện tử Momo",
            ],
            radioButtonValue: (value) {
              setState(() {
                paymentMethod = value;
              });
              print(value);
            },
            selectedColor: Theme.of(context).accentColor,
          ),
          SizedBox(height: 20),
          Text('GIẢM GIÁ',
              style: TextStyle(
                  fontFamily: 'RobotoSlab',
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold)),
          Divider(
            thickness: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 33,
                width: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey[200],
                ),
                child: TextFormField(
                  controller: _saleController,
                  style: TextStyle(fontSize: 14.0, fontFamily: 'RobotoSlab'),
                  decoration: InputDecoration(
                      hintText: "Nhập mã giảm giá",
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
                          borderRadius: BorderRadius.circular(10.0))),
                  enabled: true,
                ),
              ),
              FlatButton(
                  onPressed: () async {
                    //Todo: Cancel
                    await _getBookInCart();
                    DateTime time = await NTP.now();
                    PromoCodeModel docExist = await crudPromoCode
                        .getPromoCodeModelById(_saleController.text.trim());

                    if (docExist != null) {
                      DateTime tempDate = new DateFormat("yyyy-MM-dd hh:mm:ss")
                          .parse(docExist.expirationDate);
                      if (docExist.codeStatus == true) {
                        if (docExist.amountCondition < _tongTien) {
                          if (time.isBefore(tempDate)) {
                            setState(() {
                              _voucher = "Áp dụng mã giảm giá thành công.";
                              promocode = docExist;
                              _discountAmount =
                                  promocode.amountDiscount.toDouble();
                            });
                            print("Áp dụng mã giảm giá thành công.");

                            _isPromo = true;
                          } else {
                            setState(() {
                              _voucher = "Mã giãm giá hết hạn.";
                            });
                            print("Mã giãm giá hết hạn.");
                          }
                        } else {
                          setState(() {
                            _voucher =
                                "Đơn hàng không đủ điều kiện áp dụng mã giảm giá.";
                          });
                          print(
                              "Đơn hàng không đủ điều kiện áp dụng mã giảm giá.");
                        }
                      } else {
                        setState(() {
                          _voucher = "Bạn đã sử dụng mã giảm giá này.";
                        });
                        print("Bạn đã sử dụng mã giảm giá này.");
                      }
                    } else {
                      setState(() {
                        _voucher = "Không tồn tại mã giảm giá này.";
                      });
                      print("Không tồn tại mã giảm giá này.");
                    }
                  },
                  child: Container(
                    height: 35.0,
                    width: 100.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).accentColor),
                    child: Center(
                      child: new Text('SỬ DỤNG',
                          style: TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'RobotoSlab',
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                  )),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(_voucher,
                style: TextStyle(
                    fontFamily: 'RobotoSlab', fontSize: 15, color: Colors.red)),
          ),
          Divider(
            thickness: 1,
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                  onPressed: () {
                    //Todo: Cancel
                    onStepCancel();
                  },
                  child: Container(
                    height: 40.0,
                    width: 125.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.yellow[700]),
                    child: Center(
                      child: new Text('QUAY LẠI',
                          style: TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'RobotoSlab',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800])),
                    ),
                  )),
              FlatButton(
                  onPressed: () {
                    //Todo: Continues
                    if (paymentMethod != '') {
                      onStepContinue();
                    } else {
                      showToast('Hãy chọn phương thức thanh toán');
                    }
                  },
                  child: Container(
                    height: 40.0,
                    width: 125.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.yellow[700]),
                    child: Center(
                      child: new Text('TIẾP TỤC',
                          style: TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'RobotoSlab',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800])),
                    ),
                  )),
            ],
          )
        ]));
  }

  Widget _showConfirmScreen() {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('THÔNG TIN GIAO HÀNG',
            style: TextStyle(
                fontFamily: 'RobotoSlab',
                fontSize: 18.0,
                fontWeight: FontWeight.bold)),
        Divider(
          thickness: 1,
        ),
        SizedBox(height: 5),
        Text('${_userNameController.text}, ${_phoneNumbController.text}',
            style: TextStyle(fontFamily: 'RobotoSlab')),
        Text(
            '${_streetController.text}, Phường ${_wardController.text}, Quận ${_districtController.text}, Thành phố/Tỉnh ${_provinceController.text}',
            style: TextStyle(fontFamily: 'RobotoSlab')),
        SizedBox(height: 10),
        Text('THÔNG TIN THANH TOÁN',
            style: TextStyle(
                fontFamily: 'RobotoSlab',
                fontSize: 18.0,
                fontWeight: FontWeight.bold)),
        Divider(
          thickness: 1,
        ),
        SizedBox(height: 5),
        Text('${paymentMethod}', style: TextStyle(fontFamily: 'RobotoSlab')),
        SizedBox(height: 10),
        Text('SẢN PHẨM',
            style: TextStyle(
                fontFamily: 'RobotoSlab',
                fontSize: 18.0,
                fontWeight: FontWeight.bold)),
        Divider(
          thickness: 1,
        ),
        SizedBox(height: 10),
        FutureBuilder(
          future: _getBookInCart(),
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            if (snapshot.hasData) {
              return Column(children: [
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data.length - 1,
                    itemBuilder: (BuildContext context, int index) {
                      return new Container(
                          padding:
                              EdgeInsets.only(left: 0.0, top: 5.0, right: 5.0),
                          child: Column(
                            children: <Widget>[
                              new Row(children: [
                                CachedNetworkImage(
                                    imageUrl: snapshot.data[index]['biaSach'],
                                    height: 100,
                                    width: 70,
                                    fit: BoxFit.cover),
                                new Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                          padding: EdgeInsets.only(
                                              left: 10.0, bottom: 5.0),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.65,
                                          child: new Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                  snapshot.data[index]
                                                      ['tenSach'],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 3,
                                                  textAlign: TextAlign.justify,
                                                  style: TextStyle(
                                                    fontFamily: 'RobotoSlab',
                                                    fontSize: 14.0,
                                                  )))),
                                      Container(
                                          padding: EdgeInsets.only(
                                              left: 10.0, bottom: 5.0),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                          child: new Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                  '${snapshot.data[index]['giaTienDaGiam']} đ',
                                                  style: TextStyle(
                                                      fontFamily: 'RobotoSlab',
                                                      fontSize: 16.0,
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold)))),
                                      Container(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text(
                                              'Số lượng: ${_bookList2[index]['soLuongMua']}',
                                              style: TextStyle(
                                                  fontFamily: 'RobotoSlab')))
                                    ])
                              ]),
                              new Divider(
                                thickness: 1.0,
                              ),
                            ],
                          ));
                    }),
                Container(
                  color: Colors.grey[300],
                  child: new Column(
                    children: <Widget>[
                      Container(
                        color: Colors.grey[300],
                        padding: EdgeInsets.all(5.0),
                        child: Row(
                          children: <Widget>[
                            new Text('Tổng tạm tính:',
                                style: TextStyle(
                                    fontFamily: 'RobotoSlab', fontSize: 14.0)),
                            Expanded(
                                child: Container(
                              padding:
                                  EdgeInsets.only(bottom: 0.0, right: 15.0),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: new Text(
                                    '${_bookList2[_bookList2.length - 1]['tongTien']} đ',
                                    style: TextStyle(
                                        fontFamily: 'RobotoSlab',
                                        fontSize: 16.0,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.grey[300],
                  padding: EdgeInsets.all(5.0),
                  child: Row(
                    children: <Widget>[
                      new Text('Mã giảm giá:',
                          style: TextStyle(
                              fontFamily: 'RobotoSlab', fontSize: 14.0)),
                      Expanded(
                          child: Container(
                        padding:
                            EdgeInsets.only(top: 5.0, bottom: 0.0, right: 15.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: new Text(_discountAmount.toString() + ' đ',
                              style: TextStyle(
                                  fontFamily: 'RobotoSlab',
                                  fontSize: 16.0,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ))
                    ],
                  ),
                ),
                Container(
                  color: Colors.grey[300],
                  padding: EdgeInsets.all(5.0),
                  child: Row(
                    children: <Widget>[
                      new Text('Tổng tiền:',
                          style: TextStyle(
                              fontFamily: 'RobotoSlab', fontSize: 14.0)),
                      Expanded(
                          child: Container(
                        padding:
                            EdgeInsets.only(top: 5.0, bottom: 0.0, right: 15.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: new Text(
                              //ERR
                              '${_bookList2[_bookList2.length - 1]['tongTien'].toDouble() - _discountAmount} đ',
                              style: TextStyle(
                                  fontFamily: 'RobotoSlab',
                                  fontSize: 16.0,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ))
                    ],
                  ),
                ),
              ]);
            } else {
              return Center(
                  child: Text('Loading...',
                      style:
                          TextStyle(fontFamily: 'RobotoSlab', fontSize: 20.0)));
            }
          },
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
                onPressed: () {
                  //Todo: Cancel
                  onStepCancel();
                },
                child: Container(
                  height: 40.0,
                  width: 125.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.yellow[700]),
                  child: Center(
                    child: new Text('QUAY LẠI',
                        style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'RobotoSlab',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800])),
                  ),
                )),
            FlatButton(
                onPressed: () async {
                  //Todo: Continues
                  SharedPreferences _prefs =
                      await SharedPreferences.getInstance();
                  if (paymentMethod == 'Giao hàng và thu tiền tận nơi') {
                    try {
                      await _generateID();
                      _isBought = true;
                      print(newID);
                      reference = _db
                          .collection('UserCollection')
                          .document(_userEmail)
                          .collection('OrderCollection')
                          .document(newID)
                          .collection('BoughtBooksCollection');
                      DateTime time = await NTP.now();
                      print('time: $time');
                      OrderModel orderModel = new OrderModel(
                          maDonHang: newID,
                          ngayDatHang: time.toString(),
                          phuongThucThanhToan: paymentMethod,
                          trangThai: 'Đã tiếp nhận',
                          giamGia: _discountAmount,
                          tenNguoiMua: _userNameController.text,
                          tongTien: _tongTien - _discountAmount,
                          maGiamGia: _saleController.text,
                          diaChiGiaoHang:
                              '${_streetController.text}, ${_wardController.text}, ${_districtController.text}, ${_provinceController.text}',
                          soDienThoai: _phoneNumbController.text,
                          ghiChu: _noteController.text,
                          soLuongMua: _soLuong,
                          tamTinh: (_tongTien - 0.0).toDouble());
                      await crudOrder.addOrderModel(orderModel, newID);
                      CRUDOrderAdmin crudOrderAdmin = new CRUDOrderAdmin();
                      OrderAdminModel orderAdminModel = new OrderAdminModel(
                          idOrder: newID, idUser: _userEmail);
                      await crudOrderAdmin.addOrderAdminModel(
                          orderAdminModel, newID);
                      //var last = _bookList2.last();
                      _bookList2.removeAt(_bookList2.length - 1);
                      _bookList2.forEach((obj) async {
                        await reference.add(obj);
                        // if (obj != last) {
                        //   await reference.add(obj);
                        // }
                      });
                      if (_isPromo == true) {
                        crudPromoCode.updatePromoCodeModel(promocode.valueCode,
                            fieldName: 'codeStatus', fieldValue: false);
                      }
                      _bookList2.forEach((obj) async {
                        CRUDBook crudBook = new CRUDBook(obj['idDM']);
                        BookModel _bo =
                            await crudBook.getBookByTitleBook(obj['tenSach']);
                        await crudBook.updateBook(obj['tenSach'],
                            fieldName: 'soLuong',
                            fieldValue: _bo.soLuong - obj['soLuongMua']);
                        if ((_bo.soLuong - obj['soLuongMua']) <= 0) {
                          await crudBook.updateBook(obj['tenSach'],
                              fieldName: 'trangThai', fieldValue: false);
                        }
                        // if (obj != last) {
                        //   CRUDBook crudBook = new CRUDBook(obj['idDM']);
                        //   BookModel _bo =
                        //       await crudBook.getBookByTitleBook(obj['tenSach']);
                        //   await crudBook.updateBook(obj['tenSach'],
                        //       fieldName: 'soLuong',
                        //       fieldValue: _bo.soLuong - obj['soLuongMua']);
                        // }
                      });

                      _showDialog('Đã đặt hàng thành công. Tiếp tục mua hàng?');
                    } catch (e) {
                      print(e.toString());
                      _isBought = false;
                      _showDialog('Lỗi mua hàng. Hãy thử lại!');
                    }
                    // Navigator.pushReplacement(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => CheckOutComplete()));
                  } else {
                    try {
                      await _generateID();
                      _isBought = true;
                      MomoPaymentData momoPaymentData = MomoPaymentData(
                          appScheme: "momoldwm20200321",
                          merchantname: 'Lollipop Book',
                          merchantcode: 'MOMOLDWM20200321',
                          amount: _bookList2[_bookList2.length - 1]
                                  ['tongTien'] -
                              _discountAmount,
                          orderId: newID,
                          orderLabel: 'Mã đơn hàng',
                          merchantnamelabel: "Nhà cung cấp",
                          fee: 0,
                          description: 'Thanh toán đơn hàng sách',
                          requestId: '10',
                          partnerCode: 'MOMOLDWM20200321',
                          isDevelopmentMode: true);

                      MomoPaymentResult momoPaymentResult =
                          await MomoPaymentPlugin()
                              .requestPayment(momoPaymentData);
                      if (momoPaymentResult.isSuccess == true) {
                        reference = _db
                            .collection('UserCollection')
                            .document(_userEmail)
                            .collection('OrderCollection')
                            .document(newID)
                            .collection('BoughtBooksCollection');
                        DateTime time = await NTP.now();
                        print('time: $time');
                        OrderModel orderModel = new OrderModel(
                            maDonHang: newID,
                            ngayDatHang: time.toString(),
                            phuongThucThanhToan: paymentMethod,
                            trangThai: 'Đã tiếp nhận',
                            giamGia: _discountAmount,
                            tenNguoiMua: _userNameController.text,
                            tongTien: _tongTien - _discountAmount,
                            maGiamGia: _saleController.text,
                            diaChiGiaoHang:
                                '${_streetController.text}, ${_wardController.text}, ${_districtController.text}, ${_provinceController.text}',
                            soDienThoai: _phoneNumbController.text,
                            ghiChu: _noteController.text,
                            soLuongMua: _soLuong,
                            tamTinh: (_tongTien).toDouble());
                        await crudOrder.addOrderModel(orderModel, newID);
                        CRUDOrderAdmin crudOrderAdmin = new CRUDOrderAdmin();
                        OrderAdminModel orderAdminModel = new OrderAdminModel(
                            idOrder: newID, idUser: _userEmail);
                        await crudOrderAdmin.addOrderAdminModel(
                            orderAdminModel, newID);
                        _bookList2.removeAt(_bookList2.length - 1);
                        _bookList2.forEach((obj) async {
                          await reference.add(obj);
                          _showDialog(
                              'Đã đặt hàng thành công. Tiếp tục mua hàng?');
                        });
                        if (_isPromo == true) {
                          crudPromoCode.updatePromoCodeModel(
                              promocode.valueCode,
                              fieldName: 'codeStatus',
                              fieldValue: false);
                        }
                        _bookList2.forEach((obj) async {
                          CRUDBook crudBook = new CRUDBook(obj['idDM']);
                          BookModel _bo =
                              await crudBook.getBookByTitleBook(obj['tenSach']);
                          await crudBook.updateBook(obj['tenSach'],
                              fieldName: 'soLuong',
                              fieldValue: _bo.soLuong - obj['soLuongMua']);
                          if ((_bo.soLuong - obj['soLuongMua']) <= 0) {
                            await crudBook.updateBook(obj['tenSach'],
                                fieldName: 'trangThai', fieldValue: false);
                          }
                          // if (obj != last) {
                          //   CRUDBook crudBook = new CRUDBook(obj['idDM']);
                          //   BookModel _bo =
                          //       await crudBook.getBookByTitleBook(obj['tenSach']);
                          //   await crudBook.updateBook(obj['tenSach'],
                          //       fieldName: 'soLuong',
                          //       fieldValue: _bo.soLuong - obj['soLuongMua']);
                          // }
                        });
                      } else {
                        _isBought = false;
                        _showDialog('Lỗi thanh toán. Hãy thử lại!');
                      }
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => MomoCheckOut()));

                    } catch (e) {
                      print(e.toString());
                      _showDialog('Lỗi mua hàng. Hãy thử lại!');
                    }
                  }
                },
                child: Container(
                  height: 40.0,
                  width: 125.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.yellow[700]),
                  child: Center(
                    child: new Text('XÁC NHẬN',
                        style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'RobotoSlab',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800])),
                  ),
                )),
          ],
        )
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.amber[700],
        title: new Text(title, style: TextStyle(fontFamily: 'RobotoSlab')),
      ),
      body: Stepper(
        steps: _mySteps(),
        type: StepperType.horizontal,
        currentStep: this._currentStep,
        controlsBuilder: (BuildContext context,
                {VoidCallback onStepContinue, VoidCallback onStepCancel}) =>
            Container(),
      ),
    );
  }

  List<Step> _mySteps() {
    List<Step> _steps = [
      Step(
        title: Text('Địa chỉ', style: TextStyle(fontFamily: 'RobotoSlab')),
        content: _showDiaChiScreen(),
        isActive: _currentStep >= 0,
      ),
      Step(
        title: Text('Thanh toán', style: TextStyle(fontFamily: 'RobotoSlab')),
        content: _showPaymentScreen(),
        isActive: _currentStep >= 1,
      ),
      Step(
        title: Text('Xác nhận', style: TextStyle(fontFamily: 'RobotoSlab')),
        content: _showConfirmScreen(),
        isActive: _currentStep >= 2,
      )
    ];
    return _steps;
  }
}
