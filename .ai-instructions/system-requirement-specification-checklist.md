# 📋 CHECKLIST KIỂM TRA TÀI LIỆU ĐẶC TẢ YÊU CẦU HỆ THỐNG (SRS)

> **Mục đích**: Đảm bảo tài liệu SRS đầy đủ, chính xác và có chất lượng cao trước khi chuyển sang giai đoạn thiết kế.

---

## 🔖 Hướng dẫn sử dụng

| Ký hiệu | Ý nghĩa          |
| ------- | ---------------- |
| ✅      | Đạt yêu cầu      |
| ❌      | Chưa đạt yêu cầu |
| ⚠️      | Cần xem xét thêm |
| N/A     | Không áp dụng    |

---

## I. TỔNG QUAN & HÌNH THỨC TÀI LIỆU

| STT | Hạng mục             | Nội dung kiểm tra                                                         | Đánh giá | Ghi chú |
| --- | -------------------- | ------------------------------------------------------------------------- | -------- | ------- |
| 1.1 | Thông tin tài liệu   | Có tiêu đề, phiên bản, ngày tạo, tác giả?                                 | ☐        |         |
| 1.2 | Lịch sử sửa đổi      | Có bảng ghi rõ phiên bản, ngày sửa, người sửa và tóm tắt thay đổi?        | ☐        |         |
| 1.3 | Mục lục              | Có mục lục và có link/tham chiếu đến các section?                         | ☐        |         |
| 1.4 | Thuật ngữ & Viết tắt | Các từ viết tắt, thuật ngữ chuyên ngành có được định nghĩa đầy đủ?        | ☐        |         |
| 1.5 | Tài liệu tham khảo   | Có liệt kê các tài liệu liên quan và nguồn tham khảo?                     | ☐        |         |
| 1.6 | Định dạng nhất quán  | Định dạng (font, heading, numbering) có nhất quán trong toàn bộ tài liệu? | ☐        |         |

---

## II. GIỚI THIỆU & PHẠM VI

| STT | Hạng mục          | Nội dung kiểm tra                                                    | Đánh giá | Ghi chú |
| --- | ----------------- | -------------------------------------------------------------------- | -------- | ------- |
| 2.1 | Mục đích hệ thống | Mục đích và lý do xây dựng hệ thống có được mô tả rõ ràng?           | ☐        |         |
| 2.2 | Phạm vi (Scope)   | Có xác định rõ những gì hệ thống SẼ LÀM và KHÔNG LÀM (Out of scope)? | ☐        |         |
| 2.3 | Đối tượng sử dụng | Có liệt kê đầy đủ các đối tượng sử dụng hệ thống (Stakeholders)?     | ☐        |         |
| 2.4 | Ràng buộc         | Có nêu rõ các ràng buộc về kỹ thuật, pháp lý, business?              | ☐        |         |
| 2.5 | Giả định          | Có liệt kê các giả định khi xây dựng yêu cầu?                        | ☐        |         |
| 2.6 | Phụ thuộc         | Có xác định các phụ thuộc với hệ thống/dịch vụ bên ngoài?            | ☐        |         |

---

## III. YÊU CẦU CHỨC NĂNG (FUNCTIONAL REQUIREMENTS)

| STT | Hạng mục                          | Nội dung kiểm tra                                                                 | Đánh giá | Ghi chú |
| --- | --------------------------------- | --------------------------------------------------------------------------------- | -------- | ------- |
| 3.1 | Danh sách tính năng               | Đầy đủ tính năng theo User Story/Use Case?                                        | ☐        |         |
| 3.2 | Use Case / User Story             | Mỗi use case có: Actor, Precondition, Main Flow, Alternative Flow, Postcondition? | ☐        |         |
| 3.3 | Phân quyền (Authorization)        | Có xác định rõ quyền hạn của từng Role (Admin, User, Guest...)?                   | ☐        |         |
| 3.4 | Luồng chính (Happy Path)          | Có mô tả đầy đủ luồng xử lý thành công cho mỗi tính năng?                         | ☐        |         |
| 3.5 | Luồng thay thế (Alternative Path) | Có mô tả các trường hợp thay thế khi không thể đi theo luồng chính?               | ☐        |         |
| 3.6 | Xử lý ngoại lệ (Exception Path)   | Có mô tả cách xử lý khi có lỗi xảy ra?                                            | ☐        |         |
| 3.7 | Nghiệp vụ (Business Rules)        | Các rule nghiệp vụ có được định nghĩa rõ ràng và có mã định danh?                 | ☐        |         |
| 3.8 | Validation dữ liệu                | Có quy định kiểu dữ liệu, độ dài, format, bắt buộc/không bắt buộc cho input?      | ☐        |         |

---

## IV. YÊU CẦU PHI CHỨC NĂNG (NON-FUNCTIONAL REQUIREMENTS)

| STT | Hạng mục                           | Nội dung kiểm tra                                                            | Đánh giá | Ghi chú |
| --- | ---------------------------------- | ---------------------------------------------------------------------------- | -------- | ------- |
| 4.1 | Hiệu năng (Performance)            | Có chỉ số cụ thể về thời gian phản hồi, throughput, số user đồng thời (CCU)? | ☐        |         |
| 4.2 | Khả năng mở rộng (Scalability)     | Có yêu cầu về khả năng scale theo chiều ngang/dọc?                           | ☐        |         |
| 4.3 | Độ sẵn sàng (Availability)         | Có yêu cầu về uptime (99.9%, 99.99%)?                                        | ☐        |         |
| 4.4 | Bảo mật (Security)                 | Có quy định về Authentication, Authorization, mã hóa, session timeout?       | ☐        |         |
| 4.5 | Tương thích (Compatibility)        | Có danh sách trình duyệt, thiết bị, hệ điều hành hỗ trợ?                     | ☐        |         |
| 4.6 | Khả năng bảo trì (Maintainability) | Có yêu cầu về coding standards, documentation, modularity?                   | ☐        |         |
| 4.7 | Khả năng phục hồi (Reliability)    | Có yêu cầu về backup, disaster recovery, MTTR, MTBF?                         | ☐        |         |
| 4.8 | Usability                          | Có yêu cầu về UX/UI, accessibility (WCAG)?                                   | ☐        |         |
| 4.9 | Compliance                         | Có các yêu cầu tuân thủ pháp luật, tiêu chuẩn (GDPR, PCI-DSS, ISO)?          | ☐        |         |

---

## V. CHẤT LƯỢNG YÊU CẦU

| STT | Hạng mục                        | Nội dung kiểm tra                                                           | Đánh giá | Ghi chú |
| --- | ------------------------------- | --------------------------------------------------------------------------- | -------- | ------- |
| 5.1 | Tính rõ ràng (Clear)            | Tránh các từ mơ hồ ("có thể", "nên", "nhanh", "đẹp", "thích hợp")?          | ☐        |         |
| 5.2 | Tính đo lường được (Measurable) | Các yêu cầu có tiêu chí đo lường cụ thể?                                    | ☐        |         |
| 5.3 | Tính khả thi (Achievable)       | Các yêu cầu có khả thi về mặt kỹ thuật và nguồn lực?                        | ☐        |         |
| 5.4 | Tính nhất quán (Consistent)     | Không có mâu thuẫn giữa các yêu cầu?                                        | ☐        |         |
| 5.5 | Tính kiểm tra được (Testable)   | Mỗi yêu cầu có thể viết test case để verify?                                | ☐        |         |
| 5.6 | Tiền điều kiện                  | Có nêu rõ điều kiện để bắt đầu thực hiện chức năng?                         | ☐        |         |
| 5.7 | Hậu điều kiện                   | Có nêu rõ kết quả/trạng thái sau khi thực hiện xong?                        | ☐        |         |
| 5.8 | Requirement ID                  | Mỗi yêu cầu có mã định danh duy nhất (REQ-001, FR-001, NFR-001)?            | ☐        |         |
| 5.9 | Độ ưu tiên                      | Mỗi yêu cầu có độ ưu tiên (Must have, Should have, Could have, Won't have)? | ☐        |         |

---

## VI. GIAO DIỆN & TƯƠNG TÁC

| STT | Hạng mục                     | Nội dung kiểm tra                                                     | Đánh giá | Ghi chú |
| --- | ---------------------------- | --------------------------------------------------------------------- | -------- | ------- |
| 6.1 | Danh sách màn hình           | Có liệt kê đầy đủ các màn hình/trang của hệ thống?                    | ☐        |         |
| 6.2 | Wireframe/Mockup             | Có wireframe hoặc mockup cho các màn hình chính?                      | ☐        |         |
| 6.3 | Luồng màn hình (Screen Flow) | Có sơ đồ mô tả navigation giữa các màn hình?                          | ☐        |         |
| 6.4 | Giao diện với hệ thống khác  | Có mô tả integration với external systems (API, file, message queue)? | ☐        |         |
| 6.5 | Hardware Interface           | Có mô tả tương tác với phần cứng (nếu có)?                            | ☐        |         |
| 6.6 | Report/Export                | Có mô tả các báo cáo, export cần có?                                  | ☐        |         |

---

## VII. DỮ LIỆU

| STT | Hạng mục           | Nội dung kiểm tra                                           | Đánh giá | Ghi chú |
| --- | ------------------ | ----------------------------------------------------------- | -------- | ------- |
| 7.1 | Data Entities      | Có liệt kê các đối tượng dữ liệu chính của hệ thống?        | ☐        |         |
| 7.2 | Data Attributes    | Có mô tả các thuộc tính của mỗi entity?                     | ☐        |         |
| 7.3 | Data Relationships | Có mô tả quan hệ giữa các entities?                         | ☐        |         |
| 7.4 | Data Volume        | Có ước tính về khối lượng dữ liệu (số records, dung lượng)? | ☐        |         |
| 7.5 | Data Migration     | Có yêu cầu về migration dữ liệu từ hệ thống cũ (nếu có)?    | ☐        |         |
| 7.6 | Data Retention     | Có chính sách về lưu trữ và xóa dữ liệu?                    | ☐        |         |

---

## VIII. TRUY XUẤT & CHẤT LƯỢNG TÀI LIỆU

| STT | Hạng mục            | Nội dung kiểm tra                                      | Đánh giá | Ghi chú |
| --- | ------------------- | ------------------------------------------------------ | -------- | ------- |
| 8.1 | Traceability Matrix | Có ma trận truy xuất Requirement → Design → Test Case? | ☐        |         |
| 8.2 | Decision Log        | Có ghi nhận các quyết định quan trọng và lý do?        | ☐        |         |
| 8.3 | Open Issues         | Có danh sách các vấn đề còn chưa giải quyết (TBD/TBC)? | ☐        |         |
| 8.4 | Approval            | Có phần phê duyệt với chữ ký các stakeholders?         | ☐        |         |
| 8.5 | Review Record       | Có ghi nhận kết quả review từ các bên liên quan?       | ☐        |         |

---

## 📊 TỔNG KẾT ĐÁNH GIÁ

| Mục                          | Tổng số hạng mục | Đạt (✅) | Không đạt (❌) | Cần xem xét (⚠️) | N/A |
| ---------------------------- | ---------------- | -------- | -------------- | ---------------- | --- |
| I. Tổng quan & Hình thức     | 6                |          |                |                  |     |
| II. Giới thiệu & Phạm vi     | 6                |          |                |                  |     |
| III. Yêu cầu chức năng       | 8                |          |                |                  |     |
| IV. Yêu cầu phi chức năng    | 9                |          |                |                  |     |
| V. Chất lượng yêu cầu        | 9                |          |                |                  |     |
| VI. Giao diện & Tương tác    | 6                |          |                |                  |     |
| VII. Dữ liệu                 | 6                |          |                |                  |     |
| VIII. Truy xuất & Chất lượng | 5                |          |                |                  |     |
| **TỔNG CỘNG**                | **55**           |          |                |                  |     |

---

## 📝 GHI CHÚ ĐÁNH GIÁ

| Người đánh giá | Ngày đánh giá | Kết luận                        | Ghi chú |
| -------------- | ------------- | ------------------------------- | ------- |
|                |               | ☐ Đạt ☐ Không đạt ☐ Cần sửa đổi |         |

---

## 🔗 TÀI LIỆU LIÊN QUAN

- [Form thu thập thông tin yêu cầu](./system-requirement-specification-form-template.md)
- [Hướng dẫn tạo SRS](./system-requirement-specification-instructions.md)
- [Decision Log Template](./system-requirement-specification-decision-log.md)
