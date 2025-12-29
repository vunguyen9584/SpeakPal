# Make-Plan Final Validation Checklist

> ⚠️ **Nếu BẤT KỲ item nào chưa pass → KHÔNG ĐƯỢC XEM LÀ HOÀN THÀNH!**

---

## Phase 1: Implementation Plan

- [ ] `Implementation_Plan.md` được tạo
- [ ] Liệt kê TẤT CẢ modules từ DD
- [ ] Liệt kê TẾT CẢ Use Cases từ DD
- [ ] Liệt kê TẤT CẢ APIs từ DD
- [ ] Liệt kê TẤT CẢ database tables từ DD
- [ ] Liệt kê TẤT CẢ UI screens từ DD
- [ ] Liệt kê TẤT CẢ Batch jobs từ DD
- [ ] Liệt kê Security requirements từ DD
- [ ] Liệt kê Error handling requirements từ DD
- [ ] Xác định TẤT CẢ BD Reference items
- [ ] Đã đọc BD cho TẤT CẢ BD Reference items
- [ ] Coverage table cho thấy 100%

---

## Phase 1.5: Interface Contracts

- [ ] `Interface_Contracts.md` được tạo
- [ ] Shared Types định nghĩa đầy đủ (từ DD)
- [ ] Mỗi module có interface (từ DD 04-module-design)
- [ ] Cross-module integration points được document
- [ ] Dependency graph chính xác

---

## Phase 2: Module Folders

> 🚨 **NGHIÊM TRỌNG** - Thiếu module = Thiếu features!

- [ ] **Đếm modules trong DD:** \_\_\_\_ modules
- [ ] **Đếm folders Module_XX:** \_\_\_\_ folders
- [ ] **Hai số trên PHẢI TƯƠNG ĐƯƠNG!**
- [ ] Mỗi folder có `_module_overview.md`
- [ ] TẤT CẢ links trong Master_Plan.md hoạt động
- [ ] **Module_99_Batch/** có với TẤT CẢ batch jobs
- [ ] **Module cho Security** có
- [ ] **Module cho Error Handling** có

---

## Phase 2.5: BD Reference Coverage

> ⚠️ **Thiếu bước này = Bỏ sót features từ BD!**

- [ ] **Đếm BD Reference items trong DD:** \_\_\_\_ items
- [ ] **Đếm tasks cho BD Reference items:** \_\_\_\_ tasks
- [ ] **Hai số trên PHẢI BẰNG NHAU!**
- [ ] Mỗi BD Reference item có:
  - [ ] Task tương ứng
  - [ ] DD Reference (bảng coverage)
  - [ ] BD Reference (section chi tiết)
  - [ ] Requirements extracted từ BD

---

## Phase 3: Test Cases

- [ ] Mỗi module có `test_cases.md` (hoặc ghi rõ lý do không cần)
- [ ] Test cases cover TẤT CẢ APIs trong module
- [ ] Test cases cover TẤT CẢ business logic quan trọng
- [ ] Test cases cho Batch jobs
- [ ] Test cases cho Security features

---

## Phase 4: CHECKLIST.md

- [ ] `CHECKLIST.md` được tạo
- [ ] Liệt kê TẤT CẢ tasks từ tất cả modules
- [ ] Có Progress Summary table
- [ ] Có cột BD Ref Items trong summary
- [ ] Có Session Log section

---

## Phase 4.2: CHECKLIST Validation

- [ ] `CHECKLIST_Validation.md` được tạo
- [ ] Cross-check với DD: Modules count matches
- [ ] Cross-check với DD: Use Cases count matches
- [ ] Cross-check với DD: APIs count matches
- [ ] Cross-check với DD: Tables count matches
- [ ] Cross-check với DD: Screens count matches
- [ ] Cross-check với DD: Batches count matches
- [ ] Cross-check: BD Reference items count matches
- [ ] VERDICT: 100% coverage confirmed

---

## Phase 5: Integration

- [ ] `Module_99_Batch/` được tạo với TẤT CẢ batch jobs
- [ ] `Module_99_Integration/` được tạo
- [ ] Có `_module_overview.md`
- [ ] Có `integration_test_cases.md`

---

## Phase 5.3: Frontend-API Integration

> ⚠️ **Thiếu phần này = Hệ thống không hoạt động sau khi implement!**

### Screen-API Mapping

- [ ] Liệt kê TẤT CẢ screens từ DD (08-ui-specifications)
- [ ] Mỗi screen có APIs cần gọi
- [ ] Tổng số screens: \_\_\_\_ (phải match với DD)

### API Coverage

- [ ] Tất cả API endpoints được gọi từ ít nhất 1 Screen
- [ ] Không có "orphan API" (API không được gọi từ đâu)

### Error Handling

- [ ] Timeout handling documented
- [ ] Error response handling documented
- [ ] Offline handling documented
- [ ] Session expired handling documented

### Integration Tests

- [ ] Test cases cho Screen-API integration

---

## Master_Plan.md Quality Check

- [ ] Tổng số tasks = Sum of all module tasks
- [ ] Mỗi task có link đến module folder
- [ ] Mỗi link THỰC SỰ trỏ đến folder tồn tại
- [ ] Không có broken links
- [ ] BD Reference items được đánh dấu rõ ràng

---

## Sanity Check Commands

```powershell
# Verify module structure:
tree /F "{working_dir}/TaskList" | Select-String "Module_"

# Count modules:
Get-ChildItem "{working_dir}/TaskList" -Directory | Measure-Object
```

---

## Final Report Template

Sau khi hoàn thành, báo cáo theo format:

```
✅ Modules created: X/X
✅ Links verified: X/X
✅ Tasks tracked: X total
✅ BD Reference items: X items (all read from BD)
✅ Batch jobs: X jobs included
✅ Security tasks: Included
✅ Error handling tasks: Included
✅ Screen-API mapping: X screens mapped
✅ API coverage: X/X endpoints mapped
✅ Ready for implementation
```

---

_Created: 2025-12-21_
_For use with: /make-plan workflow_
