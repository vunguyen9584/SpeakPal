---
description: Tạo System Requirement Specification (SRS) document từ thông tin người dùng
---

# Workflow: Tạo SRS Document

## 📝 Mô tả

Workflow này hướng dẫn AI thu thập thông tin từ người dùng và tạo SRS document theo hướng dẫn chuẩn.

---

## 📥 BƯỚC 1: Thu thập tham số từ người dùng

Hỏi người dùng 3 tham số sau:

```
Để tạo SRS document, tôi cần các thông tin sau:

1. **Folder chứa input và output** (ví dụ: ./docs/TênDựÁn)
   - Đây là thư mục chứa file form input và sẽ lưu output SRS

2. **Tên file chứa form input** (ví dụ: srs-input.md)
   - File này phải chứa thông tin dự án theo template chuẩn

3. **Tài liệu tham khảo** (tùy chọn, có thể để trống)
   - Đường dẫn đến các tài liệu tham khảo bổ sung nếu có
```

---

## ✅ BƯỚC 2: Kiểm tra và xác nhận tham số

Sau khi nhận được tham số từ người dùng:

### 2.1. Xác nhận tham số

```markdown
### ✨ Xác nhận tham số:

| Tham số             | Giá trị                    |
| ------------------- | -------------------------- |
| Folder input/output | [folder_path]              |
| File form input     | [input_file_name]          |
| Tài liệu tham khảo  | [ref_docs hoặc "Không có"] |
```

### 2.2. Kiểm tra file tồn tại

- Kiểm tra file form input có tồn tại: `[folder_path]/[input_file_name]`
- Nếu không tồn tại, thông báo và hỏi người dùng có muốn tạo file mới từ template không

---

## 📖 BƯỚC 3: Load hướng dẫn và form input

### 3.1. Load file hướng dẫn

Đọc nội dung từ file: `./.ai-instructions/system-requirement-specification-instructions.md`

### 3.2. Load file form input

Đọc nội dung từ file: `[folder_path]/[input_file_name]`

### 3.3. Load tài liệu tham khảo (nếu có)

Nếu người dùng cung cấp tài liệu tham khảo, đọc nội dung các file đó.

---

## 🚀 BƯỚC 4: Tạo SRS Document

Thực hiện tạo SRS với yêu cầu sau:

```markdown
Tôi cần bạn tạo System Requirement Specification (SRS) cho dự án sau:

# HƯỚNG DẪN

Load từ file ./.ai-instructions/system-requirement-specification-instructions.md

# THÔNG TIN DỰ ÁN

## 1. Form thu thập thông tin (⭐ BẮT BUỘC)

Load từ file "[folder_path]/[input_file_name]"

## 2. Tài liệu tham khảo (Tùy chọn)

[ref_docs hoặc "Không có"]

## 3. Yêu cầu bổ sung

- **Phạm vi tạo SRS:** Toàn bộ

- **Mức độ chi tiết:** Chi tiết đầy đủ

- **Format:** Markdown với Mermaid diagrams

- **Ngôn ngữ sử dụng:** Tiếng Nhật (hoặc theo form input nếu có chỉ định)

- **Output:**

  - Thư mục chứa tài liệu: [folder_path]/システム要件定義書

  - Decision Log: [folder_path]/decision-log.md

## 4. Lưu ý đặc biệt

- Với các mục chọn "Chưa biết", AI sẽ đề xuất và ghi nhận vào Decision Log
- Sau khi hoàn thành, hãy kiểm tra với checklist: [folder_path]/system-requirement-specification-checklist.md
```

---

## 📋 BƯỚC 5: Tạo cấu trúc thư mục output

Tạo thư mục và các file theo cấu trúc:

```
[folder_path]/
├── システム要件定義書/
│   ├── _index.md
│   ├── 01-introduction.md
│   ├── 02-overall-description.md
│   ├── 03-functional-requirements.md
│   ├── 04-external-interfaces.md
│   ├── 05-non-functional-requirements.md
│   ├── 06-other-requirements.md
│   └── 07-appendix.md
├── decision-log.md
└── system-requirement-specification-checklist.md
```

---

## ✅ BƯỚC 6: Kiểm tra với Checklist

### 6.1. Copy checklist template

Copy file `./.ai-instructions/system-requirement-specification-checklist.md`
vào `[folder_path]/system-requirement-specification-checklist.md`

### 6.2. Thực hiện kiểm tra

Đánh dấu từng mục trong checklist:

- ✅ Đã hoàn thành
- ❌ Chưa hoàn thành - cần bổ sung

### 6.3. Báo cáo kết quả

Tóm tắt kết quả kiểm tra và các mục cần bổ sung (nếu có)

---

## 📊 BƯỚC 7: Tổng kết

Hiển thị tổng kết cho người dùng:

```markdown
## ✨ Hoàn thành tạo SRS

### 📂 Files đã tạo:

- [folder_path]/システム要件定義書/\_index.md
- [folder_path]/システム要件定義書/01-introduction.md
- ... (liệt kê tất cả files)
- [folder_path]/decision-log.md
- [folder_path]/system-requirement-specification-checklist.md

### 📝 Decision Log:

[Số lượng] quyết định đã được ghi nhận

### ✅ Checklist:

[X/Y] mục đã hoàn thành

### ⚠️ Các mục cần review:

- [Liệt kê nếu có]
```

---

## 💡 Lưu ý

1. **Form Input**: File form input phải tuân theo template chuẩn trong `./.ai-instructions/system-requirement-specification-form-template.md`

2. **Ngôn ngữ**: Mặc định sử dụng Tiếng Nhật, có thể thay đổi theo yêu cầu trong form input

3. **Decision Log**: Tất cả quyết định của AI cho các mục "Chưa biết" phải được ghi vào Decision Log với lý do rõ ràng

4. **Checklist**: Luôn thực hiện bước kiểm tra với checklist để đảm bảo SRS đầy đủ và chất lượng
