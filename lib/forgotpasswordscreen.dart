import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:testapp/setnewpassword.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  int _currentImageIndex = 0;
  CarouselController? _controller;
  bool _showError = false;
  final _formKey = GlobalKey<FormState>(); // Added GlobalKey for the form

// Controller for the email field
  TextEditingController _emailController = TextEditingController();


// Function to handle forgot password
  Future<void> forgotPassword(String email) async {
    final url = Uri.parse('http://localhost:8080/superAdmin/update-password'); // Replace with your backend API endpoint
    try {
      final response = await http.post(
        url,
        body: json.encode({'email': email}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Password reset email sent successfully
        // Navigate to the set new password screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SetNewPassword()),
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Center(
            child: Form(
              key: _formKey, // Assign form key
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
                              image: AssetImage('assets/vector.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: CarouselSlider(
                            carouselController: _controller,
                            options: CarouselOptions(
                              height: 650.0,
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
                              ['assets/vector.png', 'assets/illustration3.png'],
                              ['assets/vector.png', 'assets/illustration3.png'],
                            ].map((item) {
                              if (item is String) {
                                return Container(
                                  child: Center(
                                    child: Image.asset(
                                      item,
                                      fit: BoxFit.cover,
                                      width: 600,
                                      height: 300.0,
                                    ),
                                  ),
                                );
                              } else if (item is List<String> && item.length == 2) {
                                return Container(
                                  width: 600,
                                  height: 300.0,
                                  child: Stack(
                                    children: [
                                      Image.asset(
                                        item[0],
                                        fit: BoxFit.scaleDown,
                                        width: 600,
                                        height: 100.0,
                                      ),
                                      Positioned.fill(
                                        child: Image.asset(
                                          item[1],
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return Container();
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
                        SizedBox(height: 2),
                        Container(
                          padding: EdgeInsets.only(right: 110, left: 150),
                          child: Column(
                            children: [
                              SizedBox(height: 10.0),
                              Text(
                                'Forgot Password ?',
                                style: TextStyle(
                                  color: Color(0xFF5539E6),
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5.0),
                              Opacity(
                                opacity: 0.9,
                                child: Text(
                                  'No worries we will send you setup instructions',
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.5),
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
    'Enter your Email',
    style: TextStyle(
      fontSize: 14, // Change the font size as needed
      fontWeight: FontWeight.w600, // Adjust the font weight
      color: Colors.black, // Change the color as needed
    ),
  ),
),

                                  SizedBox(height: 2),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'rahul pankaj@gmail.com',
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your email';
                                        }
                                        // Check email format
                                        if (!_isValidEmail(value)) {
                                          setState(() {
                                            _showError = true;
                                          });
                                          return 'Invalid email format';
                                        }
                                        // Reset _showError if email is valid
                                        setState(() {
                                          _showError = false;
                                        });
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  GestureDetector(
                                    onTap: () {
                                            // Check if form is valid before calling forgotPassword
                                            if (_formKey.currentState!.validate()) {
                                              String email = _emailController.text; // Get the entered email
                                              forgotPassword(email); // Call forgotPassword function
                                            }
                                          },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 10.0),
                                      decoration: BoxDecoration(
                                        color: Color(0xFF5539E6),
                                        borderRadius: BorderRadius.circular(5.0),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Update Password',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Container(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Visibility(
                                      visible: _showError,
                                      child: Container(
                                        width: 700,
                                        height: 65,
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Color(0xFFFFFDD0),
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(right: 8),
                                                  child: Image.asset(
                                                    'assets/vector2.png',
                                                    width: 24,
                                                    height: 24,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    'We can\'t seem to find the right email address for you. Please re-enter the email address that you have registered.',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 10.9,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5.0),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Back to Login',
                                          style: TextStyle(
                                            color: Colors.black,
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
      ),
    );
  }

  Widget buildIndicator(int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: _currentImageIndex == index ? 24.0 : 8.0,
      decoration: BoxDecoration(
        color: _currentImageIndex == index ? Color(0xFF5539E6) : Colors.grey,
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
  }

  // Function to validate email format
  bool _isValidEmail(String email) {
    // You can implement your email validation logic here
    // This is a simple validation example using a regular expression
    // Feel free to replace it with your own validation logic
    String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regExp = RegExp(emailRegex);
    return regExp.hasMatch(email);
  }
}
