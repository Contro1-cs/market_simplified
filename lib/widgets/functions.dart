import 'dart:math';

int randomNumGenerator(int limit) {
    Random random = Random();
    int randomNumber = random.nextInt(limit);
    return randomNumber;
  }