---
name: kickoff
description: Phase 0 of the docs-bootstrap pipeline. Bootstrap docs/ scaffold, capture repo non-negotiables into PRINCIPLES.md (root of the hash-graph), gather brief+research into CONTEXT.md, init PIPELINE.lock, and freeze PRINCIPLES. On an EXISTING codebase (brownfield) it first runs a read-only recon. Fires ONLY when the user types /kickoff without an existing pipeline.
when_to_use: A new (greenfield) repo OR an existing (brownfield) codebase, starting the freeze-gated docs pipeline. Trigger only on explicit /kickoff. If PIPELINE.lock already exists, warn and do not overwrite. On an existing codebase, detect brownfield and offer recon before eliciting.
argument-hint: "[brief one-line idea]"
arguments: brief
---

# /kickoff — Phase 0

**Mục đích:** bootstrap scaffold `docs/` + capture non-negotiable của repo + research/brief. Kết bằng **freeze `PRINCIPLES.md`** — root của hash-graph. Trên repo **đã có code (brownfield)**: chạy **recon read-only** trước để docs không mù.

Đọc trước: `../../references/pipeline-lock-schema.md` · `../../references/freeze-protocol.md` · `../../references/elicitation-contract.md` · `../../references/codebase-recon.md` (brownfield).

## Trigger & guard

- Chỉ fire khi user gõ `/kickoff`. **KHÔNG** auto-fire.
- Nếu `PIPELINE.lock` **đã tồn tại** trong repo đích → **cảnh báo + DỪNG**, không ghi đè (pipeline đã chạy rồi).
- **[lock VẮNG] Detect greenfield vs brownfield** (chỉ chạy khi lock vắng — guard trên đi TRƯỚC, nên detection không bao giờ fire trên pipeline đang chạy):
  - Sniff signals "đã có code": source files (`rg --files -g '*.{ts,tsx,js,py,go,rs,java,rb,php,c,cpp,cs,kt,swift}'` đếm > vài) hoặc `src/ lib/ app/ pkg/ internal/` có nội dung · manifest có **dependency thật + lockfile** · git history thật (`git log --oneline | wc -l` > 3, không phải fresh `git init`) · toolchain build/test/CI (`.github/workflows`, `Makefile`, `tsconfig`, test dir). **VÀ** `docs/PRINCIPLES.md` + `PIPELINE.lock` vắng.
  - Khớp → **HỎI 1 lần** (confirm bắt buộc, KHÔNG suy mode ngầm): _"Repo này có vẻ đã có code (signal: X, Y). Chạy kickoff ở BROWNFIELD mode — recon code trước khi viết docs? [Y/n]"_. Signal yếu → greenfield (offer brownfield 1 dòng opt-in). **Đáp án người = authoritative**, override 2 chiều.

## Brownfield mode (recon)

Chỉ khi `project_type: brownfield` (sau confirm). Full contract: `../../references/codebase-recon.md`.

- **Recon = subagent read-only, trả TEXT.** Spawn general-purpose subagent (**read-isolation** — giữ file source khỏi context này); nó **không ghi gì** trong repo; parent (kickoff) là bên ghi DUY NHẤT. `Explore` = locator con tùy chọn. _Không mâu thuẫn grill-inline: read-isolation ≠ write-sandbox._
- **Wrapper prompt:** bounding rules của `codebase-onboarding` verbatim ("không đọc hết; `rg` + manifest + vài file đại diện; không encyclopedic") **+ bucket domain-rules** (validation/guard/state-machine/permission/calc rule — quote + `file:line`) **+ LIGHT/DEEP** (LIGHT mặc định; DEEP scoped theo feature trong brief).
- **Output 3 bucket + runbook** → parent ghi vào `CONTEXT.md`: **A** conventions/constraints → PRINCIPLES (now) · **B** domain rules/invariant → BUSINESS-FLOW (`/product`) · **C** component/layer/data-flow → ARCHITECTURE (`/architecture`) · **Runbook** appendix.
- Recon chạy **TRƯỚC** `adk:interview` và **TRƯỚC** freeze gate — **KHÔNG đụng hash/freeze/lock** (ngoài việc `project_type` đã set).

## Elicitation (🟢 nhẹ)

- **Brownfield:** recon (mục trên) chạy **TRƯỚC** — bucket ground câu hỏi (adk:interview hỏi dựa trên code thật, không moi từ đầu). **Greenfield:** bỏ qua recon, y flow cũ.
- `adk:interview` _nhẹ_ — thu brief + non-negotiable. Một câu hỏi một lúc, có guess.
- `adk:grill-docs` ở chế độ **capture** (inert — chưa có frozen doc để challenge). Chỉ ghi nhận, chưa vắt.
- Theo `elicitation-contract`: engine chỉ trả text; skill này ghi file.

## Output ghi (repo đích)

1. **Scaffold `docs/`**: tạo cây thư mục —
   ```
   docs/
   ├── CONTEXT.md            # prose thuần — brief + research gộp (out-of-scope c: KHÔNG research doc riêng)
   ├── CONTEXT-archive.md    # rỗng, chờ compact
   ├── PRINCIPLES.md         # sắp freeze
   ├── decisions/            # rỗng
   └── archive/              # rỗng
   ```
2. **`CONTEXT.md`**: brief + research gộp chung (prose thuần, KHÔNG state). **Brownfield:** thêm section "Codebase recon" chứa bucket A/B/C + runbook (parent ghi từ text subagent trả về).
3. **`PIPELINE.lock`**: init (xem side-effect dưới).
4. **`PRINCIPLES.md`**: bullet-list non-negotiable của repo — **giữ NHẸ** (rule 10). Đây là root hash-graph, đừng phình thành phase grill riêng. **Brownfield:** distill CHỈ hard-constraint từ bucket A; **KHÔNG** copy cả recon note vào (giữ nhẹ).

## Gate (freeze PRINCIPLES)

Theo `freeze-protocol` § freeze operation:

1. **Completeness-check** PRINCIPLES: đủ non-negotiable? coherent? (rule 4 — không chỉ "đủ mục" mà nội dung thực sự là ràng buộc repo).
2. Chưa đạt → **KHÔNG mời freeze**.
3. Đạt → **người confirm freeze** → compute `hash` body (bằng tool) → `from_hash: {}` (root, không upstream) → ghi frontmatter → update lock.

## Side-effect `PIPELINE.lock`

Init toàn bộ:

```yaml
lock_version: 1
phase: kickoff
project_type: greenfield # hoặc brownfield (set 1 LẦN ở init, immutable)
decisions: { ux: pending }
flags: { pending_arch_sync: false }
docs:
  - { id: PRINCIPLES, path: docs/PRINCIPLES.md, status: absent }
requirements_version: 0
adr_manifest: {}
archive_versions: []
```

Sau freeze PRINCIPLES → `docs[PRINCIPLES].status = active`, **`phase → product`**.

## Post-phase (rule 6)

- compact `CONTEXT.md` (đẩy phần kết tinh → `CONTEXT-archive.md`, archive-not-delete, conservative). **Brownfield:** GIỮ bucket B/C + runbook **chưa tiêu thụ** (còn dùng ở `/product`, `/architecture`) — đừng compact sớm.
- nhắc `/adr` nếu vừa nảy quyết định lớn.
- gợi ý bước kế: `/product`.
