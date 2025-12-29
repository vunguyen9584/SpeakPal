# 📝 FORM THU THẬP THÔNG TIN YÊU CẦU HỆ THỐNG

> **Hướng dẫn**:
>
> - Các mục đánh dấu `⭐ BẮT BUỘC` phải được điền đầy đủ
> - Các mục khác có thể chọn `[Chưa biết]` để AI tự đề xuất lựa chọn phù hợp
> - Thông tin càng chi tiết, tài liệu SRS được tạo ra càng chính xác

---

## 1. THÔNG TIN CƠ BẢN

### 1.1. Tên dự án/hệ thống

```
[Điền tên dự án hoặc hệ thống]
```

### 1.2. Người yêu cầu

```
Tên: [Điền tên]
Vai trò: [Điền vai trò]
Email: [Điền email liên hệ]
Ngày yêu cầu: [DD/MM/YYYY]
```

---

## 2. MỤC ĐÍCH HỆ THỐNG ⭐ BẮT BUỘC

### 2.1. Vấn đề cần giải quyết

> Mô tả vấn đề hoặc nhu cầu mà hệ thống cần giải quyết

```
[Mô tả chi tiết vấn đề hiện tại, pain points, lý do cần xây dựng hệ thống]
```

### 2.2. Mục tiêu của hệ thống

> Hệ thống sẽ mang lại giá trị gì?

```
[Liệt kê các mục tiêu cụ thể mà hệ thống cần đạt được]
Ví dụ:
- Giảm 50% thời gian xử lý đơn hàng
- Tự động hóa quy trình báo cáo
- Cung cấp dashboard theo dõi real-time
```

---

## 3. CHỨC NĂNG MONG MUỐN ⭐ BẮT BUỘC

### 3.1. Danh sách chức năng chính

> Liệt kê các chức năng/tính năng mà hệ thống cần có

```
| STT | Tên chức năng | Mô tả ngắn gọn | Độ ưu tiên |
|-----|---------------|----------------|------------|
| 1 | [Tên chức năng 1] | [Mô tả] | ☐ Must ☐ Should ☐ Could ☐ Won't |
| 2 | [Tên chức năng 2] | [Mô tả] | ☐ Must ☐ Should ☐ Could ☐ Won't |
| 3 | [Tên chức năng 3] | [Mô tả] | ☐ Must ☐ Should ☐ Could ☐ Won't |
[Thêm các chức năng khác...]
```

### 3.2. Mô tả chi tiết các chức năng quan trọng (nếu có)

> Mô tả chi tiết hơn về các chức năng phức tạp

```
**Chức năng: [Tên chức năng]**
- Input: [Mô tả dữ liệu đầu vào]
- Process: [Mô tả xử lý]
- Output: [Mô tả kết quả đầu ra]
- Nghiệp vụ đặc biệt: [Các rule nghiệp vụ cần tuân thủ]
```

---

## 4. ĐỐI TƯỢNG SỬ DỤNG

> Chọn một trong các option hoặc mô tả chi tiết

- [ ] **[Chưa biết]** - AI sẽ đề xuất dựa trên loại hệ thống

**HOẶC điền chi tiết:**

```
| Role | Mô tả | Quyền hạn chính |
|------|-------|-----------------|
| [Role 1] | [Mô tả vai trò] | [Liệt kê quyền] |
| [Role 2] | [Mô tả vai trò] | [Liệt kê quyền] |
[Thêm các role khác...]
```

---

## 5. PHẠM VI HỆ THỐNG

> Chọn một trong các option hoặc mô tả chi tiết

- [ ] **[Chưa biết]** - AI sẽ đề xuất dựa trên chức năng

**HOẶC điền chi tiết:**

### 5.1. Trong phạm vi (In Scope)

```
[Liệt kê những gì nằm trong phạm vi của hệ thống]
```

### 5.2. Ngoài phạm vi (Out of Scope)

```
[Liệt kê những gì KHÔNG nằm trong phạm vi của dự án này]
```

---

## 6. LOẠI ỨNG DỤNG

> Chọn loại ứng dụng phù hợp

- [ ] **[Chưa biết]** - AI sẽ đề xuất dựa trên yêu cầu

**HOẶC chọn:**

- [ ] Web Application
- [ ] Mobile Application (iOS/Android/Both)
- [ ] Desktop Application
- [ ] API/Backend Service
- [ ] Hybrid (Web + Mobile)
- [ ] Khác: `[Mô tả]`

---

## 7. CÔNG NGHỆ/NỀN TẢNG

> Chọn một trong các option hoặc mô tả chi tiết

- [ ] **[Chưa biết]** - AI sẽ đề xuất stack phù hợp

**HOẶC điền chi tiết:**

```
Frontend: [VD: React, Vue, Angular, ...]
Backend: [VD: Node.js, Java Spring, .NET, Python Django, ...]
Database: [VD: PostgreSQL, MySQL, MongoDB, ...]
Cloud/Hosting: [VD: AWS, Azure, GCP, On-premise, ...]
Khác: [Các công nghệ đặc thù khác]
```

---

## 8. YÊU CẦU HIỆU NĂNG

> Chọn một trong các option hoặc mô tả chi tiết

- [ ] **[Chưa biết]** - AI sẽ đề xuất mức tiêu chuẩn

**HOẶC điền chi tiết:**

```
Số lượng người dùng đồng thời (CCU): [Số lượng]
Thời gian phản hồi tối đa: [VD: < 2 giây]
Số lượng request/giây: [Số lượng]
Dung lượng dữ liệu dự kiến: [VD: 100GB/năm]
Uptime yêu cầu: [VD: 99.9%]
```

---

## 9. YÊU CẦU BẢO MẬT

> Chọn một trong các option hoặc mô tả chi tiết

- [ ] **[Chưa biết]** - AI sẽ đề xuất mức bảo mật phù hợp

**HOẶC chọn mức độ và chi tiết:**

**Mức độ bảo mật:**

- [ ] Cơ bản (Basic Authentication, HTTPS)
- [ ] Trung bình (+ Role-based Access, Session Management)
- [ ] Cao (+ MFA, Encryption, Audit Log, Compliance)
- [ ] Rất cao (+ Advanced Security Measures, Penetration Testing)

**Yêu cầu cụ thể (nếu có):**

```
[Mô tả các yêu cầu bảo mật đặc thù]
```

---

## 10. THIẾT BỊ/TRÌNH DUYỆT HỖ TRỢ

> Chọn một trong các option hoặc mô tả chi tiết

- [ ] **[Chưa biết]** - AI sẽ đề xuất danh sách tiêu chuẩn

**HOẶC chọn:**

**Trình duyệt:**

- [ ] Chrome (phiên bản: `____`)
- [ ] Firefox (phiên bản: `____`)
- [ ] Safari (phiên bản: `____`)
- [ ] Edge (phiên bản: `____`)
- [ ] Khác: `[Liệt kê]`

**Thiết bị:**

- [ ] Desktop (Windows/Mac/Linux)
- [ ] Tablet
- [ ] Mobile Phone
- [ ] Khác: `[Liệt kê]`

---

## 11. TÍCH HỢP HỆ THỐNG KHÁC

> Chọn một trong các option hoặc mô tả chi tiết

- [ ] **[Chưa biết]** - Không có hoặc sẽ xác định sau
- [ ] **Không có tích hợp** - Hệ thống độc lập

**HOẶC điền chi tiết:**

```
| Hệ thống/Dịch vụ | Loại tích hợp | Mục đích |
|------------------|---------------|----------|
| [Tên hệ thống 1] | [API/File/Message Queue/...] | [Mô tả mục đích] |
| [Tên hệ thống 2] | [API/File/Message Queue/...] | [Mô tả mục đích] |
```

---

## 12. NGÔN NGỮ TÀI LIỆU

> Chọn ngôn ngữ cho tài liệu SRS

- [ ] Tiếng Việt
- [ ] Tiếng Anh
- [ ] Tiếng Nhật
- [ ] Song ngữ: `[Liệt kê]`

---

## 13. RÀNG BUỘC & GIẢ ĐỊNH

> Chọn một trong các option hoặc mô tả chi tiết

- [ ] **[Chưa biết]** - AI sẽ xác định dựa trên context

**HOẶC điền chi tiết:**

### 13.1. Ràng buộc (Constraints)

```
[Liệt kê các ràng buộc về thời gian, ngân sách, công nghệ, pháp lý, ...]
- Ràng buộc 1: [Mô tả]
- Ràng buộc 2: [Mô tả]
```

### 13.2. Giả định (Assumptions)

```
[Liệt kê các giả định khi xây dựng yêu cầu]
- Giả định 1: [Mô tả]
- Giả định 2: [Mô tả]
```

---

## 14. TIMELINE & DEADLINE

> Chọn một trong các option hoặc mô tả chi tiết

- [ ] **[Chưa biết]** - Chưa xác định timeline

**HOẶC điền chi tiết:**

```
Ngày bắt đầu dự kiến: [DD/MM/YYYY]
Ngày kết thúc dự kiến: [DD/MM/YYYY]
Các milestone quan trọng:
- Milestone 1: [Mô tả] - [DD/MM/YYYY]
- Milestone 2: [Mô tả] - [DD/MM/YYYY]
```

---

## 15. THÔNG TIN BỔ SUNG

> Thông tin khác mà bạn muốn AI biết để tạo SRS tốt hơn

```
[Điền bất kỳ thông tin bổ sung nào]
```

---

## 16. TÀI LIỆU THAM KHẢO

> Liệt kê các tài liệu, link, file đính kèm có liên quan

```
- [Tên tài liệu 1]: [Mô tả ngắn / Link]
- [Tên tài liệu 2]: [Mô tả ngắn / Link]
```

---

## ✅ XÁC NHẬN THÔNG TIN

- [ ] Tôi đã điền đầy đủ các mục **BẮT BUỘC** (Mục 2 và 3)
- [ ] Các mục chọn **[Chưa biết]** tôi đồng ý để AI đề xuất
- [ ] Tôi hiểu rằng AI sẽ ghi nhận các quyết định vào Decision Log

---

**Ngày điền form**: `[DD/MM/YYYY]`

**Người điền**: `[Họ tên]`

**Chữ ký**: `________________`
