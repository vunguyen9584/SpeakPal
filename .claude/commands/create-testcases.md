---
description: Tạo Test Case để kiểm tra toàn diện các chức năng của hệ thống từ tài liệu dự án
---

Execute the Test Case creation workflow following the steps in `.agent/workflows/create-testcases.md`.

**Workflow Overview:**

1. **Thu thập tham số**: Hỏi thư mục dự án và phạm vi tạo test
2. **Kiểm tra tài liệu**: Xác định SRS (BẮT BUỘC), Basic Design, Detailed Design
3. **Load hướng dẫn**: Đọc `.ai-instructions/test-case-generation-instructions.md`
4. **Phân tích tài liệu**: Lazy loading, xây dựng Feature Map
5. **Xác định cấu trúc**: Phân nhóm chức năng, xác nhận với người dùng
6. **Tạo Test Cases**: Tạo _index.md và các file TC_xxx.md
7. **Tạo Checklist**: `application-testing-checklist.md` với coverage
8. **Validation**: Self-check và coverage check (>= 90%)

**Output Structure:**
```
[project_folder]/[テスト_folder]/
├── _index.md
├── TC_Authentication.md
├── TC_UserManagement.md
├── TC_Integration.md
└── ...
```

**Important Notes:**
- Mỗi requirement phải có ít nhất 1 test case
- Bao gồm happy path và error cases
- Test data rõ ràng, expected result cụ thể
- Ngôn ngữ test case theo ngôn ngữ SRS

Start by asking for the project folder path.
