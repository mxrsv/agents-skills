# Trình bày nhiều hướng thiết kế (design-directions)

## Khi nào dùng

- User chưa có gu thị giác rõ ràng ("không biết mình muốn gì") và cần _thấy_ vài hướng khác hẳn nhau để phản ứng, thay vì tự mô tả thiết kế bằng lời.
- Cần trình bày nhiều biến thể UI (component, empty state, dashboard…) cùng dữ liệu/nội dung, chỉ khác triết lý thiết kế.
- Muốn thu thập phản hồi có cấu trúc (thích gì, bỏ gì) trước khi build bản thật.
- Chọn loại khác nếu: đang so sánh **logic/code** chứ không phải giao diện → `code-approaches`; câu hỏi rộng hơn thẩm mỹ (kiến trúc, phạm vi, dữ liệu còn thiếu…) → `unknowns-toolkit`; chỉ cần một hình minh họa/icon đơn lẻ, không phải nhiều hướng để chọn → `svg-illustration`.

## Cấu trúc trang

1. **Header + prompt-box** (bắt buộc) — nêu bối cảnh và nhắc lại yêu cầu gốc, giống code-approaches.
2. **Toolbar/điều khiển chung** (tùy chọn) — nếu các hướng cần so sánh trên nền sáng/tối hoặc theo biến thể dữ liệu, đặt một control sticky ở đầu trang điều khiển tất cả các khung cùng lúc, không phải từng khung riêng.
3. **Dòng dữ liệu dùng chung** (tùy chọn nhưng nên có khi >2 hướng) — một dòng nhỏ liệt kê rõ dataset/nội dung là bất biến giữa các hướng, để người đọc tin rằng khác biệt duy nhất là thiết kế.
4. **Lưới hoặc chuỗi các hướng** (bắt buộc) — mỗi hướng là một khối độc lập: nhãn hướng, khung render trực tiếp (không phải ảnh chụp), và một dòng lý giải ngắn vì sao hướng này khác.
5. **Cơ chế phản hồi** (tùy chọn, dùng khi muốn thu thập lựa chọn có cấu trúc) — chip/nút "giữ lại"/"bỏ" theo từng hướng, gộp thành một câu trả lời soạn sẵn để user copy-paste ngược lại.

## Pattern đặc thù

### 1. Artboard với tag + rationale (dạng lưới song song)

Dùng khi các hướng độc lập, so sánh cạnh nhau. Mỗi ô có nhãn góc trên trái (không chiếm layout), vùng `.stage` cố định chiều cao để render live, và câu lý giải ngắn bên dưới — không lẫn vào trong khung render.

```css
.artboard {
  background: #fff;
  border: 1.5px solid var(--gray-300);
  border-radius: 12px;
  padding: 20px;
  position: relative;
}
.tag {
  position: absolute;
  top: 14px;
  left: 14px;
  font-family: var(--mono);
  font-size: 11px;
  background: var(--oat);
  padding: 4px 10px;
  border-radius: 8px;
}
.stage {
  height: 280px;
  border-radius: 8px;
  border: 1.5px solid var(--gray-300);
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
}
.rationale {
  margin-top: 16px;
  font-size: 13px;
  color: var(--gray-500);
}
```

### 2. Token cục bộ tự lật sáng/tối theo `.dark`

Mỗi vùng `.stage` khai báo lại token của riêng nó (`--fg`, `--muted`, `--line`, `--panel`) rồi override khi có class `.dark` — các hướng bên trong dùng `var(--fg)` chứ không dùng token global, nên một nút bấm có thể lật toàn bộ lưới cùng lúc.

```css
.stage {
  --fg: var(--slate);
  --muted: var(--gray-500);
  --panel: #fff;
}
.stage.dark {
  --fg: #f0eee6;
  --muted: #9c9a93;
  --panel: #1f1e1b;
}
```

```js
document.getElementById("bg-seg").addEventListener("change", (e) => {
  const dark = e.target.value === "dark";
  document
    .querySelectorAll(".stage")
    .forEach((s) => s.classList.toggle("dark", dark));
});
```

### 3. Khung "browser chrome" quanh mock-up

Khi hướng thiết kế là cả một màn hình sản phẩm (dashboard, trang), bọc nó trong một khung giả trình duyệt (3 chấm + thanh URL giả) thay vì trần trụi — gợi cảm giác "đây là sản phẩm thật sẽ trông thế nào" hơn là component rời rạc.

```css
.frame {
  background: #fff;
  border: 1.5px solid var(--gray-300);
  border-radius: 14px;
  overflow: hidden;
}
.frame-bar {
  display: flex;
  align-items: center;
  gap: 7px;
  padding: 9px 14px;
  border-bottom: 1.5px solid var(--gray-300);
  background: var(--gray-150);
}
.frame-bar .dot {
  width: 9px;
  height: 9px;
  border-radius: 50%;
  background: var(--gray-300);
}
.frame-bar .url {
  font-family: var(--mono);
  font-size: 10.5px;
  color: var(--gray-500);
}
.frame-body {
  overflow-x: auto;
}
```

### 4. Câu tuyên ngôn "hướng này nói gì"

Trước khi render, một dòng in nghiêng nêu triết lý/thái độ của hướng bằng lời thoại giả định — giúp người đọc phản ứng với _ý định_ trước khi bị cuốn vào chi tiết thị giác.

```css
.dir-says {
  font-family: var(--serif);
  font-style: italic;
  font-size: 15px;
  color: var(--gray-700);
}
.dir-says::before {
  content: "Hướng này nói: ";
  font-style: normal;
  font-family: var(--mono);
  font-size: 10.5px;
  text-transform: uppercase;
  color: var(--gray-500);
  margin-right: 6px;
}
```

```html
<p class="dir-says">
  "Hàng đợi review là hệ thống vận hành. Hiện hết, không lãng phí."
</p>
```

### 5. Chip steal/skip gộp thành câu trả lời soạn sẵn

Mỗi hướng có vài chip "giữ lại chi tiết X" / "bỏ chi tiết Y"; bấm chip toggle trạng thái `.on` và một script gộp toàn bộ lựa chọn (hướng đã chọn + steal + skip) thành văn bản sẵn để copy — biến việc phản hồi thành bấm nút thay vì viết brief.

```css
.chip {
  font-family: var(--mono);
  font-size: 11.5px;
  padding: 6px 12px;
  border-radius: 999px;
  border: 1.5px solid var(--gray-300);
  cursor: pointer;
}
.chip.steal.on {
  border-color: var(--olive);
  background: rgba(120, 140, 93, 0.12);
}
.chip.skip.on {
  border-color: var(--clay);
  background: rgba(217, 119, 87, 0.12);
}
.chip.on .k::after {
  content: " ✓";
}
```

Chỉ thêm cơ chế phản hồi (pattern 4-5) khi trang thật sự cần thu thập lựa chọn có cấu trúc; với so sánh đơn giản 2-4 biến thể, artboard + rationale (pattern 1-2) là đủ.

## Checklist nội dung

- [ ] Mỗi hướng render sống bằng HTML/CSS thật (không phải ảnh/mô tả) — người đọc phải thấy được, không phải tưởng tượng.
- [ ] Các hướng dùng chung một bộ dữ liệu/nội dung, chỉ khác thiết kế — nêu rõ dữ liệu chung ở đầu trang nếu có thể gây nghi ngờ.
- [ ] Các hướng thật sự khác triết lý (mật độ, tông, layout), không phải chỉ đổi màu accent của cùng một layout.
- [ ] Mỗi hướng có một câu lý giải ngắn vì sao nó khác — không chỉ dán nhãn A/B/C/D.
- [ ] Nếu có cơ chế phản hồi (steal/skip), câu trả lời soạn sẵn phải đủ cụ thể để dán thẳng vào chat và hành động được.
- [ ] Nếu so sánh sáng/tối hoặc biến thể dữ liệu, dùng một control chung điều khiển tất cả khung — không bắt người đọc tự tưởng tượng phiên bản còn lại.

## Example đầy đủ

- `/Users/kyantran/Documents/Development/Vault/html-effectiveness/02-exploration-visual-designs.html` — bốn hướng thiết kế empty-state, lưới 2 cột artboard với toggle sáng/tối chung điều khiển toàn bộ khung.
- `/Users/kyantran/Documents/Development/Vault/html-effectiveness/unknowns/03-design-directions.html` — bốn hướng dashboard hàng đợi review, dạng chuỗi dọc với khung browser-chrome, câu tuyên ngôn mỗi hướng, và cơ chế chip steal/skip gộp thành câu trả lời soạn sẵn.

Nếu file không tồn tại (repo đã di chuyển), bỏ qua — phần chưng cất ở trên là đủ.
