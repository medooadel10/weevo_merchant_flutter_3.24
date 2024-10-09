class UpdateUser {
  String? bankAccountNumberIban;
  String? bankAccountClientName;
  String? bankBranchName;
  String? bankName;
  String? walletNumber;

  UpdateUser({
    this.bankAccountNumberIban,
    this.bankAccountClientName,
    this.bankBranchName,
    this.bankName,
    this.walletNumber,
  });

  UpdateUser.fromJson(Map<String, dynamic> json) {
    bankAccountNumberIban = json['bank_account_number_iban'];
    bankAccountClientName = json['bank_account_client_name'];
    bankBranchName = json['bank_branch_name'];
    bankName = json['bank_name'];
    walletNumber = json['wallet_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bank_account_number_iban'] = bankAccountNumberIban;
    data['bank_account_client_name'] = bankAccountClientName;
    data['bank_branch_name'] = bankBranchName;
    data['bank_name'] = bankName;
    data['wallet_number'] = walletNumber;
    return data;
  }
}
