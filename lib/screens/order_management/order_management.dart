import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:lolipop_book_store/models/orderModel.dart';
import 'package:lolipop_book_store/screens/order_detail/order_detail.dart';
import 'package:lolipop_book_store/screens/order_management/Widgets/icon_order.dart';
import 'package:lolipop_book_store/viewmodels/CRUDOrder.dart';

class OrderManagement extends StatefulWidget {
  final String idUser;
  OrderManagement({Key key, @required this.idUser}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return OrderManagementState();
  }
}

class OrderManagementState extends State<OrderManagement> {
  @override
  Widget build(BuildContext context) {
    CRUDOrder crudOrder = new CRUDOrder(widget.idUser);
    List<OrderModel> listOrderModel = [];
    List<OrderModel> newListOrder = [];

    DateFormat formatTime = DateFormat("dd-MM-yyyy");

    // TODO: implement build
    return StreamBuilder(
      stream: crudOrder.fetchorderModelsAsStream(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData && snapshot.data.documents.length > 0) {
          for (var num = 0; num < snapshot.data.documents.length; num++) {
            print('Value of num: $num');
            listOrderModel.add(OrderModel(
              diaChiGiaoHang: snapshot.data.documents[num]['diaChiGiaoHang'],
              ghiChu: snapshot.data.documents[num]['ghiChu'],
              giamGia: snapshot.data.documents[num]['giamGia'] * 1.0,
              maDonHang: snapshot.data.documents[num]['maDonHang'],
              maGiamGia: snapshot.data.documents[num]['maGiamGia'],
              ngayDatHang: snapshot.data.documents[num]['ngayDatHang'],
              phuongThucThanhToan: snapshot.data.documents[num]
                  ['phuongThucThanhToan'],
              soDienThoai: snapshot.data.documents[num]['soDienThoai'],
              soLuongMua: snapshot.data.documents[num]['soLuongMua'],
              tamTinh: snapshot.data.documents[num]['tamTinh'] * 1.0,
              tenNguoiMua: snapshot.data.documents[num]['tenNguoiMua'],
              tongTien: snapshot.data.documents[num]['tongTien'] * 1.0,
              trangThai: snapshot.data.documents[num]['trangThai'],
            ));
          }
          for (var i = 0; i < listOrderModel.length; i++) {
            print('Ngày đặt hàng: ${listOrderModel[i].ngayDatHang}');
          }
          DateFormat format = DateFormat("yyyy-MM-dd");
          listOrderModel.sort((a, b) => format
              .parse(a.ngayDatHang)
              .compareTo(format.parse(b.ngayDatHang)));
          print('List Order: ${listOrderModel.length}');
          print('Sau khi sắp xếp:');
          newListOrder.clear();
          for (var i = listOrderModel.length - 1; i >= 0; i--) {
            newListOrder.add(listOrderModel[i]);
          }
          listOrderModel.clear();

          for (var i = 0; i < newListOrder.length; i++) {
            print(
                'Ngày đặt hàng sau khi sắp xếp: ${newListOrder[i].ngayDatHang}');
          }

          return Scaffold(
            appBar: AppBar(
              leading: new IconButton(
                icon: new Icon(
                  Icons.arrow_back,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: new Text('Quản lý đơn hàng',
                  style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.amber[700],
            ),
            body: Container(
              child: ListView.builder(
                  itemCount: newListOrder.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      child: ListTile(
                        title: new Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Mã đơn hàng: ${newListOrder[index].maDonHang}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                    fontFamily: 'RobotoSlab'),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                'Ngày đặt sách: ${DateFormat('yyyy-MM-dd HH:mm:ss').parse(newListOrder[index].ngayDatHang)}',
                                style: TextStyle(
                                    color: Colors.grey[700],
                                    fontFamily: 'RobotoSlab'),
                              ),
                              Text(
                                newListOrder[index].phuongThucThanhToan,
                                style: TextStyle(
                                    color: Colors.grey[700],
                                    fontFamily: 'RobotoSlab'),
                              ),
                              Text(
                                'Trạng thái: ${newListOrder[index].trangThai}',
                                style: TextStyle(
                                    color: Colors.grey[700],
                                    fontFamily: 'RobotoSlab'),
                              ),
                              SizedBox(
                                height: 3.0,
                              ),
                              Divider(
                                height: 1,
                              ),
                            ],
                          ),
                        ),
                        trailing: iconOrder(
                            newListOrder[index].trangThai,
                            widget.idUser,
                            newListOrder[index].maDonHang,
                            context),
                        onTap: () {
                          OrderModel orderModel = new OrderModel(
                            diaChiGiaoHang: newListOrder[index].diaChiGiaoHang,
                            ghiChu: newListOrder[index].ghiChu,
                            giamGia: newListOrder[index].giamGia,
                            maDonHang: newListOrder[index].maDonHang,
                            maGiamGia: newListOrder[index].maGiamGia,
                            ngayDatHang: newListOrder[index].ngayDatHang,
                            phuongThucThanhToan:
                                newListOrder[index].phuongThucThanhToan,
                            soDienThoai: newListOrder[index].soDienThoai,
                            soLuongMua: newListOrder[index].soLuongMua,
                            tenNguoiMua: newListOrder[index].tenNguoiMua,
                            tongTien: newListOrder[index].tongTien,
                            trangThai: newListOrder[index].trangThai,
                            tamTinh: newListOrder[index].tamTinh,
                          );
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OrderDetail(
                                        orderModel: orderModel,
                                        email: widget.idUser,
                                      )));
                        },
                      ),
                    );
                  }),
            ),
          );
        } else {
          return new Scaffold(
            appBar: AppBar(
              leading: new IconButton(
                icon: new Icon(
                  Icons.arrow_back,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: new Text('Quản lý đơn hàng',
                  style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.amber[700],
            ),
            body: Container(
              child: new Center(
                child: new Text('Chưa có đơn hàng'),
              ),
            ),
          );
        }
      },
    );
  }
}
