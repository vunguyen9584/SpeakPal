# Data Design Checklist for Basic Design

> 🔴 **BẮT BUỘC kiểm tra** - Đảm bảo Data Design cover đầy đủ tất cả FR

---

## 1. Cấu trúc tài liệu

- [ ] Có ER Diagram (Mermaid/UML format)
- [ ] Có Table List tổng hợp
- [ ] Mỗi table có: Overview + Column Definitions + Indexes
- [ ] Có phần Data Constraints (FK, Check constraints)

---

## 2. FR Coverage Check (BẮT BUỘC)

> 🔴 **QUAN TRỌNG**: Mỗi FR PHẢI được map đến ít nhất 1 table/column

### 2.1 Checklist theo FR

Với MỖI FR trong SRS, kiểm tra:

- [ ] FR có table tương ứng (hoặc column trong existing table)?
- [ ] Nếu FR có UI input → có table/column lưu data?
- [ ] Nếu FR có workflow/status → có status column + history table?
- [ ] Nếu FR có report → có đủ columns để aggregate?

### 2.2 Common Missing Patterns

> Các pattern thường bị bỏ sót - kiểm tra xem ứng dụng có feature này không:

| Pattern                 | Mô tả                       | Table Pattern                         | Check |
| ----------------------- | --------------------------- | ------------------------------------- | ----- |
| **Tag/Keyword**         | Gắn thẻ, từ khóa, label     | `t_[entity]_tags` hoặc junction table | ☐     |
| **Cost/ROI Analysis**   | Phân tích chi phí, hiệu quả | `t_cost_analyses`                     | ☐     |
| **Evaluation/Rating**   | Đánh giá, chấm điểm         | `t_evaluations`                       | ☐     |
| **Delegation/Proxy**    | Ủy quyền, đại diện          | `t_delegations`                       | ☐     |
| **Settings/Config**     | Cấu hình, tùy chỉnh         | `t_[feature]_settings`                | ☐     |
| **Password Reset**      | Đặt lại mật khẩu            | `t_password_reset_tokens`             | ☐     |
| **Escalation/Transfer** | Chuyển tiếp, leo thang      | Columns trong main entity             | ☐     |
| **Audit/History**       | Lịch sử thay đổi            | `h_[entity]` hoặc `t_audit_logs`      | ☐     |
| **File Attachment**     | Đính kèm file               | `t_attachments`                       | ☐     |
| **Notification**        | Thông báo                   | `t_notifications`                     | ☐     |
| **Comments**            | Bình luận                   | `t_comments`                          | ☐     |
| **Archive (Batch)**     | Lưu trữ dài hạn cho batch   | `h_[entity]_archive`                  | ☐ 🆕  |
| **Statistics Cache**    | Cache thống kê cho batch    | `t_statistics_cache`                  | ☐ 🆕  |
| **Email Retry**         | Retry count cho email batch | `retry_count` column in notifications | ☐ 🆕  |

**Phương pháp kiểm tra:**

1. Xem lại tất cả FR trong SRS
2. Xem lại tất cả Screen có input fields
3. Với mỗi feature → kiểm tra có table/column lưu trữ không

---

## 3. Cross-Reference with Other BD Sections

### 3.1 Screen Design → Data Design

Với mỗi screen trong Screen Design:

- [ ] Input fields có column tương ứng trong table
- [ ] Select/Dropdown có master table
- [ ] List/Table có data source table
- [ ] File upload có attachment table

### 3.2 Functional Design → Data Design

Với mỗi UC sequence diagram:

- [ ] INSERT/UPDATE/DELETE có target table
- [ ] Tất cả tables được reference đều tồn tại trong Data Design
- [ ] FK relationships đúng với diagram

---

## 4. Table Detail Requirements

### 4.1 Mỗi Table PHẢI có

**Overview section:**

- [ ] Table name (physical)
- [ ] Logical name
- [ ] Description
- [ ] Estimated record count
- [ ] Retention period
- [ ] **Related FR IDs** ← BẮT BUỘC

**Column Definitions:**

- [ ] PK, FK, UK flags
- [ ] NOT NULL flags
- [ ] Default values
- [ ] Appropriate data types
- [ ] Description for each column

**Indexes:**

- [ ] PK index
- [ ] FK indexes for foreign keys
- [ ] Search indexes for frequently queried columns

### 4.2 Master Tables

- [ ] Có Initial Data nếu applicable
- [ ] Có display_order nếu cần sort
- [ ] Có is_active cho soft delete

### 4.3 Transaction Tables

- [ ] Có created_at
- [ ] Có updated_at (nếu có update)
- [ ] Có created_by/updated_by (nếu cần audit)

### 4.4 History Tables

- [ ] Có from_value và to_value
- [ ] Có changed_by
- [ ] Có changed_at

---

## 5. FR Mapping Table (BẮT BUỘC)

> 🔴 Data Design PHẢI có section mapping FR → Tables

### 5.1 Template

```markdown
## X.X FR to Table Mapping

| FR ID  | Feature Name | Priority | Related Tables | Covered? |
| ------ | ------------ | -------- | -------------- | -------- |
| FR-001 | ...          | Must     | table1, table2 | ✅/❌    |
```

### 5.2 Coverage Requirements

- [ ] 100% Must FRs covered
- [ ] 100% Should FRs covered
- [ ] 100% Could FRs covered (nếu có screen)

### 5.3 Coverage Summary

- [ ] Có Summary table với count by priority
- [ ] Total coverage = 100%

---

## 6. Validation Questions

Trước khi finalize, tự hỏi:

1. **Screen inputs**: Mọi field mà user nhập vào screen có chỗ lưu không?
2. **Workflow states**: Status transitions có được track không?
3. **Reports**: Dữ liệu cho reports/charts đến từ đâu?
4. **Background jobs**: Batch jobs cần data gì?
5. **Audit trail**: Có cần log ai làm gì không?
6. **Soft delete**: Master data cần logical delete?
7. **Archive tables**: Batch archive cần table riêng? (h_xxx_archive) 🆕
8. **Cache tables**: Batch aggregation cần cache table? (t_statistics_cache) 🆕
9. **Retry columns**: Email batch cần retry_count column? 🆕

---

## 7. Common Mistakes to Avoid

| ❌ Mistake                                 | ✅ Correct                              |
| ------------------------------------------ | --------------------------------------- |
| Thiếu table cho Could priority FR          | Cover tất cả FR có screen               |
| Không có email_sent tracking               | Track email/notification status         |
| Không có escalation/transfer columns       | Thêm assigned_to, escalated_from        |
| Không có FR mapping                        | PHẢI có mapping table                   |
| Chỉ list tables, không giải thích relation | Có ER diagram + FK constraints          |
| Thiếu audit columns                        | Thêm created_at, updated_at, etc.       |
| Thiếu index cho FK                         | Thêm index cho tất cả FK columns        |
| Thiếu archive table cho batch 🆕           | Thêm h_xxx_archive nếu có archive batch |
| Thiếu cache table cho statistics 🆕        | Thêm t_statistics_cache cho batch agg   |

---

## 📋 Kết quả Review

| Section            | Items | Pass | Fail | Notes             |
| ------------------ | ----- | ---- | ---- | ----------------- |
| Document Structure | 4     |      |      |                   |
| FR Coverage        | 4     |      |      |                   |
| Common Patterns    | 14    |      |      | +3 batch patterns |
| Cross-reference    | 5     |      |      |                   |
| Table Details      | 12    |      |      |                   |
| FR Mapping         | 4     |      |      |                   |
| Batch Support      | 3     |      |      | 🆕 new            |

**Total: [X]/[Y] items passed**

### ❌ Items cần bổ sung:

- [ ] ...
