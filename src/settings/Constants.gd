extends Node

const FLOOR_NORMAL = Vector2.UP

const SNAP_DIRECTION = Vector2.DOWN
const SNAP_LENGTH = 16.0		# snap length in pixels


# Groups
# -------------------------------------------
const GROUP_PLAYER = "player"
const GROUP_KEY = "key"
const GROUP_DOOR = "door"
const GROUP_TRAP = "trap"
const GROUP_CHECKPOINT = "checkpoint"
const GROUP_KILLABLE_ENEMY = "killable-enemy"

# Masks
# -------------------------------------------
const MASK_PLAYER = 0		# Bit 0

# Checkpoints
# -------------------------------------------
const NO_CHECKPOINT = ""
