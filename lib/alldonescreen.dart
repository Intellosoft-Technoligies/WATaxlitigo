// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:testapp/dashboard.dart';

class AllDoneScreen extends StatefulWidget {
  @override
  _AllDoneScreenState createState() => _AllDoneScreenState();
}

class _AllDoneScreenState extends State<AllDoneScreen> {
  // ignore: unused_field
  bool _isObscusre = true; // Track whether password is obscured or not
  CarouselController _controller = CarouselController(); // Added CarouselController
  int _currentImageIndex = 0; // Added _currentImageIndex

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/vector.png'), // Background image for carousel
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: CarouselSlider(
                          carouselController: _controller,
                          options: CarouselOptions(
                            height: 650.0, // Decreased height
                            aspectRatio: 16 / 9,
                            viewportFraction: 0.8,
                            initialPage: _currentImageIndex,
                            enableInfiniteScroll: true,
                            reverse: false,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 2),
                            autoPlayAnimationDuration: Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _currentImageIndex = index;
                              });
                            },
                            scrollDirection: Axis.horizontal,
                          ),
                          items: [
                            'assets/group.png',
                            ['assets/vector.png', 'assets/illustration3.png'], // Background and overlay image
                            ['assets/vector.png', 'assets/illustration3.png'],
                            // Add more images as needed
                          ].map((item) {
                            if (item is String) {
                              // For single images
                              return Container(
                                child: Center(
                                  child: Image.asset(
                                    item,
                                    fit: BoxFit.cover, // Ensure the image covers the container
                                    width: 600, // Decreased width
                                    height: 300.0, // Decreased height
                                  ),
                                ),
                              );
                            } else if (item is List<String> && item.length == 2) {
                              // For combined images
                              return Container(
                                width: 600, // Decreased width
                                height: 300.0, // Decreased height
                                child: Stack(
                                  children: [
                                    // Background image
                                    Image.asset(
                                      item[0],
                                      fit: BoxFit.scaleDown, // Ensure the image covers the container
                                      width: 600, // Decreased width
                                      height: 100.0, // Decreased height
                                    ),
                                    // Overlay image
                                    Positioned.fill(
                                      child: Image.asset(
                                        item[1],
                                        fit: BoxFit.scaleDown, // Ensure the image fits within the container
                                        alignment: Alignment.center,
                                        width: 50, // Decreased width for illustration3.png
                                        height: 100, // Decreased height for illustration3.png
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Container(); // Handle invalid item format
                            }
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (int i = 0; i < 3; i++) buildIndicator(i),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Image.asset(
                          'assets/Logo.png',
                          width: 150,
                          height: 150,
                        ),
                      ),
                      Container(
                        child: Image.asset(
                          'assets/done.png',
                          width: 250,
                          height: 250,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 110, left: 100),
                        child: Column(
                          children: [
                            Text(
                              'All Done!',
                              style: TextStyle(
                                color: Color(0xFF5539E6), // Text color set to 5539E6
                                fontSize: 25.0,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Opacity(
                              opacity: 0.6,
                              child: Text(
                                'Your password has been reset',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            SizedBox(height: 20.0),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Dashboard()), // Navigate to Dashboard
                                );
                              },
                              child: Container(
  padding: EdgeInsets.symmetric(horizontal: 10.0),
  width: 350.0, // Adjust width as needed
  height: 50.0, // Adjust height as needed
  decoration: BoxDecoration(
    color: Color(0xFF5539E6), // Background color set to 5539E6
    borderRadius: BorderRadius.circular(5.0),
  ),
  child: Center(
    child: Text(
      'Continue',
      style: TextStyle(color: Colors.white),
    ),
  ),
),

                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildIndicator(int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: _currentImageIndex == index ? 24.0 : 8.0, // Use _currentImageIndex instead of _currentIndex
      decoration: BoxDecoration(
        color: _currentImageIndex == index ? Color(0xFF5539E6) : Colors.grey, // Use _currentImageIndex instead of _currentIndex
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
  }
}
