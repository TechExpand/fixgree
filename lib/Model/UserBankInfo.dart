class UserBankInfo {
  String mobile;
  String contractCode;
  String accountRef;
  String accountName;
  String currencyCode;
  String customerEmail;
  String accountNumber;
  String bankName;
  DateTime dateCreated;
  var balance;
  var totalIncome;
  int totalWithdrawal;

  UserBankInfo(
      {this.mobile,
      this.contractCode,
      this.accountRef,
      this.accountName,
      this.currencyCode,
      this.customerEmail,
      this.accountNumber,
      this.bankName,
      this.dateCreated,
      this.balance,
      this.totalIncome,
      this.totalWithdrawal});

  Map<String, dynamic> toJson() {
    return {
      "account_name": accountName,
      "bankName": bankName,
      "date_created": dateCreated.toString(),
      "customer_email": customerEmail,
      "mobile": mobile,
      "account_ref": accountRef,
      "contract_code": contractCode,
      "currency_code": currencyCode,
      "accountNumber": accountNumber,
      "balance": balance,
      "totalIncome": totalIncome,
      "totalWithdrawal": totalWithdrawal
    };
  }

  factory UserBankInfo.fromJson(jsonData) => UserBankInfo(
      accountName: jsonData["account_name"],
      bankName: jsonData["bankName"],
      dateCreated: DateTime.parse(jsonData["date_created"]),
      customerEmail: jsonData["customer_email"],
      mobile: jsonData["mobile"],
      accountRef: jsonData["account_ref"],
      contractCode: jsonData["contract_code"],
      currencyCode: jsonData["currency_code"],
      accountNumber: jsonData["accountNumber"],
      balance: '${jsonData["balance"].roundToDouble().toString()}',
      totalIncome: '${jsonData["totalIncome"].roundToDouble().toString()}',
      totalWithdrawal: jsonData["totalWithdrawal"]);
}
