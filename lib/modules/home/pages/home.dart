import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hushh_proto/modules/chats/screens/ai_chat.dart';
import 'package:hushh_proto/modules/chats/screens/reference.dart';
import 'package:hushh_proto/modules/home/widgets/cards.dart';
import 'package:hushh_proto/modules/profile/screens/profile.dart';
import 'package:hushh_proto/modules/scores/screens/score_tab.dart';
import 'package:hushh_proto/widgets/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  List<Widget> pages = [
    const HomePageLayout(),
    const ScoreTab(),
    const AiChatBot(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    navBarItem(Widget icon) {
      return Container(
        height: 45,
        width: 45,
        padding: const EdgeInsets.all(10),
        child: icon,
      );
    }

    return Scaffold(
      backgroundColor: Pallet.black15,
      bottomNavigationBar: Container(
        height: 70,
        margin: const EdgeInsets.fromLTRB(15, 0, 15, 8),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Pallet.white.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 5,
            )
          ],
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xff353535),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  currentIndex = 0;
                });
              },
              child: currentIndex == 0
                  ? navBarItem(
                      SvgPicture.asset("assets/navbar/home_selected.svg"),
                    )
                  : navBarItem(
                      SvgPicture.asset("assets/navbar/home_Icon.svg"),
                    ),
            ),
            const SizedBox(width: 1),
            InkWell(
              onTap: () {
                setState(() {
                  currentIndex = 1;
                });
              },
              child: navBarItem(
                currentIndex == 1
                    ? SvgPicture.asset("assets/navbar/boards_selected.svg")
                    : SvgPicture.asset("assets/navbar/boards_icon.svg"),
              ),
            ),
            const SizedBox(width: 1),
            InkWell(
              onTap: () {
                setState(() {
                  currentIndex = 2;
                });
              },
              child: navBarItem(
                currentIndex == 2
                    ? SvgPicture.asset(
                        "assets/navbar/chat_selected.svg",
                      )
                    : SvgPicture.asset(
                        "assets/navbar/chat_icon.svg",
                        color: Pallet.white.withOpacity(0.7),
                      ),
              ),
            ),
            const SizedBox(width: 1),
            InkWell(
              onTap: () {
                setState(() {
                  currentIndex = 3;
                });
              },
              child: navBarItem(
                currentIndex == 3
                    ? SvgPicture.asset(
                        "assets/navbar/person_icon.svg",
                        color: Colors.white,
                      )
                    : SvgPicture.asset("assets/navbar/person_icon.svg"),
              ),
            ),
          ],
        ),
      ),
      body: pages[currentIndex],
    );
  }
}

class HomePageLayout extends StatefulWidget {
  const HomePageLayout({super.key});

  @override
  State<HomePageLayout> createState() => _HomePageLayoutState();
}

class _HomePageLayoutState extends State<HomePageLayout> {
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
          'Market Simplified',
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
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Start with the basics',
                  style: TextStyle(
                    color: Pallet.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    basicsCard(
                      context,
                      'Technical Analysis Basics',
                      'assets/ta.png',
                      'technical_analysis',
                    ),
                    const SizedBox(width: 14),
                    basicsCard(
                      context,
                      'Options Trading Basics',
                      'assets/basics.png',
                      'options_trading',
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Practice what you learnt',
                  style: TextStyle(
                    color: Pallet.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                learningCards(
                  context,
                  'Basic Patterns',
                  Color(0xff61F4DE),
                  'basic_patterns',
                ),
                learningCards(
                  context,
                  'Support and Resistance Patterns',
                  Color(0xffDBB1BC),
                  'support_resistance',
                ),
                learningCards(
                  context,
                  'Flag Patterns',
                  Color(0xffA1E8AF),
                  'basic_patterns',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
