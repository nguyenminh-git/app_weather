# Lịch sử nâng cấp - Tính năng Tự động định vị
## 1. Cài đặt thư viện & Cấp quyền
*   **Thư viện**: Cài đặt thêm `geolocator` (lấy tọa độ GPS) và `geocoding` (chuyển tọa độ thành tên thành phố).
*   **`android/app/src/main/AndroidManifest.xml`**: Thêm quyền `ACCESS_FINE_LOCATION` và `ACCESS_COARSE_LOCATION`.
*   **`ios/Runner/Info.plist`**: Thêm mô tả quyền `NSLocationWhenInUseUsageDescription`.

## 2. Logic điều khiển (Provider)
*   **`lib/provider/weather_provider.dart`**: 
    *   Import package `geolocator` và `geocoding`.
    *   Bổ sung hàm `fetchWeatherByCurrentLocation()`. Hàm này chịu trách nhiệm: Kiểm tra dịch vụ định vị -> Xin quyền -> Lấy tọa độ GPS hiện tại -> Chuyển tọa độ thành tên thành phố -> Gọi API thời tiết theo tên thành phố đó.

## 3. Cập nhật Giao diện (Screens)
*   **`lib/screens/intro_screen.dart`**:
    *   Trong hàm `_start()`, thay vì gọi tĩnh `fetchWeatherData('hanoi')`, ứng dụng sẽ gọi `fetchWeatherByCurrentLocation()` trước. 
    *   Nếu có lỗi xảy ra (do người dùng từ chối quyền, tắt vị trí hoặc lỗi mạng), ứng dụng sẽ tự động fallback (quay về) mặc định lấy thời tiết của "hanoi" để đảm bảo app không bị đứng.
*   **`lib/screens/home_screen.dart`**:
    *   Tại phần `buildDateHeader`, đã bọc lại bằng một `Row` và thêm một icon button (`Icons.my_location_rounded`).
    *   Khi người dùng bấm vào nút này, app sẽ kích hoạt lại `context.read<WeatherProvider>().fetchWeatherByCurrentLocation()` để cập nhật thời tiết vị trí mới nhất.

## 4. Tính năng Tìm kiếm thành phố (Search & Debounce)
*   **`lib/screens/home_screen.dart`**:
    *   Thêm thư viện `dart:async` để sử dụng `Timer`.
    *   Tạo thanh `TextField` cho phép người dùng nhập tên thành phố.
    *   Áp dụng kỹ thuật **Debounce** (độ trễ 500ms): Khi người dùng đang nhập, app sẽ không gọi API ngay. Thay vào đó, nó sẽ đợi 500ms sau khi người dùng ngừng gõ phím mới gọi dữ liệu thời tiết. Mọi thay đổi đều linh hoạt.
    *   Cập nhật hàm `dispose()` để gọi `_debounce?.cancel()` tránh lỗi tràn bộ nhớ (memory leak).
    *   **Style**: UI của thanh search sẽ tự thay đổi màu hiển thị (Sáng/Tối) tùy theo biến trạng thái `isNight`. Hiệu ứng `Icon` tìm kiếm cũng được bo góc tròn đồng nhất với thiết kế.
    *   Khi ấn nút lấy vị trí tự động, `TextField` sẽ bị xóa nội dung đi để tránh gây nhầm lẫn hiển thị tên thành phố cũ.

## 5. Tính năng Gợi ý tên thành phố (Autocomplete)
*   **`lib/utils/city_data.dart` (Mới)**:
    *   Tạo danh sách chứa 63 tỉnh thành phố Việt Nam dạng không dấu.
    *   Tạo hàm xử lý `getSuggestions()` để lọc những thành phố khớp với từ khóa người dùng đang gõ.
*   **`lib/screens/home_screen.dart`**:
    *   Xóa bỏ logic *Debounce* (Timer) cũ vì nay đã có danh sách gõ trực tiếp.
    *   Thay đổi `TextField` cũ thành widget `Autocomplete<String>`. 
    *   `Autocomplete` vẫn giữ nguyên toàn bộ hiệu ứng đổi màu/Sáng Tối như `TextField` cũ để bảo đảm sự đồng bộ giao diện (`fieldViewBuilder`).
    *   Cung cấp một hộp thoại xổ xuống chứa danh sách các thành phố gợi ý (`optionsViewBuilder`). Hộp thoại này tự động thay đổi màu nền trắng/xanh đậm theo thời gian Ngày/Đêm hiện tại của app.
    *   Chỉ gọi API tải dữ liệu thời tiết khi người dùng chủ động **bấm Enter** trên bàn phím hoặc **Bấm chọn** một gợi ý từ danh sách thả xuống.
