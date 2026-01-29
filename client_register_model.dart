class ClientRegisterModel {
  String name = '';
  String phone = '';
  String city = '';
  String email = '';
  
  // Маңызды өрістер
  String address = '';      // Нақты көше/үй
  String addressType = '';  // Жер үй / Пәтер / Офис
  String floor = '';        // Қабат (егер пәтер болса)
  
  // FIREBASE ҮШІН МАҢЫЗДЫ ФУНКЦИЯ
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'city': city,
      'email': email,
      'address': address,
      'address_type': addressType,
      'floor': floor,
    };
  }

  @override
  String toString() {
    return 'ClientData(name: $name, phone: $phone, city: $city, address: $address, type: $addressType, floor: $floor)';
  }
}