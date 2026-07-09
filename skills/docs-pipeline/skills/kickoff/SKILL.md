---
name: kickoff
description: Phase 0 of the docs-bootstrap pipeline. Bootstrap docs/ scaffold, capture repo non-negotiables into PRINCIPLES.md (root of the hash-graph), gather brief+research into CONTEXT.md, init PIPELINE.lock, and freeze PRINCIPLES. Fires ONLY when the user types /kickoff on a new repo without an existing pipeline.
when_to_use: A new repo, starting the freeze-gated docs pipeline from scratch. Trigger only on explicit /kickoff. If PIPELINE.lock already exists, warn and do not overwrite.
argument-hint: "[brief one-line idea]"
arguments: brief
---

# /kickoff — Phase 0

**Mục đích:** bootstrap scaffold `docs/` + capture non-negotiable của repo + research/brief. Kết bằng **freeze `PRINCIPLES.md`** — root của hash-graph.

Đọc trước: `../../references/pipeline-lock-schema.md` · `../../references/freeze-protocol.md` · `../../references/elicitation-contract.md`.

## Trigger & guard

- Chỉ fire khi user gõ `/kickoff`. **KHÔNG** auto-fire.
- Nếu `PIPELINE.lock` **đã tồn tại** trong repo đích → **cảnh báo + DỪNG**, không ghi đè (pipeline đã chạy rồi).

## Elicitation (🟢 nhẹ)

- `interview-me` *nhẹ* — thu brief + non-negotiable. Một câu hỏi một lúc, có guess.
- `grill-with-docs` ở chế độ **capture** (inert — chưa có frozen doc để challenge). Chỉ ghi nhận, chưa vắt.
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
2. **`CONTEXT.md`**: brief + research gộp chung (prose thuần, KHÔNG state).
3. **`PIPELINE.lock`**: init (xem side-effect dưới).
4. **`PRINCIPLES.md`**: bullet-list non-negotiable của repo — **giữ NHẸ** (rule 10). Đây là root hash-graph, đừng phình thành phase grill riêng.

## Gate (freeze PRINCIPLES)

Theo `freeze-protocol` § freeze operation:
1. **Completeness-check** PRINCIPLES: đủ non-negotiable? coherent? (rule 4 — không chỉ "đủ mục" mà nội dung thực sự là ràng buộc repo).
2. Chưa đạt → **KHÔNG mời freeze**.
3. Đạt → **người confirm freeze** → compute `hash` body → `from_hash: {}` (root, không upstream) → ghi frontmatter → update lock.

## Side-effect `PIPELINE.lock`

Init toàn bộ:
```yaml
lock_version: 1
phase: kickoff
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

- compact `CONTEXT.md` (đẩy phần kết tinh → `CONTEXT-archive.md`, archive-not-delete, conservative).
- nhắc `/adr` nếu vừa nảy quyết định lớn.
- gợi ý bước kế: `/product`.
