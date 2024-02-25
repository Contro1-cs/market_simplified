import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hushh_proto/main.dart';
import 'package:hushh_proto/modules/scores/widgets/container.dart';
import 'package:hushh_proto/widgets/colors.dart';

class ScoreTab extends StatefulWidget {
  const ScoreTab({super.key});

  @override
  State<ScoreTab> createState() => _ScoreTabState();
}

class _ScoreTabState extends State<ScoreTab> {
  //Variables
  int basicTests = 0;
  int advTests = 0;
  double basicScore = 0.0;
  double advScore = 0.0;

  //Functions
  void fetchScores() async {
    var data = await supabase
        .from('users')
        .select()
        .eq('user_id', supabase.auth.currentUser!.id)
        .single();
    setState(() {
      basicScore = data['basic_score'];
      basicTests = data['basic_tests'];
      advScore = data['adv_score'];
      advTests = data['adv_tests'];
    });
    debugPrint('$basicScore $basicTests $advScore $advTests');
  }

  @override
  void initState() {
    fetchScores();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallet.black15,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Text(
                'Your Scores',
                style: TextStyle(
                  color: Pallet.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              testScoreContainer(
                  'Basic Tests', basicTests, basicScore.toStringAsFixed(2)),
              const SizedBox(height: 20),
              testScoreContainer(
                  'Advance Tests', advTests, advScore.toStringAsFixed(2)),
              Expanded(child: SizedBox()),
              // SizedBox(
              //   width: double.infinity,
              //   height: 40,
              //   child: ElevatedButton.icon(
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Pallet.white,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(100),
              //       ),
              //     ),
              //     onPressed: () {
              //       setState(() {

              //       });
              //     },
              //     icon: SvgPicture.asset(
              //       "assets/atom.svg",
              //       color: Pallet.blue,
              //       height: 20,
              //     ),
              //     label: Text(
              //       'Get analyzed by AI',
              //       style: TextStyle(color: Pallet.blue),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
