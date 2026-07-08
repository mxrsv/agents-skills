# SPEC — Docs-bootstrap pipeline (bộ 8 skill thay BMad)

> **Nguồn:** dịch trực tiếp từ `WORKFLOW.md` (thiết kế đã khoá qua 3 vòng adversarial review, 2026-07-08→09; copy source đặt cạnh file này). SPEC này **KHÔNG mở lại quyết định** — chỉ chuyển thiết kế đã chốt thành đặc tả cấu trúc để `superpowers:writing-plans` tiêu thụ.
>
> **Phạm vi kiến trúc thực thi:** mỗi skill là 1 thư mục trong `~/.claude/skills/` (global). Docs pipeline (`docs/…`, `PIPELINE.lock`) được skill ghi vào **repo mà user đang đứng** khi chạy skill. SPEC + PLAN + WORKFLOW (source) sống ở `~/.claude/docs/workflow-pipeline/` — cùng chỗ với build target global.
>
> **Hai ambiguity đã resolve từ chính doc (không phải quyết định mới):**
> 1. `REQUIREMENTS.md` = **frozen terminal node** (có `hash`+`from_hash`, tham gia cascade, versioned). Gate cột "—" ở phase 3 nghĩa là *không có freeze-ceremony giữa pipeline* — chính việc distill ra REQUIREMENTS sạch **là** cú freeze cuối + handoff. Căn cứ: dòng 7/13/57 gọi thẳng "REQUIREMENTS.md frozen contract" + fix 1.2 "re-freeze REQUIREMENTS".
> 2. Skill luật-code-cho-agent chưa có tên `/` trong doc → **chốt `/agent-rules`** (đổi tên tự do sau).

---

## 1. Mục tiêu & giá trị cốt lõi

Bộ **8 skill cá nhân thay hẳn BMad** — pipeline docs-bootstrap **tuyến tính + freeze-gated**, kết ở `REQUIREMENTS.md` làm contract giữa planning agent (`superpowers:writing-plans`) và implementation agent.

- **Giá trị cốt lõi = KỶ LUẬT** (freeze · single-source · traceability), **KHÔNG phải elicitation depth**. (Quyết định B, 2026-07-08: nhường depth ↔ đổi lấy kỷ luật.)
- **Luận điểm:** đổ công vào docs đóng băng chất lượng cao ở đầu → implementation plan tự trở nên đơn giản & chính xác. Docs là phần khó & đáng đầu tư; plan là hệ quả rẻ phía sau.
- **Chỉ là tầng upstream.** Downstream (plan + build) đã có superpowers lo — KHÔNG reinvent. Elicitation cũng **tái dùng** engine sẵn có, không viết mới.

**Ranh giới:**

```
[BỘ NÀY — upstream, freeze-gated docs]
/kickoff → /product → /architecture → /requirements → REQUIREMENTS.md (frozen contract)
   ⇧ elicitation: interview-me · grill-with-docs   (brainstorming ĐÃ BỎ)
   ⟳ anytime: /adr · /reconcile · /pivot            + /agent-rules (đứng cạnh)
        │ handoff
        ▼
[SUPERPOWERS — downstream, ĐÃ CÓ]
writing-plans → executing-plans / subagent-driven-development
```

---

## 2. Docs layout (file skill sinh ra trong repo đích)

```
<repo>/
├── docs/
│   ├── CONTEXT.md              # living working-memory — PROSE THUẦN, không state (rule 2)
│   ├── CONTEXT-archive.md      # phần đã kết tinh, compact archive-not-delete (rule 6)
│   ├── PRINCIPLES.md           # frozen · root hash-graph (rule 10)
│   ├── PRD.md                  # frozen
│   ├── BUSINESS-FLOW.md        # frozen
│   ├── ARCHITECTURE.md         # frozen · single source of truth cho kiến trúc hiện tại
│   ├── UX-DESIGN.md            # frozen · CÓ ĐIỀU KIỆN (chỉ khi UI phức tạp)
│   ├── REQUIREMENTS.md         # frozen terminal · versioned · contract
│   ├── decisions/              # ADR — append-only immutable (rule 3)
│   │   ├── 0001-<slug>.md
│   │   └── …
│   └── archive/                # /pivot đẩy snapshot vào đây
│       ├── v1/
│       └── …
├── PIPELINE.lock               # STATE machine-readable (§3.1) — SPOF của gate, KHÔNG ở CONTEXT
└── <AGENTS.md | CLAUDE.md>     # /agent-rules sinh — NGOÀI pipeline, không hash-graph
```

**Ba lớp quyền ghi (rule 3):**

| Lớp | File | Ai được ghi |
| --- | --- | --- |
| **frozen** | PRINCIPLES · PRD · BUSINESS-FLOW · ARCHITECTURE · UX-DESIGN · REQUIREMENTS | chỉ `/reconcile` **hoặc** `/pivot` mở |
| **living** | CONTEXT.md (+ CONTEXT-archive.md) | phase/update skill ghi tự do (grill chỉ *đề xuất*, §3.4) |
| **append-only immutable** | decisions/*.md | chỉ `/adr` **append file mới**; không sửa file cũ |
| **state** | PIPELINE.lock | chỉ phase/update skill ghi theo schema; grill **CẤM chạm** |

---

## 3. Shared references (`~/.claude/skills/<pkg>/references/`)

Dùng chung bởi cả 8 skill. Tách ra `references/` chính là lý do **phải là skills, không phải commands** (rule 1) — 8 command copy-paste cùng protocol = tự mâu thuẫn "single source of truth".

### 3.1 `pipeline-lock-schema` — schema `PIPELINE.lock`

Machine-readable (YAML). Là **nguồn state DUY NHẤT** cho con trỏ + quyết định + cờ; hash sống ở frontmatter doc (§3.2), KHÔNG nhân đôi vào đây.

```yaml
lock_version: 1                 # schema version của chính lock
phase: kickoff                  # con trỏ: kickoff|product|architecture|requirements|done
decisions:
  ux: pending                   # pending | included | skipped   (set ở /architecture)
flags:
  pending_arch_sync: false      # /adr arch-changing set khi ARCHITECTURE đã frozen (§3.3, 1.4)
docs:                           # registry — chỉ id/path/status; hash KHÔNG ở đây (single-source)
  - id: PRINCIPLES
    path: docs/PRINCIPLES.md
    status: active              # absent | active | stale | stale-deferred
  - id: PRD
    path: docs/PRD.md
    status: active
  # … PRD/BUSINESS-FLOW/ARCHITECTURE/UX-DESIGN/REQUIREMENTS khi tồn tại
requirements_version: 0         # bump MỌI lần REQUIREMENTS re-freeze (§3.3)
adr_manifest:                   # backstop immutability — id → hash lúc append (§3.4)
  "0001": <sha256>
  "0002": <sha256>
archive_versions: []            # [v1, v2, …] do /pivot tạo
```

Quy tắc:
- `CONTEXT.md` **KHÔNG** chứa state (fix 1.1 — bỏ SPOF block chữ dễ bị grill mài mòn).
- STALE **thô** = suy ra từ hash (§3.3), KHÔNG lưu; chỉ quyết-định-người (`stale-deferred`) mới ghi vào `docs[].status`.
- Mọi command **đọc lock để gate**, **ghi lock khi qua gate**, và **cross-check artifact thật qua hash** (§3.2).

### 3.2 `freeze-protocol` — frontmatter + gate cross-check

Mỗi frozen doc mang frontmatter:

```yaml
---
frozen: true
hash: <sha256 của BODY markdown, không tính frontmatter>   # integrity của chính nó
from_hash:                       # DANH SÁCH nguồn upstream đã distill ra (map id→hash)
  PRINCIPLES: <sha256>
  PRD: <sha256>
version: 1                       # chỉ REQUIREMENTS (+ doc versioned) dùng; khác: bỏ qua
---
```

- **`hash`** = sha256 của body (phần dưới frontmatter). Re-stamp `from_hash` (reviewed-valid) **KHÔNG** đổi `hash` (vì hash không tính frontmatter) → đúng: nội dung không đụng thì integrity giữ nguyên.
- **`from_hash` = map** (id→hash mọi nguồn upstream) → xử lý cascade **bắc cầu + đa nguồn** (§3.3). `PRINCIPLES` nằm trong `from_hash` của **MỌI** derived doc (rule 10) → nó là root hash-graph.
- **Freeze operation:** (1) completeness-check pass (§ gate rule 4) → (2) người confirm → (3) compute `hash` body → (4) snapshot `from_hash` = hash hiện tại của mọi upstream → (5) ghi frontmatter → (6) update lock (`docs[].status=active`, advance `phase`).
- **Gate cross-check** (mọi command trước khi hành động): đọc lock → với mỗi doc phải-frozen: (a) file tồn tại? (b) `frozen: true`? (c) recompute body hash == frontmatter `hash`? (d) mỗi entry `from_hash[U]` == hash hiện tại của `U`? — (d) fail ⇒ **STALE**. State suy-ra-được + cross-check, không còn block chữ dễ hỏng.

### 3.3 `hash-cascade` — STALE detection + cascade arbitration

**Topological order (root→sink):**
`PRINCIPLES → {PRD, BUSINESS-FLOW} → {ARCHITECTURE, UX-DESIGN} → REQUIREMENTS`

**STALE detection:** doc `D` STALE ⟺ ∃ upstream `U ∈ D.from_hash` mà `current_hash(U) ≠ D.from_hash[U]`.

**Cascade** (kích bởi `/reconcile` re-freeze hoặc `/pivot`): sau khi 1 doc đổi hash, duyệt downstream **theo topological order (upstream trước)**, ép phân xử **từng** STALE doc — 3 lối (option c, người-phân-xử-có-ghi-lại):

| Lối | Hành động | Kết quả |
| --- | --- | --- |
| **re-gate now** | distill lại từ upstream mới → completeness-check → freeze lại (hash mới) | + **re-scan** downstream (xem dưới) |
| **mark reviewed-valid** | người khẳng định nội dung không đụng → re-stamp `from_hash` = upstream hiện tại + **ghi note auditable** | hết STALE, `hash` giữ nguyên |
| **defer** | để nguyên STALE, không chặn | set `docs[].status = stale-deferred`; handoff cảnh báo |

Quy tắc bịt lỗ (fix review-2 G4):
- **Re-scan sau MỖI re-gate:** re-gate doc tầng giữa đổi hash nó → phải quét lại STALE cho tầng dưới. Chuỗi `PRD→ARCH→REQ`: nếu phân xử REQ *trước khi* ARCH re-gate, cú hai-bước lọt → topo-order + re-scan đóng lỗ.
- **Version REQUIREMENTS ở MỌI re-freeze:** bất kỳ lần REQUIREMENTS re-freeze nào (qua `/reconcile` cascade **hay** `/pivot`) → `requirements_version += 1` + ghi **danh sách FR-ID vừa đổi** (vào frontmatter/note) → handoff diff được "3 FR này đổi" cho code đã build trên bản trước. (Đóng m10 cho cả đường reconcile, không chỉ pivot.)
- **Bound loop:** mỗi STALE doc kết ở 1/3 trạng thái → không lặp vô hạn.

### 3.4 `elicitation-contract` — hợp đồng gọi 2 engine

**Nguyên tắc:** `interview-me` lấp **KHOẢNG TRỐNG** (đầu, chưa có gì) · `grill-with-docs` vắt **VẬT LIỆU** (sau, đã có frozen doc). `brainstorming` **ĐÃ BỎ** (thủ phạm hijack→writing-plans + double-gate + orphan-doc); chỉ giữ kỹ thuật *"propose 2-3 approaches"* nhét **inline** vào `/product` + `/architecture`.

**Enforce bằng CẤU TRÚC, không bằng lời dặn:**

- **`grill-with-docs` = subagent chỉ ĐỀ XUẤT.** Spawn subagent **KHÔNG cấp tool `Write`/`Edit`** (tool-scope, nit review-3 #3) → nó *buộc* trả edit dạng **text**; **phase-skill cha là bên DUY NHẤT thực ghi file**. → grill *không thể* tự tay chạm `PIPELINE.lock` / `decisions/` / frozen doc.
- **`interview-me`:** output = confirmed intent **trả về** phase skill để distill; **TẮT** cú optional "save to `docs/intent/`" (khỏi đẻ orphan doc). Phase skill quyết intent đi đâu (→ CONTEXT → distill vào frozen).
- **Backstop ADR immutability (NEW-1):** state có hash cross-check, nhưng ADR thì không tự nhiên có → dùng `adr_manifest` (§3.1). Gate/CI check: **không id ADR cũ nào đổi hash** (chỉ được append id mới). Bắt trường hợp ai/grill sửa inline một ADR cũ.
- **Phase skill (KHÔNG phải engine) sở hữu:** ghi frozen artifact · freeze gate · update `PIPELINE.lock` · stamp hash. Engine chỉ trả text.

**Cường độ theo phase:**

| Phase | Cường độ | Engine chính | Bản chất |
| --- | --- | --- | --- |
| `/kickoff` (0) | 🟢 nhẹ | interview-me *nhẹ* + grill (capture) | thu brief + research |
| `/product` (1) | 🔴 **nặng nhất** | **interview-me** + grill nháp | MOI intent — "hỏi liên tục" |
| `/architecture` (2) | 🟠 vừa–cao | **grill-with-docs** + "2-3 approaches" inline | THÁCH THỨC phương án trên nền frozen |
| `/requirements` (3) | 🟡 thấp tương tác / cao verify | **grill-with-docs** soi gap/consistency | DISTILL + cross-check; gap → DỪNG |
| `/reconcile` | — | grill nhắm đúng gap | — |
| `/pivot` | — | thừa hưởng mode phase đích | — |
| `/adr`, `/agent-rules` | — | interview-me nhẹ | — |

**`grill-with-docs` inert khi chưa có ≥1 frozen doc** (kickoff/đầu product chủ yếu capture) — sức challenge scale theo vật liệu frozen (fix 5.3).

---

## 4. Đặc tả 8 skill

Mỗi skill: **mục đích · trigger · input đọc · output ghi · gate · side-effect lên `PIPELINE.lock`**.

> **Trigger chung (rule 1):** `description` mỗi skill phải **chặt** — chỉ fire khi user gõ đúng `/<cmd>`, KHÔNG auto-fire giữa chừng.
> **Post-phase 4 việc (rule 6):** cuối mỗi phase skill tự làm — (a) freeze artifact · (b) update `PIPELINE.lock` · (c) compact CONTEXT (đẩy phần kết tinh → `CONTEXT-archive.md`, **archive-not-delete**, conservative) · (d) nhắc `/adr` nếu vừa nảy quyết định lớn.

### 4.1 `/kickoff` — Phase 0

- **Mục đích:** bootstrap scaffold `docs/` + capture non-negotiable repo + research/brief.
- **Trigger:** user gõ `/kickoff` (repo mới, chưa có pipeline). Nếu `PIPELINE.lock` đã tồn tại → cảnh báo, không ghi đè.
- **Input đọc:** user input (interview-me nhẹ). Chưa có frozen doc → grill ở chế độ capture.
- **Output ghi:** tạo `docs/` scaffold · `CONTEXT.md` (brief + research gộp vào, out-of-scope c) · `PIPELINE.lock` (init) · **`PRINCIPLES.md`** (bullet-list non-negotiable, **root hash-graph**, giữ NHẸ — rule 10) → **freeze PRINCIPLES**.
- **Gate:** completeness-check PRINCIPLES (đủ non-negotiable, coherent) → **người confirm freeze**. Chưa đạt → KHÔNG mời freeze (rule 4).
- **Side-effect lock:** init toàn bộ (`lock_version`, `phase: kickoff`, `decisions.ux: pending`, `adr_manifest: {}`). Sau freeze PRINCIPLES → `docs[PRINCIPLES].status=active`, **`phase → product`**.

### 4.2 `/product` — Phase 1

- **Mục đích:** MOI intent → `PRD.md` (intent · journey · scope) + `BUSINESS-FLOW.md` (state · rule · invariant).
- **Trigger:** `/product`; gate-guard `phase == product` (PRINCIPLES đã frozen). Sai phase → chặn + báo.
- **Input đọc:** `PRINCIPLES.md` (frozen, nền cho completeness-check + grill) · `CONTEXT.md`. Elicitation **nặng nhất**: interview-me (moi intent) + grill nháp + "2-3 approaches" inline.
- **Output ghi:** `PRD.md` + `BUSINESS-FLOW.md`. Update CONTEXT (parent ghi từ grill-đề-xuất). FR/NFR **viết narrative** ở PRD (atomic để dành REQUIREMENTS — rule 8, KHÔNG sync 2 list).
- **Gate:** completeness-check **từng doc** — PRD có intent+journey+scope? BUSINESS-FLOW có state+rule+invariant? **VÀ** khớp PRINCIPLES (rule 4) → **người freeze CẢ HAI**.
- **Side-effect lock:** sau freeze → `docs[PRD].status=active` + `docs[BUSINESS-FLOW].status=active` (stamp `from_hash={PRINCIPLES}`), **`phase → architecture`**. Compact CONTEXT. Nhắc `/adr` nếu có quyết định lớn.

### 4.3 `/architecture` — Phase 2

- **Mục đích:** chốt kiến trúc trên nền frozen product docs; UX là sub-artifact CÓ ĐIỀU KIỆN (rule 7).
- **Trigger:** `/architecture`; gate-guard `phase == architecture` (PRD+BUSINESS-FLOW frozen).
- **Input đọc:** `PRINCIPLES` · `PRD` · `BUSINESS-FLOW` (frozen — grill-with-docs vắt vật liệu) · `CONTEXT`. **Hỏi "UI phức tạp không?"**
- **Output ghi:**
  - UI phức tạp → sinh `UX-DESIGN.md` (freeze); backend thuần → **ghi dòng skip vào CONTEXT + dồn surface vào ARCHITECTURE** (KHÔNG bỏ phase — rule 7).
  - Luôn `ARCHITECTURE.md` (single source of truth kiến trúc) → **freeze**. ADR sinh trong lúc dựng đi qua `/adr` (§4.5).
- **Gate:** completeness-check ARCHITECTURE (+ UX nếu có) khớp PRINCIPLES/PRD → **người freeze**.
- **Side-effect lock:** `decisions.ux = included | skipped`. Sau freeze → `docs[ARCHITECTURE].status=active` (+ UX), **`phase → requirements`**. Compact CONTEXT. Nhắc `/adr`.
  - **Lưu ý ADR-early:** ADR đổi-kiến-trúc ghi *trong* phase này (ARCHITECTURE chưa frozen) → **KHÔNG** set `pending_arch_sync`; nó chỉ **feed vào** `/architecture` như input (guard deadlock, §4.5).

### 4.4 `/requirements` — Phase 3

- **Mục đích:** distill FR/NFR atomic + acceptance → `REQUIREMENTS.md` (contract terminal).
- **Trigger:** `/requirements`; gate-guard `phase == requirements` (ARCHITECTURE frozen) **và** `flags.pending_arch_sync == false`.
- **Input đọc:** toàn bộ frozen upstream (PRINCIPLES · PRD · BUSINESS-FLOW · ARCHITECTURE · UX nếu có) · CONTEXT. grill-with-docs soi gap/consistency.
- **Output ghi:** `REQUIREMENTS.md`:
  - FR/NFR **atomic, đánh số** (`FR-xxx` / `NFR-xxx`), **mỗi dòng link acceptance criteria** = đơn vị nguyên tử của contract (fix 4.1).
  - `epic` (nhóm product-area) / `story` (nhóm feature-slice) = **NHÃN traceability/tổ chức**, KHÔNG phải đơn vị implementation (KHÔNG per-story context doc).
  - **Gặp gap → phân loại** (intent→PRD; state/rule→BUSINESS-FLOW) → **DỪNG + báo** → route `/reconcile` (gap cục bộ) hoặc `/pivot` (tiền đề sai). **KHÔNG tự sửa frozen.**
- **Gate:** cột "—" = **không có freeze-ceremony giữa pipeline**; distill REQUIREMENTS sạch = **freeze terminal** (frontmatter `frozen:true` + `version:1` + `from_hash` = mọi upstream). completeness-check vẫn chạy (mọi FR phủ + khớp).
- **Side-effect lock:** `docs[REQUIREMENTS].status=active`, `requirements_version = 1`, **`phase → done`**. Nếu còn `stale-deferred` → cờ để handoff `writing-plans` cảnh báo.

### 4.5 `/adr <title>` — anytime

- **Mục đích:** ghi quyết định lý-do/lịch-sử, **append-only immutable** (đổi ý → ADR mới supersedes, KHÔNG sửa file cũ).
- **Trigger:** `/adr <title>`, bất kỳ lúc nào.
- **Input đọc:** CONTEXT + interview-me nhẹ; đọc lock (ARCHITECTURE đã frozen chưa?).
- **Output ghi:** **file mới** `decisions/NNNN-<slug>.md` (auto-số). Skill **tự phân loại** ADR (đổi-kiến-trúc hay không).
- **Gate:** — (không freeze). ADR **không** sửa ARCHITECTURE; ARCHITECTURE **không** chép rationale (fix 1.4 option A).
- **Side-effect lock:** thêm `adr_manifest[NNNN] = hash` (backstop). Nếu ADR **đổi-kiến-trúc** **VÀ** `ARCHITECTURE.md` **đã frozen** → `flags.pending_arch_sync = true` → **CHẶN command kế + gate** cho tới khi `/reconcile ARCHITECTURE` chạy xong (guard deadlock: chưa frozen thì KHÔNG set cờ — §4.3).

### 4.6 `/reconcile <target>` — anytime

- **Mục đích:** mở 1 frozen doc sửa **gap cục bộ** (framing giữ nguyên) → re-freeze → cascade STALE downstream. Cùng `/pivot` là **hai đường DUY NHẤT** mở frozen doc.
- **Trigger:** `/reconcile <target>`; `target ∈ {PRINCIPLES, PRD, BUSINESS-FLOW, ARCHITECTURE, UX-DESIGN}`. (REQUIREMENTS re-freeze **qua cascade**, không target trực tiếp — nó là sink.)
- **Input đọc:** target frozen doc + upstream của nó + CONTEXT. grill nhắm đúng gap.
- **Output ghi:** sửa target → **re-freeze** (hash đổi) → duyệt downstream **topological order**, phân xử **từng STALE doc** 3 lối (§3.3) + **re-scan sau mỗi re-gate**.
  - `target == ARCHITECTURE`: đây là đường **sync snapshot** khi `pending_arch_sync` bật (fix 1.4). Sau khi freeze lại → **clear `pending_arch_sync`**.
  - `target == PRINCIPLES`: cascade **toàn bộ** (root hash-graph — rule 10).
- **Gate:** re-freeze target = **người**; mỗi downstream STALE = **người phân xử** (re-gate / reviewed-valid+note / defer).
- **Side-effect lock:** hash target đổi (frontmatter) → cập nhật `docs[].status` theo phân xử. **Version REQUIREMENTS** nếu REQ nằm trong chuỗi re-freeze (`requirements_version += 1` + FR-ID list). Clear `pending_arch_sync` nếu target=ARCHITECTURE. **KHÔNG** rewind `phase`.

### 4.7 `/pivot <phase-đích>` — anytime (escape-hatch)

- **Mục đích:** khi **tiền đề phase trước SAI** (reframe gốc, không phải gap cục bộ) → lật + rewind. Tách bạch với `/reconcile` bằng **ngữ nghĩa** (reconcile = sửa phẫu thuật; pivot = tiền đề sai).
- **Trigger:** `/pivot <phase-đích>`, bất kỳ lúc nào; grill phase muộn **được cấp phép** raise `/pivot` (challenge frozen doc read-only). **Framing: phơi reframe gốc = hệ thống THÀNH CÔNG, KHÔNG phạt** (fix 3.2 ②) — không có framing này thì cơ chế vô dụng.
- **Input đọc:** doc hiện tại + phase-đích + CONTEXT. **Thừa hưởng elicitation mode của phase đích.**
- **Output ghi:** archive doc hiện tại (+ downstream) → `docs/archive/v{N}/` · **pivot-ADR** (vì sao lật) vào `decisions/` · rewind con trỏ về phase đích, mở lại (unfreeze từ phase-đích trở đi) · downstream tự STALE (máy hash §3.3) → re-derive theo pipeline.
- **Gate:** — (raise không phạt); re-derive chạy gate pipeline bình thường từ phase-đích.
- **Side-effect lock:** **rewind `phase` = phase-đích**; `archive_versions += [vN]` (version contract m10); `docs[].status` downstream → absent/stale; `adr_manifest[pivot-ADR] = hash`.

### 4.8 `/agent-rules` — đứng cạnh (skill luật-code-cho-agent)

- **Mục đích:** sinh **1 file luật code cho agent** (kiểu `CLAUDE.md`/`AGENTS.md`), gọi **độc lập** — KHÔNG trong pipeline tuyến tính.
- **Trigger:** `/agent-rules`, bất kỳ lúc nào, **không phụ thuộc phase**.
- **Input đọc:** CONTEXT + frozen docs nếu có (PRINCIPLES/ARCHITECTURE làm nền) + interview-me nhẹ.
- **Output ghi:** 1 file ở **repo root** (vd `AGENTS.md` / `CLAUDE.md`) — **NGOÀI** `docs/` pipeline, **KHÔNG** trong hash-graph.
- **Gate:** — (không freeze).
- **Side-effect lock:** **KHÔNG** (đứng cạnh — không đụng `PIPELINE.lock`, không advance phase).

---

## 5. Invariants (10 quy tắc bất biến — checklist SPEC phải giữ)

1. **Skills, KHÔNG commands** — shared `references/`; `description` chặt (chỉ khi gõ `/…`).
2. **State một chỗ, machine-readable** — `PIPELINE.lock`; CONTEXT = prose thuần, KHÔNG state.
3. **Ba lớp quyền ghi** — frozen (chỉ `/reconcile`|`/pivot`) · living · append-only immutable.
4. **Gate = người + completeness-check** — (a) đủ section **VÀ** (b) khớp PRINCIPLES, TRƯỚC khi mời freeze. Không auto-freeze.
5. **Elicitation = tái dùng + custom mỏng** — interview-me + grill-with-docs (2 engine); enforce reuse bằng cấu trúc (grill=subagent-đề-xuất) + backstop hash ADR.
6. **Cuối phase 4 việc** — freeze · update lock · compact CONTEXT (archive-not-delete) · nhắc `/adr`.
7. **UX = sub-artifact có điều kiện** — KHÔNG phải phase; `/architecture` + `ARCHITECTURE.md` VẪN bắt buộc; số phase không co.
8. **FR/NFR viết một lần** — narrative PRD, atomic REQUIREMENTS; KHÔNG sync 2 list.
9. **REQUIREMENTS = contract** — ID→epic→story→test; epic/story = nhãn traceability, KHÔNG phải đơn vị implementation; ưu tiên ổn định format.
10. **PRINCIPLES.md = root hash-graph** — capture+freeze ở `/kickoff`, trong `from_hash` MỌI derived doc; giữ NHẸ (bullet-list).

---

## 6. Out of scope (không build)

- (a) sinh implementation plan · dev/story execution · code-review — **downstream, superpowers lo** (`writing-plans` → `executing-plans`/`subagent-driven-development`). Bộ này dừng ở `REQUIREMENTS`.
- (b) per-story context file (kiểu `bmad-create-story`) — **bỏ** (cược: docs frozen tốt → plan tự đơn giản). *Điều kiện đảo:* nếu shadow-test FAIL 2.1 → mở lại (xem §7).
- (c) research docs tách riêng — **gộp vào CONTEXT**.
- `brainstorming` — **BỎ khỏi bộ reuse** (chỉ giữ "2-3 approaches" inline).

---

## 7. Seam chưa đóng → SHADOW-TEST (điều kiện tiên quyết của PLAN)

**2.2 interface (fix 4.1) CHƯA đóng:** claim "story-slice ≈ subsystem mà `writing-plans` CONSUME" là cây cầu chưa đi thử — `writing-plans` nhiều khả năng tự phân rã theo codebase, **lờ nhãn story**.

**→ Task 0 của PLAN = SHADOW-TEST (chạy TRƯỚC khi build 8 skill):** tay-viết `REQUIREMENTS.md` frozen tối thiểu (+ PRD/ARCHITECTURE/PRINCIPLES tối thiểu) cho 1 ý tưởng greenfield nhỏ → feed `superpowers:writing-plans` → đo:

- **(2.1)** plan chính xác + phủ đủ **mỗi FR** mà **KHÔNG re-elicit intent**? — **FAIL ⇒ DỪNG, báo** (out-of-scope b sai → cần thêm tầng story-context trước khi spec/build).
- **(2.2)** `writing-plans` có tôn trọng **story-slice làm ranh giới plan** không? — nếu không → cân nhắc **handoff tường minh** (chỉ thị writing-plans coi mỗi story-slice = 1 ranh giới plan).

Chỉ build tiếp 8 skill khi **pass 2.1**.

---

## 8. Ghi chú traceability về nguồn

SPEC này phủ toàn bộ nửa normative của `WORKFLOW.md`: mục tiêu (dòng 5–18) · pipeline 4 phase (22–29) · update cmd (31–35) · đứng-cạnh (37–39) · tích hợp ecosystem (41–63) · nhịp grill→distill→freeze (65–74) · 10 rule (76–87) · risk divergent/convergent (89–95) · out-of-scope (101–105). Hardening: fix 1.1 (§3.1–3.2) · 1.2 (§3.3) · 1.4 (§4.5–4.6) · 3.2/F12 (§4.7) · 4.1 (§4.4, §7) · contract-reuse/NEW-1 (§3.4) · elicitation table (§3.4). Verification review adversarial (117–159) + design-fixes changelog (161–234) = rationale, KHÔNG normative — đã fold vào các mục trên.
