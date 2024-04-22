import 'package:flutter/material.dart';
import 'package:testapp/alldonescreen.dart'; // Import the AllDoneScreen widget
import 'package:carousel_slider/carousel_slider.dart'; // Import CarouselSlider
import 'package:http/http.dart' as http;
import 'dart:convert';


class SetNewPassword extends StatefulWidget {
  @override
  _SetNewPasswordState createState() => _SetNewPasswordState();
}

class _SetNewPasswordState extends State<SetNewPassword> {
  int _currentImageIndex = 0;
  CarouselController _controller = CarouselController();

  // Variable to track loading state
  double _loaderProgress = 0.0; // Variable to track loader progress

  // Controllers for password fields
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true; // Variable to toggle password visibility
  bool _obscureConfirmPassword = true; // Variable to toggle confirm password visibility

 final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


// Function to handle password reset
Future<void> resetPassword(String password) async {
  final url = Uri.parse('http://localhost:8080/superAdmin/reset-password'); // Replace with your backend API endpoint
  try {
    final response = await http.put( // Use http.put instead of http.post
      url,
      body: json.encode({'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Password reset successful
      // Navigate to the all done screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AllDoneScreen()),
      );
    } else {
      // Error occurred, handle accordingly
      print('Error: ${response.reasonPhrase}');
      // You can display an error message to the user
    }
  } catch (error) {
    // Handle error
    print('Error: $error');
    // You can display an error message to the user
  }
}




  @override
  void dispose() {
    // Dispose controllers when the widget is disposed
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

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
                          height: 600.0,
                           // Decreased height
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
                        for (int i = 0; i < 3; i++)
                          buildIndicator(i),
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
                    Padding(
                      padding: EdgeInsets.only(top: 20, left: 40),
                      child: Container(
                        child: Image.asset(
                          'assets/Logo.png',
                          width: 150,
                          height: 150,
                        ),
                      ),
                    ),
                    SizedBox(height: 5,),
                    Container(
                      padding: EdgeInsets.only(  right: 110, left: 150),
                      child: Column(
                        children: [
                          SizedBox(height: 5.0),
                          Text(
                            'Set new password',
                            style: TextStyle(
                              color: Color(0xFF5539E6), // Text color set to 5539E6
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Opacity(
                            opacity: 0.9,
                            child: Text(
                              'Must be at least 8 characters',
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
  padding: EdgeInsets.only(left: 2),
  child: Text(
    'Password',
    style: TextStyle(
      color: Colors.black, // Set text color to black
      fontSize: 14.0, // Set font size to 16
      fontWeight: FontWeight.w600 // Set font weight to bold
    ),
  ),
),

                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: TextFormField(
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  onChanged: (value) {
                                    setState(() {
                                      // Calculate loader progress based on the number of digits entered
                                      _loaderProgress = value.length / 8.0;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter password',
                                    suffixIcon: IconButton(
                                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.0), // Add some space between the boxes
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildLoaderSection(0, _loaderProgress),
                                  _buildLoaderSection(1, _loaderProgress),
                                  _buildLoaderSection(2, _loaderProgress),
                                  _buildLoaderSection(3, _loaderProgress),
                                ],
                              ),
                              SizedBox(height: 10.0), // Add some space between the sections
                              Container(
  padding: EdgeInsets.only(left: 2),
  child: Text(
    'Confirm Password',
    style: TextStyle(
      color: Colors.black, // Set text color to black
      fontSize: 14.0, // Set font size to 16
      fontWeight: FontWeight.w600 // Set font weight to bold
    ),
  ),
),

                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: TextFormField(
                                  controller: _confirmPasswordController,
                                  obscureText: _obscureConfirmPassword,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Confirm password',
                                    suffixIcon: IconButton(
                                      icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                                      onPressed: () {
                                        setState(() {
                                          _obscureConfirmPassword = !_obscureConfirmPassword;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                                     SizedBox(height: 20.0),
                              GestureDetector(
                                // onTap: () {
                                //   // Start loading
                                //   setState(() {
                                //   });
                                //   // Simulate a loading delay
                                //   Future.delayed(Duration(seconds: 2), () {
                                //     // Stop loading
                                //     setState(() {
                                //     });
                                //     Navigator.push(
                                //       context,
                                //       MaterialPageRoute(builder: (context) => AllDoneScreen()), // Navigate to AllDoneScreen
                                //     );
                                //   });
                                // },
                                       onTap: () {
    // Check if form is valid before calling resetPassword
    if (_formKey.currentState!.validate()) {
      String password = _passwordController.text; // Get the entered password
      resetPassword(password); // Call resetPassword function
    }
  },
                                
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10.0),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF5539E6), // Background color set to 5539E6
                                    borderRadius: BorderRadius.circular(5.0),
                                    border: Border.all(color: Colors.grey), // Add border
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Reset password',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.0), // Add some space between the boxes
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context); // Navigate back to the previous screen
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0), // Padding around the text
                                  decoration: BoxDecoration(
                                    color: Colors.white, // Background color set to white
                                    borderRadius: BorderRadius.circular(5.0),
                                    border: Border.all(color: Colors.grey), // Add border
                                  ),
                                  child: Center( // Center the text
                                    child: Text(
                                      'Back to Login',
                                      style: TextStyle(
                                        color: Colors.black, // Text color set to black
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
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

  // Function to build a section of the loader
  Widget _buildLoaderSection(int sectionIndex, double loaderProgress) {
    return Container(
      width: 70.0,
      height: 4.0,
      decoration: BoxDecoration(
        color: loaderProgress > sectionIndex * 0.25 ? Colors.green : Colors.grey,
        borderRadius: BorderRadius.circular(2.0),
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
