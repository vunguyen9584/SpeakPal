# API Design Checklist

> 📋 Checklist này được sử dụng để kiểm tra tính đầy đủ và chất lượng của tài liệu **API Design** trong Basic Design.

---

## 1. Cấu trúc tài liệu

- [ ] Có section **API 設計方針/API Design Policy** với quy ước endpoint
- [ ] Có section **Action/Endpoint 一覧** phân theo module/feature
- [ ] Có section **API 詳細/API Details** với request/response schemas
- [ ] Có section **Form Submission 仕様** (nếu có form-based submission)
- [ ] Có section **Security Design** (Auth, Authorization, Input Validation)
- [ ] Có section **Response Format** (Success/Error formats)
- [ ] Có section **Error Code 一覧** với mã lỗi thống nhất
- [ ] Có section **UC ↔ API Traceability Matrix**

---

## 2. Use Case Coverage (UC ↔ API Mapping)

> 🔴 **QUAN TRỌNG**: Mỗi UC (trừ Background UC) PHẢI có ít nhất 1 Action/API tương ứng

### 2.1. Phương pháp kiểm tra

1. Liệt kê tất cả UC từ Functional Design
2. Phân loại UC:
   - **Interactive UC**: Cần có API/Action
   - **Background UC**: Batch processing, scheduled jobs → Không cần API
3. Với mỗi Interactive UC, xác định API/Action tương ứng
4. Tính Coverage Rate

### 2.2. Kiểm tra theo loại UC

| UC Type                  | Yêu cầu API                             |
| ------------------------ | --------------------------------------- |
| CRUD operations          | Create, Read, Update, Delete endpoints  |
| List/Search              | List endpoint với filtering, pagination |
| Status change            | Endpoint cho mỗi action thay đổi status |
| Workflow actions         | Endpoint cho mỗi workflow step          |
| User actions from Screen | Mỗi button/action cần endpoint          |
| Background processes     | Không cần API, ghi chú N/A              |

### 2.3. Common patterns thường bị thiếu

Kiểm tra các pattern sau có trong ứng dụng không, nếu có thì đảm bảo có API:

- [ ] **Workflow/Approval actions**: Không chỉ approve/reject, còn có các actions khác không?
- [ ] **Bulk operations**: Có bulk update/delete/action không?
- [ ] **Settings/Configuration**: Có admin settings cần API không?
- [ ] **Audit/History**: Có xem lịch sử, audit log không?
- [ ] **Delegation/Proxy**: Có ủy quyền, đại diện không?
- [ ] **Export/Report**: Có xuất báo cáo, export data không?
- [ ] **Search/Autocomplete**: Có tìm kiếm realtime, gợi ý không?
- [ ] **Master data**: Có API lấy dropdown data không?

---

## 3. API Details Quality

### 3.1. Mỗi API phải có đủ thông tin

- [ ] **Identification**: API ID, Endpoint URL, HTTP Method
- [ ] **Description**: Mô tả chức năng
- [ ] **Authentication**: Required or not, method
- [ ] **Authorization**: Required roles/permissions
- [ ] **Request**: Parameters, Body schema, Validation rules
- [ ] **Response Success**: HTTP status, Response schema, Example
- [ ] **Response Error**: Error codes, HTTP status, Error schema

### 3.2. Request Specification

- [ ] Có danh sách parameters (path, query, body)
- [ ] Mỗi parameter có: Name, Type, Required, Description
- [ ] Validation rules được định nghĩa rõ ràng
- [ ] Data types consistent với Data Design

### 3.3. Response Specification

- [ ] Success response có example JSON/XML
- [ ] Error responses được định nghĩa
- [ ] HTTP status codes phù hợp (200, 201, 400, 401, 403, 404, 500)

---

## 4. Form/Action Submission (nếu có)

### 4.1. Mỗi Form Specification phải có đủ

- [ ] **Action info**: URL, Method, Content-Type
- [ ] **Navigation**: Success redirect, Failure redirect
- [ ] **Parameters**: Field name, Type, Required, Max length
- [ ] **Validation Rules**: Chi tiết cho từng field

### 4.2. Cross-reference với Screen Design

- [ ] Mỗi form trong Screen Design có Form Specification
- [ ] Form parameters match với screen input fields
- [ ] Validation rules consistent

---

## 5. Security Design

- [ ] **Authentication method** được định nghĩa (Session, JWT, OAuth, etc.)
- [ ] **Session management** (timeout, storage, etc.)
- [ ] **CSRF Protection** (nếu applicable)
- [ ] **Authorization** strategy (Role-based, Resource-based, etc.)
- [ ] **Password policy** (nếu có authentication)
- [ ] **Input Validation** rules cho các loại input (String, Number, Date, File, ID)
- [ ] **Rate limiting** (nếu applicable)

---

## 6. Error Handling

### 6.1. Error Response Format

- [ ] Có định nghĩa **Error Response Format** thống nhất
- [ ] Format bao gồm: error code, message, details (optional)
- [ ] HTTP status codes được map đúng

### 6.2. Error Code System

- [ ] Có **Error Code Naming Convention** (e.g., CATEGORY-TYPE-NUMBER)
- [ ] Có danh sách Error Codes được document
- [ ] Mỗi error code có: Code, HTTP Status, Message, Description

---

## 7. Traceability Matrix

> 🔴 **BẮT BUỘC**: Tài liệu PHẢI có UC ↔ API Traceability Matrix

### 7.1. Matrix Structure

- [ ] Tất cả UC từ Functional Design được liệt kê
- [ ] Mỗi UC có cột Related API/Action
- [ ] Có cột Status (✅ Complete / ❌ Missing / N/A Background)
- [ ] Background UCs được đánh dấu N/A với ghi chú

### 7.2. Coverage Calculation

```
Coverage = (UCs có API) / (Tổng Interactive UCs) × 100%

Target: 100%

Nếu Coverage < 100% → Có UC thiếu API → ❌ KHÔNG ĐẠT
```

---

## 8. Cross-reference Checks

### 8.1. API ↔ Screen Design

- [ ] Mỗi user action trên màn hình có API/Action tương ứng
- [ ] AJAX calls trong Screen Design có API definition
- [ ] Form submissions có Form Specification

### 8.2. API ↔ Data Design

- [ ] Request/Response data match với database schema
- [ ] Validation rules consistent với database constraints
- [ ] Foreign key references valid

### 8.3. API ↔ Functional Design

- [ ] Tất cả operations trong Sequence Diagrams có API
- [ ] Business rules trong UC được phản ánh trong API

---

## 9. Consistency Checks

- [ ] **Naming Convention** thống nhất (camelCase, snake_case, etc.)
- [ ] **ID Format** thống nhất (API-001, UC-001, etc.)
- [ ] **URL Pattern** thống nhất (REST style, action-based, etc.)
- [ ] **HTTP Methods** sử dụng đúng (GET for read, POST for create, etc.)
- [ ] **Data Types** consistent giữa API và Data Design

---

## 10. Completeness Summary

### 10.1. Đếm và đối chiếu

| Item              | Trong danh sách | Có chi tiết | Thiếu | Đánh giá |
| ----------------- | --------------- | ----------- | ----- | -------- |
| Actions/Endpoints | X               | Y           | X-Y   | ✅/❌    |
| AJAX APIs         | X               | Y           | X-Y   | ✅/⚠️    |
| Form Specs        | X               | Y           | X-Y   | ✅/⚠️    |
| UC→API Mapping    | X               | Y           | X-Y   | ✅/❌    |
| Error Codes       | X               | Y           | X-Y   | ✅/⚠️    |

### 10.2. Coverage Targets

| Metric               | Target | Actual | Status |
| -------------------- | ------ | ------ | ------ |
| UC Coverage          | 100%   |        |        |
| API Details Complete | 100%   |        |        |
| Error Codes Defined  | >80%   |        |        |
| Form Specs Complete  | 100%   |        |        |

---

## 📋 Kết quả Review

| Hạng mục            | Đạt | Không đạt | Ghi chú |
| ------------------- | --- | --------- | ------- |
| Cấu trúc tài liệu   |     |           |         |
| UC Coverage         |     |           |         |
| API Details         |     |           |         |
| Form Specifications |     |           |         |
| Security Design     |     |           |         |
| Error Handling      |     |           |         |
| Traceability Matrix |     |           |         |
| Cross-reference     |     |           |         |
| Consistency         |     |           |         |

**Kết luận:** ☐ Đạt / ☐ Đạt có điều kiện / ☐ Không đạt

---

## 📝 Template: Items cần bổ sung

### UCs thiếu API:

- [ ] UC-XXX: [Tên UC] - Cần thêm API/Action

### APIs thiếu chi tiết:

- [ ] API-XXX: [Endpoint] - Cần thêm request/response schema

### Forms thiếu specification:

- [ ] [Screen ID]: [Form name] - Cần thêm form specification

### Common patterns bị thiếu:

- [ ] [Pattern type]: Cần thêm API cho [feature description]
