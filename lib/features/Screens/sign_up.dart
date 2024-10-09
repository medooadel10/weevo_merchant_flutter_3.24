import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/Providers/auth_provider.dart';
import '../../core/router/router.dart';
import '../Widgets/loading_widget.dart';

class SignUp extends StatefulWidget {
  static const String id = 'SIGN_UP';

  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    final signUp = Provider.of<AuthProvider>(context);
    return LoadingWidget(
      isLoading: signUp.isLoading,
      child: WillPopScope(
        onWillPop: () async {
          if (!signUp.isLoading) {
            switch (signUp.screenIndex) {
              case 0:
                MagicRouter.pop();
                break;
              // case 1:
              //   signUp.updateScreen(0);
              //   break;
            }
          }
          return false;
        },
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () {
                  if (!signUp.isLoading) {
                    switch (signUp.screenIndex) {
                      case 0:
                        MagicRouter.pop();
                        break;
                      // case 1:
                      //   signUp.updateScreen(0);
                      //   break;
                    }
                  }
                },
                icon: const Icon(
                  Icons.arrow_back_ios_outlined,
                ),
              ),
              title: const Text(
                'التسجيل',
              ),
            ),
            backgroundColor: Colors.white,
            body: signUp.currentPage,
          ),
        ),
      ),
    );
  }
}
