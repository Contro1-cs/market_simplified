import 'package:flutter/material.dart';
import 'package:hushh_proto/widgets/colors.dart';

testScoreContainer(String title, int tests, String score) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Pallet.white.withOpacity(0.1),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Pallet.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Pallet.green,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Tests',
                style: TextStyle(
                  color: Pallet.black15,
                  fontSize: 18,
                ),
              ),
              Text(
                tests.toString(),
                style: TextStyle(
                  color: Pallet.black15,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Pallet.green,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Average Score',
                style: TextStyle(
                  color: Pallet.black15,
                  fontSize: 18,
                ),
              ),
              Text(
                '$score%',
                style: TextStyle(
                  color: Pallet.black15,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
