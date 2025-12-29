# BD Screen Design Checklist

> Checklist chi tiết cho file Screen Design trong Basic Design

---

## 1. Screen Detail Coverage Check

> 🚨 **CRITICAL - ĐÂY LÀ KIỂM TRA QUAN TRỌNG NHẤT!**
> Thiếu Screen Details = **FAIL toàn bộ Screen Design**
> KHÔNG ĐƯỢC đánh giá PASS nếu Coverage < 100%!

### 1.1 Đếm và đối chiếu (BẮT BUỘC)

**Quy trình kiểm tra:**

```
BƯỚC 1: Đếm Screen trong danh sách
  - Tìm tất cả bảng "画面一覧" hoặc "Screen List"
  - Đếm số dòng data (không tính header)
  - Ghi lại: Screen_Count_In_List = [số]

BƯỚC 2: Đếm Screen có chi tiết
  - Tìm tất cả section với format "### X.X.X. SCR-XXX-YYY:"
  - Mỗi section phải có:
    ✓ 画面基本情報 (Screen Basic Info)
    ✓ レイアウト (Layout/Wireframe)
    ✓ 画面項目定義 (Item Definition)
    ✓ イベント定義 (Event Definition)
  - Ghi lại: Screen_Count_Detailed = [số]

BƯỚC 3: Tính Coverage
  - Coverage = Screen_Count_Detailed / Screen_Count_In_List * 100%
  - Điền vào bảng dưới đây
```

### 1.2 Bảng đối chiếu

| Module    | Screen trong DS | Screen chi tiết | Thiếu      | Coverage    | OK? |
| --------- | --------------- | --------------- | ---------- | ----------- | --- |
| PLM       | \_\_\_          | \_\_\_          | \_\_\_     | \_\_\_%     | ☐   |
| APS       | \_\_\_          | \_\_\_          | \_\_\_     | \_\_\_%     | ☐   |
| Common    | \_\_\_          | \_\_\_          | \_\_\_     | \_\_\_%     | ☐   |
| **TOTAL** | **\_\_\_**      | **\_\_\_**      | **\_\_\_** | **\_\_\_%** | ☐   |

### 1.3 Tiêu chuẩn đánh giá

| Coverage   | Verdict            | Hành động                             |
| ---------- | ------------------ | ------------------------------------- |
| **100%**   | ✅ PASS            | Tiếp tục kiểm tra các mục khác        |
| **80-99%** | ❌ FAIL (Minor)    | Liệt kê Screen thiếu, yêu cầu bổ sung |
| **50-79%** | ❌ FAIL (Major)    | Document chưa đầy đủ nghiêm trọng     |
| **< 50%**  | ❌ FAIL (Critical) | Document chưa hoàn thành              |

> ⚠️ **CẢNH BÁO**: Document chỉ có danh sách Screen mà thiếu chi tiết = **CHƯA HOÀN THÀNH**!

### 1.4 Checklist cơ bản

| #   | Mục kiểm tra                                          | Trạng thái |
| --- | ----------------------------------------------------- | ---------- |
| 1   | Có Screen Transition Diagram?                         | ☐          |
| 2   | Có Screen List với đầy đủ thông tin?                  | ☐          |
| 3   | Screen List có cột Related UC?                        | ☐          |
| 4   | Có Common Layout section?                             | ☐          |
| 5   | **Số màn hình trong bảng = Số màn hình có chi tiết?** | ☐          |
| 6   | Coverage 100% cho Must priority screens?              | ☐          |
| 7   | Coverage 100% cho Should priority screens?            | ☐          |

---

## 2. UC → Screen Mapping Check

> 🔴 **BẮT BUỘC**: Mỗi UC phải được map đến ít nhất một màn hình hoặc phân loại là Background.

### 2.1 UC Classification

| Loại           | Mô tả                                | Cần màn hình?              |
| -------------- | ------------------------------------ | -------------------------- |
| **UI Screen**  | UC tương tác trực tiếp với user      | ✅ Bắt buộc                |
| **Background** | Batch, notification, scheduler       | ❌ Không cần - ghi chú N/A |
| **Sub-UC**     | UC con thực hiện trong màn hình khác | 🔗 Map vào màn hình cha    |

### 2.2 Common Background UC Types

- Email/SMS notification sending
- Scheduled reminders
- Batch processing jobs
- Auto cleanup/archiving
- Report generation (scheduled)

> **Note:** Background UC phải được ghi chú trong bảng Screen List với "N/A - Background"

### 2.3 Checklist

| #   | Mục kiểm tra                                          | Trạng thái |
| --- | ----------------------------------------------------- | ---------- |
| 1   | Tất cả UC Must có màn hình hoặc phân loại Background? | ☐          |
| 2   | Tất cả UC Should có màn hình hoặc phân loại?          | ☐          |
| 3   | Tất cả UC Could có màn hình hoặc planned?             | ☐          |
| 4   | Background UC có được ghi chú trong Screen List?      | ☐          |
| 5   | Screen List có cột Related UC?                        | ☐          |
| 6   | **Mỗi UC action có UI element tương ứng?**            | ☐          |

---

## 3. Screen Detail Check

> 🔴 **BẮT BUỘC**: Mỗi màn hình PHẢI có đầy đủ 3 phần.

### 3.1 Required Sections per Screen

| Section             | Mô tả                          | Bắt buộc? |
| ------------------- | ------------------------------ | --------- |
| **Screen Layout**   | ASCII art / wireframe / mockup | ✅ Must   |
| **Item Definition** | Bảng liệt kê tất cả UI items   | ✅ Must   |
| **Event/Action**    | Bảng hành vi của UI            | ✅ Must   |

### 3.2 Checklist per Screen

**For EACH screen in screen list, verify:**

| #   | Mục kiểm tra                                | Trạng thái |
| --- | ------------------------------------------- | ---------- |
| 1   | Có Layout/Wireframe?                        | ☐          |
| 2   | Layout có đủ các elements từ FR/UC?         | ☐          |
| 3   | Có Item Definition Table?                   | ☐          |
| 4   | Item IDs unique và consistent?              | ☐          |
| 5   | Có Event/Action Table?                      | ☐          |
| 6   | Events cover tất cả interactive elements?   | ☐          |
| 7   | **UC actions đều có UI element tương ứng?** | ☐          |

> 🔴 **Critical:** Với mỗi UC được map đến màn hình, kiểm tra TẤT CẢ actions trong UC đều có UI element.

---

## 4. Screen Layout Quality Check

| #   | Mục kiểm tra                         | Trạng thái |
| --- | ------------------------------------ | ---------- |
| 1   | Layout có rõ ràng, dễ đọc?           | ☐          |
| 2   | Header/Footer/Sidebar consistent?    | ☐          |
| 3   | Breadcrumb/Navigation hiển thị đúng? | ☐          |
| 4   | Buttons có label đủ rõ?              | ☐          |
| 5   | Form fields có labels?               | ☐          |
| 6   | Required fields có đánh dấu (\*) ?   | ☐          |

---

## 5. Item Definition Quality Check

### 5.1 Required Columns

| Column      | Required? | Mô tả                                           |
| ----------- | --------- | ----------------------------------------------- |
| No.         | ✅        | Số thứ tự                                       |
| Item ID     | ✅        | Unique ID với prefix (btn*, txt*, sel\_, etc.)  |
| Item Name   | ✅        | Tên hiển thị                                    |
| Type        | ✅        | Text/Textarea/Select/Button/Radio/Checkbox/etc. |
| Required    | ✅        | Yes/No hoặc ○/-                                 |
| Max Length  | 🟡        | Cho text fields                                 |
| Validation  | 🟡        | Validation rules                                |
| Description | 🟡        | Mô tả bổ sung                                   |

### 5.2 Checklist

| #   | Mục kiểm tra                           | Trạng thái |
| --- | -------------------------------------- | ---------- |
| 1   | Có đủ các columns bắt buộc?            | ☐          |
| 2   | Item IDs theo naming convention?       | ☐          |
| 3   | Type phù hợp với data?                 | ☐          |
| 4   | Validation rules khớp với SRS/FR?      | ☐          |
| 5   | Validation rules khớp với Data Design? | ☐          |

---

## 6. Event/Action Quality Check

### 6.1 Required Columns

| Column | Required? | Mô tả                                           |
| ------ | --------- | ----------------------------------------------- |
| No.    | ✅        | Số thứ tự                                       |
| Event  | ✅        | Item ID + trigger (click, change, submit, etc.) |
| Action | ✅        | Behavior description                            |

### 6.2 Checklist

| #   | Mục kiểm tra                           | Trạng thái |
| --- | -------------------------------------- | ---------- |
| 1   | Tất cả buttons có event?               | ☐          |
| 2   | Tất cả links có event?                 | ☐          |
| 3   | Form submit có event?                  | ☐          |
| 4   | Actions mô tả rõ behavior?             | ☐          |
| 5   | Navigation targets đúng Screen ID?     | ☐          |
| 6   | Validation → error handling described? | ☐          |

---

## 7. Common UI Components Check

| #   | Mục kiểm tra                       | Trạng thái |
| --- | ---------------------------------- | ---------- |
| 1   | Có section Color Scheme?           | ☐          |
| 2   | Có section Font/Typography?        | ☐          |
| 3   | Có section Button Styles?          | ☐          |
| 4   | Có section Form Controls?          | ☐          |
| 5   | Có section Error/Success Messages? | ☐          |
| 6   | Có section Modal/Dialog?           | ☐          |
| 7   | Có section Loading States?         | ☐          |
| 8   | Có section Empty States?           | ☐          |
| 9   | Có section Status Badges?          | ☐          |

---

## 8. Responsive Design Check (nếu áp dụng)

| #   | Mục kiểm tra                      | Trạng thái |
| --- | --------------------------------- | ---------- |
| 1   | Có breakpoint definitions?        | ☐          |
| 2   | Có layout changes per breakpoint? | ☐          |
| 3   | Mobile navigation defined?        | ☐          |

---

## 9. Screen Types Coverage

> Kiểm tra đã có đủ các loại màn hình theo yêu cầu của ứng dụng

### 9.1 Common Screen Types

| Screen Type            | Mô tả                            | Có? |
| ---------------------- | -------------------------------- | --- |
| **Authentication**     | Login, Register, Password Reset  | ☐   |
| **Dashboard/Home**     | Main landing page after login    | ☐   |
| **List/Search**        | Data list với filter, pagination | ☐   |
| **Create/Edit Form**   | Data entry forms                 | ☐   |
| **Detail/View**        | Read-only detail view            | ☐   |
| **Settings**           | User/System settings             | ☐   |
| **Admin/Management**   | Master data, user management     | ☐   |
| **Reports/Statistics** | Charts, analytics                | ☐   |
| **Notifications**      | Notification list                | ☐   |
| **Error Pages**        | 404, 403, 500                    | ☐   |

### 9.2 Checklist

| #   | Mục kiểm tra                          | Trạng thái |
| --- | ------------------------------------- | ---------- |
| 1   | Có tất cả screen types theo FRs?      | ☐          |
| 2   | Không thiếu screen cho bất kỳ UC nào? | ☐          |

---

## 10. Quick Reference: Item Naming Convention

| Prefix   | Type            | Example                  |
| -------- | --------------- | ------------------------ |
| `txt_`   | Text Input      | txt_email, txt_title     |
| `pwd_`   | Password        | pwd_password             |
| `sel_`   | Select/Dropdown | sel_category, sel_status |
| `rad_`   | Radio Button    | rad_action, rad_type     |
| `chk_`   | Checkbox        | chk_remember, chk_agree  |
| `txa_`   | Textarea        | txa_content, txa_comment |
| `btn_`   | Button          | btn_submit, btn_cancel   |
| `lnk_`   | Link            | lnk_forgot, lnk_detail   |
| `tbl_`   | Table           | tbl_list, tbl_users      |
| `fil_`   | File Input      | fil_attachments          |
| `dat_`   | Date Input      | dat_startDate            |
| `num_`   | Number Input    | num_amount               |
| `pag_`   | Pagination      | pag_list                 |
| `card_`  | Card/Widget     | card_stats               |
| `chart_` | Chart           | chart_trend              |

---

## 📋 Kết quả kiểm tra

```markdown
## 📋 Kết quả kiểm tra Screen Design

| Section         | Items | Pass | Fail | Notes |
| --------------- | ----- | ---- | ---- | ----- |
| Coverage        | 7     |      |      |       |
| UC Mapping      | 6     |      |      |       |
| Screen Details  | 7×N   |      |      |       |
| Layout Quality  | 6     |      |      |       |
| Item Definition | 5     |      |      |       |
| Event/Action    | 6     |      |      |       |
| Common UI       | 9     |      |      |       |
| Responsive      | 3     |      |      |       |
| Screen Types    | 2     |      |      |       |

**Total: [X]/[Y] items passed**

### ❌ Items cần bổ sung:

- [ ] ...
```
