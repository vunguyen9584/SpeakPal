# Auto Mode Implementation Guide

## Tổng quan

Auto Mode cho phép `/implement-phase` tự động chạy hết tất cả tasks trong một phase mà không cần confirm từ người dùng. Đây là chế độ lý tưởng để deploy nhanh các tasks đơn giản và lặp lại.

---

## So sánh Manual vs Auto Mode

| Đặc điểm | Manual Mode | Auto Mode |
|----------|------------|-----------|
| **Confirm từng task** | ✅ Có (qua `/implement-task`) | ❌ Không |
| **Tốc độ** | Chậm (cần user input) | Nhanh (tự động) |
| **Control** | Cao (kiểm soát từng bước) | Thấp (chỉ xem kết quả cuối) |
| **Khi lỗi xảy ra** | Hỏi: Retry/Skip/Abort | Log error, tiếp tục |
| **Phù hợp cho** | Tasks phức tạp, thử nghiệm | Tasks đơn giản, production |
| **Review code** | Trước khi chạy | Sau khi chạy |

---

## Khi nào dùng Auto Mode?

### ✅ NÊN dùng Auto Mode:

1. **Setup & Configuration Tasks**
   - Install dependencies
   - Setup databases
   - Configure services
   - Environment setup

2. **Repetitive Tasks**
   - Tạo CRUD endpoints
   - Tạo entity files
   - Tạo test files theo template

3. **Trusted Phase Plans**
   - Đã review kỹ phase plan
   - Đã test trên môi trường dev
   - Tasks đơn giản, rõ ràng

4. **Fast Deployment**
   - Cần deploy nhanh
   - Production emergency fixes
   - Bulk migrations

### ❌ KHÔNG nên dùng Auto Mode:

1. **Complex Business Logic**
   - Logic phức tạp, nhiều edge cases
   - Integration với external services mới
   - Security-sensitive code

2. **Experimental Work**
   - Thử nghiệm công nghệ mới
   - Chưa rõ requirements
   - Prototype phase

3. **High-Risk Tasks**
   - Database migrations trên production
   - Payment processing code
   - Authentication/Authorization logic

---

## Cách sử dụng

### 1. Chạy Auto Mode

```bash
/implement-phase
```

**Khi được hỏi:**
- Phase Plan path: `docs/project/implementation-plan/phase-X-name.md`
- CHECKLIST path: `docs/project/implementation-plan/CHECKLIST.md`
- **Execution Mode**: Chọn `auto`

### 2. Workflow sẽ tự động:

```
📋 Phase X: [Phase Name]
   Execution Mode: AUTO
   [N] Work Packages, [M] Tasks

Tự động bắt đầu implement...

🔄 [1/M] TASK-001: Task Name
   Type: setup | Commands: ...
   ✅ Executed successfully

🔄 [2/M] TASK-002: Task Name
   Type: feature | Files: ...
   ✅ Created files successfully

...

🎉 Phase X hoàn thành!
   Success: X/M tasks
   Failed: Y tasks (xem chi tiết bên dưới)
```

### 3. Review kết quả

Sau khi hoàn thành, **BẮT BUỘC** phải:

1. **Kiểm tra error logs**
   ```
   ### Tasks thất bại (nếu có):
   - ❌ TASK-XXX: [Error message]
   ```

2. **Review code changes**
   ```bash
   git diff
   git status
   ```

3. **Run tests**
   ```bash
   npm test
   flutter test
   ```

4. **Verify acceptance criteria**
   - Đọc lại phase plan
   - Kiểm tra từng acceptance criteria

---

## Error Handling trong Auto Mode

### Cách Auto Mode xử lý lỗi:

1. **Task Dependency Error**
   - ⚠️ Log warning
   - Skip task
   - Tiếp tục task tiếp theo

2. **Command Failure**
   - ❌ Log error details
   - Skip task
   - Tiếp tục task tiếp theo

3. **File Creation Error**
   - ❌ Log error
   - Skip task
   - Tiếp tục task tiếp theo

### Sau khi phase hoàn thành:

```markdown
### Tasks thất bại: 3

- ❌ WP-XXX-T001: Install Service X
  Error: Port 5432 already in use

- ❌ WP-XXX-T005: Create Migration
  Error: Table already exists

- ❌ WP-XXX-T010: Run Tests
  Error: Test suite failed with 5 errors
```

**Action items:**
1. Đọc error messages
2. Fix manually những tasks failed
3. Re-run `/implement-task` cho từng failed task
4. Hoặc fix code trực tiếp nếu đơn giản

---

## Best Practices

### 1. Chuẩn bị trước khi chạy

✅ **Review Phase Plan kỹ**
- Đọc hết tất cả tasks
- Kiểm tra commands có hợp lý không
- Verify file paths tồn tại

✅ **Backup code**
```bash
git commit -m "Backup before auto implementation"
git branch backup-$(date +%Y%m%d)
```

✅ **Clean working directory**
```bash
git status  # Đảm bảo không có uncommitted changes
```

### 2. Trong khi chạy

✅ **Theo dõi output**
- Xem log real-time
- Note lại tasks failed

✅ **Không interrupt**
- Để workflow chạy hết
- CHECKLIST.md sẽ track progress

### 3. Sau khi chạy

✅ **Review toàn bộ changes**
```bash
git diff --stat
git diff
```

✅ **Run tests**
```bash
npm run test
npm run lint
```

✅ **Fix failed tasks**
- Ưu tiên tasks dependency cao
- Re-run bằng `/implement-task`

✅ **Commit nhóm theo WP**
```bash
git add .
git commit -m "feat(phase-X): implement WP-XXX-YYY [description]"
```

---

## Ví dụ thực tế

### Ví dụ 1: Infrastructure Setup (Phù hợp Auto Mode)

**Phase 0: Infrastructure Setup**
- 5 Work Packages
- 17 Tasks (setup, config, install)

**Kết quả:**
```
🎉 Phase 0 hoàn thành!
   Success: 17/17 tasks ✅
   Failed: 0 tasks
   Time: ~30 minutes
```

**Manual mode tốn:** ~3 hours (confirm từng task)

### Ví dụ 2: Backend API (Có thể dùng Auto Mode)

**Phase 1: Backend API Core**
- 8 Work Packages
- 45 Tasks (entities, DTOs, controllers)

**Kết quả:**
```
🎉 Phase 1 hoàn thành!
   Success: 42/45 tasks ✅
   Failed: 3 tasks ❌
   Time: ~1.5 hours

Failed tasks:
- ❌ WP-BE-003-T004: Complex validation logic
- ❌ WP-BE-005-T002: Third-party integration
- ❌ WP-BE-007-T003: Custom authentication
```

**Action:** Fix 3 failed tasks manually (30 mins)

**Total time:** ~2 hours
**Manual mode tốn:** ~8 hours

### Ví dụ 3: Complex Business Logic (KHÔNG nên Auto Mode)

**Phase 3: Payment Processing**
- 3 Work Packages
- 12 Tasks (complex logic, security)

**Nên dùng:** MANUAL mode
**Lý do:**
- Cần review kỹ từng bước
- Security-sensitive
- Complex edge cases
- Integration với payment gateway

---

## Troubleshooting

### 1. "Too many failed tasks"

**Hiện tượng:** >30% tasks failed

**Nguyên nhân:**
- Phase plan chưa đúng
- Environment chưa setup
- Dependencies thiếu

**Giải pháp:**
1. Dừng và review phase plan
2. Fix environment issues
3. Re-run ở Manual mode để debug

### 2. "Workflow stuck"

**Hiện tượng:** Workflow không tiến triển

**Nguyên nhân:**
- Command hang (không timeout)
- File system issue

**Giải pháp:**
1. Ctrl+C để dừng
2. Check CHECKLIST.md để xem task nào đang chạy
3. Fix issue
4. Re-run với START_FROM=[next task]

### 3. "Wrong code generated"

**Hiện tượng:** Code không đúng spec

**Nguyên nhân:**
- Phase plan thiếu detail
- Template không rõ ràng
- DD Reference không đầy đủ

**Giải pháp:**
1. Review và update phase plan
2. Add DD Reference chi tiết hơn
3. Re-run task với Manual mode

---

## Kết luận

**Auto Mode là công cụ mạnh để:**
- Tăng tốc implementation
- Giảm manual work
- Scale development

**Nhưng cần:**
- Phase plan chất lượng cao
- Review kỹ trước và sau
- Biết khi nào nên dùng Manual mode

**Golden Rule:**
> "Auto Mode để chạy nhanh, Manual Mode để chạy chính xác. Chọn mode phù hợp với từng phase!"

---

_Last updated: 2025-12-30_
