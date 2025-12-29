---
description: Tạo System Requirement Specification (SRS) document từ thông tin người dùng
---

Execute the SRS creation workflow following the steps in `.agent/workflows/create-srs.md`.

**Workflow Overview:**

1. **Thu thập tham số**: Hỏi folder path, tên file input, tài liệu tham khảo
2. **Kiểm tra tham số**: Xác nhận folder và file tồn tại
3. **Load hướng dẫn**: Đọc `.ai-instructions/system-requirement-specification-instructions.md`
4. **Load form input**: Đọc file input từ folder đã chỉ định
5. **Tạo SRS**: Tạo 7 files trong thư mục `システム要件定義書/`
6. **Checklist**: Kiểm tra với checklist và ghi kết quả
7. **Tổng kết**: Report kết quả và các mục cần review

**Important Notes:**
- File input phải theo template trong `.ai-instructions/system-requirement-specification-form-template.md`
- Mặc định sử dụng Tiếng Nhật, có thể thay đổi theo form input
- Tất cả quyết định AI phải ghi vào Decision Log

Start by asking for the folder path and input file information.
