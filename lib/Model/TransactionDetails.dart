class TransactionDetails {
  DateTime transactionDate;
  String transactionReference;
  String paymentReference;
  String mobile;
  String paymentDescription;
  String transactionType;
  var amountPaid;
  var totalPayable;
  String paymentMethod;
  String currency;
  int id;
  String paymentStatus;
  String monnifyTransactionDate;

  TransactionDetails(
      {this.transactionDate,
        this.transactionReference,
        this.paymentReference,
        this.mobile,
        this.paymentDescription,
        this.transactionType,
        this.amountPaid,
        this.totalPayable,
        this.paymentMethod,
        this.currency,
        this.id,
        this.paymentStatus,
        this.monnifyTransactionDate});

  TransactionDetails.fromJson(Map<String, dynamic> json) {
    transactionDate = DateTime.parse(json['transaction_date']);
    transactionReference = json['transactionReference'];
    paymentReference = json['paymentReference'];
    mobile = json['mobile'];
    paymentDescription = json['paymentDescription'];
    transactionType = json['transactionType'];
    amountPaid = json['amountPaid'];
    totalPayable = json['totalPayable'];
    paymentMethod = json['paymentMethod'];
    currency = json['currency'];
    id = json['id'];
    paymentStatus = json['paymentStatus'];
    monnifyTransactionDate = json['monnifyTransactionDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transaction_date'] = this.transactionDate;
    data['transactionReference'] = this.transactionReference;
    data['paymentReference'] = this.paymentReference;
    data['mobile'] = this.mobile;
    data['paymentDescription'] = this.paymentDescription;
    data['transactionType'] = this.transactionType;
    data['amountPaid'] = this.amountPaid;
    data['totalPayable'] = this.totalPayable;
    data['paymentMethod'] = this.paymentMethod;
    data['currency'] = this.currency;
    data['id'] = this.id;
    data['paymentStatus'] = this.paymentStatus;
    data['monnifyTransactionDate'] = this.monnifyTransactionDate;
    return data;
  }
}