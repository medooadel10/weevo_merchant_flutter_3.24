import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/Dialogs/action_dialog.dart';
import '../../core/Models/address.dart';
import '../../core/Models/fill_address_arg.dart';
import '../../core/Providers/auth_provider.dart';
import '../../core/Providers/map_provider.dart';
import '../../core/Providers/update_provider.dart';
import '../../core/Storage/shared_preference.dart';
import '../../core/Utilits/colors.dart';
import '../../core/router/router.dart';
import '../Screens/add_address.dart';

class AddressView extends StatelessWidget {
  final Address address;
  final bool isPicked;

  const AddressView({
    super.key,
    required this.address,
    required this.isPicked,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final MapProvider mapProvider = Provider.of<MapProvider>(context);
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    final UpdateProfileProvider updateProvider =
        Provider.of<UpdateProfileProvider>(context);
    return Stack(
      children: [
        Card(
          margin: const EdgeInsets.symmetric(
            vertical: 4.0,
            horizontal: 12.0,
          ),
          elevation: 1.0,
          shadowColor: weevoGreyColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(
              12.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  address.name ?? 'اسم المستخدم',
                  style: const TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: size.height * 0.001,
                ),
                Text(
                  '${address.state} - ${address.city}',
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.001,
                ),
                Text(
                  '${address.buildingNumber} ${address.street} - الدور ${address.floor} - شقة ${address.apartment} \nعلامة مميزة: ${address.landmark}',
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13.0,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 8,
          top: 0,
          child: CircleAvatar(
            radius: 10.0,
            backgroundColor:
                isPicked ? weevoPrimaryOrangeColor : Colors.transparent,
            child: isPicked
                ? const Icon(
                    Icons.done,
                    color: Colors.white,
                    size: 18.0,
                  )
                : Container(),
          ),
        ),
        Positioned(
          left: 8,
          top: 8,
          child: PopupMenuButton(
            onSelected: (String s) {
              switch (s) {
                case 'تعديل':
                  Navigator.pushReplacementNamed(
                    context,
                    AddAddress.id,
                    arguments: FillAddressArg(
                      isUpdated: true,
                      address: address,
                    ),
                  );
                  break;
                case 'حذف':
                  showDialog(
                    context: navigator.currentContext!,
                    builder: (context) => ActionDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          20.0,
                        ),
                      ),
                      title: 'حذف العنوان',
                      content: 'هل تود حذف هذا العنوان',
                      approveAction: 'نعم',
                      onApproveClick: () {
                        mapProvider.deleteAddress(
                          address.id!,
                        );
                        if (isPicked) {
                          if (!mapProvider.addressIsEmpty!) {
                            updateProvider.updateCurrentAddressId(
                              addressId: mapProvider.address!.last.id!,
                              currentPassword: authProvider.password!,
                            );
                            authProvider.setAddressId(
                              mapProvider.address!.last.id!,
                            );
                            mapProvider.setCurrentAddressId(
                              mapProvider.address!.last.id!,
                            );
                            mapProvider.setFullAddress(mapProvider.address!
                                .where(
                                    (i) => i.id == mapProvider.address!.last.id)
                                .first);
                          } else {
                            updateProvider.updateCurrentAddressId(
                              addressId: null,
                              currentPassword: authProvider.password!,
                            );
                            authProvider.setAddressId(-1);
                            mapProvider.setFullAddress(null);
                          }
                        }
                        MagicRouter.pop();
                      },
                      cancelAction: 'لا',
                      onCancelClick: () {
                        MagicRouter.pop();
                      },
                    ),
                  );
                  break;
              }
            },
            itemBuilder: (context) => <PopupMenuItem<String>>[
              const PopupMenuItem(
                value: 'تعديل',
                child: ListTile(
                  title: Text('تعديل'),
                  leading: Icon(
                    Icons.edit,
                  ),
                ),
              ),
              const PopupMenuItem(
                value: 'حذف',
                child: ListTile(
                  title: Text('حذف'),
                  leading: Icon(
                    Icons.delete,
                  ),
                ),
              ),
            ],
            icon: const Icon(
              Icons.more_vert,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }
}
