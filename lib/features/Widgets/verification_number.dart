import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';

import '../../core/Utilits/colors.dart';

class VerificationNumber extends StatelessWidget {
  final String countryCode;
  final Function(CountryCode) onCountryChange;
  final TextEditingController controller;

  const VerificationNumber({
    super.key,
    required this.countryCode,
    required this.onCountryChange,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          25.0,
        ),
        color: weevoGreyColor,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.phone_iphone,
            color: Colors.grey,
          ),
          Expanded(
            child: TextField(
              controller: controller,
              textAlign: TextAlign.end,
              keyboardType: TextInputType.number,
              maxLength: 11,
              decoration: const InputDecoration(
                counterText: '',
                border: UnderlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
          ),
          SizedBox(
            width: size.width * 0.02,
          ),
          Text(
            countryCode,
            style: const TextStyle(
              fontSize: 16.0,
            ),
          ),
          Wrap(
            children: [
              CountryCodePicker(
                onChanged: onCountryChange,
                initialSelection: 'EG',
                showCountryOnly: false,
                padding: const EdgeInsets.all(0.0),
                hideMainText: true,
                showOnlyCountryWhenClosed: false,
                alignLeft: false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
