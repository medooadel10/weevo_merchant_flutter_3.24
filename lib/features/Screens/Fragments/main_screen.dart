import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/Providers/auth_provider.dart';
import '../../../core/Utilits/constants.dart';
import '../../Widgets/general_preview.dart';
import '../../Widgets/weevo_video.dart';

class MainScreen extends StatefulWidget {
  final bool isPlus;

  const MainScreen({super.key, required this.isPlus});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          GeneralPreview(isPlus: widget.isPlus),
          Visibility(
              visible: authProvider.groupBannersState == NetworkState.SUCCESS,
              child: const WeevoVideos()),
          // Visibility(
          //   visible:
          //       productProvider.last5ProductState != NetworkState.WAITING &&
          //           productProvider.catState != NetworkState.WAITING,
          //   child: productProvider.last5ProductIsEmpty
          //       ? FirstTimeProduct()
          //       : UserProducts(size: size),
          // ),
          // Visibility(
          //     visible: authProvider.articleState == NetworkState.SUCCESS,
          //     child: WeevoStory()),
        ],
      ),
    );
  }
}
