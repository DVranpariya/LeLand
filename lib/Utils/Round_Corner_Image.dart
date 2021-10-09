import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'Constant.dart';

class RoundCornerImage extends StatelessWidget {
  final double height;
  final double width;
  final String image;
  final File fileImage;
  final String placeholder;
  final double circular;
  // BoxFit fit;
  RoundCornerImage(
      {this.height,
      this.width,
      this.image,
      this.fileImage,
      this.circular,
      this.placeholder});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(circular),
        child: CachedNetworkImage(
          width: width,
          height: height,
          fit: BoxFit.cover,
          imageUrl: image,
          placeholder: (context, url) => Container(
              child: Center(
                  child: new CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(kPrimaryColor)))),
          errorWidget: (context, url, error) => Container(
            height: width,
            width: height,
            decoration: BoxDecoration(
              /*  color: Color(0xFFdbdbdb),*/
              borderRadius: BorderRadius.circular(circular),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: fileImage == null
                      ? AssetImage(('assets/$placeholder'))
                      : FileImage(fileImage)),
              /* new Image.asset('assets/test.jpg')*/
            ),
          ),
        ),
      ),
    );
  }
}
