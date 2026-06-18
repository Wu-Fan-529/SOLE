# SOLE — Chapter 0 (可运行版)

## 如何运行
1. 用 Godot 4.5 打开本项目（`project.godot`）。
2. 首次打开时 Godot 会自动导入占位 PNG，稍等几秒。
3. 直接按 F5 运行。主场景已设为 `scenes/chapter0/IntroBoot.tscn`。

## 流程
IntroBoot (0-0) → MedicalPod_FPV (0-1) → MedicalRoom_2D (0-2) → HospitalCorridor (0-3) → 循环回 0-2（demo 占位结尾）

## 操作
- 移动：WASD / 方向键
- 挣扎（0-1）：狂按 F
- 拾取（0-2）：靠近扳手按 E
- 蹲伏（0-3）：C
- 验证（0-3）：走到走廊中段触发，点选哪个护士是人类（暖橙色那个是人类 = 正确）

## 占位美术（单色像素图，待替换）
- `assets/placeholder/pyx_placeholder.png` 青蓝 — Pyx（当前 Pyx 用的是项目自带 sprite，占位图备用）
- `nurse_a_placeholder.png` 冷白 — AI 护士
- `nurse_b_placeholder.png` 暖橙 — 人类护士
- `wrench_placeholder.png` 黄 — 扳手
- `pod_placeholder.png` / `prop_placeholder.png` — 备用

## 复用的现有系统
- player.tscn / pyx.tscn / hospital_room_tls.tres（在 0-2、0-3 中实例化）
- PhantomCamera2D 跟随相机（复刻 game.tscn 搭法）
- GameInputEvent 输入锁
- IDV_VerificationManager（autoload 单例）+ VerificationProfile
- 0-2、0-3 中把 player 的起始状态从 PodLocked 覆盖为 Idle，使其可自由移动

## Dialogic
`dialogic/timelines/chapter0/*.dtl` 是对话内容草稿。当前脚本为保证开箱即跑，对话用了简单 UI/print；接入 Dialogic 时在对应位置调用 `Dialogic.start("ch0_pyx_intro")` 等，并记得用 GameInputEvent.input_enabled 管理输入时序。

## 已知占位/待办
- 0-0 文字序列、0-1 的 3D 呼吸相机动画可后续用 AnimationPlayer 精修
- 0-1 的医疗舱是简单 BoxMesh，待换真实模型/shader
- 0-3 结尾暂时循环回 0-2，待 RooftopReveal 场景
- 护士对话气泡未实现（数据在 .dtl 里）
