import 'package:flutter/material.dart';

class ItemBookReview extends StatelessWidget {
  final String urlHinhDaiDien;
  final String hoTenNguoiBinhLuan;
  final String noiDungBinhLuan;
  final double saoDanhGia;

  ItemBookReview({
    Key key,
    this.urlHinhDaiDien,
    this.hoTenNguoiBinhLuan,
    this.noiDungBinhLuan,
    this.saoDanhGia,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
        child: new Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Container(
          padding: EdgeInsets.all(5.0),
          child: new CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(
              urlHinhDaiDien,
            ),
          ),
        ),
        new Expanded(
            child: Container(
                margin: EdgeInsets.only(left: 5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                      hoTenNguoiBinhLuan,
                      style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'RobotoSlab',
                          fontWeight: FontWeight.bold),
                    ),
                    new Text(
                      'Đánh giá: ${saoDanhGia.toString()}/5.0',
                      style: TextStyle(
                        fontSize: 13.0,
                        fontFamily: 'RobotoSlab',
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: 3.0,
                    ),
                    new Text(
                      noiDungBinhLuan,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontFamily: 'RobotoSlab',
                      ),
                    )
                  ],
                )))
      ],
    ));
  }
}
