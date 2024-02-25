import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hushh_proto/widgets/colors.dart';

class LineChartWidget extends StatefulWidget {
  const LineChartWidget({
    super.key,
    required this.barData,
  });
  final List<FlSpot> barData;

  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  List<Color> gradientColors = [
    Colors.cyan,
    Colors.cyan,
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.7,
          child: LineChart(
            mainData(),
            duration: const Duration(seconds: 1),
          ),
        ),
      ],
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 10,
      color: Pallet.white,
    );

    String text = value.toString();

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
      );
  LineChartData mainData() {
    return LineChartData(
      // minX: 0,
      // minY: 0,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles:
              SideTitles(showTitles: true, getTitlesWidget: leftTitleWidgets),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: widget.barData,
          isCurved: false,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
