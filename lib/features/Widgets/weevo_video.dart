import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../core/Providers/auth_provider.dart';
import '../../core_new/networking/api_constants.dart';
import '../Screens/video_preview_list.dart';

class WeevoVideos extends StatelessWidget {
  const WeevoVideos({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  'كيف تستخدم ويفو',
                  style: TextStyle(
                    fontSize: 20.0.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              authProvider.groupBanner![2].banners!.length > 1
                  ? InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, VideoPreviewList.id);
                      },
                      child: Text(
                        'عرض المزيد',
                        style: TextStyle(
                          fontSize: 15.0.sp,
                          color: const Color(0xFF0062DD),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 8.0,
          ),
          child: GestureDetector(
            onTap: () async {
              await launchUrlString(
                  'https://www.youtube.com/embed/${authProvider.groupBanner![2].banners![0].link!.split('?')[1].split('=')[1]}');
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 6.0,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child:
                        authProvider.groupBanner![2].banners![0].image != null
                            ? Stack(
                                children: [
                                  AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: CachedNetworkImage(
                                      imageUrl: authProvider.groupBanner![2]
                                                  .banners![0].image!
                                                  .contains('http') ||
                                              authProvider.groupBanner![2]
                                                  .banners![0].image!
                                                  .contains('https')
                                          ? authProvider.groupBanner![2]
                                                  .banners![0].image ??
                                              ''
                                          : '${ApiConstants.baseUrl}${authProvider.groupBanner![2].banners![0].image}',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: Container(
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              )
                            : Stack(
                                children: [
                                  AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: Image.asset(
                                      'assets/images/video_image.jpg',
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: Container(
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                  ),
                  Image.asset(
                    'assets/images/weevo_video_icon.png',
                    height: 23.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
