import 'package:flutter/material.dart';
import 'package:testapp/loginscreen.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  int _currentImageIndex = 0;
  bool isHovered = false;
  Color borderColor = Colors.grey;

  final CarouselController _controller = CarouselController();
  bool _isObscure = true;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String? _usernameError;
  String? _emailError;
  String? _passwordError;

  
  Future<void> _signup() async {
    final String username = _usernameController.text;
    final String email = _emailController.text;
    final String password = _passwordController.text;

    final Uri uri = Uri.parse('http://localhost:8080/superAdmin/register');

    try {
      final http.Response response = await http.post(
        uri,
        body: json.encode({'userName': username, 'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Signup successful
        print('Signup successful');
        // Navigate to the login screen after successful signup
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        // Signup failed
        print('Signup failed');
        // Show an error message to the user
        // You can display a SnackBar or showDialog to show the error message
      }
    } catch (error) {
      // Error occurred
      print('Error occurred: $error');
      // Show an error message to the user
      // You can display a SnackBar or showDialog to show the error message
    }
  }

  void _validateInputs() {
    setState(() {
      _usernameError = _validateUsername(_usernameController.text);
      _emailError = _validateEmail(_emailController.text);
      _passwordError = _validatePassword(_passwordController.text);
    });
  }

  String? _validateUsername(String value) {
    if (value.isEmpty) {
      return 'Please enter a username';
    }
    // Add validation for username containing only characters and numbers
    if (!RegExp(r'^[a-zA-Z0-9]*$').hasMatch(value)) {
      return 'Username can only contain letters and numbers';
    }
    return null;
  }

  String? _validateEmail(String value) {
    if (value.isEmpty) {
      return 'Please enter an email';
    }
    // Add email format validation if needed
    return null;
  }

  String? _validatePassword(String value) {
    if (value.isEmpty) {
      return 'Please enter a password';
    }
    // Ensure password is at least 6 characters long and between 8 to 12 characters long
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    if (value.length < 8 || value.length > 12) {
      return 'Password must be 8 to 12 characters long';
    }
    return null;
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
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 800),
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
                            } else if (item is List<String> &&
                                item.length == 2) {
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
                          for (int i = 0; i < 3; i++) buildIndicator(i),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 60.0, right: 200.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            left: 6,
                          ),
                          child: Center(
                            child: Image.asset(
                              'assets/Logo.png',
                              width: 150,
                              height: 150,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 0),
                          child: Center(
                            child: Text(
                              'Create an Account',
                              style: TextStyle(
                                color: Color(0xFF5539E6),
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            'Please create your personal account',
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 2),
                              child: Text(
                                'User name',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    controller: _usernameController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: '@User name',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (_usernameError != null)
                              Padding(
                                padding: EdgeInsets.only(left: 12, top: 4),
                                child: Text(
                                  _usernameError!,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 2),
                              child: Text(
                                'Email',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Enter email',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (_emailError != null)
                              Padding(
                                padding: EdgeInsets.only(left: 12, top: 4),
                                child: Text(
                                  _emailError!,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 2),
                              child: Text(
                                'Password',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: _isObscure,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Enter password',
                                      suffixIcon: IconButton(
                                        icon: Icon(_isObscure
                                            ? Icons.visibility
                                            : Icons.visibility_off),
                                        onPressed: () {
                                          setState(() {
                                            _isObscure = !_isObscure;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (_passwordError != null)
                              Padding(
                                padding: EdgeInsets.only(left: 12, top: 4),
                                child: Text(
                                  _passwordError!,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                      
                        GestureDetector(
                          onTap:(){
                           _validateInputs();
                          _signup();

                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            decoration: BoxDecoration(
                              color: Color(0xFF5539E6),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Center(
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 15.0),
                        Divider(
                          height: 1,
                          color: Color(0xFFE5E5E5),
                        ),
                        SizedBox(height: 15.0),
                        MouseRegion(
                          onEnter: (_) {
                            setState(() {
                              borderColor = Color(0xFF5539E6);
                            });
                          },
                          onExit: (_) {
                            setState(() {
                              borderColor = Colors.grey;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: borderColor),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/image.png',
                                  width: 24,
                                  height: 24,
                                ),
                                SizedBox(width: 10.0),
                                Text(
                                  'or Sign in with Google',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 7.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: TextStyle(color: Colors.black),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(
                                    Colors.transparent),
                                overlayColor: MaterialStateProperty.all<Color>(
                                    Colors.transparent),
                              ),
                              child: Text(
                                'Log In',
                                style: TextStyle(color: Color(0xFF5539E6)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
      width: _currentImageIndex == index ? 24.0 : 8.0,
      decoration: BoxDecoration(
        color: _currentImageIndex == index ? Color(0xFF5539E6) : Colors.grey,
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
  }
}
