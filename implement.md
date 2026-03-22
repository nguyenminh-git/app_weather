# Kế Hoạch Chuyển Đổi Dự Án Thời Tiết: Flutter (Dart) ➡️ Android Native (Kotlin + XML)

Bộ tài liệu này hướng dẫn chi tiết từng bước để viết lại ứng dụng `app_weather` từ Flutter sang Kotlin Native mang phong cách giao diện truyền thống (sử dụng **XML**).

---

## 🏗️ 1. Khởi Tạo Dự Án (Android Studio)
- [ ] Mở Android Studio -> **New Project** -> Chọn **Empty Views Activity** (với tùy chọn ngôn ngữ Kotlin).
- [ ] Tên dự án: `AppWeather_KotlinXML`.
- [ ] Bật `ViewBinding` trong file `build.gradle.kts` (Module :app) để không phải dùng `findViewById`:
  ```kotlin
  android {
      ...
      buildFeatures {
          viewBinding = true
      }
  }
  ```
- [ ] Thêm các thư viện cần thiết vào `build.gradle.kts`:
  ```kotlin
  dependencies {
      // 1. Call API (thay http)
      implementation("com.squareup.retrofit2:retrofit:2.9.0")
      implementation("com.squareup.retrofit2:converter-gson:2.9.0")

      // 2. Quản lý State (thay provider)
      implementation("androidx.lifecycle:lifecycle-viewmodel-ktx:2.7.0")
      implementation("androidx.lifecycle:lifecycle-livedata-ktx:2.7.0")
      implementation("androidx.activity:activity-ktx:1.8.0")
      implementation("androidx.fragment:fragment-ktx:1.6.2")

      // 3. Lấy vị trí GPS (thay geolocator)
      implementation("com.google.android.gms:play-services-location:21.1.0")

      // 4. Các UI cơ bản (thay các Widget của Flutter)
      implementation("androidx.constraintlayout:constraintlayout:2.1.4")
      implementation("androidx.recyclerview:recyclerview:1.3.2")
      implementation("com.google.android.material:material:1.11.0")
  }
  ```

---

## 🗂️ 2. Chuyển Đổi Cấu Trúc Thư Mục
Dự án của bạn bên Flutter chia thành `models`, `provider`, `screens`, `services`, `widgets`. Ở Kotlin, project sẽ phân tán hơn một chút do tách biệt logic (`.kt`) và giao diện (`.xml`):

**Thư mục Code (`java/com/yourname/appweather/`)**:
1. `data/model` (ứng với `models`)
2. `data/remote` (ứng với `services`)
3. `ui/main` (ứng với `screens` và `provider` - chứa Activity/Fragment và ViewModel)
4. `ui/adapter` (dùng để chứa Adapter cho RecyclerView của `widgets`)

**Thư mục Giao diện (`res/layout/`)**:
Chứa toàn bộ các file `.xml` định nghĩa giao diện tương đương với cây Widget của Flutter.

---

## 🛠️ 3. Lộ Trình Code (Dưới Lên Trên)

### Bước 1: Migrate Models (`lib/models/`)
Chuyển đổi dữ liệu JSON sang Kotlin Data Class.
- [ ] Chuyển **`weather.dart`** ➡️ **`Weather.kt`**
  *Dùng thẻ `@SerializedName("tên_truong_json")` của Gson.*
- [ ] Chuyển **`forecast.dart`** ➡️ **`Forecast.kt`**

### Bước 2: Migrate Services (`lib/services/`)
- [ ] Chuyển **`weather_service.dart`** ➡️ **`WeatherApiService.kt`** (Retrofit Interface)
- [ ] Viết thêm class **`LocationService.kt`**
  *Dùng `FusedLocationProviderClient`.*

### Bước 3: Migrate Provider/State (`lib/provider/`)
- [ ] Chuyển **`weather_provider.dart`** ➡️ **`WeatherViewModel.kt`**
  *Kế thừa `ViewModel`. Dùng `LiveData` thay vì thay đổi ngang trên biến như Dart:*
  ```kotlin
  private val _weatherData = MutableLiveData<Weather>()
  val weatherData: LiveData<Weather> = _weatherData
  
  // Khi API fetch xong
  _weatherData.postValue(result)
  ```

### Bước 4: Migrate Giao diện & Widgets (`res/layout/`)
Ở Flutter bạn xếp Widget như nào thì ở XML bạn vẽ bằng thẻ mô tả như thế.
- [ ] Tạo **`activity_main.xml`** (tương đương `home_screen.dart`). Dùng `ConstraintLayout` bọc ngoài, bên trong có thể là `LinearLayout` (thay thế Column/Row) và `RecyclerView`.
- [ ] Chuyển **`header_widget.dart`** ➡️ Tạo file `layout_header.xml` dùng thẻ `<include>` để chèn vào Main. Hoặc tạo Custom View nếu phức tạp.
- [ ] Chuyển **`info_capsule.dart`** ➡️ Tạo file `item_info_capsule.xml`.

### Bước 5: Phụ trách List (RecyclerView)
Flutter có `ListView.builder` rất dễ, nhưng ở Kotlin+XML bạn phải tạo Adapter cho nó:
- [ ] Tạo file giao diện cho từng phần tử: **`item_hour_forecast.xml`** (tương đương `hour_forecast_item.dart`).
- [ ] Tạo class kotlin **`ForecastAdapter.kt`** kế thừa `RecyclerView.Adapter`. Class này sẽ bơm danh sách `Forecast` lên từng view `.xml` phía trên.
- [ ] Component **`forecast_list.dart`** bên Flutter giờ đây chính là đoạn mã cài đặt RecyclerView ở Kotlin: `recyclerView.adapter = ForecastAdapter(list)` và `recyclerView.layoutManager = LinearLayoutManager(this, RecyclerView.HORIZONTAL, false)`.

### Bước 6: Ghép nối Logic vào Screens (`lib/screens/`)
- [ ] Chuyển **`intro_screen.dart`** ➡️ **`IntroActivity.kt`** (đi kèm file `activity_intro.xml`).
- [ ] Chuyển **`home_screen.dart`** ➡️ **`MainActivity.kt`** (hoặc `HomeFragment`). Nơi đây bạn sẽ lấy `ViewModel` ra để observe LiveData nhằm hiện UI:
  ```kotlin
  viewModel.weatherData.observe(this) { weather ->
      // Gán lên TextView
      binding.tvTemp.text = "${weather.temp}°C"
  }
  ```
- [ ] Chuyển **`hourly_detail_screen.dart`** ➡️ **`HourlyDetailActivity.kt`** (đi kèm `activity_hourly_detail.xml`).

### Bước 7: Điều hướng (Navigation)
- [ ] Ở Flutter bạn gọi `Navigator.push`. 
- [ ] Ở XML bạn dùng `Intent`:
  ```kotlin
  val intent = Intent(this, HourlyDetailActivity::class.java)
  startActivity(intent)
  ```

---

## ✅ 4. Kiểm thử & Cấu hình cuối
- [ ] Mở file **`AndroidManifest.xml`** để bổ sung quyền và đăng ký Activity:
  ```xml
  <uses-permission android:name="android.permission.INTERNET" />
  <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
  <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
  ```
- [ ] Đảm bảo `IntroActivity` nằm trong thẻ `<intent-filter>` có chứa `LAUNCHER` (tùy luồng khởi động app của bạn).
- [ ] Chạy trực tiếp qua Emulator hoặc máy Android thật.
