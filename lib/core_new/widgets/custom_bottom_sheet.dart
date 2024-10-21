import 'package:flutter/material.dart';

class CustomBottomSheet extends StatelessWidget {
  final List<BottomSheetItem> items;

  const CustomBottomSheet({super.key, required this.items});

  static void show(BuildContext context, List<BottomSheetItem> items) {
    showModalBottomSheet(
      context: context,
      builder: (context) => CustomBottomSheet(items: items),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Navigator.pop(context);
              items[index].onTap();
            },
            child: ListTile(
              leading: Icon(items[index].icon),
              title: Text(items[index].title),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => Divider(
          height: 1,
          thickness: 1,
          color: Colors.grey[400],
        ),
      ),
    );
  }
}

class BottomSheetItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  BottomSheetItem(
      {required this.title, required this.icon, required this.onTap});
}
