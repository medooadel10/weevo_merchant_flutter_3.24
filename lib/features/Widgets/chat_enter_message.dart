import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../core/Dialogs/image_picker_dialog.dart';
import '../../core/Models/chat_data.dart';
import '../../core/Providers/auth_provider.dart';
import '../../core/Storage/shared_preference.dart';
import '../../core/Utilits/colors.dart';
import '../../core/Utilits/constants.dart';
import '../../core/router/router.dart';
import '../../core_new/networking/api_constants.dart';
import 'edit_text.dart';

class ChatEnterMessage extends StatefulWidget {
  final CollectionReference message;
  final ChatData chatData;
  final String conversionId;
  final ScrollController controller;

  const ChatEnterMessage({
    super.key,
    required this.message,
    required this.chatData,
    required this.conversionId,
    required this.controller,
  });

  @override
  State<ChatEnterMessage> createState() => _ChatEnterMessageState();
}

class _ChatEnterMessageState extends State<ChatEnterMessage> {
  late TextEditingController sendController;
  late FocusNode sendNode;
  bool _isLoading = false;
  int? type;

  @override
  void initState() {
    super.initState();
    sendController = TextEditingController();
    sendNode = FocusNode();
  }

  @override
  void dispose() {
    sendController.dispose();
    sendNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              if (sendController.text.trim().isNotEmpty) {
                String messageContent = sendController.text;
                sendController.clear();
                await sendMessage(messageContent, Type.TEXT.index);
                widget.controller.animateTo(
                  0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.bounceIn,
                );
              }
            },
            child: CircleAvatar(
              radius: 25.0,
              backgroundColor: weevoPrimaryBlueColor,
              child: Transform.rotate(
                angle: pi,
                child: const Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 5.0,
          ),
          Expanded(
            child: EditText(
              fillColor: Colors.white,
              radius: 20,
              maxLines: 5,
              type: TextInputType.multiline,
              borderSide: const BorderSide(width: 0.2),
              isPassword: false,
              isPhoneNumber: false,
              readOnly: false,
              hintColor: Colors.grey,
              controller: sendController,
              focusNode: sendNode,
              hintText: 'أكتب رسالتك هنا',
            ),
          ),
          const SizedBox(
            width: 5.0,
          ),
          GestureDetector(
            onTap: () async {
              showModalBottomSheet(
                context: navigator.currentContext!,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20.0),
                        topLeft: Radius.circular(20.0))),
                builder: (context) => ImagePickerDialog(
                  onImageReceived: (XFile? file) async {
                    if (file == null) return;
                    MagicRouter.pop();
                    setState(() => _isLoading = true);
                    TaskSnapshot? task = await uploadImage(
                        uid: DateTime.now().millisecondsSinceEpoch.toString(),
                        path: file.path);
                    if (task == null) return;
                    String imageUrl = await task.ref.getDownloadURL();
                    setState(() => _isLoading = false);
                    await sendMessage(imageUrl, Type.IMAGE.index);
                    widget.controller.animateTo(
                      0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.bounceIn,
                    );
                  },
                ),
              );
            },
            child: CircleAvatar(
              radius: 25.0,
              backgroundColor: weevoPrimaryBlueColor,
              child: _isLoading
                  ? const SpinKitDoubleBounce(
                      color: Colors.white,
                      size: 20.0,
                    )
                  : const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> sendMessage(String content, int type) async {
    final DocumentReference convoDoc = FirebaseFirestore.instance
        .collection('messages')
        .doc(widget.conversionId);
    QuerySnapshot map = await convoDoc.collection(widget.conversionId).get();
    await convoDoc.set(<String, dynamic>{
      'lastMessage': <String, dynamic>{
        'currentUserId': widget.chatData.currentUserId,
        'currentUserImage': widget.chatData.currentUserImageUrl,
        'currentUsername': widget.chatData.currentUserName,
        'currentNationalId': widget.chatData.currentUserNationalId,
        'peerNationalId': widget.chatData.peerNationalId,
        'peerId': widget.chatData.peerId,
        'peerUsername': widget.chatData.peerUserName,
        'dateTime': DateTime.now().toIso8601String(),
        'peerImageUrl': widget.chatData.peerImageUrl,
        'shipmentId': widget.chatData.shipmentId,
        'content': content,
        'type': type,
        'read': false,
        'count': map.docs
                .map((e) => e['read'])
                .where((i) => i == false)
                .toList()
                .length +
            1
      },
      'users': <String>[
        widget.chatData.currentUserNationalId,
        widget.chatData.peerNationalId
      ]
    }).then((dynamic success) async {
      await FirebaseFirestore.instance
          .collection('messages')
          .doc(widget.conversionId)
          .collection(widget.conversionId)
          .add({
        'currentUserId': widget.chatData.currentUserId,
        'currentUserImage': widget.chatData.currentUserImageUrl,
        'currentUsername': widget.chatData.currentUserName,
        'currentNationalId': widget.chatData.currentUserNationalId,
        'peerNationalId': widget.chatData.peerNationalId,
        'peerUsername': widget.chatData.peerUserName,
        'peerImageUrl': widget.chatData.peerImageUrl,
        'peerId': widget.chatData.peerId,
        'dateTime': DateTime.now().toIso8601String(),
        'content': content,
        'read': false,
        'type': type,
      });
      DocumentSnapshot userToken = await FirebaseFirestore.instance
          .collection('courier_users')
          .doc(widget.chatData.peerId)
          .get();
      String token = userToken['fcmToken'];
      switch (type) {
        case 0:
          Provider.of<AuthProvider>(navigator.currentContext!, listen: false)
              .sendNotification(
                  title: widget.chatData.currentUserName,
                  body: content,
                  image: (widget.chatData.currentUserImageUrl.isNotEmpty)
                      ? widget.chatData.currentUserImageUrl
                              .contains(ApiConstants.baseUrl)
                          ? widget.chatData.currentUserImageUrl
                          : '${ApiConstants.baseUrl}${widget.chatData.currentUserImageUrl}'
                      : '',
                  toToken: token,
                  type: 'chat',
                  screenTo: 'chat_screen',
                  data: ChatData(
                    widget.chatData.currentPhoneNumber,
                    widget.chatData.peerPhoneNumber,
                    currentUserId: widget.chatData.currentUserId,
                    currentUserNationalId:
                        widget.chatData.currentUserNationalId,
                    peerNationalId: widget.chatData.peerNationalId,
                    currentUserName: widget.chatData.currentUserName,
                    currentUserImageUrl: widget.chatData.currentUserImageUrl,
                    peerId: widget.chatData.peerId,
                    shipmentId: widget.chatData.shipmentId,
                    peerUserName: widget.chatData.peerUserName,
                    peerImageUrl: widget.chatData.peerImageUrl,
                    conversionId: widget.conversionId,
                    type: type,
                  ).toJson());
          break;
        case 1:
          Provider.of<AuthProvider>(navigator.currentContext!, listen: false)
              .sendNotification(
                  title: widget.chatData.currentUserName,
                  body: 'photo',
                  image: (widget.chatData.currentUserImageUrl.isNotEmpty)
                      ? widget.chatData.currentUserImageUrl
                              .contains(ApiConstants.baseUrl)
                          ? widget.chatData.currentUserImageUrl
                          : '${ApiConstants.baseUrl}${widget.chatData.currentUserImageUrl}'
                      : '',
                  toToken: token,
                  type: 'chat',
                  screenTo: 'chat_screen',
                  data: ChatData(
                    widget.chatData.currentPhoneNumber,
                    widget.chatData.peerPhoneNumber,
                    currentUserId: widget.chatData.currentUserId,
                    currentUserName: widget.chatData.currentUserName,
                    currentUserNationalId:
                        widget.chatData.currentUserNationalId,
                    peerNationalId: widget.chatData.peerNationalId,
                    currentUserImageUrl: widget.chatData.currentUserImageUrl,
                    peerId: widget.chatData.peerId,
                    shipmentId: widget.chatData.shipmentId,
                    peerUserName: widget.chatData.peerUserName,
                    peerImageUrl: widget.chatData.peerImageUrl,
                    conversionId: widget.conversionId,
                    type: type,
                  ).toJson());
          break;
        case 2:
          break;
      }
    });
  }
}
