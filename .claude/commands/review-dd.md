---
description: Review Detailed Design Document sử dụng checklist chuẩn
---

Execute the Detailed Design Document review workflow following the steps in `.agent/workflows/review-dd.md`.

**Workflow Overview:**

1. **Thu thập tham số**: Hỏi folder path chứa DD hoặc nhận trực tiếp path
2. **Kiểm tra file tồn tại**: Xác nhận folder `詳細設計書` tồn tại
3. **Load tài liệu tham khảo**: Load checklist và requirements từ `.ai-instructions/`
4. **Content Requirements Check (🔴 QUAN TRỌNG NHẤT)**:
   - Check CRITICAL items: 17/17 (FAIL nếu thiếu)
   - Check REQUIRED items: ≥70% (53/76)
   - Đánh giá: PASS/CONDITIONAL PASS/FAIL
5. **Traditional Review**: Foundation, Core Logic, Data & Interfaces, UI & Others
6. **Cross-Reference Verification**: Logic, Data, Interface, UI, E2E flows
7. **Tạo file kết quả**: Generate `dd-review-report.md`
8. **Tổng kết**: Display final verdict and action items

**FAIL Conditions:**
- ❌ CRITICAL < 17/17
- ❌ REQUIRED < 50% (38/76)
- ❌ Coverage mapping < 100%
- ❌ Missing DDL for tables or OpenAPI for APIs
- ❌ Missing Document Information, Actor mapping, or Design Decisions in 03-system-overview

**Pass Criteria:**
- ✅ PASS: CRITICAL 17/17 + REQUIRED ≥70% + Coverage 100%
- ⚠️ CONDITIONAL PASS: CRITICAL 17/17 + REQUIRED 50-69%

Start by asking for the folder path containing the DD document to review.
