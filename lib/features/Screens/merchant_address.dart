import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/Providers/auth_provider.dart';
import '../../core/Providers/map_provider.dart';
import '../../core/Providers/update_provider.dart';
import '../../core/Storage/shared_preference.dart';
import '../../core/Utilits/colors.dart';
import '../../core/Utilits/constants.dart';
import '../../core/router/router.dart';
import '../Widgets/address_view.dart';
import 'map.dart';

class MerchantAddress extends StatefulWidget {
  static String id = 'Your Address';

  const MerchantAddress({super.key});

  @override
  State<MerchantAddress> createState() => _MerchantAddressState();
}

class _MerchantAddressState extends State<MerchantAddress> {
  bool _currentAddressLoading = false;
  late UpdateProfileProvider _updateProvider;
  late AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
    _updateProvider =
        Provider.of<UpdateProfileProvider>(context, listen: false);
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _updateProvider.getUserDataByToken();
    check(
        auth: _authProvider,
        ctx: context,
        state: _updateProvider.getUserDataByTokenState!);
  }

  @override
  Widget build(BuildContext context) {
    final MapProvider mapProvider = Provider.of<MapProvider>(context);
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    final UpdateProfileProvider updateProvider =
        Provider.of<UpdateProfileProvider>(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: WillPopScope(
        onWillPop: () async {
          if (mapProvider.currentAddressId != null) {
            setState(() => _currentAddressLoading = true);
            await updateProvider.updateCurrentAddressId(
              addressId: mapProvider.currentAddressId,
              currentPassword: authProvider.password!,
            );
            if (updateProvider.updateCurrentAddressIdState ==
                NetworkState.SUCCESS) {
              await authProvider.setAddressId(mapProvider.currentAddressId!);
            } else if (updateProvider.updateCurrentAddressIdState ==
                NetworkState.LOGOUT) {
              check(
                  auth: authProvider,
                  ctx: navigator.currentContext!,
                  state: updateProvider.updateCurrentAddressIdState!);
            }
            setState(() => _currentAddressLoading = false);
          }
          MagicRouter.pop();
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () async {
                if (mapProvider.currentAddressId != null) {
                  setState(() => _currentAddressLoading = true);
                  await updateProvider.updateCurrentAddressId(
                    addressId: mapProvider.currentAddressId,
                    currentPassword: authProvider.password!,
                  );
                  if (updateProvider.updateCurrentAddressIdState ==
                      NetworkState.SUCCESS) {
                    await authProvider
                        .setAddressId(mapProvider.currentAddressId!);
                  } else if (updateProvider.updateCurrentAddressIdState ==
                      NetworkState.LOGOUT) {
                    check(
                        auth: authProvider,
                        ctx: navigator.currentContext!,
                        state: updateProvider.updateCurrentAddressIdState!);
                  }
                  setState(() => _currentAddressLoading = false);
                }
                MagicRouter.pop();
              },
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                color: weevoPrimaryOrangeColor,
              ),
            ),
            title: const Text(
              'العناوين',
            ),
          ),
          body: mapProvider.addressLoading ||
                  _currentAddressLoading ||
                  updateProvider.getUserDataByTokenState == NetworkState.WAITING
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      weevoPrimaryOrangeColor,
                    ),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: mapProvider.addressIsEmpty!
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 40.0,
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    'لا يوجد لديك عناوين',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: () => mapProvider.clearAddressList(),
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12.0,
                                ),
                                itemCount: mapProvider.address!.length,
                                itemBuilder: (context, i) => GestureDetector(
                                  onTap: () {
                                    mapProvider.setCurrentAddressId(
                                        mapProvider.address![i].id!);
                                    mapProvider.setFullAddress(mapProvider
                                        .address!
                                        .where((i) =>
                                            i.id ==
                                            mapProvider.currentAddressId)
                                        .first);
                                  },
                                  child: AddressView(
                                    isPicked: mapProvider.currentAddressId !=
                                            null
                                        ? mapProvider.address!.indexOf(
                                                mapProvider.address!
                                                    .where((item) =>
                                                        item.id ==
                                                        mapProvider
                                                            .currentAddressId)
                                                    .first) ==
                                            i
                                        : authProvider.addressId != -1
                                            ? mapProvider.address!.indexOf(
                                                    mapProvider.address!
                                                        .where((item) =>
                                                            item.id ==
                                                            authProvider
                                                                .addressId)
                                                        .first) ==
                                                i
                                            : !mapProvider.addressIsEmpty!
                                                ? mapProvider.address!.indexOf(
                                                        mapProvider
                                                            .address!.last) ==
                                                    i
                                                : false,
                                    address: mapProvider.address![i],
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          floatingActionButton: FloatingActionButton.extended(
            label: const Text(
              'أضافة عنوان جديد',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: weevoPrimaryBlueColor,
            icon: const Icon(
              Icons.add,
              color: Colors.white,
              size: 30.0,
            ),
            onPressed: () {
              mapProvider.setFrom(from_address_map);
              Navigator.pushReplacementNamed(context, MapScreen.id,
                  arguments: false);
            },
          ),
        ),
      ),
    );
  }
}
