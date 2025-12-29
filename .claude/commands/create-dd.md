---
description: Tạo Detailed Design Document từ SRS và Basic Design
---

Execute the Detailed Design Document creation workflow following the steps in `.agent/workflows/create-dd.md`.

**Workflow Overview:**

1. **Thu thập tham số**: Hỏi folder path chứa input/output
2. **Kiểm tra tham số**: Xác nhận folder và file tồn tại
3. **Kiểm tra Progress**: Load hoặc tạo mới `dd-progress.md`
4. **Load tài liệu**: Load SRS, BD, và các instruction files
5. **Tạo BD-DD Mapping**: File `00-bd-dd-mapping.md` (100% coverage)
6. **Tạo DD**: 16 files từ 00-15, check content requirements sau mỗi file
7. **Validation**: Run validation script
8. **Checklist**: Kiểm tra và lưu kết quả
9. **Final Verification**: Check CRITICAL/REQUIRED items
10. **Tổng kết**: Report kết quả

**Important Notes:**
- Always check `dd-progress.md` to resume from last checkpoint
- Check `dd-content-requirements.md` after creating each file
- CRITICAL items (🔴) must not be missing
- Update progress after each chapter

Start by asking for the folder path containing SRS and Basic Design documents.
