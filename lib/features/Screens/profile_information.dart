import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';
import 'package:weevo_merchant_upgrade/core/Models/user_type.dart';

import '../../core/Dialogs/action_dialog.dart';
import '../../core/Dialogs/gender_bottom_sheet.dart';
import '../../core/Dialogs/image_picker_dialog.dart';
import '../../core/Models/image.dart';
import '../../core/Providers/auth_provider.dart';
import '../../core/Providers/update_provider.dart';
import '../../core/Storage/shared_preference.dart';
import '../../core/Utilits/colors.dart';
import '../../core/Utilits/constants.dart';
import '../../core/router/router.dart';
import '../Widgets/edit_text.dart';
import '../Widgets/image_container.dart';
import '../Widgets/loading_widget.dart';

class ProfileInformation extends StatefulWidget {
  static const String id = 'Profile Information';

  const ProfileInformation({super.key});

  @override
  State<ProfileInformation> createState() => _ProfileInformationState();
}

class _ProfileInformationState extends State<ProfileInformation> {
  late AuthProvider _authProvider;
  int _imageCounter = 0;
  Img? _img, _oldImage;
  String? _dateTime, _firstName, _lastName, _imagePath;
  late FocusNode _firstNameNode,
      _lastNameNode,
      _genderNode,
      _commercialActivityNode;
  late TextEditingController _firstNameController,
      _commercialActivityController,
      _lastNameController,
      _genderController,
      _dateTimeController;
  bool _firstNameFocused = false;
  bool _lastNameFocused = false;
  bool _genderFocused = false;
  bool _commercialActivityFocused = false;
  bool _dateTimeEmpty = true;
  bool _genderEmpty = true;
  bool _commercialActivityEmpty = true;
  bool _firstNameEmpty = true;
  bool _lastNameEmpty = true;
  int? _selectedItem;
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  bool isError = false;
  bool isButtonPressed = false;

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _firstNameNode = FocusNode();
    _lastNameNode = FocusNode();
    _genderNode = FocusNode();
    _commercialActivityNode = FocusNode();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _dateTimeController = TextEditingController();
    _genderController = TextEditingController();
    _commercialActivityController = TextEditingController();
    _firstNameNode.addListener(() {
      setState(() {
        _firstNameFocused = _firstNameNode.hasFocus;
      });
    });
    _commercialActivityNode.addListener(() {
      setState(() {
        _commercialActivityFocused = _commercialActivityNode.hasFocus;
      });
    });
    _lastNameNode.addListener(() {
      setState(() {
        _lastNameFocused = _lastNameNode.hasFocus;
      });
    });
    _genderNode.addListener(() {
      setState(() {
        _genderFocused = _genderNode.hasFocus;
      });
    });
    _firstNameController.addListener(() {
      setState(() {
        _firstNameEmpty = _firstNameController.text.isEmpty;
      });
    });
    _lastNameController.addListener(() {
      setState(() {
        _lastNameEmpty = _lastNameController.text.isEmpty;
      });
    });
    _commercialActivityController.addListener(() {
      setState(() {
        _commercialActivityEmpty = _commercialActivityController.text.isEmpty;
      });
    });
    _genderController.addListener(() {
      setState(() {
        _genderEmpty = _genderController.text.isEmpty;
      });
    });
    _dateTimeController.addListener(() {
      setState(() {
        _dateTimeEmpty = _dateTimeController.text.isEmpty;
      });
    });
    _dateTimeController.text = _authProvider.dateOfBirth!;
    _firstNameController.text = _authProvider.name!.split(' ')[0];
    _lastNameController.text = _authProvider.name!.split(' ')[1];
    _dateTimeEmpty = _dateTimeController.text.isEmpty;
    _firstNameEmpty = _firstNameController.text.isEmpty;
    _lastNameEmpty = _lastNameController.text.isEmpty;
    _genderEmpty = _genderController.text.isEmpty;
    _imagePath = _authProvider.photo;
    _selectedItem = genders.indexOf(_genderController.text);
  }

  @override
  void dispose() {
    _firstNameNode.dispose();
    _lastNameNode.dispose();
    _genderNode.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _genderController.dispose();
    _dateTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final UpdateProfileProvider updateProfileProvider =
        Provider.of<UpdateProfileProvider>(context);
    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
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
            'معلومات الحساب',
          ),
        ),
        body: LoadingWidget(
          isLoading: updateProfileProvider.updatePersonalInfoState ==
              NetworkState.WAITING,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(
                16.0,
              ),
              child: Form(
                key: _formState,
                child: AutofillGroup(
                  child: Column(
                    children: [
                      ImageContainer(
                        isLoading: updateProfileProvider.profileImageLoading,
                        imagePath: _imagePath!,
                        onImagePressed: () {
                          if (_img != null) {
                            _oldImage = _img;
                          }
                          !updateProfileProvider.profileImageLoading
                              ? showModalBottomSheet(
                                  context: navigator.currentContext!,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(
                                        20.0,
                                      ),
                                      topLeft: Radius.circular(
                                        20.0,
                                      ),
                                    ),
                                  ),
                                  builder: (_) => ImagePickerDialog(
                                        onImageReceived:
                                            (XFile? imageFile) async {
                                          if (imageFile == null) return;
                                          _imageCounter++;
                                          MagicRouter.pop();
                                          updateProfileProvider
                                              .setImageLoading(true);
                                          File? compressedImage =
                                              await compressFile(
                                                  imageFile.path);
                                          if (compressedImage == null) {
                                            return;
                                          }
                                          if (_imageCounter > 1) {
                                            await authProvider.deletePhoto(
                                              token: _oldImage!.token!,
                                              imageName: _oldImage!.filename!,
                                            );
                                            _img =
                                                await authProvider.uploadPhoto(
                                              path: base64Encode(
                                                  await compressedImage
                                                      .readAsBytes()),
                                              imageName: imageFile.path
                                                  .split('/')
                                                  .last,
                                            );
                                          } else {
                                            _img =
                                                await authProvider.uploadPhoto(
                                              path: base64Encode(
                                                  await compressedImage
                                                      .readAsBytes()),
                                              imageName: imageFile.path
                                                  .split('/')
                                                  .last,
                                            );
                                          }
                                          setState(
                                            () => _imagePath = imageFile.path,
                                          );
                                          updateProfileProvider
                                              .setImageLoading(false);
                                        },
                                      ))
                              : Container();
                        },
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      EditText(
                        readOnly: false,
                        radius: 16,
                        controller: _firstNameController,
                        autofillHints: const [AutofillHints.givenName],
                        upperTitle: true,
                        onChange: (String? value) {
                          isButtonPressed = false;
                          if (isError) {
                            _formState.currentState!.validate();
                          }
                          setState(
                            () {
                              _firstNameEmpty = value!.isEmpty;
                            },
                          );
                        },
                        shouldDisappear: !_firstNameEmpty && !_firstNameFocused,
                        action: TextInputAction.done,
                        onFieldSubmit: (_) {
                          FocusScope.of(context).unfocus();
                        },
                        isPhoneNumber: false,
                        isPassword: false,
                        isFocus: _firstNameFocused,
                        focusNode: _firstNameNode,
                        validator: (String? output) {
                          if (!isButtonPressed) {
                            return null;
                          }
                          isError = true;
                          if (output!.isEmpty) {
                            return 'ادخل الاسم الاول';
                          }
                          isError = false;
                          return null;
                        },
                        onSave: (String? saved) {
                          _firstName = saved;
                        },
                        labelText: 'الاسم الأول',
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      EditText(
                        readOnly: false,
                        controller: _lastNameController,
                        upperTitle: true,
                        autofillHints: const [AutofillHints.familyName],
                        radius: 16,
                        onChange: (String? value) {
                          isButtonPressed = false;
                          if (isError) {
                            _formState.currentState!.validate();
                          }
                          setState(() {
                            _lastNameEmpty = value!.isEmpty;
                          });
                        },
                        shouldDisappear: !_lastNameEmpty && !_lastNameFocused,
                        action: TextInputAction.done,
                        onFieldSubmit: (_) {
                          FocusScope.of(context).unfocus();
                        },
                        isPhoneNumber: false,
                        isPassword: false,
                        isFocus: _lastNameFocused,
                        focusNode: _lastNameNode,
                        validator: (String? output) {
                          if (!isButtonPressed) {
                            return null;
                          }
                          isError = true;
                          if (output!.isEmpty) {
                            return 'ادخل الاسم الاخير';
                          }
                          isError = false;
                          return null;
                        },
                        onSave: (String? saved) {
                          _lastName = saved;
                        },
                        labelText: 'الاسم الأخير',
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      EditText(
                        readOnly: false,
                        radius: 16,
                        controller: _commercialActivityController,
                        upperTitle: true,
                        onChange: (String? value) {
                          isButtonPressed = false;
                          if (isError) {
                            _formState.currentState!.validate();
                          }
                          setState(
                            () {
                              _commercialActivityEmpty = value!.isEmpty;
                            },
                          );
                        },
                        shouldDisappear: !_commercialActivityEmpty &&
                            !_commercialActivityFocused,
                        action: TextInputAction.done,
                        onFieldSubmit: (_) {
                          FocusScope.of(context).unfocus();
                        },
                        isPhoneNumber: false,
                        isPassword: false,
                        isFocus: _commercialActivityFocused,
                        focusNode: _commercialActivityNode,
                        validator: (String? output) {
                          if (!isButtonPressed) {
                            return null;
                          }
                          isError = true;
                          if (output!.isEmpty) {
                            return 'ادخل نشاطك التجاري';
                          }
                          isError = false;
                          return null;
                        },
                        onSave: (String? saved) {},
                        labelText: 'نشاطك التجاري',
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      EditText(
                        readOnly: true,
                        upperTitle: true,
                        labelText: 'تاريخ الميلاد',
                        shouldDisappear: !_dateTimeEmpty && true,
                        controller: _dateTimeController,
                        isPassword: false,
                        isPhoneNumber: false,
                        onChange: (String? v) {
                          isButtonPressed = false;
                          if (isError) {
                            _formState.currentState!.validate();
                          }
                        },
                        validator: (String? value) {
                          if (!isButtonPressed) {
                            return null;
                          }
                          isError = true;
                          if (value!.isEmpty) {
                            return 'من فضلك أدخل تاريخ الميلاد';
                          }
                          isError = false;
                          return null;
                        },
                        onSave: (String? value) {
                          _dateTime = value;
                        },
                        focusNode: null,
                        isFocus: false,
                        onTap: () async {
                          DateTime? dt = await showDatePicker(
                            context: navigator.currentContext!,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1919),
                            lastDate: DateTime.now(),
                            builder: (BuildContext ctx, Widget? child) {
                              return Theme(
                                data: ThemeData.light().copyWith(
                                  dialogTheme: DialogTheme(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        25.0,
                                      ),
                                    ),
                                  ),
                                  colorScheme: const ColorScheme.light(
                                    primary: weevoPrimaryOrangeColor,
                                    onPrimary: Colors.white,
                                    surface: Colors.white,
                                    onSurface: weevoPrimaryOrangeColor,
                                  ),
                                  dialogBackgroundColor: Colors.white,
                                ),
                                child: child ?? Container(),
                              );
                            },
                          );
                          if (dt == null) return;
                          final dateTime = DateTime(
                            dt.year,
                            dt.month,
                            dt.day,
                          );
                          _dateTime =
                              intl.DateFormat('yyyy-MM-dd').format(dateTime);
                          _dateTimeController.text = _dateTime!;
                        },
                      ),
                      SizedBox(
                        height: 10.0.h,
                      ),
                      EditText(
                        readOnly: true,
                        upperTitle: true,
                        labelText: 'النوع',
                        onChange: (String? v) {
                          isButtonPressed = false;
                          if (isError) {
                            _formState.currentState!.validate();
                          }
                        },
                        onTap: () async {
                          await showModalBottomSheet(
                            context: navigator.currentContext!,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(25.0),
                                topLeft: Radius.circular(25.0),
                              ),
                            ),
                            builder: (ctx) {
                              FocusScope.of(context).requestFocus(_genderNode);
                              return GenderBottomSheet(
                                onItemClick: (UserTypeModel item, int i) {
                                  setState(() {
                                    _selectedItem = i;
                                    _genderController.text = item.title;
                                    _genderEmpty =
                                        _genderController.text.isEmpty;
                                    Navigator.pop(ctx);
                                  });
                                },
                                selectedItem: _selectedItem ?? 0,
                              );
                            },
                          );
                          _genderNode.unfocus();
                        },
                        shouldDisappear: !_genderEmpty && !_genderFocused,
                        controller: _genderController,
                        isPassword: false,
                        isPhoneNumber: false,
                        validator: (String? value) {
                          if (!isButtonPressed) {
                            return null;
                          }
                          isError = true;
                          if (value!.isEmpty) {
                            return 'من فضلك اختر النوع';
                          }
                          isError = false;
                          return null;
                        },
                        onSave: (String? value) {},
                        focusNode: _genderNode,
                        isFocus: _genderFocused,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      TextButton(
                        style: ButtonStyle(
                          minimumSize: WidgetStateProperty.all<Size>(
                            Size(
                              size.width,
                              30.h,
                            ),
                          ),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          backgroundColor: WidgetStateProperty.all<Color>(
                            weevoPrimaryBlueColor,
                          ),
                        ),
                        onPressed: updateProfileProvider.profileImageLoading
                            ? null
                            : () async {
                                isButtonPressed = true;
                                if (_formState.currentState!.validate()) {
                                  authProvider.setLoading(true);
                                  _formState.currentState!.save();
                                  await updateProfileProvider
                                      .updatePersonalInfo(
                                    firstName: _firstName!,
                                    lastName: _lastName!,
                                    photo: _img != null
                                        ? _img!.path!
                                        : _imagePath!,
                                    currentPassword: authProvider.password!,
                                  );
                                  await authProvider.updateUser(
                                    updateProfileProvider.updatedUser!,
                                  );
                                  if (updateProfileProvider
                                          .updatePersonalInfoState ==
                                      NetworkState.SUCCESS) {
                                    await FirebaseFirestore.instance
                                        .collection('merchant_users')
                                        .doc(authProvider.id)
                                        .update({
                                      'id': authProvider.id,
                                      'email': authProvider.email,
                                      'name': authProvider.name,
                                      'imageUrl': '${authProvider.photo}',
                                      'fcmToken': authProvider.fcmToken,
                                    });
                                    authProvider.setLoading(false);
                                    showDialog(
                                      context: navigator.currentContext!,
                                      builder: (context) => ActionDialog(
                                        content:
                                            'تم تغيير معلومات الحساب بنجاح',
                                        onCancelClick: () {
                                          MagicRouter.pop();
                                          MagicRouter.pop();
                                        },
                                        cancelAction: 'حسناً',
                                      ),
                                    );
                                  } else if (updateProfileProvider
                                          .updatePersonalInfoState ==
                                      NetworkState.LOGOUT) {
                                    check(
                                        auth: authProvider,
                                        ctx: navigator.currentContext!,
                                        state: updateProfileProvider
                                            .updatePersonalInfoState!);
                                  }
                                }
                              },
                        child: const Text(
                          'حفظ',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
