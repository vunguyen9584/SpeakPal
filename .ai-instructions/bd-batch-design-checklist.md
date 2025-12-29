# Batch Design Checklist for Basic Design

> 🔴 **BẮT BUỘC kiểm tra** - Đảm bảo Batch Design cover đầy đủ tất cả background processing requirements

---

## 1. Cấu trúc tài liệu

- [ ] Có Batch List tổng hợp (bảng với ID, tên, schedule, priority)
- [ ] Mỗi batch có: 基本情報 + 処理概要 + 処理フロー + エラー処理
- [ ] Có Execution Environment (スケジューラー, 実行ユーザー, ログ出力先)
- [ ] Có Monitoring/Alert design (監視・アラート)
- [ ] Có cron/scheduler configuration example

---

## 2. FR Coverage Check (BẮT BUỘC)

> 🔴 **QUAN TRỌNG**: Mỗi background processing FR PHẢI có batch tương ứng

### 2.1 Common Batch Patterns

> Kiểm tra các pattern thường cần batch processing:

| Pattern                    | Mô tả                           | Batch Pattern            | Check |
| -------------------------- | ------------------------------- | ------------------------ | ----- |
| **Reminder/Notification**  | Nhắc nhở định kỳ                | Scheduled reminder batch | ☐     |
| **Email Queue Processing** | Gửi email từ queue              | Email sender batch       | ☐     |
| **Data Cleanup**           | Xóa data cũ, expired            | Cleanup batch            | ☐     |
| **Archive/Backup**         | Lưu trữ data dài hạn            | Archive batch            | ☐     |
| **Statistics Aggregation** | Tính toán thống kê              | Aggregation batch        | ☐     |
| **Auto Escalation**        | Tự động escalate theo rule      | Escalation batch         | ☐     |
| **Session Cleanup**        | Xóa session hết hạn             | Session cleanup batch    | ☐     |
| **Cache Refresh**          | Cập nhật cache định kỳ          | Cache refresh batch      | ☐     |
| **Report Generation**      | Tạo báo cáo định kỳ             | Report batch             | ☐     |
| **Data Sync/Import**       | Đồng bộ data từ external system | Sync batch               | ☐     |

### 2.2 FR Mapping Requirements

Với MỖI FR liên quan đến background processing:

- [ ] FR có batch xử lý tương ứng?
- [ ] Nếu FR có notification → có batch gửi notification?
- [ ] Nếu FR có reminder → có reminder batch?
- [ ] Nếu FR có auto-action → có batch thực hiện action?
- [ ] Nếu FR có report/statistics → có aggregation batch?

---

## 3. Batch Detail Requirements

### 3.1 基本情報 (Mỗi batch PHẢI có)

- [ ] バッチ ID (unique identifier)
- [ ] バッチ名 (human-readable name)
- [ ] 実行タイミング (schedule: daily, hourly, etc.)
- [ ] 推定実行時間 (estimated duration)
- [ ] 優先度 (Must/Should/Could)
- [ ] **関連機能要件 (Related FRs)** ← BẮT BUỘC

### 3.2 処理フロー (PHẢI có)

- [ ] Flowchart (Mermaid format)
- [ ] Input data source
- [ ] Processing logic steps
- [ ] Output/side effects
- [ ] Loop/iteration logic nếu có

### 3.3 エラー処理 (PHẢI có)

- [ ] Error types và handling strategy
- [ ] Retry logic
- [ ] Fallback behavior
- [ ] Logging requirements
- [ ] Alert/notification on failure

### 3.4 通知レコード仕様 (Nếu tạo notifications)

- [ ] notification_type value
- [ ] title format
- [ ] link_url pattern
- [ ] email_sent handling

---

## 4. Cross-Reference with Other BD Sections

### 4.1 Data Design → Batch Design

Với mỗi batch:

- [ ] Tables được reference trong SQL đều tồn tại
- [ ] Archive tables có định nghĩa trong Data Design
- [ ] Cache tables có định nghĩa (nếu sử dụng)
- [ ] Additional columns cần cho batch được liệt kê

### 4.2 Functional Design → Batch Design

Với mỗi Background UC:

- [ ] UC có batch xử lý tương ứng
- [ ] UC-023 (メール送信) → Email batch
- [ ] UC-031 (リマインダー) → Reminder batch
- [ ] Auto-workflow actions → Escalation batch

### 4.3 API Design → Batch Design

- [ ] Manual trigger APIs cho admin (optional)
- [ ] Batch trigger endpoints (nếu có)

---

## 5. Technical Requirements

### 5.1 排他制御 (Concurrency Control)

- [ ] Có section 排他制御
- [ ] Mỗi batch có defined locking strategy
- [ ] Concurrent execution policy (可/不可)
- [ ] Lock file hoặc DB lock mechanism

### 5.2 Performance Considerations

- [ ] Batch size limits (e.g., 1000 records per iteration)
- [ ] Table lock avoidance strategy
- [ ] Timeout handling
- [ ] Resource limits

### 5.3 Scheduling

- [ ] Cron expressions cho tất cả batches
- [ ] Time zone consideration
- [ ] Dependency between batches (nếu có)
- [ ] Weekday/Weekend handling

---

## 6. FR Mapping Table (BẮT BUỘC)

> 🔴 Batch Design PHẢI có section mapping FR → Batches

### 6.1 Template

```markdown
## X.X FR to Batch Mapping

| FR ID  | Feature Name | Priority | Related Batch | Covered? |
| ------ | ------------ | -------- | ------------- | -------- |
| FR-036 | Reminder     | Could    | BAT-001       | ✅/❌    |
```

### 6.2 Coverage Requirements

- [ ] Tất cả notification FRs covered
- [ ] Tất cả reminder FRs covered
- [ ] Tất cả auto-action FRs covered
- [ ] Tất cả statistics/report FRs covered (nếu có pre-calculation)

### 6.3 Coverage Summary

- [ ] Có Summary table với count
- [ ] Total coverage = 100% cho background FRs

---

## 7. Common Mistakes to Avoid

| ❌ Mistake                     | ✅ Correct                                |
| ------------------------------ | ----------------------------------------- |
| Thiếu email queue batch        | Có batch xử lý email từ notification      |
| Thiếu auto-escalation batch    | Có batch auto-escalate theo workflow rule |
| Không có 排他制御              | PHẢI có concurrency control section       |
| Archive table không defined    | Archive tables phải có trong Data Design  |
| Không có FR mapping            | PHẢI có mapping table                     |
| Chỉ có cron cho must batches   | Cron cho TẤT CẢ batches                   |
| Thiếu notification_type values | Định nghĩa rõ notification_type sử dụng   |
| Không có manual trigger        | Có admin API để trigger manual (optional) |

---

## 8. Validation Questions

Trước khi finalize, tự hỏi:

1. **Email notifications**: Có batch gửi email từ notification queue?
2. **Reminders**: Có batch tạo reminder notifications?
3. **Auto-actions**: Workflow có auto-escalation? → Cần batch
4. **Data retention**: Có policy xóa/archive data cũ? → Cleanup batch
5. **Statistics**: Dashboard cần pre-calculated data? → Aggregation batch
6. **Sessions**: Có session timeout? → Cleanup batch
7. **Audit logs**: Có retention policy? → Archive batch

---

## 📋 Kết quả Review

| Section                | Items | Pass | Fail | Notes |
| ---------------------- | ----- | ---- | ---- | ----- |
| Document Structure     | 5     |      |      |       |
| FR Coverage            | 5     |      |      |       |
| Common Patterns        | 10    |      |      |       |
| Batch Details          | 13    |      |      |       |
| Cross-reference        | 7     |      |      |       |
| Technical Requirements | 8     |      |      |       |
| FR Mapping             | 4     |      |      |       |

**Total: [X]/[Y] items passed**

### ❌ Items cần bổ sung:

- [ ] ...
