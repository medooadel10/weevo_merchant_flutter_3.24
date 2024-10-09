import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../core/Dialogs/action_dialog.dart';
import '../../../core/Dialogs/gender_bottom_sheet.dart';
import '../../../core/Dialogs/image_picker_dialog.dart';
import '../../../core/Dialogs/loading.dart';
import '../../../core/Models/image.dart';
import '../../../core/Models/sign_up_data.dart';
import '../../../core/Models/user_type.dart';
import '../../../core/Models/weevo_user.dart';
import '../../../core/Providers/auth_provider.dart';
import '../../../core/Storage/shared_preference.dart';
import '../../../core/Utilits/colors.dart';
import '../../../core/Utilits/constants.dart';
import '../../../core/router/router.dart';
import '../../Widgets/edit_text.dart';
import '../../Widgets/image_container.dart';
import '../../Widgets/weevo_button.dart';
import '../../Widgets/weevo_checkbox.dart';

class SignUpPersonalInfo extends StatefulWidget {
  const SignUpPersonalInfo({super.key});

  @override
  State<SignUpPersonalInfo> createState() => _SignUpPersonalInfoState();
}

class _SignUpPersonalInfoState extends State<SignUpPersonalInfo> {
  late AuthProvider _authProvider;
  int? _imageCounter = 0, _selectedItem;
  Img? _img;
  late FocusNode _emailNode,
      _firstNameNode,
      _lastNameNode,
      _phoneNode,
      _genderNode,
      _passwordNode,
      _commercialActivityNode,
      _nationalIdNumberNode;
  late TextEditingController _emailController,
      _firstNameController,
      _lastNameController,
      _phoneController,
      _userTypeValueController,
      _userTypeNameController,
      _passwordController,
      _commercialActivityController,
      _nationalIdNumberController;
  bool _firstNameFocused = false;
  bool _lastNameFocused = false;
  bool _emailFocused = false;
  bool _phoneFocused = false;
  bool _genderFocused = false;
  bool _passwordFocused = false;
  bool _firstNameIsEmpty = true;
  bool _lastNameIsEmpty = true;
  bool _emailIsEmpty = true;
  bool _genderIsEmpty = true;
  bool _phoneIsEmpty = true;
  bool _passwordIsEmpty = true;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  String? userType,
      _imagePath,
      _firstName,
      _lastName,
      _emailAddress,
      _password,
      _phoneNumber;
  bool isError = false;
  bool isButtonPressed = false;
  bool _agreed = false;

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _emailNode = FocusNode();
    _firstNameNode = FocusNode();
    _lastNameNode = FocusNode();
    _phoneNode = FocusNode();
    _genderNode = FocusNode();
    _passwordNode = FocusNode();
    _commercialActivityNode = FocusNode();
    _nationalIdNumberNode = FocusNode();
    _emailController = TextEditingController();
    _userTypeValueController = TextEditingController();
    _userTypeNameController = TextEditingController();
    _passwordController = TextEditingController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _commercialActivityController = TextEditingController();
    _phoneController = TextEditingController();
    _nationalIdNumberController = TextEditingController();
    _emailController.addListener(() {
      setState(() {
        _emailIsEmpty = _emailController.text.isEmpty;
      });
    });
    _commercialActivityController.addListener(() {});
    _firstNameController.addListener(() {
      setState(() {
        _firstNameIsEmpty = _firstNameController.text.isEmpty;
      });
    });
    _lastNameController.addListener(() {
      setState(() {
        _lastNameIsEmpty = _lastNameController.text.isEmpty;
      });
    });
    _phoneController.addListener(() {
      setState(() {
        _phoneIsEmpty = _phoneController.text.isEmpty;
      });
    });
    _userTypeValueController.addListener(() {
      setState(() {
        _genderIsEmpty = _userTypeValueController.text.isEmpty;
      });
    });
    _nationalIdNumberController.addListener(() {});
    _passwordController.addListener(() {
      setState(() {
        _passwordIsEmpty = _passwordController.text.isEmpty;
      });
    });
    _emailNode.addListener(() {
      setState(() {
        _emailFocused = _emailNode.hasFocus;
      });
    });
    _genderNode.addListener(() {
      setState(() {
        _genderFocused = _genderNode.hasFocus;
      });
    });
    _nationalIdNumberNode.addListener(() {});
    _passwordNode.addListener(() {
      setState(() {
        _passwordFocused = _passwordNode.hasFocus;
      });
    });
    _commercialActivityNode.addListener(() {});
    _phoneNode.addListener(() {
      setState(() {
        _phoneFocused = _phoneNode.hasFocus;
      });
    });
    _firstNameNode.addListener(() {
      setState(() {
        _firstNameFocused = _firstNameNode.hasFocus;
      });
    });
    _lastNameNode.addListener(() {
      setState(() {
        _lastNameFocused = _lastNameNode.hasFocus;
      });
    });
    _phoneController.text = _authProvider.userPhone ?? '';
    _firstNameController.text = _authProvider.firstName ?? '';
    _lastNameController.text = _authProvider.lastName ?? '';
    _emailController.text = _authProvider.userEmail ?? '';
    _commercialActivityController.text = _authProvider.commercialActivity ?? '';
    _passwordController.text = _authProvider.userPassword ?? '';
    _nationalIdNumberController.text = _authProvider.nationalIdNumber ?? '';
    _imagePath = _authProvider.userPhoto;
    _emailIsEmpty = _emailController.text.isEmpty;
    _firstNameIsEmpty = _firstNameController.text.isEmpty;
    _lastNameIsEmpty = _lastNameController.text.isEmpty;
    _phoneIsEmpty = _phoneController.text.isEmpty;
    _genderIsEmpty = _userTypeValueController.text.isEmpty;
    _passwordIsEmpty = _passwordController.text.isEmpty;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _userTypeValueController.dispose();
    _userTypeNameController.dispose();
    _phoneController.dispose();
    _commercialActivityController.dispose();
    _phoneNode.dispose();
    _emailNode.dispose();
    _firstNameNode.dispose();
    _lastNameNode.dispose();
    _commercialActivityNode.dispose();
    _genderNode.dispose();
    _passwordNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ImageContainer(
            isLoading: authProvider.isImageLoading,
            imagePath: _imagePath ?? '',
            onImagePressed: () {
              !authProvider.isImageLoading
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
                            onImageReceived: (XFile? imageFile) async {
                              if (imageFile == null) return;
                              _imageCounter = _imageCounter! + 1;
                              MagicRouter.pop();
                              authProvider.setImageLoading(true);
                              File? compressedImage =
                                  await compressFile(imageFile.path);
                              if (_imageCounter! > 1) {
                                _img = await authProvider.uploadPhoto(
                                  path: base64Encode(
                                      await compressedImage!.readAsBytes()),
                                  imageName: imageFile.path.split('/').last,
                                );
                              } else {
                                _img = await authProvider.uploadPhoto(
                                  path: base64Encode(
                                      await compressedImage!.readAsBytes()),
                                  imageName: imageFile.path.split('/').last,
                                );
                              }
                              setState(
                                () => _imagePath = imageFile.path,
                              );
                              authProvider.setImageLoading(false);
                            },
                          ))
                  : Container();
            },
          ),
          SizedBox(
            height: 10.h,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Form(
                key: formState,
                child: AutofillGroup(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: EditText(
                              autofillHints: const [AutofillHints.givenName],
                              readOnly: false,
                              controller: _firstNameController,
                              upperTitle: true,
                              shouldDisappear:
                                  !_firstNameIsEmpty && !_firstNameFocused,
                              action: TextInputAction.next,
                              onFieldSubmit: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_lastNameNode);
                              },
                              isPhoneNumber: false,
                              onChange: (String? v) {
                                isButtonPressed = false;
                                if (isError) {
                                  formState.currentState!.validate();
                                }
                              },
                              isPassword: false,
                              isFocus: _firstNameFocused,
                              focusNode: _firstNameNode,
                              validator: (String? output) {
                                if (!isButtonPressed) {
                                  return null;
                                }
                                isError = true;
                                if (output!.isEmpty) {
                                  return 'الأسم الأول';
                                }
                                isError = false;
                                return null;
                              },
                              onSave: (String? saved) {
                                _firstName = saved;
                              },
                              labelText: 'الاسم الاول',
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.03,
                          ),
                          Expanded(
                            child: EditText(
                              autofillHints: const [AutofillHints.familyName],
                              readOnly: false,
                              controller: _lastNameController,
                              upperTitle: true,
                              shouldDisappear:
                                  !_lastNameIsEmpty && !_lastNameFocused,
                              action: TextInputAction.next,
                              onChange: (String? v) {
                                isButtonPressed = false;
                                if (isError) {
                                  formState.currentState!.validate();
                                }
                              },
                              onFieldSubmit: (_) {
                                FocusScope.of(context).requestFocus(_emailNode);
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
                                  return 'الأسم الأخير';
                                }
                                isError = false;
                                return null;
                              },
                              onSave: (String? saved) {
                                _lastName = saved;
                              },
                              labelText: 'الاسم الاخير',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0.h,
                      ),
                      EditText(
                        autofillHints: const [AutofillHints.email],
                        readOnly: false,
                        controller: _emailController,
                        upperTitle: true,
                        shouldDisappear: !_emailIsEmpty && !_emailFocused,
                        action: TextInputAction.next,
                        onChange: (String? v) {
                          isButtonPressed = false;
                          if (isError) {
                            formState.currentState!.validate();
                          }
                        },
                        onFieldSubmit: (_) {
                          FocusScope.of(context).unfocus();
                        },
                        isPhoneNumber: false,
                        type: TextInputType.emailAddress,
                        isPassword: false,
                        isFocus: _emailFocused,
                        focusNode: _emailNode,
                        validator: (String? output) {
                          if (!isButtonPressed) {
                            return null;
                          }
                          isError = true;
                          if (!validateUserEmail(output!)) {
                            return emailValidatorMessage;
                          }
                          isError = false;
                          return null;
                        },
                        onSave: (String? saved) {
                          _emailAddress = saved;
                        },
                        labelText: 'البريد الالكتروني',
                      ),
                      SizedBox(
                        height: 10.0.h,
                      ),
                      EditText(
                        readOnly: false,
                        controller: _phoneController,
                        upperTitle: true,
                        shouldDisappear: !_phoneIsEmpty && !_phoneFocused,
                        action: TextInputAction.done,
                        onFieldSubmit: (_) {
                          FocusScope.of(context).unfocus();
                        },
                        onChange: (String? v) {
                          isButtonPressed = false;
                          if (isError) {
                            formState.currentState!.validate();
                          }
                        },
                        isPhoneNumber: true,
                        type: TextInputType.phone,
                        isPassword: false,
                        isFocus: _phoneFocused,
                        focusNode: _phoneNode,
                        validator: (String? output) {
                          if (!isButtonPressed) {
                            return null;
                          }
                          isError = true;
                          if (output!.trim().length < 11) {
                            return phoneValidatorMessage;
                          }
                          isError = false;
                          return null;
                        },
                        onSave: (String? saved) {
                          _phoneNumber = saved;
                        },
                        labelText: 'رقم الهاتف',
                      ),
                      SizedBox(
                        height: 10.0.h,
                      ),
                      EditText(
                        readOnly: true,
                        upperTitle: true,
                        labelText: 'نوع المستخدم',
                        onChange: (String? v) {
                          isButtonPressed = false;
                          if (isError) {
                            formState.currentState!.validate();
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
                            builder: (_) {
                              FocusScope.of(navigator.currentContext!)
                                  .requestFocus(_genderNode);
                              return GenderBottomSheet(
                                onItemClick: (UserTypeModel item, int i) {
                                  log(item.toString());
                                  setState(() {
                                    _selectedItem = i;
                                    _userTypeValueController.text = item.value;
                                    _userTypeNameController.text = item.title;
                                    Navigator.pop(navigator.currentContext!);
                                  });
                                },
                                selectedItem: _selectedItem ?? 0,
                              );
                            },
                          );
                          _genderNode.unfocus();
                        },
                        shouldDisappear: !_genderIsEmpty && !_genderFocused,
                        controller: _userTypeNameController,
                        isPassword: false,
                        isPhoneNumber: false,
                        validator: (String? value) {
                          if (!isButtonPressed) {
                            return null;
                          }
                          isError = true;
                          if (value!.isEmpty) {
                            return 'من فضلك اختر نوع المستخدم';
                          }
                          isError = false;
                          return null;
                        },
                        focusNode: _genderNode,
                        isFocus: _genderFocused,
                      ),
                      SizedBox(
                        height: 10.0.h,
                      ),
                      // EditText(
                      //   readOnly: false,
                      //   controller: _nationalIdNumberController,
                      //   upperTitle: true,
                      //   type: TextInputType.number,
                      //   shouldDisappear: !_nationalIdNumberEmpty &&
                      //       !_nationalIdNumberFocused,
                      //   action: TextInputAction.next,
                      //   onFieldSubmit: (_) {
                      //     FocusScope.of(context)
                      //         .requestFocus(_commercialActivityNode);
                      //   },
                      //   onChange: (String v) {
                      //     isButtonPressed = false;
                      //     if (isError) {
                      //       formState.currentState.validate();
                      //     }
                      //   },
                      //   isPhoneNumber: false,
                      //   isPassword: false,
                      //   maxLength: 14,
                      //   isFocus: _nationalIdNumberFocused,
                      //   focusNode: _nationalIdNumberNode,
                      //   validator: (String output) {
                      //     if (!isButtonPressed) {
                      //       return null;
                      //     }
                      //     isError = true;
                      //     if (output.isEmpty) {
                      //       return nationalIdNumberValidatorMessage;
                      //     }
                      //     isError = false;
                      //   },
                      //   onSave: (String saved) {
                      //     _nationalIdNumber = saved;
                      //   },
                      //   labelText: 'الرقم القومي',
                      // ),
                      // SizedBox(
                      //   height: 10.0.h,
                      // ),
                      // EditText(
                      //   readOnly: false,
                      //   controller: _commercialActivityController,
                      //   upperTitle: true,
                      //   type: TextInputType.text,
                      //   shouldDisappear: !_commercialActivityEmpty &&
                      //       !_commercialActivityFocused,
                      //   action: TextInputAction.next,
                      //   onFieldSubmit: (_) {
                      //     FocusScope.of(context).requestFocus(_passwordNode);
                      //   },
                      //   onChange: (String v) {
                      //     isButtonPressed = false;
                      //     if (isError) {
                      //       formState.currentState.validate();
                      //     }
                      //   },
                      //   isPhoneNumber: false,
                      //   isPassword: false,
                      //   isFocus: _commercialActivityFocused,
                      //   focusNode: _commercialActivityNode,
                      //   validator: (String output) {
                      //     if (!isButtonPressed) {
                      //       return null;
                      //     }
                      //     isError = true;
                      //     if (output.isEmpty) {
                      //       return commercialActivity;
                      //     }
                      //     isError = false;
                      //   },
                      //   onSave: (String saved) {
                      //     _commercialActivity = saved;
                      //   },
                      //   labelText: 'أسم نشاطك التجاري',
                      // ),
                      // SizedBox(height: 10.h),
                      EditText(
                        readOnly: false,
                        controller: _passwordController,
                        upperTitle: true,
                        shouldDisappear: !_passwordIsEmpty && !_passwordFocused,
                        action: TextInputAction.done,
                        isPhoneNumber: false,
                        type: TextInputType.visiblePassword,
                        isPassword: true,
                        onFieldSubmit: (String? v) {
                          FocusScope.of(context).unfocus();
                        },
                        onChange: (String? v) {
                          isButtonPressed = false;
                          if (isError) {
                            formState.currentState!.validate();
                          }
                        },
                        isFocus: _passwordFocused,
                        focusNode: _passwordNode,
                        validator: (String? output) {
                          if (!isButtonPressed) {
                            return null;
                          }
                          isError = true;
                          if (output!.length < 6) {
                            return passwordValidatorMessage;
                          }
                          isError = false;
                          return null;
                        },
                        onSave: (String? saved) {
                          _password = saved;
                        },
                        labelText: 'كلمة السر',
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      WeevoCheckbox(
                        content: 'أوافق علي سياسة الخصوصية والشروط والأحكام',
                        onCheck: (bool v) {
                          _agreed = v;
                        },
                        value: _agreed,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          WeevoButton(
            isStable: false,
            color: weevoPrimaryOrangeColor,
            onTap: authProvider.isImageLoading
                ? null
                : () async {
                    isButtonPressed = true;
                    FocusScope.of(context).unfocus();
                    if (formState.currentState!.validate()) {
                      formState.currentState!.save();
                      if (_agreed) {
                        showDialog(
                            context: navigator.currentContext!,
                            barrierDismissible: false,
                            builder: (context) => const Loading());
                        if (await authProvider
                                .checkEmailExisted(_emailAddress!) &&
                            authProvider.existedState == NetworkState.SUCCESS) {
                          MagicRouter.pop();
                          showDialog(
                              context: navigator.currentContext!,
                              barrierDismissible: false,
                              builder: (ctx) => ActionDialog(
                                    content: 'الإيميل موجود بالفعل',
                                    onApproveClick: () {
                                      MagicRouter.pop();
                                    },
                                    approveAction: 'حسناً',
                                  ));
                        } else if (await authProvider
                                .checkPhoneExisted(_phoneNumber!) &&
                            authProvider.existedState == NetworkState.SUCCESS) {
                          MagicRouter.pop();
                          showDialog(
                              context: navigator.currentContext!,
                              barrierDismissible: false,
                              builder: (ctx) => ActionDialog(
                                    content: 'الهاتف موجود بالفعل',
                                    onApproveClick: () {
                                      MagicRouter.pop();
                                    },
                                    approveAction: 'حسناً',
                                  ));
                        } else {
                          MagicRouter.pop();
                          authProvider.setUserDataOne(
                            SignUpData(
                              firstName: _firstName,
                              lastName: _lastName,
                              phone: _phoneNumber,
                              email: _emailAddress,
                              userType: _userTypeValueController.text,
                              password: _password,
                              photo: _img!.path,
                              // nationalIdNumber: _nationalIdNumber,
                              // commercialActivity: _commercialActivity,
                            ),
                          );

                          authProvider.setLoading(true);
                          await authProvider.getFirebaseToken();
                          authProvider.createNewUser(
                            WeevoUser(
                              firstName: authProvider.firstName,
                              lastName: authProvider.lastName,
                              phoneNumber: authProvider.userPhone,
                              emailAddress: authProvider.userEmail,
                              type: _userTypeValueController.text,
                              password: authProvider.userPassword,
                              imageUrl: authProvider.userPhoto,
                              userFirebaseId: authProvider.userFirebaseId,
                              // nationalIdNumber: authProvider.nationalIdNumber,
                              // commercialActivityName: authProvider.commercialActivity,
                              weevoPlanId: 1,
                              weevoPlusTrail: true,
                              firebaseNotificationToken: authProvider.fcmToken,
                            ),
                          );
                        }
                      } else {
                        showDialog(
                            context: navigator.currentContext!,
                            barrierDismissible: false,
                            builder: (ctx) => ActionDialog(
                                  content:
                                      'عليك الموافقة علي سياسة الخصوصية\nوالشروط والأحكام الخاصة بويفو',
                                  onApproveClick: () {
                                    MagicRouter.pop();
                                  },
                                  approveAction: 'حسناً',
                                ));
                      }
                    }
                  },
            title: 'التالي',
          ),
        ],
      ),
    );
  }
}
