# WORKFLOW — Bộ skill bootstrap docs cho repo mới

> **Checkpoint** phiên interview-me (2026-07-08, cập nhật 2026-07-09). **Nửa trên = normative đã fold fix (nguồn cho spec); "Design fixes" nửa dưới = rationale/changelog.** Còn chờ: chốt nhóm nên-có + "yes" cuối trước khi viết spec.

## Mục tiêu (confirmed intent)

Bộ **8 skill** cá nhân **thay hẳn BMad** — pipeline docs-bootstrap **tuyến tính + freeze-gated**, kết ở `REQUIREMENTS.md` làm contract giữa planning agent và implementation agent. **Giá trị cốt lõi = KỶ LUẬT (freeze · single-source · traceability), KHÔNG phải elicitation depth.**

> **8 skill = 4 phase** (`/kickoff` `/product` `/architecture` `/requirements`) **+ 4 update/anytime** (`/adr` `/reconcile` `/pivot` + skill luật-code-cho-agent). `/pivot` thêm ở vòng bịt lỗ (3.2/F12).

- **User:** cá nhân, dùng cho **mọi repo mới** từ giờ.
- **Why now:** BMad grill giỏi nhưng _lỏng_ — không ép thứ tự, không freeze, state tản mát, ~40 skill như menu. → giữ _đủ_ phần grill (tái dùng 3 engine), bỏ phần lỏng.
- **Success:** mở repo mới → chạy tuần tự tới `REQUIREMENTS.md` frozen → implementation plan sinh ra _đơn giản & chính xác_. Elicitation **đủ dùng** qua `interview-me` + `grill-with-docs` (2 engine) — **KHÔNG hứa depth ngang BMad** (quyết định B, 2026-07-08: nhường depth, đổi lấy kỷ luật).
- **Trade thành thật (gỡ n15):** nhường BMad ở elicitation _breadth_ (~40 kỹ thuật/persona); thắng ở _discipline_ (BUSINESS-FLOW tách riêng · freeze · ADR immutable). Không khoe suông.

## Luận điểm cốt lõi

Đổ công vào **docs đóng băng chất lượng cao ở đầu** → implementation plan tự trở nên đơn giản & chính xác. Docs là phần khó & đáng đầu tư; plan chỉ là hệ quả rẻ ở phía sau.

## Kiến trúc bộ skill

### Pipeline tuyến tính (4 phase, freeze-gated)

| Cmd             | Phase | Sinh ra                                                                                                                                                                                                    | Gate                   |
| --------------- | ----- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------- |
| `/kickoff`      | 0     | scaffold `docs/`, mở `CONTEXT.md` + `PIPELINE.lock`, capture `PRINCIPLES.md` (non-negotiable repo, bullet-list — **root hash-graph**), research + brief                                                    | freeze `PRINCIPLES.md` |
| `/product`      | 1     | `PRD.md` (intent, journey, scope) + `BUSINESS-FLOW.md` (state, rule, invariant)                                                                                                                            | freeze cả hai          |
| `/architecture` | 2     | hỏi "UI phức tạp không?" → có: `UX-DESIGN.md`; không: ghi dòng skip vào CONTEXT + dồn surface vào architecture. Rồi `ARCHITECTURE.md` + ADR                                                                | freeze                 |
| `/requirements` | 3     | distill FR/NFR atomic đánh số (`FR-xxx`/`NFR-xxx`), mỗi dòng link acceptance criteria. Gap → phân loại (intent→PRD, state/rule→BUSINESS-FLOW), dừng & báo, đẩy sang `/reconcile`. Sạch → `REQUIREMENTS.md` | —                      |

### Update command (chạy bất kỳ lúc nào)

- `/adr <title>` — append file mới vào `decisions/`, đánh số tự động, **immutable** (đổi ý → ADR mới supersedes, không sửa file cũ).
- `/reconcile <target>` — mở **bất kỳ frozen doc** (PRD · BUSINESS-FLOW · ARCHITECTURE) để sửa **gap cục bộ** (framing giữ nguyên), rồi freeze lại → cascade STALE downstream (1.2). Cùng với `/pivot` là **hai đường DUY NHẤT** mở frozen doc.
- `/pivot <phase-đích>` — escape-hatch khi **tiền đề phase trước SAI** (không phải gap cục bộ): archive doc hiện tại → `docs/archive/v{N}/` + pivot-ADR, rewind con trỏ `PIPELINE.lock` về phase đích, downstream tự STALE + re-derive. (Fix 3.2/F12.)

### Đứng cạnh (không trong pipeline tuyến tính)

- Skill **luật-code-cho-agent** → sinh **1 file riêng** (kiểu `CLAUDE.md`/`AGENTS.md`), gọi độc lập.

## Tích hợp hệ sinh thái (upstream / downstream)

Bộ mới **chỉ là tầng upstream**. Downstream (plan + build) đã có superpowers lo — KHÔNG reinvent. Elicitation cũng **tái dùng** skill đang tin dùng, không viết mới.

| Skill đang dùng                                               | Vai trò                                                                                                                                                                                                                                                                                                                |
| ------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `/interview-me`                                               | elicitation engine cho phase greenfield (`/kickoff`, `/product`) — moi intent one-Q-with-guess, lúc chưa có docs                                                                                                                                                                                                       |
| `/grill-with-docs`                                            | **engine tầng LIVING** — grill user (đọc frozen docs _đang có_ làm nền) rồi **đề xuất** edit `CONTEXT.md` (cha ghi). **Inert khi chưa có ≥1 frozen doc** (kickoff/đầu product chủ yếu capture, chưa "challenge"); sức challenge scale theo vật liệu frozen. Cường độ theo phase: xem bảng cuối doc. (Fix 5.3 wording.) |
| ~~`superpowers:brainstorming`~~ **ĐÃ BỎ (2026-07-08)**        | Thủ phạm NEW-2 (hijack→writing-plans) + double-gate + orphan-doc. Chỉ giữ lại kỹ thuật _"propose 2-3 approaches"_ nhét **inline** vào `/product` + `/architecture`, không kéo cả skill.                                                                                                                                |
| `superpowers:writing-plans`                                   | ⬇️ downstream — sinh implementation plan từ `REQUIREMENTS.md` frozen ("plan rất đơn giản")                                                                                                                                                                                                                             |
| `superpowers:executing-plans` + `subagent-driven-development` | ⬇️ downstream-2 — chạy build từ plan                                                                                                                                                                                                                                                                                   |

Lifecycle:

```
[BỘ MỚI — upstream, freeze-gated docs]
/kickoff → /product → /architecture → /requirements → REQUIREMENTS.md (frozen contract)
   ⇧ elicitation: interview-me · grill-with-docs  (brainstorming ĐÃ BỎ)
        │ handoff
        ▼
[SUPERPOWERS — downstream, ĐÃ CÓ, không reinvent]
writing-plans → executing-plans / subagent-driven-development
```

### Nhịp mỗi phase: grill → distill → freeze

`CONTEXT.md` = **working memory / bột thô** (living, cập nhật liên tục). Mỗi frozen doc = **kết tinh** distill ra từ CONTEXT tại gate.

```
grill-into-CONTEXT  →  distill CONTEXT → frozen artifact  →  gate freeze  →  phase sau
  (grill-with-docs)        (phase skill tự làm)             (người confirm)
```

Phân vai theo write-model: `grill-with-docs` **đọc frozen, ghi living (CONTEXT)**; phase skill **distill CONTEXT → ghi frozen** rồi freeze. Không ai vi phạm freeze.

## Quy tắc bất biến

1. **Skills**, KHÔNG commands. Lý do: pipeline có triết lý "single source of truth, chống drift" → không thể build bằng 8 file command copy-paste cùng một protocol (tự mâu thuẫn). Skills cho phép shared `references/` (freeze-protocol, `PIPELINE.lock`-schema, elicitation, doc-template). Để `description` chặt ("chỉ khi user gõ /...") để không auto-fire giữa chừng.
2. **State một chỗ, MACHINE-READABLE:** `PIPELINE.lock` (YAML/JSON — KHÔNG phải block chữ trong CONTEXT) giữ con trỏ phase + quyết định (vd `ux: skipped`); mọi command đọc để gate, ghi khi qua gate, và **đối chiếu chéo với artifact thật qua hash**. `CONTEXT.md` = prose working-memory thuần, **KHÔNG chứa state**. (Fix 1.1 — bỏ SPOF block chữ dễ bị grill mài mòn.)
3. **Ba lớp quyền ghi:** frozen (PRINCIPLES/PRD/BUSINESS-FLOW/ARCHITECTURE — chỉ `/reconcile` **hoặc `/pivot`** mở) · living (`CONTEXT` — ghi tự do) · append-only immutable (`decisions/`). (Nit review-3: khớp dòng "/reconcile & /pivot là hai đường duy nhất".)
4. **Gate = người** confirm "freeze?", KHÔNG auto-freeze. **Trước khi MỜI freeze**, phase skill chạy **completeness-check** (readiness checklist): (a) đủ section cấu trúc — PRD có intent+journey+scope? BUSINESS-FLOW có state+rule+invariant? — **VÀ** (b) khớp `PRINCIPLES.md` (đúng ràng buộc repo, không chỉ "đủ mục"). Chưa đạt → KHÔNG mời freeze. (Fix 3.4 — teeth chống gate=bấm-yes-cho-qua; cặp với 4.2.)
5. **Elicitation = ĐỦ DÙNG, TÁI DÙNG + CUSTOM MỎNG, không reinvent** (đã hạ khỏi "hạng nhất/depth ngang BMad" theo quyết định B). Lấy kỹ thuật gốc của **`interview-me` + `grill-with-docs`** (2 engine; `brainstorming` đã bỏ) làm nền; mỗi phase phủ một lớp custom mỏng: tinh chỉnh framing + đấu dây vào pipeline (ghi đúng doc đích, update `PIPELINE.lock`, tôn trọng freeze). Contract reuse **enforce bằng cấu trúc** (grill = subagent đề-xuất, cha ghi) + **backstop hash ADR**, không chỉ dặn suông (NEW-1). (Xem "Tích hợp hệ sinh thái" + "Rủi ro thiết kế".)
6. Cuối mỗi phase, command tự làm 4 việc: freeze artifact · cập nhật `PIPELINE.lock` · **compact CONTEXT** (phần đã kết tinh → summarize/đẩy `CONTEXT-archive.md`, **archive-not-delete**, conservative kẻo mất signal — compaction là thao tác LLM) · nhắc `/adr` nếu vừa nảy quyết định lớn. (Fix 5.2.)
7. **UX là sub-artifact CÓ ĐIỀU KIỆN, KHÔNG phải một phase:** backend thuần → `/architecture` bỏ sub-artifact `UX-DESIGN.md` (ghi dòng skip vào CONTEXT), nhưng **phase `/architecture` + `ARCHITECTURE.md` VẪN bắt buộc**. Số phase KHÔNG co lại. (Fix 5.1.)
8. **FR/NFR viết một lần:** narrative ở PRD, atomic/testable ở REQUIREMENTS. KHÔNG đồng bộ hai list.
9. **REQUIREMENTS** (ID→epic→story→test; epic/story = nhãn traceability, KHÔNG phải đơn vị implementation — Fix 4.1) = contract giữa planning & implementation agent — ưu tiên ổn định format.
10. **`PRINCIPLES.md` = root của hash-graph:** non-negotiable của repo, capture + freeze ở `/kickoff`, nằm trong `from_hash` của MỌI derived doc → `/reconcile PRINCIPLES` = cascade toàn bộ. Giữ **NHẸ** (bullet-list), KHÔNG phình thành phase grill riêng. Cặp với rule 4 (cho completeness-check một chuẩn nội-dung khách quan). (Fix 4.2.)

## Rủi ro thiết kế lớn nhất: divergent vs convergent

- BMad mạnh nhờ **divergent** — grill nhiều hướng, moi idea (Socratic, pre-mortem, red-team, first-principles…).
- Pipeline này mạnh nhờ **convergent** — tuyến tính, freeze.
- Làm ẩu → freeze giết grill → mất đúng thứ giá trị nhất.

**Hoà giải:** freeze-_per-phase_ là cơ chế để grill _tối đa_ mà không loạn. **Trong** phase (trước gate) = divergent — chạy `interview-me` / `grill-with-docs` (+ "2-3 approaches" inline); **gate freeze** = điểm hội tụ. Elicitation không phải reference tự viết mà là **orchestration** 2 engine sẵn có; không phase nào được hỏi hời hợt. _Lưu ý: freeze-per-phase chỉ hội tụ TRONG phase — reframe XUYÊN phase là bài toán 3.2, chưa giải._

## Docs coverage vs BMad

Cho phạm vi _planning/docs bootstrap_: **đầy đủ + gọn + kỷ luật hơn**. Thắng BMad ở 3 chỗ: `BUSINESS-FLOW.md` tách riêng · freeze discipline · ADR immutable + supersede.

## Out of scope

- (a) sinh implementation plan + dev/story execution + code-review — **downstream, ĐÃ có superpowers lo** (`writing-plans` → `executing-plans` / `subagent-driven-development`). Bộ mới dừng ở `REQUIREMENTS`.
- (b) per-story context file (kiểu `bmad-create-story`) — **bỏ (đã chốt)** (cược: docs frozen tốt → plan tự đơn giản).
- (c) research docs tách riêng — gộp vào `CONTEXT`.

## Câu hỏi còn mở (chờ xác nhận trước khi ra spec)

- [x] Out-of-scope (b): bỏ per-story context file — **CHỐT: bỏ**.
- [x] Constraint 5: elicitation = tái dùng + custom mỏng — **CHỐT** (B: nhường depth).
- [x] 6 cụm load-bearing + contract-reuse — **BỊT XONG** (review-1) + hardening (review-2) + fold-back & 3 nit (review-3).
- [x] Nhóm nên-có — **NHẬN NGUYÊN LÔ**: 3.4 (nâng lên must, rule 4) · 4.2 PRINCIPLES.md nhẹ (rule 10) · 5.2 compaction archive-not-delete (rule 6) · 5.3 wording. Cặp 3.4+4.2 giữ.
- [x] Shadow-test — **CHỐT: chạy TRƯỚC spec** (thin manual, không cần pipeline tồn tại; đo 2.1 + 2.2-interface). Bất đối xứng chi phí: 1 buổi vs rework-scope.
- [ ] **Bước kế = SHADOW-TEST** → nếu pass → **"yes" cuối** → viết spec (bắt đầu `PIPELINE.lock` schema + freeze-protocol reference).
- [ ] Nếu shadow-test FAIL 2.1 → out-of-scope (b) sai → mở lại (thêm tầng story-context) trước khi spec.

## Verification review adversarial (2026-07-08)

Đã kiểm chứng từng finding vào **nguồn thật** (đọc `writing-plans` SKILL.md, `brainstorming` SKILL.md, định nghĩa `grill-with-docs`, và chính doc này). Nhãn: ✅CONFIRMED · ✅+ (thật, còn tệ hơn mô tả) · ◐ REFRAME (thật nhưng quy trách/severity lệch) · ⤵ OVERSTATED · ❌ REFUTED.

| #                                                           | Verdict               | Ghi chú kiểm chứng                                                                                                                                                                                                                                                                                                                            |
| ----------------------------------------------------------- | --------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1.1 state ở CONTEXT living                                  | ✅+                   | `grill-with-docs` định nghĩa gốc: "updates CONTEXT.md **inline**" → mài mòn block state là hành vi mặc định của nó, không phải rủi ro giả định. **Load-bearing.**                                                                                                                                                                             |
| 1.2 /reconcile không cascade                                | ✅                    | Doc không định nghĩa invalidation downstream. **Load-bearing.**                                                                                                                                                                                                                                                                               |
| 1.3 hai list FR = drift                                     | ◐                     | Constraint 8 (viết-một-lần, khác altitude) là **tốt**, không phải thủ phạm. Gap thật = thiếu traceability PRD→REQ, đã gộp vào 1.2. Hạ khỏi MAJOR độc lập.                                                                                                                                                                                     |
| 1.4 ARCHITECTURE không unfreeze + mâu thuẫn nội tại         | ✅                    | Mâu thuẫn **verify trực tiếp trong doc**: rule 3 liệt ARCHITECTURE reconcile-được, mô tả /reconcile chỉ "PRD hoặc BUSINESS-FLOW". **Load-bearing.**                                                                                                                                                                                           |
| 2.1 cược "docs→plan đơn giản"                               | ⤵                     | `writing-plans` **đọc codebase** + sinh task file-level + interfaces → NÓ mang impl-domain complexity, không phải REQUIREMENTS. "Không fallback" sai. Repo mới = greenfield = ít integration. Vẫn nên shadow-test, nhưng KHÔNG phải BLOCKER chiến lược.                                                                                       |
| 2.2 handoff REQ→writing-plans                               | ◐                     | REFUTED phần lõi: description của `writing-plans` = "spec **OR requirements**", Self-Review lặp "each requirement in the spec" → atomic FR/NFR là input **sạch/tốt hơn** prose. Seam thật: writing-plans giả định brainstorming đã tách sub-subsystem (Scope Check) — pipeline mình bỏ brainstorming nên khâu tách subsystem vô chủ. Reframe. |
| 3.1 "nằm giữa" bất khả thi                                  | ◐                     | "Skill chỉ 2 trạng thái" SAI — orchestration + thin-wrapper (invoke + pre/post) là mode thứ 3, đúng cái đã chốt. NHƯNG verify: brainstorming/grill-with-docs **không invoke verbatim được** (xem NEW-1/NEW-2) → contract phải ghi rõ SUPPRESSION, không chỉ plumbing. Đòi hỏi "contract chính xác" = ✅.                                      |
| 3.2 freeze giết cross-phase reframe                         | ✅                    | Finding sắc nhất. Đúng "cái giá của freeze". **Load-bearing.**                                                                                                                                                                                                                                                                                |
| 3.3 custom-mỏng ⊥ grill-sâu-ngang-BMad                      | ✅ → **RESOLVED (B)** | Verify: 3 engine đều **generic**, không mang ~40 kỹ thuật/persona của BMad. **Quyết định B (2026-07-08): hạ tuyên bố** — nhường depth, giữ custom mỏng, KHÔNG dựng `references/elicitation.md`. Mâu thuẫn gỡ.                                                                                                                                 |
| 3.4 gate fatigue + không completeness-check                 | ✅/PLAUSIBLE          | Không có readiness-check trước freeze = ✅ gap. Fatigue = rủi ro human-factor hợp lý.                                                                                                                                                                                                                                                         |
| 4.1 epic→story trong REQ vs downstream                      | ✅                    | Altitude mập mờ thật. Lưu ý: writing-plans sinh **task** không phải story → cần chốt story-vs-task.                                                                                                                                                                                                                                           |
| 4.2 thiếu PRINCIPLES.md (constitution)                      | PLAUSIBLE             | Gap thật vs spec-kit; ghép với 3.4 (cho gate chuẩn khách quan). "Bắt buộc" là judgment.                                                                                                                                                                                                                                                       |
| 5.1 rule 7 mô tả sai phase co giãn                          | ✅                    | Bỏ UX = bỏ sub-artifact, ARCHITECTURE vẫn bắt buộc → không mất phase. Minor verify đúng.                                                                                                                                                                                                                                                      |
| 5.2 CONTEXT phình vô hạn                                    | ✅                    | Không compaction; distill-quality tựa vào nó.                                                                                                                                                                                                                                                                                                 |
| 5.3 grill-with-docs "đọc frozen" nhưng phase 0/1 chưa có gì | ✅                    | grill-with-docs bản chất "challenge against existing model" → inert lúc kickoff. Chỗ tự nhiên của nó là phase muộn (đúng chỗ mình đặt BAN ĐẦU trước khi bạn sửa).                                                                                                                                                                             |
| 5.4 brainstorming/interview-me double-gate + orphan         | ✅+                   | Xem NEW-2: brainstorming còn tệ hơn — hard-gate + spec-review-gate + ghi spec riêng + **terminal-state = invoke writing-plans**.                                                                                                                                                                                                              |
| m10 không version contract                                  | ✅                    | Gap (gắn 1.2).                                                                                                                                                                                                                                                                                                                                |
| F12 không escape-hatch product-sai-gốc                      | ✅                    | Gap (gắn 3.2).                                                                                                                                                                                                                                                                                                                                |
| n14/n15 lạc quan gọn/thắng BMad                             | FAIR                  | Tu từ nhưng công bằng; coupling ra 3 skill ngoài là thật.                                                                                                                                                                                                                                                                                     |

### Reviewer BỎ SÓT (mình tự tìm)

- **NEW-1 — grill-with-docs mutate ADR inline, phá append-only-immutable.** Định nghĩa gốc: "updates documentation (CONTEXT.md, **ADRs**) inline". Rule 3 bảo `decisions/` immutable, chỉ `/adr` ghi. Reuse verbatim → vi phạm invariant. Contract reuse phải **cấm** nó chạm ADR.
- **NEW-2 — brainstorming HIJACK pipeline.** Terminal-state của brainstorming (SKILL.md dòng 32/46/61) = "invoke writing-plans". Gọi verbatim trong `/product` → nhảy thẳng sang implementation plan, **bỏ qua /architecture + /requirements**. Nghiêm trọng hơn "double-gate" nhiều.
- **NEW-3 — greenfield làm 2.1 nhẹ đi.** Use-case là "repo MỚI" → ít legacy để tích hợp → phần impl-complexity reviewer lo (integrate existing code, migration order) ít liên quan nhất đúng lúc này.

### Kết luận verification

Review **chất lượng cao, phần lớn đứng vững**.

- **3.3 RESOLVED bằng quyết định B** (nhường depth, đổi kỷ luật) — không còn load-bearing.
- **Load-bearing còn lại phải bịt TRƯỚC khi viết spec (5 cụm):** **1.1** (state → file machine-readable riêng, grill cấm chạm) · **1.2** (reconcile cascade/invalidation) · **1.4** (ARCHITECTURE unfreeze path + gỡ mâu thuẫn rule 3 vs /reconcile) · **3.2** (escape-hatch cho cross-phase reframe, gắn F12) · **4.1** (chốt altitude story-vs-task) · **contract reuse** (3.1 reframe + NEW-1 cấm grill chạm ADR + NEW-2 chặn brainstorming→writing-plans hijack).
- **Nên-có (không chặn spec):** 3.4 completeness-check trước freeze · 4.2 PRINCIPLES.md · 5.2 CONTEXT compaction · 5.1/5.3 sửa wording · m10 version contract.
- **Lever B — ĐÃ QUYẾT (2026-07-08): bỏ `brainstorming` khỏi bộ reuse.** Chỉ giữ `interview-me` + `grill-with-docs` (2 engine). "propose 2-3 approaches" giữ inline. → **NEW-2 xoá tận gốc**; contract reuse chỉ còn NEW-1 (cấm grill chạm ADR).
- Nhóm 2 (cược nền) rủi ro **nhỏ hơn** reviewer khung — shadow-test 1 repo là đủ, không phải BLOCKER.

**Đồng ý: chưa viết spec** — mở vòng thiết kế bịt 5 cụm + contract reuse trước.

## Design fixes — vòng bịt lỗ (2026-07-08)

Tiến độ: ✅1.1 · ✅1.2 (+topo-order +version-mọi-re-freeze) · ✅1.4 (+enforce cờ +guard-deadlock) · ✅3.2/F12 · ✅4.1 · ✅contract-reuse (+subagent-no-Write +ADR-backstop) · ✅**fold-back normative** (review-2 G1) · ✅nên-có nguyên lô (3.4 must · 4.2 · 5.2 · 5.3) · ◐2.2 (interface → **shadow-test trước spec**).

> **Review-2 (2026-07-09) đã xử:** G1 fold fix vào nửa trên (rule 1/2/5/6/7 + `/reconcile` + thêm `/pivot` vào update-cmd). G2 hardening cấu trúc (grill=subagent-đề-xuất + ADR-backstop-hash; `/adr` set cờ `pending_arch_sync` chặn tới khi `/reconcile ARCHITECTURE`). G3 hạ overclaim 2.2 → shadow-test. G4 cascade topological-order + re-scan + version-REQ-mọi-re-freeze.

> **Review-3 (2026-07-09) đã xử:** 3 nit — (1) rule 3 → "/reconcile hoặc /pivot"; (2) guard deadlock `pending_arch_sync` chỉ set nếu ARCHITECTURE đã frozen; (3) grill-subagent spawn KHÔNG cấp Write/Edit (tool-scope, không dặn suông). Nhận nhóm nên-có: 3.4 (must, rule 4) · 4.2 PRINCIPLES.md root hash-graph (rule 10) · 5.2 compaction archive-not-delete (rule 6) · 5.3 wording (dòng grill). **Chốt shadow-test TRƯỚC spec.**

### ✅ 1.1 — State integrity (hybrid, đã chốt)

1. **Tách state ra `PIPELINE.lock`** (YAML/JSON nhỏ, machine-readable): con trỏ phase + quyết định không map vào doc (vd `ux: skipped`). `grill-with-docs` **CẤM hợp đồng** chạm file này; chỉ phase/update skill ghi theo schema chặt. `CONTEXT.md` = thuần prose working-memory (grill tha hồ mài).
2. **Mỗi frozen doc mang frontmatter** `frozen: true` + `hash` (nội dung nó) + `from_hash` (**danh sách** hash mọi nguồn upstream nó distill ra).
3. **Gate = đọc `PIPELINE.lock` + đối chiếu artifact thật** (doc tồn tại? frozen? hash khớp?) — state suy-ra-được + cross-check, không còn block chữ dễ hỏng (SPOF).
   → Loại: sentinel-marker trong CONTEXT (mong manh, tựa vào grill "ngoan").

### ✅ 1.2 — Reconcile cascade (option c: người phân xử, có ghi lại)

- Hash (mảnh 2 của 1.1) **tự phát hiện STALE**: `/reconcile` đổi PRD → `hash` PRD đổi → doc nào có PRD trong `from_hash` list → gắn **STALE**. `from_hash` = list → xử lý cascade **bắc cầu + đa nguồn**.
- Khi STALE, `/reconcile` **duyệt downstream theo TOPOLOGICAL ORDER (upstream trước), ép phân xử từng doc**, 3 lối:
  - **re-gate now** — distill lại + freeze lại.
  - **mark reviewed-valid** — người khẳng định không đụng → re-stamp `from_hash` + **ghi note** (auditable).
  - **defer** — vẫn STALE, không chặn nhưng **hiện cờ**; handoff `writing-plans` cảnh báo nếu còn STALE-deferred.
- Vì sao: hard-block → gate-fatigue + thrash; warn-only → drift âm thầm; **(c)** = freeze người-gác thì cascade cũng người-phân-xử-từng-doc, có ghi lại. **Bound loop**: mỗi doc STALE kết ở 1/3 trạng thái → không lặp vô hạn.
- **Re-scan sau mỗi re-gate (fix review-2 G4):** re-gate một doc tầng giữa làm hash nó đổi → phải **quét lại STALE cho tầng dưới**. Chuỗi PRD→ARCH→REQ: nếu phân xử REQ _trước khi_ ARCH re-gate, cú hai-bước có thể lọt. Topological order + re-scan-sau-mỗi-re-gate đóng lỗ này.
- **Version REQUIREMENTS ở MỌI lần re-freeze (fix review-2 G4 — đóng m10 cho đường `/reconcile`):** không chỉ `/pivot` archive `v{N}`. Bất kỳ re-freeze REQUIREMENTS nào (qua `/reconcile` cascade hay `/pivot`) đều **bump version + ghi danh sách FR-ID vừa đổi**, để handoff/writing-plans diff được "3 FR này vừa đổi" cho code đã build trên v1. (Trước: m10 chỉ giải cho `/pivot`, đường reconcile→REQ vẫn hở.)

### ✅ 1.4 — ARCHITECTURE unfreeze + quan hệ ADR (option A)

- **① Gỡ mâu thuẫn:** `/reconcile <target>` mở **bất kỳ frozen doc** — PRD · BUSINESS-FLOW · **ARCHITECTURE**. Sửa dòng mô tả `/reconcile` (bị hẹp); rule 3 đúng. Đây là đường unfreeze của ARCHITECTURE.
- **② ARCHITECTURE ↔ ADR (A):**
  - `ARCHITECTURE.md` = **nguồn sự thật DUY NHẤT cho kiến trúc hiện tại**; đọc 1 phát ra chân lý, không replay ADR.
  - `decisions/` = nhật ký lý-do/lịch-sử, **append-only immutable**, không bao giờ sửa.
  - **Ràng buộc — enforce bằng STATE, không bằng trí nhớ (fix review-2 G2):** `/adr` **tự phân loại** ADR; nếu là loại **đổi kiến trúc** → set cờ `pending_arch_sync: true` trong `PIPELINE.lock`. Cờ này **CHẶN** command kế + gate cho tới khi `/reconcile ARCHITECTURE` chạy xong (đồng bộ snapshot + freeze → hash đổi → cascade 1.2 → clear cờ). Người **không thể "quên"** → không rơi lại bệnh two-sources. ADR không sửa ARCHITECTURE; ARCHITECTURE không chép rationale.
  - **Guard deadlock (nit review-3 #2):** chỉ set cờ `pending_arch_sync` **NẾU `ARCHITECTURE.md` đã frozen**. Arch-ADR ghi sớm (còn ở phase 1, chưa có ARCHITECTURE để reconcile) → **KHÔNG** set cờ; ADR đó chỉ **feed vào `/architecture` sắp tới** như input. Tránh cờ chặn một `/reconcile ARCHITECTURE` không thể chạy.
  - Khớp NEW-1 (grill cấm chạm `decisions/`) + rule 6 (nhắc `/adr`).
  - Loại (B): "snapshot bất biến + replay ADR" = bệnh không-lần-đọc-nào-ra-chân-lý.

### ✅ 3.2/F12 — Escape-hatch reframe xuyên phase (command #8: `/pivot`)

Tách 2 loại "sai": **gap cục bộ** (framing đúng) → `/reconcile`; **reframe gốc** (tiền đề phase trước sai) → **`/pivot`**.

- **① Mechanism `/pivot <phase-đích>`** (command thứ 8, được chúc phúc): archive doc hiện tại → `docs/archive/v{N}/` + **pivot-ADR** (vì sao lật) → rewind con trỏ `PIPELINE.lock` về phase đích, mở lại → downstream tự STALE (máy hash 1.2) → re-derive. Tái dùng máy 1.2. Khác `/reconcile` ở **ngữ nghĩa** (reconcile = sửa phẫu thuật; pivot = tiền đề sai). Archive vN **cho luôn version contract (m10)**.
- **② Framing chống-trừng-phạt (phần chữa 3.2 tận gốc):** grill phase muộn **được cấp phép** thách thức frozen doc phase trước (read-only, nhưng được raise `/pivot`). Phơi reframe gốc = **hệ thống THÀNH CÔNG**, không phải phá freeze — **không phạt**. Giá redo là thật nhưng bounded + recorded + rẻ hơn phát hiện sau build. Không có ② thì ① vô dụng.

### ✅ 4.1 — Altitude của contract (cắt dứt khoát)

- **Đơn vị nguyên tử = FR/NFR + acceptance criteria** (phần testable, thật của contract).
- **`epic` = nhóm product-area; `story` = nhóm feature-slice** — chỉ là **nhãn traceability/tổ chức**, KHÔNG phải đơn vị implementation (không per-story context doc). Grouping ≠ planning → "planning downstream" giữ nguyên.
- **`writing-plans` sở hữu toàn bộ FR→task.** Contract không plan gì.
- **Seam 2.2 — chỉ vá phần NỘI BỘ; phần interface CHƯA (sửa overclaim, fix review-2 G3):** 4.1 gỡ xong mâu thuẫn altitude _bên trong_ doc. NHƯNG claim "story-slice ≈ subsystem mà writing-plans CONSUME" là **cây cầu chưa đi thử** — writing-plans nhiều khả năng tự phân rã theo codebase, **lờ nhãn story**. → (a) thêm câu hỏi này vào **shadow-test** (cùng lượt đo cược nền 2.1); (b) cân nhắc **handoff tường minh** — chỉ thị writing-plans coi mỗi story-slice = 1 ranh giới plan, thay vì hy vọng nó tự suy. **CHƯA coi là đóng.**

### ✅ contract-reuse (NEW-1) — hợp đồng gọi 2 engine (contract 3.1 đòi)

Phase skill = **orchestrator**; engine = sub-skill invoke; phase skill bọc pre/post plumbing + **suppression cứng**:

- **`grill-with-docs` — enforce bằng CẤU TRÚC, không bằng lời dặn (fix review-2 G2):** chạy như **subagent chỉ ĐỀ XUẤT** edit CONTEXT; **phase-skill cha là bên DUY NHẤT thực ghi file**. → grill _không thể_ tự tay chạm `PIPELINE.lock`/`decisions/`/frozen (nó chỉ trả text, cha quyết ghi gì). Suppression-bằng-instruction đơn thuần là mềm (model phải nghe lời wrapper), nên nâng lên cấu trúc.
  - **Cơ chế cụ thể ở spec (nit review-3 #3):** spawn subagent grill **KHÔNG cấp tool `Write`/`Edit`** → nó _buộc_ trả edit dạng text, cha mới ghi. Phải ghi rõ tool-scope này trong spec, kẻo lại rơi về "dặn suông".
- **Backstop cho ADR immutability (NEW-1, fix review-2 G2):** state có hash cross-check bắt lỗi, nhưng **ADR thì không** — nếu ai/grill sửa inline một ADR cũ, `decisions/` "append-only" chỉ theo LUẬT, không cơ chế phát hiện. → thêm **manifest hash `decisions/`**; gate/CI check **không file ADR cũ nào đổi hash** (chỉ được append file mới).
- **`interview-me`:** output = confirmed intent **trả về** phase skill để distill; **tắt** cú optional "save to `docs/intent/`" (khỏi đẻ orphan doc — phase skill quyết intent đi đâu: CONTEXT → distill vào frozen doc).
- **Phase skill (KHÔNG phải engine) sở hữu:** ghi frozen artifact · freeze gate · update `PIPELINE.lock` · stamp hash.

### ✅ Elicitation contract — engine + cường độ theo phase

Nguyên tắc: **interview-me lấp KHOẢNG TRỐNG** (đầu, chưa có gì) · **grill-with-docs vắt VẬT LIỆU** (sau, đã có doc). Giao điểm = freeze PRD/BUSINESS-FLOW cuối phase 1.

| Phase               | Cường độ                       | Engine chính                                  | Bản chất                                                               |
| ------------------- | ------------------------------ | --------------------------------------------- | ---------------------------------------------------------------------- |
| `/kickoff` (0)      | 🟢 nhẹ                         | interview-me _nhẹ_ + grill (capture)          | thu brief + research                                                   |
| `/product` (1)      | 🔴 **nặng nhất**               | **interview-me** + grill nháp                 | **MOI intent** — phase "hỏi liên tục" đúng nghĩa                       |
| `/architecture` (2) | 🟠 vừa–cao                     | **grill-with-docs** + "2-3 approaches" inline | **THÁCH THỨC** phương án trên nền frozen                               |
| `/requirements` (3) | 🟡 thấp tương tác / cao verify | **grill-with-docs** soi gap/consistency       | **DISTILL** + cross-check; gặp gap → DỪNG, route `/reconcile`/`/pivot` |

Update cmd: `/reconcile` = grill nhắm đúng gap · `/pivot` = thừa hưởng mode phase đích · `/adr` + luật-code = interview-me nhẹ.
