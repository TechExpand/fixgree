class Beneficary {
  String bankCode;
  String accountNumber;
  int userId;
  String accountName;
  String bankName;
  int sn;
  String dateAdded;

  Beneficary(
      {this.bankCode,
      this.accountNumber,
      this.userId,
      this.accountName,
      this.bankName,
      this.sn,
      this.dateAdded});

  Beneficary.fromJson(Map<String, dynamic> json) {
    bankCode = json['bank_code'];
    accountNumber = json['account_number'];
    userId = json['user_id'];
    accountName = json['account_name'];
    bankName = json['bank_name'];
    sn = json['sn'];
    dateAdded = json['dateAdded'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bank_code'] = this.bankCode;
    data['account_number'] = this.accountNumber;
    data['user_id'] = this.userId;
    data['account_name'] = this.accountName;
    data['bank_name'] = this.bankName;
    data['sn'] = this.sn;
    data['dateAdded'] = this.dateAdded;
    return data;
  }
}
