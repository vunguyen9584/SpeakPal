---
description: Tạo tài liệu học tập toàn diện cho một chủ đề phần mềm, từ cơ bản đến senior level
---

Execute the learning document creation workflow following the steps in `.agent/workflows/learn-topic.md`.

**Workflow Overview:**

1. **Thu thập thông tin**: Xác nhận chủ đề, level hiện tại, mục tiêu cụ thể
2. **Tìm kiếm web**: Thông tin mới nhất về công nghệ
3. **Tạo cấu trúc**: Tạo folder `docs/learning/{topic-name}/`
4. **Tạo các files**:
   - README.md (tổng quan)
   - 01-introduction.md đến 10-interview-prep.md
   - exercises/ (beginner, intermediate, advanced)
   - projects/ (mini projects với solution)
   - cheatsheet.md

**Content Requirements:**
- Code examples HOÀN CHỈNH, có thể chạy được
- Mỗi bài tập có ĐỀ BÀI + LỜI GIẢI HOÀN CHỈNH
- Mỗi khái niệm có ít nhất 3 ví dụ thực tế
- Pitfalls có code so sánh ❌ Bad vs ✅ Good
- Core concepts có Glossary và Relationship diagram

**Topic Types:**
- **Coding/Technical** (Go, Python, React): Code examples, output mẫu, projects với source code
- **Domain Knowledge** (ERP, BA, PM): Case studies, screenshots, configuration examples, trial links

**Important Notes:**
- Định nghĩa khái niệm TRƯỚC KHI sử dụng
- Mỗi chương có Prerequisites và Relationship diagram
- Final Validation Checklist trước khi hoàn thành

Start by asking for the topic and current level.
