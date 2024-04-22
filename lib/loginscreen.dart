import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testapp/dashboard.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:testapp/forgotpasswordscreen.dart';
import 'package:testapp/signupscreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final List<String> _imageList = [
    'assets/group.png',
    'assets/illustration3.png',
    'assets/illustration2.png',
  ];

  bool _rememberMe = false;
  bool _isObscure = true;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  CarouselController _controller = CarouselController();
  int _currentImageIndex = 0;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _emailError;
  String? _passwordError;


  void _signInApi() async {
  setState(() {
    _emailError = validateEmail(_emailController.text);
    _passwordError = validatePassword(_passwordController.text);
  });

  if (_formKey.currentState!.validate()) {
    // Form is valid, proceed with sign-in action
    final String email = _emailController.text;
    final String password = _passwordController.text;

    // Make HTTP POST request to your authentication endpoint
    final response = await http.post(
      Uri.parse('http://localhost:8080/superAdmin/login'), // Replace with your API URL
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Authentication successful, navigate to next screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    } else {
      // Authentication failed, display error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Authentication failed. Please check your credentials.'),
        ),
      );
    }
  }
}

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                            image: AssetImage('assets/vector.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child:CarouselSlider(
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
                          for (int i = 0; i < _imageList.length; i++)
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
                        padding: EdgeInsets.only(bottom: 20.0, left: 10, right: 150),
                        child: Container(
                          child: Image.asset(
                            'assets/Logo.png',
                            width: 150,
                            height: 150,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 20, bottom: 110, right: 200, left: 60),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 1.0),
                              Center(
                                child: Column(
                                  children: [
                                    Text(
                                      'WELCOME!',
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
                                        'Please login to your personal account',
                                        style: TextStyle(
                                          color: Colors.black.withOpacity(0.6),
                                          fontWeight: FontWeight.w600
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 2),
                                    child: Text(
                                      'Email',
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.9),
                                        fontWeight: FontWeight.w600
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
                                      padding: const EdgeInsets.only(left: 12.0),
                                      child: Text(
                                        _emailError!,
                                        style: TextStyle(color: Colors.red),
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
                                        color: Colors.black.withOpacity(0.9),
                                        fontWeight: FontWeight.w600
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
                                              icon: Icon(
                                                _isObscure
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                              ),
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
                                      padding: const EdgeInsets.only(left: 12.0),
                                      child: Text(
                                        _passwordError!,
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(height: 10.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Transform.scale(
                                        scale: 0.8,
                                        child: CupertinoSwitch(
                                          value: _rememberMe,
                                          onChanged: (bool value) {
                                            setState(() {
                                              _rememberMe = value;
                                            });
                                          },
                                          activeColor: Color(0xFFF2F2F2),
                                          trackColor: Color(0xFFF2F2F2),
                                        ),
                                      ),
                                      Text('Remember me', style: TextStyle(color: Colors.black)),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                                      );
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                      overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                    ),
                                    child: Text(
                                      'Forgot Password?',
                                      style: TextStyle(
                                        color: Color(0xFF5539E6),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15.0),
                              GestureDetector(
                                onTap: () {
                                  _signInApi();
                                  _signIn();

                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF5539E6),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Sign in',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Divider(
                                color: Color(0xFFE5E5E5),
                                thickness: 1.0,
                              ),
                              SizedBox(height: 10.0),
                              InkWell(
                                onTap: () {
                                  // Add your Google sign-in action here
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(color: Colors.black),
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
                              SizedBox(height: 15.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Don\'t have an account? ',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  Container(
                                    color: Colors.white,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => SignUpScreen()),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Sign up now',
                                          style: TextStyle(color: Color(0xFF5539E6)),
                                        ),
                                      ),
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

  void _signIn() {
    setState(() {
      _emailError = validateEmail(_emailController.text);
      _passwordError = validatePassword(_passwordController.text);
    });

    if (_formKey.currentState!.validate()) {
      // Form is valid, proceed with sign-in action
    }
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length != 4) {
      return 'Please enter a 4-digit password';
    }
    return null;
  }
}
