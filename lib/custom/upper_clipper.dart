import 'package:flutter/material.dart';


class UpperClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
//    path.lineTo(0.0, size.height);
//
//    var firstEndPoint = Offset(size.width, size.height);
//    var firstControlPoint = Offset(size.width, size.height);
////    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);
//
//    path.lineTo(size.width, 0.0);
//    path.lineTo(size.width, size.height*0.25);
    path.lineTo(0.0, 0.0);
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width, size.height/2);
    path.lineTo(0.0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}