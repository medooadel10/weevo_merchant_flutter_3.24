import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:share_plus/share_plus.dart';

import '../../core_new/networking/api_constants.dart';
import '../../core_new/widgets/custom_image.dart';
import '../Models/refresh_qr_code.dart';
import '../Storage/shared_preference.dart';
import '../Utilits/colors.dart';
import '../router/router.dart';
import 'content_dialog.dart';
import 'done_dialog.dart';
import 'loading_dialog.dart';

class ShareSaveQrCodeDialog extends StatefulWidget {
  final RefreshQrcode data;
  final int shipmentId;

  const ShareSaveQrCodeDialog({
    super.key,
    required this.data,
    required this.shipmentId,
  });

  @override
  State<ShareSaveQrCodeDialog> createState() => _ShareSaveQrCodeDialogState();
}

class _ShareSaveQrCodeDialogState extends State<ShareSaveQrCodeDialog> {
  final GlobalKey _globalKey = GlobalKey();
  StreamSubscription? _subscription;
  bool _isFinishedSharing = false;

  @override
  initState() {
    super.initState();
    _subscription = FGBGEvents.instance.stream.listen((event) {
      if (event == FGBGType.foreground && _isFinishedSharing) {
        _isFinishedSharing = false;
        showDialog(
            context: navigator.currentContext!,
            barrierDismissible: false,
            builder: (c) => DoneDialog(
                  onDoneCallback: () {
                    MagicRouter.pop();
                    MagicRouter.pop();
                  },
                  content: 'تم نشر الصورة بنجاح',
                ));
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RepaintBoundary(
                  key: _globalKey,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50.0,
                      vertical: 10.0,
                    ),
                    margin: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/qr_code_weevo_logo.png',
                        ),
                        SizedBox(
                          height: 10.0.h,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.black, width: 2.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 6.0, horizontal: 12.0),
                          child: Text(
                            'طلب رقم ${widget.shipmentId}',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0.sp,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: 10.0.h,
                        ),
                        Text(
                          'خلي الكابتن\nيسكان الكود ده',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17.0.sp,
                            fontWeight: FontWeight.w700,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 10.0.h,
                        ),
                        CustomImage(
                          imageUrl:
                              '${ApiConstants.baseUrl}${widget.data.path}',
                          height: 120.0.h,
                          width: 180.0.w,
                        ),
                        SizedBox(
                          height: 10.0.h,
                        ),
                        Text(
                          'او يكتب الكود ده',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17.0.sp,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.black, width: 2.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 6.0, horizontal: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: widget.data.code
                                .toString()
                                .split('')
                                .map((e) => Text(
                                      e,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17.0.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.center,
                                    ))
                                .toList(),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          'www.weevoapp.com',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 4.0.h),
                        Text(
                          'تطبق الشروط والأحكام',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0.sp,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                              weevoPrimaryOrangeColor),
                          foregroundColor:
                              WidgetStateProperty.all<Color>(Colors.white)),
                      child: const Text('حفظ الصورة'),
                      onPressed: () async {
                        _savePng(widget.data.filename ?? '');
                      },
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                              weevoPrimaryOrangeColor),
                          foregroundColor:
                              WidgetStateProperty.all<Color>(Colors.white)),
                      child: const Text('نشر الصورة'),
                      onPressed: () async {
                        _shareImage(widget.data.filename ?? '');
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                              weevoPrimaryOrangeColor),
                          foregroundColor:
                              WidgetStateProperty.all<Color>(Colors.white)),
                      child: const Text('لاحقاً'),
                      onPressed: () async {
                        if (Preferences.instance.getWeevoShipmentNote(
                                widget.shipmentId.toString()) !=
                            1) {
                          showDialog(
                            context: navigator.currentContext!,
                            barrierDismissible: false,
                            builder: (c) => Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        'يمكنك نشر الصورة او حفظها\nفي اي وقت عن طريق\nالضغط علي هذا الزر',
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        decoration: const BoxDecoration(
                                          color: weevoPrimaryBlueColor,
                                          shape: BoxShape.circle,
                                        ),
                                        height: 50.0,
                                        width: 50.0,
                                        padding: const EdgeInsets.all(8.0),
                                        child: const Icon(
                                          Icons.qr_code,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                WidgetStateProperty.all<Color>(
                                                    weevoPrimaryOrangeColor),
                                            foregroundColor:
                                                WidgetStateProperty.all<Color>(
                                                    Colors.white)),
                                        child: const Text('حسناً'),
                                        onPressed: () {
                                          Preferences.instance.setShipmentNote(
                                              widget.shipmentId.toString(), 1);
                                          MagicRouter.pop();
                                          MagicRouter.pop();
                                        },
                                      )
                                    ],
                                  ),
                                )),
                          );
                        } else {
                          MagicRouter.pop();
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _savePng(String filename) async {
    showDialog(
        context: navigator.currentContext!,
        barrierDismissible: false,
        builder: (context) => const LoadingDialog());
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject()! as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        MagicRouter.pop();
        return;
      }
      Uint8List pngBytes = byteData.buffer.asUint8List();
      var documentDirectory = await getTemporaryDirectory();
      var firstPath = "${documentDirectory.path}/images";
      var filePathAndName = '${documentDirectory.path}/images/$filename';
      await Directory(firstPath).create(recursive: true);
      File file2 = File(filePathAndName);
      file2.writeAsBytesSync(pngBytes);
      await SaverGallery.saveImage(
        pngBytes,
        name: filename,
        androidExistNotSave: false,
      );
      MagicRouter.pop();
      showDialog(
          context: navigator.currentContext!,
          barrierDismissible: false,
          builder: (c) => DoneDialog(
                onDoneCallback: () {
                  MagicRouter.pop();
                  MagicRouter.pop();
                },
                content: 'تم حفظ الصورة بنجاح',
              ));
    } catch (e) {
      log(e.toString());
      MagicRouter.pop();
      showDialog(
          context: navigator.currentContext!,
          barrierDismissible: false,
          builder: (c) => ContentDialog(
                content: 'برجاء المحاولة مرة اخري',
                callback: () {
                  MagicRouter.pop();
                  MagicRouter.pop();
                },
              ));
    }
  }

  Future<void> _shareImage(String filename) async {
    showDialog(
        context: navigator.currentContext!,
        barrierDismissible: false,
        builder: (context) => const LoadingDialog());
    RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      MagicRouter.pop();
      return;
    }
    Uint8List pngBytes = byteData.buffer.asUint8List();
    var createDocumentDirectory = await getTemporaryDirectory();
    var saveFirstPath = "${createDocumentDirectory.path}/images";
    var filePathAndName = '${createDocumentDirectory.path}/images/$filename';
    await Directory(saveFirstPath).create(recursive: true);
    File file2 = File(filePathAndName);
    file2.writeAsBytesSync(pngBytes);
    var getDocumentDirectory = await getTemporaryDirectory();
    var getFirstPath = "${getDocumentDirectory.path}/images";
    File file = File('$getFirstPath/$filename');
    try {
      MagicRouter.pop();
      await Share.shareXFiles([XFile(file.path)]);
      _isFinishedSharing = true;
    } catch (e) {
      log('error: ${e.toString()}');
      MagicRouter.pop();
      showDialog(
          context: navigator.currentContext!,
          barrierDismissible: false,
          builder: (c) => ContentDialog(
                content: 'برجاء المحاولة مرة اخري',
                callback: () {
                  MagicRouter.pop();
                  MagicRouter.pop();
                },
              ));
    }
  }
}
