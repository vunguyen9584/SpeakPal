# BD Functional Design Checklist

> Checklist chi tiết cho file Functional Design trong Basic Design

---

## 1. Coverage Check

> 🔴 **BẮT BUỘC**: Functional Design PHẢI cover 100% FRs từ SRS

| #   | Mục kiểm tra                                 | Trạng thái |
| --- | -------------------------------------------- | ---------- |
| 1   | Có section Requirement Coverage Summary?     | ☐          |
| 2   | Có FR→UC Mapping Table với TẤT CẢ FR từ SRS? | ☐          |
| 3   | Coverage rate = 100% cho Must priority?      | ☐          |
| 4   | Coverage rate = 100% cho Should priority?    | ☐          |
| 5   | Coverage rate = 100% cho Could priority?     | ☐          |

---

## 2. Use Case Details Check

> 🚨 **CRITICAL - ĐÂY LÀ KIỂM TRA QUAN TRỌNG NHẤT!**
> Thiếu UC Details = **FAIL toàn bộ Functional Design**
> KHÔNG ĐƯỢC đánh giá PASS nếu Coverage < 100%!

### 2.1 Đếm và đối chiếu (BẮT BUỘC)

**Quy trình kiểm tra:**

```
BƯỚC 1: Đếm UC trong danh sách
  - Tìm tất cả bảng "ユースケース一覧" hoặc "Use Case List"
  - Đếm số dòng data (không tính header)
  - Ghi lại: UC_Count_In_List = [số]

BƯỚC 2: Đếm UC có chi tiết
  - Tìm tất cả section "### X.X.X. UC-XXX-YYY:"
  - Mỗi section phải có:
    ✓ Bảng 基本情報 (Basic Info)
    ✓ シーケンス図 (Sequence Diagram)
  - Ghi lại: UC_Count_Detailed = [số]

BƯỚC 3: Tính Coverage
  - Coverage = UC_Count_Detailed / UC_Count_In_List * 100%
  - Điền vào bảng dưới đây
```

### 2.2 Bảng đối chiếu

| Module    | UC trong DS | UC chi tiết | Thiếu      | Coverage    | OK? |
| --------- | ----------- | ----------- | ---------- | ----------- | --- |
| PLM       | \_\_\_      | \_\_\_      | \_\_\_     | \_\_\_%     | ☐   |
| APS       | \_\_\_      | \_\_\_      | \_\_\_     | \_\_\_%     | ☐   |
| Common    | \_\_\_      | \_\_\_      | \_\_\_     | \_\_\_%     | ☐   |
| **TOTAL** | **\_\_\_**  | **\_\_\_**  | **\_\_\_** | **\_\_\_%** | ☐   |

### 2.3 Tiêu chuẩn đánh giá

| Coverage   | Verdict            | Hành động                         |
| ---------- | ------------------ | --------------------------------- |
| **100%**   | ✅ PASS            | Tiếp tục kiểm tra các mục khác    |
| **80-99%** | ❌ FAIL (Minor)    | Liệt kê UC thiếu, yêu cầu bổ sung |
| **50-79%** | ❌ FAIL (Major)    | Document chưa đầy đủ nghiêm trọng |
| **< 50%**  | ❌ FAIL (Critical) | Document chưa hoàn thành          |

> ⚠️ **CẢNH BÁO**: Document chỉ có danh sách UC mà thiếu chi tiết = **CHƯA HOÀN THÀNH**!

### 2.4 Checklist chi tiết

| #   | Mục kiểm tra                                         | Trạng thái |
| --- | ---------------------------------------------------- | ---------- |
| 1   | **Số UC trong bảng = Số UC có chi tiết?**            | ☐          |
| 2   | Mỗi UC có Basic Information section?                 | ☐          |
| 3   | Mỗi UC có Sequence Diagram?                          | ☐          |
| 4   | Sequence diagram có đầy đủ các participants?         | ☐          |
| 5   | Sequence diagram có xử lý cả success và error paths? | ☐          |

### 2.5 UC Basic Information Required Fields

Mỗi UC cần có:

- [ ] UC ID
- [ ] UC Name
- [ ] Related FR IDs
- [ ] Actor(s)
- [ ] Priority
- [ ] Pre-conditions
- [ ] Post-conditions

---

## 3. Validation Rules Check

> 🔴 **BẮT BUỘC**: Các UC có input form PHẢI có bảng Validation Rules.

### 3.1 UC Types cần Validation Rules

| UC Type               | Cần Validation? | Example                           |
| --------------------- | --------------- | --------------------------------- |
| Login/Authentication  | ✅              | Email format, password strength   |
| Registration          | ✅              | Required fields, email uniqueness |
| Create/Edit Form      | ✅              | Field lengths, formats, required  |
| Approval with Comment | ✅              | Comment required when reject      |
| Data Entry            | ✅              | Number ranges, date formats       |
| File Upload           | ✅              | File size, type, count            |
| Search/Filter         | 🟡              | Query length, date ranges         |
| View/List Only        | ❌              | No input = no validation          |

### 3.2 Checklist

| #   | Mục kiểm tra                                       | Trạng thái |
| --- | -------------------------------------------------- | ---------- |
| 1   | Tất cả UC có form input → có Validation section?   | ☐          |
| 2   | Validation rules khớp với SRS requirements?        | ☐          |
| 3   | Validation rules khớp với Data Design constraints? | ☐          |

---

## 4. Business Rules Check

| #   | Mục kiểm tra                                | Trạng thái |
| --- | ------------------------------------------- | ---------- |
| 1   | Tất cả BR từ SRS được kế thừa?              | ☐          |
| 2   | Các UC liên quan có tham chiếu đến đúng BR? | ☐          |
| 3   | Có BR mới được bổ sung nếu cần?             | ☐          |
| 4   | BR có ID thống nhất (BR-001, etc.)?         | ☐          |

---

## 5. Alternative & Exception Flow Check

> 🟡 **NÊN CÓ**: Các UC quan trọng nên có alternative/exception flows.

### 5.1 UC Types cần Alt/Exception Flow

| UC Type         | Alternative Flow Examples | Exception Flow Examples      |
| --------------- | ------------------------- | ---------------------------- |
| Authentication  | Forgot password, SSO      | Auth failed, account locked  |
| CRUD            | Edit mode, Clone          | Duplicate, not found         |
| Submit          | Save draft                | Missing required fields      |
| Workflow Action | Approve, Reject, Revise   | Permission denied            |
| File Operation  | Replace, Delete           | File too large, invalid type |

### 5.2 Checklist

| #   | Mục kiểm tra                                  | Trạng thái |
| --- | --------------------------------------------- | ---------- |
| 1   | Các critical UC có alternative flows?         | ☐          |
| 2   | Các UC có error scenarios có exception flows? | ☐          |
| 3   | Exception handling được mô tả rõ ràng?        | ☐          |

---

## 6. State Transition Check

> Áp dụng cho hệ thống có workflow/status-based entities

| #   | Mục kiểm tra                                    | Trạng thái |
| --- | ----------------------------------------------- | ---------- |
| 1   | Có section Business Flow hoặc State Transition? | ☐          |
| 2   | Có flowchart cho entity lifecycle?              | ☐          |
| 3   | Có State Transition Matrix?                     | ☐          |
| 4   | Matrix khớp với SRS business rules?             | ☐          |
| 5   | Tất cả transitions có điều kiện rõ ràng?        | ☐          |

---

## 7. Action Classification Check

> 🔴 **BẮT BUỘC**: Đảm bảo các loại actions được phân loại rõ ràng.

### 7.1 Action Types

| Type                  | Mô tả                      | Ảnh hưởng Status? | Example                     |
| --------------------- | -------------------------- | ----------------- | --------------------------- |
| **Status Transition** | Thay đổi trạng thái entity | ✅ Yes            | Submit, Approve, Reject     |
| **Side Action**       | Thao tác không đổi status  | ❌ No             | Comment, Escalate, Delegate |
| **Background Action** | Xử lý tự động/scheduled    | Depends           | Send notification, Reminder |

### 7.2 Checklist

| #   | Mục kiểm tra                                      | Trạng thái |
| --- | ------------------------------------------------- | ---------- |
| 1   | Side Actions có được highlight trong flowchart?   | ☐          |
| 2   | Side Actions có note giải thích không đổi status? | ☐          |
| 3   | Mỗi Side Action có sequence diagram riêng?        | ☐          |
| 4   | Background Actions được liệt kê?                  | ☐          |
| 5   | Background Actions có trigger conditions?         | ☐          |

---

## 8. Module Organization Check

| #   | Mục kiểm tra                | Trạng thái |
| --- | --------------------------- | ---------- |
| 1   | Có Module Overview section? | ☐          |
| 2   | Có Module List tổng hợp?    | ☐          |
| 3   | UC được group theo module?  | ☐          |
| 4   | Mỗi module có mô tả ngắn?   | ☐          |

---

## 9. Cross-Reference Check

| #   | Mục kiểm tra                                           | Trạng thái |
| --- | ------------------------------------------------------ | ---------- |
| 1   | FR IDs trong UC tham chiếu đúng SRS?                   | ☐          |
| 2   | UC IDs được sử dụng nhất quán?                         | ☐          |
| 3   | Tables trong sequence diagrams → có trong Data Design? | ☐          |
| 4   | Screens mentioned → có trong Screen Design?            | ☐          |

---

## 📋 Kết quả kiểm tra

```markdown
## 📋 Kết quả kiểm tra Functional Design

| Section               | Items | Pass | Fail | Notes |
| --------------------- | ----- | ---- | ---- | ----- |
| Coverage              | 5     |      |      |       |
| UC Details            | 7     |      |      |       |
| Validation            | 3     |      |      |       |
| Business Rules        | 4     |      |      |       |
| Alt/Exception         | 3     |      |      |       |
| State Transition      | 5     |      |      |       |
| Action Classification | 5     |      |      |       |
| Module Organization   | 4     |      |      |       |
| Cross-Reference       | 4     |      |      |       |

**Total: [X]/[Y] items passed**

### ❌ Items cần bổ sung:

- [ ] ...
```
