import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:freshchat_sdk/freshchat_user.dart';
import 'package:provider/provider.dart';

import '../Storage/shared_preference.dart';

class FreshChatProvider with ChangeNotifier {
  static FreshChatProvider get(BuildContext context) =>
      Provider.of<FreshChatProvider>(context);

  static FreshChatProvider listenFalse(BuildContext context) =>
      Provider.of<FreshChatProvider>(context, listen: false);

  Timer? _freshChatMessagesTimer;
  Map unreadCountStatus = {};
  int? freshChatNewMessageCounter;
  FreshchatUser? user;
  StreamSubscription? unreadCountSubscription;

  void initFreshChat() async {
    getUser();
    getUnreadCount(init: true);
    freshChatOnMessageCountUpdate();
    // _freshChatMessagesTimer = Timer.periodic(Duration(seconds: 3), (timer) {
    //   getUnreadCount();
    // });
  }

  void freshChatOnMessageCountUpdate() async {
    var unreadCountStream = Freshchat.onMessageCountUpdate;
    unreadCountSubscription = unreadCountStream.listen((event) {
      log("New message generated: $event");
    });
  }

  void freshChatOnMessageCountUpdateDispose() {
    if (unreadCountSubscription != null) {
      unreadCountSubscription?.cancel();
    }
  }

  void getUser() async {
    user = await Freshchat.getUser;
    user?.setFirstName(Preferences.instance.getUserName.split(' ')[0]);
    user?.setLastName(
        '${Preferences.instance.getUserName.split(' ')[1]} (Merchant)');
    user?.setEmail(Preferences.instance.getUserEmail);
    user?.setPhone('+2', Preferences.instance.getPhoneNumber);
    Freshchat.setUser(user!);
    Freshchat.identifyUser(externalId: Preferences.instance.getUserId);
    log('user -> ${user?.getEmail()}');
    log('user -> ${user?.getPhone()}');
    log('user -> ${user?.getFirstName()}');
    log('user -> ${user?.getLastName()}');
    log('user -> ${user?.getRestoreId()}');
    log('user -> ${user?.getExternalId()}');
  }

  void getUnreadCount({bool init = false}) async {
    unreadCountStatus = await Freshchat.getUnreadCountAsync;
    freshChatNewMessageCounter = unreadCountStatus['count'];
    log('unreadCountStatus -> $unreadCountStatus');
    log('unreadCountStatus -> ${unreadCountStatus['count']}');
    if (!init) {
      notifyListeners();
    }
  }

  void disposeTimer() {
    if (_freshChatMessagesTimer != null && _freshChatMessagesTimer!.isActive) {
      _freshChatMessagesTimer?.cancel();
    }
  }
}
