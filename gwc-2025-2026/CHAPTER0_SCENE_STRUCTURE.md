# SOLE – Chapter 0 Scene Structure Reference

Generated to resolve issue: *Define all scenes required for Chapter 0*

---

## File Map

```
scenes/chapter0/
├── IntroBoot.tscn          ← 0-0  animation only, no interaction
├── MedicalPod_FPV.tscn     ← 0-1  3D first-person, QTE struggle
├── MedicalRoom_2D.tscn     ← 0-2  2D gameplay begins, Pyx intro
└── HospitalCorridor.tscn   ← 0-3  stealth + first verification

scripts/chapter0/
├── IntroBoot.gd
├── MedicalPodFPV.gd
├── MedicalRoom.gd
├── HospitalCorridor.gd
├── NurseNPC.gd
├── Pickup.gd
├── InventoryPanel.gd
└── VerificationOverlay.gd
```

---

## Scene Responsibility Summary

| Scene | Root type | Input | Key systems touched |
|---|---|---|---|
| IntroBoot | Node2D | None | AnimationPlayer |
| MedicalPod_FPV | Node3D | QTE only | Struggle loop (self-contained in MedicalPodFPV.gd), Pyx glass-break rescue (Dialogic `ch0_pod_rescue`), CanvasLayer HUD |
| MedicalRoom_2D | Node2D | Full movement | Player, Pyx (intro via Dialogic `ch0_pyx_intro`, then leads player to wrench), Pickup, Inventory |
| HospitalCorridor | Node2D | Movement + Crouch | NurseNPC, VerificationManager, VerificationOverlay |

---

## Linear Transition Chain

```
IntroBoot
  → (animation_finished) → MedicalPod_FPV
  → (struggle complete → Pyx shatters glass + VO → ) → MedicalRoom_2D
  → (exit trigger) → HospitalCorridor
  → (verification complete) → RooftopReveal  ← Ch0 end / Ch1 start
```

All transitions use `get_tree().change_scene_to_file(NEXT_SCENE)`.
`GameInputEvent.input_enabled` is set false/true at each boundary
to prevent input bleed between scenes.

---

## Integration Notes

### Reused from existing codebase (no changes needed)
- `NodeState` / `NodeStateMachine`, `StruggleState` on `player.tscn` – orphaned, never transitioned into; not used by MedicalPod_FPV (its struggle loop lives directly in `MedicalPodFPV.gd`)
- `VerificationProfile` / `VerificationManager` – skeleton already exists
- `GameInputEvent` – static input lock/unlock
- `player.tscn` / `pyx.tscn` – instanced as-is in scenes 0-2 and 0-3
- `hospital_room_tls.tres` – tileset reused across 0-2 and 0-3
- `cam_manager.gd` – Camera2D manager reused in both 2D scenes

### New scripts introduced
| Script | Why new |
|---|---|
| `Pickup.gd` | Generic Area2D pickup, didn't exist |
| `InventoryPanel.gd` | Inventory data layer stub |
| `NurseNPC.gd` | Patrol + dialogue, no existing NPC base |
| `VerificationOverlay.gd` | UI controller separate from game logic |

### Input action to add in Project Settings
- `interact` → E key (for Pickup.gd)
- `crouch`   → C key / LB (for HospitalCorridor.gd)
- `struggle` → already exists in StruggleState

### What is deliberately NOT in these files
- Art assets (sprites, tiles, shaders) – paths are commented placeholders
- AnimationPlayer keyframes – defined in editor, not in .tscn text
- Dialogue system – `trigger_pyx_intro()` and `_advance_dialogue()` are stubs
- RooftopReveal.tscn – Ch0 end scene, out of scope for this issue

---

## Next Steps (after merging this)

1. **Art pass**: assign sprites to Player, Pyx, Nurse_A, Nurse_B nodes
2. **AnimationPlayer setup**: define `boot_sequence`, `awaken`, `sedation`, `pod_open` animations
3. **Tilemap paint**: lay out hospital_room_tls tiles in MedicalRoom and Corridor
4. **Nurse patrol points**: set `patrol_points` export arrays in editor
5. **Audio**: drop in audio streams for breathing, heartbeat, ambience
6. **RooftopReveal.tscn**: Ch0 ending scene (separate issue)
