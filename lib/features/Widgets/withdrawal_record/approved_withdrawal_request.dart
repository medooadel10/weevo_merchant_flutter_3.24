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

class ApprovedWithdrawalRequests extends StatefulWidget {
  const ApprovedWithdrawalRequests({super.key});

  @override
  State<ApprovedWithdrawalRequests> createState() =>
      _ApprovedWithdrawalRequestsState();
}

class _ApprovedWithdrawalRequestsState
    extends State<ApprovedWithdrawalRequests> {
  late WalletProvider _walletProvider;
  late ScrollController _controller;
  late AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
    _walletProvider = Provider.of<WalletProvider>(context, listen: false);
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _walletProvider.approvedWithdrawTransactions(
      paging: false,
      refreshing: false,
      isFilter: false,
    );
    check(
        auth: _authProvider,
        state: _walletProvider.approvedWithdrawState!,
        ctx: context);
    _controller = ScrollController();
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        if (!_walletProvider.approvedWithdrawPaging) {
          _walletProvider.nextApprovedWithdrawPage();
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
          data.approvedWithdrawState == NetworkState.WAITING
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(weevoPrimaryOrangeColor),
                  ),
                )
              : data.approvedWithdrawState == NetworkState.SUCCESS
                  ? data.approvedWithdrawEmpty
                      ? Center(
                          child: Text(
                            'لا توجد مسحوبات مقبولة',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17.0.sp,
                            ),
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: () => data.clearApprovedWithdrawList(),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              ListView.builder(
                                controller: _controller,
                                itemBuilder: (BuildContext context, int i) =>
                                    WithdrawalRecordItem(
                                  data: data.approvedWithdrawList[i],
                                ),
                                itemCount: data.approvedWithdrawList.length,
                              ),
                              AnimatedContainer(
                                color: Colors.white.withOpacity(0.8),
                                height: data.approvedWithdrawPaging
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
                      data.approvedWithdrawTransactions(
                        paging: false,
                        refreshing: false,
                        isFilter: false,
                      );
                    }),
    );
  }
}
