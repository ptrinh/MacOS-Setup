# charge-by-location

Tự đổi charge limit của MacBook theo vị trí:

- **Đổi chỗ** (router khác) → sạc **100%** (đang di chuyển, cần pin đầy).
- **Ở yên một chỗ ≥ 24h** → hạ xuống **80%** (cắm sạc lâu, giữ pin).

Vị trí được nhận diện bằng MAC của router (default gateway). LaunchAgent chạy script mỗi giờ và khi đăng nhập.

## Cài đặt

1. Tạo 2 shortcut trong app **Shortcuts**, tên chính xác `Charge 80` và `Charge 100`. Mỗi cái chỉ cần 1 action đặt charge limit (gõ "charge" để tìm), lần lượt 80% và 100%.
2. Chạy:
   ```sh
   ./install.sh
   ```

## Kiểm tra

```sh
launchctl kickstart gui/$(id -u)/com.phil.charge-by-location
cat ~/.charge_loc ~/.charge_loc.log
```

- `~/.charge_loc`: trạng thái hiện tại, dạng `MAC thời_điểm_đến mode`.
- `~/.charge_loc.log`: mỗi lần đổi charge limit ghi một dòng.
- `/tmp/charge-by-location.err`: lỗi (vd. chưa có shortcut).

> **Lưu ý:** chạy script trực tiếp từ một số terminal (vd. Claude Code) có thể không đọc được bảng ARP vì macOS ẩn đi (Local Network privacy) → script giữ nguyên trạng thái. Dùng `launchctl kickstart` như trên để test.

## Gỡ

```sh
launchctl bootout gui/$(id -u)/com.phil.charge-by-location
rm ~/Library/LaunchAgents/com.phil.charge-by-location.plist ~/.local/bin/charge-by-location.sh ~/.charge_loc ~/.charge_loc.log
```
