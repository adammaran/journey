/// daily type implies for food, drinks, local transportation and other small, daily activity costs
enum SpendingMoneyType { daily, transport, clothing, souvenir }

class SpendingMoney {
  String spendingMoneyId;
  SpendingMoneyType type;
  String price;
  String description;

  SpendingMoney(this.spendingMoneyId, this.type, this.price, this.description);
}
