import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_dropdown_formfield/material_dropdown_formfield.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lolipop_book_store/models/feedbackModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class FeedBack extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FeedBackState();
  }
}

class FeedBackState extends State<FeedBack> {
  String _myActivity;
  String _myActivityResult;
  final formKey = new GlobalKey<FormState>();

  String content;
  final TextEditingController _multilineTextController =
      new TextEditingController();

  List dataSource = [
    {
      "display": "Lỗi Thanh Toán Online",
      "value": "errorThanhToanOnline",
    },
    {
      "display": "Lỗi Giỏ Hàng",
      "value": "errorGioHang",
    },
    {
      "display": "Lỗi Hiển Thị",
      "value": "errorHienThi",
    },
    {
      "display": "Sản phẩm lỗi",
      "value": "errorSanPham",
    },
    {
      "display": "Những lỗi khác",
      "value": "errorLoiKhac",
    },
  ];

  @override
  void initState() {
    super.initState();
    _myActivity = '';
    _myActivityResult = '';
  }

  _saveForm() {
    var form = formKey.currentState;
    if (form.validate()) {
      setState(() {
        _myActivityResult = _myActivity;
      });
    }
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

  getLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool login = prefs.containsKey('LoginStatus');
    if (login == false)
      return login;
    else {
      String loginStatus = prefs.get('LoginStatus');
      if (loginStatus != '')
        login = true;
      else
        login = false;
    }
    return login;
  }

  void showToast(message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        textColor: Colors.white,
        fontSize: 15.0);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
        child: KeyboardDismisser(
      child: Scaffold(
          appBar: AppBar(
            leading: new IconButton(
              icon: new Icon(
                Icons.arrow_back,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: new Text('Góp ý và báo lỗi',
                style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.amber[700],
          ),
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                children: <Widget>[
                  Center(
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(16),
                            child: DropDownFormField(
                              inputDecoration: OutlinedDropDownDecoration(
                                  labelText: "Lỗi của ứng dụng"),
                              hintText: 'Hãy chọn lỗi bạn đang gặp',
                              value: _myActivity,
                              onSaved: (value) {
                                setState(() {
                                  _myActivity = value;
                                });
                              },
                              onChanged: (value) {
                                setState(() {
                                  _myActivity = value;
                                });
                              },
                              dataSource: dataSource,
                              textField: 'display',
                              valueField: 'value',
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0))),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    TextField(
                                      controller: _multilineTextController,
                                      maxLines: 20,
                                      decoration: InputDecoration(
                                          hintText: 'Mô tả chi tiết',
                                          hintStyle: TextStyle(
                                              fontFamily: 'RobotoSlab'),
                                          border: UnderlineInputBorder(
                                              borderSide: BorderSide.none)),
                                      onChanged: (str) => content = str,
                                      //onSubmitted: (str) => widget.content = str,
                                      onTap: () => print('Tap tap tap'),
                                    ),
                                    SizedBox(height: 10.0),
                                  ],
                                ),
                              )),
                          FlatButton(
                              onPressed: () async {
                                String userName = await _getUserEmail();
                                _saveForm();
                                if (getLoginStatus() != null) {
                                  if (_myActivityResult == '' &&
                                      _multilineTextController.text != '') {
                                    showToast('Xin hãy chọn một lỗi cụ thể');
                                  } else if (_myActivityResult != '' &&
                                      _multilineTextController.text == '') {
                                    showToast('Xin hãy mô tả chi tiết về lỗi');
                                  } else if (_myActivityResult == '' &&
                                      _multilineTextController.text == '') {
                                    showToast('Xin hãy điền đủ thông tin');
                                  } else if (_myActivityResult != '' &&
                                      _multilineTextController.text != '') {
                                    FeedbackModel feedbackModel = FeedbackModel(
                                        emailNguoiDung: userName,
                                        noiDungPhanHoi: content,
                                        thoiGianPhanHoi: (new DateFormat(
                                                    "dd-MM-yyyy hh:mm:ss")
                                                .format(DateTime.now()))
                                            .toString());
                                    Firestore.instance
                                        .collection('FeedbackCollection')
                                        .document(_myActivityResult)
                                        .collection('FeedbackDetailCollection')
                                        .document(
                                            '$userName ${(new DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now())).toString()}')
                                        .setData(feedbackModel.toJson());
                                    print('${userName} đã gửi  feedback');
                                    showToast(
                                        'Cảm ơn bạn đã gửi phản hồi cho chúng tôi');
                                    Navigator.of(context).pop();
                                  }
                                }
                              },
                              child: Container(
                                height: 50.0,
                                width: 360.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.amber[700]),
                                child: Center(
                                  child: new Text('Gửi phản hồi',
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontFamily: 'RobotoSlab',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[800])),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    ));
  }
}
