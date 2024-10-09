import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../core/Dialogs/image_picker_dialog.dart';
import '../../../core/Models/image.dart';
import '../../../core/Providers/auth_provider.dart';
import '../../../core/Storage/shared_preference.dart';
import '../../../core/Utilits/colors.dart';
import '../../../core/Utilits/constants.dart';
import '../../../core/router/router.dart';
import '../../Widgets/id_image_container.dart';
import '../../Widgets/weevo_button.dart';

class SignUpNationalIDScreen extends StatefulWidget {
  const SignUpNationalIDScreen({super.key});

  @override
  State<SignUpNationalIDScreen> createState() => _SignUpNationalIDScreenState();
}

class _SignUpNationalIDScreenState extends State<SignUpNationalIDScreen> {
  late AuthProvider _authProvider;
  int? productCategory, _frontIdImageCounter = 0, _backIdImageCounter = 0;
  Img? _frontIdImg, _backIdImg, _oldBackIdImage, _oldFrontIdImage;
  bool _frontIdImageHasError = false, _backIdImageHasError = false;
  String? _nationalIdPhotoFrontPath, _nationalIdPhotoBackPath;

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of(context, listen: false);
    _nationalIdPhotoBackPath = _authProvider.nationalIdPhotoBack;
    _nationalIdPhotoFrontPath = _authProvider.nationalIdPhotoFront;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          IDImageContainer(
            text: 'صورة البطاقة الأمامية',
            isLoading: authProvider.frontIdImageLoading,
            imagePath: _nationalIdPhotoFrontPath,
            onImagePressed: () {
              if (_frontIdImageHasError) {
                setState(() {
                  _frontIdImageHasError = false;
                });
              }
              _oldFrontIdImage = _frontIdImg;
              !authProvider.frontIdImageLoading &&
                      !authProvider.backIdImageLoading
                  ? showModalBottomSheet(
                      context: navigator.currentContext!,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(25),
                          topLeft: Radius.circular(25),
                        ),
                      ),
                      builder: (_) => ImagePickerDialog(
                            onImageReceived: (XFile? imageFile) async {
                              if (imageFile == null) return;
                              _frontIdImageCounter = _frontIdImageCounter! + 1;
                              MagicRouter.pop();
                              authProvider.setFrontIdImageLoading(true);
                              File? compressedImage =
                                  await compressFile(imageFile.path);
                              if (_frontIdImageCounter! > 1) {
                                await authProvider.deletePhotoID(
                                  token: _oldFrontIdImage!.token!,
                                  imageName: _oldFrontIdImage!.filename!,
                                );
                                _frontIdImg = await authProvider.uploadPhotoID(
                                  path: base64Encode(
                                      await compressedImage!.readAsBytes()),
                                  imageName: imageFile.path.split('/').last,
                                );
                              } else {
                                _frontIdImg = await authProvider.uploadPhotoID(
                                  path: base64Encode(
                                      await compressedImage!.readAsBytes()),
                                  imageName: imageFile.path.split('/').last,
                                );
                              }
                              setState(
                                () => _nationalIdPhotoFrontPath =
                                    _frontIdImg!.path,
                              );
                              authProvider.setFrontIdImageLoading(false);
                            },
                          ))
                  : Container();
            },
          ),
          SizedBox(
            height: 10.h,
          ),
          _frontIdImageHasError
              ? Text(
                  'من فضلك أختر الصورة الأمامية للبطاقة',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red[700],
                    fontSize: 18.0.sp,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : Container(),
          _frontIdImageHasError
              ? SizedBox(
                  height: 10.h,
                )
              : Container(),
          IDImageContainer(
            text: 'صورة البطاقة الخلفية',
            isLoading: authProvider.backIdImageLoading,
            imagePath: _nationalIdPhotoBackPath,
            onImagePressed: () {
              if (_backIdImageHasError) {
                setState(() {
                  _backIdImageHasError = false;
                });
              }
              _oldBackIdImage = _backIdImg;
              !authProvider.backIdImageLoading &&
                      !authProvider.frontIdImageLoading
                  ? showModalBottomSheet(
                      context: navigator.currentContext!,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                        topRight: Radius.circular(25.0),
                        topLeft: Radius.circular(25.0),
                      )),
                      builder: (_) => ImagePickerDialog(
                        onImageReceived: (XFile? imageFile) async {
                          if (imageFile == null) return;
                          _backIdImageCounter = _backIdImageCounter! + 1;
                          MagicRouter.pop();
                          authProvider.setBackIdImageLoading(true);
                          File? compressedImage =
                              await compressFile(imageFile.path);
                          if (_backIdImageCounter! > 1) {
                            await authProvider.deletePhotoID(
                              token: _oldBackIdImage!.token!,
                              imageName: _oldBackIdImage!.filename!,
                            );
                            _backIdImg = await authProvider.uploadPhotoID(
                              path: base64Encode(
                                await compressedImage!.readAsBytes(),
                              ),
                              imageName: imageFile.path.split('/').last,
                            );
                          } else {
                            _backIdImg = await authProvider.uploadPhotoID(
                              path: base64Encode(
                                await compressedImage!.readAsBytes(),
                              ),
                              imageName: imageFile.path.split('/').last,
                            );
                          }
                          setState(
                            () => _nationalIdPhotoBackPath = _backIdImg!.path,
                          );
                          authProvider.setBackIdImageLoading(false);
                        },
                      ),
                    )
                  : Container();
            },
          ),
          const SizedBox(
            height: 10.0,
          ),
          _backIdImageHasError
              ? Text(
                  'من فضلك أختر الصورة الخلفية للبطاقة',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red[700],
                    fontSize: 18.0.sp,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : Container(),
          _backIdImageHasError
              ? SizedBox(
                  height: 10.h,
                )
              : Container(),
          Text(
            'تأكد من ظهور صورة البطاقة الشخصية \nبشكل واضح وصحيح',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 18.0.sp,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20.0.h,
          ),
          Consumer<AuthProvider>(
            builder: (ctx, data, ch) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                WeevoButton(
                  isStable: true,
                  color: Colors.red,
                  onTap: () async {
                    // setState(() {
                    //   _backIdImageHasError = false;
                    //   _frontIdImageHasError = false;
                    // });
                    // if (res == AuthProvider.success) {
                    //
                    // } else {
                    //   authProvider.setLoading(false);
                    //   showDialog(
                    //     navigator.currentContext!,
                    //     builder: (context) => ActionDialog(
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(
                    //           20.0,
                    //         ),
                    //       ),
                    //       title: 'خطأ',
                    //       content: '$res',
                    //       onCancelClick: () {
                    //   magicRouter.pop();                    //       },
                    //       cancelAction: 'حسناً',
                    //     ),
                    //   );
                    // }
                  },
                  title: 'تخطي',
                ),
                WeevoButton(
                  isStable: true,
                  color: weevoPrimaryOrangeColor,
                  onTap: authProvider.backIdImageLoading ||
                          authProvider.frontIdImageLoading
                      ? null
                      : () async {
                          // if (_nationalIdPhotoBackPath != null &&
                          //     _nationalIdPhotoFrontPath != null) {
                          //   setState(() {
                          //     _backIdImageHasError = false;
                          //     _frontIdImageHasError = false;
                          //   });
                          //   authProvider.setUserDataThree(
                          //     SignUpData(
                          //       nationalIdFront: '$_nationalIdPhotoFrontPath',
                          //       nationalIdBack: '$_nationalIdPhotoBackPath',
                          //     ),
                          //   );
                          //   authProvider.setLoading(true);
                          //   String res;
                          //   await authProvider.getFirebaseToken();
                          //   res = await authProvider.createNewUser(
                          //     WeevoUser(
                          //       firstName: authProvider.firstName,
                          //       lastName: authProvider.lastName,
                          //       phoneNumber: authProvider.userPhone,
                          //       emailAddress: authProvider.userEmail,
                          //       gender: authProvider.userGender,
                          //       password: authProvider.userPassword,
                          //       imageUrl: authProvider.userPhoto,
                          //       userFirebaseId: authProvider.userFirebaseId,
                          //       nationalIdNumber: authProvider.nationalIdNumber,
                          //       nationalIdFront:
                          //           authProvider.nationalIdPhotoFront,
                          //       nationalIdBack:
                          //           authProvider.nationalIdPhotoBack,
                          //       commercialActivityName:
                          //           authProvider.commercialActivity,
                          //       weevoPlanId: 1,
                          //       weevoPlusTrail: true,
                          //       firebaseNotificationToken:
                          //           authProvider.fcmToken,
                          //     ),
                          //   );
                          //   if (res == AuthProvider.success) {
                          //     await FirebaseFirestore.instance
                          //         .collection('merchant_users')
                          //         .doc(authProvider.userId.toString())
                          //         .set({
                          //       'id': authProvider.userId,
                          //       'email': authProvider.userEmail,
                          //       'name': '${authProvider.firstName} ${authProvider.lastName}',
                          //       'imageUrl': authProvider.userPhoto ?? '',
                          //       'fcmToken': authProvider.fcmToken,
                          //       'national_id': authProvider.nationalIdNumber,
                          //     });
                          //     await authProvider.verifyPhoneNumber();
                          //   } else {
                          //     authProvider.setLoading(false);
                          //     showDialog(
                          //       navigator.currentContext!,
                          //       builder: (context) => ActionDialog(
                          //         shape: RoundedRectangleBorder(
                          //           borderRadius: BorderRadius.circular(
                          //             20.0,
                          //           ),
                          //         ),
                          //         title: 'خطأ',
                          //         content: '$res',
                          //         onCancelClick: () {
                          //     magicRouter.pop();                          //         },
                          //         cancelAction: 'حسناً',
                          //       ),
                          //     );
                          //   }
                          // }
                          // else {
                          //   if (_backIdImg == null) {
                          //     setState(() {
                          //       _backIdImageHasError = true;
                          //     });
                          //   }
                          //   if (_frontIdImg == null) {
                          //     setState(() {
                          //       _frontIdImageHasError = true;
                          //     });
                          //   }
                          // }
                        },
                  title: 'التالي',
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
