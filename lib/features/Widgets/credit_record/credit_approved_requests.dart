import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../../core/Providers/auth_provider.dart';
import '../../../core/Providers/wallet_provider.dart';
import '../../../core/Utilits/colors.dart';
import '../../../core/Utilits/constants.dart';
import '../network_error_widget.dart';
import 'widget/credit_record_item.dart';

class CreditApprovedRequest extends StatefulWidget {
  const CreditApprovedRequest({super.key});

  @override
  State<CreditApprovedRequest> createState() => _CreditApprovedRequestState();
}

class _CreditApprovedRequestState extends State<CreditApprovedRequest> {
  late WalletProvider _walletProvider;
  late ScrollController _controller;
  late AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
    _walletProvider = Provider.of<WalletProvider>(context, listen: false);
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _walletProvider.approvedCreditListOfTransaction(
      paging: false,
      refreshing: false,
      isFilter: false,
    );
    check(
        auth: _authProvider,
        state: _walletProvider.creditApprovedState!,
        ctx: context);
    _controller = ScrollController();
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        if (!_walletProvider.approvedCreditPaging) {
          _walletProvider.nextApprovedCreditPage();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletProvider>(
      builder: (context, data, child) => data.creditApprovedState ==
              NetworkState.WAITING
          ? const Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(weevoPrimaryOrangeColor),
              ),
            )
          : data.creditApprovedState == NetworkState.SUCCESS
              ? data.approvedCreditListEmpty
                  ? Center(
                      child: Text(
                        'لا توجد إيداعات مقبولة',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17.0.sp,
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () => data.clearApprovedCreditList(),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          ListView.builder(
                            controller: _controller,
                            itemBuilder: (BuildContext context, int i) =>
                                CreditRecordItem(
                              index: 1,
                              data: data.approvedCreditTransactionList[i],
                            ),
                            itemCount:
                                data.approvedCreditTransactionList.length,
                          ),
                          AnimatedContainer(
                            color: Colors.white.withOpacity(0.8),
                            height: data.approvedCreditPaging ? 40.0.h : 0.0.h,
                            duration: const Duration(milliseconds: 300),
                            child: const Center(
                              child: SpinKitThreeBounce(
                                color: weevoPrimaryOrangeColor,
                                size: 20.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
              : NetworkErrorWidget(onRetryCallback: () {
                  data.approvedCreditListOfTransaction(
                    paging: false,
                    refreshing: false,
                    isFilter: false,
                  );
                }),
    );
  }
}
