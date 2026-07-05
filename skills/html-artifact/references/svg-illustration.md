# Minh họa SVG inline (svg-illustration)

## Khi nào dùng

- Cần minh họa một khái niệm trừu tượng (hàng đợi job, retry/backoff, fan-out/fan-in, kiến trúc…) bằng hình vẽ dạng flat-design, không phải ảnh chụp hay icon có sẵn.
- Minh họa sẽ dùng làm header/banner cho tài liệu, hoặc cần export riêng thành file `.svg` độc lập để dùng chỗ khác.
- Muốn một bộ hình có cùng phong cách (palette, độ dày nét, bo góc) lặp lại nhất quán qua nhiều minh họa trong cùng bộ tài liệu.
- Chọn loại khác nếu: đang vẽ luồng quyết định nhiều bước có rẽ nhánh → `flowchart`; cần biểu đồ dữ liệu (số liệu, trục, chuỗi) thay vì minh họa khái niệm → xem `dataviz` skill riêng, không thuộc bộ này.

## Cấu trúc trang

1. **Header** (bắt buộc) — `<h1>` nêu tên bộ minh họa, `.lead` mô tả kích thước chuẩn + phong cách vẽ (vd "fill phẳng, nét 1.5–2px, khóa palette"), dòng `.meta` ghi kích thước px và định dạng xuất.
2. **Mỗi minh họa trong `<figure>`** (bắt buộc, lặp lại N lần) — `.canvas` bọc SVG, `figcaption` bên dưới gồm tiêu đề + mô tả ngữ cảnh dùng (dùng cho trang nào) + nút tải xuống riêng.
3. **Nút tải SVG độc lập** (tùy chọn nhưng khuyến khích) — serialize chính SVG đó thành file `.svg` tải về được, không phụ thuộc phần còn lại của trang.
4. **Dải palette tham chiếu** (bắt buộc) — lưới swatch cuối trang liệt kê đúng các mã hex đã dùng trong minh họa, để người đọc/tái sử dụng biết chính xác token nào.
5. **Ghi chú quy tắc vẽ** (bắt buộc) — danh sách gạch đầu dòng ngắn nêu rule chung (độ dày nét theo ngữ cảnh, bo góc cố định, cỡ chữ theo loại nhãn, ý nghĩa màu nhấn).

## Pattern đặc thù

### viewBox convention: khung cố định lặp lại cho cả bộ

Mọi minh họa trong cùng bộ dùng chung kích thước và `viewBox` (vd `width="720" height="320" viewBox="0 0 720 320"`) để khi đặt cạnh nhau trong tài liệu, chúng đồng bộ tỷ lệ. `<svg>` khai báo đủ `xmlns="http://www.w3.org/2000/svg"` — bắt buộc phải có để file tải riêng ra vẫn tự mở được như một `.svg` hợp lệ, không phụ thuộc HTML bao quanh.

### Màu: hardcode hex trực tiếp, KHÔNG dùng `var()`

Đây là điểm khác biệt quan trọng so với phần còn lại của trang: CSS custom property (`var(--clay)`) không "đi theo" khi SVG bị serialize và tải về như file độc lập (file tải về sẽ không còn `:root` chứa biến đó). Vì vậy mọi `fill`/`stroke` trong minh họa đều ghi thẳng mã hex (`fill="#D97757"`, `stroke="#141413"`) — không tham chiếu biến CSS của trang, dù bảng màu vẫn là cùng một hệ token (ivory/slate/clay/olive/oat/gray). Dải palette cuối trang tồn tại chính là để giữ "nguồn sự thật" cho các mã hex đó ở một nơi.

### Text trong SVG: `<style>` riêng bên trong từng `<svg>`

Mỗi SVG tự khai `<defs><style>.m {...} .s {...}</style></defs>` định nghĩa class font riêng (`.m` = mono 11px cho nhãn trong hộp, `.s` = sans 12px màu gray-500 cho chú thích ngoài hộp) — không dùng `<style>` ở `<head>` trang, vì lý do tương tự màu: SVG tải riêng ra phải tự đứng được, không phụ thuộc stylesheet ngoài.

### Kỹ thuật tạo chiều sâu: layer phẳng, không gradient/shadow

Không dùng gradient hay drop-shadow — độ sâu/phân cấp thể hiện qua:

- **Độ dày nét**: `stroke-width="1.5"` cho hộp trung tính, `"2"` cho container được nhấn mạnh (đang chạy, đang focus).
- **Fill theo trạng thái**: `gray-150 (#F0EEE6)` = mặc định/chờ, `clay (#D97757)` = đang được focus/xử lý, `olive (#788C5D)` = thành công/hoàn tất, `oat (#E3DACC)` = container trung tính nhưng nổi bật hơn nền.
- **Bo góc cố định**: mọi rect dùng `rx="10"` — nhất quán toàn bộ bộ minh họa, không đổi theo từng hình.
- Trạng thái động (fail/success/thời gian chờ) vẽ bằng ký hiệu tối giản: dấu `x` bằng hai `<line>` chéo nhau, dấu check bằng `<path>` gấp khúc, cung nét đứt (`stroke-dasharray="4 4"`) biểu diễn khoảng chờ/backoff.

### Mũi tên: `<marker>` đơn giản, không phân nhiều màu như flowchart

Vì mỗi minh họa chỉ có một luồng ý nghĩa (không rẽ nhánh thành công/lỗi như flowchart), chỉ cần một `<marker>` màu xám trung tính dùng lại cho mọi mũi tên trong cùng hình.

### Nút tải xuống: serialize chính node SVG

```js
const svg = document.getElementById("ill-queue");
const src = new XMLSerializer().serializeToString(svg);
const blob = new Blob([src], { type: "image/svg+xml;charset=utf-8" });
const url = URL.createObjectURL(blob);
```

Đây là lý do mọi thứ (màu, font class, xmlns) phải nằm trong chính thẻ `<svg>` — nếu để ở CSS trang ngoài, file tải về sẽ mất hết style.

### Skeleton SVG tối giản (hộp + nhãn + xuống dòng chú thích)

```html
<svg
  xmlns="http://www.w3.org/2000/svg"
  width="360"
  height="160"
  viewBox="0 0 360 160"
>
  <defs>
    <style>
      .m {
        font-family: ui-monospace, "SF Mono", Menlo, monospace;
        font-size: 11px;
      }
      .s {
        font-family: system-ui, sans-serif;
        font-size: 12px;
      }
    </style>
  </defs>
  <rect width="360" height="160" fill="#FAF9F5" />
  <rect
    x="40"
    y="40"
    width="100"
    height="70"
    rx="10"
    fill="#F0EEE6"
    stroke="#3D3D3A"
    stroke-width="1.5"
  />
  <text x="90" y="80" text-anchor="middle" class="m" fill="#3D3D3A">job</text>
  <text x="40" y="130" class="s" fill="#87867F">chú thích ngắn</text>
</svg>
```

## Checklist nội dung

- [ ] Tất cả minh họa trong bộ dùng chung `viewBox`/kích thước, không lệch tỷ lệ giữa các hình.
- [ ] Màu là hex hardcode trong SVG, không phải `var(--token)` — vì SVG cần tải rời được như file độc lập.
- [ ] Có `xmlns` trên thẻ `<svg>` để file export đứng riêng vẫn hợp lệ.
- [ ] Bo góc, độ dày nét, cỡ chữ nhất quán theo đúng một bộ rule trong toàn minh họa (không tự do đổi mỗi hình một kiểu).
- [ ] Có dải palette cuối trang liệt kê đúng mã hex đã dùng, khớp 100% với những gì xuất hiện trong SVG.
- [ ] Mỗi minh họa có chú thích ngữ cảnh dùng (dùng ở đâu, cho mục nào) chứ không chỉ có hình trơ.
- [ ] Nếu có nút tải, SVG phải tự chứa đủ style/font-class/màu để mở độc lập vẫn đúng như trong trang.

## Example đầy đủ

- `/Users/kyantran/Documents/Development/Vault/html-effectiveness/10-svg-illustrations.html` — ba minh họa 720×320 (hàng đợi job/FIFO, retry với backoff cấp số nhân, fan-out/fan-in), mỗi cái tải riêng được, kèm dải palette và ghi chú quy tắc vẽ.

Nếu file không tồn tại (repo đã di chuyển), bỏ qua — phần chưng cất ở trên là đủ.
