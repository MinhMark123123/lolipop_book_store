import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lolipop_book_store/models/bookModel.dart';
import 'package:lolipop_book_store/screens/book_detail/book_detail.dart';
import 'package:lolipop_book_store/viewmodels/CRUDFavoriteBook.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FavoriteBookScreen extends StatefulWidget {
  String email;
  FavoriteBookScreen({Key key, @required this.email}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FavoriteBookScreenState();
  }
}

class FavoriteBookScreenState extends State<FavoriteBookScreen> {
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

  @override
  Widget build(BuildContext context) {
    CRUDBookFavorite crudBookFavorite = new CRUDBookFavorite(widget.email);
    // TODO: implement build
    return StreamBuilder(
        stream: crudBookFavorite.fetchBooksAsStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData && snapshot.data.documents.length > 0) {
            return Scaffold(
                appBar: AppBar(
                  leading: new IconButton(
                    icon: new Icon(
                      Icons.arrow_back,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  title: new Text('Sách yêu thích',
                      style: TextStyle(color: Colors.white)),
                  backgroundColor: Colors.amber[700],
                ),
                body: Container(
                  child: ListView(
                    children: snapshot.data.documents.map((document) {
                      return Container(
                          child: ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          new Card(
                            child: ListTile(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Container(
                                    margin: new EdgeInsets.only(
                                        bottom: 8.0, top: 8.0),
                                    child: new CachedNetworkImage(
                                      imageUrl: document['biaSach'],
                                      width: 80.0,
                                      height: 115.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  new Expanded(
                                      child: Container(
                                    margin:
                                        EdgeInsets.only(left: 7.0, top: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          document['tenSach'],
                                          style: new TextStyle(
                                              fontFamily: 'RobotoSlab',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0,
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          height: 7.0,
                                        ),
                                        Text(
                                          'Tác giả: ${document['tacGia']}',
                                          style: TextStyle(
                                              fontFamily: 'RobotoSlab',
                                              fontWeight: FontWeight.normal,
                                              fontSize: 12.0,
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  )),
                                ],
                              ),
                              trailing: InkWell(
                                child: Icon(Icons.clear),
                                onTap: () {
                                  crudBookFavorite
                                      .deleteBook(document['tenSach']);
                                },
                              ),
                              onTap: () {
                                BookModel bookModel = new BookModel(
                                  biaSach: document['biaSach'],
                                  danhGia: document['danhGia'],
                                  dinhDang: document['dinhDang'],
                                  giaTien: document['giaTien'],
                                  giaTienDaGiam: document['giaTienDaGiam'],
                                  gioiThieuSach: document['gioiThieuSach'],
                                  idDM: document['idDM'],
                                  khoiLuong: document['khoiLuong'],
                                  kichThuoc: document['kichThuoc'],
                                  luotDanhGia: document['luotDanhGia'],
                                  maSP: document['maSP'],
                                  ngayPhatHanh: document['ngayPhatHanh'],
                                  ngonNgu: document['ngonNgu'],
                                  nguoiDich: document['nguoiDich'],
                                  nhaPhatHanh: document['nhaPhatHanh'],
                                  nhaXuatBan: document['nhaXuatBan'],
                                  phanTramGiamGia: document['phanTramGiamGia'],
                                  soLuong: document['soLuong'],
                                  soTrang: document['soTrang'],
                                  tacGia: document['tacGia'],
                                  tenSach: document['tenSach'],
                                  trangThai: document['trangThai'],
                                );
                                print(document['nhaXuatBan']);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            BookDetails(bookModel: bookModel)));
                              },
                            ),
                          )
                        ],
                      ));
                    }).toList(),
                  ),
                ));
          } else {
            return Scaffold(
                appBar: AppBar(
                  leading: new IconButton(
                    icon: new Icon(
                      Icons.arrow_back,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  title: new Text('Sách yêu thích',
                      style: TextStyle(color: Colors.white)),
                  backgroundColor: Colors.amber[700],
                ),
                body: Container(
                    child: Center(
                        child: Text("Chưa có sách yêu thích",
                            style: TextStyle(
                                fontFamily: 'RobotoSlab', fontSize: 20)))));
          }
        });
  }
}
