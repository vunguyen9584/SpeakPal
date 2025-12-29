# DETAILED DESIGN POST-GENERATION CHECKLIST

> ⚠️ **QUAN TRỌNG**: Sau khi hoàn thành việc tạo tài liệu Detailed Design, **BẮT BUỘC** phải thực hiện checklist này để đảm bảo không có phần nào bị thiếu sót.

---

## 0. BD COVERAGE CHECK (BẮT BUỘC - LÀM ĐẦU TIÊN)

> 🔴 **CRITICAL**: Kiểm tra này PHẢI PASS trước khi tiếp tục các bước khác. Nếu không pass, DD được coi là KHÔNG HỢP LỆ.

### 0.1 Chạy Validation Script

// turbo

```bash
node .ai-scripts/validate-dd-coverage.js [folder_path]
```

### 0.2 Kiểm tra kết quả

| Kiểm tra | Mô tả                                      |
| -------- | ------------------------------------------ |
| □        | Script validation đã chạy                  |
| □        | File `dd-validation-report.md` đã được tạo |
| □        | Overall coverage = 100%                    |

### 0.3 Kiểm tra Coverage theo Category

> 🔴 **Detailed Design yêu cầu 100% coverage cho TẤT CẢ BD elements**

| Category  | Total in BD | Covered in DD | Coverage | Pass Criteria | Status          |
| --------- | ----------- | ------------- | -------- | ------------- | --------------- |
| Use Cases | [đếm]       | [đếm]         | [%]      | = 100%        | □ PASS / □ FAIL |
| Screens   | [đếm]       | [đếm]         | [%]      | = 100%        | □ PASS / □ FAIL |
| Tables    | [đếm]       | [đếm]         | [%]      | = 100%        | □ PASS / □ FAIL |
| APIs      | [đếm]       | [đếm]         | [%]      | = 100%        | □ PASS / □ FAIL |
| Batches   | [đếm]       | [đếm]         | [%]      | = 100%        | □ PASS / □ FAIL |

### 0.4 Xử lý nếu Coverage < 100%

**Nếu có BẤT KỲ category nào < 100%:**

- ❌ **FAIL** - KHÔNG tiếp tục
- Action: Đọc `dd-validation-report.md` để xem elements thiếu
- Bổ sung detailed design cho elements thiếu
- Chạy lại validation script
- Chạy lại checklist từ đầu

### 0.5 Kết quả kiểm tra

| Kết quả                             | Hành động                |
| ----------------------------------- | ------------------------ |
| □ **PASS** - Tất cả category = 100% | ✅ Tiếp tục Section 1    |
| □ **FAIL** - Có category < 100%     | ❌ DỪNG LẠI - Bổ sung DD |

---

## 🔴 1. KIỂM TRA ĐỐI CHIẾU DANH SÁCH VỚI CHI TIẾT

> **LƯU Ý QUAN TRỌNG**: Đây là lỗi thường gặp nhất - có danh sách nhưng thiếu mô tả chi tiết!

### 1.1 Modules/Components

| Kiểm tra | Mô tả                                                                       |
| -------- | --------------------------------------------------------------------------- |
| □        | Đếm số lượng Modules trong **module list**                                  |
| □        | Đếm số lượng **module specifications chi tiết** (có class diagram, methods) |
| □        | **HAI CON SỐ NÀY PHẢI BẰNG NHAU**                                           |
| □        | Mỗi module PHẢI có: Class diagram, Method specifications, Dependencies      |

### 1.2 Class Definitions

| Kiểm tra | Mô tả                                                                          |
| -------- | ------------------------------------------------------------------------------ |
| □        | Đếm số lượng Classes trong **class diagrams**                                  |
| □        | Đếm số lượng **class specifications chi tiết** (có attributes, methods, logic) |
| □        | Mỗi class PHẢI có: Attributes, Methods, Business logic pseudocode              |

### 1.3 API Endpoints (Chi tiết)

| Kiểm tra | Mô tả                                                                           |
| -------- | ------------------------------------------------------------------------------- |
| □        | Đếm số lượng APIs trong **API list**                                            |
| □        | Đếm số lượng **API specifications đầy đủ**                                      |
| □        | Mỗi API PHẢI có: Request/Response schema, Validation rules, Error codes, Sample |

### 1.4 Database Tables

| Kiểm tra | Mô tả                                                     |
| -------- | --------------------------------------------------------- |
| □        | Đếm số lượng Tables trong **table list**                  |
| □        | Đếm số lượng **DDL scripts** được define                  |
| □        | Mỗi table PHẢI có: DDL, Indexes, Constraints, Sample data |

### 1.5 Sequence Diagrams

| Kiểm tra | Mô tả                                                    |
| -------- | -------------------------------------------------------- |
| □        | Đếm số lượng Use Cases từ Basic Design                   |
| □        | Đếm số lượng **Sequence diagrams chi tiết** trong DDD    |
| □        | **TẤT CẢ Use Cases quan trọng PHẢI có Sequence diagram** |

### 1.6 State Machines

| Kiểm tra | Mô tả                                                                       |
| -------- | --------------------------------------------------------------------------- |
| □        | Xác định các entities có state transitions (Orders, Documents, Tasks, etc.) |
| □        | Mỗi entity có trạng thái PHẢI có State diagram                              |

---

## 2. TÍNH ĐẦY ĐỦ (Completeness)

| Kiểm tra | Mô tả                                                  |
| -------- | ------------------------------------------------------ |
| □        | Tất cả Functional Requirements đều được map đến design |
| □        | Tất cả Non-Functional Requirements đều được address    |
| □        | Tất cả Use Cases đều có sequence diagram               |
| □        | Tất cả entities đều có table design với DDL            |
| □        | Tất cả API endpoints đều được định nghĩa chi tiết      |
| □        | Error handling cho tất cả scenarios                    |
| □        | Security considerations cho tất cả touchpoints         |

---

## 3. TÍNH NHẤT QUÁN (Consistency)

| Kiểm tra | Mô tả                                            |
| -------- | ------------------------------------------------ |
| □        | Naming convention thống nhất                     |
| □        | Thuật ngữ đồng nhất                              |
| □        | Format tables và code blocks đồng bộ             |
| □        | ID convention nhất quán (FR-xxx, NFR-xxx, etc.)  |
| □        | Data types nhất quán giữa API, Database, và Code |

---

## 4. TÍNH CHÍNH XÁC (Accuracy)

| Kiểm tra | Mô tả                                 |
| -------- | ------------------------------------- |
| □        | Data types phù hợp                    |
| □        | Relationships đúng                    |
| □        | Business logic chính xác              |
| □        | API contracts hợp lệ                  |
| □        | Sequence diagrams phản ánh đúng logic |

---

## 5. TÍNH KHẢ THI (Implementability)

| Kiểm tra | Mô tả                                       |
| -------- | ------------------------------------------- |
| □        | Developer có thể code trực tiếp từ tài liệu |
| □        | Không có ambiguity (mơ hồ)                  |
| □        | Technology-specific details đầy đủ          |
| □        | Edge cases được xử lý                       |
| □        | Pseudocode đủ chi tiết để implement         |

---

## 6. TRACEABILITY

| Kiểm tra | Mô tả                                        |
| -------- | -------------------------------------------- |
| □        | Requirement Traceability Matrix đầy đủ       |
| □        | Mỗi design element reference đến requirement |
| □        | Version control information                  |
| □        | Cross-references chính xác                   |

---

## 7. QUALITY ATTRIBUTES

| Kiểm tra | Mô tả                                                               |
| -------- | ------------------------------------------------------------------- |
| □        | Performance considerations (caching, indexing, etc.)                |
| □        | Scalability considerations (horizontal/vertical)                    |
| □        | Security considerations (authentication, authorization, encryption) |
| □        | Maintainability considerations (modularity, documentation)          |
| □        | Testability considerations (unit test, integration test)            |

---

## 📌 QUY TRÌNH KIỂM TRA KHUYẾN NGHỊ

```
Step 1: Mở từng file DDD
        → Đếm items trong danh sách/diagrams
        → Đếm items có specifications chi tiết
        → Bổ sung nếu thiếu

Step 2: Cross-check với Basic Design
        → Mọi thứ trong BDD phải có trong DDD với chi tiết hơn

Step 3: Kiểm tra code-ready
        → Có thể implement trực tiếp từ specs không?
        → Có đủ pseudocode/logic không?

Step 4: Kiểm tra consistency
        → ID, naming, data types đồng nhất không?
```

---

## ⚠️ CẢNH BÁO - LỖI THƯỜNG GẶP

1. **Có class diagram nhưng thiếu method details**: Vẽ class nhưng không mô tả chi tiết từng method
2. **Có API list nhưng thiếu request/response schema**: Liệt kê endpoints nhưng không có sample
3. **Có table list nhưng thiếu DDL**: Liệt kê table nhưng không có CREATE TABLE statement
4. **Thiếu sequence diagrams**: Có Use Cases nhưng không vẽ sequence diagram
5. **Business logic mơ hồ**: "Xử lý theo quy tắc business" thay vì pseudocode cụ thể
