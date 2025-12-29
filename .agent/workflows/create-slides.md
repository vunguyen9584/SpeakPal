---
description: Tạo HTML Presentation từ Markdown hướng dẫn
---

# Workflow: Create Slides - Tạo HTML Presentation từ Markdown

## Mục đích

Chuyển đổi file markdown slides (output từ workflow `/present`) thành trang HTML trình bày chuyên nghiệp với animations, navigation, và responsive design.

---

## Bước 1: Xác định input

Hỏi người dùng:

1. **File nguồn**: "Đường dẫn đến file markdown slides? (VD: docs/Presentations/my-slides.md)"
2. **Thư mục output**: "Thư mục lưu file HTML? (mặc định: cùng thư mục với file nguồn)"
3. **Theme**: "Chọn theme cho slides?"

   - [ ] Dark (nền tối, chữ sáng - chuyên nghiệp)
   - [ ] Light (nền sáng, chữ tối - thân thiện)
   - [ ] Gradient (nền gradient hiện đại)
   - [ ] Corporate (phong cách doanh nghiệp)
   - [ ] AI tự quyết dựa trên nội dung

4. **Tính năng bổ sung** (tùy chọn):
   - [ ] Speaker notes panel (bật/tắt bằng phím 'S')
   - [ ] Progress bar
   - [ ] Slide number
   - [ ] Timer
   - [ ] Touch support cho mobile

---

## Bước 2: Parse file markdown

Đọc file markdown và extract thông tin cho mỗi slide:

```
Mỗi slide được đánh dấu bởi: ## Slide [số]: [Tiêu đề]

Extract:
- slideNumber: số thứ tự
- title: tiêu đề slide
- purpose: mục đích (từ ### Mục đích)
- layout: layout type (từ ### Layout)
- content: nội dung chính (từ ### Nội dung)
- visual: thông tin visual (từ ### Visual element)
- speakerNotes: ghi chú (từ ### Speaker Notes)
```

---

## Bước 3: Tạo file HTML

Tạo file HTML với cấu trúc sau:

### 3.1. HTML Structure

```html
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>[Tên Presentation]</title>
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link
      href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
      rel="stylesheet"
    />
    <style>
      /* CSS sẽ được inject ở đây */
    </style>
  </head>
  <body>
    <div class="presentation">
      <div class="slides-container">
        <!-- Slides sẽ được generate ở đây -->
      </div>

      <!-- Navigation -->
      <div class="nav-controls">
        <button class="nav-btn prev" onclick="prevSlide()">‹</button>
        <button class="nav-btn next" onclick="nextSlide()">›</button>
      </div>

      <!-- Progress Bar -->
      <div class="progress-bar">
        <div class="progress-fill"></div>
      </div>

      <!-- Slide Counter -->
      <div class="slide-counter">
        <span class="current">1</span> / <span class="total">14</span>
      </div>

      <!-- Speaker Notes Panel (hidden by default) -->
      <div class="speaker-notes-panel">
        <div class="speaker-notes-content"></div>
      </div>
    </div>

    <script>
      /* JavaScript sẽ được inject ở đây */
    </script>
  </body>
</html>
```

### 3.2. CSS Requirements

```css
/* Base Styles */
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}
body {
  font-family: "Inter", sans-serif;
  overflow: hidden;
}

/* Slide Container */
.presentation {
  width: 100vw;
  height: 100vh;
  position: relative;
}

.slides-container {
  width: 100%;
  height: 100%;
  position: relative;
}

/* Individual Slide */
.slide {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  padding: 60px 80px;
  opacity: 0;
  transform: translateX(100%);
  transition: all 0.5s cubic-bezier(0.25, 0.46, 0.45, 0.94);
}

.slide.active {
  opacity: 1;
  transform: translateX(0);
}

.slide.prev {
  transform: translateX(-100%);
}

/* Typography */
.slide-title {
  font-size: 3rem;
  font-weight: 700;
  margin-bottom: 2rem;
  text-align: center;
}

.slide-subtitle {
  font-size: 1.5rem;
  font-weight: 400;
  opacity: 0.8;
  margin-bottom: 3rem;
}

.slide-content {
  font-size: 1.25rem;
  line-height: 1.8;
  max-width: 900px;
}

.slide-content ul {
  list-style: none;
  padding-left: 0;
}

.slide-content li {
  padding: 0.5rem 0;
  padding-left: 2rem;
  position: relative;
}

.slide-content li::before {
  content: "→";
  position: absolute;
  left: 0;
  color: var(--accent-color);
}

/* Highlight Boxes */
.highlight-box {
  background: var(--highlight-bg);
  border-left: 4px solid var(--accent-color);
  padding: 1.5rem 2rem;
  margin: 1rem 0;
  border-radius: 0 8px 8px 0;
}

.warning-box {
  background: rgba(255, 59, 48, 0.1);
  border-left: 4px solid #ff3b30;
  padding: 1.5rem 2rem;
  margin: 1rem 0;
  border-radius: 0 8px 8px 0;
}

.success-box {
  background: rgba(52, 199, 89, 0.1);
  border-left: 4px solid #34c759;
  padding: 1.5rem 2rem;
  margin: 1rem 0;
  border-radius: 0 8px 8px 0;
}

/* Navigation */
.nav-controls {
  position: fixed;
  bottom: 30px;
  left: 50%;
  transform: translateX(-50%);
  display: flex;
  gap: 20px;
  z-index: 100;
}

.nav-btn {
  width: 50px;
  height: 50px;
  border-radius: 50%;
  border: none;
  background: var(--nav-bg);
  color: var(--nav-color);
  font-size: 1.5rem;
  cursor: pointer;
  transition: all 0.3s ease;
  backdrop-filter: blur(10px);
}

.nav-btn:hover {
  transform: scale(1.1);
  background: var(--accent-color);
}

/* Progress Bar */
.progress-bar {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 4px;
  background: rgba(255, 255, 255, 0.1);
  z-index: 100;
}

.progress-fill {
  height: 100%;
  background: var(--accent-color);
  transition: width 0.3s ease;
}

/* Slide Counter */
.slide-counter {
  position: fixed;
  bottom: 30px;
  right: 40px;
  font-size: 1rem;
  opacity: 0.6;
  z-index: 100;
}

/* Speaker Notes */
.speaker-notes-panel {
  position: fixed;
  bottom: 0;
  left: 0;
  width: 100%;
  height: 200px;
  background: rgba(0, 0, 0, 0.95);
  color: #fff;
  padding: 20px 40px;
  transform: translateY(100%);
  transition: transform 0.3s ease;
  z-index: 200;
  overflow-y: auto;
}

.speaker-notes-panel.visible {
  transform: translateY(0);
}

/* Animations */
@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.slide.active .slide-title {
  animation: fadeInUp 0.6s ease forwards;
}

.slide.active .slide-content {
  animation: fadeInUp 0.6s ease 0.2s forwards;
  opacity: 0;
}

.slide.active .slide-content li {
  animation: fadeInUp 0.4s ease forwards;
  opacity: 0;
}

.slide.active .slide-content li:nth-child(1) {
  animation-delay: 0.3s;
}
.slide.active .slide-content li:nth-child(2) {
  animation-delay: 0.4s;
}
.slide.active .slide-content li:nth-child(3) {
  animation-delay: 0.5s;
}
.slide.active .slide-content li:nth-child(4) {
  animation-delay: 0.6s;
}
.slide.active .slide-content li:nth-child(5) {
  animation-delay: 0.7s;
}

/* Theme Variables */
/* Dark Theme */
.theme-dark {
  --bg-color: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
  --text-color: #ffffff;
  --text-muted: rgba(255, 255, 255, 0.7);
  --accent-color: #00d4ff;
  --highlight-bg: rgba(0, 212, 255, 0.1);
  --nav-bg: rgba(255, 255, 255, 0.1);
  --nav-color: #ffffff;
}

/* Light Theme */
.theme-light {
  --bg-color: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
  --text-color: #1a1a2e;
  --text-muted: rgba(0, 0, 0, 0.6);
  --accent-color: #667eea;
  --highlight-bg: rgba(102, 126, 234, 0.1);
  --nav-bg: rgba(0, 0, 0, 0.1);
  --nav-color: #1a1a2e;
}

/* Gradient Theme */
.theme-gradient {
  --bg-color: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  --text-color: #ffffff;
  --text-muted: rgba(255, 255, 255, 0.8);
  --accent-color: #ffd700;
  --highlight-bg: rgba(255, 215, 0, 0.15);
  --nav-bg: rgba(255, 255, 255, 0.2);
  --nav-color: #ffffff;
}

/* Corporate Theme */
.theme-corporate {
  --bg-color: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
  --text-color: #ecf0f1;
  --text-muted: rgba(236, 240, 241, 0.7);
  --accent-color: #3498db;
  --highlight-bg: rgba(52, 152, 219, 0.15);
  --nav-bg: rgba(255, 255, 255, 0.1);
  --nav-color: #ecf0f1;
}

.presentation {
  background: var(--bg-color);
  color: var(--text-color);
}

/* Responsive */
@media (max-width: 768px) {
  .slide {
    padding: 40px 30px;
  }

  .slide-title {
    font-size: 2rem;
  }

  .slide-content {
    font-size: 1rem;
  }

  .nav-controls {
    bottom: 20px;
  }
}
```

### 3.3. JavaScript Requirements

```javascript
// Slide Navigation
let currentSlide = 0;
const slides = document.querySelectorAll('.slide');
const totalSlides = slides.length;
const speakerNotes = [...]; // Array of speaker notes per slide

function showSlide(index) {
    // Boundary check
    if (index < 0) index = 0;
    if (index >= totalSlides) index = totalSlides - 1;

    // Update slides
    slides.forEach((slide, i) => {
        slide.classList.remove('active', 'prev');
        if (i === index) {
            slide.classList.add('active');
        } else if (i < index) {
            slide.classList.add('prev');
        }
    });

    currentSlide = index;

    // Update progress
    updateProgress();

    // Update counter
    updateCounter();

    // Update speaker notes
    updateSpeakerNotes();
}

function nextSlide() {
    showSlide(currentSlide + 1);
}

function prevSlide() {
    showSlide(currentSlide - 1);
}

function updateProgress() {
    const progress = ((currentSlide + 1) / totalSlides) * 100;
    document.querySelector('.progress-fill').style.width = progress + '%';
}

function updateCounter() {
    document.querySelector('.slide-counter .current').textContent = currentSlide + 1;
}

function updateSpeakerNotes() {
    const panel = document.querySelector('.speaker-notes-content');
    panel.textContent = speakerNotes[currentSlide] || '';
}

// Keyboard Navigation
document.addEventListener('keydown', (e) => {
    switch(e.key) {
        case 'ArrowRight':
        case 'Space':
        case 'PageDown':
            nextSlide();
            break;
        case 'ArrowLeft':
        case 'PageUp':
            prevSlide();
            break;
        case 's':
        case 'S':
            toggleSpeakerNotes();
            break;
        case 'f':
        case 'F':
            toggleFullscreen();
            break;
        case 'Home':
            showSlide(0);
            break;
        case 'End':
            showSlide(totalSlides - 1);
            break;
    }
});

// Touch Support
let touchStartX = 0;
document.addEventListener('touchstart', (e) => {
    touchStartX = e.touches[0].clientX;
});

document.addEventListener('touchend', (e) => {
    const touchEndX = e.changedTouches[0].clientX;
    const diff = touchStartX - touchEndX;

    if (Math.abs(diff) > 50) {
        if (diff > 0) nextSlide();
        else prevSlide();
    }
});

// Speaker Notes Toggle
function toggleSpeakerNotes() {
    document.querySelector('.speaker-notes-panel').classList.toggle('visible');
}

// Fullscreen Toggle
function toggleFullscreen() {
    if (!document.fullscreenElement) {
        document.documentElement.requestFullscreen();
    } else {
        document.exitFullscreen();
    }
}

// Initialize
showSlide(0);
```

---

## Bước 4: Generate slides HTML

Với mỗi slide từ markdown, tạo HTML element:

```html
<div class="slide" data-slide="[số]">
  <h1 class="slide-title">[Tiêu đề]</h1>
  <p class="slide-subtitle">[Subtitle nếu có]</p>
  <div class="slide-content">[Nội dung được format thành HTML]</div>
</div>
```

### Mapping layout types:

| Layout trong MD | HTML Structure                    |
| --------------- | --------------------------------- |
| Full-text       | Centered content, no split        |
| Split           | Two columns using flexbox         |
| Diagram         | Content + placeholder for diagram |
| Comparison      | Side-by-side boxes                |
| Alert style     | Warning box styling               |

### Mapping visual elements:

| Visual type | Implementation                    |
| ----------- | --------------------------------- |
| Icon        | Use emoji hoặc SVG icon           |
| Diagram     | Placeholder box với mô tả         |
| Chart       | Placeholder hoặc simple CSS chart |
| Comparison  | Comparison boxes                  |

---

## Bước 5: Tạo file output

Lưu file HTML vào thư mục đã chỉ định với tên:
`[tên-file-gốc].html`

VD: `upwork-how-to-start-slides.md` → `upwork-how-to-start-slides.html`

---

## Bước 6: Test và Preview

// turbo
Mở file HTML trong browser để preview:

```powershell
Start-Process "[đường-dẫn-file-html]"
```

---

## Keyboard Shortcuts (trong presentation)

| Phím                       | Chức năng             |
| -------------------------- | --------------------- |
| `→` / `Space` / `PageDown` | Slide tiếp theo       |
| `←` / `PageUp`             | Slide trước           |
| `S`                        | Bật/tắt Speaker Notes |
| `F`                        | Toggle Fullscreen     |
| `Home`                     | Về slide đầu          |
| `End`                      | Đến slide cuối        |

---

## Output Structure

```
[thư-mục-output]/
└── [tên]-slides.html     # File HTML presentation hoàn chỉnh
```

---

## Ví dụ sử dụng

**Input:**

```
/create-slides docs/Presentations/upwork-how-to-start-slides.md
```

**Output:**

```
docs/Presentations/upwork-how-to-start-slides.html
```

---

## ⚠️ QUY TẮC QUAN TRỌNG: KHÔNG Sử Dụng ASCII Art Diagrams

### Vấn đề

ASCII art diagrams sử dụng các ký tự box drawing (─ │ ┌ ┐ └ ┘ ├ ┤) sẽ bị **hiển thị lệch** khi:

- Trộn với ký tự CJK (tiếng Nhật, Trung, Hàn) - do full-width vs half-width
- Font không hoàn toàn monospace
- Kích thước màn hình khác nhau

### ❌ KHÔNG LÀM

```
┌─────────────────────────┐
│  【基本情報】           │
│   行番号・B票番号       │
└─────────────────────────┘
```

### ✅ THAY VÀO ĐÓ - Sử dụng HTML/CSS Components

**1. Structure Diagram → Dùng styled nested divs:**

```html
<div class="structure-diagram">
  <div class="diagram-header">📋 B票管理表</div>
  <div class="diagram-section">
    <div class="section-icon">📊</div>
    <div class="section-content">
      <div class="section-title">基本情報</div>
      <div class="section-items">行番号・B票番号・ステータス</div>
    </div>
  </div>
</div>
```

**2. Flow Diagram → Dùng flexbox với arrows:**

```html
<div class="flow-diagram">
  <div class="flow-step">📝 起票</div>
  <div class="flow-arrow">→</div>
  <div class="flow-step">🔍 対策中</div>
  <div class="flow-arrow">→</div>
  <div class="flow-step">✅ 完了</div>
</div>
```

**3. Hierarchy Diagram → Dùng nested list với CSS:**

```html
<div class="hierarchy">
  <div class="hierarchy-item level-0">Parent Item</div>
  <div class="hierarchy-item level-1">├─ Child 1</div>
  <div class="hierarchy-item level-1">├─ Child 2</div>
  <div class="hierarchy-item level-1">└─ Child 3</div>
</div>
```

**4. Comparison → Dùng grid layout:**

```html
<div class="comparison-grid">
  <div class="compare-item bad">
    <div class="compare-label">❌ 悪い例</div>
    <div class="compare-content">...</div>
  </div>
  <div class="compare-item good">
    <div class="compare-label">✅ 良い例</div>
    <div class="compare-content">...</div>
  </div>
</div>
```

### CSS Classes Cần Có

```css
/* Structure Diagram */
.structure-diagram {
  background: var(--card-bg);
  border: 1px solid var(--border-color);
  border-radius: 12px;
  overflow: hidden;
}

.diagram-header {
  background: rgba(52, 152, 219, 0.2);
  padding: 0.8rem 1rem;
  font-weight: 600;
  text-align: center;
  border-bottom: 1px solid var(--border-color);
}

.diagram-section {
  display: flex;
  align-items: flex-start;
  padding: 0.8rem 1rem;
  border-bottom: 1px solid var(--border-color);
}

.diagram-section:last-child {
  border-bottom: none;
}

.section-icon {
  font-size: 1.2rem;
  margin-right: 0.8rem;
}

.section-title {
  font-weight: 600;
  color: var(--accent-color);
  margin-bottom: 0.3rem;
}

.section-items {
  font-size: 0.9rem;
  opacity: 0.8;
}

/* Flow Diagram */
.flow-diagram {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  padding: 1rem;
  flex-wrap: wrap;
}

.flow-step {
  background: var(--card-bg);
  border: 1px solid var(--accent-color);
  border-radius: 8px;
  padding: 0.5rem 1rem;
  text-align: center;
  font-size: 0.9rem;
}

.flow-arrow {
  color: var(--accent-color);
  font-size: 1.2rem;
  font-weight: bold;
}

/* Hierarchy */
.hierarchy {
  font-family: inherit;
  font-size: 0.9rem;
}

.hierarchy-item {
  padding: 0.3rem 0;
}

.hierarchy-item.level-1 {
  padding-left: 1.5rem;
}

.hierarchy-item.level-2 {
  padding-left: 3rem;
}

/* Comparison Grid */
.comparison-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1rem;
}

.compare-item {
  border-radius: 8px;
  padding: 1rem;
}

.compare-item.bad {
  background: rgba(231, 76, 60, 0.1);
  border: 1px solid rgba(231, 76, 60, 0.3);
}

.compare-item.good {
  background: rgba(46, 204, 113, 0.1);
  border: 1px solid rgba(46, 204, 113, 0.3);
}

.compare-label {
  font-weight: 600;
  margin-bottom: 0.5rem;
}
```

---

## Lưu ý

1. **Single file**: Tất cả CSS và JS được inline trong 1 file HTML duy nhất để dễ share
2. **No dependencies**: Chỉ cần Google Fonts (optional), không cần thư viện JS
3. **Offline capable**: Có thể xem offline sau khi load fonts
4. **Print friendly**: Có thể Ctrl+P để in slides (optional CSS)
5. **Mobile responsive**: Hoạt động tốt trên mobile với touch navigation
6. **KHÔNG DÙNG ASCII ART**: Luôn thay thế ASCII diagrams bằng HTML/CSS styled components
