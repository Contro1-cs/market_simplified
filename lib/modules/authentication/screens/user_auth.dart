import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hushh_proto/main.dart';
import 'package:hushh_proto/modules/home/pages/home.dart';
import 'package:hushh_proto/widgets/colors.dart';
import 'package:hushh_proto/widgets/snackbars.dart';
import 'package:hushh_proto/widgets/textfield.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserAuthPage extends StatefulWidget {
  const UserAuthPage({super.key});

  @override
  State<UserAuthPage> createState() => _UserAuthPageState();
}

class _UserAuthPageState extends State<UserAuthPage> {
  //Variables
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  late final StreamSubscription<AuthState> _streamSubscription;
  //Functions
  Future<void> signinUser() async {
    try {
      final AuthResponse res = await supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } on AuthException catch (e) {
      errorSnackbar(context, e.message);
    }
  }

  @override
  void initState() {
    super.initState();
    _streamSubscription = supabase.auth.onAuthStateChange.listen((event) {
      final session = event.session;
      if (session != null) {
        Navigator.popUntil(context, (route) => false);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallet.black15,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset("assets/logo_light.svg"),
          const SizedBox(height: 15),
          Text(
            'Market Simplified',
            style: TextStyle(
              color: Pallet.white,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          const SizedBox(height: 70),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                customTextField(
                  context,
                  'Email',
                  _emailController,
                  TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),
                customTextField(
                  context,
                  'Password',
                  _passwordController,
                  TextInputType.visiblePassword,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 40),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Pallet.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                if (_emailController.text.trim().isEmpty) {
                  errorSnackbar(context, 'Please enter email');
                } else if (_passwordController.text.trim().isEmpty) {
                  errorSnackbar(context, 'Please enter password');
                } else {
                  signinUser();
                }
              },
              child: Text(
                'Sign in',
                style: TextStyle(
                  color: Pallet.black15,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
