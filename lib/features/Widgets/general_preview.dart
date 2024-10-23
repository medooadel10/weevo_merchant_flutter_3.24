import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/Providers/auth_provider.dart';
import '../../core/Providers/map_provider.dart';
import '../../core/Providers/product_provider.dart';
import '../../core/Storage/shared_preference.dart';
import '../../core/Utilits/colors.dart';
import '../../core/Utilits/constants.dart';
import '../../core/Utilits/notification_const.dart';
import '../../core_new/helpers/spacing.dart';
import '../../core_new/router/router.dart';
import '../../core_new/widgets/custom_image.dart';
import '../../core_new/widgets/custom_shimmer.dart';
import '../../main.dart';
import '../Screens/shipment_splash.dart';
import '../Screens/wallet.dart';
import '../products/ui/products_screen.dart';
import '../shipments/ui/screens/shipments_screen.dart';
import 'weevo_plus_banner.dart';

class GeneralPreview extends StatefulWidget {
  final bool? isPlus;

  @override
  State<GeneralPreview> createState() => _GeneralPreviewState();

  const GeneralPreview({
    super.key,
    this.isPlus,
  });
}

class _GeneralPreviewState extends State<GeneralPreview> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authProvider = Provider.of<AuthProvider>(context);
    final MapProvider mapProvider = Provider.of<MapProvider>(context);
    final ProductProvider productProvider =
        Provider.of<ProductProvider>(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        0.0,
        8.0,
        0.0,
        0.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (authProvider.groupBannersState != NetworkState.WAITING)
            SizedBox(
              height: 120.h,
              width: double.infinity,
              child: CarouselSlider(
                items: List.generate(
                  authProvider.groupBanner != null
                      ? authProvider.groupBanner![0].banners!.length
                      : 0,
                  (int i) => GestureDetector(
                    onTap: () {
                      whereTo(context,
                          authProvider.groupBanner![0].banners![i].link!);
                    },
                    child: CustomImage(
                      imageUrl: authProvider.groupBanner![0].banners![i].image,
                      width: size.width,
                      height: 120.h,
                      radius: 12.0,
                    ),
                  ),
                ),
                options: CarouselOptions(
                    autoPlay: true,
                    aspectRatio: 16 / 9,
                    enlargeCenterPage: true,
                    viewportFraction: 0.9,
                    onPageChanged:
                        (int i, CarouselPageChangedReason reason) {}),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              child: CustomShimmer(
                height: 120.h,
                width: double.infinity,
                shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsetsDirectional.only(
              start: 10,
              top: 15.0,
            ),
            child: Row(
              children: [
                Text(
                  'اهلاً بك',
                  style: TextStyle(
                    fontSize: 20.0.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                horizontalSpace(5),
                Text(
                  Preferences.instance.getUserName.split(' ')[0],
                  style: TextStyle(
                    fontSize: 20.0.sp,
                    fontWeight: FontWeight.w600,
                    color: weevoPrimaryBlueColor,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 6.h,
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    Weevo.facebookAppEvents.setAutoLogAppEventsEnabled(true);
                    Weevo.facebookAppEvents
                        .setUserID(Preferences.instance.getUserId);
                    Weevo.facebookAppEvents.setUserData(
                      email: Preferences.instance.getUserEmail,
                      firstName: Preferences.instance.getUserName.split('')[0],
                      lastName: Preferences.instance.getUserName.split('')[1],
                      phone: Preferences.instance.getPhoneNumber,
                    );
                    log(mapProvider.state.name);
                    log(productProvider.productState!.name);
                    Navigator.pushNamed(
                      navigator.currentContext!,
                      ShipmentSplash.id,
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: weevoPrimaryOrangeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'إضافة طلب',
                              style: TextStyle(
                                fontSize: 18.0.sp,
                                color: const Color(0xff33334D),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Image.asset(
                          'assets/images/delivery_guy.png',
                          alignment: Alignment.bottomCenter,
                          height: 120.h,
                          width: 120.w,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    MagicRouter.navigateTo(const ShipmentsScreen());
                  },
                  child: Container(
                    margin: const EdgeInsets.all(4.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'الطلبات',
                              style: TextStyle(
                                fontSize: 18.0.sp,
                                color: const Color(0xff33334D),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Image.asset(
                          'assets/images/guy_alarm.png',
                          alignment: Alignment.bottomCenter,
                          height: 120.h,
                          width: 120.w,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    //Navigator.pushNamed(context, MerchantWarehouse.id);
                    MagicRouter.navigateTo(const ProductsScreen());
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    margin: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Row(
                            children: [
                              Text(
                                'المنتجات',
                                style: TextStyle(
                                    fontSize: 18.0.sp,
                                    color: const Color(0xff33334D),
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Image.asset(
                          'assets/images/wallet.png',
                          alignment: Alignment.bottomCenter,
                          height: 120.h,
                          width: 120.w,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    if (await authProvider.authenticateWithBiometrics()) {
                      Navigator.pushNamed(navigator.currentContext!, Wallet.id);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    margin: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: weevoPrimaryBlueColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'المحفظة',
                              style: TextStyle(
                                  fontSize: 18.0.sp,
                                  color: const Color(0xff33334D),
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Image.asset(
                          'assets/images/my_wallet.png',
                          alignment: Alignment.bottomCenter,
                          fit: BoxFit.contain,
                          height: 120.h,
                          width: 120.w,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          const WeevoPlusBanner()
        ],
      ),
    );
  }
}
