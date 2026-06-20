# AI Usage Log

Tài liệu này ghi lại lịch sử AI hỗ trợ viết, sửa, refactor, debug hoặc test code trong dự án.

## Purpose

This log is used as evidence that AI tools were used to assist the developer during project development.

AI assistance does not mean the project was completed by an external person. The developer remains the owner of the work, reviews the generated code, verifies the logic, runs tests, and takes final responsibility for all commits.

Mục đích:
- Chứng minh project có sử dụng AI hỗ trợ lập trình.
- Chứng minh Developer tự làm project, không nhờ người ngoài làm thay.
- Theo dõi AI đã hỗ trợ task nào.
- Ghi lại prompt, file thay đổi, lệnh test và kết quả.
- Nhắc rõ Developer là người review và chịu trách nhiệm cuối cùng.

## Logging Rules

- Thêm log mới lên đầu phần `Log History`.
- Không ghi API key, token, password, connection string hoặc thông tin nhạy cảm.
- Nếu không biết chính xác model AI, ghi `Unknown / Antigravity AI`.
- Mức độ hỗ trợ `%` là ước lượng, không phải số tuyệt đối.
- Mỗi task có sửa code nên có ít nhất một log.
- AI không được tự commit/push nếu Developer chưa xác nhận.

## Log Format

```md
## [YYYY-MM-DD HH:mm:ss] - [Task Name]

| Field                      | Content                                                                                                              |
| -------------------------- | -------------------------------------------------------------------------------------------------------------------- |
| AI Tool / Model            | [Ví dụ: Antigravity AI / Gemini / Claude / Unknown]                                                                  |
| Support Type               | [Generate code / Fix bug / Refactor / UI update / Test / Debug]                                                      |
| Estimated AI Support       | [Ví dụ: 70% AI suggestion, 30% developer review]                                                                     |
| Human Reviewer             | [Tên/Nickname dev review]                                                                                            |
| Development Responsibility | AI assisted with implementation, but the developer reviewed, tested, and accepted responsibility for the final code. |

### User Prompt

[Prompt hoặc yêu cầu chính người dùng đã đưa cho AI]

### AI Assistance Summary

- [AI đã phân tích gì]
- [AI đã sửa/gợi ý gì]
- [AI đã hỗ trợ test/debug gì]

### Files Created / Modified / Deleted

| File            | Action   | Summary          |
| --------------- | -------- | ---------------- |
| `path/to/file1` | Modified | [Sửa gì]         |
| `path/to/file2` | Created  | [Tạo gì]         |
| `path/to/file3` | Deleted  | [Xóa gì, nếu có] |

### Commands Run & Results

| Command                                             | Result                       |
| --------------------------------------------------- | ---------------------------- |
| `git status --short --branch --untracked-files=all` | [Kết quả]                    |
| `[build command]`                                   | [Success / Failed / Not run] |
| `[test command]`                                    | [Passed / Failed / Not run]  |

### Git Status Summary

[Ví dụ: Modified 2 files, created 1 file, no commit made]

### Developer Review Notes

- [Dev cần kiểm tra lại gì]
- [Phần nào chưa test]
- [Có cần commit/push không]

---
```

## Log History

## [2026-06-19 09:09:40] - Phân tích kiến trúc và tạo tài liệu cấu trúc dự án

| Field | Content |
|---|---|
| AI Tool / Model | Gemini / Antigravity AI |
| Support Type | Generate documentation |
| Estimated AI Support | 95% AI suggestion, 5% developer review |
| Human Reviewer | Trần Gia Bảo |
| Development Responsibility | AI assisted with documentation, but the developer reviewed and accepted responsibility. |

### User Prompt

> Đọc code, quản lý code sạch, ghi rõ cái nào backend, cái nào frontend, ghi rõ ra để người ngoài còn hiểu cấu trúc project

### AI Assistance Summary

- AI đã dùng các công cụ đọc file (`list_dir`, `view_file`) để duyệt toàn bộ mã nguồn (`lib/`, `docs/`, `pubspec.yaml`, `main.dart`).
- AI đã phân tích sự phân tách giữa Frontend (UI/Routing) và Data Layer / Backend mô phỏng (`MockDataService`).
- AI đã tổng hợp và sinh ra tài liệu cấu trúc dự án `PROJECT_STRUCTURE.md` dưới dạng artifact, giải thích rõ các module, các loại dữ liệu, luồng điều hướng, và hướng dẫn cách tích hợp Backend thật sau này.

### Files Created / Modified / Deleted

| File | Action | Summary |
|---|---|---|
| `PROJECT_STRUCTURE.md` (Artifact) | Created | Tài liệu giải thích kiến trúc dự án |

### Commands Run & Results

| Command | Result |
|---|---|
| Khảo sát file bằng system tools | Success |

### Git Status Summary

Chưa commit.

### Developer Review Notes

- Dev có thể đọc qua file artifact `PROJECT_STRUCTURE.md` được tạo để kiểm tra độ chính xác và chia sẻ với các thành viên mới.

---

## [2026-06-19 09:24:56] - Thêm màn hình Quản lý Ngoại lệ nâng cao cho Manager

| Field | Content |
|---|---|
| AI Tool / Model | Claude Sonnet 4.6 (Thinking) / Antigravity AI |
| Support Type | Generate code |
| Estimated AI Support | 85% AI suggestion, 15% developer review |
| Human Reviewer | Trần Gia Bảo |
| Development Responsibility | AI assisted with implementation, but the developer reviewed, tested, and accepted responsibility for the final code. |

### User Prompt

> làm (optional) Các quản lý nâng cao khác như: theo dõi các trường hợp mất vé, sai biển số, quá giờ, gửi sai khu vực, xe chưa thanh toán

### AI Assistance Summary

- AI đã đọc toàn bộ code hiện tại: `exception_screen.dart`, `mock_data_service.dart`, `app_router.dart`, `manager_shell.dart`.
- AI đã tạo màn hình `exception_management_screen.dart` mới cho role Manager với:
  - Dashboard 6 stat cards (chờ xử lý, đã giải quyết, quá giờ, mất vé, sai biển số, chưa thanh toán).
  - Donut chart phân loại ngoại lệ (fl_chart PieChart).
  - Filter panel bên trái lọc theo từng loại ngoại lệ.
  - Search bar tìm theo biển số / mã slot.
  - Danh sách card có expand/collapse, hiển thị trạng thái màu sắc.
  - Dialog xử lý với 3 hành động: giải quyết & cho ra, đổi loại, cập nhật ghi chú.
  - Quick action bar đổi loại ngoại lệ nhanh.
- AI đã thêm 2 method mới vào `MockDataService`: `checkOutException()` và `markAsException()`.
- AI đã bổ sung 4 exception session mới (wrongPlate, unpaid, wrongZone, overtime 48h) để demo phong phú.
- AI đã đăng ký route `/manager/exceptions` trong `app_router.dart`.
- AI đã thêm nav item "Quản lý Ngoại lệ" vào sidebar Manager.

### Files Created / Modified / Deleted

| File | Action | Summary |
|---|---|---|
| `lib/features/manager/exception_management_screen.dart` | Created | Màn hình quản lý ngoại lệ nâng cao cho Manager |
| `lib/core/services/mock_data_service.dart` | Modified | Thêm 2 method + 4 exception sessions demo |
| `lib/core/router/app_router.dart` | Modified | Thêm route `/manager/exceptions` |
| `lib/features/manager/manager_shell.dart` | Modified | Thêm nav item Quản lý Ngoại lệ |

### Commands Run & Results

| Command | Result |
|---|---|
| `flutter analyze lib/features/manager/exception_management_screen.dart` | Running... |

### Git Status Summary

Chưa commit (không có git repo).

### Developer Review Notes

- Kiểm tra dialog "Giải quyết & cho ra" có tính đúng phí và giải phóng slot không.
- Kiểm tra filter + search hoạt động đúng khi có nhiều exception.
- Nếu cần, bổ sung thêm exception data để test đầy đủ các loại.

---



| Field | Content |
|---|---|
| AI Tool / Model | Claude Sonnet 4.6 (Thinking) / Antigravity AI |
| Support Type | Generate code |
| Estimated AI Support | 90% AI suggestion, 10% developer review |
| Human Reviewer | Trần Gia Bảo |
| Development Responsibility | AI assisted with implementation, but the developer reviewed, tested, and accepted responsibility for the final code. |

### User Prompt

> làm dự án SU26SWP08: Hệ thống quản lý tòa nhà gửi xe (Parking Building Management System)
> 1. Bối cảnh và Mục tiêu...
> 2. Các đối tượng sử dụng hệ thống (Actors)...
> 3. Yêu cầu chức năng chi tiết...
> 4. Các vấn đề nghiệp vụ cần giải quyết...
> Làm kiểu code Flutter, viết theo kiểu wed

### AI Assistance Summary

- AI đã phân tích chi tiết requirement của hệ thống Parking Building Management System.
- AI đã đề xuất kiến trúc Flutter Web với các components: core/theme, models, mock data service, auth, roles (manager, staff, driver, admin).
- AI đã khởi tạo toàn bộ project base (`flutter create`).
- AI đã thiết lập các model `vehicle`, `parking_slot`, `parking_floor`, `parking_session`, `pricing_policy`, `app_user`, `feedback_report`, `prebooking`.
- AI đã cài đặt `GoRouter`, cấu hình Theme Dark mode, thiết lập Mock data xử lý logic hiển thị các Dashboard.

### Files Created / Modified / Deleted

| File | Action | Summary |
|---|---|---|
| `lib/main.dart` | Created | Khởi tạo file chính, khai báo `appRouter` và `Provider` |
| `lib/core/models/*.dart` | Created | Các file model cho toàn bộ hệ thống |
| `lib/core/theme/app_theme.dart` | Created | Cấu hình Dark theme |
| `lib/core/services/mock_data_service.dart` | Created | Mock service để giả lập dữ liệu |
| `lib/core/router/app_router.dart` | Created | Thiết lập routes cho toàn bộ ứng dụng |
| `pubspec.yaml` | Modified | Cài đặt các thư viện `go_router`, `provider`, `fl_chart`, `google_fonts`, v.v. |
| `lib/features/...` | Created | Tất cả các màn hình chức năng cho 4 role |

### Commands Run & Results

| Command | Result |
|---|---|
| `flutter create ...` | Success |
| `flutter pub get` | Success |
| `flutter build web` | Success |
| `flutter run -d chrome` | Đã khởi chạy để dev test thực tế |

### Git Status Summary

Chưa khởi tạo kho lưu trữ git (fatal: not a git repository).

### Developer Review Notes

- Cần xem xét logic mock data trong `mock_data_service.dart` để thay bằng kết nối Backend API.
- Cần chạy lại ứng dụng để kiểm tra các luồng check-in/check-out thực tế trên giao diện.
- Nên chạy `git init`, thêm tất cả file và tiến hành commit version đầu tiên.

---

<!-- Add newest AI usage log entries above this line -->
