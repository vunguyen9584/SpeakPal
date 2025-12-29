---
description: Review tài liệu đặc tả yêu cầu (SRS) sử dụng checklist chuẩn
---

# Workflow: Review SRS Document

## 📝 Mô tả

Workflow này thực hiện review tài liệu SRS theo checklist chuẩn.

---

## 📥 BƯỚC 1: Thu thập tham số

Hỏi người dùng 1 tham số:

```
Để review tài liệu SRS, tôi cần thông tin sau:

**Folder chứa input và output** (ví dụ: ./docs/TênDựÁn)
```

Từ folder path, xác định các đường dẫn:

| Mục                 | Đường dẫn                                                        |
| ------------------- | ---------------------------------------------------------------- |
| File SRS cần review | [folder_path]/システム要件定義書/\_index.md                      |
| File Checklist      | ./.ai-instructions/system-requirement-specification-checklist.md |
| File Output         | [folder_path]/system-requirement-specification-checklist.md      |

---

## ✅ BƯỚC 2: Kiểm tra file tồn tại

- ❌ **BẮT BUỘC**: File SRS và Checklist phải tồn tại, nếu không → dừng workflow

---

## 📖 BƯỚC 3: Load file checklist

Đọc file checklist: `./.ai-instructions/system-requirement-specification-checklist.md`

**Checklist này chứa các tiêu chí cần kiểm tra (55 mục, 8 sections).**

---

## 🔍 BƯỚC 4: Thực hiện Review

### 4.1. Đọc file SRS (\_index.md) và xác định danh sách files con

Tùy theo structure của tài liệu, có thể bao gồm:

- 01-introduction.md
- 02-overall-description.md
- 03-functional-requirements.md
- 04-external-interfaces.md
- 05-non-functional-requirements.md
- 06-other-requirements.md
- 07-appendix.md

### 4.2. Review từng section theo checklist (8 sections)

| #    | Section                | Mô tả                                        |
| ---- | ---------------------- | -------------------------------------------- |
| I    | Tổng quan & Hình thức  | Thông tin tài liệu, định dạng, mục lục       |
| II   | Giới thiệu & Phạm vi   | Mục đích, scope, stakeholders, ràng buộc     |
| III  | Yêu cầu chức năng      | Use cases, luồng xử lý, business rules       |
| IV   | Yêu cầu phi chức năng  | Performance, security, scalability           |
| V    | Chất lượng yêu cầu     | Tính rõ ràng, đo lường được, khả thi         |
| VI   | Giao diện & Tương tác  | Wireframes, screen flow, external interfaces |
| VII  | Dữ liệu                | Data entities, attributes, relationships     |
| VIII | Truy xuất & Chất lượng | Traceability, decision log, approval         |

**⚠️ QUAN TRỌNG: Chỉ load từng file SRS con khi đang review section tương ứng**

---

## 📝 BƯỚC 5: Tạo file kết quả

Tạo file output: `[folder_path]/system-requirement-specification-checklist.md`

**Format file output:**

```markdown
# 📋 KẾT QUẢ REVIEW TÀI LIỆU SRS

## 📊 Thông tin Review

| Thông tin       | Giá trị                                     |
| --------------- | ------------------------------------------- |
| Ngày review     | [YYYY-MM-DD]                                |
| Tài liệu SRS    | [folder_path]/システム要件定義書/\_index.md |
| Người thực hiện | AI Assistant                                |

---

## 📋 CHECKLIST ĐÁNH GIÁ

[Copy cấu trúc từ checklist template và điền đánh giá ✅/❌/⚠️/N/A cho từng mục]

---

## 📊 TỔNG KẾT

| Mục                          | Tổng | ✅  | ❌  | ⚠️  | N/A |
| ---------------------------- | ---- | --- | --- | --- | --- |
| I. Tổng quan & Hình thức     | 6    |     |     |     |     |
| II. Giới thiệu & Phạm vi     | 6    |     |     |     |     |
| III. Yêu cầu chức năng       | 8    |     |     |     |     |
| IV. Yêu cầu phi chức năng    | 9    |     |     |     |     |
| V. Chất lượng yêu cầu        | 9    |     |     |     |     |
| VI. Giao diện & Tương tác    | 6    |     |     |     |     |
| VII. Dữ liệu                 | 6    |     |     |     |     |
| VIII. Truy xuất & Chất lượng | 5    |     |     |     |     |
| **TỔNG CỘNG**                | 55   |     |     |     |     |

---

## ⚠️ CÁC VẤN ĐỀ CẦN CẢI THIỆN

### Mức độ CAO (❌)

1. [Mục X.Y] - [Vấn đề] - [Đề xuất]

### Mức độ TRUNG BÌNH (⚠️)

1. [Mục X.Y] - [Vấn đề] - [Đề xuất]

---

## 💡 KHUYẾN NGHỊ

1. [Khuyến nghị 1]
2. [Khuyến nghị 2]

---

## 📝 KẾT LUẬN

☐ **Đạt** / ☐ **Đạt có điều kiện** / ☐ **Không đạt**
```

---

## 📊 BƯỚC 6: Tổng kết

Hiển thị tóm tắt cho người dùng với số lượng ✅/❌/⚠️ và các action items quan trọng nhất.

---

## 💡 Lưu ý

1. **Lazy loading**: Chỉ load file SRS con khi cần cho section đang review
2. **Tính khách quan**: Đánh giá dựa trên tiêu chuẩn trong checklist
3. **Ghi chú chi tiết**: Với mỗi mục ❌ hoặc ⚠️, phải có giải thích và đề xuất
4. **Tham chiếu checklist**: Các tiêu chí chi tiết xem tại `./.ai-instructions/system-requirement-specification-checklist.md`
