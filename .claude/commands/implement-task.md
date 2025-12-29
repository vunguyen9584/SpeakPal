---
description: Thực thi một task cụ thể từ Implementation Plan
---

Execute the Task Implementation workflow following the steps in `.agent/workflows/implement-task.md`.

**Workflow Overview:**

**Phase 1: Thu thập thông tin**
- Hỏi Task ID cần implement (VD: `WP-INF-001-T001`)
- Hỏi đường dẫn đến file Phase Plan chứa task

**Phase 2: Đọc và phân tích Task**
- Tìm task theo TASK_ID trong file plan
- Trích xuất thông tin:
  - **ID**: Task ID
  - **Type**: setup | feature | integration | test | docs
  - **Description**: Mô tả chi tiết
  - **Commands**: Các lệnh cần chạy (nếu có)
  - **Files to Create/Modify**: Danh sách files
  - **Code Template**: Mẫu code (nếu có)
  - **Acceptance Criteria**: Tiêu chí hoàn thành
  - **Estimated Hours**: Thời gian ước tính
  - **DD Reference**: Tham chiếu đến Detailed Design

**Phase 3: XÁC NHẬN với người dùng (BẮT BUỘC)**
- Hiển thị bảng thông tin task
- Liệt kê các bước thực hiện
- Liệt kê files sẽ tạo/sửa
- Liệt kê commands sẽ chạy
- CHỜ người dùng xác nhận trước khi tiếp tục

**Phase 4: Thực thi Task**
Sau khi người dùng xác nhận:
1. Chạy Commands (nếu có) - Kiểm tra output, dừng nếu lỗi
2. Tạo/Sửa Files theo template - Code đầy đủ, không placeholder
3. Verify hoàn thành - Kiểm tra acceptance criteria

**Phase 5: Báo cáo kết quả**
- Kết quả thực hiện: Commands, Files, Verification
- Danh sách files đã tạo/sửa
- Acceptance Criteria đã đạt
- Hướng dẫn cập nhật CHECKLIST.md

**Task Types:**
- **setup**: Chạy commands, tạo config files, verify installation
- **feature**: Tạo source code, implement logic, đọc DD Reference
- **integration**: Kết nối external services, cấu hình API keys
- **test**: Tạo test files, implement test cases, chạy tests
- **docs**: Tạo documentation files

**Important Notes:**
- KHÔNG được bỏ sót nội dung - implement 100% task
- Đọc DD Reference nếu có để lấy thêm chi tiết
- KHÔNG giả định - hỏi người dùng nếu thiếu thông tin
- Real Code Only - không dùng TODO hoặc placeholder

Start by asking for the Task ID and Plan file path.
