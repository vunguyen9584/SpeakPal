# DD Review Steps Guide

> Hướng dẫn chi tiết các bước review tài liệu Detailed Design (DD).

---

## 1. Review Mapping & Foundation (00-04)

### 00-bd-dd-mapping.md

- [ ] **Coverage Check**: So sánh số lượng items trong BD (List) và trong Mapping table. Phải khớp 100%.
- [ ] **Links**: Kiểm tra ngẫu nhiên 5-10 links xem có trỏ đúng đến section trong DD không.

### 01-04 (Intro, Ref, Overview, Considerations)

- [ ] Tính nhất quán với SRS và BD.
- [ ] Design decisions có được giải thích rõ ràng không (tại sao chọn pattern này, lib kia).

---

## 2. Review Core Logic (05-06)

### 05-module-design.md

- [ ] **Class Design**: Class names, Methods, Attributes có tuân thủ quy tắc đặt tên không?
- [ ] **Relationships**: Access modifiers (public/private) và Dependencies có hợp lý không?

### 06-component-design.md

- [ ] **Completeness**: Mọi UC phức tạp đều PHẢI có pseudocode hoặc flow chi tiết.
- [ ] **Logic**: Pseudocode có xử lý edge cases và exceptions không?
- [ ] **Traceability**: Business Rules từ BD có được reflect trong logic không?

---

## 3. Review Data & Interfaces (07-08)

### 07-database-design.md

- [ ] **Physical Design**: Data types (VARCHAR vs TEXT, INT vs BIGINT) có tối ưu không?
- [ ] **Performance**: Indexes có được thiết kế dựa trên query patterns trong Component Design không?

### 08-api-design.md

- [ ] **Consistency**: Tên field trong Request/Response có khớp với Database columns hoặc UI fields không?
- [ ] **Validation**: Rules có đủ chi tiết (length, format, regex) để dev implement không?

---

## 4. Review UI Specifications (09)

### 09-ui-specifications.md

- [ ] **State Management**: Có mô tả state của màn hình (loading, error, success) không?
- [ ] **Interactions**: Xử lý click events, transitions có rõ ràng không?

---

## 5. Review Quality & Support (10-14)

- [ ] **Security (10)**: Có hướng dẫn cụ thể implementation (vd: dùng thư viện nào để hash password)?
- [ ] **Error Handling (11)**: Có danh sách Error Codes đầy đủ và message tương ứng?
- [ ] **Logging (12)**: Có quy định format log để tích hợp với monitoring tool không?
- [ ] **Deployment (13)**: Có file config template (env.example) không?

---

## 6. Cross-Reference Verification (⚠️ QUAN TRỌNG)

> 🔴 BẮT BUỘC: Kiểm tra mẫu ít nhất 3 flows từ đầu đến cuối

1. **Top-Down Check**:

   - Chọn 1 UC phức tạp.
   - Check Component Design (Logic) → Check API (Endpoint) → Check DB (Query).
   - Đảm bảo logic flow liền mạch và data types khớp nhau.

2. **UI-Backend Check**:
   - Chọn 1 Screen Input form.
   - Check UI Specs (Validation) → Check API Specs (Validation) → Check DB (Constraints).
   - Đảm bảo validation rules nhất quán.

---

## 7. Đếm và đối chiếu

| Loại Items | Trong BD | Trong DD Mapping | Trong DD Specs   | Đánh giá |
| :--------- | :------- | :--------------- | :--------------- | :------- |
| Use Cases  | X        | X                | X (Detailed/Ref) | ✅/❌    |
| Screens    | Y        | Y                | Y (Detailed/Ref) | ✅/❌    |
| Tables     | Z        | Z                | Z (DDL)          | ✅/❌    |
| APIs       | W        | W                | W (Specs)        | ✅/❌    |
