import 'package:cash_manager/components/animations/toast.dart';
import 'package:cash_manager/components/widgets/classic_button.dart';
import 'package:cash_manager/components/widgets/fields/custom_field.dart';
import 'package:cash_manager/components/widgets/messages_screen.dart';
import 'package:cash_manager/services/manager.dart';
import 'package:cash_manager/utils/regex.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  double _elementsOpacity = 1;
  bool loadingBallAppear = false;
  double loadingBallSize = 1;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late String _username;
  late String _email;
  late String _password;
  late String _confirmedPassword;

  @override
  void initState() {
    _username = "";
    _email = "";
    _password = "";
    _confirmedPassword = "";
    super.initState();
  }

  Future<bool> _register(String username, String email, String password) async {
    final response =
        await Manager.of(context).api.register(username, email, password);
    switch (response) {
      case 200:
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, '/login');
        break;
      case 400:
        toast(context, "L'adresse email est invalide");
        break;
      case 413:
        toast(context, "Le mot de passe n'est pas assez sécurisé");
        break;
      default:
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

  void _getConfirmedPassword(String confirmedPassword) {
    setState(() {
      _confirmedPassword = confirmedPassword;
    });
  }

  void _getUsername(String username) {
    setState(() {
      _username = username;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                            children: [
                              const Icon(Icons.flutter_dash,
                                  size: 60, color: Color(0xff21579C)),
                              const SizedBox(height: 25),
                              const Text(
                                "Register,",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 35),
                              ),
                              Text(
                                "Remplir le formulaire",
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.7),
                                    fontSize: 27),
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
                              validatorFunc: null,
                              actionOnChanged: _getUsername,
                              hintText: "Username",
                            ),
                            const SizedBox(height: 60),
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
                            CustomField(
                              fade: _elementsOpacity == 0,
                              validatorFunc: null,
                              actionOnChanged: _getConfirmedPassword,
                              hintText: "Confirm Password",
                            ),
                            const SizedBox(height: 60),
                            ClassicButton(
                              text: "Sign up",
                              elementsOpacity: _elementsOpacity,
                              icon: Icons.arrow_forward_rounded,
                              onTap: () {
                                print("$_confirmedPassword $_email, $_password, $_password");
                                _register(_username, _email, _password)
                                    .then((value) {
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
