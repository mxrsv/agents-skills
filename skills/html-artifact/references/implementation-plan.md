# Implementation plan

## Khi nào dùng

- Trình bày kế hoạch triển khai một tính năng để người khác (hoặc chính bạn sau này) duyệt trước khi code.
- Ghi lại các quyết định thiết kế có trade-off (data model, API shape) cần approve, tách rõ khỏi phần "cơ học" không cần bàn.
- Giữ nhật ký triển khai khi build đang chạy: mỗi lần lệch plan hoặc phát hiện bất ngờ được chốt lại ngay, không rơi vào scrollback.
- Bàn giao plan cho người implement khác, kèm mockup/diagram đủ để họ bắt tay ngay không cần hỏi lại.
- Chọn loại khác nếu: chỉ so sánh vài hướng code chưa chốt hướng nào → dùng `code-approaches`; chỉ chốt một quyết định thiết kế đơn lẻ không cần lịch trình → `design-directions`; chỉ cần sơ đồ luồng xử lý không kèm nhiều text → `flowchart`.

## Cấu trúc trang

1. Header + prompt box (bắt buộc) — eyebrow, `h1`, khối prompt gốc.
2. Summary strip / chips (bắt buộc) — vài số tổng quan: công sức ước tính, số file/package đụng tới, số bảng mới, tên feature flag.
3. Mốc triển khai — milestone timeline có trạng thái done/pending (bắt buộc cho plan đầy đủ) — hoặc danh sách tuần tự có ước tính giờ/ngày (biến thể gọn hơn, xem mục B).
4. Luồng dữ liệu / diagram (tùy chọn) — SVG box-and-arrow, chỉ thêm khi luồng thực sự cần hình để hiểu.
5. Mockup UI (tùy chọn) — khối preview tĩnh minh hoạ giao diện, không cần pixel-final.
6. Code chính (bắt buộc nếu plan đụng code) — 1-2 file quan trọng nhất, có thể kèm margin note đánh số bên cạnh dòng được flag.
7. Rủi ro & cách giảm thiểu (bắt buộc) — bảng rủi ro có mức độ nghiêm trọng.
8. Câu hỏi mở / quyết định cần người chốt (bắt buộc) — mỗi câu hỏi có chủ sở hữu quyết định và deadline mờ (trước slice nào).

**Biến thể "sắp theo mức độ dễ chỉnh"** (khi muốn reviewer đọc phần quan trọng nhất trước): chia plan thành Phần A (quyết định có thể bị đổi, mỗi lựa chọn có nút xem phương án khác), Phần B (thứ tự build thực tế, không cần bàn), Phần C (việc cơ học, gói trong `<details>` gấp lại mặc định).

**Biến thể "implementation notes" (nhật ký lúc build)**: thay milestone bằng timeline các mốc thời gian thực tế, mỗi entry gắn nhãn loại (khớp plan / lệch plan / phát hiện / cần người quyết), có chip lọc theo loại, và khối tổng hợp "đổi gì ở lần thử sau" ở cuối trang.

## Pattern đặc thù

**1. Mốc triển khai (milestone timeline có trạng thái)** — cột thời gian trái, dot nối bằng line dọc, dot đổi màu khi mốc đã xong.

```css
.milestone {
  display: grid;
  grid-template-columns: 120px 28px 1fr;
  gap: 0 18px;
}
.milestone .dot {
  width: 14px;
  height: 14px;
  border-radius: 50%;
  background: #fff;
  border: 3px solid var(--clay);
}
.milestone .dot.done {
  background: var(--olive);
  border-color: var(--olive);
}
.milestone .line {
  width: 2px;
  flex: 1;
  background: var(--gray-300);
  margin: 4px 0;
}
.milestone:last-child .line {
  display: none;
}
```

```html
<div class="milestone">
  <div class="when">Tuần 1 · T2–T3</div>
  <div class="dot-col">
    <span class="dot done"></span><span class="line"></span>
  </div>
  <div class="body">
    <h3>Schema &amp; API contract</h3>
    <p>…</p>
    <div class="tags"><span class="tag">packages/db</span></div>
  </div>
</div>
```

**2. Bảng rủi ro có mức độ nghiêm trọng** — badge màu theo mức, hàng 3 cột (rủi ro / mức / giảm thiểu), tự xếp dọc trên mobile.

```css
.risks .row {
  display: grid;
  grid-template-columns: 1.6fr 90px 1.6fr;
}
@media (max-width: 780px) {
  .risks .row {
    grid-template-columns: 1fr;
  }
}
.sev {
  font-family: var(--mono);
  font-size: 11px;
  padding: 2px 8px;
  border-radius: 6px;
  font-weight: 600;
}
.sev.high {
  background: #f3d9cc;
  color: #8a3b1e;
}
.sev.med {
  background: var(--oat);
  color: var(--slate);
}
.sev.low {
  background: #e4e9dc;
  color: #4b5c39;
}
```

```html
<div class="risks">
  <div class="row">
    <div class="cell head">Rủi ro</div>
    <div class="cell head">Mức</div>
    <div class="cell head">Giảm thiểu</div>
  </div>
  <div class="row">
    <div class="cell">Trùng realtime append với reconcile temp-id.</div>
    <div class="cell"><span class="sev high">CAO</span></div>
    <div class="cell">Dedupe theo id server gán.</div>
  </div>
</div>
```

**3. Khối quyết định có thể chỉnh + nút xem phương án khác (JS)** — mỗi lựa chọn hiện mặc định phương án plan chọn; bấm nút để lộ phương án thay thế, ẩn phương án đang hiện. Cùng cơ chế có thể đồng bộ đổi cả sơ đồ schema đi kèm (toggle `data-variant`).

```css
[data-variant="main"] .v-alt {
  display: none;
}
[data-variant="alt"] .v-main {
  display: none;
}
.choice-flag {
  font-family: var(--mono);
  font-size: 10.5px;
  background: var(--clay);
  color: #fff;
  border-radius: 6px;
  padding: 3px 8px;
}
button.alt-toggle {
  font-family: var(--mono);
  font-size: 11.5px;
  background: #fff;
  color: var(--clay);
  border: 1.5px solid var(--clay);
  border-radius: 8px;
  padding: 5px 12px;
}
```

```html
<div class="choice-card" data-variant="main" id="c1">
  <div class="choice-head">
    <span class="choice-flag">Lựa chọn ①</span>
    <button class="alt-toggle" onclick="toggleChoice(1)">
      Xem phương án khác →
    </button>
  </div>
  <div class="choice-body">
    <div class="v-main">Plan chọn — snapshot denormalized…</div>
    <div class="v-alt">Phương án khác — live join lúc render…</div>
  </div>
</div>
<script>
  function toggleChoice(n) {
    var card = document.getElementById("c" + n);
    var toAlt = card.getAttribute("data-variant") === "main";
    card.setAttribute("data-variant", toAlt ? "alt" : "main");
    card.querySelector(".alt-toggle").textContent = toAlt
      ? "← Về lựa chọn của plan"
      : "Xem phương án khác →";
  }
</script>
```

**4. Khối lệch plan (deviation block)** — dùng trong implementation notes, 4 hàng cố định: plan nói gì → code cho thấy gì → lựa chọn bảo thủ đã chọn (tô nổi) → điều cần xem lại sau.

```css
.devgrid {
  border: 1.5px solid var(--oat);
  border-left: 3px solid var(--clay);
  border-radius: 10px;
}
.devgrid .row {
  display: grid;
  grid-template-columns: 158px 1fr;
  gap: 12px;
  padding: 9px 14px;
}
.devgrid .row.chosen .k {
  color: var(--olive);
}
.devgrid .row.chosen .v {
  color: var(--slate);
  font-weight: 500;
}
```

```html
<div class="devgrid">
  <div class="row">
    <div class="k">Plan nói gì</div>
    <div class="v">Mọi annotation có frame_ts.</div>
  </div>
  <div class="row">
    <div class="k">Code cho thấy gì</div>
    <div class="v">~12% row null frame_ts.</div>
  </div>
  <div class="row chosen">
    <div class="k">Lựa chọn bảo thủ</div>
    <div class="v">Loại khỏi burn-in, đưa vào CSV sidecar.</div>
  </div>
  <div class="row">
    <div class="k">Xem lại</div>
    <div class="v">Có thể interpolate timestamp sau.</div>
  </div>
</div>
```

**5. Timeline nhật ký có chip lọc theo loại (JS)** — mỗi entry gắn `data-t` (plan/dev/disc/human), node đổi màu theo loại; chip lọc ẩn/hiện entry và cập nhật `rail-first`/`rail-last` để đường nối không thừa ở đầu/cuối danh sách đang lọc.

```css
.entry .node {
  background: var(--gray-300);
}
.entry.t-dev .node {
  background: var(--clay);
}
.entry.t-human .node {
  background: var(--slate);
}
.chip.on {
  background: var(--slate);
  border-color: var(--slate);
  color: var(--ivory);
}
.entry.hidden {
  display: none;
}
```

```js
chip.addEventListener("click", function () {
  chips.forEach((c) => c.classList.remove("on"));
  chip.classList.add("on");
  var f = chip.getAttribute("data-f");
  entries.forEach((e) => {
    var show = f === "all" || e.getAttribute("data-t") === f;
    e.classList.toggle("hidden", !show);
  });
});
```

## Checklist nội dung

- [ ] Mỗi mốc/bước có tiêu chí "xong" rõ ràng (không chỉ tên việc), và gắn package/file bị đụng tới.
- [ ] Trạng thái mốc thể hiện được done vs chưa làm (dot, badge, hoặc timestamp thực tế nếu là nhật ký).
- [ ] Mỗi quyết định có lý do chọn + trade-off của phương án bị bỏ, không chỉ nêu kết luận.
- [ ] Rủi ro nào cũng có phương án giảm thiểu cụ thể, không để trống cột giảm thiểu.
- [ ] Câu hỏi mở nêu rõ ai cần chốt và chốt trước mốc nào — không để lửng "cần bàn thêm".
- [ ] Nếu là nhật ký triển khai: mọi lệch plan chọn phương án bảo thủ và ghi rõ điều cần xem lại, không âm thầm sửa mà không note.
- [ ] Việc cơ học/không cần bàn được gói gọn (ví dụ trong `<details>`), không chiếm chỗ ngang với quyết định thật.

## Example đầy đủ

- `/Users/kyantran/Documents/Development/Vault/html-effectiveness/16-implementation-plan.html` — plan đầy đủ: milestone timeline, sơ đồ luồng dữ liệu SVG, mockup, code chính, bảng rủi ro, câu hỏi mở.
- `/Users/kyantran/Documents/Development/Vault/html-effectiveness/unknowns/08-implementation-plan.html` — biến thể sắp theo mức độ dễ chỉnh: Phần A/B/C, choice card có toggle phương án khác, margin note đánh số cạnh code.
- `/Users/kyantran/Documents/Development/Vault/html-effectiveness/unknowns/09-implementation-notes.html` — biến thể nhật ký lúc build: timeline có chip lọc, khối lệch plan, tổng hợp "đổi gì ở lần thử sau".

Nếu file không tồn tại (repo đã di chuyển), bỏ qua — phần chưng cất ở trên là đủ.
