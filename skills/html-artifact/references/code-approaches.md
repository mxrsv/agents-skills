# So sánh cách tiếp cận code (code-approaches)

## Khi nào dùng

- User hỏi kiểu "cho tôi vài cách khác nhau để làm X" và muốn so sánh trade-off trước khi chọn.
- Cần quyết định giữa nhiều pattern/hook/thư viện cho cùng một bài toán cụ thể, có ngữ cảnh codebase rõ (tên hàm, file, convention thật).
- Có ít nhất 2-3 approach thực sự khác biệt về cách viết code — không phải chỉ khác style hay tên biến.
- Chọn loại khác nếu: đang so sánh **giao diện/thẩm mỹ** thay vì code → `design-directions`; chỉ cần giải thích code đã tồn tại (không so sánh nhiều lối viết) → `code-understanding`; đã chốt 1 approach và cần lộ trình triển khai từng bước → `implementation-plan`.

## Cấu trúc trang

1. **Header + prompt-box** (bắt buộc) — eyebrow ngắn nêu bối cảnh dự án, `<h1>` nêu đúng bài toán, prompt-box nhắc lại nguyên văn yêu cầu để người đọc đối chiếu artifact có đúng câu hỏi không.
2. **Lưới approach** (bắt buộc) — 3 cột (1 cột khi hẹp), mỗi cột là một `<article class="approach">` độc lập, tự chứa đủ thông tin để đọc rời từng cái mà không cần cuộn qua lại.
3. **Mỗi approach card** (bắt buộc) gồm: tiêu đề có số thứ tự + mô tả 1 dòng → code panel → bảng tradeoffs (ưu/nhược) → dải chip chỉ số ngắn gọn.
4. **Khối khuyến nghị cuối trang** (bắt buộc) — nêu rõ chọn approach nào, vì sao đúng với bối cảnh hiện tại của codebase, và điều kiện nào sẽ đổi ý.

## Pattern đặc thù

### 1. Lưới approach đánh số

Card không phải panel chung chung — có `.num` badge để mắt lướt nhanh "phương án mấy", và card widths bằng nhau kể cả khi nội dung lệch (dùng `flex-direction: column` cho card, không set height cố định).

```css
.approaches {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 28px;
}
.approach {
  background: #fff;
  border: 1.5px solid var(--gray-300);
  border-radius: 12px;
  padding: 24px;
  display: flex;
  flex-direction: column;
  gap: 20px;
}
.approach-head .num {
  font-family: var(--mono);
  font-size: 12px;
  background: var(--oat);
  padding: 2px 8px;
  border-radius: 8px;
  margin-right: 8px;
}
```

```html
<article class="approach">
  <header class="approach-head">
    <h2><span class="num">02</span>Custom useDebounce hook</h2>
    <p>Tách timer thành hook dùng chung trong src/hooks/.</p>
  </header>
  <!-- code, tradeoffs, chips bên dưới -->
</article>
```

### 2. Code panel tô màu bằng span ngữ nghĩa

Không dùng highlighter thật — tự bọc token bằng `<span class="kw">`/`.str`/`.cm`/`.fn` để code đọc được ngay trong artifact tĩnh, không cần JS. Nền tối để code nổi bật khỏi nền ivory của trang.

```css
.code {
  background: var(--slate);
  border-radius: 12px;
  padding: 18px 20px;
  overflow-x: auto;
}
.code pre {
  font-family: var(--mono);
  font-size: 12.5px;
  line-height: 1.65;
  color: #e8e6de;
}
.code .kw {
  color: var(--clay);
} /* keyword */
.code .str {
  color: var(--olive);
} /* string literal */
.code .cm {
  color: var(--gray-500);
} /* comment */
.code .fn {
  color: #c9b98a;
} /* identifier/function */
```

Chỉ tô các token có ý nghĩa phân biệt (keyword, string, comment, identifier) — đừng cố mô phỏng highlighter đầy đủ, sẽ rối và sai màu ở edge case.

### 3. Bảng tradeoffs 2 cột với chấm màu ưu/nhược

Mỗi hàng là 1 cặp ưu-nhược tương ứng theo cùng một khía cạnh (bundle, testability, reuse…) — không liệt kê ưu/nhược rời rạc không đối xứng.

```css
.tradeoffs {
  border: 1.5px solid var(--gray-300);
  border-radius: 8px;
  overflow: hidden;
  font-size: 13px;
}
.tradeoffs .row {
  display: grid;
  grid-template-columns: 1fr 1fr;
}
.tradeoffs .row + .row {
  border-top: 1.5px solid var(--gray-300);
}
.tradeoffs .cell {
  padding: 10px 14px;
}
.tradeoffs .cell:first-child {
  border-right: 1.5px solid var(--gray-300);
}
.tradeoffs .pro::before,
.tradeoffs .con::before {
  content: "";
  display: inline-block;
  width: 6px;
  height: 6px;
  border-radius: 50%;
  margin-right: 8px;
}
.tradeoffs .pro::before {
  background: var(--olive);
}
.tradeoffs .con::before {
  background: var(--clay);
}
```

### 4. Chip chỉ số footer

Dải chip ngắn tóm tắt các trục so sánh định lượng/định tính chung cho mọi approach (bundle size, testability, khả năng tái sử dụng, SSR-safe…) — cho phép liếc so sánh chéo giữa 3 card mà không cần đọc lại bảng tradeoffs.

```html
<div class="chips">
  <span class="chip">Bundle: <strong>+0.2 kb</strong></span>
  <span class="chip">Testability: <strong>cao</strong></span>
</div>
```

### 5. Khối khuyến nghị (reco) nhấn viền trái

Tách khỏi lưới card bằng border trái màu clay + bo góc chỉ 3 phía, để mắt nhận ra ngay đây là kết luận chứ không phải approach thứ 4.

```css
.reco {
  border-left: 4px solid var(--clay);
  background: #fff;
  border-radius: 0 12px 12px 0;
  padding: 24px 28px;
  max-width: 860px;
}
```

## Checklist nội dung

- [ ] Mỗi approach dùng tên hàm/biến/file thật khớp convention của codebase đang bàn — không đặt tên generic kiểu `doStuff`.
- [ ] Code snippet đủ ngắn để đọc trong 5-10 giây nhưng đủ để thấy sự khác biệt cốt lõi giữa các approach (không cắt mất phần quyết định).
- [ ] Mỗi dòng tradeoff phải là sự đánh đổi thật, không phải ưu/nhược hiển nhiên/vô nghĩa (ví dụ tránh "dễ đọc" ở mọi approach).
- [ ] Chip chỉ số phải nhất quán trục so sánh giữa các approach (cùng bộ tiêu chí, không đổi thang đo giữa các card).
- [ ] Có đúng một khuyến nghị cuối trang, nêu rõ lý do gắn với bối cảnh cụ thể (không phải "approach nào cũng được").
- [ ] Khuyến nghị nêu điều kiện khi nào nên đổi sang approach khác, không chỉ chọn 1 rồi dừng.

## Example đầy đủ

- `/Users/kyantran/Documents/Development/Vault/html-effectiveness/01-exploration-code-approaches.html` — ba cách triển khai debounced search (inline useEffect, custom hook, thư viện ngoài) kèm bảng tradeoff, chip chỉ số và khuyến nghị cuối trang.

Nếu file không tồn tại (repo đã di chuyển), bỏ qua — phần chưng cất ở trên là đủ.
