// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logistics/LoginScreen.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  bool obscureText1 = true;
  double strength = 0.0;

  void togglePasswordVisibility1() {
    setState(() {
      obscureText1 = !obscureText1;
    });
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneNumberController.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.orange,
        child: Column(
          children: [
            SizedBox(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child:  SvgPicture.asset(
                  'assets/Amazon_logo.svg',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: ListView(
                  children: [
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: nameController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        prefixIcon: Icon(Icons.email,color: Colors.orange,),
                        labelStyle: TextStyle(
                          color: Colors.orange,
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: phoneNumberController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        labelStyle: TextStyle(
                          color: Colors.orange,
                        ),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone,color: Colors.orange,),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: emailController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',labelStyle: TextStyle(
                        color: Colors.orange,
                      ),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email,color: Colors.orange,),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextFormField(
                            controller: passwordController,
                            textInputAction: TextInputAction.next,
                            obscureText: obscureText1,
                            onChanged: (password) {
                              setState(() {
                                strength = calculatePasswordStrength(password);
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: const TextStyle(
                                color: Colors.orange,
                              ),
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.lock,color: Colors.orange,),
                              suffixIcon: GestureDetector(
                                onTap: togglePasswordVisibility1,
                                child: Icon(
                                  obscureText1
                                      ? Icons.visibility
                                      : Icons.visibility_off,color: Colors.orange,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: confirmPasswordController,
                            textInputAction: TextInputAction.done,
                            obscureText: obscureText1,
                            onChanged: (password) {
                              setState(() {
                                strength = calculatePasswordStrength(password);
                              });
                            },
                            onFieldSubmitted: (_) {
                              String enteredPassword = confirmPasswordController.text;
                              String originalPassword = passwordController.text;

                              if (enteredPassword == originalPassword) {

                                onRegisterSuccess(context);
                              } else {

                                Fluttertoast.showToast(msg: "Passwords do not match.");
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              labelStyle: const TextStyle(
                                color: Colors.orange, // Change label color to orange
                              ),
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.lock, color: Colors.orange),
                              suffixIcon: GestureDetector(
                                onTap: togglePasswordVisibility1,
                                child: Icon(
                                  obscureText1 ? Icons.visibility : Icons.visibility_off,
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),


                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ), backgroundColor: Colors.orange,
                        ),
                        onPressed: () {
                          String password = passwordController.text;
                          String confirmPassword = confirmPasswordController.text;

                          if (password == confirmPassword) {
                            onRegisterSuccess(context);
                          } else {
                            Fluttertoast.showToast(msg: "Passwords do not match.");
                          }
                        },
                        child: const Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have account?",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.
                              orange,
                              fontSize: 18,
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
    );
  }
  void onRegisterSuccess(BuildContext context) async {
    String email = emailController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;
    String phoneNumber = phoneNumberController.text;
    String name = nameController.text;

    if (password == confirmPassword) {
      bool registrationSuccess = await registerUserAPI(name, email, phoneNumber, password);

      if (registrationSuccess) {
        await saveUserData('$name:$email:$phoneNumber:$password');

        Fluttertoast.showToast(msg: "Account Created!");

        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        Fluttertoast.showToast(msg: "Registration failed. Please try again.");
      }
    } else {
      Fluttertoast.showToast(msg: "Passwords do not match.");
    }
  }

  Future<bool> registerUserAPI(String name, String email, String phoneNumber, String password) async {
    const String registerEndpoint = 'https://your-api-endpoint.com/register';

    try {
      final response = await http.post(
        Uri.parse(registerEndpoint),
        body: {
          'name': name,
          'email': email,
          'phone_number': phoneNumber,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        // Display error message based on response status or other conditions
        Fluttertoast.showToast(msg: "Registration failed. Please try again.");
        return false;
      }
    } catch (e) {
      // Display error message if the request fails due to an exception
      Fluttertoast.showToast(msg: "Registration failed. Please try again.");
      return false;
    }
  }


  Future<void> saveUserData(String userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userData', userData);
  }



  double calculatePasswordStrength(String password) {

    return 0.0;
  }
}
