import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hushh_proto/main.dart';
import 'package:hushh_proto/modules/authentication/screens/user_auth.dart';
import 'package:hushh_proto/modules/chats/widgets/chart.dart';
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
  TextEditingController _nameController = TextEditingController();
  List<FlSpot> barData = [];

  //Functions
  fetchEmail() async {
    _emailController.text = supabase.auth.currentUser!.email!;
    final data = await supabase
        .from('users')
        .select('name')
        .eq('user_id', supabase.auth.currentUser!.id)
        .single();

    _nameController.text = data['name'];
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
    barData = [];
    List tempList = [
      {"x": 0.0, "y": 0.0},
      {"x": 1.0, "y": 3.0},
      {"x": 2.0, "y": 2.0},
      {"x": 3.0, "y": 5.0},
      {"x": 4.0, "y": 4.0},
      {"x": 5.0, "y": 4.8},
      {"x": 6.0, "y": 3.0},
      {"x": 7.0, "y": 5.0},
      {"x": 8.0, "y": 2.0},
      {"x": 9.0, "y": 7.0},
      {"x": 10.0, "y": 5.0},
      {"x": 11.0, "y": 7.0},
      {"x": 12.0, "y": 9.0}
    ];
    tempList.forEach((element) {
      double x = element["x"];
      double y = element["y"];
      barData.add(FlSpot(x, y));
    });

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
              'Name',
              _nameController,
              TextInputType.emailAddress,
            ),
            const SizedBox(height: 10),
            customTextField(
              context,
              'Email',
              _emailController,
              TextInputType.emailAddress,
            ),
            const SizedBox(height: 30),
            LineChartWidget(
              barData: barData,
            ),
            const Expanded(child: SizedBox(height: 20)),
            Container(
              height: 50,
              width: double.infinity,
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
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
