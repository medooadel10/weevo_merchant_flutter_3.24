class BankAccount {
  String? accountIBAN;
  String? accountOwnerName;
  String? bankName;
  String? bankBranchName;

  BankAccount({
    this.accountIBAN,
    this.accountOwnerName,
    this.bankName,
    this.bankBranchName,
  });

  @override
  String toString() {
    return 'BankAccount{accountIBAN: $accountIBAN, accountOwnerName: $accountOwnerName, bankName: $bankName, bankBranchName: $bankBranchName}';
  }
}
