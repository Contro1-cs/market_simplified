import 'package:flutter/material.dart';
import 'package:hushh_proto/main.dart';
import 'package:hushh_proto/modules/chats/widgets/lists.dart';
import 'package:hushh_proto/widgets/colors.dart';
import 'package:hushh_proto/widgets/functions.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({
    super.key,
    required this.score,
    required this.total,
    required this.basic,
  });
  final int score;
  final int total;
  final bool basic;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  //Variables
  String remark = 'You are a genius!';
  String comment =
      'Keep learning, and when you feel confident. Try harder concepts such as “options trading” or “Turn around patterns”';

  //Functions
  updateScore() async {
    double percent = (widget.score / widget.total) * 100;
    final data = await supabase
        .from('users')
        .select()
        .eq('user_id', supabase.auth.currentUser!.id)
        .single();
    if (widget.basic) {
      double basicScore = double.parse(data['basic_score'].toString());
      int basicTests = data['basic_tests'];
      double basicAvg =
          ((basicScore * basicTests) + percent) / (basicTests + 1);

      await supabase.from('users').update({
        'basic_score': basicTests == 0 ? percent : basicAvg,
        'basic_tests': basicTests + 1,
      }).match({
        'user_id': supabase.auth.currentUser!.id,
      });

      debugPrint(basicScore.toString());
    } else {
      double advScore = double.parse(data['adv_score'].toString());
      int advTests = data['adv_tests'];
      double advAvg = ((advScore * advTests) + percent) / (advTests + 1);

      await supabase.from('users').update({
        'adv_score': advTests == 0 ? percent : advAvg,
        'adv_tests': advTests + 1,
      }).match({
        'user_id': supabase.auth.currentUser!.id,
      });

      debugPrint(advScore.toString());
    }
  }

  setGreetings() {
    double percent = widget.score / widget.total;

    if (percent > 0 && percent < 0.5) {
      remark = belowAverageGreetings[randomNumGenerator(3)];
      comment = belowAverageImprovement[randomNumGenerator(3)];
    } else if (percent > 0.5 && percent < 0.9) {
      remark = averageGreetings[randomNumGenerator(3)];
      comment = averageImprovement[randomNumGenerator(3)];
    } else if (percent > 0.9) {
      aboveAverageGreetings[randomNumGenerator(3)];
      comment = aboveAverageImprovement[randomNumGenerator(3)];
    }
  }

  @override
  void initState() {
    updateScore();
    setGreetings();
    super.initState();
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
          'Results',
          style: TextStyle(
            color: Pallet.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Text(
              'Your score',
              style: TextStyle(
                color: Pallet.white,
                fontWeight: FontWeight.w500,
                fontSize: 40,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.score.toString(),
              style: TextStyle(
                color: Pallet.white,
                fontWeight: FontWeight.bold,
                fontSize: 128,
              ),
            ),
            const SizedBox(height: 25),
            Text(
              remark,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Pallet.white,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              comment,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Pallet.white,
                fontSize: 14,
              ),
            ),
            Expanded(child: SizedBox()),
            Container(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Pallet.green,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Done',
                  style: TextStyle(
                    color: Pallet.black15,
                    fontWeight: FontWeight.bold,
                  ),
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
