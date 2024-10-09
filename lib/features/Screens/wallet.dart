import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/Dialogs/filter_dialog.dart';
import '../../core/Providers/auth_provider.dart';
import '../../core/Providers/wallet_provider.dart';
import '../../core/Storage/shared_preference.dart';
import '../../core/Utilits/colors.dart';
import '../../core/Utilits/constants.dart';
import '../../core/router/router.dart';
import '../Widgets/wallet_tab.dart';

class Wallet extends StatefulWidget {
  static String id = 'Wallet';

  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  late WalletProvider _walletProvider;
  late AuthProvider _authProvider;
  @override
  void initState() {
    super.initState();
    _walletProvider = Provider.of<WalletProvider>(context, listen: false);
    _walletProvider.getCurrentBalance(fromRefresh: false);
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    check(
        auth: _authProvider,
        state: _walletProvider.currentBalanceState!,
        ctx: context);
    _walletProvider.getPendingBalance(fromRefresh: false);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final walletProvider = Provider.of<WalletProvider>(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: WillPopScope(
        onWillPop: () async {
          switch (walletProvider.mainIndex) {
            case 0:
              MagicRouter.pop();
              walletProvider.setMainIndex(0);
              break;
            case 1:
              switch (walletProvider.depositIndex) {
                case 0:
                  MagicRouter.pop();
                  walletProvider.setMainIndex(0);
                  break;
                case 1:
                  walletProvider.setWithdrawIndex(0);
                  break;
                case 2:
                  walletProvider.setWithdrawIndex(1);
                  break;
                case 3:
                  walletProvider.setWithdrawIndex(1);
                  break;
                case 4:
                  walletProvider.setWithdrawIndex(1);
                  break;
                case 5:
                  walletProvider.setWithdrawalAmount(null);
                  walletProvider.setWithdrawIndex(0);
                  break;
              }
              break;
            case 2:
              MagicRouter.pop();
              walletProvider.setMainIndex(0);
              break;
            case 3:
              MagicRouter.pop();
              walletProvider.setMainIndex(0);
              break;
          }

          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                switch (walletProvider.mainIndex) {
                  case 0:
                    MagicRouter.pop();
                    walletProvider.setMainIndex(0);
                    break;
                  case 1:
                    switch (walletProvider.depositIndex) {
                      case 0:
                        MagicRouter.pop();
                        walletProvider.setMainIndex(0);
                        break;
                      case 1:
                        walletProvider.setWithdrawIndex(0);
                        break;
                      case 2:
                        walletProvider.setWithdrawIndex(1);
                        break;
                      case 3:
                        walletProvider.setWithdrawIndex(1);
                        break;
                      case 4:
                        walletProvider.setWithdrawIndex(1);
                        break;
                      case 5:
                        walletProvider.setWithdrawalAmount(null);
                        walletProvider.setWithdrawIndex(0);
                        break;
                    }
                    break;
                  case 2:
                    MagicRouter.pop();
                    walletProvider.setMainIndex(0);
                    break;
                  case 3:
                    MagicRouter.pop();
                    walletProvider.setMainIndex(0);
                    break;
                }
              },
              icon: const Icon(
                Icons.arrow_back_ios_outlined,
              ),
            ),
            title: const Text(
              'المحفظة',
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton:
              walletProvider.mainIndex == 2 || walletProvider.mainIndex == 3
                  ? walletProvider.approvedCreditPaging ||
                          walletProvider.pendingCreditPaging ||
                          walletProvider.approvedWithdrawPaging ||
                          walletProvider.pendingWithdrawPaging ||
                          walletProvider.declinedWithdrawPaging ||
                          walletProvider.transferredWithdrawPaging
                      ? Container()
                      : FloatingActionButton.extended(
                          onPressed: () {
                            showDialog(
                              context: navigator.currentContext!,
                              builder: (context) => const FilterDialog(),
                            );
                          },
                          label: const Text(
                            'تصنيف',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                            ),
                          ),
                          icon: const Icon(Icons.filter_list_alt),
                          backgroundColor: walletProvider.mainIndex == 3
                              ? weevoLightBlue
                              : weevoLightPurple,
                        )
                  : Container(),
          backgroundColor: weevoWhiteSilver,
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                  ),
                  color: weevoWhiteSilver,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      walletProvider.currentBalanceState ==
                                  NetworkState.WAITING ||
                              walletProvider.pendingBalanceState ==
                                  NetworkState.WAITING
                          ? IconButton(
                              onPressed: () {},
                              icon: SizedBox(
                                height: 15.h,
                                width: 15.w,
                                child: const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    weevoPrimaryBlueColor,
                                  ),
                                ),
                              ),
                            )
                          : IconButton(
                              icon: const Icon(Icons.refresh),
                              onPressed: () async {
                                await walletProvider.getCurrentBalance(
                                    fromRefresh: true);
                                await walletProvider.getPendingBalance(
                                    fromRefresh: true);
                              },
                            ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                const Text(
                                  'رصيدك الحـالي',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: weevoLightGrey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: mediaQuery.size.height * .01,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const Text(
                                      'EGP',
                                      style: TextStyle(
                                        fontSize: 22.0,
                                        color: weevoDarkBlue,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      walletProvider.currentBalance!
                                          .split('.')[0],
                                      style: const TextStyle(
                                        fontSize: 22.0,
                                        color: weevoDarkBlue,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 80.0,
                            child: VerticalDivider(
                              width: 2.0,
                              indent: 40,
                              thickness: 2.0,
                              color: Colors.grey,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                const Text(
                                  'رصيدك المنتظر',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: weevoLightGrey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: mediaQuery.size.height * .01,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const Text(
                                      'EGP',
                                      style: TextStyle(
                                        fontSize: 22.0,
                                        color: weevoDarkBlue,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      walletProvider.pendingBalance!
                                          .split('.')[0],
                                      style: const TextStyle(
                                        fontSize: 22.0,
                                        color: weevoDarkBlue,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: mediaQuery.size.height * .03,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          WalletTab(
                            tabTitle: 'الرئيسية',
                            onTap: () => walletProvider.setMainIndex(0),
                            imageIcon: 'assets/images/home.png',
                            color: weevoGreenLighter,
                            selectedIndex: walletProvider.mainIndex,
                            itemIndex: 0,
                          ),
                          SizedBox(
                            width: mediaQuery.size.width * 0.03,
                          ),
                          WalletTab(
                            tabTitle: 'سحب',
                            onTap: () {
                              walletProvider.setMainIndex(1);
                              walletProvider.setWithdrawIndex(0);
                              walletProvider.setWithdrawalAmount(null);
                            },
                            imageIcon: 'assets/images/deposit.png',
                            color: weevoRustYellow,
                            selectedIndex: walletProvider.mainIndex,
                            itemIndex: 1,
                          ),
                          SizedBox(
                            width: mediaQuery.size.width * 0.03,
                          ),
                          WalletTab(
                            tabTitle: 'سجل الرصيد',
                            onTap: () {
                              walletProvider.setMainIndex(2);
                              walletProvider.resetCreditApprovedFilter();
                              walletProvider.resetCreditPendingFilter();
                            },
                            imageIcon: 'assets/images/on_hold.png',
                            color: weevoLightPurple,
                            selectedIndex: walletProvider.mainIndex,
                            itemIndex: 2,
                          ),
                          SizedBox(
                            width: mediaQuery.size.width * 0.03,
                          ),
                          WalletTab(
                            tabTitle: 'سجل السحب',
                            onTap: () {
                              walletProvider.setMainIndex(3);
                              walletProvider.resetApprovedWithdrawFilter();
                              walletProvider.resetPendingWithdrawFilter();
                              walletProvider.resetTransferredWithdrawFilter();
                              walletProvider.resetDeclinedWithdrawFilter();
                            },
                            imageIcon: 'assets/images/record.png',
                            color: weevoLightBlue,
                            selectedIndex: walletProvider.mainIndex,
                            itemIndex: 3,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(
                          35,
                        ),
                        topLeft: Radius.circular(
                          35,
                        ),
                      ),
                    ),
                    child: walletProvider.mainWidget,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
