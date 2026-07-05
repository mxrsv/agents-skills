# Sơ đồ luồng (flowchart)

## Khi nào dùng

- Cần trực quan hóa một chuỗi bước có nhánh rẽ/quyết định (pipeline CI/CD, state machine, quy trình duyệt, luồng xử lý lỗi…) mà văn xuôi khó theo dõi thứ tự và điều kiện rẽ nhánh.
- User muốn bấm vào từng bước để xem chi tiết (code, thời gian chạy, ghi chú) thay vì đọc hết một lượt.
- Có ranh giới rõ giữa các loại bước: bắt đầu/kết thúc, xử lý tuần tự, điểm quyết định (gate), nhánh thành công/thất bại.
- Chọn loại khác nếu: đang minh họa một khái niệm/kiến trúc tĩnh không có luồng rẽ nhánh tuần tự → `svg-illustration`; đang giải thích code đã có sẵn thay vì mô hình hóa quy trình → `code-understanding`; cần lộ trình triển khai theo mốc thời gian (không phải luồng quyết định) → `implementation-plan`.

## Cấu trúc trang

1. **Header** (bắt buộc) — eyebrow ngắn nêu chủ đề, `<h1>` nêu câu hỏi/quy trình đang minh họa, `.lead` 1-2 câu nói rõ sơ đồ vẽ từ nguồn nào (file cấu hình thật, workflow thật) để tăng độ tin cậy.
2. **Layout 2 cột: canvas + side panel** (bắt buộc) — cột chính chứa SVG sơ đồ trong khung `.canvas` có `overflow-x: auto`; cột phụ (`aside`, sticky) hiển thị chi tiết bước đang chọn. Gập thành 1 cột dưới `920px`.
3. **Legend** (bắt buộc) — dải chip nhỏ ngay dưới canvas giải thích ý nghĩa màu/hình dạng node (bước thường, quyết định, kết thúc thành công, nhánh lỗi).
4. **Side panel chi tiết** (bắt buộc) — tiêu đề, dòng meta (loại bước · thời gian), đoạn mô tả, khối `<pre>` code/config liên quan. Cập nhật qua JS khi click node.
5. **Script điều khiển tương tác** (bắt buộc nếu có click-to-detail) — object tra cứu theo key (`data-k`) map sang nội dung panel, toggle class `.active` trên node đang chọn.

## Pattern đặc thù

### Node: vẽ bằng SVG `<g>` chứa `<rect>` hoặc `<path>`

Mỗi bước là một `<g class="node ...">` gắn `data-k="ten-buoc"` để JS tra cứu. Bước xử lý thường và bước bắt đầu/kết thúc dùng `<rect>` (bo góc qua CSS `rx`, bước start/end bo tròn hẳn `rx: 22` để trông như pill). Bước quyết định (gate) dùng `<path>` vẽ hình thoi (`M x,y1 L x2,y2 L x,y3 L x1,y2 Z`) — không có hình thoi SVG dựng sẵn nên phải vẽ tay bằng path.

```css
.node rect {
  fill: #fff;
  stroke: var(--gray-300);
  stroke-width: 1.5;
  rx: 8;
}
.node.term rect {
  fill: var(--gray-150);
  rx: 22;
} /* start/end: pill */
.node.gate path {
  fill: #fff;
  stroke: var(--gray-300);
  stroke-width: 1.5;
} /* decision: diamond */
.node.ok rect {
  fill: rgba(120, 140, 93, 0.12);
  stroke: var(--olive);
} /* thành công */
.node.bad rect {
  fill: rgba(176, 74, 63, 0.1);
  stroke: var(--rust);
} /* nhánh lỗi */
```

### Edge: `<path>` nối tay bằng tọa độ tuyệt đối, không auto-layout

Toàn bộ sơ đồ dùng **tọa độ tay** trong viewBox cố định (ví dụ `0 0 620 920`) — không có engine tự layout. Trục chính là một cột dọc (vd `x=310`), nối bằng đường thẳng `M x,y1 L x,y2`. Nhánh rẽ khỏi trục dùng cubic bezier `C` để bo cong mềm sang cột phụ, ví dụ nhánh lỗi rẽ trái: `M268,294 C190,294 150,294 150,212`. Phân loại nhánh bằng class (`.edge`, `.edge.yes`, `.edge.no`) đổi màu stroke + màu marker tương ứng.

### Mũi tên: `<marker>` riêng cho từng màu edge

SVG marker không kế thừa màu từ `stroke` của path gọi nó — mỗi màu nhánh cần một `<marker>` riêng với `fill` hardcode trong `<defs>`, rồi path trỏ tới đúng id qua `marker-end`.

```html
<marker
  id="arrow"
  viewBox="0 0 10 10"
  refX="9"
  refY="5"
  markerWidth="6"
  markerHeight="6"
  orient="auto-start-reverse"
>
  <path d="M0,0 L10,5 L0,10 z" fill="#87867F" />
</marker>
```

Ba biến thể trong ví dụ: `#arrow` (xám, mặc định), `#arrow-rust` (nhánh lỗi), `#arrow-olive` (nhánh đạt) — mỗi cái là một marker riêng vì marker không đọc được biến CSS.

### Label trên nhánh

`<text class="lbl">` đặt lệch cạnh path (không đặt giữa, tránh đè lên đường), tô màu khớp nhánh (`fill="#B04A3F"` cho nhánh lỗi) để không cần nhìn theo màu đường mới hiểu nhánh nào là gì.

### Responsive: chỉ scroll ngang, không scale nội dung

SVG có `width: 100%; height: auto` để co theo cột, còn khung `.canvas` có `overflow-x: auto` — trên màn hẹp, sơ đồ dài/rộng sẽ **cuộn ngang** trong khung thay vì bị bóp méo hay chữ nhỏ lại quá mức. `viewBox` giữ nguyên tỷ lệ gốc nên node/text luôn giữ kích thước tương đối như thiết kế.

### Tương tác click-to-detail

Mỗi node có `data-k`; JS giữ object tra cứu `DETAIL[key] = { title, meta, body, code }`, click vào node thì toggle `.active` (đổi màu viền sang clay) và đổ nội dung vào panel bên cạnh. Đây là lý do node cần `cursor: pointer` và transition nhẹ khi hover.

### Skeleton SVG tối giản (1 node + 1 edge + arrowhead)

```html
<svg viewBox="0 0 300 200">
  <defs>
    <marker
      id="arrow"
      viewBox="0 0 10 10"
      refX="9"
      refY="5"
      markerWidth="6"
      markerHeight="6"
      orient="auto-start-reverse"
    >
      <path d="M0,0 L10,5 L0,10 z" fill="#87867F" />
    </marker>
  </defs>
  <path
    class="edge"
    d="M150,60 L150,100"
    stroke="#87867F"
    stroke-width="1.5"
    fill="none"
    marker-end="url(#arrow)"
  />
  <g class="node" data-k="step-1">
    <rect
      x="70"
      y="10"
      width="160"
      height="44"
      rx="8"
      fill="#fff"
      stroke="#D1CFC5"
      stroke-width="1.5"
    />
    <text x="150" y="36" text-anchor="middle">Bước 1</text>
  </g>
</svg>
```

## Checklist nội dung

- [ ] Mọi nhánh rẽ (quyết định) có nhãn rõ điều kiện (vd "đạt", "lỗi") — không để mũi tên trần không giải thích rẽ vì sao.
- [ ] Đọc được bố cục tổng thể mà không cần zoom — trục chính thẳng hàng, nhánh phụ không cắt ngang node khác.
- [ ] Có chú giải (legend) map màu/hình dạng sang ý nghĩa (bước thường, quyết định, thành công, lỗi).
- [ ] Mỗi node có thông tin thật (tên job, thời gian chạy, file cấu hình) — không dùng placeholder "Step 1", "Step 2".
- [ ] Nhánh lỗi/rollback luôn có điểm kết thúc rõ ràng, không để cụt giữa chừng.
- [ ] Nếu có click-to-detail, node đang chọn phải có trạng thái active nhận biết được bằng mắt (đổi viền/màu).
- [ ] Sơ đồ scroll ngang được trên viewport hẹp thay vì vỡ layout hoặc chữ bé không đọc nổi.

## Example đầy đủ

- `/Users/kyantran/Documents/Development/Vault/html-effectiveness/13-flowchart-diagram.html` — sơ đồ pipeline deploy `git push` → CI → test → build → canary → promote/rollback, có gate quyết định, nhánh lỗi, và panel chi tiết click-to-detail cho từng bước.

Nếu file không tồn tại (repo đã di chuyển), bỏ qua — phần chưng cất ở trên là đủ.
