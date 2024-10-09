import 'package:flutter/material.dart';
import 'package:weevo_merchant_upgrade/core/Providers/profile_provider.dart';

import '../../core_new/router/router.dart';

class ChangeYourPhone extends StatefulWidget {
  static const String id = 'Change Phone Number';

  const ChangeYourPhone({super.key});

  @override
  State<ChangeYourPhone> createState() => _ChangeYourPhoneState();
}

class _ChangeYourPhoneState extends State<ChangeYourPhone> {
  @override
  void initState() {
    super.initState();
    ProfileProvider.listenFalse(context).phoneNumberController.clear();
    ProfileProvider.listenFalse(context).pinController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = ProfileProvider.get(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: WillPopScope(
        onWillPop: () async {
          switch (profileProvider.currentIndex) {
            case 0:
              MagicRouter.pop();
              break;
            case 1:
              profileProvider.setCurrentIndex(0);
              break;
          }
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                switch (profileProvider.currentIndex) {
                  case 0:
                    MagicRouter.pop();
                    break;
                  case 1:
                    profileProvider.setCurrentIndex(0);
                    break;
                }
              },
              icon: const Icon(
                Icons.arrow_back_ios_outlined,
              ),
            ),
            title: profileProvider.currentIndex == 0
                ? const Text(
                    'تغيير رقم الهاتف',
                  )
                : Container(),
          ),
          body: profileProvider.widget,
        ),
      ),
    );
  }
}
