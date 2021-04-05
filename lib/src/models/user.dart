class UserAccount {
  double balance;
  String fullname;
  String phone;

  UserAccount(this.balance, this.fullname, this.phone);

  Map<String, dynamic> toJson() =>
      {'balance': balance, 'fullname': fullname, 'phone': phone};
}
