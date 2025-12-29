# DD Element Coverage Requirements

> 🔴 **QUAN TRỌNG**: DD được sử dụng để lập plan implementation. KHÔNG ĐƯỢC BỎ SÓT bất kỳ element nào từ BD.

---

## 0. Module Design (04-module-design.md) - MỚI

### Modules - YÊU CẦU 100% COVERAGE

| Mức độ chi tiết     | Áp dụng cho                             | Nội dung bắt buộc                                 |
| ------------------- | --------------------------------------- | ------------------------------------------------- |
| **Chi tiết đầy đủ** | Core modules (User, Proposal, Approval) | Class diagram, Service interfaces, Method specs   |
| **Chi tiết cơ bản** | Support modules                         | Class diagram đơn giản, Service interface list    |
| **Tham chiếu**      | Utility modules                         | Bảng liệt kê với BD Reference + related UC/Screen |

### Nội dung bắt buộc cho mỗi Module:

| Nội dung                            | Bắt buộc                                          |
| ----------------------------------- | ------------------------------------------------- |
| Module overview (ID, Name, Purpose) | ✅                                                |
| Dependencies (relies on, used by)   | ✅                                                |
| Class diagram (Mermaid)             | Core modules: Chi tiết. Others: Có thể tham chiếu |
| Service interface specs             | Core modules: Chi tiết. Others: Liệt kê methods   |
| BD Reference                        | ✅ Cuối file phải có coverage table               |

---

## 1. Component Design (05-component-design.md)

### Use Cases - YÊU CẦU 100% COVERAGE

| Mức độ chi tiết     | Áp dụng cho                                | Nội dung bắt buộc                                            |
| ------------------- | ------------------------------------------ | ------------------------------------------------------------ |
| **Chi tiết đầy đủ** | UCs phức tạp, có business logic quan trọng | Sequence diagram, Pseudocode, Business rules, Error handling |
| **Chi tiết cơ bản** | UCs đơn giản, CRUD operations              | Sequence diagram đơn giản, tham chiếu BD section             |
| **Tham chiếu**      | UCs rất đơn giản                           | Bảng liệt kê với tham chiếu đến BD                           |

### Batches - YÊU CẦU 100% COVERAGE

Mỗi Batch PHẢI có:

- Flowchart
- Processing logic
- Error handling
- Recovery procedure

---

## 2. Database Design (06-database-design.md)

### Tables - YÊU CẦU 100% COVERAGE

| Nội dung                | Bắt buộc                                        |
| ----------------------- | ----------------------------------------------- |
| DDL (CREATE TABLE)      | ✅ Có cho TẤT CẢ tables                         |
| Indexes                 | ✅ Có cho TẤT CẢ tables                         |
| Constraints (FK, CHECK) | ✅ Có cho TẤT CẢ tables                         |
| Sample data             | Master tables: Có. Transaction tables: Optional |
| Comments                | ✅ Có cho TẤT CẢ columns                        |

---

## 3. API Design (07-api-design.md)

### AJAX APIs - YÊU CẦU 100% COVERAGE

| Nội dung                         | Bắt buộc |
| -------------------------------- | -------- |
| Endpoint, Method, Authentication | ✅       |
| Request/Response JSON schema     | ✅       |
| Business logic pseudocode        | ✅       |
| Error responses                  | ✅       |

### Struts Actions/Controllers - YÊU CẦU 100% COVERAGE

| Mức độ chi tiết        | Áp dụng cho                        | Nội dung bắt buộc                                      |
| ---------------------- | ---------------------------------- | ------------------------------------------------------ |
| **Chi tiết đầy đủ**    | Actions có business logic phức tạp | Form parameters, Validation rules, Processing flow     |
| **Danh sách tổng hợp** | Actions đơn giản                   | Bảng: Action path, Method, Required role, BD Reference |

---

## 4. UI Specifications (08-ui-specifications.md)

### Screens - YÊU CẦU 100% COVERAGE

| Mức độ chi tiết        | Áp dụng cho                             | Nội dung bắt buộc                                    |
| ---------------------- | --------------------------------------- | ---------------------------------------------------- |
| **Chi tiết đầy đủ**    | Screens phức tạp, có nhiều interactions | Layout diagram, Component specs, Validation, Events  |
| **Chi tiết cơ bản**    | Screens đơn giản                        | Component list, Validation rules cơ bản              |
| **Danh sách tổng hợp** | Screens CRUD đơn giản                   | Bảng: Screen ID, Name, URL, Components, BD Reference |

---

## 5. Format cho "Danh sách tổng hợp"

Khi element không được chi tiết đầy đủ, PHẢI có entry trong bảng tổng hợp:

```markdown
### Danh sách tổng hợp

| ID      | Name   | BD Reference                      | DD Section              | Notes                                |
| ------- | ------ | --------------------------------- | ----------------------- | ------------------------------------ |
| UC-XXX  | [Name] | BD 03-functional-design.md#uc-xxx | 05-component-design.md  | Xem sequence diagram tại BD          |
| SCR-XXX | [Name] | BD 04-screen-design.md#scr-xxx    | 08-ui-specifications.md | CRUD cơ bản, layout tương tự SCR-YYY |
```

---

## 6. Định nghĩa "Covered"

Một BD element được coi là "covered" khi THỎA MÃN MỘT trong các điều kiện:

| Loại Coverage            | Điều kiện                                          | Ví dụ                                        |
| ------------------------ | -------------------------------------------------- | -------------------------------------------- |
| **Chi tiết đầy đủ**      | Có section riêng với đầy đủ nội dung theo yêu cầu  | UC-001 có sequence diagram, pseudocode       |
| **Tham chiếu với mô tả** | Có entry trong bảng tổng hợp + mô tả ngắn gọn      | "Tương tự UC-001, chỉ khác filter condition" |
| **Tham chiếu BD**        | Có entry trong bảng tổng hợp + link đến BD section | "Xem BD 03-functional-design.md#uc-xxx"      |

### ⚠️ KHÔNG ĐƯỢC COI LÀ COVERED

- Chỉ mention ID mà không có chi tiết hoặc tham chiếu
- Có trong bd-dd-mapping nhưng không xuất hiện trong DD file
- Thiếu BD reference link khi dùng "Tham chiếu"

---

## 7. Validation Rule

> ⚠️ **KHÔNG ĐƯỢC HOÀN THÀNH DD** nếu bất kỳ BD element nào:
>
> - Không có detailed design, VÀ
> - Không có entry trong bảng tổng hợp với BD reference
