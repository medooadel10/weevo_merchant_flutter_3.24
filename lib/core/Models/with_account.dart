import 'wallet_account_model.dart';

class WithBankAccount {
  BankAccount? bankAccount;
  String? walletNumber;
  bool isUpdated;

  WithBankAccount({
    this.bankAccount,
    required this.isUpdated,
    this.walletNumber,
  });
}
