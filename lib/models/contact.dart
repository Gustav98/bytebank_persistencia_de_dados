class Contact {
  final int id;
  final String name;
  final int accountNumber;

  Contact(this.name, this.accountNumber, this.id);

  @override
  String toString() {
    return 'Contact{name: $name, accountNumber: $accountNumber, id: $id}';
  }

  Contact.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        accountNumber = json['accountNumber'],
        id = json['id'] ?? 0;

  Map<String, dynamic> toJson() => {
        'name': name,
        'accountNumber': accountNumber,
      };
}
