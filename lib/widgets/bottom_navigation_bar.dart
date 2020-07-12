import 'package:flutter/material.dart';

class BottomNavigatuonBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 0;
    const TextStyle bottomItemStyle =
        TextStyle(fontFamily: 'RobotoSlab', fontSize: 13.0);
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text(
            'Trang Chủ',
            style: bottomItemStyle,
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          title: Text(
            'Danh Mục',
            style: bottomItemStyle,
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.shopping_cart,
          ),
          title: Text(
            'Giỏ Hàng',
            style: bottomItemStyle,
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          title: Text(
            'Cá Nhân',
            style: bottomItemStyle,
          ),
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.amber[700],
      //onTap: _onItemTapped,
    );
  }
}
