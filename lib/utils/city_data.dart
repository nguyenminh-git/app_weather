class CityData {
  static const List<String> vietnamCities = [
    'An Giang',
    'Ba Ria',
    'Vung Tau',
    'Bac Lieu',
    'Bac Kạn',
    'Bac Giang',
    'Bac Ninh',
    'Ben Tre',
    'Binh Duong',
    'Binh Dinh',
    'Binh Phuoc',
    'Binh Thuan',
    'Ca Mau',
    'Cao Bang',
    'Can Tho',
    'Da Nang',
    'Dak Lak',
    'Dak Nong',
    'Dien Bien',
    'Dong Nai',
    'Dong Thap',
    'Gia Lai',
    'Ha Giang',
    'Ha Nam',
    'Ha Noi',
    'Ha Tinh',
    'Hai Duong',
    'Hai Phong',
    'Hau Giang',
    'Hoa Binh',
    'Ho Chi Minh',
    'Hung Yen',
    'Kien Giang',
    'Kon Tum',
    'Khanh Hoa',
    'Lai Chau',
    'Lang Son',
    'Lao Cai',
    'Lam Dong',
    'Long An',
    'Nam Dinh',
    'Nghe An',
    'Ninh Binh',
    'Ninh Thuan',
    'Phu Tho',
    'Phu Yen',
    'Quang Binh',
    'Quang Nam',
    'Quang Ngai',
    'Quang Ninh',
    'Quang Tri',
    'Soc Trang',
    'Son La',
    'Tay Ninh',
    'Thai Binh',
    'Thai Nguyen',
    'Thanh Hoa',
    'Thua Thien Hue',
    'Tien Giang',
    'Tra Vinh',
    'Tuyen Quang',
    'Vinh Long',
    'Vinh Phuc',
    'Yen Bai',
  ];

  static List<String> getSuggestions(String query) {
    if (query.isEmpty) {
      return const [];
    }
    
    // Loại bỏ dấu đi 
    // Ở đây danh sách đang được lưu thành ASCII (không dấu) để tra cứu dễ nhất.
    final lowercaseQuery = query.toLowerCase();
    
    return vietnamCities.where((city) {
      return city.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }
}
