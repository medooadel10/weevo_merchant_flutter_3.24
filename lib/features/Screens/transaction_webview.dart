import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/Models/transaction_webview_model.dart';
import '../Widgets/loading_widget.dart';

class TransactionWebView extends StatefulWidget {
  static const String id = 'TransactionWebView';
  final TransactionWebViewModel model;

  const TransactionWebView({
    super.key,
    required this.model,
  });

  @override
  State<TransactionWebView> createState() => _TransactionWebViewState();
}

class _TransactionWebViewState extends State<TransactionWebView> {
  WebViewController? _controller;
  final bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: LoadingWidget(
          isLoading: _isLoading,
          child: WebViewWidget(controller: _controller!),
          //   WebView(
          //     onWebResourceError: (WebResourceError error) {
          //       log('${error.errorCode}');
          //     },
          //     initialUrl: widget.model.url,
          //     javascriptMode: JavascriptMode.unrestricted,
          //     onWebViewCreated: (WebViewController webViewController) async {
          //       _controller = webViewController;
          //     },
          //     onPageFinished: (String s) async {
          //       setState(() => _isLoading = false);
          //       String result = await _controller.runJavascriptReturningResult(
          //           'document.documentElement.innerHTML');
          //       if (widget.model.selectedValue == 0 &&
          //           result.contains('Approved')) {
          //         String number = result.split(':')[1].substring(0, 7).trim();
          //         Navigator.pop(context, number);
          //       } else if (widget.model.selectedValue == 2 &&
          //           result.split(',')[1].split(':')[1].contains('completed')) {
          //         Navigator.pop(context, true);
          //       }
          //     },
          //     gestureNavigationEnabled: true,
          //   ),
          // ),
        ),
      ),
    );
  }
}
