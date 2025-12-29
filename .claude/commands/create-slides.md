---
description: Tạo HTML Presentation từ Markdown slides
---

Execute the HTML slide creation workflow following the steps in `.agent/workflows/create-slides.md`.

**Workflow Overview:**

1. **Xác định input**: Hỏi file nguồn markdown, thư mục output, theme, tính năng bổ sung
2. **Parse markdown**: Extract thông tin từ mỗi slide (title, purpose, layout, content, visual, speaker notes)
3. **Tạo file HTML**: Single file với CSS và JS inline
4. **Generate slides HTML**: Map layout types và visual elements
5. **Tạo file output**: `[tên-file-gốc].html`
6. **Preview**: Mở file HTML trong browser

**Available Themes:**
- Dark (nền tối, chữ sáng)
- Light (nền sáng, chữ tối)
- Gradient (nền gradient hiện đại)
- Corporate (phong cách doanh nghiệp)

**Features:**
- Speaker notes panel (phím 'S')
- Progress bar
- Slide number
- Touch support cho mobile
- Keyboard navigation (→←, Space, Home, End, F for fullscreen)

**Important Notes:**
- KHÔNG sử dụng ASCII Art Diagrams - dùng HTML/CSS styled components
- Single file HTML, no dependencies
- Responsive design

Start by asking for the markdown slides file path.
