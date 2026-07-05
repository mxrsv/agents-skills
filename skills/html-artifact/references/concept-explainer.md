# Concept/feature explainer

## Khi nào dùng

- Giải thích một khái niệm/thuật toán/kỹ thuật người đọc chưa biết (consistent hashing, color grading, rate limiting…).
- Tài liệu hoá "tính năng X hoạt động thế nào" trong một codebase cụ thể, có file/dòng thật để trỏ tới.
- So sánh 2 lựa chọn kỹ thuật (A vs B) khi bảng chữ không đủ trực quan.
- Tài liệu onboarding — dạy từ vựng và mô hình tư duy của một lĩnh vực trước khi làm việc thật với nó.

Chọn loại khác nếu: mục tiêu là so sánh nhiều hướng code song song (→ code-approaches), so 3-4 hướng thiết kế UI (→ design-directions), trình bày kế hoạch nhiều bước có thứ tự thi công (→ implementation-plan), hoặc bọc bài giải thích trong khung "dạy tôi điều chưa biết" có prompt-box + reward-prompt ở đầu/cuối (→ unknowns-toolkit).

## Cấu trúc trang

Hai khuôn chính, chọn theo việc bạn đang giải thích **code có thật** hay **khái niệm đứng độc lập**:

**Biến thể 1 — Feature/system walkthrough** (nguồn: `14-research-feature-explainer.html`)

- Sidebar TOC trái, sticky, kèm danh sách "file đã đọc" — (tùy chọn, chỉ cần khi trang dài và có nhiều file tham chiếu)
- Header: eyebrow + h1 + khối TL;DR viền trái màu nhấn — (bắt buộc)
- Thân bài: từng bước dạng `<details>` collapsible, mỗi bước gắn nhãn `file:line` — (bắt buộc nếu giải thích code có thật)
- Khối code/cấu hình mẫu dạng tabs — (tùy chọn)
- Callout mẹo nhanh — (tùy chọn)
- Danh sách "Lưu ý đáng biết" (hiểu nhầm thường gặp) — (bắt buộc)
- FAQ dạng `<dl>` — (tùy chọn)

**Biến thể 2 — Standalone concept teaching** (nguồn: `15-research-concept-explainer.html`; phần lõi giải thích của `unknowns/02`, `unknowns/12` — không tính khung prompt-box/reward-prompt của hai file này, khung đó thuộc unknowns-toolkit)

- Header: eyebrow + h1 + đoạn lead đặt vấn đề bằng câu hỏi cụ thể, có con số — (bắt buộc)
- Diagram/demo tương tác minh hoạ đúng ý tưởng cốt lõi, có slider/nút điều khiển + số liệu đọc sống — (bắt buộc, đây là lý do chọn HTML thay vì markdown)
- Bảng so sánh A-vs-B hoặc khối trước/sau — (bắt buộc)
- Đoạn liên hệ thực tế "bạn sẽ gặp nó ở đâu" — (tùy chọn)
- Glossary/thuật ngữ dạng aside sticky, hover-highlight nối với thuật ngữ trong bài — (khuyến khích nếu nhiều jargon, tùy chọn nếu bài ngắn)

Cả hai biến thể đều dùng chung: eyebrow mono uppercase trên h1, `.tldr`/`.lead` giới hạn `max-width` để dễ đọc, và section heading `h2` đánh dấu mỗi khối ý riêng biệt.

## Pattern đặc thù

### 1. Bước tuần tự bằng `<details>` gắn vị trí file

Mỗi bước là một collapsible mở/đóng độc lập, tiêu đề có nhãn `file:line` căn phải để người đọc biết chính xác nơi cần xem trong code thật.

```css
details {
  border: 1.5px solid var(--gray-300);
  border-radius: 10px;
  background: #fff;
  margin: 14px 0;
  overflow: hidden;
}
summary {
  list-style: none;
  cursor: pointer;
  padding: 14px 16px;
  display: flex;
  align-items: baseline;
  gap: 10px;
  font-family: var(--serif);
  font-size: 16px;
}
summary::-webkit-details-marker {
  display: none;
}
summary::before {
  content: "▸";
  color: var(--clay);
  transition: transform 120ms;
}
details[open] summary::before {
  transform: rotate(90deg);
}
summary .where {
  font-family: var(--mono);
  font-size: 11px;
  color: var(--gray-500);
  margin-left: auto;
}
details .body {
  padding: 0 16px 16px;
}
```

```html
<details open>
  <summary>
    1 · Nhận diện caller <span class="where">middleware/ratelimit.ts:21</span>
  </summary>
  <div class="body"><p>Middleware rút request về bucketKey...</p></div>
</details>
```

### 2. Diagram tương tác (SVG re-render theo slider + readout sống)

Build lại chuỗi SVG mỗi lần slider đổi giá trị, kèm dòng "readout" tính số liệu phái sinh (ví dụ % key di chuyển) — không chỉ hiện lại con số slider.

```css
.demo {
  border: 1.5px solid var(--gray-300);
  border-radius: 14px;
  background: #fff;
  padding: 24px;
}
.demo-grid {
  display: grid;
  grid-template-columns: 320px 1fr;
  gap: 28px;
  align-items: center;
}
svg.diagram {
  display: block;
  width: 100%;
  max-width: 320px;
}
.controls input[type="range"] {
  flex: 1;
  accent-color: var(--clay);
}
.readout {
  border-top: 1px solid var(--gray-300);
  margin-top: 16px;
  padding-top: 14px;
  font-size: 13px;
}
```

```js
function render() {
  ring.innerHTML = buildSvgString(nodes, keys); // vẽ lại toàn bộ SVG từ state
  readout.textContent = `${nodes.length} node · ${moved} key chuyển (${pct}%)`;
}
nSlider.oninput = () => {
  buildNodes(+nSlider.value);
  render();
};
```

```html
<div class="demo">
  <div class="demo-grid">
    <svg class="diagram" id="ring" viewBox="0 0 260 260"></svg>
    <div class="controls">
      <input id="nSlider" type="range" min="2" max="8" value="4" />
      <div class="readout" id="readout">—</div>
    </div>
  </div>
</div>
```

### 3. Khối trước/sau kéo được (split-handle)

Hai lớp SVG chồng nhau, lớp trên bị `clip-path` cắt theo vị trí slider ẩn — người đọc kéo để tự so sánh thay vì đọc mô tả khác biệt.

```css
.frame-wrap {
  position: relative;
  background: var(--slate);
}
.frame-stack {
  position: relative;
  aspect-ratio: 16/9;
  overflow: hidden;
}
#afterLayer {
  position: absolute;
  inset: 0;
}
.split-handle {
  position: absolute;
  top: 0;
  bottom: 0;
  width: 2px;
  background: rgba(250, 249, 245, 0.9);
  pointer-events: none;
}
#splitRange {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  opacity: 0;
  cursor: ew-resize;
  -webkit-appearance: none;
}
.frame-tag {
  position: absolute;
  top: 10px;
  font-family: var(--mono);
  font-size: 10px;
  padding: 3px 8px;
  border-radius: 4px;
  background: rgba(20, 20, 19, 0.55);
  color: #fff;
}
```

```js
splitRange.addEventListener("input", () => {
  const pct = +splitRange.value;
  afterLayer.style.clipPath = `inset(0 0 0 ${pct}%)`;
  splitHandle.style.left = pct + "%";
});
```

```html
<div class="frame-wrap">
  <div class="frame-stack">
    <svg><!-- before --></svg>
    <div id="afterLayer">
      <svg><!-- after --></svg>
    </div>
    <span class="frame-tag before">TRƯỚC</span
    ><span class="frame-tag after">SAU</span>
    <div class="split-handle" id="splitHandle"></div>
    <input type="range" id="splitRange" min="4" max="96" value="42" />
  </div>
</div>
```

### 4. Bảng so sánh A-vs-B

Dùng khi khác biệt là dữ liệu rời rạc (chi phí, độ phức tạp, use case) chứ không cần cảm nhận thị giác — nhẹ hơn split-handle.

```css
table {
  border-collapse: collapse;
  width: 100%;
  max-width: 640px;
  font-size: 13.5px;
}
th,
td {
  text-align: left;
  padding: 10px 12px;
  border-bottom: 1px solid var(--gray-300);
}
th {
  font-family: var(--mono);
  font-size: 11px;
  text-transform: uppercase;
  color: var(--gray-500);
}
td.bad {
  color: var(--rust);
}
td.good {
  color: var(--olive);
}
```

```html
<table>
  <thead>
    <tr>
      <th></th>
      <th>hash mod N</th>
      <th>consistent hashing</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Key di chuyển khi N→N+1</td>
      <td class="bad">~(N−1)/N</td>
      <td class="good">~1/(N+1)</td>
    </tr>
  </tbody>
</table>
```

### 5. Thang mức độ (slider → nhãn định tính)

Khi khái niệm là một _độ_, không phải giá trị chính xác — ánh xạ số sang nhãn ("thấp/vừa/cao") thay vì hiện con số thô, giữ đúng mức trừu tượng người đọc cần.

```css
.sl-row label {
  display: flex;
  justify-content: space-between;
  font-family: var(--mono);
  font-size: 11.5px;
  text-transform: uppercase;
}
.sl-row output {
  color: var(--clay);
  text-transform: none;
}
```

```js
function levelLabel(v) {
  return v < 14 ? "thấp" : v < 32 ? "vừa" : "cao";
}
slider.addEventListener("input", () => {
  output.textContent = levelLabel(+slider.value);
});
```

```html
<div class="sl-row">
  <label for="sSpace">Không gian <output id="oSpace">cao</output></label>
  <input type="range" id="sSpace" min="0" max="50" value="38" />
</div>
```

### 6. Khối hiểu nhầm thường gặp

Danh sách ngắn, mỗi mục mở bằng khẳng định sai phổ biến in đậm rồi sửa lại — đặt gần cuối bài, sau khi cơ chế đã rõ.

```css
ul.gotchas {
  padding-left: 20px;
  max-width: 680px;
}
ul.gotchas li {
  margin-bottom: 8px;
}
ul.gotchas li b {
  color: var(--slate);
}
```

```html
<ul class="gotchas">
  <li>
    <b>Burst ≠ rate.</b> <code>burst</code> là dung lượng bucket; caller idle
    một phút có thể bắn hết burst ngay dù rate thấp.
  </li>
</ul>
```

### 7. Tab chuyển đổi nội dung/code

Nhiều view của cùng một ý (config file / call site / response mẫu) xếp trong một khối, chuyển bằng nút thay vì cuộn.

```css
.tabbar {
  display: flex;
  border-bottom: 1px solid var(--gray-300);
}
.tabbar button.on {
  border-bottom: 2px solid var(--clay);
  margin-bottom: -1px;
}
.tabs pre {
  display: none;
  margin: 0;
  padding: 16px 18px;
  font-family: var(--mono);
  font-size: 12.5px;
}
.tabs pre.on {
  display: block;
}
```

```js
btns.forEach((b) =>
  b.addEventListener("click", () => {
    btns.forEach((x) => x.classList.remove("on"));
    panes.forEach((x) => x.classList.remove("on"));
    b.classList.add("on");
    panes[+b.dataset.t].classList.add("on");
  }),
);
```

```html
<div class="tabs" data-tabs>
  <div class="tabbar">
    <button class="on" data-t="0">limits.yaml</button
    ><button data-t="1">route.ts</button>
  </div>
  <pre class="on">default:\n  rate: 100/min</pre>
  <pre>router.post("/search", rateLimit("search.query"), handler);</pre>
</div>
```

## Checklist nội dung

- [ ] Mở đầu bằng 1-2 câu nêu rõ "vì sao cần biết điều này" trước khi vào chi tiết
- [ ] Mỗi `h2` diễn giải đúng một ý — không gộp hai khái niệm vào chung một block
- [ ] Thuật ngữ mới được định nghĩa ngay lần đầu xuất hiện (dotted underline + tooltip, hoặc glossary aside)
- [ ] Có ít nhất một ví dụ cụ thể/con số thật (file:line, tên biến, số liệu đo) thay vì mô tả trừu tượng
- [ ] Diagram/demo tương tác chỉ thêm khi nó giúp cảm nhận nhanh hơn đọc chữ — không tương tác hoá cho có
- [ ] Khối "hiểu nhầm thường gặp"/"lưu ý" đặt gần cuối bài, sau khi cơ chế đã rõ
- [ ] Nếu giải thích code có thật, luôn trỏ `file:line` — không diễn giải chay không dẫn nguồn
- [ ] Kết bằng liên hệ thực tế: dùng ở đâu, khi nào chọn cách này thay cách khác

## Example đầy đủ

- `/Users/kyantran/Documents/Development/Vault/html-effectiveness/14-research-feature-explainer.html` — feature walkthrough rate limiting: TOC, TL;DR, bước collapsible gắn file:line, tabs config, FAQ.
- `/Users/kyantran/Documents/Development/Vault/html-effectiveness/15-research-concept-explainer.html` — concept độc lập consistent hashing: diagram vòng tròn tương tác, bảng so sánh, glossary hover-highlight.
- `/Users/kyantran/Documents/Development/Vault/html-effectiveness/unknowns/02-color-grading-explainer.html` — dạy color grading: mental-model pipeline, vocab ladder, console before/after kéo được, checklist chuẩn đẹp.
- `/Users/kyantran/Documents/Development/Vault/html-effectiveness/unknowns/12-html-artifact-explainer.html` — dạy khi nào dùng HTML artifact thay markdown: so sánh split-handle với preset đổi nội dung, verdict tính sống từ slider.

Nếu file không tồn tại (repo đã di chuyển), bỏ qua — phần chưng cất ở trên là đủ.
