
// ignore_for_file: use_build_context_synchronously
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logistics/FirstScreen.dart';
import 'package:logistics/RegisterScreen.dart';
import 'package:logistics/ResetPassword.dart';
import 'package:logistics/app_dio.dart';
import 'package:http/http.dart' as http;


void main() {
  AppDio.init();
  runApp(
    DevicePreview(
      builder: (context) => const SignUpApp(),
    ),
  );
}

class SignUpApp extends StatelessWidget {
  const SignUpApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (pO, pl, p2) {
        return MaterialApp(
          title: 'News App',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          home: const LoginScreen(),
        );
      },
    );
  }
}




class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    // Add listener to check for keyboard visibility changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final mediaQuery = MediaQuery.of(context);
      setState(() {
        isKeyboardVisible = mediaQuery.viewInsets.bottom > 0;
      });
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
  Future<String?> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userData');
  }
  void login() async {
    // Your existing login logic
    String email = emailController.text;
    String password = passwordController.text;

    String? savedUserData = await getUserData();
    if (savedUserData != null) {
      List<String> userInfo = savedUserData.split(":");
      String savedEmail = userInfo[1];
      String savedPassword = userInfo[3];

      if (email == savedEmail && password == savedPassword) {

        bool loginSuccess = await loginUserAPI(email, password);

        if (loginSuccess) {


          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else {
          Fluttertoast.showToast(msg: "Login failed. Please try again.");
        }
      } else {
        displayToast("Email or password wrong!");
      }
    } else {
      displayToast("User data not found!");
    }
  }

  Future<bool> loginUserAPI(String email, String password) async {

    const String loginEndpoint = 'https://localhost:7073/swagger/index.html/login';

    try {
      final response = await http.post(
        Uri.parse(loginEndpoint),
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return true; // Successful login
      } else {
        return false; // Login failed
      }
    } catch (e) {
      return false; // Error occurred during login
    }
  }



  void displayToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: 18.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
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
                    color: Colors.white,
                    padding: const EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 30),
                            TextFormField(
                              controller: emailController,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Colors.orange,
                                ),
                                labelStyle: TextStyle(
                                  color: Colors.orange,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Email required";
                                }
                                if (!value.contains("@") ||
                                    !value.contains(".")) {
                                  return "Invalid email!";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: passwordController,
                              textInputAction: TextInputAction.done,
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                border: const OutlineInputBorder(),
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  color: Colors.orange,
                                ),
                                labelStyle: const TextStyle(
                                  color: Colors.orange,
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: togglePasswordVisibility,
                                  child: Icon(
                                    _obscureText
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.orange,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Password required";
                                }
                                if (value.length < 6) {
                                  return "Password must be at least 6 characters";
                                }
                                return null;
                              },
                              onEditingComplete: () {
                                login();
                              },
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: login,
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      backgroundColor: Colors.orange,
                                    ),
                                    child: const Text(
                                      "Login",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Don't have an account? ",
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                        const RegisterScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Register",
                                    style: TextStyle(
                                      color: Colors.orange,
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
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void navToForgetPassword(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const ResetPassword()),
  );
}