class ListOfAvailablePaymentGateways {
  String? gateway;
  String? depositionBankChargePercentageOrFixedFlag;
  double? depositionBankChargeValue;
  double? depositionAlwaysAppliedFixedBankChargeAmount;
  String? depositionBankChargeMessage;
  String? depositionBankChargeSecondMessage;

  ListOfAvailablePaymentGateways(
      {this.gateway,
      this.depositionBankChargePercentageOrFixedFlag,
      this.depositionBankChargeValue,
      this.depositionAlwaysAppliedFixedBankChargeAmount,
      this.depositionBankChargeMessage,
      this.depositionBankChargeSecondMessage});

  ListOfAvailablePaymentGateways.fromJson(Map<String, dynamic> json) {
    gateway = json['gateway'];
    depositionBankChargePercentageOrFixedFlag =
        json['deposition_bank_charge_percentage_or_fixed_flag'];
    depositionBankChargeValue = json['deposition_bank_charge_value'];
    depositionAlwaysAppliedFixedBankChargeAmount =
        json['deposition_always_applied_fixed_bank_charge_amount'];
    depositionBankChargeMessage = json['deposition_bank_charge_message'];
    depositionBankChargeSecondMessage =
        json['deposition_bank_charge_second_message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['gateway'] = gateway;
    data['deposition_bank_charge_percentage_or_fixed_flag'] =
        depositionBankChargePercentageOrFixedFlag;
    data['deposition_bank_charge_value'] = depositionBankChargeValue;
    data['deposition_always_applied_fixed_bank_charge_amount'] =
        depositionAlwaysAppliedFixedBankChargeAmount;
    data['deposition_bank_charge_message'] = depositionBankChargeMessage;
    data['deposition_bank_charge_second_message'] =
        depositionBankChargeSecondMessage;
    return data;
  }
}
