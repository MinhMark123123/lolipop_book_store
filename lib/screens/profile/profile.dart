import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lolipop_book_store/screens/login/login.dart';
import 'package:lolipop_book_store/screens/profile/Widgets/profileSelected.dart';
import 'package:lolipop_book_store/screens/info_user/info_user.dart';
import 'package:lolipop_book_store/screens/user_address/user_address.dart';
import 'package:lolipop_book_store/screens/order_management/order_management.dart';
import 'package:lolipop_book_store/screens/welcome/welcome.dart';
import 'package:lolipop_book_store/viewmodels/CRUDUser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

import '../../main.dart';

enum LoginStatus { EmailPassword, Google, Facebook }

class Profile extends StatefulWidget {
  Profile();
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ProfileState();
  }
}

class ProfileState extends State<Profile> {
  //Todo: Lưu loại đăng nhập vào local
  void saveLoginStatus(status, userEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('bookListCart');
    await prefs.setString('LoginStatus', status);
    await prefs.setString('userEmail', userEmail);
  }

  get crudUser => null;
  Future<String> _getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _userEmail = prefs.getString('userEmail');

    if (_userEmail != null) {
      print('User email: ' + _userEmail);

      return _userEmail;
    } else
      return '';
  }

  @override
  Widget build(BuildContext context) {
    CRUDUser crudUser = new CRUDUser();
    Future<bool> googleSignout() async {
      FirebaseAuth auth = FirebaseAuth.instance;
      GoogleSignIn googleSignIn = new GoogleSignIn();
      await auth.signOut();
      await googleSignIn.signOut();
      await saveLoginStatus('', '');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Welcome()));
      return true;
    }

    Future<bool> facebookLoginout() async {
      var facebookLogin = new FacebookLogin();
      FirebaseAuth auth = FirebaseAuth.instance;
      await auth.signOut();
      await facebookLogin.logOut();
      await saveLoginStatus('', '');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Welcome()));
      return true;
    }

    Future<bool> signOutEmailPassword() async {
      FirebaseAuth auth = FirebaseAuth.instance;
      await auth.signOut();
      await saveLoginStatus('', '');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Welcome()));
      return true;
    }

    void signOut() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String loginStatus = prefs.getString('LoginStatus');
      print('LoginStatus: $loginStatus');
      if (loginStatus == LoginStatus.EmailPassword.toString()) {
        signOutEmailPassword();
      }
      if (loginStatus == LoginStatus.Facebook.toString()) {
        facebookLoginout();
      }
      if (loginStatus == LoginStatus.Google.toString()) {
        googleSignout();
      }
    }

    var facebookLogin = new FacebookLogin();
    // TODO: implement build
    return FutureBuilder(
        future: _getUserEmail(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData && snapshot.data != '') {
            return new StreamBuilder(
                stream: crudUser.fetchOneUserAsStream(snapshot.data),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshotStream) {
                  if (snapshotStream.hasData) {
                    return new Scaffold(
                        body: SingleChildScrollView(
                      child: new Container(
                        child: new Column(
                          children: <Widget>[
                            new Container(
                                height: 170.0,
                                child: Stack(children: [
                                  new Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              snapshotStream.data['imageURL']),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      child: BlurHash(
                                        hash: "LISp{vr=B@\$z%FV|t8of9QV@JWs8",
                                      )),
                                  Center(
                                    child: Column(
                                      children: <Widget>[
                                        new Container(
                                          margin: EdgeInsets.only(top: 35.0),
                                          child: new CircleAvatar(
                                            radius: 40.0,
                                            backgroundColor: Colors.white,
                                            backgroundImage: NetworkImage(
                                                snapshotStream
                                                    .data['imageURL']),
                                          ),
                                        ),
                                        new Padding(
                                          padding: EdgeInsets.only(top: 12.0),
                                        ),
                                        new Text(
                                          snapshotStream.data['userName'],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0,
                                              fontFamily: 'RobotoSlab'),
                                        )
                                      ],
                                    ),
                                  ),
                                ])),
                            new Padding(
                              padding: EdgeInsets.only(bottom: 8.0),
                            ),
                            new ProfileSelected(
                              label: "Thông tin cá nhân",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => InfoUser(
                                        idUser: snapshotStream.data['email']),
                                  ),
                                );
                              },
                            ),
                            // new ProfileSelected(
                            //   label: "Địa chỉ giao hàng",
                            //   onTap: () {
                            //     Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //         builder: (context) => UserAddress(),
                            //       ),
                            //     );
                            //   },
                            // ),
                            new ProfileSelected(
                              label: "Quản lý đơn hàng",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OrderManagement(
                                          idUser:
                                              snapshotStream.data['email'])),
                                );
                              },
                            ),
                            new ProfileSelected(
                              label: "Đăng xuất",
                              onTap: () {
                                signOut();
                              },
                            ),
                          ],
                        ),
                      ),
                    ));
                  } else {
                    return Container(height: 0.0, width: 0.0);
                  }
                });
          } else {
            return new Container(height: 0.0, width: 0.0);
          }
        });
  }
}
