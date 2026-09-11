# Linear — quy trình solo dev với agent

Áp dụng khi làm việc với workspace `mxrsv`. Đây là nguồn luật vận hành chung; template và hướng dẫn cấu hình chi tiết có thể ở Linear. Không cần gọi MCP chỉ để đọc lại luật này. Chỉ thị hiện hành của người dùng và giới hạn quyền của công cụ luôn được ưu tiên.

## Chọn và nhận việc

- **LW1.** Người dùng làm việc qua hội thoại; agent quản lý issue. Dùng Linear MCP cho thao tác được hỗ trợ. Chỉ dùng Computer Use khi người dùng yêu cầu rõ trong công việc hiện tại; MCP thiếu chức năng không tự cấp quyền dùng Computer Use. Đọc issue và comment quyết định trước khi sửa; kiểm tra lại trạng thái trước khi ghi, giữ metadata không thuộc phạm vi thay đổi.
- **LW2.** Người dùng chốt mục tiêu tuần và duyệt tập việc một lần. Agent tự kéo thêm việc nhỏ, rõ, cùng mục tiêu; việc ngoài mục tiêu vào Backlog, điều chưa rõ gắn `Needs decision` và hỏi. Thay đổi hướng sản phẩm, mở rộng phạm vi hoặc phát sinh chi phí cần duyệt.
- **LW3.** Khi bắt đầu phiên hoặc được giao lập kế hoạch ngày: xem việc đang giữ và Blocked trước, rồi tự chọn tập việc khả thi trong mục tiêu tuần, nêu kết quả dự kiến và làm tiếp. Today là tập issue được chọn, không bắt người dùng tạo issue “Today”; không tạo bản sao issue, nhật ký ngày hoặc dùng due date giả để biểu diễn kế hoạch. Lịch tự chạy và cách lưu tập Today phải được cấu hình riêng; file luật không tạo scheduler.
- **LW4.** Mỗi phiên chỉ thực thi một issue tại một thời điểm; được nhận việc tiếp khi issue trước chờ review hoặc Blocked. Không giới hạn tổng số issue chờ review; các phiên khác được làm song song. Ưu tiên xử lý blocker đã được gỡ, không lặp câu hỏi cũ khi chưa có thông tin mới.
- **LW5.** Assignee giữ `mxrsv`. Trước khi làm, kiểm tra comment nhận việc; ghi agent, mã phiên và thời gian có múi giờ, rồi đọc lại để phát hiện tranh chấp. Comment/status không phải khóa nguyên tử: có chủ khác thì phối hợp, không giành việc theo tuổi comment. Chỉ tiếp quản khi xác nhận phiên cũ đã dừng và đọc bàn giao.
- **LW6.** Bàn giao ghi tiến độ, worktree/branch/PR, kiểm chứng đã chạy, việc tiếp theo hoặc blocker và việc nhả quyền xử lý. Không tự chuyển issue giữa team để điều phối agent.

## Phân loại và quyền quyết định

- **LW7.** Mỗi issue công việc có đúng một Type: `Bug`, `Feature`, `Improvement`, `Maintenance` hoặc `Verification`. Bổ sung acceptance criteria từ ngữ cảnh chắc chắn; nếu chưa rõ kết quả mong muốn thì hỏi trước khi triển khai. Không sửa issue Done/Canceled chỉ để bổ sung label.
- **LW8.** Trước khi sửa code, chọn đúng một Impact: `Hạn chế` (hậu quả cục bộ, dễ phục hồi), `Đáng kể` (ảnh hưởng nhiều luồng/module, cần kiểm chứng rộng), `Nghiêm trọng` (nguy cơ dữ liệu, bảo mật, vận hành hoặc khó phục hồi). Impact đo hậu quả nếu sai, Priority đo độ khẩn cấp; thiếu Impact không có nghĩa là an toàn. Đánh giá lại khi phát hiện rủi ro mới.
- **LW9.** Impact `Nghiêm trọng`: được điều tra trước; phải trình cách làm, kiểm chứng và phục hồi, chờ người dùng duyệt trong hội thoại trước khi sửa, kể cả bug Urgent. Đổi đáng kể khỏi phương án đã duyệt thì xin duyệt lại; quyết định nhỏ, đảo được, trong phạm vi thì tự làm.
- **LW10.** Sự cố mất dữ liệu hoặc chức năng chính không dùng được có thể chen trước mục tiêu tuần; báo ngay cho người dùng. Không dùng nhãn Urgent để bỏ qua duyệt Impact hoặc giới hạn quyền. Không tự đổi hàng loạt priority để đạt chỉ tiêu số lượng.

## Review, merge và hoàn thành

- **LW11.** Luồng làm việc: `Backlog` → `Todo` → `In Progress` → `Ready for Review` → `Done`; dùng `Blocked` khi không thể tiến tiếp. Đọc trạng thái thực tế của team; nếu thiếu trạng thái chuẩn thì báo thiếu, không tự giả định đã cấu hình.
- **LW12.** Agent xong phần triển khai: ghi kết quả, bằng chứng kiểm chứng, link PR/artifact và điều cần người dùng duyệt; chuyển `Ready for Review`. Người dùng duyệt trong hội thoại; agent ghi lại phạm vi chấp thuận trên issue rồi merge khi các kiểm chứng và quyền cần thiết đã đủ. Có yêu cầu sửa thì ghi phản hồi, về `In Progress`, sửa và kiểm chứng lại trước khi gửi review.
- **LW13.** Ngoại lệ đã cho phép: bản sửa bug Urgent có thể tự merge sau kiểm chứng nếu đã xác minh merge không kích hoạt deploy/release. Không chắc tác động của merge thì hỏi. Deploy/release vẫn cần người dùng duyệt; LW9 vẫn áp dụng. Không xem quyền quản lý Linear là quyền bỏ qua các gate của repo hay công cụ.
- **LW14.** Chỉ `Done` khi acceptance criteria và các lượt duyệt bắt buộc đã đủ; PR merge không tự đồng nghĩa Done. Đang kiểm chứng thì `In Progress`, chờ deploy hoặc điều kiện bên ngoài thì `Blocked` kèm lý do. Không bật tự đóng issue theo PR merge nếu làm mất gate này. Kế hoạch ngày phân biệt “agent xong, chờ duyệt” với Done; không hứa thay phần duyệt của người dùng.
- **LW15.** Cuối phiên báo gọn kết quả, bằng chứng, blocker và việc chờ duyệt. Ngắt ngay khi có sự cố khẩn hoặc quyết định chặn tiến độ; thông báo thông thường gom lại. Không tự mở kênh gửi tin ngoài hội thoại khi chưa được cho phép.

## Giữ workspace nhất quán

- **LW16.** Giữ nguyên các team hiện tại; không gộp/xóa team, chuyển issue giữa team hoặc archive project trong phạm vi cấu hình này. Issue mới theo sản phẩm; Mxrsv dành cho việc chung/cross-product và làm team tham chiếu cấu hình cho team mới. Không tự tạo team chỉ vì có repo hoặc agent mới.
- **LW17.** Không xóa issue hoặc tự hủy vì lâu không hoạt động. Duplicate phải liên kết issue chuẩn; hủy việc người dùng đã giao cần được duyệt. Báo cáo agent đặt trong comment issue liên quan; chỉ tạo issue cho hành động cần làm, giữ các issue `Agent report` cũ.
- **LW18.** Các tên status/label ở đây là quy chuẩn đã chốt, không phải bằng chứng workspace đã được cập nhật. Thay đổi cấu hình chỉ trong phạm vi được giao; với UI phải chụp trước/sau, dừng hỏi khi giao diện khác mô tả. Không tự đặt target date, lịch chạy, hay mở rộng quyền tích hợp còn chờ quyết định.
