# Bộ công cụ unknowns

Cả 5 biến thể phục vụ một mục đích: **lộ ra điều người dùng chưa biết trước khi họ quyết định** — trước khi code (blindspot, brainstorm, interview), khi thuyết phục người khác (pitch), hoặc sau khi code xong nhưng trước khi merge (quiz). Điểm chung về hình thức: prompt card ở đầu (nhờ copy), rồi một artifact có khung "Claude đã tạo ra". Điểm khác nhau là _cơ chế tương tác_ — đó là phần cần chưng cất kỹ nhất, vì nó quyết định artifact có buộc người dùng thực sự dừng lại và xử lý thông tin hay chỉ là một trang đọc lướt.

## Khi nào dùng

| Biến thể             | Khi nào dùng                                                                                                   |
| -------------------- | -------------------------------------------------------------------------------------------------------------- |
| Quét điểm mù         | Sắp đụng vào code/module lạ — cần lộ mìn, lịch sử, convention ngầm, concept thiếu trước khi viết dòng đầu tiên |
| Brainstorm can thiệp | Vấn đề còn mơ hồ ("user churn"), muốn thấy _toàn bộ_ không gian lựa chọn (rẻ → tham vọng) trước khi chốt hướng |
| Phỏng vấn            | Yêu cầu mơ hồ, cần Claude hỏi ngược từng câu để chốt kiến trúc trước khi viết code, thay vì đoán               |
| Doc thuyết phục      | Đã build xong, cần gói thành một doc thuyết phục người khác duyệt/ship, trả lời trước các câu hỏi họ sẽ hỏi    |
| Quiz trước khi merge | Đã có diff/report, muốn _verify_ người review thật sự hiểu — không chỉ lướt qua — trước khi bấm merge          |

**Chọn loại khác nếu…** cần so sánh nhiều cách implement cùng một tính năng → `code-approaches`; cần chọn hướng thẩm mỹ UI → `design-directions`; cần breakdown công việc theo bước thực thi → `implementation-plan`; cần minh hoạ luồng hệ thống/dữ liệu → `flowchart`; cần giải thích một khái niệm trừu tượng cho người mới → `concept-explainer`; cần giải thích code _đã tồn tại_ (không phải điều chưa biết, mà là điều cần hiểu) → `code-understanding`; cần minh hoạ trực quan bằng hình vẽ → `svg-illustration`.

## Biến thể: Quét điểm mù

**Cấu trúc trang**: prompt card → stat strip đếm tổng số mìn/convention/concept/lịch sử → danh sách bs-card, mỗi cái là một điểm mù cụ thể → final-card gộp toàn bộ prompt-chip thành một prompt cải thiện duy nhất.

**Pattern đặc thù**: mỗi `bs-card` gắn một badge phân loại — 4 loại cố định: mìn (nguy hiểm ngay), lịch sử (đã có người thử và fail), convention (quy ước ngầm chưa viết ở đâu), concept thiếu (mô hình mental cần biết trước). Trong card có khối `bite` (border-left màu clay) chuyên trả lời "vì sao nguy hiểm" — tách biệt khỏi mô tả sự kiện, không gộp chung đoạn văn. Cuối mỗi card là một `prompt-chip` riêng — một câu ràng buộc ngắn có thể copy độc lập, không phải cả trang. Tương tác duy nhất là copy-to-clipboard qua event delegation trên `data-copy-target`, không có state phức tạp:

```js
document.addEventListener("click", (e) => {
  const btn = e.target.closest("button[data-copy-target]");
  if (!btn) return;
  const el = document.getElementById(btn.dataset.copyTarget);
  navigator.clipboard.writeText(el.textContent.trim());
});
```

Giá trị nằm ở nội dung (mỗi điểm mù phải cụ thể, trỏ đúng file/dòng, giải thích hậu quả thật), không ở cơ chế — đừng thêm tương tác thừa (không cần checkbox, không cần chấm điểm).

Mỗi card thêm một dòng **liên hệ đời thật** (`analogy`) ngay sau khối "vì sao nguy hiểm" — một câu ví von tình huống ngoài đời để hậu quả trở nên trực quan với cả người không đọc code. Mỗi loại badge có một khuôn ví von tự nhiên:

| Badge         | Khuôn liên hệ đời thật (ví dụ)                                                                                             |
| ------------- | -------------------------------------------------------------------------------------------------------------------------- |
| Mìn           | "Như đào móng nhà mà không hỏi sơ đồ ống gas — cuốc trúng là nổ ngay, không có cảnh báo trước."                            |
| Lịch sử       | "Như mua căn nhà từng chống thấm 2 lần vẫn dột — chủ cũ đã thử cách bạn đang định làm, và nó thất bại."                    |
| Convention    | "Như luật ngầm của khu phố: không ai cấm đậu xe trước cổng nhà ông Ba, nhưng ai cũng biết là đừng."                        |
| Concept thiếu | "Như lái xe số sàn lần đầu mà chưa ai giải thích chân côn — thao tác đúng thứ tự vẫn chết máy vì thiếu mô hình trong đầu." |

```css
.analogy {
  font-family: var(--serif);
  font-style: italic;
  font-size: 13.5px;
  color: var(--gray-500);
  padding-left: 14px;
  border-left: 1.5px solid var(--oat);
}
.analogy::before {
  content: "Ngoài đời: ";
  font-style: normal;
  font-family: var(--mono);
  font-size: 10.5px;
  text-transform: uppercase;
}
```

```html
<p class="analogy">
  Như đào móng mà không hỏi sơ đồ ống gas — cuốc trúng là nổ ngay.
</p>
```

Câu ví von phải khớp _cơ chế_ gây nguy hiểm của điểm mù đó (bất ngờ, đã-thử-và-fail, luật ngầm, thiếu mô hình), không phải ví von chung chung cho có.

**Checklist nội dung**:

- [ ] Mỗi điểm mù gắn đúng 1 trong 4 badge (mìn/lịch sử/convention/concept), không badge tùy tiện
- [ ] Có ô "vấn đề bạn yêu cầu gì" vs "thực tế bạn đang bước vào" ngay đầu để tạo tương phản kỳ vọng
- [ ] Mỗi card có "vì sao nguy hiểm" tách riêng khỏi mô tả sự kiện
- [ ] Mỗi card có dòng liên hệ đời thật khớp đúng cơ chế nguy hiểm của loại badge, không ví von chung chung
- [ ] Mỗi card có prompt-chip copy riêng — không bắt người dùng tự gộp
- [ ] Kết bằng final prompt gộp tất cả ràng buộc theo đúng thứ tự nên làm

## Biến thể: Brainstorm can thiệp

**Cấu trúc trang**: prompt card → thanh spectrum (dải từ "ship chiều nay" đến "cược cả quý", các dot đại diện từng phương án) → danh sách iv-card theo effort tăng dần → sticky reply bar dưới cùng tổng hợp lựa chọn.

**Pattern đặc thù**: đây là biến thể duy nhất có **vote qua checkbox + compose reply sống**. Mỗi `iv-card` có effort badge (S/M/L/XL) và một checkbox "cái này ăn khớp"; tick checkbox thì card đổi viền màu clay và dot tương ứng trên spectrum sáng lên — hai UI đồng bộ cùng một state. Sticky bar dưới cùng luôn hiện số lượng đã chọn và một câu reply được soạn sẵn, sẵn sàng copy-paste vào chat:

```js
const boxes = [...document.querySelectorAll(".resonate input")];
function update() {
  const picked = boxes
    .filter((b) => b.checked)
    .map((b) => +b.dataset.n)
    .sort((a, b) => a - b);
  boxes.forEach((b) => {
    document
      .getElementById("iv" + b.dataset.n)
      .classList.toggle("checked", b.checked);
  });
  rbCopy.disabled = picked.length === 0;
  rbReply.textContent = picked.length
    ? `Những cái này ăn khớp: ${picked.map((n) => "#" + n).join(", ")} — bắt đầu với #${picked[0]}`
    : "Tick các can thiệp ăn khớp…";
}
boxes.forEach((b) => b.addEventListener("change", update));
```

Dot trên spectrum chỉ làm một việc: click thì `scrollIntoView` tới card tương ứng — điều hướng, không phải chọn.

**Checklist nội dung**:

- [ ] 8-10 phương án trải đều effort S → XL, không dồn cụm một mức
- [ ] Mỗi phương án ghi rõ "tìm thấy trong code" (bằng chứng cụ thể: file, TODO, flag tắt) — không phải ý tưởng suông
- [ ] Mỗi phương án có dòng "tác động" riêng, tách khỏi mô tả
- [ ] Checkbox + sticky reply bar hoạt động, không chỉ trang trí
- [ ] Effort thấp nhất ưu tiên là "nối dây" cái đã có sẵn, không phải xây mới

## Biến thể: Phỏng vấn

**Cấu trúc trang**: prompt card → artifact hai cột: rail trái (danh sách câu hỏi, tô theo "bán kính ảnh hưởng" — kiến trúc/data/ux/hoàn thiện) + stage phải (một câu hỏi tại một thời điểm) → sau câu cuối, chuyển sang bảng tóm tắt quyết định + prompt follow-up sinh tự động.

**Pattern đặc thù**: wizard tuần tự, chỉ hiện **một câu hỏi mỗi lần**, chọn một option-card thì tự động chuyển sang câu kế (không cần nút "tiếp"), có input "khác" cho câu trả lời tự do. Rail bên trái là progress indicator kiêm nav — câu đã trả lời bấm được để quay lại sửa, câu chưa trả lời thì khoá (`tabindex="-1"`). Cốt lõi là state machine đơn giản:

```js
let current = 0;
const answers = Array(QUESTIONS.length).fill(null);
function go(idx) {
  current = idx;
  renderRail();
  current >= QUESTIONS.length ? renderSummary() : renderQuestion();
}
function pick(optText, isCustom) {
  answers[current] = { text: optText, custom: isCustom };
  renderRail();
  setTimeout(() => go(current + 1), 240); // tự động sang câu kế
}
```

Ở summary, mỗi hàng có nút "sửa" gọi lại `go(i)` — quay về đúng câu đó mà không mất các câu đã trả lời khác. Prompt follow-up được build bằng cách nối `topic: answer` theo thứ tự, đánh dấu câu nào là tự diễn đạt để Claude biết hỏi lại nếu mơ hồ.

**Checklist nội dung**:

- [ ] Mỗi câu hỏi có dòng "vì sao câu này quan trọng" (blast radius) — không hỏi cho có
- [ ] Câu hỏi sắp theo mức ảnh hưởng giảm dần: kiến trúc/data trước, UX/hoàn thiện sau
- [ ] Option luôn có mô tả hệ quả ngắn, không chỉ nhãn
- [ ] Luôn có lựa chọn "khác" — không ép chọn trong danh sách đóng
- [ ] Summary cho sửa lại từng câu, và sinh prompt follow-up gộp toàn bộ quyết định

## Biến thể: Doc thuyết phục

**Cấu trúc trang**: prompt card → doc artifact: demo mô phỏng (01) → lời thuyết phục ngắn (02) → objections dạng accordion (03) → bảng spec tóm tắt (04) → rủi ro & ai cần duyệt gì (05) → dòng kết luận kêu gọi hành động.

**Pattern đặc thù**: đây là biến thể _trình diễn_, không có input người dùng — tương tác chính là một **demo animation tự lặp** dựng bằng chuỗi `setTimeout`, mô phỏng luồng sản phẩm thật (chọn annotation → export → progress bar → toast xong) rồi tự replay sau vài giây, có nút "xem lại" thủ công:

```js
function play() {
  reset();
  [0, 1, 2].forEach((i, idx) =>
    setTimeout(() => selectItem(i), 500 + idx * 450),
  );
  setTimeout(() => armExportButton(), 2000);
  setTimeout(() => showProgress(), 2300);
  setTimeout(() => showToast(), 4300);
  setTimeout(play, 7000); // tự lặp
}
document.getElementById("replayBtn").addEventListener("click", play);
play();
```

Phần objections dùng `<details>/<summary>` thuần HTML (không cần JS) — mỗi câu trả lời có link neo (`href="#spec"`) trỏ về đúng dòng trong bảng spec bên dưới, biến "tôi hứa" thành "đây là bằng chứng, bấm vào xem". Card "cần gì từ bạn" liệt kê từng approver theo tên + vai trò + việc cụ thể họ cần duyệt — không dùng câu chung "cần mọi người duyệt".

**Checklist nội dung**:

- [ ] Demo mô phỏng đúng luồng sản phẩm thật, không phải hình minh hoạ tĩnh
- [ ] Mỗi objection là câu hỏi thật reviewer sẽ hỏi, có số liệu/link cụ thể, không trả lời chung chung
- [ ] Bảng spec có cột "tham chiếu" neo tới đúng mục objection dùng nó
- [ ] Rủi ro liệt kê cả "worst case" và cách rollback — không chỉ mặt tốt
- [ ] Mỗi approver có tên riêng + việc cụ thể cần họ duyệt, không phải danh sách chung

## Biến thể: Quiz trước khi merge

**Cấu trúc trang**: prompt card → report artifact: stat chip (file/dòng đổi) → mental model before/after → các khối "behavior không hiển nhiên" (là gì/vì sao/ở đâu) → callout "dựa vào" hạ tầng có sẵn → quiz 6 câu → kết quả pass (checklist merge) hoặc fail (link quay lại phần cần đọc).

**Pattern đặc thù**: quiz chấm điểm ngay tại chỗ, **mỗi câu chỉ được chọn một lần** (khoá option sau khi chọn), phản hồi tức thì kèm trích dẫn nguyên văn từ đúng đoạn report phía trên và link neo quay lại đó. Đạt hết mới được xem là "được phép merge"; sai câu nào thì bị dẫn thẳng về phần liên quan để đọc lại — quiz vì vậy gắn chặt với nội dung phía trên, không phải trắc nghiệm rời rạc:

```js
function onAnswer(qi, oi) {
  if (answers[qi] !== null) return; // chỉ một lần thử
  const right = oi === QS[qi].correct;
  answers[qi] = right;
  showFeedback(qi, right, QS[qi].excerpt, QS[qi].anchor); // trích + link neo
  if (answers.every((a) => a !== null)) finish();
}
function finish() {
  const score = answers.filter(Boolean).length;
  score === QS.length ? showPassChecklist() : showFailLinks(missedAnchors());
}
```

Nút "reset quiz & thử lại" build lại toàn bộ DOM câu hỏi từ đầu, không chỉ xoá đáp án đã chọn — tránh học vẹt thứ tự.

**Checklist nội dung**:

- [ ] Mỗi câu quiz là một tình huống thực tế ("pod bị OOM-kill thì sao"), không phải hỏi định nghĩa
- [ ] Đáp án sai có excerpt trích đúng từ report + link neo, không chỉ nói "sai rồi"
- [ ] Pass toàn bộ mới hiện checklist merge; thiếu 1 câu vẫn phải đọc lại, không có "gần đủ"
- [ ] Có khối "behavior không hiển nhiên" tách khỏi mental model — đây là phần diff không tự nói lên được
- [ ] Có callout riêng cho phần hạ tầng có sẵn mà change này âm thầm phụ thuộc vào

## Example đầy đủ

- `/Users/kyantran/Documents/Development/Vault/html-effectiveness/unknowns/01-blindspot-pass.html` — quét điểm mù trước khi thêm SSO provider vào module auth lạ
- `/Users/kyantran/Documents/Development/Vault/html-effectiveness/unknowns/05-churn-brainstorm.html` — brainstorm 10 phương án chống churn onboarding, từ rẻ nhất đến tham vọng nhất
- `/Users/kyantran/Documents/Development/Vault/html-effectiveness/unknowns/06-interview.html` — phỏng vấn 7 câu để chốt kiến trúc tính năng export annotation
- `/Users/kyantran/Documents/Development/Vault/html-effectiveness/unknowns/10-pitch-doc.html` — doc thuyết phục ship tính năng export annotation, mở đầu bằng demo
- `/Users/kyantran/Documents/Development/Vault/html-effectiveness/unknowns/11-change-quiz.html` — report + quiz 6 câu trước khi merge diff export clip

Nếu file không tồn tại (repo đã di chuyển), bỏ qua — phần chưng cất ở trên là đủ.
