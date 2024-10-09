import 'package:flutter/material.dart';

class BankInfoItem extends StatelessWidget {
  final String title;
  final String subtitle;

  BankInfoItem({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      leading: CircleAvatar(
        backgroundColor: Colors.blue,
        radius: 22.0,
        child: Icon(
          Icons.account_balance_wallet,
          color: Colors.white,
        ),
      ),
    );
  }
}
