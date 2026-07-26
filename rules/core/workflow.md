# Quy trình làm việc (W-rules)

- **W1.** Việc creative (feature / component / behavior mới) → brainstorm chốt spec TRƯỚC khi viết code.
- **W2.** Có spec → viết plan trước khi implement. Gặp bug → systematic-debugging trước khi sửa.
- **W3.** Chỉ sửa trong phạm vi task. Phát hiện việc ngoài scope (refactor tiện tay, lỗi khác) → NÊU RA, không tự làm.
- **W4.** NEVER báo "xong / đã sửa / pass" khi chưa chạy lệnh kiểm chứng (test / typecheck / build / screenshot) và dán output làm bằng chứng.
- **W5.** Commit theo conventional commits có scope — `type(scope): mô tả`. Một commit = một việc trọn vẹn.
- **W6.** Tuân luật branching trong CLAUDE.md: không tự tạo branch; branch (khi được yêu cầu) luôn đi kèm worktree.
- **W7.** Bắt đầu chức năng mới đáng kể → tìm skeleton/foundation battle-tested trước khi tự dựng từ đầu.
- **W8.** Kết thúc task → xoá file thí nghiệm/debug đã tạo; rà các file MỚI theo checklist F-rules.
- **W9.** Lệnh thay đổi trạng thái khó đảo (xoá, reset DB, deploy, migrate) → soát lại bằng chứng có ủng hộ đúng hành động đó không; không chắc → hỏi.
- **W10.** Frontend: tuân `<frontend_gate>` trong CLAUDE.md — chốt IDEA + APPROACH trước khi làm UI.

## Checklist trước khi báo hoàn thành

- [ ] Đã chạy verify và dán output chưa? (W4)
- [ ] Có sửa gì ngoài scope không? (W3)
- [ ] File tạm đã dọn, file mới đã soát F-rules chưa? (W8)
- [ ] Commit message đúng chuẩn chưa? (W5)
