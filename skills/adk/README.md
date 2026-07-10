# adk (ADR-driven kit) v2 — ADR-first docs-bootstrap + hệ elicitation (thay BMad)

> Tên cũ: `docs-pipeline` (đổi tên 2026-07-10, cùng ngày chuyển từ **freeze-gated** sang **ADR-first**). Gom cả 4 skill vệ tinh elicitation (`interview`, `brainstorm`, `grill`, `grill-docs`) vào cùng package — một nhận diện `adk:*` duy nhất.

**Đảo trục cốt lõi (v2):** `docs/decisions/` (ADR log, append-only) là **nguồn chân lý duy nhất**. `PRINCIPLES.md` / `PRD.md` / `BUSINESS-FLOW.md` / `ARCHITECTURE.md` / `UX-DESIGN.md` / `REQUIREMENTS.md` là **doc dẫn xuất** — render lại được từ tập ADR active, không khoá, không hash, không "freeze". Lý do đổi: chi phí tái sinh doc bằng agent ~0, thứ đắt duy nhất là **quyết định của con người** — nên bảo vệ đúng chỗ đắt (ADR), không xây bộ máy freeze/hash/cascade không enforce nổi cho phần rẻ (doc).

Mức đảm bảo mục tiêu = **workflow discipline ngang Superpowers** — hook best-effort + `git diff`/history + review người. **Không phải** security boundary hay state-machine tuyệt đối.

> Nguồn thiết kế: `docs/workflow-pipeline/SPEC-v2-adr-first.md` (delta trên `SPEC.md` v1 + `WORKFLOW.md`). Package này là implementation của SPEC đó.

## Ranh giới

```
[BOOTSTRAP — chạy 1 lần]
/adk:kickoff → /adk:product → /adk:architecture → /adk:requirements
   mỗi phase: elicit → adk:grill-docs (subagent) → NGƯỜI chốt chùm ADR → render doc dẫn xuất

[VÒNG ĐỜI — lặp vô hạn sau bootstrap]
/adk:adr (ghi quyết định mới / supersede) → render lại doc ảnh hưởng
/adk:docs-check (so ADR active ↔ doc dẫn xuất)      /adk:pivot (pivot batch + render lại từ gốc)
/adk:router (GPS propose-only — hỏi gì cũng được, không tự làm)
        │ handoff
        ▼
[SUPERPOWERS — downstream, ĐÃ CÓ]
writing-plans → executing-plans / subagent-driven-development
```

## Cấu trúc package

```
adk/                                # skills-directory plugin — auto-load qua .claude-plugin/plugin.json
├── .claude-plugin/
│   └── plugin.json                 # name: adk → skill gọi dạng /adk:<name>
├── references/                     # shared — lý do phải là SKILLS không phải commands (rule 1)
│   ├── pipeline-lock-schema.md     #   PIPELINE.lock v2 — con trỏ bootstrap + registry path (KHÔNG state machine)
│   ├── adr-protocol.md             #   đơn vị chân lý — frontmatter ADR, active-set, atomic, affects/supersedes
│   ├── render-protocol.md          #   render doc dẫn xuất — file tạm + diff + confirm; REQUIREMENTS FR/NFR-ID immutable
│   ├── decisions-hook.md           #   template PreToolUse hook per-repo (deny Edit/Write-đè vào docs/decisions/)
│   ├── elicitation-contract.md     #   hợp đồng gọi engine (grill BẮT BUỘC subagent fresh-context)
│   └── codebase-recon.md           #   brownfield: recon read-only → CONTEXT buckets (+ injection guard)
└── skills/
    ├── kickoff/       SKILL.md      # phase 0 (bootstrap) → chùm ADR principle → render PRINCIPLES
    ├── product/       SKILL.md      # phase 1 (bootstrap) → chùm ADR product → render PRD + BUSINESS-FLOW
    ├── architecture/  SKILL.md      # phase 2 (bootstrap) → chùm ADR architecture → render ARCHITECTURE (+ UX-DESIGN)
    ├── requirements/  SKILL.md      # phase 3 (bootstrap, terminal) → render REQUIREMENTS (versioned contract)
    ├── adr/           SKILL.md      # anytime — TRÁI TIM HỆ: ghi ADR append-only + đề nghị render lại doc lệch
    ├── docs-check/    SKILL.md      # anytime — so tập ADR active ↔ derived_from; --force sửa view/body hỏng
    ├── pivot/         SKILL.md      # anytime — escape-hatch: pivot batch ADR + render lại từ gốc
    ├── router/        SKILL.md      # anytime — GPS propose-only, đọc state thật, KHÔNG tự invoke/ghi gì
    ├── agent-rules/   SKILL.md      # đứng cạnh — sinh CLAUDE.md/AGENTS.md (ngoài pipeline)
    ├── interview/     SKILL.md      # vệ tinh — làm rõ intent trước mọi thứ
    ├── brainstorm/    SKILL.md      # vệ tinh — NGOẠI LỆ tường minh, giữ semantics gốc Superpowers (design→spec→writing-plans)
    ├── grill/         SKILL.md      # vệ tinh — chất vấn plan/design; BẮT BUỘC chạy qua subagent khi gọi từ adk
    └── grill-docs/    SKILL.md      # vệ tinh — wrapper: spawn adk:grill (subagent) → parent ghi CONTEXT; CẤM ghi ADR
```

`reconcile` (v1) đã **BỎ** — thay bằng `/adk:adr` (ghi quyết định mới, kể cả sửa gap cục bộ) + `/adk:docs-check` (render lại doc lệch).

Skill được discover dạng **plugin** (`/adk:kickoff` …). Mỗi SKILL.md tham chiếu shared refs qua `../../references/<name>.md` — single-source, không copy-paste protocol.

## Skill sinh gì trong repo ĐÍCH (không phải repo này)

`docs/decisions/`, doc dẫn xuất, `PIPELINE.lock`, `.claude/settings.json` (hook) được skill ghi vào **repo mà user đang đứng** khi chạy skill. Layout: xem SPEC v2 §1, §4.

## Elicitation v2

`adk:interview` lấp KHOẢNG TRỐNG (đầu, chưa có gì) · `adk:grill-docs` vắt VẬT LIỆU (sau, đã có ADR active). `adk:grill-docs` giờ luôn spawn `adk:grill` **như một subagent fresh-context, read-only** — khôi phục epistemic independence (v1 chạy inline, mất sức bẻ). `adk:brainstorm` đứng **ngoài** elicitation-contract — ngoại lệ tường minh giữ nguyên semantics gốc Superpowers.

## Brownfield mode

`/adk:kickoff` detect existing codebase → chạy **recon read-only** (subagent, mượn methodology `codebase-onboarding`, có prompt-injection guard) → ghi 3 bucket vào `CONTEXT.md`: conventions/constraints → ADR `principle` (PRINCIPLES) · domain rules/invariant → ADR `product` (BUSINESS-FLOW) · component/layer/data-flow → ADR `architecture` (ARCHITECTURE) + runbook. `PIPELINE.lock.project_type = brownfield`. Contract: `references/codebase-recon.md`.

## Invariant cốt lõi (v2)

1. Skills, KHÔNG commands — shared `references/`; `description` chặt, explicit-trigger only.
2. **ADR log là chân lý duy nhất** — `docs/decisions/`, append-only, active-set suy từ log (không trường `superseded_by`).
3. **Doc dẫn xuất không khoá** — render qua file tạm + unified diff + human confirm; `derived_from` trace quyết định đã dùng, không hứa byte-for-byte.
4. Gate = **DỪNG THẬT** — mọi điểm người chốt (duyệt ADR, confirm render) có chỉ thị cứng chống auto-answer.
5. `affects` downstream-default theo thứ tự phase; thu hẹp phải có lý do ghi trong ADR.
6. ADR nguyên tử — một file, một quyết định, không partial-supersede/revive ngầm.
7. `adk:grill` BẮT BUỘC subagent fresh-context; `adk:grill-docs`/`adk:interview` CẤM ghi ADR/lock/doc dẫn xuất — chỉ trả text, nhắc `/adk:adr`.
8. UX = doc dẫn xuất CÓ ĐIỀU KIỆN — KHÔNG phải phase riêng; `/adk:architecture` VẪN bắt buộc hỏi.
9. FR/NFR — narrative ở PRD, atomic + ID immutable ở REQUIREMENTS (không renumber/reuse).
10. `lock_version` guard — mọi skill kiểm trước khi đọc/ghi; gặp v1/lạ → DỪNG, không đoán/mutate.
11. Hook `docs/decisions/` = best-effort (không phủ Bash/ngoài Claude Code) — safety net thật là `git diff`/history + review người.

## ⚠️ Shadow-test — hard gate trước rollout (chưa chạy)

SPEC v2 §11 (traceability A-C2) giữ nguyên yêu cầu shadow-test từ v1: feed một `REQUIREMENTS.md` tay-viết vào `superpowers:writing-plans`, đo coverage FR/NFR + có bị re-elicit intent không. **Chạy 1 lần trên repo greenfield nhỏ TRƯỚC khi dùng cho repo thật.** FAIL ⇒ không rollout, quay lại thiết kế contract REQUIREMENTS/render-protocol.
