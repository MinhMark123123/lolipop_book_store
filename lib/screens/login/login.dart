import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lolipop_book_store/screens/otp_verification/otp_verification.dart';
import 'package:lolipop_book_store/screens/register/register.dart';
import 'package:lolipop_book_store/widgets/button/customButton.dart';
import 'package:lolipop_book_store/screens/login/Widgets/text.dart';
import 'package:lolipop_book_store/screens/login/Widgets/buttonSocial.dart';
import 'package:lolipop_book_store/main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:lolipop_book_store/screens/change_password/change_password.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../viewmodels/CRUDUser.dart';
import '../../models/userModel.dart';
import 'package:http/http.dart' as http;
import 'package:keyboard_dismisser/keyboard_dismisser.dart';

enum LoginStatus { EmailPassword, Google, Facebook }

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  final _formKey = new GlobalKey<FormState>();
  CRUDUser crudUser = new CRUDUser();
  String _email;
  String _password;
  String _errorMessage;
  bool _obscureText;
  bool _isLoading;
  TextEditingController _emailController = new TextEditingController();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    _errorMessage = "";
    _isLoading = false;
    _obscureText = true;
    super.initState();
  }

  //**================================================================================
  //* CÁC FUNCTION
  //*=================================================================================

  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0))),
          title: new Text("Quên mật khẩu",
              style: TextStyle(
                  fontFamily: 'RobotoSlab',
                  color: Colors.amberAccent[800],
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
          content: Container(
            height: 60,
            child: Column(children: [
              new Text("Hãy nhập email của bạn để đổi mật khẩu",
                  style: TextStyle(fontFamily: 'RobotoSlab', fontSize: 14)),
              Container(
                padding: EdgeInsets.only(top: 10),
                height: 40,
                width: 270,
                child: new TextFormField(
                  controller: _emailController,
                  decoration: new InputDecoration(
                    labelText: "abc@gmail.com",
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(),
                    ),
                    //fillColor: Colors.green
                  ),
                  validator: (val) {
                    if (val.length == 0) {
                      return "Email cannot be empty";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.emailAddress,
                  style: new TextStyle(
                    fontFamily: "RobotoSlab",
                  ),
                ),
              ),
            ]),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog

            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Xác nhận"),
              onPressed: () async {
                await resetPassword(_emailController.text);
                showToast(
                    "Một thư đã được gửi đến email của bạn. Vui lòng kiểm tra để đổi mật khẩu");
              },
            ),
          ],
        );
      },
    );
  }

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

  //Todo: Lưu loại đăng nhập vào local
  void saveLoginStatus(status, userEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('LoginStatus', status);
    await prefs.setString('userEmail', userEmail);
  }

  //Todo: Add user lên Firestore khi login bằng Facebook và Google
  addUserSignUp(_email, _userName, _soDienThoai, _imageURL) async {
    User user = await crudUser.getUserById(_email);
    if (user == null) {
      await crudUser.addUser(
          User(
              email: _email.trim(),
              gioiTinh: false,
              imageURL: _imageURL,
              userName: _userName.trim(),
              role: 'User',
              ngaySinh: '',
              soDienThoai: _soDienThoai,
              soSachDaMua: 0,
              diaChi: '',
              verification: 'false'),
          _email.trim());
    }
  }

  Future<FirebaseUser> signIn(
      String _email, String _password, BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      FirebaseUser user = (await auth
              .signInWithEmailAndPassword(email: _email, password: _password)
              .catchError((e) {
        showToast(e.code);
        print(e.message);
        setState(() {
          _isLoading = false;
        });
      }))
          .user;

      if (user != null) {
        User user2 = await crudUser.getUserById(user.email);
        if (user2.verification == 'false') {
          setState(() {
            _isLoading = false;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  OTPVerification(currentUser: user, user: user2),
            ),
          );
        } else {
          setState(() {
            _isLoading = false;
          });
          saveLoginStatus(LoginStatus.EmailPassword.toString(), _email);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyApp(),
            ),
          );
        }
      } else {
        print("No user");
      }
      return user;
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error: $e");
      return null;
    }
  }

  Future facebookSignIn() async {
    var facebookLogin = new FacebookLogin();
    FirebaseAuth auth = FirebaseAuth.instance;
    facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
    var facebookLoginResult =
        await facebookLogin.logInWithReadPermissions(['email']);
    final accessToken = facebookLoginResult.accessToken.token;
    print('accessToken' + accessToken);
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        print("Error");
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("CancelledByUser");
        break;
      case FacebookLoginStatus.loggedIn:
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,picture.width(800).height(800),first_name,last_name,email&access_token=${accessToken}');
        final profile = json.decode(graphResponse.body);
        final facebookAuthCred =
            FacebookAuthProvider.getCredential(accessToken: accessToken);
        final user = await auth
            .signInWithCredential(facebookAuthCred)
            .whenComplete(() {})
            .catchError((onError) {
          showToast(onError.code);
        });
        if (user.user != null) {
          try {
            await addUserSignUp(profile['email'], profile['name'], '',
                profile['picture']['data']['url']);
          } catch (e) {
            print('Error: $e.message');
          }
          User user2 = await crudUser.getUserById(user.user.email);
          if (user2.verification == 'false') {
            setState(() {
              _isLoading = false;
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OTPVerification(
                    currentUser: user.user,
                    user: user2,
                    loginStatus: LoginStatus.Facebook.toString()),
              ),
            );
          } else {
            setState(() {
              _isLoading = false;
            });
            saveLoginStatus(LoginStatus.Facebook.toString(), user.user.email);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyApp(),
              ),
            );
          }
          print("LoggedIn - User: ${user.user.displayName}");
          break;
        }
    }
  }

  Future<FirebaseUser> googleSignin(BuildContext context) async {
    FirebaseUser currentUser;
    FirebaseAuth auth = FirebaseAuth.instance;
    GoogleSignIn googleSignIn = new GoogleSignIn();
    try {
      final GoogleSignInAccount googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final FirebaseUser user =
          (await auth.signInWithCredential(credential)).user;
      if (user != null) {
        try {
          await addUserSignUp(user.email, user.displayName, '', user.photoUrl);
        } catch (e) {
          print('Error: $e.message');
        }
        User user2 = await crudUser.getUserById(user.email);
        if (user2.verification == 'false') {
          setState(() {
            _isLoading = false;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPVerification(
                  currentUser: user,
                  user: user2,
                  loginStatus: LoginStatus.Google.toString()),
            ),
          );
        } else {
          setState(() {
            _isLoading = false;
          });
          saveLoginStatus(LoginStatus.Google.toString(), user.email);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyApp(),
            ),
          );
        }
      }
      currentUser = await auth.currentUser();
      print(currentUser);
      print("User Name : ${currentUser.displayName}");
    } catch (e) {
      return currentUser;
    }
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

  //Todo: Reset Form
  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  //Todo: Xử lý Đăng nhập
  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      try {
        print("Sign In.");
        signIn(_email, _password, context);
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

  //**================================================================================
  //* LIST CÁC WIDGET LOGIN SCREEN
  //*=================================================================================
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

  //Todo: Hiển thị TextFormField Account
  Widget showAccountInput() {
    return new TextFormField(
        style: new TextStyle(
          color: Colors.black,
          fontFamily: 'RobotoSlab',
        ),
        onTap: () {
          resetForm();
        },
        decoration: InputDecoration(
            labelText: 'Tài khoản',
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
              Icons.account_circle,
              color: Colors.grey[800],
              size: 30.0,
            ),
            contentPadding: new EdgeInsets.symmetric(vertical: 8.0),
            border: UnderlineInputBorder(borderSide: BorderSide.none)),
        maxLines: 1,
        autofocus: false,
        validator: (value) {
          if (value.isEmpty) {
            return 'Tài khoản không được bỏ trống.';
          }
          if (EmailValidator.validate(value.trim()) == false) {
            return 'Email không khả dụng.';
          }
        },
        onSaved: (value) => _email = value.trim());
  }

  //Todo: Hiển thị TextFormField Password
  Widget showPasswordInput() {
    return new TextFormField(
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
              icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey),
              onPressed: _toggle),
          contentPadding: new EdgeInsets.symmetric(vertical: 8.0),
          border: UnderlineInputBorder(borderSide: BorderSide.none)),
      obscureText: _obscureText,
      maxLines: 1,
      autofocus: false,
      validator: (value) {
        if (value.isEmpty) {
          return 'Mật khẩu không được bỏ trống.';
        }
        if (value.length < 8) {
          return 'Mật khẩu chứa ít nhất 8 ký tự.';
        }
      },
      onSaved: (value) => _password = value.trim(),
    );
  }

  //Todo: Hiển thị Divider
  Widget showDivider() {
    return new Divider(
      color: Colors.grey[500],
    );
  }

  //Todo: Hiển thị Text và Checkbox Lưu mật khẩu
  Widget savePassword() {
    return Expanded(
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Checkbox(
            value: false,
            checkColor: Colors.blue, // color of tick Mark
            activeColor: Colors.green,
            onChanged: null,
          ),
          new Text(
            'Lưu đăng nhập',
            style: TextStyle(
              color: Colors.black,
              fontSize: 15.0,
              fontFamily: 'RobotoSlab',
            ),
          ),
        ],
      ),
    );
  }

  //Todo: Hiển thị Text Quên Mật Khẩu?
  Widget forgot_password() {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        new InkWell(
          child: new Text(
            'Quên mật khẩu?',
            style: TextStyle(
                color: Colors.black, fontFamily: 'RobotoSlab', fontSize: 15.0),
          ),
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => ChangePassword(),
            //   ),
            // );
            _showDialog();
          },
        )
      ],
    );
  }

  //Todo: Hiển thị tiêu đề trang ĐĂNG NHẬP
  Widget showTitle() {
    return Padding(
        padding: const EdgeInsets.only(top: 60.0, bottom: 20.0),
        child: Column(
          children: <Widget>[
            Text(
              'ĐĂNG NHẬP',
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

  //Todo: Hiển thị Button Đăng Nhập
  Widget showCustomButton() {
    return new CustomButton(
      label: "Đăng Nhập",
      background: Colors.amber[700],
      fontColor: Colors.white,
      borderColor: Colors.amber[700],
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        validateAndSubmit();
      },
    );
  }

  //Todo: Hiển thị Text Bạn không có tài khoản
  Widget showText() {
    return new Text(
      'Bạn không có tài khoản?',
      style: TextStyle(
        color: Colors.black,
        fontFamily: 'RobotoSlab',
      ),
    );
  }

  //Todo: Hiển thị InkWell Đăng ký
  Widget showInkwellLoginNow() {
    return InkWell(
      child: Text(' Đăng ký ngay.',
          style: TextStyle(
            color: Colors.amber[400],
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoSlab',
          )),
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Register(),
          ),
        );
      },
    );
  }

  //Todo: Đăng nhập với Facebook
  Widget loginFacebook() {
    return buildSocialBtn(
        () => facebookSignIn(),
        AssetImage(
          'images/logo/logoFacebook.jpg',
        ),
        Colors.white);
  }

  //Todo: Đăng nhập với Google
  Widget loginGoogle() {
    return buildSocialBtn(
        () => googleSignin(context),
        AssetImage(
          'images/logo/logoGoogle.png',
        ),
        Colors.white);
  }

  //Todo: Hiển thị Form Login
  Widget showLoginScreen() {
    return new Form(
        key: _formKey,
        child: KeyboardDismisser(
          child: SingleChildScrollView(
              child: new Container(
            padding: EdgeInsets.only(top: 25.0, left: 30.0, right: 30.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                showTitle(),
                showAccountInput(),
                showDivider(),
                showPasswordInput(),
                showDivider(),
                new SizedBox(
                  height: 5.0,
                ),
                new Row(
                  children: <Widget>[
                    //Todo: Lưu mật khẩu
                    savePassword(),
                    //Todo: Quên mật khẩu
                    forgot_password()
                  ],
                ),
                new SizedBox(
                  height: 20.0,
                ),
                //Todo: Button Đăng Nhập
                showCustomButton(),
                showErrorMessage(),
                textSocial,
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      //Todo: Login Facebook
                      loginFacebook(),
                      //Todo: Login Google
                      loginGoogle()
                    ],
                  ),
                ),
                new SizedBox(
                  height: 15.0,
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    //Todo: Hiển thị Text
                    showText(),
                    //Todo: Hiển thị InkWell Đăng ký ngay
                    showInkwellLoginNow()
                  ],
                )
              ],
            ),
          )),
        ));
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        body: Stack(
            children: <Widget>[showLoginScreen(), showCircularProgress()]));
  }
}
