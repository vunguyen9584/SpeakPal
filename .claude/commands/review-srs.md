---
description: Review tài liệu đặc tả yêu cầu (SRS) sử dụng checklist chuẩn
---

Execute the SRS review workflow following the steps in `.agent/workflows/review-srs.md`.

**Workflow Overview:**

1. **Thu thập tham số**: Hỏi folder path chứa SRS
2. **Kiểm tra file**: Xác nhận SRS và checklist tồn tại
3. **Load checklist**: Đọc `.ai-instructions/system-requirement-specification-checklist.md`
4. **Review 8 sections**: Tổng quan, Giới thiệu, Yêu cầu chức năng, Yêu cầu phi chức năng, Chất lượng, Giao diện, Dữ liệu, Truy xuất
5. **Tạo kết quả**: Output file `system-requirement-specification-checklist.md`
6. **Tổng kết**: Báo cáo ✅/❌/⚠️ và các action items

**Important Notes:**
- Chỉ load file SRS con khi cần cho section đang review (lazy loading)
- Mỗi mục ❌ hoặc ⚠️ phải có giải thích và đề xuất
- Kết luận: Đạt / Đạt có điều kiện / Không đạt

Start by asking for the folder path containing SRS documents.
