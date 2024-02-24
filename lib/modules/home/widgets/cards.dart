import 'package:flutter/material.dart';
import 'package:hushh_proto/modules/chats/screens/advance_chat.dart';
import 'package:hushh_proto/modules/chats/screens/basic_chat.dart';
import 'package:hushh_proto/widgets/colors.dart';
import 'package:hushh_proto/widgets/transitions.dart';

basicsCard(context, String title, String image, String table) {
  return Expanded(
    child: InkWell(
      onTap: () {
        rightSlideTransition(
            context,
            BasicChatPage(
              title: title,
              table: table,
            ));
      },
      child: Container(
        height: 230,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.fill,
          ),
          color: Pallet.black15,
          border: Border.all(
            color: Pallet.white.withOpacity(0.3),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            title,
            textAlign: TextAlign.center,
            softWrap: true,
            style: TextStyle(
              color: Pallet.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    ),
  );
}

learningCards(context, String title, Color color) {
  return InkWell(
    onTap: () {
      rightSlideTransition(context, AdvancedChat());
    },
    child: Container(
      width: double.infinity,
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 5),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: Pallet.black15,
          fontSize: 16,
        ),
      ),
    ),
  );
}
