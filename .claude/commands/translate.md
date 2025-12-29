---
description: Dịch tài liệu sang ngôn ngữ khác, giữ nguyên format và nội dung gốc
---

Execute the document translation workflow following the steps in `.agent/workflows/translate.md`.

**Workflow Overview:**

1. **Thu thập thông tin**: Hỏi đường dẫn file cần dịch và ngôn ngữ đích
2. **Xác định mã ngôn ngữ**: Chuyển đổi thành ISO 639-1 (en, vi, ja, zh, ko, etc.)
3. **Xác định output path**: `[tên_gốc]_[mã_ngôn_ngữ].[đuôi_file]`
4. **Đọc và dịch**: Dịch nội dung văn bản, giữ nguyên format
5. **Tạo file output**: Lưu file đã dịch
6. **Xác nhận hoàn thành**: Thông báo kết quả

**Translation Rules:**
- Chỉ dịch nội dung văn bản
- KHÔNG thay đổi: Code blocks, URLs, tên file, số liệu, format markdown
- KHÔNG thêm nội dung: Không ghi chú, header/footer, disclaimer
- Giữ nguyên: Indentation, special characters, frontmatter

**Special Cases:**
- Comments trong code: Dịch
- Alt text của hình ảnh: Dịch
- Thuật ngữ kỹ thuật phổ biến: Có thể giữ nguyên tiếng Anh

Start by asking for the file path and target language.
