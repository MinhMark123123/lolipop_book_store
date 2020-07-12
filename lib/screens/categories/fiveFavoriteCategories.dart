import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:lolipop_book_store/models/categoryModel.dart';
import 'package:lolipop_book_store/screens/home/home.dart';
import 'package:lolipop_book_store/screens/welcome/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FiveFavoriteCategories extends StatefulWidget {
  @override
  FiveFavoriteCategoriesState createState() {
    // TODO: implement createState
    return FiveFavoriteCategoriesState();
  }
}

class FiveFavoriteCategoriesState extends State<FiveFavoriteCategories> {
  bool isShowDialog;
  List<String> images = [
    "images/categories/blockchain.jpeg",
    "images/categories/chuyennganh.jpg",
    "images/categories/giaokhoagiaotrinh.jpg",
    "images/categories/kinhte.jpg",
    "images/categories/ngoaivan.jpg",
    "images/categories/phattrienbanthan.png",
    "images/categories/tapchi.jpg",
    "images/categories/thieunhi.jpg",
    "images/categories/thuongthucdoidong.jpg",
    "images/categories/tinhoc.jpg",
    "images/categories/vhnuocngoai.png",
    "images/categories/vhtrongnuoc.png"
  ];
  List<String> categoriesTitle = [
    'Blockchain',
    'Chuyên Ngành',
    'Giáo Khoa Giáo Trình',
    'Kinh Tế',
    'Ngoại Văn',
    'Phát Triển Bản Thân',
    'Tạp Chí',
    'Thiếu Nhi',
    'Thường Thức Đời Sống',
    'Tin Học Ngoại Ngữ',
    'VH Nước Ngoài',
    'VH Trong Nước'
  ];
  List categoriesID = [
    {'idDM': 'dmBlockchain', 'tenDM': 'Sách Blockchain'},
    {'idDM': 'dmChuyenNganh', 'tenDM': 'Sách Chuyên Ngành'},
    {'idDM': 'dmGiaoKhoaGiaoTrinh', 'tenDM': 'Sách Giáo Khoa - Giáo Trình'},
    {'idDM': 'dmKinhTe', 'tenDM': 'Sách Kinh Tế'},
    {'idDM': 'dmNgoaiVan', 'tenDM': 'Sách Ngoại Văn'},
    {'idDM': 'dmPhatTrienBanThan', 'tenDM': 'Sách Phát Triển Bản Thân'},
    {'idDM': 'dmTapChi', 'tenDM': 'Tạp Chí'},
    {'idDM': 'dmThieuNhi', 'tenDM': 'Sách Thiếu Nhi'},
    {'idDM': 'dmTinHocNgoaiNgu', 'tenDM': 'Sách Tin Học - Ngoại Ngữ'},
    {'idDM': 'dmThuongThucDoiSong', 'tenDM': 'Sách Thường Thức - Đời Sống'},
    {'idDM': 'dmVHNuocNgoai', 'tenDM': 'Sách Văn Học Nước Ngoài'},
    {'idDM': 'dmVHTrongNuoc', 'tenDM': 'Sách Văn Học Trong Nước'}
  ];
  List selectedCategories = [];
  List<Color> colors = new List();
  @override
  void initState() {
    super.initState();
    isShowDialog = true;
    colors.addAll([
      Colors.white.withOpacity(0.6),
      Colors.white.withOpacity(0.6),
      Colors.white.withOpacity(0.6),
      Colors.white.withOpacity(0.6),
      Colors.white.withOpacity(0.6),
      Colors.white.withOpacity(0.6),
      Colors.white.withOpacity(0.6),
      Colors.white.withOpacity(0.6),
      Colors.white.withOpacity(0.6),
      Colors.white.withOpacity(0.6),
      Colors.white.withOpacity(0.6),
      Colors.white.withOpacity(0.6)
    ]);
  }

  _saveFavoriteCatgories(List list) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString("favoriteCategories", json.encode(list));
  }

  @override
  Widget build(BuildContext context) {
    _showDialog(BuildContext context) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.INFO,
        animType: AnimType.BOTTOMSLIDE,
        customHeader: Icon(
          Icons.face,
          size: 50,
        ),
        tittle: 'Danh Mục Yêu Thích',
        desc: 'Hãy chọn 4 danh mục bạn yêu thích để tiếp tục',
      ).show();
    }

    if (isShowDialog == true) {
      Future.delayed(Duration.zero, () => _showDialog(context));
      setState(() {
        isShowDialog = false;
      });
    }
    // TODO: implement build
    return Scaffold(
        body: Container(
            padding: EdgeInsets.all(16.0),
            child: GridView.builder(
              itemCount: images.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
                childAspectRatio: (MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height / 2)),
              ),
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.width * 0.46,
                          width: MediaQuery.of(context).size.width * 0.46,
                          padding: EdgeInsets.only(top: 10, right: 5, left: 5),
                          child: FittedBox(
                              child: Image(image: AssetImage(images[index])),
                              fit: BoxFit.fill),
                        ),
                        Center(
                          child: Container(
                              height: 60,
                              width: 150,
                              color: colors[index],
                              child: Center(
                                child: Text(
                                  categoriesTitle[index],
                                  style: TextStyle(
                                    fontFamily: 'RobotoSlab',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )),
                        )
                      ],
                    ),
                    onTap: () {
                      if (selectedCategories.length < 4 &&
                          colors[index] == Colors.white.withOpacity(0.6)) {
                        setState(() {
                          colors[index] = Colors.amber.withOpacity(0.7);
                        });
                        selectedCategories.add(categoriesID[index]);
                        if (selectedCategories.length == 4) {
                          if (selectedCategories.length == 4) {
                            selectedCategories.insert(
                              0,
                              {'idDM': 'dmBanChay', 'tenDM': 'Sách Bán Chạy'},
                            );
                            selectedCategories.insert(
                              1,
                              {
                                'idDM': 'dmSachMoiPhatHanh',
                                'tenDM': 'Sách Mới Phát Hành'
                              },
                            );
                            _saveFavoriteCatgories(selectedCategories);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Welcome()));
                          }
                        }

                        print(selectedCategories.toString());
                      } else if (colors[index] !=
                          Colors.white.withOpacity(0.6)) {
                        selectedCategories.remove(categoriesID[index]);
                        setState(() {
                          colors[index] = Colors.white.withOpacity(0.6);
                        });
                      }
                    });
              },
            )));
  }
}
