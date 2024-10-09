import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../../core/Providers/auth_provider.dart';
import '../../../core/Providers/wallet_provider.dart';
import '../../../core/Utilits/colors.dart';
import '../../../core/Utilits/constants.dart';
import '../network_error_widget.dart';
import 'widget/wallet_withdrawal_item.dart';

class PendingWithdrawalRequests extends StatefulWidget {
  const PendingWithdrawalRequests({super.key});

  @override
  State<PendingWithdrawalRequests> createState() =>
      _PendingWithdrawalRequestsState();
}

class _PendingWithdrawalRequestsState extends State<PendingWithdrawalRequests> {
  late WalletProvider _walletProvider;
  late AuthProvider _authProvider;
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _walletProvider = Provider.of<WalletProvider>(context, listen: false);
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _walletProvider.pendingWithdrawTransactions(
      paging: false,
      refreshing: false,
      isFilter: false,
    );
    check(
        auth: _authProvider,
        state: _walletProvider.pendingWithdrawState!,
        ctx: context);
    _controller = ScrollController();
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        if (!_walletProvider.pendingWithdrawPaging) {
          _walletProvider.nextPendingWithdrawPage();
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WalletProvider>(
      builder: (context, data, child) => data.pendingWithdrawState ==
              NetworkState.WAITING
          ? const Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(weevoPrimaryOrangeColor),
              ),
            )
          : data.pendingWithdrawState == NetworkState.SUCCESS
              ? data.pendingWithdrawEmpty
                  ? Center(
                      child: Text(
                        'لا توجد مسحوبات منتظرة',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17.0.sp,
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () => data.clearPendingWithdrawList(),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          ListView.builder(
                            controller: _controller,
                            itemBuilder: (BuildContext context, int i) =>
                                WithdrawalRecordItem(
                              data: data.pendingWithdrawList[i],
                            ),
                            itemCount: data.pendingWithdrawList.length,
                          ),
                          AnimatedContainer(
                            color: Colors.white.withOpacity(0.8),
                            height: data.pendingWithdrawPaging ? 40.0.h : 0.0.h,
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
                  data.pendingWithdrawTransactions(
                    paging: false,
                    refreshing: false,
                    isFilter: false,
                  );
                }),
    );
  }
}
