import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/Dialogs/action_dialog.dart';
import '../../core/Providers/auth_provider.dart';
import '../../core/Providers/update_provider.dart';
import '../../core/Storage/shared_preference.dart';
import '../../core/Utilits/colors.dart';
import '../../core/Utilits/constants.dart';
import '../../core_new/router/router.dart';
import '../Widgets/edit_text.dart';
import '../Widgets/loading_widget.dart';
import '../Widgets/weevo_button.dart';

class ChangeYourPassword extends StatefulWidget {
  static const String id = 'Change Password';

  const ChangeYourPassword({super.key});

  @override
  State<ChangeYourPassword> createState() => _ChangeYourPasswordState();
}

class _ChangeYourPasswordState extends State<ChangeYourPassword> {
  late FocusNode _yourCurrentPasswordNode,
      _yourNewPasswordNode,
      _retypeYourNewPasswordNode;
  late TextEditingController _yourNewPasswordController,
      _retypeYourNewPasswordController,
      _yourCurrentPasswordController;
  bool _yourNewPasswordFocused = false;
  bool _retypeYourNewPasswordFocused = false;
  bool _yourCurrentPasswordFocused = false;
  bool _yourNewPasswordEmpty = true;
  bool _retypeYourNewPasswordEmpty = true;
  bool _yourCurrentPasswordEmpty = true;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  String? _retypeNewPassword;
  bool isError = false;
  bool isButtonPressed = false;

  @override
  void initState() {
    super.initState();
    _yourCurrentPasswordNode = FocusNode();
    _yourNewPasswordNode = FocusNode();
    _retypeYourNewPasswordNode = FocusNode();
    _yourNewPasswordController = TextEditingController();
    _retypeYourNewPasswordController = TextEditingController();
    _yourCurrentPasswordController = TextEditingController();
    _yourCurrentPasswordNode.addListener(() {
      setState(() {
        _yourCurrentPasswordFocused = _yourCurrentPasswordNode.hasFocus;
      });
    });
    _yourNewPasswordNode.addListener(() {
      setState(() {
        _yourNewPasswordFocused = _yourNewPasswordNode.hasFocus;
      });
    });
    _retypeYourNewPasswordNode.addListener(() {
      setState(() {
        _retypeYourNewPasswordFocused = _retypeYourNewPasswordNode.hasFocus;
      });
    });
    _yourNewPasswordEmpty = _yourNewPasswordController.text.isEmpty;
    _retypeYourNewPasswordEmpty = _retypeYourNewPasswordController.text.isEmpty;
    _yourCurrentPasswordEmpty = _yourCurrentPasswordController.text.isEmpty;
  }

  @override
  void dispose() {
    _yourCurrentPasswordNode.dispose();
    _yourNewPasswordNode.dispose();
    _retypeYourNewPasswordNode.dispose();
    _yourNewPasswordController.dispose();
    _retypeYourNewPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final UpdateProfileProvider updateProvider =
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
            'تغير كلمة المرور',
          ),
        ),
        body: LoadingWidget(
          isLoading: updateProvider.updatePasswordState == NetworkState.WAITING,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(
                16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Form(
                    key: formState,
                    child: Column(
                      children: [
                        EditText(
                          readOnly: false,
                          controller: _yourCurrentPasswordController,
                          upperTitle: true,
                          onChange: (String? value) {
                            isButtonPressed = false;
                            if (isError) {
                              formState.currentState!.validate();
                            }
                            setState(() {
                              _yourCurrentPasswordEmpty = value!.isEmpty;
                            });
                          },
                          shouldDisappear: !_yourCurrentPasswordEmpty &&
                              !_yourCurrentPasswordFocused,
                          action: TextInputAction.done,
                          onFieldSubmit: (_) {
                            FocusScope.of(context)
                                .requestFocus(_yourNewPasswordNode);
                          },
                          type: TextInputType.emailAddress,
                          isPhoneNumber: false,
                          isPassword: true,
                          isFocus: _yourCurrentPasswordFocused,
                          focusNode: _yourCurrentPasswordNode,
                          validator: (String? output) {
                            if (!isButtonPressed) {
                              return null;
                            }
                            isError = true;
                            if (output!.length < 6 ||
                                output != authProvider.password) {
                              return passwordValidatorMessage;
                            }
                            isError = false;
                            return null;
                          },
                          onSave: (String? saved) {},
                          labelText: 'كلمة المرور الحالية',
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        EditText(
                          readOnly: false,
                          controller: _yourNewPasswordController,
                          upperTitle: true,
                          onChange: (String? value) {
                            isButtonPressed = false;
                            if (isError) {
                              formState.currentState!.validate();
                            }
                            setState(() {
                              _yourNewPasswordEmpty = value!.isEmpty;
                            });
                          },
                          shouldDisappear: !_yourNewPasswordEmpty &&
                              !_yourNewPasswordFocused,
                          action: TextInputAction.done,
                          onFieldSubmit: (_) {
                            FocusScope.of(context)
                                .requestFocus(_retypeYourNewPasswordNode);
                          },
                          type: TextInputType.visiblePassword,
                          isPhoneNumber: false,
                          isPassword: true,
                          isFocus: _yourNewPasswordFocused,
                          focusNode: _yourNewPasswordNode,
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
                          onSave: (String? saved) {},
                          labelText: 'كلمة المرور الجديدة',
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        EditText(
                          readOnly: false,
                          controller: _retypeYourNewPasswordController,
                          upperTitle: true,
                          onChange: (String? value) {
                            isButtonPressed = false;
                            if (isError) {
                              formState.currentState!.validate();
                            }
                            setState(() {
                              _retypeYourNewPasswordEmpty = value!.isEmpty;
                            });
                          },
                          shouldDisappear: !_retypeYourNewPasswordEmpty &&
                              !_retypeYourNewPasswordFocused,
                          action: TextInputAction.done,
                          onFieldSubmit: (_) {
                            _retypeYourNewPasswordNode.unfocus();
                          },
                          type: TextInputType.visiblePassword,
                          isPhoneNumber: false,
                          isPassword: true,
                          isFocus: _retypeYourNewPasswordFocused,
                          focusNode: _retypeYourNewPasswordNode,
                          validator: (String? output) {
                            if (!isButtonPressed) {
                              return null;
                            }
                            isError = true;
                            if (output!.length < 6 ||
                                output != _yourNewPasswordController.text) {
                              return passwordValidatorMessage;
                            }
                            isError = false;
                            return null;
                          },
                          onSave: (String? saved) {
                            _retypeNewPassword = saved;
                          },
                          labelText: 'اعد كتابة كلمة المرور الجديدة',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  WeevoButton(
                    isStable: true,
                    color: weevoPrimaryOrangeColor,
                    onTap: () async {
                      isButtonPressed = true;
                      if (formState.currentState!.validate()) {
                        formState.currentState!.save();
                        await updateProvider.updatePassword(
                          password: _retypeNewPassword!,
                          currentPassword: authProvider.password!,
                        );
                        if (updateProvider.updatePasswordState ==
                            NetworkState.SUCCESS) {
                          await authProvider
                              .updatePassword(_retypeNewPassword!);
                          showDialog(
                            context: navigator.currentContext!,
                            builder: (context) => ActionDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  20.0,
                                ),
                              ),
                              content: 'تم تغيير كلمة السر بنجاح',
                              onCancelClick: () {
                                MagicRouter.pop();
                                MagicRouter.pop();
                              },
                              cancelAction: 'حسناً',
                            ),
                          );
                        } else if (updateProvider.updatePasswordState ==
                            NetworkState.LOGOUT) {
                          check(
                              auth: authProvider,
                              state: updateProvider.updatePasswordState!,
                              ctx: navigator.currentContext!);
                        }
                      }
                    },
                    title: 'تغيير',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
