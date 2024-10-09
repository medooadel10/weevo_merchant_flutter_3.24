import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/Providers/auth_provider.dart';
import '../../core/router/router.dart';
import '../Widgets/video_item.dart';

class VideoPreviewList extends StatelessWidget {
  static const String id = 'Video_Preview_List';

  const VideoPreviewList({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              MagicRouter.pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios_outlined,
            ),
          ),
          title: const Text(
            'كيف تستخدم ويفو',
          ),
        ),
        body: ListView.builder(
          itemBuilder: (BuildContext context, int i) => VideoItem(
            i: i,
          ),
          itemCount: authProvider.groupBanner![2].banners!.length,
        ),
      ),
    );
  }
}
