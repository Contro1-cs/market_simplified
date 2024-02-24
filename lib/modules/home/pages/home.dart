import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hushh_proto/modules/chats/widgets/chart.dart';
import 'package:hushh_proto/modules/home/widgets/cards.dart';
import 'package:hushh_proto/widgets/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

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
                    ? SvgPicture.asset("assets/navbar/calendar_selected.svg")
                    : SvgPicture.asset("assets/navbar/calendar_icon.svg"),
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
      body: currentIndex == 0
          ? HomePageLayout()
          : LineChartWidget(
              barData: const [
                FlSpot(0, 3),
                FlSpot(2.6, 2),
                FlSpot(4.9, 5),
                FlSpot(6.8, 3.1),
                FlSpot(8, 4),
                FlSpot(9.5, 3),
                FlSpot(11, 4),
              ],
            ),
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
    return Padding(
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
                'Support and Resistance',
                Color(0xff61F4DE),
              ),
              learningCards(
                context,
                'Candelstick Patters',
                Color(0xffDBB1BC),
              ),
              learningCards(
                context,
                'Advance Patterns',
                Color(0xffA1E8AF),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
