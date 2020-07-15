import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:party_booking/res/assets.dart';
import 'package:party_booking/widgets/common/utiu.dart';

class ImageListSlider extends StatelessWidget {
  final List<String> images;

  const ImageListSlider({Key key, @required this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          Assets.imgDishDetail,
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
          height: 250,
        ),
        CarouselSlider(
          height: 250,
          initialPage: 1,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: true,
          viewportFraction: 0.8,
          autoPlayInterval: Duration(seconds: 3),
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          pauseAutoPlayOnTouch: Duration(seconds: 10),
          enlargeCenterPage: true,
          scrollDirection: Axis.horizontal,
          items: UiUtiu.mapIndexed(
            images,
            (index, value) => Container(
              padding: EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  errorWidget: (context, url, error) => Icon(
                    Icons.error,
                    size: 80,
                    color: Colors.red,
                  ),
                  imageUrl: value,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 150,
                ),
              ),
            ),
          ).toList(),
        ),
      ],
    );
  }
}