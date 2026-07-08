# docs-pipeline — bộ 8 skill docs-bootstrap (thay BMad)

Pipeline docs-bootstrap **tuyến tính + freeze-gated**, kết ở `REQUIREMENTS.md` làm contract handoff sang `superpowers:writing-plans`. Giá trị cốt lõi = **kỷ luật** (freeze · single-source · traceability), KHÔNG phải elicitation depth.

> Nguồn thiết kế: `docs/workflow-pipeline/SPEC.md` (+ `WORKFLOW.md`). Package này là implementation của SPEC đó.

## Ranh giới

```
[BỘ NÀY — upstream, freeze-gated docs]
/kickoff → /product → /architecture → /requirements → REQUIREMENTS.md (frozen contract)
   ⇧ elicitation: interview-me · grill-with-docs        (brainstorming ĐÃ BỎ)
   ⟳ anytime: /adr · /reconcile · /pivot                + /agent-rules (đứng cạnh)
        │ handoff
        ▼
[SUPERPOWERS — downstream, ĐÃ CÓ]
writing-plans → executing-plans / subagent-driven-development
```

## Cấu trúc package

```
docs-pipeline/
├── references/                 # shared — lý do phải là SKILLS không phải commands (rule 1)
│   ├── pipeline-lock-schema.md #   state machine-readable (PIPELINE.lock) — nguồn state DUY NHẤT
│   ├── freeze-protocol.md      #   frontmatter hash/from_hash + gate cross-check
│   ├── hash-cascade.md         #   STALE detection + cascade arbitration (topo-order + re-scan)
│   └── elicitation-contract.md #   hợp đồng gọi 2 engine (grill = subagent chỉ-đề-xuất)
├── kickoff/       SKILL.md      # phase 0 → freeze PRINCIPLES
├── product/       SKILL.md      # phase 1 → freeze PRD + BUSINESS-FLOW
├── architecture/  SKILL.md      # phase 2 → freeze ARCHITECTURE (+ UX-DESIGN có điều kiện)
├── requirements/  SKILL.md      # phase 3 (terminal) → freeze REQUIREMENTS (contract)
├── adr/           SKILL.md      # anytime — append-only immutable decision record
├── reconcile/     SKILL.md      # anytime — mở frozen doc sửa gap cục bộ → cascade
├── pivot/         SKILL.md      # anytime — escape-hatch reframe gốc → rewind
└── agent-rules/   SKILL.md      # đứng cạnh — sinh CLAUDE.md/AGENTS.md (ngoài pipeline)
```

Mỗi SKILL.md tham chiếu shared refs qua `../references/<name>.md` — single-source, không copy-paste protocol.

## Skill sinh gì trong repo ĐÍCH (không phải repo này)

Docs pipeline (`docs/…`, `PIPELINE.lock`) được skill ghi vào **repo mà user đang đứng** khi chạy. Layout: xem SPEC §2.

## Engine tái dùng (ngoài package)

`interview-me` + `grill-with-docs` là engine **ngoài** package — tái dùng, không viết lại (`elicitation-contract`). `brainstorming` **ĐÃ BỎ** (chỉ giữ "2-3 approaches" inline).

## 10 invariant (checklist)

1. Skills, KHÔNG commands — shared `references/`; `description` chặt.
2. State một chỗ, machine-readable — `PIPELINE.lock`; CONTEXT = prose thuần.
3. Ba lớp quyền ghi — frozen (chỉ `/reconcile`|`/pivot`) · living · append-only immutable.
4. Gate = người + completeness-check (đủ section VÀ khớp PRINCIPLES) trước freeze.
5. Elicitation = tái dùng + custom mỏng; enforce reuse bằng cấu trúc + backstop hash ADR.
6. Cuối phase 4 việc — freeze · update lock · compact CONTEXT (archive-not-delete) · nhắc `/adr`.
7. UX = sub-artifact có điều kiện — KHÔNG phải phase; `/architecture` VẪN bắt buộc.
8. FR/NFR viết một lần — narrative PRD, atomic REQUIREMENTS.
9. REQUIREMENTS = contract — epic/story = nhãn traceability, KHÔNG phải đơn vị implementation.
10. PRINCIPLES.md = root hash-graph — trong `from_hash` MỌI derived doc; giữ nhẹ.

## ⚠️ Shadow-test (SPEC §7) — CHỦ ĐỘNG SKIP

SPEC §7 quy định Task 0 của PLAN = **shadow-test** (feed một `REQUIREMENTS.md` tay-viết vào `superpowers:writing-plans`, đo 2.1/2.2) và **chỉ build 8 skill khi pass 2.1**.

Bộ này được **build trước khi chạy shadow-test** theo yêu cầu tường minh (2026-07-08). Hệ quả cần nhớ:
- **Cược nền (out-of-scope b: bỏ per-story context)** CHƯA được kiểm chứng. Nếu chạy thử pipeline mà `writing-plans` phải re-elicit intent hoặc plan phủ thiếu FR → SPEC §7 (2.1) FAIL → cần thêm tầng story-context **trước** khi tin dùng.
- **Seam 2.2** (story-slice có làm ranh giới plan không) cũng chưa đo — có thể cần handoff tường minh chỉ thị `writing-plans`.

→ Nên chạy shadow-test 1 lần trên repo greenfield nhỏ **trước khi** dùng cho repo thật.
