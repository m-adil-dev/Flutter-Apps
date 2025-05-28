import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';




class ImageSliderWidget extends StatelessWidget {
  final List<Map<String, String>> imageList = [
    {
      'image':
          'lib/assets/customer_support.png',
      'text': '24/7 Customer Support',
    },
    {
      'image':
          'lib/assets/refunds.png',
      'text': 'Refunds within 48 hours',
    },
    {
      'image':
          'lib/assets/secure_transaction.png',
      'text': 'Secure Transaction Guaranteed',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 250,
        color: Colors.white,
        child: Center(
          child: CarouselSlider.builder(
            itemCount: imageList.length,
            itemBuilder: (BuildContext context, int index, int realIndex) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(imageList[index]['image']!,width: 150,),
                  SizedBox(height: 10),
                  Text(
                    imageList[index]['text']!,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              );
            },
            options: CarouselOptions(
              height: 300,
              enlargeCenterPage: true,
              autoPlay: true,
              aspectRatio: 16 / 9,
              viewportFraction: 0.8,
            ),
          ),
        ),
        );
  }
}