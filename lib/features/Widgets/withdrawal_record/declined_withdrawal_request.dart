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

class DeclinedWithdrawalRequests extends StatefulWidget {
  const DeclinedWithdrawalRequests({super.key});

  @override
  State<DeclinedWithdrawalRequests> createState() =>
      _DeclinedWithdrawalRequestsState();
}

class _DeclinedWithdrawalRequestsState
    extends State<DeclinedWithdrawalRequests> {
  late WalletProvider _walletProvider;
  late ScrollController _controller;
  late AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
    _walletProvider = Provider.of<WalletProvider>(context, listen: false);
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _walletProvider.declinedWithdrawTransactions(
      paging: false,
      refreshing: false,
      isFilter: false,
    );
    check(
        auth: _authProvider,
        state: _walletProvider.declinedWithdrawState!,
        ctx: context);
    _controller = ScrollController();
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        if (!_walletProvider.declinedWithdrawPaging) {
          _walletProvider.nextDeclinedWithdrawPage();
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
      builder: (context, data, child) =>
          data.declinedWithdrawState == NetworkState.WAITING
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(weevoPrimaryOrangeColor),
                  ),
                )
              : data.declinedWithdrawState == NetworkState.SUCCESS
                  ? data.approvedWithdrawEmpty
                      ? Center(
                          child: Text(
                            'لا توجد إيداعات مرفوضة',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17.0.sp,
                            ),
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: () => data.clearDeclinedWithdrawList(),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              ListView.builder(
                                controller: _controller,
                                itemBuilder: (BuildContext context, int i) =>
                                    WithdrawalRecordItem(
                                  data: data.declinedWithdrawList[i],
                                ),
                                itemCount: data.declinedWithdrawList.length,
                              ),
                              AnimatedContainer(
                                color: Colors.white.withOpacity(0.8),
                                height: data.declinedWithdrawPaging
                                    ? 40.0.h
                                    : 0.0.h,
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
                      data.declinedWithdrawTransactions(
                        paging: false,
                        refreshing: false,
                        isFilter: false,
                      );
                    }),
    );
  }
}
