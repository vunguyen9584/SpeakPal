# Hướng dẫn Progress Tracking & Resume cho workflow create-bd

> 📌 File này chứa hướng dẫn chi tiết về việc tracking progress và resume từ session mới

---

## 📋 Kiểm tra Progress File

Kiểm tra file: `[folder_path]/bd-progress.md`

### Nếu file CHƯA TỒN TẠI

1. Copy template từ `./.ai-instructions/bd-progress-template.md`
2. Tạo file `[folder_path]/bd-progress.md`
3. Cập nhật thông tin project và folder path
4. Ghi timestamp bắt đầu

### Nếu file ĐÃ TỒN TẠI

1. Đọc file progress hiện tại
2. Tìm chương có status `🔄 In Progress` hoặc `⬜ Not Started` đầu tiên
3. Thông báo cho user:

```
📊 **Phát hiện progress từ session trước:**

✅ Đã hoàn thành: [X]/11 chương
🔄 Đang làm: [CHAPTER_NAME] (nếu có)
⬜ Chưa làm: [Y] chương

Bạn muốn:
1. **Tiếp tục** từ vị trí hiện tại
2. **Bắt đầu lại** từ đầu (reset progress)
```

---

## 🔄 Cập nhật Progress sau mỗi chương

Sau khi hoàn thành mỗi chương, **BẮT BUỘC** cập nhật file `bd-progress.md`:

1. Đổi status của chương vừa hoàn thành: `⬜ Not Started` → `✅ Completed`
2. Cập nhật cột `Completed` với timestamp
3. Cập nhật `Last Update` trong thông tin chung
4. Cập nhật `Next Action` với chương tiếp theo
5. Thêm entry vào `Changelog`

**Template cập nhật status:**

```markdown
| 01-system-overview.md | ✅ Completed | 2025-12-21 17:30 | 2025-12-21 17:45 | OK |
```

---

## ⏸️ Lưu trạng thái khi dừng giữa chừng

Nếu cần dừng workflow giữa chừng:

1. Đổi status chương đang làm thành `🔄 In Progress`
2. Ghi chi tiết vào cột `Notes` về phần đang làm dở
3. Cập nhật `Next Action` với mô tả cụ thể
4. Thêm entry vào `Changelog`

**Ví dụ Notes cho chương đang làm dở:**

```markdown
| 04-screen-design.md | 🔄 In Progress | 2025-12-21 18:00 | - | Đã làm 10/18 màn hình |
```

---

## ✅ Đánh dấu hoàn thành workflow

Khi hoàn thành toàn bộ workflow, cập nhật file `bd-progress.md`:

1. Đổi `Status` trong thông tin chung thành `✅ Completed`
2. Đổi tất cả chương thành `✅ Completed`
3. Cập nhật `Last Update` với timestamp hiện tại
4. Ghi `Next Action`: "Workflow completed - Ready for review"
5. Thêm entry cuối vào `Changelog`: "Hoàn thành tất cả các chương"

---

## 📝 Status Legend

| Icon | Status       | Mô tả                                   |
| ---- | ------------ | --------------------------------------- |
| ⬜   | Not Started  | Chưa bắt đầu                            |
| 🔄   | In Progress  | Đang làm                                |
| ✅   | Completed    | Hoàn thành                              |
| ⚠️   | Needs Review | Cần review lại                          |
| ❌   | Blocked      | Bị chặn (thiếu input hoặc dependencies) |
