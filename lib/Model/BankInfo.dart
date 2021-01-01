class BankInfo {
  String name;
  bool active;
  String slug;
  String isDeleted;
  String code;
  int id;
  String longCode;
  DateTime createdAt;
  String gateway;
  DateTime updatedAt;

  BankInfo(
      {this.name,
      this.active,
      this.slug,
      this.isDeleted,
      this.code,
      this.id,
      this.longCode,
      this.createdAt,
      this.gateway,
      this.updatedAt});

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "active": active,
      "slug": slug,
      "longcode": longCode,
      "code": code,
      "id": id,
    };
  }

  factory BankInfo.fromJson(jsonData) => BankInfo(
      name: jsonData["name"],
      active: jsonData["active"],
      slug: jsonData["slug"],
      longCode: jsonData["longcode"],
      code: jsonData["code"],
      id: jsonData["id"]);

  //   createdAt: jsonData["currency_code"],
  //   gateway: jsonData["accountNumber"],
  //   updatedAt: jsonData["balance"],
  // isDeleted: jsonData["customer_email"]);
}
