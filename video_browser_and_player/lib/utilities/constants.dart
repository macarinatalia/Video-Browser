import 'package:flutter/material.dart';

const API_KEY = '27236302-31d450790e5e22d1a48e68e7f';

const myLabelSmallStyle = TextStyle(
  color: Colors.black,
  fontFamily: 'Open Sans',
  fontSize: 12,
);

const myAppBarTitleStyle = TextStyle(color: Colors.black);

const myAppBarIconStyle = IconThemeData(color: Colors.black, size: 25);

const mySignInTextStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'Open Sans',
  fontSize: 16,
);

var mySignInBtnStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(Colors.green.shade600));

const myTextFieldBorderStyle = OutlineInputBorder(
  borderSide: BorderSide(color: Colors.grey, width: 1),
  borderRadius: BorderRadius.all(Radius.circular(10)),
);

const myTextFieldDisabledBorderStyle = OutlineInputBorder(
  borderSide: BorderSide(color: Colors.black12, width: 1),
  borderRadius: BorderRadius.all(Radius.circular(10)),
);

const myVideoTitleStyle = TextStyle(fontSize: 16.0);
