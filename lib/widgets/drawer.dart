import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lolipop_book_store/screens/spin_wheel/spin_wheel.dart';
import 'package:lolipop_book_store/viewmodels/CRUDUser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lolipop_book_store/screens/feedback/feedback.dart';
import 'package:lolipop_book_store/screens/favoritebook/favoritebook.dart';
import 'package:lolipop_book_store/screens/promotional_code_list/promotional_code_list.dart';
import 'package:lolipop_book_store/screens/notification/notification.dart';

import 'package:animated_dialog_box/animated_dialog_box.dart';

class DrawerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DrawerWidgetState();
  }
}

class DrawerWidgetState extends State<DrawerWidget> {
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
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle listTileStyle =
        TextStyle(fontFamily: 'RobotoSlab', fontSize: 15.0);
    CRUDUser crudUser = new CRUDUser();
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
                    return new Drawer(
                      child: new ListView(
                        children: <Widget>[
                          new UserAccountsDrawerHeader(
                            accountName: Text(snapshotStream.data['userName'],
                                style: TextStyle(
                                    fontFamily: 'RobotoSlab',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0)),
                            accountEmail: Text(
                                'Email: ${snapshotStream.data['email']} ',
                                style: TextStyle(fontFamily: 'RobotoSlab')),
                            currentAccountPicture: GestureDetector(
                              child: new CircleAvatar(
                                backgroundImage: NetworkImage(
                                  snapshotStream.data['imageURL'],
                                ),
                              ),
                            ),
                            decoration:
                                new BoxDecoration(color: Colors.amber[700]),
                          ),
                          // InkWell(
                          //   child: ListTile(
                          //     title: Text(
                          //       'Vòng quay may mắn',
                          //       style: listTileStyle,
                          //     ),
                          //     leading: Image.asset('images/icon/iconwheel.png',
                          //         height: 28, width: 28),
                          //   ),
                          //   onTap: () {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder: (context) => SpinWheel(),
                          //       ),
                          //     );
                          //   },
                          // ),
                          InkWell(
                            child: ListTile(
                              title: Text(
                                'Thông báo',
                                style: listTileStyle,
                              ),
                              leading: new Icon(Icons.notifications,
                                  color: Colors.amber[700]),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NotificationScreen(),
                                ),
                              );
                            },
                          ),
                          InkWell(
                            child: ListTile(
                              title: Text(
                                'Yêu thích',
                                style: listTileStyle,
                              ),
                              leading: new Icon(Icons.favorite,
                                  color: Colors.pink[500]),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FavoriteBookScreen(
                                    email: snapshotStream.data['email'],
                                  ),
                                ),
                              );
                            },
                          ),
                          InkWell(
                            child: ListTile(
                              title: Text(
                                'Mã khuyến mãi',
                                style: listTileStyle,
                              ),
                              leading: Image.asset('images/icon/promo_code.png',
                                  height: 24, width: 24),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PromotionalCodeList(
                                    idUser: snapshotStream.data['email'],
                                  ),
                                ),
                              );
                            },
                          ),
                          InkWell(
                            child: ListTile(
                              title: Text(
                                'Góp ý và báo lỗi',
                                style: listTileStyle,
                              ),
                              leading: new Icon(Icons.chat,
                                  color: Colors.deepOrange[700]),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FeedBack(),
                                ),
                              );
                            },
                          ),
                          // new Divider(
                          //   indent: 5.0,
                          //   color: Colors.amber[700],
                          // ),
                          InkWell(
                            child: ListTile(
                              title: Text(
                                'Thông tin ứng dụng',
                                style: listTileStyle,
                              ),
                              leading:
                                  new Icon(Icons.info, color: Colors.blue[700]),
                            ),
                            onTap: () async {
                              await animated_dialog_box.showScaleAlertBox(
                                  title: Center(
                                      child: Text("Thông tin ứng dụng",
                                          style: TextStyle(
                                              fontFamily: 'RobotoSlab',
                                              fontWeight: FontWeight
                                                  .bold))), // IF YOU WANT TO ADD
                                  context: context,
                                  firstButton: MaterialButton(
                                    // FIRST BUTTON IS REQUIRED
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    color: Colors.white,
                                    child: Text('Close'),
                                    onPressed: () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                    },
                                  ),
                                  icon: Icon(
                                    Icons.info_outline,
                                    color: Colors.red,
                                  ), // IF YOU WANT TO ADD ICON
                                  yourWidget: Column(children: [
                                    Text('Version: 1.0',
                                        style: TextStyle(
                                            fontFamily: 'RobotoSlab',
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Lollipop Book là một ứng dụng bán sách online tuyệt vời, mang đến những trải nghiệm tốt cho người dùng.',
                                      style: TextStyle(
                                        fontFamily: 'RobotoSlab',
                                      ),
                                      textAlign: TextAlign.justify,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Lollipop Book bán đa dạng sách với rất nhiều thể loại, được cập nhật hàng ngày giúp người dùng có thể thoải mái lựa chọn những tựa sách yêu thích.',
                                      style:
                                          TextStyle(fontFamily: 'RobotoSlab'),
                                      textAlign: TextAlign.justify,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      'Nhóm phát triển: Hùng Đào & Anh Nguyễn',
                                      style:
                                          TextStyle(fontFamily: 'RobotoSlab'),
                                      textAlign: TextAlign.justify,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      'Email: lollipopbook.mobi@gmail.com',
                                      style:
                                          TextStyle(fontFamily: 'RobotoSlab'),
                                      textAlign: TextAlign.justify,
                                    )
                                  ]));
                            },
                          ),
                        ],
                      ),
                    );
                  } else
                    return new Container(height: 0.0, width: 0.0);
                });
          } else
            return new Drawer(
              child: new ListView(
                children: <Widget>[
                  new UserAccountsDrawerHeader(
                    accountName: Text('Khách',
                        style: TextStyle(
                            fontFamily: 'RobotoSlab',
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0)),
                    accountEmail: Text('Email: abc@gmail.com',
                        style: TextStyle(fontFamily: 'RobotoSlab')),
                    currentAccountPicture: GestureDetector(
                      child: new CircleAvatar(
                        backgroundImage: NetworkImage(
                          'https://firebasestorage.googleapis.com/v0/b/lollipopbookstore.appspot.com/o/BiaSach%2Favatar%2Favatar.png?alt=media&token=0c4ac3c6-433b-44ec-9254-e2ebc1909f80',
                        ),
                      ),
                    ),
                    decoration: new BoxDecoration(color: Colors.amber[700]),
                  ),
                  InkWell(
                    child: ListTile(
                      title: Text(
                        'Thông báo',
                        style: listTileStyle,
                      ),
                      leading: new Icon(Icons.notifications,
                          color: Colors.amber[700]),
                    ),
                    onTap: () {},
                  ),
                  InkWell(
                    child: ListTile(
                      title: Text(
                        'Yêu thích',
                        style: listTileStyle,
                      ),
                      leading:
                          new Icon(Icons.favorite, color: Colors.pink[500]),
                    ),
                    onTap: () {},
                  ),
                  InkWell(
                    child: ListTile(
                      title: Text(
                        'Góp ý và báo lỗi',
                        style: listTileStyle,
                      ),
                      leading:
                          new Icon(Icons.chat, color: Colors.deepOrange[700]),
                    ),
                    onTap: () {},
                  ),
                  new Divider(
                    indent: 5.0,
                    color: Colors.amber[700],
                  ),
                  InkWell(
                    child: ListTile(
                      title: Text(
                        'Cài đặt',
                        style: listTileStyle,
                      ),
                      leading: new Icon(Icons.settings),
                    ),
                    onTap: () {},
                  ),
                  InkWell(
                    child: ListTile(
                      title: Text(
                        'Thông tin ứng dụng',
                        style: listTileStyle,
                      ),
                      leading: new Icon(Icons.info, color: Colors.blue[700]),
                    ),
                    onTap: () async {
                      await animated_dialog_box.showScaleAlertBox(
                          title: Center(
                              child: Text("Thông tin ứng dụng",
                                  style: TextStyle(
                                      fontFamily: 'RobotoSlab',
                                      fontWeight: FontWeight
                                          .bold))), // IF YOU WANT TO ADD
                          context: context,
                          firstButton: MaterialButton(
                            // FIRST BUTTON IS REQUIRED
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            color: Colors.white,
                            child: Text('Close'),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                          ),
                          icon: Icon(
                            Icons.info_outline,
                            color: Colors.red,
                          ), // IF YOU WANT TO ADD ICON
                          yourWidget: Column(children: [
                            Text('Version: 1.0',
                                style: TextStyle(
                                    fontFamily: 'RobotoSlab',
                                    fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Lollipop Book là một ứng dụng bán sách online tuyệt vời, mang đến những trải nghiệm tốt cho người dùng.',
                              style: TextStyle(
                                fontFamily: 'RobotoSlab',
                              ),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Lollipop Book bán đa dạng sách với rất nhiều thể loại, được cập nhật hàng ngày giúp người dùng có thể thoải mái lựa chọn những tựa sách yêu thích.',
                              style: TextStyle(fontFamily: 'RobotoSlab'),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Nhóm phát triển: Hùng Đào & Anh Nguyễn',
                              style: TextStyle(fontFamily: 'RobotoSlab'),
                              textAlign: TextAlign.justify,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Email: lollipopbook.mobi@gmail.com',
                              style: TextStyle(fontFamily: 'RobotoSlab'),
                              textAlign: TextAlign.justify,
                            )
                          ]));
                    },
                  ),
                ],
              ),
            );
        });
  }
}
