---
description: Review tài liệu Basic Design sử dụng checklist chuẩn
---

Execute the Basic Design review workflow following the steps in `.agent/workflows/review-bd.md`.

**Workflow Overview:**

1. **Thu thập tham số**: Hỏi folder path chứa BD
2. **Kiểm tra file**: Xác nhận folder BD tồn tại
3. **Chạy Validation**: Run `validate-bd-coverage.js` script
4. **Load tài liệu**: Load BD, SRS (nếu có), và instruction files
5. **Kiểm tra cấu trúc**: Verify Main + Folder structure cho chương 03-07
6. **Coverage Check**: Đảm bảo 100% coverage (CRITICAL)
7. **Review sections**: Kiểm tra từng section với checklists
8. **Cross-Reference Check**: Verify FR→UC, UC→Screen, UC→API mappings
9. **Tạo báo cáo**: Tạo `basic-design-review-report.md`
10. **Tổng kết**: Hiển thị summary và verdict

**Important Notes:**
- Kiểm tra File/Folder Structure TRƯỚC KHI review nội dung
- Coverage < 100% = FAIL dù các tiêu chí khác OK
- Tất cả links phải valid (không broken links)
- Tham khảo `bd-checklist-summary.md` cho chi tiết checklist

Start by asking for the folder path containing Basic Design documents.
