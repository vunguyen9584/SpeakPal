---
description: Tạo Basic Design Document từ SRS
---

Execute the Basic Design Document creation workflow following the steps in `.agent/workflows/create-bd.md`.

**Workflow Overview:**

1. **Thu thập tham số**: Hỏi folder path chứa SRS
2. **Kiểm tra SRS**: Xác nhận folder SRS tồn tại
3. **Load tài liệu**: Load SRS và các instruction files từ `.ai-instructions/`
4. **Tạo cấu trúc**: Tạo thư mục `基本設計書/` và các sub-folders
5. **Tạo nội dung**: Tạo files theo thứ tự dependencies
6. **Coverage Check**: Đảm bảo 100% coverage cho tất cả items
7. **Kiểm tra Checklist**: Verify với các BD checklists
8. **Tổng kết**: Cập nhật progress và report kết quả

**Important Notes:**
- SRS là bắt buộc - phải có trước khi tạo BD
- Chương 03-07 PHẢI dùng cấu trúc Main + Folder
- Mỗi folder PHẢI có `_index.md`
- Coverage phải đạt 100% cho tất cả items
- Tham khảo `bd-file-folder-structure.md` cho chi tiết cấu trúc

Start by asking for the folder path containing SRS documents.
