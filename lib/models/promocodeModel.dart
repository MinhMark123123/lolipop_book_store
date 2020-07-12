import 'package:flutter/material.dart';

class PromoCodeModel {
  final String titleCode;
  final String valueCode;
  final int amountDiscount;
  final String expirationDate;
  final bool codeStatus;
  final int amountCondition;

  const PromoCodeModel(
      {this.titleCode,
      this.valueCode,
      this.amountDiscount,
      this.expirationDate,
      this.codeStatus,
      this.amountCondition});

  PromoCodeModel.fromMap(Map<String, dynamic> data)
      : this(
          titleCode: data['titleCode'],
          valueCode: data['valueCode'],
          amountDiscount: data['amountDiscount'],
          expirationDate: data['expirationDate'],
          codeStatus: data['codeStatus'],
          amountCondition: data['amountCondition'],
        );
  toJson() {
    return {
      'titleCode': titleCode,
      'valueCode': valueCode,
      'amountDiscount': amountDiscount,
      'expirationDate': expirationDate,
      'codeStatus': codeStatus,
      'amountCondition': amountCondition,
    };
  }
}
