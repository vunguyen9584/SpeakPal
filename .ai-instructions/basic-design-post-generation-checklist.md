# BASIC DESIGN POST-GENERATION CHECKLIST

> ⚠️ **QUAN TRỌNG**: Sau khi hoàn thành việc tạo tài liệu Basic Design, **BẮT BUỘC** phải thực hiện checklist này để đảm bảo không có phần nào bị thiếu sót.

---

## 0. REQUIREMENT COVERAGE CHECK (BẮT BUỘC - LÀM ĐẦU TIÊN)

> 🔴 **CRITICAL**: Kiểm tra này PHẢI PASS trước khi tiếp tục các bước khác. Nếu không pass, BD được coi là KHÔNG HỢP LỆ.

### 0.1 Kiểm tra FR→UC Mapping trong 03-functional-design.md

| Kiểm tra | Mô tả                                                                                    |
| -------- | ---------------------------------------------------------------------------------------- |
| □        | File `03-functional-design.md` có section "要件カバレッジサマリー" ở đầu                 |
| □        | Section có đầy đủ: Thống kê, Bảng Priority, FR→UC Mapping Table, Danh sách FR chưa cover |
| □        | Bảng Use Case có cột "マッピング FR" để trace ngược về SRS                               |

### 0.2 Kiểm tra Coverage Rate

**Quy trình:**

1. Mở file SRS: `03-functional-requirements.md`
2. Đếm tổng số FR (trong bảng "機能要件一覧" hoặc tương đương)
3. Mở file BD: `03-functional-design.md`
4. Đếm số UC và liệt kê FR mà mỗi UC cover

**Template kiểm tra:**

> 🔴 **Basic Design yêu cầu 100% coverage cho TẤT CẢ FR**

| Priority | Tổng FR trong SRS | Số FR có UC | Coverage | Pass Criteria | Status          |
| -------- | ----------------- | ----------- | -------- | ------------- | --------------- |
| Must     | [đếm]             | [đếm]       | [%]      | = 100%        | □ PASS / □ FAIL |
| Should   | [đếm]             | [đếm]       | [%]      | = 100%        | □ PASS / □ FAIL |
| Could    | [đếm]             | [đếm]       | [%]      | = 100%        | □ PASS / □ FAIL |

### 0.3 Liệt kê chi tiết FR không có UC

> Điền bảng này cho MỖI FR trong SRS:

| FR ID  | FR Name | Priority | UC trong BD | Status       |
| ------ | ------- | -------- | ----------- | ------------ |
| FR-001 |         | Must     | UC-001      | □ ✅         |
| FR-002 |         | Must     | UC-003      | □ ✅         |
| ...    | ...     | ...      | ...         | ...          |
| FR-XXX |         | Should   | -           | □ ❌ MISSING |

### 0.4 Xử lý FR thiếu UC

> 🔴 **Basic Design yêu cầu 100% coverage. Tất cả FR phải có UC.**

**Nếu có BẤT KỲ FR nào thiếu UC:**

- ❌ **FAIL** - KHÔNG tiếp tục
- Action: Quay lại và bổ sung UC cho FR thiếu
- Chạy lại checklist từ đầu

**Lý do:** BD là tài liệu thiết kế toàn diện, phải cover 100% yêu cầu. Priority (Must/Should/Could) chỉ ảnh hưởng đến thứ tự implementation.

### 0.5 Kết quả kiểm tra

| Kết quả                                            | Hành động                |
| -------------------------------------------------- | ------------------------ |
| □ **PASS** - Tất cả tiêu chí đạt                   | ✅ Tiếp tục Section 1    |
| □ **CONDITIONAL PASS** - Should < 100% nhưng ≥ 80% | ⚠️ Tiếp tục với warning  |
| □ **FAIL** - Must < 100% hoặc Should < 80%         | ❌ DỪNG LẠI - Bổ sung UC |

---

## 1. KIỂM TRA ĐỐI CHIẾU DANH SÁCH VỚI CHI TIẾT

> 🔴 **LƯU Ý QUAN TRỌNG**: Đây là lỗi thường gặp nhất - có danh sách nhưng thiếu mô tả chi tiết!

### 1.1 Use Cases (03-functional-design.md)

| Kiểm tra | Mô tả                                                                            |
| -------- | -------------------------------------------------------------------------------- |
| □        | Đếm số lượng Use Case trong **danh sách UC** (ví dụ: UC-001 ~ UC-018 = 18 items) |
| □        | Đếm số lượng **phần chi tiết UC** (có sequence diagram, business rules)          |
| □        | **HAI CON SỐ NÀY PHẢI BẰNG NHAU**                                                |
| □        | Nếu thiếu → Bổ sung chi tiết cho các UC còn thiếu                                |

**Mẫu kiểm tra:**

```
Danh sách: UC-001, UC-002, UC-003, UC-004, UC-005 (5 items)
Chi tiết: UC-001 ✅, UC-003 ✅, UC-005 ✅ (3 items)
→ THIẾU: UC-002, UC-004
```

### 1.2 Screens (04-screen-design.md)

| Kiểm tra | Mô tả                                                                      |
| -------- | -------------------------------------------------------------------------- |
| □        | Đếm số lượng Screen trong **danh sách màn hình**                           |
| □        | Đếm số lượng **layout chi tiết** (có ASCII art/wireframe, item definition) |
| □        | **HAI CON SỐ NÀY PHẢI BẰNG NHAU**                                          |
| □        | Mỗi màn hình PHẢI có: Layout, Item Definition, Events                      |

### 1.3 Tables (05-data-design.md)

| Kiểm tra | Mô tả                                                                |
| -------- | -------------------------------------------------------------------- |
| □        | Đếm số lượng Table trong **ER Diagram** hoặc **danh sách table**     |
| □        | Đếm số lượng **table definition chi tiết** (có column list, indexes) |
| □        | **HAI CON SỐ NÀY PHẢI BẰNG NHAU**                                    |
| □        | Mỗi table PHẢI có: Column definitions, Data types, PK/FK, Indexes    |

### 1.4 APIs (06-api-design.md)

| Kiểm tra | Mô tả                                                                      |
| -------- | -------------------------------------------------------------------------- |
| □        | Đếm số lượng API trong **danh sách API**                                   |
| □        | Đảm bảo các API quan trọng có **mô tả chi tiết** (request/response format) |
| □        | Tối thiểu 30% APIs cần có chi tiết đầy đủ làm reference                    |

### 1.5 Batches (07-batch-design.md)

| Kiểm tra | Mô tả                                                                          |
| -------- | ------------------------------------------------------------------------------ |
| □        | Đếm số lượng Batch trong **danh sách batch**                                   |
| □        | Đếm số lượng **batch specification chi tiết** (có flowchart, processing steps) |
| □        | **HAI CON SỐ NÀY PHẢI BẰNG NHAU**                                              |

---

## 2. COMPLETENESS CHECK (Tính đầy đủ)

| Kiểm tra | Mô tả                                                                        |
| -------- | ---------------------------------------------------------------------------- |
| □        | Tất cả functional requirements từ SRS đều được cover bởi ít nhất 1 Use Case  |
| □        | Tất cả Use Cases đều có Screen tương ứng (hoặc ghi rõ là background process) |
| □        | Tất cả Screens có API calls đều được liệt kê trong API Design                |
| □        | Tất cả APIs có data persistence đều tham chiếu đến Tables cụ thể             |
| □        | Error handling được định nghĩa cho tất cả error codes                        |

---

## 3. CONSISTENCY CHECK (Tính nhất quán)

| Kiểm tra | Mô tả                                                  |
| -------- | ------------------------------------------------------ |
| □        | ID format nhất quán: UC-XXX, SCR-XXX, API-XXX, TBL-XXX |
| □        | Naming conventions thống nhất xuyên suốt tài liệu      |
| □        | Data types nhất quán giữa API và Database              |
| □        | Cross-references chính xác (không có dead links)       |
| □        | Enum values nhất quán giữa các phần liên quan          |

---

## 4. TRACEABILITY CHECK (Tính truy vết)

| Kiểm tra | Mô tả                                        |
| -------- | -------------------------------------------- |
| □        | Có Traceability Matrix đầy đủ trong Appendix |
| □        | Requirement → Function mapping rõ ràng       |
| □        | Function → Screen mapping rõ ràng            |
| □        | Screen → API mapping rõ ràng                 |
| □        | API → Table mapping rõ ràng                  |

---

## 5. QUALITY CHECK (Chất lượng)

| Kiểm tra | Mô tả                                               |
| -------- | --------------------------------------------------- |
| □        | Không có conflicts/contradictions giữa các sections |
| □        | Đủ detail để implement (developer có thể hiểu)      |
| □        | Security considerations được đề cập                 |
| □        | Performance considerations được đề cập              |
| □        | Edge cases và error cases được handle               |

---

## 6. FORMAT CHECK (Định dạng)

| Kiểm tra | Mô tả                                               |
| -------- | --------------------------------------------------- |
| □        | Document structure đúng template                    |
| □        | Tables formatted correctly (không bị lỗi markdown)  |
| □        | Mermaid diagrams render đúng                        |
| □        | Numbering và heading levels chính xác               |
| □        | Không có placeholder text (TODO, TBD, etc.) còn sót |

---

## 📌 QUY TRÌNH KIỂM TRA KHUYẾN NGHỊ

```
Step 1: Mở file 03-functional-design.md
        → Đếm Use Cases trong danh sách
        → Đếm Use Cases có chi tiết
        → Bổ sung nếu thiếu

Step 2: Mở file 04-screen-design.md
        → Đếm Screens trong danh sách
        → Đếm Screens có layout chi tiết
        → Bổ sung nếu thiếu

Step 3: Mở file 05-data-design.md
        → Đếm Tables trong ER diagram/list
        → Đếm Tables có definition chi tiết
        → Bổ sung nếu thiếu

Step 4: Mở file 06-api-design.md
        → Kiểm tra API list
        → Đảm bảo các API quan trọng có chi tiết

Step 5: Mở file 07-batch-design.md
        → Đếm Batches trong danh sách
        → Đếm Batches có specification chi tiết
        → Bổ sung nếu thiếu

Step 6: Review cross-references và traceability
```

---

## ⚠️ CẢNH BÁO - LỖI THƯỜNG GẶP

1. **Có danh sách nhưng thiếu chi tiết**: Liệt kê 20 Use Cases nhưng chỉ viết chi tiết 5 cái
2. **Có màn hình nhưng thiếu layout**: Liệt kê 15 screens nhưng chỉ vẽ wireframe cho 5 màn hình
3. **Có table list nhưng thiếu column definitions**: Liệt kê 10 tables nhưng chỉ định nghĩa 5 cái
4. **Cross-reference sai**: Tham chiếu đến UC-015 nhưng UC-015 không tồn tại
5. **Placeholder còn sót**: Còn text như "TBD", "TODO", "..."
