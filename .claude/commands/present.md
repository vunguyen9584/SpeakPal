---
description: Tạo slide presentation từ nội dung kỹ thuật hoặc giải pháp
---

Execute the presentation creation workflow following the steps in `.agent/workflows/present.md`.

**Workflow Overview:**

1. **Thu thập thông tin**:
   - Nội dung chính (paste text, link file, hoặc mô tả)
   - Đối tượng (Technical team / Manager / Khách hàng / Mixed)
   - Thời lượng (5/10/15/30 phút)
   - Ngôn ngữ trình bày (BẮT BUỘC nhất quán)
   - Mục tiêu và phong cách
2. **Phân tích và cấu trúc**: Key messages, story flow, số slide tối thiểu
3. **Tạo file output**: `docs/Presentations/[tên]-slides.md`
4. **Tạo log** (nếu có AI decisions)
5. **Review và xác nhận**: Hỏi người dùng điều chỉnh

**Slide Design Principles:**
- Một ý chính/slide
- Quy tắc 6x6: Tối đa 6 bullets, mỗi bullet tối đa 6 từ
- Visual > Text
- Flow logic tự nhiên

**Language Rules:**
- MỘT ngôn ngữ duy nhất cho toàn bộ slides
- Ngoại lệ: Tên API, Class, Table, Package giữ nguyên tiếng Anh

**For Technical Presentations:**
- BẮT BUỘC có Sequence/Flow Diagrams (Mermaid)
- Code snippets phải có ngữ cảnh (file path, giải thích)
- Before/After Comparison cho changes

Start by asking about the content and audience.
