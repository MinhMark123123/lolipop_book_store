import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lolipop_book_store/screens/login/login.dart';
import 'package:lolipop_book_store/widgets/button/customButton.dart';
import '../../viewmodels/CRUDUser.dart';
import '../../models/userModel.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RegisterState();
  }
}

class RegisterState extends State<Register> {
  final _formKey = new GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  String _email;
  String _password;
  String _repeatPassword;
  String _userName;
  String _soDienThoai;
  String _errorMessage;
  bool _obscureText;
  bool _isLoading;
  CRUDUser crudUser = CRUDUser();
  @override
  void initState() {
    _errorMessage = '';
    _isLoading = false;
    _obscureText = false;
    super.initState();
  }

  //* CÁC FUNCTION
  //*=================================================================================
  //Todo: Show Toast
  void showToast(message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        textColor: Colors.white,
        fontSize: 15.0);
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  //Todo: Reset Form
  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  //Todo: Kiểm tra các TextFormField trước khi Đăng Nhập
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  //Todo: Xử lý Đăng nhập
  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      try {
        print("Sign Up.");
        signUp(_email, _password);
        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<FirebaseUser> signUp(email, password) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      FirebaseUser user = (await auth.createUserWithEmailAndPassword(
              email: _email, password: _password))
          .user;
      assert(user != null);
      assert(await user.getIdToken() != null);
      if (user != null) {
        addUserSignUp();
      }
      return user;
    } catch (e) {
      return null;
    }
  }

  addUserSignUp() async {
    await crudUser
        .addUser(
            User(
                email: _email,
                gioiTinh: false,
                imageURL:
                    'https://firebasestorage.googleapis.com/v0/b/lollipopbookstore.appspot.com/o/BiaSach%2Favatar%2Favatar.png?alt=media&token=0c4ac3c6-433b-44ec-9254-e2ebc1909f80',
                userName: _userName,
                role: 'User',
                ngaySinh: '',
                soDienThoai: _soDienThoai,
                soSachDaMua: 0,
                diaChi: '',
                verification: 'false'),
            _email)
        .whenComplete(() async {
      showToast('Bạn đã đăng ký thành công, hãy đăng nhập để sử dụng.');
      await Future.delayed(const Duration(seconds: 1));
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    });
  }

  //Todo: Hiển thị lỗi
  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  //**================================================================================
  //* LIST CÁC WIDGET LOGIN SCREEN
  //*=================================================================================
  //Todo: Hiển thị tên màn hình Đăng ký
  Widget showSignUpTitle() {
    return Padding(
        padding: const EdgeInsets.only(top: 60.0, bottom: 20.0),
        child: Column(
          children: <Widget>[
            Text(
              'ĐĂNG KÝ',
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                color: Colors.amber[700],
                fontFamily: 'RobotoSlab',
              ),
            ),
          ],
        ));
  }

  Widget showUserName() {
    return new TextFormField(
        style: new TextStyle(
          color: Colors.black,
          fontFamily: 'RobotoSlab',
        ),
        decoration: InputDecoration(
            labelText: 'Họ và Tên',
            hintText: 'Nguyễn Văn A',
            labelStyle: TextStyle(
              color: Colors.grey[600],
              fontSize: 16.0,
              fontFamily: 'RobotoSlab',
            ),
            hintStyle: TextStyle(
              color: Colors.grey[500],
              fontSize: 16.0,
              fontFamily: 'RobotoSlab',
            ),
            icon: Icon(
              Icons.account_circle,
              color: Colors.grey[800],
              size: 30.0,
            ),
            contentPadding: new EdgeInsets.symmetric(vertical: 8.0),
            border: UnderlineInputBorder(borderSide: BorderSide.none)),
        autofocus: false,
        validator: (value) {
          if (value.isEmpty) {
            return 'Họ và tên không được bỏ trống.';
          }
        },
        onSaved: (value) => _userName = value.trim());
  }

  Widget showDivider() {
    return new Divider(
      color: Colors.grey[500],
    );
  }

  Widget showEmail() {
    return new TextFormField(
        style: new TextStyle(
          color: Colors.black,
          fontFamily: 'RobotoSlab',
        ),
        decoration: InputDecoration(
            labelText: 'Email',
            hintText: 'abc@gmail.com',
            labelStyle: TextStyle(
              color: Colors.grey[600],
              fontSize: 16.0,
              fontFamily: 'RobotoSlab',
            ),
            hintStyle: TextStyle(
              color: Colors.grey[500],
              fontSize: 16.0,
              fontFamily: 'RobotoSlab',
            ),
            icon: Icon(
              Icons.mail,
              color: Colors.grey[800],
              size: 30.0,
            ),
            contentPadding: new EdgeInsets.symmetric(vertical: 8.0),
            border: UnderlineInputBorder(borderSide: BorderSide.none)),
        autofocus: false,
        validator: (value) {
          if (value.isEmpty) {
            return 'Email không được bỏ trống.';
          }
          if (EmailValidator.validate(value.trim()) == false) {
            return 'Email không khả dụng.';
          }
        },
        onSaved: (value) => _email = value.trim());
  }

  Widget showPhoneNumber() {
    return new TextFormField(
        style: new TextStyle(
          color: Colors.black,
          fontFamily: 'RobotoSlab',
        ),
        decoration: InputDecoration(
            labelText: 'Số điện thoại',
            hintText: '123456789',
            labelStyle: TextStyle(
              color: Colors.grey[600],
              fontSize: 16.0,
              fontFamily: 'RobotoSlab',
            ),
            hintStyle: TextStyle(
              color: Colors.grey[500],
              fontSize: 16.0,
              fontFamily: 'RobotoSlab',
            ),
            icon: Icon(
              Icons.phone_android,
              color: Colors.grey[800],
              size: 30.0,
            ),
            contentPadding: new EdgeInsets.symmetric(vertical: 8.0),
            border: UnderlineInputBorder(borderSide: BorderSide.none)),
        keyboardType: TextInputType.number,
        autofocus: false,
        validator: (value) {
          if (value.isEmpty) {
            return 'Số điện thoại không được bỏ trống.';
          }
          if (value.trim().length != 9) {
            return 'Số điện thoại không khả dụng.';
          }
        },
        onSaved: (value) => _soDienThoai = '+84' + value.trim());
  }

  Widget showPassword() {
    return new TextFormField(
        controller: _pass,
        style: new TextStyle(
          color: Colors.black,
          fontFamily: 'RobotoSlab',
        ),
        decoration: InputDecoration(
            labelText: 'Mật khẩu',
            hintText: '••••••••',
            labelStyle: TextStyle(
              color: Colors.grey[600],
              fontSize: 16.0,
              fontFamily: 'RobotoSlab',
            ),
            hintStyle: TextStyle(
              color: Colors.grey[500],
              fontSize: 16.0,
              fontFamily: 'RobotoSlab',
            ),
            icon: Icon(
              Icons.lock,
              color: Colors.grey[800],
              size: 30.0,
            ),
            suffixIcon: IconButton(
                icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey),
                onPressed: _toggle),
            contentPadding: new EdgeInsets.symmetric(vertical: 8.0),
            border: UnderlineInputBorder(borderSide: BorderSide.none)),
        obscureText: _obscureText,
        autofocus: false,
        validator: (value) {
          if (value.isEmpty) {
            return 'Mật khẩu không được bỏ trống.';
          }
          if (value.length < 8) {
            return 'Mật khẩu chứa ít nhất 8 ký tự.';
          }
        },
        onSaved: (value) => _password = value.trim());
  }

  Widget showRepeatPassword() {
    return new TextFormField(
        controller: _confirmPass,
        style: new TextStyle(
          color: Colors.black,
          fontFamily: 'RobotoSlab',
        ),
        decoration: InputDecoration(
            labelText: 'Xác nhận Mật khẩu',
            hintText: '••••••••',
            labelStyle: TextStyle(
              color: Colors.grey[600],
              fontSize: 16.0,
              fontFamily: 'RobotoSlab',
            ),
            hintStyle: TextStyle(
              color: Colors.grey[500],
              fontSize: 16.0,
              fontFamily: 'RobotoSlab',
            ),
            icon: Icon(
              Icons.lock,
              color: Colors.grey[800],
              size: 30.0,
            ),
            suffixIcon: IconButton(
                icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey),
                onPressed: _toggle),
            contentPadding: new EdgeInsets.symmetric(vertical: 8.0),
            border: UnderlineInputBorder(borderSide: BorderSide.none)),
        obscureText: _obscureText,
        autofocus: false,
        validator: (value) {
          if (value.isEmpty) {
            return 'Mật khẩu không được bỏ trống.';
          }
          if (value.length < 8) {
            return 'Mật khẩu chứa ít nhất 8 ký tự.';
          }
          if (value.trim() != _pass.text) {
            return 'Mật khẩu xác nhận không giống.';
          }
        },
        onSaved: (value) => _repeatPassword = value.trim());
  }

  Widget btnSignUp() {
    return new CustomButton(
      label: "Đăng Ký",
      background: Colors.amber[700],
      fontColor: Colors.white,
      borderColor: Colors.amber[700],
      onTap: () {
        validateAndSubmit();
      },
    );
  }

  Widget showLoginNow() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Text(
          'Bạn đã có tài khoản?',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'RobotoSlab',
          ),
        ),
        InkWell(
          child: Text(' Đăng nhập ngay.',
              style: TextStyle(
                color: Colors.amber[400],
                fontWeight: FontWeight.bold,
                fontFamily: 'RobotoSlab',
              )),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ),
            );
          },
        )
      ],
    );
  }

  //Todo: Hiển thị Circular Loading Progress
  Widget showCircularProgress() {
    if (_isLoading) {
      return Center(
          child: CircularProgressIndicator(
              valueColor:
                  new AlwaysStoppedAnimation<Color>(Colors.amber[800])));
    } else {
      return Container(width: 0.0, height: 0.0);
    }
  }

  Widget showSignUpScreen() {
    return new Form(
        key: _formKey,
        child: KeyboardDismisser(
          child: SingleChildScrollView(
              child: Container(
            padding: EdgeInsets.only(top: 15.0, left: 30.0, right: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                showSignUpTitle(),
                showUserName(),
                showDivider(),
                showEmail(),
                showDivider(),
                showPhoneNumber(),
                showDivider(),
                showPassword(),
                showDivider(),
                showRepeatPassword(),
                new SizedBox(
                  height: 20.0,
                ),
                btnSignUp(),
                showErrorMessage(),
                SizedBox(height: 20.0),
                Text(
                  '- Hoặc -',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'RobotoSlab',
                  ),
                ),
                new SizedBox(
                  height: 15.0,
                ),
                showLoginNow()
              ],
            ),
          )),
        ));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(children: [showSignUpScreen(), showCircularProgress()]));
  }
}
