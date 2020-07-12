import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lolipop_book_store/models/orderModel.dart';
import 'package:lolipop_book_store/viewmodels/CRUDOderListBook.dart';
import 'package:lolipop_book_store/viewmodels/CRUDOrder.dart';

class OrderDetail extends StatelessWidget {
  final OrderModel orderModel;
  final String email;
  OrderDetail({Key key, @required this.orderModel, @required this.email})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(
              Icons.arrow_back,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: new Text('Chi Tiết Đơn Hàng',
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.amber[700],
        ),
        body: SingleChildScrollView(
            child: Container(
          padding:
              EdgeInsets.only(top: 20.0, left: 10.0, bottom: 5.0, right: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Mã đơn hàng: ${orderModel.maDonHang}',
                style: TextStyle(fontSize: 16.0, fontFamily: 'RobotoSlab'),
              ),
              SizedBox(height: 10.0),
              Text(
                'Ngày đặt hàng: ${orderModel.ngayDatHang}',
                style: TextStyle(
                    color: Colors.grey[600], fontFamily: 'RobotoSlab'),
              ),
              Text(
                'Trạng thái: ${orderModel.trangThai}',
                style: TextStyle(
                    color: Colors.grey[600], fontFamily: 'RobotoSlab'),
              ),
              SizedBox(height: 5.0),
              Divider(
                color: Colors.grey,
              ),
              Text(
                'Địa chỉ người nhận:',
                style: TextStyle(fontSize: 16.0, fontFamily: 'RobotoSlab'),
              ),
              SizedBox(height: 5.0),
              Text(
                'Tên người đặt: ${orderModel.tenNguoiMua}',
                style: TextStyle(
                    color: Colors.grey[600], fontFamily: 'RobotoSlab'),
              ),
              Text('Địa chỉ: ${orderModel.diaChiGiaoHang}',
                  style: TextStyle(
                      color: Colors.grey[600], fontFamily: 'RobotoSlab')),
              Text('Số điện thoại: ${orderModel.soDienThoai}',
                  style: TextStyle(
                      color: Colors.grey[600], fontFamily: 'RobotoSlab')),
              SizedBox(height: 5.0),
              Divider(
                color: Colors.grey,
              ),
              Text(
                'Hình thức thanh toán:',
                style: TextStyle(fontSize: 16.0, fontFamily: 'RobotoSlab'),
              ),
              SizedBox(height: 5.0),
              Text(
                orderModel.phuongThucThanhToan,
                style: TextStyle(
                    color: Colors.grey[600], fontFamily: 'RobotoSlab'),
              ),
              SizedBox(height: 5.0),
              Divider(
                color: Colors.grey,
              ),
              Text(
                'Thông tin đơn hàng:',
                style: TextStyle(fontSize: 16.0, fontFamily: 'RobotoSlab'),
              ),
              StreamBuilder(
                stream: Firestore.instance
                    .collection('UserCollection')
                    .document(email)
                    .collection('OrderCollection')
                    .document(orderModel.maDonHang)
                    .collection('BoughtBooksCollection')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  print(email);
                  print(orderModel.maDonHang);
                  if (snapshot.hasData &&
                      snapshot.data.documents.length - 1 >= 0) {
                    print('Có Dữ liệu');
                    //print('Email: $email');
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (BuildContext context, int index) {
                          return new Container(
                              padding: EdgeInsets.only(
                                  left: 0.0, top: 5.0, right: 5.0),
                              child: Column(
                                children: <Widget>[
                                  new Row(children: [
                                    CachedNetworkImage(
                                        imageUrl: snapshot.data.documents[index]
                                            ['biaSach'],
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
                                                      snapshot.data
                                                              .documents[index]
                                                          ['tenSach'],
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 3,
                                                      textAlign:
                                                          TextAlign.justify,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'RobotoSlab',
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
                                                      '${snapshot.data.documents[index]['giaTienDaGiam']} đ',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'RobotoSlab',
                                                          fontSize: 16.0,
                                                          color: Colors.red,
                                                          fontWeight: FontWeight
                                                              .bold)))),
                                          Container(
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                              child: Text(
                                                  'Số lượng: ${snapshot.data.documents[index]['soLuongMua']}',
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'RobotoSlab')))
                                        ])
                                  ]),
                                  new Divider(
                                    thickness: 1.0,
                                  ),
                                ],
                              ));
                        });
                  } else {
                    return Container(
                      height: 0,
                      width: 0.0,
                    );
                  }
                },
              ),
              SizedBox(height: 5.0),
              Divider(
                color: Colors.grey,
              ),
              SizedBox(height: 5.0),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Tạm tính: ',
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey[600],
                          fontFamily: 'RobotoSlab'),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        '${orderModel.tamTinh}đ',
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                            fontFamily: 'RobotoSlab'),
                      )
                    ],
                  )
                ],
              ),
              SizedBox(height: 15.0),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Giảm giá: ',
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey[600],
                          fontFamily: 'RobotoSlab'),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        '${orderModel.giamGia}đ',
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                            fontFamily: 'RobotoSlab'),
                      )
                    ],
                  )
                ],
              ),
              SizedBox(height: 15.0),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Thành tiền: ',
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey[600],
                          fontFamily: 'RobotoSlab'),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        '${orderModel.tongTien}đ',
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.red[600],
                            fontFamily: 'RobotoSlab'),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        )));
  }
}
