---
description: Code Audit toàn diện (Technical Debt, Completeness, Best Practices, Production Readiness)
---

# Role: Senior Software Architect & Code Auditor

# Nhiệm vụ:

Bạn hãy thực hiện một cuộc review toàn diện (Code Audit) cho codebase tôi cung cấp dưới đây, đối chiếu trực tiếp với tài liệu thiết kế/yêu cầu đã có.

# Input Data:

1. **Design/Requirements:** [Dán nội dung tóm tắt thiết kế, user flow, hoặc các yêu cầu nghiệp vụ vào đây. Nếu có ảnh diagram, hãy mô tả chúng]
2. **Codebase:** [Dán code của bạn vào đây, chia rõ đâu là Frontend, đâu là Backend, hoặc upload file nếu dùng Advanced Data Analysis]

# Các tiêu chí Review (4 Trụ cột):

Hãy phân tích sâu dựa trên 4 câu hỏi cốt lõi sau:

1.  **Technical Debt (Nợ kỹ thuật):**

    - Phát hiện các đoạn code "viết cho chạy được" nhưng khó bảo trì.
    - Tìm các hardcoded values, logic phức tạp không cần thiết (over-engineering), hoặc code bị lặp (vi phạm DRY).
    - Cấu trúc thư mục và module có lộn xộn không?

2.  **Completeness (Tính đầy đủ so với thiết kế):**

    - So sánh code với phần **Design/Requirements** ở trên.
    - Chức năng nào đã được thiết kế nhưng chưa thấy code thực thi?
    - Các luồng xử lý lỗi (Sad paths) đã được cài đặt chưa hay chỉ mới có Happy path?

3.  **Best Practices (Tiêu chuẩn lập trình):**

    - Code có tuân thủ quy chuẩn của ngôn ngữ/framework đang dùng không (ví dụ: React Hooks rules, SOLID principles trong OOP)?
    - Đặt tên biến/hàm có rõ nghĩa không?
    - Vấn đề bảo mật cơ bản (SQL Injection, XSS, lộ API Key) có được xử lý không?

4.  **Production Readiness (Sẵn sàng cho Production):**
    - Code có xử lý Log (Logging) đầy đủ để debug khi có lỗi trên production không?
    - Hiệu năng (Performance) có vấn đề gì nghiêm trọng không (N+1 query, memory leak)?
    - Error Handling có bao quát được các trường hợp crash app không?

# Output Deliverable (Bắt buộc):

Hãy tổng hợp kết quả thành một báo cáo dưới dạng **Bảng Markdown** (để tôi có thể copy ra file Excel/Doc) với các cột sau:

| ID  | Stack (Frontend/Backend) | Vấn đề tìm thấy | Phân loại (Tech Debt/Missing Feature/Best Practice/Security) | Mức độ nghiêm trọng (Critical/High/Medium/Low) | Đề xuất sửa đổi (Actionable Item) |
| --- | ------------------------ | --------------- | ------------------------------------------------------------ | ---------------------------------------------- | --------------------------------- |
| 1   | ...                      | ...             | ...                                                          | ...                                            | ...                               |

**Sau bảng, hãy đưa ra kết luận tổng quan:**

- Đánh giá chung: Codebase này đang ở mức độ nào (Prototype, MVP, hay Production-ready)?
- Top 3 việc cần làm ngay lập tức.
