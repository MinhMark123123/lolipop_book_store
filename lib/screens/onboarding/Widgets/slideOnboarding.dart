import 'package:flutter/material.dart';
import 'package:lolipop_book_store/screens/onboarding/Widgets/textStyles.dart';

final slide1 = Padding(
  padding: EdgeInsets.all(40.0),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Center(
        child: Image(
          image: AssetImage(
            'images/carousel/carousel1.jpg',
          ),
          height: 300.0,
          width: 300.0,
        ),
      ),
      SizedBox(height: 30.0),
      Text(
        'Connect people\naround the world',
        style: titleStyle,
      ),
      SizedBox(height: 15.0),
      Text(
        'Lorem ipsum dolor sit amet, consect adipiscing elit, sed do eiusmod tempor incididunt ut labore et.',
        style: subtitleStyle,
      ),
    ],
  ),
);

final slide2 = Padding(
  padding: EdgeInsets.all(40.0),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Center(
        child: Image(
          image: AssetImage(
            'images/carousel/carousel2.jpg',
          ),
          height: 300.0,
          width: 300.0,
        ),
      ),
      SizedBox(height: 30.0),
      Text(
        'Live your life smarter\nwith us!',
        style: titleStyle,
      ),
      SizedBox(height: 15.0),
      Text(
        'Lorem ipsum dolor sit amet, consect adipiscing elit, sed do eiusmod tempor incididunt ut labore et.',
        style: subtitleStyle,
      ),
    ],
  ),
);

final slide3 = Padding(
  padding: EdgeInsets.all(40.0),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Center(
        child: Image(
          image: AssetImage(
            'images/carousel/carousel3.jpg',
          ),
          height: 300.0,
          width: 300.0,
        ),
      ),
      SizedBox(height: 30.0),
      Text(
        'Get a new experience\nof imagination',
        style: titleStyle,
      ),
      SizedBox(height: 15.0),
      Text(
        'Lorem ipsum dolor sit amet, consect adipiscing elit, sed do eiusmod tempor incididunt ut labore et.',
        style: subtitleStyle,
      ),
    ],
  ),
);
