# 📂 Cấu Trúc Dự Án — Parking Building Management System (SU26SWP08)

> **Dự án:** Hệ thống Quản lý Tòa nhà Gửi xe  
> **Tech stack:** Flutter (Dart) — chạy trên Web/Desktop  
> **Trạng thái hiện tại:** Prototype — dùng Mock Data (chưa kết nối backend thật)

---

## 🗺️ Tổng quan kiến trúc

```
┌──────────────────────────────────────────────────────────┐
│                    FLUTTER APP (lib/)                     │
│                                                          │
│  ┌─────────────┐   ┌──────────────┐   ┌───────────────┐ │
│  │   FRONTEND  │   │  DATA LAYER  │   │     CORE      │ │
│  │  (UI/Views) │◄──│ (Mock svc)   │   │ (Theme/Route) │ │
│  │  features/  │   │ core/svc/    │   │ core/         │ │
│  └─────────────┘   └──────────────┘   └───────────────┘ │
└──────────────────────────────────────────────────────────┘

⚠️  Hiện tại CHƯA có backend server thật.
    MockDataService đóng vai trò "backend giả" lưu dữ liệu
    trong bộ nhớ RAM (mất khi reload app).
```

---

## 📁 Cây thư mục đầy đủ

```
parking_management/
│
├── lib/                        ← Toàn bộ code Dart của app
│   ├── main.dart               ← Điểm khởi động app
│   │
│   ├── core/                   ← Tầng lõi, dùng chung toàn app
│   │   ├── models/             ← [DATA LAYER] Định nghĩa cấu trúc dữ liệu
│   │   │   ├── models.dart         barrel file (export tất cả model)
│   │   │   ├── app_user.dart       Model người dùng + enum Role/Status
│   │   │   ├── parking_floor.dart  Model tầng gửi xe
│   │   │   ├── parking_slot.dart   Model ô đỗ xe
│   │   │   ├── parking_session.dart Model phiên gửi xe (check-in/out)
│   │   │   ├── pricing_policy.dart Model chính sách giá
│   │   │   ├── prebooking.dart     Model đặt chỗ trước
│   │   │   ├── feedback_report.dart Model phản hồi/khiếu nại
│   │   │   └── vehicle.dart        Enum loại xe (motorbike/car/truck)
│   │   │
│   │   ├── services/           ← [BACKEND GIẢ] Business logic + Mock data
│   │   │   └── mock_data_service.dart  ★ File quan trọng nhất
│   │   │
│   │   ├── router/             ← [FRONTEND] Điều hướng màn hình
│   │   │   └── app_router.dart     Cấu hình route (GoRouter)
│   │   │
│   │   └── theme/              ← [FRONTEND] Giao diện / Design system
│   │       └── app_theme.dart      Màu sắc, typography, button styles
│   │
│   ├── features/               ← [FRONTEND] Các màn hình theo role
│   │   ├── auth/
│   │   │   └── login_screen.dart       Màn hình đăng nhập
│   │   │
│   │   ├── manager/            ← Màn hình cho Quản lý bãi xe
│   │   │   ├── manager_shell.dart      Layout sidebar cho manager
│   │   │   ├── dashboard_screen.dart   Tổng quan / Dashboard chính
│   │   │   ├── slot_management_screen.dart  Quản lý ô đỗ xe
│   │   │   ├── pricing_screen.dart     Cấu hình giá vé
│   │   │   └── reports_screen.dart     Báo cáo doanh thu & lưu lượng
│   │   │
│   │   ├── staff/              ← Màn hình cho Nhân viên bãi xe
│   │   │   ├── staff_shell.dart        Layout sidebar cho staff
│   │   │   ├── check_in_screen.dart    Màn hình Check-in xe
│   │   │   ├── check_out_screen.dart   Màn hình Check-out xe
│   │   │   └── exception_screen.dart   Xử lý sự cố (mất vé, quá giờ...)
│   │   │
│   │   ├── driver/             ← Màn hình cho Người gửi xe
│   │   │   ├── driver_shell.dart       Layout sidebar cho driver
│   │   │   ├── driver_dashboard_screen.dart  Tổng quan xe của driver
│   │   │   ├── my_sessions_screen.dart Lịch sử gửi xe
│   │   │   ├── prebooking_screen.dart  Đặt chỗ trước
│   │   │   └── feedback_screen.dart    Gửi phản hồi / khiếu nại
│   │   │
│   │   └── admin/              ← Màn hình cho Quản trị viên hệ thống
│   │       ├── admin_shell.dart        Layout sidebar cho admin
│   │       ├── system_config_screen.dart   Cấu hình hệ thống (giờ mở/đóng, tên...)
│   │       └── user_management_screen.dart Quản lý tài khoản người dùng
│   │
│   └── shared/                 ← [FRONTEND] Widget dùng lại nhiều nơi
│       └── widgets/
│           └── app_sidebar.dart    Sidebar navigation (dùng cho tất cả role)
│
├── pubspec.yaml                ← Khai báo thư viện (dependencies)
├── docs/
│   └── AI_USAGE_LOG.md         ← Log quá trình dùng AI hỗ trợ code
└── test/                       ← Thư mục test (hiện trống)
```

---

## 🖥️ FRONTEND — Phần giao diện người dùng

> **Định nghĩa:** Tất cả code liên quan đến **hiển thị UI, điều hướng màn hình, và design**.

### Danh sách file Frontend

| File | Mô tả |
|------|-------|
| `lib/core/theme/app_theme.dart` | Design system: màu sắc (dark mode indigo/cyan), font (Inter), button, card styles |
| `lib/core/router/app_router.dart` | Định nghĩa các route URL và điều hướng giữa màn hình |
| `lib/shared/widgets/app_sidebar.dart` | Sidebar navigation tái sử dụng cho tất cả 4 role |
| `lib/features/auth/login_screen.dart` | Form đăng nhập với chọn role demo |
| `lib/features/manager/manager_shell.dart` | Layout wrapper sidebar cho Manager |
| `lib/features/manager/dashboard_screen.dart` | Dashboard Manager: biểu đồ doanh thu, lưu lượng xe, tình trạng slot |
| `lib/features/manager/slot_management_screen.dart` | Xem và quản lý trạng thái từng ô đỗ xe theo tầng |
| `lib/features/manager/pricing_screen.dart` | Cấu hình giá vé theo loại xe |
| `lib/features/manager/reports_screen.dart` | Báo cáo doanh thu 7 ngày, phân tích lưu lượng |
| `lib/features/staff/staff_shell.dart` | Layout wrapper sidebar cho Staff |
| `lib/features/staff/check_in_screen.dart` | Form check-in: nhập biển số, chọn loại xe, chọn tầng |
| `lib/features/staff/check_out_screen.dart` | Tìm xe theo biển số → tính tiền → check-out |
| `lib/features/staff/exception_screen.dart` | Danh sách và xử lý các sự cố (mất vé, quá giờ...) |
| `lib/features/driver/driver_shell.dart` | Layout wrapper sidebar cho Driver |
| `lib/features/driver/driver_dashboard_screen.dart` | Tổng quan xe đang gửi của driver |
| `lib/features/driver/my_sessions_screen.dart` | Lịch sử gửi xe + QR code phiên |
| `lib/features/driver/prebooking_screen.dart` | Đặt chỗ trước: chọn loại xe, tầng, thời gian |
| `lib/features/driver/feedback_screen.dart` | Gửi phản hồi / khiếu nại về dịch vụ |
| `lib/features/admin/admin_shell.dart` | Layout wrapper sidebar cho Admin |
| `lib/features/admin/system_config_screen.dart` | Cấu hình tên bãi, địa chỉ, giờ mở/đóng |
| `lib/features/admin/user_management_screen.dart` | Thêm/xem/kích hoạt-hủy tài khoản người dùng |

### Thư viện Frontend đang dùng

| Package | Mục đích |
|---------|---------|
| `flutter` | Framework UI chính |
| `go_router ^14.0.0` | Điều hướng URL-based (web-friendly) |
| `google_fonts ^6.2.1` | Font chữ Inter (Google Fonts) |
| `fl_chart ^0.69.0` | Vẽ biểu đồ (line chart, bar chart, pie chart) |
| `flutter_animate ^4.5.0` | Animation (fade-in, slide, v.v.) |
| `qr_flutter ^4.1.0` | Sinh mã QR cho phiên gửi xe |
| `intl ^0.19.0` | Định dạng ngày giờ (locale tiếng Việt `vi`) |

---

## 🗄️ DATA LAYER — Tầng dữ liệu (hiện là "Backend giả")

> **Định nghĩa:** Phần xử lý **business logic, thao tác dữ liệu, và state management**.  
> **Hiện tại:** Dùng `MockDataService` thay cho backend API thật.  
> **Khi tích hợp backend thật:** Sẽ thay thế `MockDataService` bằng các `Repository` + HTTP client gọi REST API.

### Models (Cấu trúc dữ liệu)

| File | Class / Enum | Mô tả |
|------|-------------|-------|
| `vehicle.dart` | `enum VehicleType` | Loại xe: motorbike, car, truck |
| `app_user.dart` | `class AppUser`, `enum UserRole`, `enum UserStatus` | Người dùng hệ thống với 4 role |
| `parking_floor.dart` | `class ParkingFloor` | Tầng gửi xe (id, tên, sức chứa theo loại xe) |
| `parking_slot.dart` | `class ParkingSlot`, `enum SlotStatus` | Ô đỗ xe (mã slot, tầng, trạng thái, biển số hiện tại) |
| `parking_session.dart` | `class ParkingSession`, `enum SessionStatus`, `enum ExceptionType` | Phiên gửi xe: check-in→check-out, tính phí |
| `pricing_policy.dart` | `class PricingPolicy` | Chính sách giá: theo giờ, qua đêm, tháng |
| `prebooking.dart` | `class Prebooking`, `enum PrebookingStatus` | Đặt chỗ trước (có mã xác nhận) |
| `feedback_report.dart` | `class FeedbackReport`, `enum FeedbackCategory`, `enum FeedbackStatus` | Phản hồi / khiếu nại của driver |

### MockDataService (Business Logic)

**File:** `lib/core/services/mock_data_service.dart`  
**Kích thước:** ~753 dòng — **đây là file "backend" quan trọng nhất**

```
MockDataService extends ChangeNotifier
│
├── Dữ liệu (State)
│   ├── users           — Danh sách người dùng (6 tài khoản demo)
│   ├── floors          — 4 tầng xe (T1+T2: xe máy, T3: ô tô, T4: ô tô+xe tải)
│   ├── slots           — 190 ô đỗ xe được sinh ngẫu nhiên
│   ├── sessions        — Phiên gửi xe (active, completed, exception)
│   ├── pricingPolicies — 3 chính sách giá (xe máy/ô tô/xe tải)
│   ├── prebookings     — Danh sách đặt chỗ trước
│   └── feedbacks       — Danh sách phản hồi
│
├── Auth
│   ├── login()         — Kiểm tra username (mọi password đều OK trong demo)
│   └── logout()        — Xóa currentUser
│
├── Slot Queries
│   ├── slotsForFloor() — Lấy danh sách slot theo tầng
│   ├── availableCount()— Đếm slot trống
│   ├── occupancyRate() — Tỷ lệ lấp đầy (%)
│   └── totalOccupied() — Tổng slot đang có xe
│
├── Session Operations
│   ├── checkIn()       — Tìm slot trống → tạo session mới
│   ├── checkOut()      — Tính phí → đánh dấu slot trống
│   ├── findActiveSession() — Tìm phiên đang gửi theo biển số
│   └── resolveException()  — Giải quyết sự cố
│
├── Pricing
│   ├── updatePricing() — Cập nhật giá theo loại xe
│   └── getPriceForType() — Lấy giá hiện tại
│
├── Reports
│   ├── todayRevenue()      — Doanh thu hôm nay
│   ├── weekRevenue()       — Doanh thu 7 ngày
│   ├── hourlyTrafficToday()— Lưu lượng theo giờ trong ngày
│   └── dailyRevenue7Days() — Doanh thu từng ngày 7 ngày qua
│
├── Prebooking
│   ├── createPrebooking()  — Tạo đặt chỗ + giữ slot
│   └── prebookingsForUser()— Lấy đặt chỗ theo userId
│
├── Feedback
│   ├── submitFeedback()    — Gửi phản hồi mới
│   └── resolveFeedback()   — Đánh dấu đã giải quyết
│
└── User Management
    ├── addUser()           — Thêm tài khoản mới
    ├── toggleUserStatus()  — Kích hoạt / Vô hiệu hóa tài khoản
    └── updateBuildingConfig() — Cập nhật thông tin tòa nhà
```

### State Management

- Dùng **Provider** (`ChangeNotifierProvider` + `ChangeNotifier`)
- `MockDataService` là singleton, được inject vào toàn app qua `Provider`
- Bất kỳ widget nào gọi `context.watch<MockDataService>()` sẽ tự rebuild khi data thay đổi

---

## 👤 Phân vai người dùng (Roles)

| Role | Username demo | Màn hình | Quyền |
|------|--------------|---------|-------|
| **Manager** (Quản lý) | `manager` | `/manager/*` | Xem dashboard, quản lý slot, cấu hình giá, xem báo cáo |
| **Staff** (Nhân viên) | `staff1`, `staff2` | `/staff/*` | Check-in, check-out, xử lý sự cố |
| **Driver** (Người gửi xe) | `driver1`, `driver2` | `/driver/*` | Xem xe đang gửi, đặt chỗ, gửi feedback |
| **Admin** (Quản trị viên) | `admin` | `/admin/*` | Cấu hình hệ thống, quản lý tài khoản |

> **Demo login:** Nhập đúng username, password có thể nhập bất kỳ.

---

## 🔄 Luồng điều hướng (Routing)

```
/login
  │
  ├── login thành công → redirect theo role:
  │     manager  → /manager  (Dashboard)
  │     staff    → /staff    (Check-in)
  │     driver   → /driver   (Dashboard)
  │     admin    → /admin    (System Config)
  │
  ├── /manager/
  │     /manager          → Dashboard
  │     /manager/slots    → Quản lý ô đỗ
  │     /manager/pricing  → Chính sách giá
  │     /manager/reports  → Báo cáo
  │
  ├── /staff/
  │     /staff            → Check-in
  │     /staff/checkout   → Check-out
  │     /staff/exceptions → Xử lý sự cố
  │
  ├── /driver/
  │     /driver           → Dashboard driver
  │     /driver/sessions  → Lịch sử gửi xe
  │     /driver/booking   → Đặt chỗ trước
  │     /driver/feedback  → Gửi phản hồi
  │
  └── /admin/
        /admin            → Cấu hình hệ thống
        /admin/users      → Quản lý tài khoản
```

---

## 🏗️ Dữ liệu Demo có sẵn

Khi khởi động app, `MockDataService._init()` tự sinh:

| Dữ liệu | Số lượng | Chi tiết |
|---------|---------|---------|
| Users | 6 | 1 manager, 2 staff, 2 driver, 1 admin |
| Floors | 4 | T1-T2 (xe máy), T3 (ô tô), T4 (ô tô + xe tải) |
| Slots | 190 | T1-T2: 120 slot xe máy, T3: 40 slot ô tô, T4: 30 slot (20 ô tô + 10 xe tải) |
| Sessions | ~100 | Lịch sử 7 ngày + 8 phiên đang active + 2 phiên exception |
| Prebookings | 2 | 1 confirmed, 1 pending |
| Feedbacks | 2 | 1 pending, 1 resolved |

---

## 🔮 Hướng tích hợp Backend thật (khi cần)

Hiện tại app dùng Mock, khi cần kết nối API thật:

```
Thay thế:
  lib/core/services/mock_data_service.dart
Bằng:
  lib/core/services/auth_service.dart       ← gọi POST /api/login
  lib/core/repositories/slot_repository.dart ← gọi GET/PUT /api/slots
  lib/core/repositories/session_repository.dart ← gọi POST /api/sessions
  lib/core/repositories/report_repository.dart  ← gọi GET /api/reports
  ...

Thêm:
  lib/core/network/api_client.dart          ← HTTP client (dio/http package)
  lib/core/network/api_endpoints.dart       ← Khai báo URL endpoints
```

> Các màn hình (features/) **không cần sửa nhiều** vì chúng chỉ gọi service qua Provider.

---

## 📦 Tóm tắt nhanh cho người mới vào project

```
Muốn sửa giao diện?        → lib/features/{role}/*_screen.dart
Muốn sửa màu sắc/font?     → lib/core/theme/app_theme.dart
Muốn sửa dữ liệu/logic?    → lib/core/services/mock_data_service.dart
Muốn thêm màn hình mới?    → 1) Tạo file trong lib/features/
                              2) Đăng ký route trong lib/core/router/app_router.dart
Muốn sửa cấu trúc dữ liệu? → lib/core/models/*.dart
Muốn chạy app?             → flutter run -d chrome (web)
                              flutter run (desktop/mobile)
```
