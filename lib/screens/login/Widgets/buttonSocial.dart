import 'package:flutter/material.dart';

Widget buildSocialBtn(Function onTap, AssetImage logo, Color colorBackground) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50.0,
        width: 50.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colorBackground,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo, fit: BoxFit.cover
          ),
        ),
      ),
    );
  }

