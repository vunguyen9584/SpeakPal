---
description: Dịch tài liệu sang ngôn ngữ khác, giữ nguyên format và nội dung gốc
---

# Workflow: Translate Document

## Mục đích

Dịch một tài liệu sang ngôn ngữ đích, giữ nguyên cấu trúc và format của file gốc.

---

## Bước 1: Thu thập thông tin

Hỏi người dùng các thông tin sau:

### 1.1 Đường dẫn tài liệu

```
Nhập đường dẫn file cần dịch (tuyệt đối hoặc tương đối):
```

### 1.2 Ngôn ngữ đích

```
Nhập ngôn ngữ đích (ví dụ: English, Japanese, Vietnamese, Chinese...):
```

---

## Bước 2: Xác định mã ngôn ngữ

Chuyển đổi ngôn ngữ đích thành mã ISO 639-1 (2 ký tự):

| Ngôn ngữ              | Mã    |
| --------------------- | ----- |
| English               | en    |
| Vietnamese            | vi    |
| Japanese              | ja    |
| Chinese (Simplified)  | zh    |
| Chinese (Traditional) | zh-tw |
| Korean                | ko    |
| French                | fr    |
| German                | de    |
| Spanish               | es    |
| Portuguese            | pt    |
| Russian               | ru    |
| Thai                  | th    |
| Indonesian            | id    |
| Italian               | it    |
| Dutch                 | nl    |
| Arabic                | ar    |
| Hindi                 | hi    |

Nếu ngôn ngữ không có trong danh sách, tra cứu mã ISO 639-1 tương ứng.

---

## Bước 3: Xác định output path

Từ đường dẫn file gốc, tạo đường dẫn file output:

**Quy tắc đặt tên:**

- Cùng thư mục với file gốc
- Tên file = `[tên_gốc]_[mã_ngôn_ngữ].[đuôi_file]`

**Ví dụ:**
| File gốc | Ngôn ngữ đích | File output |
|----------|---------------|-------------|
| `docs/guide.md` | Japanese | `docs/guide_ja.md` |
| `README.md` | Vietnamese | `README_vi.md` |
| `spec/api.txt` | English | `spec/api_en.txt` |
| `manual.docx` | Chinese | `manual_zh.docx` |

---

## Bước 4: Đọc và dịch tài liệu

### 4.1 Đọc file gốc

Sử dụng `view_file` để đọc toàn bộ nội dung file gốc.

### 4.2 Dịch nội dung

**QUY TẮC DỊCH QUAN TRỌNG:**

1. **Chỉ dịch nội dung văn bản** - Không thay đổi:

   - Cấu trúc file (headings, bullets, tables...)
   - Code blocks và inline code
   - URLs và links
   - Tên file, đường dẫn
   - Tên biến, hàm, class trong code
   - Số liệu, ngày tháng
   - Format markdown/markup

2. **Giữ nguyên format** - Bảo toàn:

   - Số dòng và khoảng cách
   - Indentation
   - Special characters
   - Frontmatter (YAML, JSON...)

3. **KHÔNG thêm nội dung** - Tuyệt đối không:

   - Thêm ghi chú giải thích
   - Thêm header/footer
   - Thêm disclaimer về bản dịch
   - Thêm bất kỳ nội dung nào không có trong file gốc

4. **Xử lý đặc biệt:**
   - Comment trong code: Dịch
   - Alt text của hình ảnh: Dịch
   - Placeholder text: Dịch
   - Error messages trong ví dụ: Dịch
   - Technical terms phổ biến: Có thể giữ nguyên tiếng Anh nếu phù hợp

---

## Bước 5: Tạo file output

Sử dụng `write_to_file` để tạo file đã dịch với đường dẫn xác định ở Bước 3.

**Lưu ý:**

- Nếu file output đã tồn tại, hỏi người dùng có muốn ghi đè không
- Đảm bảo encoding UTF-8

---

## Bước 6: Xác nhận hoàn thành

Thông báo cho người dùng:

```
✅ Dịch hoàn tất!

📄 File gốc: [đường_dẫn_gốc]
📝 File dịch: [đường_dẫn_output]
🌐 Ngôn ngữ: [ngôn_ngữ_gốc] → [ngôn_ngữ_đích]
📊 Số dòng: [số_dòng]
```

---

## Ví dụ sử dụng

**Input:**

```
Đường dẫn: docs/Presentation/DB_Design/how-to-read-db-design-slides.md
Ngôn ngữ đích: Japanese
```

**Output:**

```
docs/Presentation/DB_Design/how-to-read-db-design-slides_ja.md
```

---

## Lưu ý quan trọng

1. **File lớn**: Nếu file > 800 dòng, chia nhỏ thành từng phần để dịch
2. **File binary**: Workflow này chỉ hỗ trợ file text (md, txt, html, xml, json...)
3. **Chất lượng dịch**: Đảm bảo dịch tự nhiên, phù hợp ngữ cảnh
4. **Thuật ngữ chuyên ngành**: Giữ nhất quán trong toàn bộ tài liệu
