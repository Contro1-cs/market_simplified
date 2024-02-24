import 'package:flutter/material.dart';
import 'package:hushh_proto/main.dart';
import 'package:hushh_proto/modules/authentication/screens/user_auth.dart';
import 'package:hushh_proto/widgets/colors.dart';
import 'package:hushh_proto/widgets/textfield.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //Variables
  TextEditingController _emailController = TextEditingController();

  //Functions
  fetchEmail() async {
    _emailController.text = supabase.auth.currentUser!.email!;
  }

  @override
  void initState() {
    fetchEmail();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallet.black15,
      appBar: AppBar(
        backgroundColor: Pallet.black15,
        elevation: 0,
        shadowColor: Pallet.white,
        centerTitle: true,
        title: Text(
          'Profile',
          style: TextStyle(
            color: Pallet.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            customTextField(
              context,
              'Email',
              _emailController,
              TextInputType.emailAddress,
            ),
            const SizedBox(height: 10),
            Container(
              height: 50,
              width: double.infinity,
              // margin: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Pallet.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  supabase.auth.signOut();
                  Navigator.popUntil(context, (route) => false);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UserAuthPage()));
                },
                icon: Icon(
                  Icons.logout_rounded,
                  color: Colors.white,
                ),
                label: Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
