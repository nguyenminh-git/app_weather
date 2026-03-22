# app_weather

A new Flutter project.

## Tính năng chính ✨

- 📍 Lấy thời tiết theo vị trí hiện tại của thiết bị (sử dụng Geolocator & Geocoding).
- 🔍 Tìm kiếm thời tiết theo tên thành phố.
- 🌡️ Hiển thị thời tiết chi tiết: Nhiệt độ, độ ẩm, tốc độ gió, và tình trạng thời tiết.
- 🌐 Tích hợp API thời tiết.
- 🧩 Quản lý trạng thái (State Management) hiệu quả với Provider.

## Công nghệ & Thư viện 🛠️

- **Framework:** [Flutter](https://flutter.dev/)
- **State Management:** `provider`
- **Network / API:** `http`
- **Location:** `geolocator`, `geocoding`
- **Environment Variables:** `flutter_dotenv` (Bảo mật API Key không bị lộ lên source control)
- **Formatting:** `intl` (Định dạng ngày tháng)

## Cài đặt và Chạy dự án 🚀

### Yêu cầu trước
- Cài đặt [Flutter SDK](https://docs.flutter.dev/get-started/install).
- Đăng ký API Key miễn phí tại [OpenWeatherMap](https://openweathermap.org/) (hoặc dịch vụ thời tiết tương ứng mà ứng dụng sử dụng).

### Các bước thực hiện
1. **Clone dự án repository**
   ```bash
   git clone <URL_CUA_REPO_NAY>
   cd app_weather
   ```

2. **Cài đặt các thư viện (dependencies)**
   ```bash
   flutter pub get
   ```

3. **Cấu hình API Key**
   - Tạo một file tên là `.env` ở thư mục gốc của dự án.
   - Thêm API Key của bạn vào file `.env` theo định dạng sau:
     ```env
     WEATHER_API_KEY=your_api_key_here
     ```

4. **Chạy ứng dụng**
   ```bash
   flutter run
   ```

## Cấu trúc thư mục 📂

Dự án được triển khai theo cấu trúc thư mục rõ ràng, giúp dễ dàng bảo trì và mở rộng:

```text
lib/
├── models/       # Chứa các class Data/Model (ví dụ: WeatherModel) định nghĩa cấu trúc dữ liệu trả về từ API.
├── provider/     # Chứa các class quản lý State bằng Provider, tách biệt logic kinh doanh (Business Logic) khỏi UI.
├── screens/      # Chứa các màn hình giao diện chính (UI) của ứng dụng.
├── services/     # Chứa code gọi API (HTTP requests) hoặc các service ngoại vi (như Location).
├── utils/        # Chứa các hàm tiện ích, hằng số chung của dự án, formatter (hiển thị ngày tháng).
├── widgets/      # Chứa các UI components dùng chung và linh hoạt (Custom button, Weather Card...).
└── main.dart     # Điểm bắt đầu (Entry point) của ứng dụng, cấu hình Provider và Theme.
```

## Ảnh chụp màn hình 📱
*(Thêm screenshot chụp dự án thực tế của bạn vào đây – ví dụ: lưu vào thư mục `assets/images` và chèn link).*

---

Được xây dựng với ❤️ bằng Flutter.
