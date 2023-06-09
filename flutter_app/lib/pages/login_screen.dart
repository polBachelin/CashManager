import 'package:cash_manager/components/animations/toast.dart';
import 'package:cash_manager/components/widgets/classic_button.dart';
import 'package:cash_manager/components/widgets/fields/custom_field.dart';
import 'package:cash_manager/components/widgets/messages_screen.dart';
import 'package:cash_manager/services/manager.dart';
import 'package:cash_manager/theme.dart';
import 'package:cash_manager/utils/regex.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email = "";
  String _password = "";
  double _elementsOpacity = 1;
  bool loadingBallAppear = false;
  double loadingBallSize = 1;

  Future<bool> _login(String email, String password) async {
    final response = await Manager.of(context).api.login(email, password);
    switch (response) {
      case 200:
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, '/buy');
        break;
      default:
        break;
    }
    // ignore: use_build_context_synchronously
    toast(context, "Impossible de me connecter");
    return false;
  }

  void _getEmail(String email) {
    setState(() {
      _email = email;
    });
  }

  void _getPassword(String password) {
    setState(() {
      _password = password;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorBackground,
      body: SafeArea(
        bottom: false,
        child: loadingBallAppear
            ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30.0),
                child: MessagesScreen())
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 70),
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 300),
                        tween: Tween(begin: 1, end: _elementsOpacity),
                        builder: (_, value, __) => Opacity(
                          opacity: value,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Icon(Icons.flutter_dash,
                                  size: 60, color: Color(0xff21579C)),
                              SizedBox(height: 25),
                              Text(
                                "Bienvenue,",
                                style: TextStyle(
                                    color: ColorTitleText, fontSize: 35),
                              ),
                              Text(
                                "Connectez-vous pour continuer",
                                style:
                                    TextStyle(color: ColorText, fontSize: 27),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            CustomField(
                              fade: _elementsOpacity == 0,
                              validatorFunc: isValidEmail,
                              actionOnChanged: _getEmail,
                              hintText: "Email",
                            ),
                            const SizedBox(height: 40),
                            CustomField(
                              fade: _elementsOpacity == 0,
                              validatorFunc: null,
                              actionOnChanged: _getPassword,
                              hintText: "Password",
                            ),
                            const SizedBox(height: 60),
                            ClassicButton(
                              width: 200,
                              height: 50,
                              sizeText: 20,
                              text: "Login",
                              elementsOpacity: _elementsOpacity,
                              icon: Icons.login,
                              onTap: () {
                                _login(_email, _password).then((value) {
                                  if (value) {
                                    setState(() {
                                      _elementsOpacity = 0;
                                    });
                                  }
                                });
                              },
                              onAnimationEnd: () async {
                                await Future.delayed(
                                    const Duration(milliseconds: 500));
                                setState(() {
                                  loadingBallAppear = true;
                                });
                              },
                            ),
                            const Text("or"),
                            ClassicButton(
                              width: 100,
                              height: 50,
                              sizeText: 20,
                              text: "Register",
                              elementsOpacity: _elementsOpacity,
                              icon: Icons.app_registration,
                              onTap: () {
                                Navigator.pushReplacementNamed(
                                    context, "/register");
                              },
                              onAnimationEnd: () async {
                                await Future.delayed(
                                    const Duration(milliseconds: 500));
                                setState(() {
                                  loadingBallAppear = true;
                                });
                              },
                            )
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
}
