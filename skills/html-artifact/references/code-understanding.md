# Bản đồ hiểu code (code-understanding)

## Khi nào dùng

- Onboard vào một codebase lạ hoặc một subsystem chưa quen, cần nắm kiến trúc + luồng chạy trước khi đọc raw source.
- Giải thích một vùng code (auth, payment, caching…) trước khi sửa, để người review hoặc teammate khác cùng hiểu bối cảnh.
- Bàn giao (handoff) một phần hệ thống cho người khác — cần chỉ rõ file nào quan trọng, đọc từ đâu, và bẫy nào cần tránh.
- Trả lời câu hỏi "request/data đi qua đâu" bằng một sơ đồ kèm walkthrough từng bước có trích dẫn dòng code thật.
- Chọn loại khác nếu: đang so sánh nhiều cách viết code khác nhau → `code-approaches`; đang bàn giao thẩm mỹ/giao diện → `design-directions`; cần lộ trình các bước triển khai sắp tới (chưa tồn tại) → `implementation-plan`; câu hỏi mở kiểu "còn gì chưa rõ" → `unknowns-toolkit`.

## Cấu trúc trang

1. **Header** (bắt buộc) — dòng nhỏ nêu tên repo/khu vực đang nói tới, `<h1>` nêu đúng luồng/subsystem, đoạn tóm tắt 3-5 câu nêu bản chất kiến trúc (trust boundary, single writer, pattern chính) bằng `<code>` cho tên hàm/bảng thật.
2. **Sơ đồ đường đi** (bắt buộc) — SVG flow diagram vẽ các thành phần dạng box nối bằng mũi tên, box liên quan tới bước quan trọng nhất được tô nổi (hot).
3. **Walkthrough callstack** (bắt buộc) — danh sách bước đánh số, mỗi bước gắn với box tương ứng trong sơ đồ qua vị trí và màu, có file:dòng cụ thể, mô tả ngắn, và snippet code thật gấp lại được.
4. **Sidebar — file quan trọng** (bắt buộc) — danh sách đường dẫn file thật kèm vai trò 1 dòng, để người đọc biết bắt đầu từ đâu.
5. **Sidebar — lưu ý/gotchas** (tùy chọn nhưng nên có) — các bẫy ngầm không thấy được nếu chỉ đọc code tuyến tính (cache theo process, timezone, thứ tự kiểm tra…).
6. **Script accordion** (tùy chọn) — chỉ cho phép mở một snippet tại một thời điểm để walkthrough không bị rối mắt.

## Pattern đặc thù

### 1. Sơ đồ SVG với box "hot" liên kết sang walkthrough

Box trong sơ đồ và badge của bước tương ứng trong walkthrough dùng chung class `.hot` (cùng màu clay) — người đọc lướt mắt từ sơ đồ sang bước giải thích mà không cần đọc lại tên.

```css
.flow .box {
  fill: #fff;
  stroke: var(--gray-300);
  stroke-width: 1.5;
}
.flow .box.hot {
  fill: rgba(217, 119, 87, 0.1);
  stroke: var(--clay);
}
.step.hot .badge {
  background: rgba(217, 119, 87, 0.14);
  border-color: var(--clay);
  color: var(--clay);
}
```

```html
<rect class="box hot" x="460" y="40" width="180" height="64" rx="10"></rect>
<text x="550" y="68" text-anchor="middle">verifyToken()</text>
<text class="sub" x="550" y="84" text-anchor="middle">middleware/auth.ts</text>
```

### 2. Bước walkthrough với file:dòng + snippet gấp lại

Mỗi bước neo vào một vị trí thật (`path:dòng-đầu-dòng-cuối`) trước khi giải thích — người đọc luôn biết đang nói về đoạn code cụ thể nào, không phải mô tả chung chung.

```css
.step {
  display: grid;
  grid-template-columns: 44px 1fr;
  gap: 18px;
  padding: 20px 0;
  border-bottom: 1.5px solid var(--gray-150);
}
.step-loc {
  font-family: var(--mono);
  font-size: 13px;
  color: var(--slate);
}
.step-loc .range {
  color: var(--gray-500);
}
```

```html
<div class="step hot">
  <div class="badge">3</div>
  <div class="step-body">
    <div class="step-loc">
      src/middleware/auth.ts<span class="range"> :14-31</span>
    </div>
    <p>Đây là trust boundary. ...</p>
  </div>
</div>
```

### 3. Snippet code thật, gấp lại bằng `<details>`

Dùng `<details class="snippet">` thay vì hiện hết code — walkthrough đọc lướt nhanh, chỉ mở snippet khi cần xác minh dòng chính xác. Tô màu bằng span ngữ nghĩa tối thiểu (`.kw`, `.str`, `.dim`), không mô phỏng highlighter đầy đủ.

```css
details.snippet summary {
  list-style: none;
  cursor: pointer;
  font-family: var(--mono);
  font-size: 12.5px;
  color: var(--gray-500);
}
details.snippet summary::before {
  content: "▸";
  font-size: 10px;
  transition: transform 0.15s ease;
}
details.snippet[open] summary::before {
  transform: rotate(90deg);
}
pre.code {
  background: var(--slate);
  color: #e8e6dc;
  font-family: var(--mono);
  border-radius: 8px;
  padding: 14px 16px;
  overflow-x: auto;
}
```

```html
<details class="snippet">
  <summary>xem source</summary>
  <pre
    class="code"
  ><span class="kw">export async function</span> verifyToken(req, res, next) {
  <span class="kw">const</span> raw = req.signedCookies[<span class="str">'fw_sid'</span>];
  ...
}</pre>
</details>
```

### 4. Danh sách "file quan trọng" trong sidebar

Không phải bảng — là list path + vai trò 1 dòng, sticky trong sidebar để luôn thấy khi cuộn walkthrough. Path dùng mono, break-all vì path dài.

```css
.key-files {
  list-style: none;
  padding: 0;
}
.key-files li {
  margin-bottom: 12px;
}
.key-files .path {
  font-family: var(--mono);
  font-size: 12px;
  color: var(--slate);
  display: block;
  word-break: break-all;
}
.key-files .desc {
  font-size: 12.5px;
  color: var(--gray-500);
}
```

```html
<ul class="key-files">
  <li>
    <span class="path">src/middleware/auth.ts</span>
    <span class="desc">Điểm vào duy nhất cho request authentication.</span>
  </li>
</ul>
```

### 5. Hộp "lưu ý" (gotchas) viền clay

Tách hẳn khỏi panel file quan trọng bằng viền + nền clay nhạt — báo hiệu đây là rủi ro ngầm (cache per-process, thứ tự kiểm tra, kiểu dữ liệu…), không phải thông tin trung tính.

```css
.gotchas {
  border: 1.5px solid var(--clay);
  border-radius: 12px;
  background: rgba(217, 119, 87, 0.06);
  padding: 18px 20px;
}
.gotchas li {
  position: relative;
  padding-left: 16px;
  font-size: 13px;
}
.gotchas li::before {
  content: "";
  position: absolute;
  left: 0;
  top: 8px;
  width: 5px;
  height: 5px;
  background: var(--clay);
  border-radius: 2px;
}
```

### 6. JS: chỉ mở một snippet tại một thời điểm

Accordion tối giản — không cần framework, chỉ đóng các `<details>` khác khi một cái được mở, để trang không phình dài khi người đọc mở lần lượt nhiều snippet.

```js
var snippets = document.querySelectorAll("details.snippet");
snippets.forEach(function (d) {
  d.addEventListener("toggle", function () {
    if (!d.open) return;
    snippets.forEach(function (other) {
      if (other !== d) other.open = false;
    });
  });
});
```

## Checklist nội dung

- [ ] Mọi đường dẫn file trong sơ đồ, walkthrough và sidebar là đường dẫn thật trong repo, không phải placeholder kiểu `src/foo.ts`.
- [ ] Mỗi snippet code là code thật lấy từ file đang mô tả (có thể rút gọn) — không phải pseudocode.
- [ ] Có đúng một entry point rõ ràng ở bước 1 của walkthrough (nơi luồng bắt đầu), không nhảy giữa chừng.
- [ ] Sidebar "file quan trọng" đủ để người đọc biết bắt đầu đọc code từ đâu nếu họ đóng artifact lại và mở editor.
- [ ] Bước nào là trust boundary / single writer / điểm quyết định quan trọng nhất được đánh dấu `hot` nhất quán giữa sơ đồ và walkthrough.
- [ ] Mỗi bước walkthrough có file:dòng cụ thể (không chỉ tên file), khớp với snippet đi kèm.
- [ ] Gotchas nêu rủi ro thật (race condition, cache theo process, kiểu dữ liệu…), không phải nhận xét hiển nhiên.

## Example đầy đủ

- `/Users/kyantran/Documents/Development/Vault/html-effectiveness/04-code-understanding.html` — luồng authentication dựa trên session cookie trong `acme/web`, từ `AuthProvider` phía client qua middleware `verifyToken()` tới `SessionStore` và bảng `sessions`, kèm sơ đồ SVG, walkthrough 5 bước có snippet thật, và ghi chú về cache LRU theo process.

Nếu file không tồn tại (repo đã di chuyển), bỏ qua — phần chưng cất ở trên là đủ.
