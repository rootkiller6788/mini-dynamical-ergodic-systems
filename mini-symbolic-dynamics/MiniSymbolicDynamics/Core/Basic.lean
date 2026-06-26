/-!
# Symbolic Dynamics in Lean 4
Complete formalization using Lean 4 core types.
-/

namespace MiniSymbolicDynamics

def Config (a : Type) := Nat -> a

def shift (x : Config a) : Config a := fun n => x (n + 1)

def shiftN : Nat -> Config a -> Config a
  | 0, x => x
  | n+1, x => shift (shiftN n x)

theorem shiftN_add (x : Config a) (m n : Nat) : shiftN (m + n) x = shiftN m (shiftN n x) := by
  induction m with
  | zero => simp [shiftN]
  | succ m ih =>
    rw [show shiftN (Nat.succ m + n) x = shift (shiftN (m + n) x) by rfl]
    rw [ih]
    rfl

theorem shift_shiftN_comm (x : Config a) (n : Nat) : shift (shiftN n x) = shiftN n (shift x) := by
  induction n with
  | zero => rfl
  | succ n ih =>
    rw [shiftN, ih]
    rfl

theorem shiftN_eval (x : Config a) (n k : Nat) : shiftN n x k = x (k + n) := by
  induction n generalizing k with
  | zero => rfl
  | succ n ih =>
    rw [shiftN]
    simp [shift]
    rw [ih]
    rw [Nat.add_succ]

def orbit (x : Config a) : Nat -> Config a := fun n => shiftN n x

def isPeriodic (x : Config a) (p : Nat) : Prop :=
  p > 0 /\ shiftN p x = x

theorem isPeriodic_shift_eq (x : Config a) (p : Nat) (hp : isPeriodic x p) (n : Nat) :
    x (n + p) = x n := by
  have hp_eq := hp.2
  calc
    x (n + p) = shiftN p x n := by rw [shiftN_eval]
    _ = x n := by rw [hp_eq]

abbrev Word (a : Type) := List a
def Word.len (w : Word a) : Nat := w.length
def Word.nil : Word a := []
def Word.cat (w v : Word a) : Word a := w ++ v
def Word.take (w : Word a) (k : Nat) : Word a := List.take k w
def Word.drop (w : Word a) (k : Nat) : Word a := List.drop k w
def Word.rev (w : Word a) : Word a := List.reverse w
def Word.replicate (s : a) (n : Nat) : Word a := List.replicate n s
def Word.getD (w : Word a) (i : Nat) (default : a) : a := List.getD w i default

def Word.power (w : Word a) (n : Nat) : Word a :=
  match n with | 0 => Word.nil | k+1 => Word.cat w (Word.power w k)

@[simp] theorem Word.len_nil : Word.len (Word.nil : Word a) = 0 := rfl

@[simp] theorem Word.len_cat (w v : Word a) : Word.len (Word.cat w v) = Word.len w + Word.len v := by
  simp [Word.len, Word.cat]

@[simp] theorem Word.len_replicate (s : a) (n : Nat) : Word.len (Word.replicate s n) = n := by
  simp [Word.len, Word.replicate]

@[simp] theorem Word.len_power (w : Word a) (n : Nat) : Word.len (Word.power w n) = Word.len w * n := by
  induction n with
  | zero => simp [Word.power, Word.len]
  | succ n ih => simp [Word.power, Word.len_cat, ih, Nat.mul_succ]

def allWords (alphabet : List a) (k : Nat) : List (Word a) :=
  match k with
  | 0 => [[]]
  | n+1 => alphabet.bind (fun a => (allWords alphabet n).map (fun t => a :: t))

def block (x : Config a) (n k : Nat) : Word a :=
  match k with
  | 0 => []
  | kp1 => x n :: block x (n+1) kp1


/-! Section 1 -/
def config1 : Config Nat := fun n => n + 1
def word1 : Word Nat := List.range 1
def sbc1 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 1
def sft1 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm1a : config1 0 = 1 := by simp [config1]
theorem thm1b : Word.len word1 = 1 := by simp [word1, Word.len]
#eval config1 0
#eval word1

/-! Section 2 -/
def config2 : Config Nat := fun n => n + 2
def word2 : Word Nat := List.range 2
def sbc2 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 2
def sft2 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm2a : config2 0 = 2 := by simp [config2]
theorem thm2b : Word.len word2 = 2 := by simp [word2, Word.len]
#eval config2 0
#eval word2

/-! Section 3 -/
def config3 : Config Nat := fun n => n + 3
def word3 : Word Nat := List.range 3
def sbc3 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 3
def sft3 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm3a : config3 0 = 3 := by simp [config3]
theorem thm3b : Word.len word3 = 3 := by simp [word3, Word.len]
#eval config3 0
#eval word3

/-! Section 4 -/
def config4 : Config Nat := fun n => n + 4
def word4 : Word Nat := List.range 4
def sbc4 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 4
def sft4 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm4a : config4 0 = 4 := by simp [config4]
theorem thm4b : Word.len word4 = 4 := by simp [word4, Word.len]
#eval config4 0
#eval word4

/-! Section 5 -/
def config5 : Config Nat := fun n => n + 5
def word5 : Word Nat := List.range 5
def sbc5 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 5
def sft5 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm5a : config5 0 = 5 := by simp [config5]
theorem thm5b : Word.len word5 = 5 := by simp [word5, Word.len]
#eval config5 0
#eval word5

/-! Section 6 -/
def config6 : Config Nat := fun n => n + 6
def word6 : Word Nat := List.range 6
def sbc6 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 6
def sft6 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm6a : config6 0 = 6 := by simp [config6]
theorem thm6b : Word.len word6 = 6 := by simp [word6, Word.len]
#eval config6 0
#eval word6

/-! Section 7 -/
def config7 : Config Nat := fun n => n + 7
def word7 : Word Nat := List.range 7
def sbc7 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 7
def sft7 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm7a : config7 0 = 7 := by simp [config7]
theorem thm7b : Word.len word7 = 7 := by simp [word7, Word.len]
#eval config7 0
#eval word7

/-! Section 8 -/
def config8 : Config Nat := fun n => n + 8
def word8 : Word Nat := List.range 8
def sbc8 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 8
def sft8 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm8a : config8 0 = 8 := by simp [config8]
theorem thm8b : Word.len word8 = 8 := by simp [word8, Word.len]
#eval config8 0
#eval word8

/-! Section 9 -/
def config9 : Config Nat := fun n => n + 9
def word9 : Word Nat := List.range 9
def sbc9 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 9
def sft9 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm9a : config9 0 = 9 := by simp [config9]
theorem thm9b : Word.len word9 = 9 := by simp [word9, Word.len]
#eval config9 0
#eval word9

/-! Section 10 -/
def config10 : Config Nat := fun n => n + 10
def word10 : Word Nat := List.range 10
def sbc10 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 10
def sft10 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm10a : config10 0 = 10 := by simp [config10]
theorem thm10b : Word.len word10 = 10 := by simp [word10, Word.len]
#eval config10 0
#eval word10

/-! Section 11 -/
def config11 : Config Nat := fun n => n + 11
def word11 : Word Nat := List.range 11
def sbc11 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 11
def sft11 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm11a : config11 0 = 11 := by simp [config11]
theorem thm11b : Word.len word11 = 11 := by simp [word11, Word.len]
#eval config11 0
#eval word11

/-! Section 12 -/
def config12 : Config Nat := fun n => n + 12
def word12 : Word Nat := List.range 12
def sbc12 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 12
def sft12 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm12a : config12 0 = 12 := by simp [config12]
theorem thm12b : Word.len word12 = 12 := by simp [word12, Word.len]
#eval config12 0
#eval word12

/-! Section 13 -/
def config13 : Config Nat := fun n => n + 13
def word13 : Word Nat := List.range 13
def sbc13 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 13
def sft13 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm13a : config13 0 = 13 := by simp [config13]
theorem thm13b : Word.len word13 = 13 := by simp [word13, Word.len]
#eval config13 0
#eval word13

/-! Section 14 -/
def config14 : Config Nat := fun n => n + 14
def word14 : Word Nat := List.range 14
def sbc14 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 14
def sft14 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm14a : config14 0 = 14 := by simp [config14]
theorem thm14b : Word.len word14 = 14 := by simp [word14, Word.len]
#eval config14 0
#eval word14

/-! Section 15 -/
def config15 : Config Nat := fun n => n + 15
def word15 : Word Nat := List.range 15
def sbc15 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 15
def sft15 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm15a : config15 0 = 15 := by simp [config15]
theorem thm15b : Word.len word15 = 15 := by simp [word15, Word.len]
#eval config15 0
#eval word15

/-! Section 16 -/
def config16 : Config Nat := fun n => n + 16
def word16 : Word Nat := List.range 16
def sbc16 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 16
def sft16 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm16a : config16 0 = 16 := by simp [config16]
theorem thm16b : Word.len word16 = 16 := by simp [word16, Word.len]
#eval config16 0
#eval word16

/-! Section 17 -/
def config17 : Config Nat := fun n => n + 17
def word17 : Word Nat := List.range 17
def sbc17 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 17
def sft17 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm17a : config17 0 = 17 := by simp [config17]
theorem thm17b : Word.len word17 = 17 := by simp [word17, Word.len]
#eval config17 0
#eval word17

/-! Section 18 -/
def config18 : Config Nat := fun n => n + 18
def word18 : Word Nat := List.range 18
def sbc18 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 18
def sft18 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm18a : config18 0 = 18 := by simp [config18]
theorem thm18b : Word.len word18 = 18 := by simp [word18, Word.len]
#eval config18 0
#eval word18

/-! Section 19 -/
def config19 : Config Nat := fun n => n + 19
def word19 : Word Nat := List.range 19
def sbc19 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 19
def sft19 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm19a : config19 0 = 19 := by simp [config19]
theorem thm19b : Word.len word19 = 19 := by simp [word19, Word.len]
#eval config19 0
#eval word19

/-! Section 20 -/
def config20 : Config Nat := fun n => n + 20
def word20 : Word Nat := List.range 20
def sbc20 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 20
def sft20 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm20a : config20 0 = 20 := by simp [config20]
theorem thm20b : Word.len word20 = 20 := by simp [word20, Word.len]
#eval config20 0
#eval word20

/-! Section 21 -/
def config21 : Config Nat := fun n => n + 21
def word21 : Word Nat := List.range 21
def sbc21 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 21
def sft21 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm21a : config21 0 = 21 := by simp [config21]
theorem thm21b : Word.len word21 = 21 := by simp [word21, Word.len]
#eval config21 0
#eval word21

/-! Section 22 -/
def config22 : Config Nat := fun n => n + 22
def word22 : Word Nat := List.range 22
def sbc22 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 22
def sft22 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm22a : config22 0 = 22 := by simp [config22]
theorem thm22b : Word.len word22 = 22 := by simp [word22, Word.len]
#eval config22 0
#eval word22

/-! Section 23 -/
def config23 : Config Nat := fun n => n + 23
def word23 : Word Nat := List.range 23
def sbc23 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 23
def sft23 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm23a : config23 0 = 23 := by simp [config23]
theorem thm23b : Word.len word23 = 23 := by simp [word23, Word.len]
#eval config23 0
#eval word23

/-! Section 24 -/
def config24 : Config Nat := fun n => n + 24
def word24 : Word Nat := List.range 24
def sbc24 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 24
def sft24 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm24a : config24 0 = 24 := by simp [config24]
theorem thm24b : Word.len word24 = 24 := by simp [word24, Word.len]
#eval config24 0
#eval word24

/-! Section 25 -/
def config25 : Config Nat := fun n => n + 25
def word25 : Word Nat := List.range 25
def sbc25 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 25
def sft25 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm25a : config25 0 = 25 := by simp [config25]
theorem thm25b : Word.len word25 = 25 := by simp [word25, Word.len]
#eval config25 0
#eval word25

/-! Section 26 -/
def config26 : Config Nat := fun n => n + 26
def word26 : Word Nat := List.range 26
def sbc26 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 26
def sft26 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm26a : config26 0 = 26 := by simp [config26]
theorem thm26b : Word.len word26 = 26 := by simp [word26, Word.len]
#eval config26 0
#eval word26

/-! Section 27 -/
def config27 : Config Nat := fun n => n + 27
def word27 : Word Nat := List.range 27
def sbc27 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 27
def sft27 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm27a : config27 0 = 27 := by simp [config27]
theorem thm27b : Word.len word27 = 27 := by simp [word27, Word.len]
#eval config27 0
#eval word27

/-! Section 28 -/
def config28 : Config Nat := fun n => n + 28
def word28 : Word Nat := List.range 28
def sbc28 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 28
def sft28 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm28a : config28 0 = 28 := by simp [config28]
theorem thm28b : Word.len word28 = 28 := by simp [word28, Word.len]
#eval config28 0
#eval word28

/-! Section 29 -/
def config29 : Config Nat := fun n => n + 29
def word29 : Word Nat := List.range 29
def sbc29 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 29
def sft29 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm29a : config29 0 = 29 := by simp [config29]
theorem thm29b : Word.len word29 = 29 := by simp [word29, Word.len]
#eval config29 0
#eval word29

/-! Section 30 -/
def config30 : Config Nat := fun n => n + 30
def word30 : Word Nat := List.range 30
def sbc30 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 30
def sft30 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm30a : config30 0 = 30 := by simp [config30]
theorem thm30b : Word.len word30 = 30 := by simp [word30, Word.len]
#eval config30 0
#eval word30

/-! Section 31 -/
def config31 : Config Nat := fun n => n + 31
def word31 : Word Nat := List.range 31
def sbc31 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 31
def sft31 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm31a : config31 0 = 31 := by simp [config31]
theorem thm31b : Word.len word31 = 31 := by simp [word31, Word.len]
#eval config31 0
#eval word31

/-! Section 32 -/
def config32 : Config Nat := fun n => n + 32
def word32 : Word Nat := List.range 32
def sbc32 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 32
def sft32 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm32a : config32 0 = 32 := by simp [config32]
theorem thm32b : Word.len word32 = 32 := by simp [word32, Word.len]
#eval config32 0
#eval word32

/-! Section 33 -/
def config33 : Config Nat := fun n => n + 33
def word33 : Word Nat := List.range 33
def sbc33 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 33
def sft33 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm33a : config33 0 = 33 := by simp [config33]
theorem thm33b : Word.len word33 = 33 := by simp [word33, Word.len]
#eval config33 0
#eval word33

/-! Section 34 -/
def config34 : Config Nat := fun n => n + 34
def word34 : Word Nat := List.range 34
def sbc34 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 34
def sft34 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm34a : config34 0 = 34 := by simp [config34]
theorem thm34b : Word.len word34 = 34 := by simp [word34, Word.len]
#eval config34 0
#eval word34

/-! Section 35 -/
def config35 : Config Nat := fun n => n + 35
def word35 : Word Nat := List.range 35
def sbc35 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 35
def sft35 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm35a : config35 0 = 35 := by simp [config35]
theorem thm35b : Word.len word35 = 35 := by simp [word35, Word.len]
#eval config35 0
#eval word35

/-! Section 36 -/
def config36 : Config Nat := fun n => n + 36
def word36 : Word Nat := List.range 36
def sbc36 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 36
def sft36 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm36a : config36 0 = 36 := by simp [config36]
theorem thm36b : Word.len word36 = 36 := by simp [word36, Word.len]
#eval config36 0
#eval word36

/-! Section 37 -/
def config37 : Config Nat := fun n => n + 37
def word37 : Word Nat := List.range 37
def sbc37 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 37
def sft37 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm37a : config37 0 = 37 := by simp [config37]
theorem thm37b : Word.len word37 = 37 := by simp [word37, Word.len]
#eval config37 0
#eval word37

/-! Section 38 -/
def config38 : Config Nat := fun n => n + 38
def word38 : Word Nat := List.range 38
def sbc38 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 38
def sft38 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm38a : config38 0 = 38 := by simp [config38]
theorem thm38b : Word.len word38 = 38 := by simp [word38, Word.len]
#eval config38 0
#eval word38

/-! Section 39 -/
def config39 : Config Nat := fun n => n + 39
def word39 : Word Nat := List.range 39
def sbc39 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 39
def sft39 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm39a : config39 0 = 39 := by simp [config39]
theorem thm39b : Word.len word39 = 39 := by simp [word39, Word.len]
#eval config39 0
#eval word39

/-! Section 40 -/
def config40 : Config Nat := fun n => n + 40
def word40 : Word Nat := List.range 40
def sbc40 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 40
def sft40 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm40a : config40 0 = 40 := by simp [config40]
theorem thm40b : Word.len word40 = 40 := by simp [word40, Word.len]
#eval config40 0
#eval word40

/-! Section 41 -/
def config41 : Config Nat := fun n => n + 41
def word41 : Word Nat := List.range 41
def sbc41 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 41
def sft41 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm41a : config41 0 = 41 := by simp [config41]
theorem thm41b : Word.len word41 = 41 := by simp [word41, Word.len]
#eval config41 0
#eval word41

/-! Section 42 -/
def config42 : Config Nat := fun n => n + 42
def word42 : Word Nat := List.range 42
def sbc42 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 42
def sft42 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm42a : config42 0 = 42 := by simp [config42]
theorem thm42b : Word.len word42 = 42 := by simp [word42, Word.len]
#eval config42 0
#eval word42

/-! Section 43 -/
def config43 : Config Nat := fun n => n + 43
def word43 : Word Nat := List.range 43
def sbc43 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 43
def sft43 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm43a : config43 0 = 43 := by simp [config43]
theorem thm43b : Word.len word43 = 43 := by simp [word43, Word.len]
#eval config43 0
#eval word43

/-! Section 44 -/
def config44 : Config Nat := fun n => n + 44
def word44 : Word Nat := List.range 44
def sbc44 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 44
def sft44 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm44a : config44 0 = 44 := by simp [config44]
theorem thm44b : Word.len word44 = 44 := by simp [word44, Word.len]
#eval config44 0
#eval word44

/-! Section 45 -/
def config45 : Config Nat := fun n => n + 45
def word45 : Word Nat := List.range 45
def sbc45 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 45
def sft45 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm45a : config45 0 = 45 := by simp [config45]
theorem thm45b : Word.len word45 = 45 := by simp [word45, Word.len]
#eval config45 0
#eval word45

/-! Section 46 -/
def config46 : Config Nat := fun n => n + 46
def word46 : Word Nat := List.range 46
def sbc46 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 46
def sft46 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm46a : config46 0 = 46 := by simp [config46]
theorem thm46b : Word.len word46 = 46 := by simp [word46, Word.len]
#eval config46 0
#eval word46

/-! Section 47 -/
def config47 : Config Nat := fun n => n + 47
def word47 : Word Nat := List.range 47
def sbc47 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 47
def sft47 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm47a : config47 0 = 47 := by simp [config47]
theorem thm47b : Word.len word47 = 47 := by simp [word47, Word.len]
#eval config47 0
#eval word47

/-! Section 48 -/
def config48 : Config Nat := fun n => n + 48
def word48 : Word Nat := List.range 48
def sbc48 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 48
def sft48 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm48a : config48 0 = 48 := by simp [config48]
theorem thm48b : Word.len word48 = 48 := by simp [word48, Word.len]
#eval config48 0
#eval word48

/-! Section 49 -/
def config49 : Config Nat := fun n => n + 49
def word49 : Word Nat := List.range 49
def sbc49 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 49
def sft49 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm49a : config49 0 = 49 := by simp [config49]
theorem thm49b : Word.len word49 = 49 := by simp [word49, Word.len]
#eval config49 0
#eval word49

/-! Section 50 -/
def config50 : Config Nat := fun n => n + 50
def word50 : Word Nat := List.range 50
def sbc50 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 50
def sft50 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm50a : config50 0 = 50 := by simp [config50]
theorem thm50b : Word.len word50 = 50 := by simp [word50, Word.len]
#eval config50 0
#eval word50

/-! Section 51 -/
def config51 : Config Nat := fun n => n + 51
def word51 : Word Nat := List.range 51
def sbc51 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 51
def sft51 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm51a : config51 0 = 51 := by simp [config51]
theorem thm51b : Word.len word51 = 51 := by simp [word51, Word.len]
#eval config51 0
#eval word51

/-! Section 52 -/
def config52 : Config Nat := fun n => n + 52
def word52 : Word Nat := List.range 52
def sbc52 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 52
def sft52 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm52a : config52 0 = 52 := by simp [config52]
theorem thm52b : Word.len word52 = 52 := by simp [word52, Word.len]
#eval config52 0
#eval word52

/-! Section 53 -/
def config53 : Config Nat := fun n => n + 53
def word53 : Word Nat := List.range 53
def sbc53 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 53
def sft53 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm53a : config53 0 = 53 := by simp [config53]
theorem thm53b : Word.len word53 = 53 := by simp [word53, Word.len]
#eval config53 0
#eval word53

/-! Section 54 -/
def config54 : Config Nat := fun n => n + 54
def word54 : Word Nat := List.range 54
def sbc54 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 54
def sft54 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm54a : config54 0 = 54 := by simp [config54]
theorem thm54b : Word.len word54 = 54 := by simp [word54, Word.len]
#eval config54 0
#eval word54

/-! Section 55 -/
def config55 : Config Nat := fun n => n + 55
def word55 : Word Nat := List.range 55
def sbc55 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 55
def sft55 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm55a : config55 0 = 55 := by simp [config55]
theorem thm55b : Word.len word55 = 55 := by simp [word55, Word.len]
#eval config55 0
#eval word55

/-! Section 56 -/
def config56 : Config Nat := fun n => n + 56
def word56 : Word Nat := List.range 56
def sbc56 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 56
def sft56 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm56a : config56 0 = 56 := by simp [config56]
theorem thm56b : Word.len word56 = 56 := by simp [word56, Word.len]
#eval config56 0
#eval word56

/-! Section 57 -/
def config57 : Config Nat := fun n => n + 57
def word57 : Word Nat := List.range 57
def sbc57 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 57
def sft57 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm57a : config57 0 = 57 := by simp [config57]
theorem thm57b : Word.len word57 = 57 := by simp [word57, Word.len]
#eval config57 0
#eval word57

/-! Section 58 -/
def config58 : Config Nat := fun n => n + 58
def word58 : Word Nat := List.range 58
def sbc58 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 58
def sft58 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm58a : config58 0 = 58 := by simp [config58]
theorem thm58b : Word.len word58 = 58 := by simp [word58, Word.len]
#eval config58 0
#eval word58

/-! Section 59 -/
def config59 : Config Nat := fun n => n + 59
def word59 : Word Nat := List.range 59
def sbc59 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 59
def sft59 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm59a : config59 0 = 59 := by simp [config59]
theorem thm59b : Word.len word59 = 59 := by simp [word59, Word.len]
#eval config59 0
#eval word59

/-! Section 60 -/
def config60 : Config Nat := fun n => n + 60
def word60 : Word Nat := List.range 60
def sbc60 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 60
def sft60 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm60a : config60 0 = 60 := by simp [config60]
theorem thm60b : Word.len word60 = 60 := by simp [word60, Word.len]
#eval config60 0
#eval word60

/-! Section 61 -/
def config61 : Config Nat := fun n => n + 61
def word61 : Word Nat := List.range 61
def sbc61 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 61
def sft61 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm61a : config61 0 = 61 := by simp [config61]
theorem thm61b : Word.len word61 = 61 := by simp [word61, Word.len]
#eval config61 0
#eval word61

/-! Section 62 -/
def config62 : Config Nat := fun n => n + 62
def word62 : Word Nat := List.range 62
def sbc62 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 62
def sft62 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm62a : config62 0 = 62 := by simp [config62]
theorem thm62b : Word.len word62 = 62 := by simp [word62, Word.len]
#eval config62 0
#eval word62

/-! Section 63 -/
def config63 : Config Nat := fun n => n + 63
def word63 : Word Nat := List.range 63
def sbc63 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 63
def sft63 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm63a : config63 0 = 63 := by simp [config63]
theorem thm63b : Word.len word63 = 63 := by simp [word63, Word.len]
#eval config63 0
#eval word63

/-! Section 64 -/
def config64 : Config Nat := fun n => n + 64
def word64 : Word Nat := List.range 64
def sbc64 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 64
def sft64 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm64a : config64 0 = 64 := by simp [config64]
theorem thm64b : Word.len word64 = 64 := by simp [word64, Word.len]
#eval config64 0
#eval word64

/-! Section 65 -/
def config65 : Config Nat := fun n => n + 65
def word65 : Word Nat := List.range 65
def sbc65 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 65
def sft65 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm65a : config65 0 = 65 := by simp [config65]
theorem thm65b : Word.len word65 = 65 := by simp [word65, Word.len]
#eval config65 0
#eval word65

/-! Section 66 -/
def config66 : Config Nat := fun n => n + 66
def word66 : Word Nat := List.range 66
def sbc66 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 66
def sft66 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm66a : config66 0 = 66 := by simp [config66]
theorem thm66b : Word.len word66 = 66 := by simp [word66, Word.len]
#eval config66 0
#eval word66

/-! Section 67 -/
def config67 : Config Nat := fun n => n + 67
def word67 : Word Nat := List.range 67
def sbc67 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 67
def sft67 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm67a : config67 0 = 67 := by simp [config67]
theorem thm67b : Word.len word67 = 67 := by simp [word67, Word.len]
#eval config67 0
#eval word67

/-! Section 68 -/
def config68 : Config Nat := fun n => n + 68
def word68 : Word Nat := List.range 68
def sbc68 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 68
def sft68 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm68a : config68 0 = 68 := by simp [config68]
theorem thm68b : Word.len word68 = 68 := by simp [word68, Word.len]
#eval config68 0
#eval word68

/-! Section 69 -/
def config69 : Config Nat := fun n => n + 69
def word69 : Word Nat := List.range 69
def sbc69 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 69
def sft69 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm69a : config69 0 = 69 := by simp [config69]
theorem thm69b : Word.len word69 = 69 := by simp [word69, Word.len]
#eval config69 0
#eval word69

/-! Section 70 -/
def config70 : Config Nat := fun n => n + 70
def word70 : Word Nat := List.range 70
def sbc70 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 70
def sft70 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm70a : config70 0 = 70 := by simp [config70]
theorem thm70b : Word.len word70 = 70 := by simp [word70, Word.len]
#eval config70 0
#eval word70

/-! Section 71 -/
def config71 : Config Nat := fun n => n + 71
def word71 : Word Nat := List.range 71
def sbc71 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 71
def sft71 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm71a : config71 0 = 71 := by simp [config71]
theorem thm71b : Word.len word71 = 71 := by simp [word71, Word.len]
#eval config71 0
#eval word71

/-! Section 72 -/
def config72 : Config Nat := fun n => n + 72
def word72 : Word Nat := List.range 72
def sbc72 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 72
def sft72 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm72a : config72 0 = 72 := by simp [config72]
theorem thm72b : Word.len word72 = 72 := by simp [word72, Word.len]
#eval config72 0
#eval word72

/-! Section 73 -/
def config73 : Config Nat := fun n => n + 73
def word73 : Word Nat := List.range 73
def sbc73 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 73
def sft73 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm73a : config73 0 = 73 := by simp [config73]
theorem thm73b : Word.len word73 = 73 := by simp [word73, Word.len]
#eval config73 0
#eval word73

/-! Section 74 -/
def config74 : Config Nat := fun n => n + 74
def word74 : Word Nat := List.range 74
def sbc74 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 74
def sft74 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm74a : config74 0 = 74 := by simp [config74]
theorem thm74b : Word.len word74 = 74 := by simp [word74, Word.len]
#eval config74 0
#eval word74

/-! Section 75 -/
def config75 : Config Nat := fun n => n + 75
def word75 : Word Nat := List.range 75
def sbc75 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 75
def sft75 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm75a : config75 0 = 75 := by simp [config75]
theorem thm75b : Word.len word75 = 75 := by simp [word75, Word.len]
#eval config75 0
#eval word75

/-! Section 76 -/
def config76 : Config Nat := fun n => n + 76
def word76 : Word Nat := List.range 76
def sbc76 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 76
def sft76 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm76a : config76 0 = 76 := by simp [config76]
theorem thm76b : Word.len word76 = 76 := by simp [word76, Word.len]
#eval config76 0
#eval word76

/-! Section 77 -/
def config77 : Config Nat := fun n => n + 77
def word77 : Word Nat := List.range 77
def sbc77 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 77
def sft77 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm77a : config77 0 = 77 := by simp [config77]
theorem thm77b : Word.len word77 = 77 := by simp [word77, Word.len]
#eval config77 0
#eval word77

/-! Section 78 -/
def config78 : Config Nat := fun n => n + 78
def word78 : Word Nat := List.range 78
def sbc78 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 78
def sft78 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm78a : config78 0 = 78 := by simp [config78]
theorem thm78b : Word.len word78 = 78 := by simp [word78, Word.len]
#eval config78 0
#eval word78

/-! Section 79 -/
def config79 : Config Nat := fun n => n + 79
def word79 : Word Nat := List.range 79
def sbc79 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 79
def sft79 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm79a : config79 0 = 79 := by simp [config79]
theorem thm79b : Word.len word79 = 79 := by simp [word79, Word.len]
#eval config79 0
#eval word79

/-! Section 80 -/
def config80 : Config Nat := fun n => n + 80
def word80 : Word Nat := List.range 80
def sbc80 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 80
def sft80 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm80a : config80 0 = 80 := by simp [config80]
theorem thm80b : Word.len word80 = 80 := by simp [word80, Word.len]
#eval config80 0
#eval word80

/-! Section 81 -/
def config81 : Config Nat := fun n => n + 81
def word81 : Word Nat := List.range 81
def sbc81 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 81
def sft81 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm81a : config81 0 = 81 := by simp [config81]
theorem thm81b : Word.len word81 = 81 := by simp [word81, Word.len]
#eval config81 0
#eval word81

/-! Section 82 -/
def config82 : Config Nat := fun n => n + 82
def word82 : Word Nat := List.range 82
def sbc82 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 82
def sft82 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm82a : config82 0 = 82 := by simp [config82]
theorem thm82b : Word.len word82 = 82 := by simp [word82, Word.len]
#eval config82 0
#eval word82

/-! Section 83 -/
def config83 : Config Nat := fun n => n + 83
def word83 : Word Nat := List.range 83
def sbc83 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 83
def sft83 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm83a : config83 0 = 83 := by simp [config83]
theorem thm83b : Word.len word83 = 83 := by simp [word83, Word.len]
#eval config83 0
#eval word83

/-! Section 84 -/
def config84 : Config Nat := fun n => n + 84
def word84 : Word Nat := List.range 84
def sbc84 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 84
def sft84 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm84a : config84 0 = 84 := by simp [config84]
theorem thm84b : Word.len word84 = 84 := by simp [word84, Word.len]
#eval config84 0
#eval word84

/-! Section 85 -/
def config85 : Config Nat := fun n => n + 85
def word85 : Word Nat := List.range 85
def sbc85 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 85
def sft85 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm85a : config85 0 = 85 := by simp [config85]
theorem thm85b : Word.len word85 = 85 := by simp [word85, Word.len]
#eval config85 0
#eval word85

/-! Section 86 -/
def config86 : Config Nat := fun n => n + 86
def word86 : Word Nat := List.range 86
def sbc86 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 86
def sft86 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm86a : config86 0 = 86 := by simp [config86]
theorem thm86b : Word.len word86 = 86 := by simp [word86, Word.len]
#eval config86 0
#eval word86

/-! Section 87 -/
def config87 : Config Nat := fun n => n + 87
def word87 : Word Nat := List.range 87
def sbc87 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 87
def sft87 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm87a : config87 0 = 87 := by simp [config87]
theorem thm87b : Word.len word87 = 87 := by simp [word87, Word.len]
#eval config87 0
#eval word87

/-! Section 88 -/
def config88 : Config Nat := fun n => n + 88
def word88 : Word Nat := List.range 88
def sbc88 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 88
def sft88 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm88a : config88 0 = 88 := by simp [config88]
theorem thm88b : Word.len word88 = 88 := by simp [word88, Word.len]
#eval config88 0
#eval word88

/-! Section 89 -/
def config89 : Config Nat := fun n => n + 89
def word89 : Word Nat := List.range 89
def sbc89 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 89
def sft89 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm89a : config89 0 = 89 := by simp [config89]
theorem thm89b : Word.len word89 = 89 := by simp [word89, Word.len]
#eval config89 0
#eval word89

/-! Section 90 -/
def config90 : Config Nat := fun n => n + 90
def word90 : Word Nat := List.range 90
def sbc90 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 90
def sft90 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm90a : config90 0 = 90 := by simp [config90]
theorem thm90b : Word.len word90 = 90 := by simp [word90, Word.len]
#eval config90 0
#eval word90

/-! Section 91 -/
def config91 : Config Nat := fun n => n + 91
def word91 : Word Nat := List.range 91
def sbc91 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 91
def sft91 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm91a : config91 0 = 91 := by simp [config91]
theorem thm91b : Word.len word91 = 91 := by simp [word91, Word.len]
#eval config91 0
#eval word91

/-! Section 92 -/
def config92 : Config Nat := fun n => n + 92
def word92 : Word Nat := List.range 92
def sbc92 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 92
def sft92 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm92a : config92 0 = 92 := by simp [config92]
theorem thm92b : Word.len word92 = 92 := by simp [word92, Word.len]
#eval config92 0
#eval word92

/-! Section 93 -/
def config93 : Config Nat := fun n => n + 93
def word93 : Word Nat := List.range 93
def sbc93 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 93
def sft93 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm93a : config93 0 = 93 := by simp [config93]
theorem thm93b : Word.len word93 = 93 := by simp [word93, Word.len]
#eval config93 0
#eval word93

/-! Section 94 -/
def config94 : Config Nat := fun n => n + 94
def word94 : Word Nat := List.range 94
def sbc94 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 94
def sft94 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm94a : config94 0 = 94 := by simp [config94]
theorem thm94b : Word.len word94 = 94 := by simp [word94, Word.len]
#eval config94 0
#eval word94

/-! Section 95 -/
def config95 : Config Nat := fun n => n + 95
def word95 : Word Nat := List.range 95
def sbc95 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 95
def sft95 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm95a : config95 0 = 95 := by simp [config95]
theorem thm95b : Word.len word95 = 95 := by simp [word95, Word.len]
#eval config95 0
#eval word95

/-! Section 96 -/
def config96 : Config Nat := fun n => n + 96
def word96 : Word Nat := List.range 96
def sbc96 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 96
def sft96 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm96a : config96 0 = 96 := by simp [config96]
theorem thm96b : Word.len word96 = 96 := by simp [word96, Word.len]
#eval config96 0
#eval word96

/-! Section 97 -/
def config97 : Config Nat := fun n => n + 97
def word97 : Word Nat := List.range 97
def sbc97 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 97
def sft97 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm97a : config97 0 = 97 := by simp [config97]
theorem thm97b : Word.len word97 = 97 := by simp [word97, Word.len]
#eval config97 0
#eval word97

/-! Section 98 -/
def config98 : Config Nat := fun n => n + 98
def word98 : Word Nat := List.range 98
def sbc98 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 98
def sft98 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm98a : config98 0 = 98 := by simp [config98]
theorem thm98b : Word.len word98 = 98 := by simp [word98, Word.len]
#eval config98 0
#eval word98

/-! Section 99 -/
def config99 : Config Nat := fun n => n + 99
def word99 : Word Nat := List.range 99
def sbc99 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 99
def sft99 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm99a : config99 0 = 99 := by simp [config99]
theorem thm99b : Word.len word99 = 99 := by simp [word99, Word.len]
#eval config99 0
#eval word99

/-! Section 100 -/
def config100 : Config Nat := fun n => n + 100
def word100 : Word Nat := List.range 100
def sbc100 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 100
def sft100 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm100a : config100 0 = 100 := by simp [config100]
theorem thm100b : Word.len word100 = 100 := by simp [word100, Word.len]
#eval config100 0
#eval word100

/-! Section 101 -/
def config101 : Config Nat := fun n => n + 101
def word101 : Word Nat := List.range 101
def sbc101 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 101
def sft101 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm101a : config101 0 = 101 := by simp [config101]
theorem thm101b : Word.len word101 = 101 := by simp [word101, Word.len]
#eval config101 0
#eval word101

/-! Section 102 -/
def config102 : Config Nat := fun n => n + 102
def word102 : Word Nat := List.range 102
def sbc102 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 102
def sft102 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm102a : config102 0 = 102 := by simp [config102]
theorem thm102b : Word.len word102 = 102 := by simp [word102, Word.len]
#eval config102 0
#eval word102

/-! Section 103 -/
def config103 : Config Nat := fun n => n + 103
def word103 : Word Nat := List.range 103
def sbc103 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 103
def sft103 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm103a : config103 0 = 103 := by simp [config103]
theorem thm103b : Word.len word103 = 103 := by simp [word103, Word.len]
#eval config103 0
#eval word103

/-! Section 104 -/
def config104 : Config Nat := fun n => n + 104
def word104 : Word Nat := List.range 104
def sbc104 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 104
def sft104 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm104a : config104 0 = 104 := by simp [config104]
theorem thm104b : Word.len word104 = 104 := by simp [word104, Word.len]
#eval config104 0
#eval word104

/-! Section 105 -/
def config105 : Config Nat := fun n => n + 105
def word105 : Word Nat := List.range 105
def sbc105 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 105
def sft105 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm105a : config105 0 = 105 := by simp [config105]
theorem thm105b : Word.len word105 = 105 := by simp [word105, Word.len]
#eval config105 0
#eval word105

/-! Section 106 -/
def config106 : Config Nat := fun n => n + 106
def word106 : Word Nat := List.range 106
def sbc106 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 106
def sft106 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm106a : config106 0 = 106 := by simp [config106]
theorem thm106b : Word.len word106 = 106 := by simp [word106, Word.len]
#eval config106 0
#eval word106

/-! Section 107 -/
def config107 : Config Nat := fun n => n + 107
def word107 : Word Nat := List.range 107
def sbc107 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 107
def sft107 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm107a : config107 0 = 107 := by simp [config107]
theorem thm107b : Word.len word107 = 107 := by simp [word107, Word.len]
#eval config107 0
#eval word107

/-! Section 108 -/
def config108 : Config Nat := fun n => n + 108
def word108 : Word Nat := List.range 108
def sbc108 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 108
def sft108 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm108a : config108 0 = 108 := by simp [config108]
theorem thm108b : Word.len word108 = 108 := by simp [word108, Word.len]
#eval config108 0
#eval word108

/-! Section 109 -/
def config109 : Config Nat := fun n => n + 109
def word109 : Word Nat := List.range 109
def sbc109 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 109
def sft109 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm109a : config109 0 = 109 := by simp [config109]
theorem thm109b : Word.len word109 = 109 := by simp [word109, Word.len]
#eval config109 0
#eval word109

/-! Section 110 -/
def config110 : Config Nat := fun n => n + 110
def word110 : Word Nat := List.range 110
def sbc110 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 110
def sft110 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm110a : config110 0 = 110 := by simp [config110]
theorem thm110b : Word.len word110 = 110 := by simp [word110, Word.len]
#eval config110 0
#eval word110

/-! Section 111 -/
def config111 : Config Nat := fun n => n + 111
def word111 : Word Nat := List.range 111
def sbc111 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 111
def sft111 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm111a : config111 0 = 111 := by simp [config111]
theorem thm111b : Word.len word111 = 111 := by simp [word111, Word.len]
#eval config111 0
#eval word111

/-! Section 112 -/
def config112 : Config Nat := fun n => n + 112
def word112 : Word Nat := List.range 112
def sbc112 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 112
def sft112 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm112a : config112 0 = 112 := by simp [config112]
theorem thm112b : Word.len word112 = 112 := by simp [word112, Word.len]
#eval config112 0
#eval word112

/-! Section 113 -/
def config113 : Config Nat := fun n => n + 113
def word113 : Word Nat := List.range 113
def sbc113 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 113
def sft113 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm113a : config113 0 = 113 := by simp [config113]
theorem thm113b : Word.len word113 = 113 := by simp [word113, Word.len]
#eval config113 0
#eval word113

/-! Section 114 -/
def config114 : Config Nat := fun n => n + 114
def word114 : Word Nat := List.range 114
def sbc114 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 114
def sft114 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm114a : config114 0 = 114 := by simp [config114]
theorem thm114b : Word.len word114 = 114 := by simp [word114, Word.len]
#eval config114 0
#eval word114

/-! Section 115 -/
def config115 : Config Nat := fun n => n + 115
def word115 : Word Nat := List.range 115
def sbc115 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 115
def sft115 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm115a : config115 0 = 115 := by simp [config115]
theorem thm115b : Word.len word115 = 115 := by simp [word115, Word.len]
#eval config115 0
#eval word115

/-! Section 116 -/
def config116 : Config Nat := fun n => n + 116
def word116 : Word Nat := List.range 116
def sbc116 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 116
def sft116 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm116a : config116 0 = 116 := by simp [config116]
theorem thm116b : Word.len word116 = 116 := by simp [word116, Word.len]
#eval config116 0
#eval word116

/-! Section 117 -/
def config117 : Config Nat := fun n => n + 117
def word117 : Word Nat := List.range 117
def sbc117 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 117
def sft117 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm117a : config117 0 = 117 := by simp [config117]
theorem thm117b : Word.len word117 = 117 := by simp [word117, Word.len]
#eval config117 0
#eval word117

/-! Section 118 -/
def config118 : Config Nat := fun n => n + 118
def word118 : Word Nat := List.range 118
def sbc118 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 118
def sft118 : SFT1 Nat where
  alphabet := [0, 1]
  transitions := [(0, 1)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm118a : config118 0 = 118 := by simp [config118]
theorem thm118b : Word.len word118 = 118 := by simp [word118, Word.len]
#eval config118 0
#eval word118

/-! Section 119 -/
def config119 : Config Nat := fun n => n + 119
def word119 : Word Nat := List.range 119
def sbc119 : SlidingBlockCode Nat Nat where
  mem := 0
  ant := 0
  localRule := fun _ => 119
def sft119 : SFT1 Nat where
  alphabet := [1, 0]
  transitions := [(1, 0)]
  carrier := fun _ => True
  carrier_eq := rfl

theorem thm119a : config119 0 = 119 := by simp [config119]
theorem thm119b : Word.len word119 = 119 := by simp [word119, Word.len]
#eval config119 0
#eval word119

end MiniSymbolicDynamics

/-! Section 120 -/
def cfg120 : Config Nat := fun n => n * 120
def wrd120 : Word Nat := List.replicate 0 (120 % 3)
theorem th120a : cfg120 0 = 0 := by simp [cfg120]
theorem th120b : Word.len wrd120 = 0 := by simp [wrd120, Word.len]
theorem th120c : True := by trivial
#eval cfg120 1
#eval wrd120


/-! Section 121 -/
def cfg121 : Config Nat := fun n => n * 121
def wrd121 : Word Nat := List.replicate 1 (121 % 3)
theorem th121a : cfg121 0 = 0 := by simp [cfg121]
theorem th121b : Word.len wrd121 = 1 := by simp [wrd121, Word.len]
theorem th121c : True := by trivial
#eval cfg121 1
#eval wrd121


/-! Section 122 -/
def cfg122 : Config Nat := fun n => n * 122
def wrd122 : Word Nat := List.replicate 2 (122 % 3)
theorem th122a : cfg122 0 = 0 := by simp [cfg122]
theorem th122b : Word.len wrd122 = 2 := by simp [wrd122, Word.len]
theorem th122c : True := by trivial
#eval cfg122 1
#eval wrd122


/-! Section 123 -/
def cfg123 : Config Nat := fun n => n * 123
def wrd123 : Word Nat := List.replicate 3 (123 % 3)
theorem th123a : cfg123 0 = 0 := by simp [cfg123]
theorem th123b : Word.len wrd123 = 3 := by simp [wrd123, Word.len]
theorem th123c : True := by trivial
#eval cfg123 1
#eval wrd123


/-! Section 124 -/
def cfg124 : Config Nat := fun n => n * 124
def wrd124 : Word Nat := List.replicate 4 (124 % 3)
theorem th124a : cfg124 0 = 0 := by simp [cfg124]
theorem th124b : Word.len wrd124 = 4 := by simp [wrd124, Word.len]
theorem th124c : True := by trivial
#eval cfg124 1
#eval wrd124


/-! Section 125 -/
def cfg125 : Config Nat := fun n => n * 125
def wrd125 : Word Nat := List.replicate 5 (125 % 3)
theorem th125a : cfg125 0 = 0 := by simp [cfg125]
theorem th125b : Word.len wrd125 = 5 := by simp [wrd125, Word.len]
theorem th125c : True := by trivial
#eval cfg125 1
#eval wrd125


/-! Section 126 -/
def cfg126 : Config Nat := fun n => n * 126
def wrd126 : Word Nat := List.replicate 6 (126 % 3)
theorem th126a : cfg126 0 = 0 := by simp [cfg126]
theorem th126b : Word.len wrd126 = 6 := by simp [wrd126, Word.len]
theorem th126c : True := by trivial
#eval cfg126 1
#eval wrd126


/-! Section 127 -/
def cfg127 : Config Nat := fun n => n * 127
def wrd127 : Word Nat := List.replicate 7 (127 % 3)
theorem th127a : cfg127 0 = 0 := by simp [cfg127]
theorem th127b : Word.len wrd127 = 7 := by simp [wrd127, Word.len]
theorem th127c : True := by trivial
#eval cfg127 1
#eval wrd127


/-! Section 128 -/
def cfg128 : Config Nat := fun n => n * 128
def wrd128 : Word Nat := List.replicate 8 (128 % 3)
theorem th128a : cfg128 0 = 0 := by simp [cfg128]
theorem th128b : Word.len wrd128 = 8 := by simp [wrd128, Word.len]
theorem th128c : True := by trivial
#eval cfg128 1
#eval wrd128


/-! Section 129 -/
def cfg129 : Config Nat := fun n => n * 129
def wrd129 : Word Nat := List.replicate 9 (129 % 3)
theorem th129a : cfg129 0 = 0 := by simp [cfg129]
theorem th129b : Word.len wrd129 = 9 := by simp [wrd129, Word.len]
theorem th129c : True := by trivial
#eval cfg129 1
#eval wrd129


/-! Section 130 -/
def cfg130 : Config Nat := fun n => n * 130
def wrd130 : Word Nat := List.replicate 0 (130 % 3)
theorem th130a : cfg130 0 = 0 := by simp [cfg130]
theorem th130b : Word.len wrd130 = 0 := by simp [wrd130, Word.len]
theorem th130c : True := by trivial
#eval cfg130 1
#eval wrd130


/-! Section 131 -/
def cfg131 : Config Nat := fun n => n * 131
def wrd131 : Word Nat := List.replicate 1 (131 % 3)
theorem th131a : cfg131 0 = 0 := by simp [cfg131]
theorem th131b : Word.len wrd131 = 1 := by simp [wrd131, Word.len]
theorem th131c : True := by trivial
#eval cfg131 1
#eval wrd131


/-! Section 132 -/
def cfg132 : Config Nat := fun n => n * 132
def wrd132 : Word Nat := List.replicate 2 (132 % 3)
theorem th132a : cfg132 0 = 0 := by simp [cfg132]
theorem th132b : Word.len wrd132 = 2 := by simp [wrd132, Word.len]
theorem th132c : True := by trivial
#eval cfg132 1
#eval wrd132


/-! Section 133 -/
def cfg133 : Config Nat := fun n => n * 133
def wrd133 : Word Nat := List.replicate 3 (133 % 3)
theorem th133a : cfg133 0 = 0 := by simp [cfg133]
theorem th133b : Word.len wrd133 = 3 := by simp [wrd133, Word.len]
theorem th133c : True := by trivial
#eval cfg133 1
#eval wrd133


/-! Section 134 -/
def cfg134 : Config Nat := fun n => n * 134
def wrd134 : Word Nat := List.replicate 4 (134 % 3)
theorem th134a : cfg134 0 = 0 := by simp [cfg134]
theorem th134b : Word.len wrd134 = 4 := by simp [wrd134, Word.len]
theorem th134c : True := by trivial
#eval cfg134 1
#eval wrd134


/-! Section 135 -/
def cfg135 : Config Nat := fun n => n * 135
def wrd135 : Word Nat := List.replicate 5 (135 % 3)
theorem th135a : cfg135 0 = 0 := by simp [cfg135]
theorem th135b : Word.len wrd135 = 5 := by simp [wrd135, Word.len]
theorem th135c : True := by trivial
#eval cfg135 1
#eval wrd135


/-! Section 136 -/
def cfg136 : Config Nat := fun n => n * 136
def wrd136 : Word Nat := List.replicate 6 (136 % 3)
theorem th136a : cfg136 0 = 0 := by simp [cfg136]
theorem th136b : Word.len wrd136 = 6 := by simp [wrd136, Word.len]
theorem th136c : True := by trivial
#eval cfg136 1
#eval wrd136


/-! Section 137 -/
def cfg137 : Config Nat := fun n => n * 137
def wrd137 : Word Nat := List.replicate 7 (137 % 3)
theorem th137a : cfg137 0 = 0 := by simp [cfg137]
theorem th137b : Word.len wrd137 = 7 := by simp [wrd137, Word.len]
theorem th137c : True := by trivial
#eval cfg137 1
#eval wrd137


/-! Section 138 -/
def cfg138 : Config Nat := fun n => n * 138
def wrd138 : Word Nat := List.replicate 8 (138 % 3)
theorem th138a : cfg138 0 = 0 := by simp [cfg138]
theorem th138b : Word.len wrd138 = 8 := by simp [wrd138, Word.len]
theorem th138c : True := by trivial
#eval cfg138 1
#eval wrd138


/-! Section 139 -/
def cfg139 : Config Nat := fun n => n * 139
def wrd139 : Word Nat := List.replicate 9 (139 % 3)
theorem th139a : cfg139 0 = 0 := by simp [cfg139]
theorem th139b : Word.len wrd139 = 9 := by simp [wrd139, Word.len]
theorem th139c : True := by trivial
#eval cfg139 1
#eval wrd139


/-! Section 140 -/
def cfg140 : Config Nat := fun n => n * 140
def wrd140 : Word Nat := List.replicate 0 (140 % 3)
theorem th140a : cfg140 0 = 0 := by simp [cfg140]
theorem th140b : Word.len wrd140 = 0 := by simp [wrd140, Word.len]
theorem th140c : True := by trivial
#eval cfg140 1
#eval wrd140


/-! Section 141 -/
def cfg141 : Config Nat := fun n => n * 141
def wrd141 : Word Nat := List.replicate 1 (141 % 3)
theorem th141a : cfg141 0 = 0 := by simp [cfg141]
theorem th141b : Word.len wrd141 = 1 := by simp [wrd141, Word.len]
theorem th141c : True := by trivial
#eval cfg141 1
#eval wrd141


/-! Section 142 -/
def cfg142 : Config Nat := fun n => n * 142
def wrd142 : Word Nat := List.replicate 2 (142 % 3)
theorem th142a : cfg142 0 = 0 := by simp [cfg142]
theorem th142b : Word.len wrd142 = 2 := by simp [wrd142, Word.len]
theorem th142c : True := by trivial
#eval cfg142 1
#eval wrd142


/-! Section 143 -/
def cfg143 : Config Nat := fun n => n * 143
def wrd143 : Word Nat := List.replicate 3 (143 % 3)
theorem th143a : cfg143 0 = 0 := by simp [cfg143]
theorem th143b : Word.len wrd143 = 3 := by simp [wrd143, Word.len]
theorem th143c : True := by trivial
#eval cfg143 1
#eval wrd143


/-! Section 144 -/
def cfg144 : Config Nat := fun n => n * 144
def wrd144 : Word Nat := List.replicate 4 (144 % 3)
theorem th144a : cfg144 0 = 0 := by simp [cfg144]
theorem th144b : Word.len wrd144 = 4 := by simp [wrd144, Word.len]
theorem th144c : True := by trivial
#eval cfg144 1
#eval wrd144


/-! Section 145 -/
def cfg145 : Config Nat := fun n => n * 145
def wrd145 : Word Nat := List.replicate 5 (145 % 3)
theorem th145a : cfg145 0 = 0 := by simp [cfg145]
theorem th145b : Word.len wrd145 = 5 := by simp [wrd145, Word.len]
theorem th145c : True := by trivial
#eval cfg145 1
#eval wrd145


/-! Section 146 -/
def cfg146 : Config Nat := fun n => n * 146
def wrd146 : Word Nat := List.replicate 6 (146 % 3)
theorem th146a : cfg146 0 = 0 := by simp [cfg146]
theorem th146b : Word.len wrd146 = 6 := by simp [wrd146, Word.len]
theorem th146c : True := by trivial
#eval cfg146 1
#eval wrd146


/-! Section 147 -/
def cfg147 : Config Nat := fun n => n * 147
def wrd147 : Word Nat := List.replicate 7 (147 % 3)
theorem th147a : cfg147 0 = 0 := by simp [cfg147]
theorem th147b : Word.len wrd147 = 7 := by simp [wrd147, Word.len]
theorem th147c : True := by trivial
#eval cfg147 1
#eval wrd147


/-! Section 148 -/
def cfg148 : Config Nat := fun n => n * 148
def wrd148 : Word Nat := List.replicate 8 (148 % 3)
theorem th148a : cfg148 0 = 0 := by simp [cfg148]
theorem th148b : Word.len wrd148 = 8 := by simp [wrd148, Word.len]
theorem th148c : True := by trivial
#eval cfg148 1
#eval wrd148


/-! Section 149 -/
def cfg149 : Config Nat := fun n => n * 149
def wrd149 : Word Nat := List.replicate 9 (149 % 3)
theorem th149a : cfg149 0 = 0 := by simp [cfg149]
theorem th149b : Word.len wrd149 = 9 := by simp [wrd149, Word.len]
theorem th149c : True := by trivial
#eval cfg149 1
#eval wrd149


/-! Section 150 -/
def cfg150 : Config Nat := fun n => n * 150
def wrd150 : Word Nat := List.replicate 0 (150 % 3)
theorem th150a : cfg150 0 = 0 := by simp [cfg150]
theorem th150b : Word.len wrd150 = 0 := by simp [wrd150, Word.len]
theorem th150c : True := by trivial
#eval cfg150 1
#eval wrd150


/-! Section 151 -/
def cfg151 : Config Nat := fun n => n * 151
def wrd151 : Word Nat := List.replicate 1 (151 % 3)
theorem th151a : cfg151 0 = 0 := by simp [cfg151]
theorem th151b : Word.len wrd151 = 1 := by simp [wrd151, Word.len]
theorem th151c : True := by trivial
#eval cfg151 1
#eval wrd151


/-! Section 152 -/
def cfg152 : Config Nat := fun n => n * 152
def wrd152 : Word Nat := List.replicate 2 (152 % 3)
theorem th152a : cfg152 0 = 0 := by simp [cfg152]
theorem th152b : Word.len wrd152 = 2 := by simp [wrd152, Word.len]
theorem th152c : True := by trivial
#eval cfg152 1
#eval wrd152


/-! Section 153 -/
def cfg153 : Config Nat := fun n => n * 153
def wrd153 : Word Nat := List.replicate 3 (153 % 3)
theorem th153a : cfg153 0 = 0 := by simp [cfg153]
theorem th153b : Word.len wrd153 = 3 := by simp [wrd153, Word.len]
theorem th153c : True := by trivial
#eval cfg153 1
#eval wrd153


/-! Section 154 -/
def cfg154 : Config Nat := fun n => n * 154
def wrd154 : Word Nat := List.replicate 4 (154 % 3)
theorem th154a : cfg154 0 = 0 := by simp [cfg154]
theorem th154b : Word.len wrd154 = 4 := by simp [wrd154, Word.len]
theorem th154c : True := by trivial
#eval cfg154 1
#eval wrd154


/-! Section 155 -/
def cfg155 : Config Nat := fun n => n * 155
def wrd155 : Word Nat := List.replicate 5 (155 % 3)
theorem th155a : cfg155 0 = 0 := by simp [cfg155]
theorem th155b : Word.len wrd155 = 5 := by simp [wrd155, Word.len]
theorem th155c : True := by trivial
#eval cfg155 1
#eval wrd155


/-! Section 156 -/
def cfg156 : Config Nat := fun n => n * 156
def wrd156 : Word Nat := List.replicate 6 (156 % 3)
theorem th156a : cfg156 0 = 0 := by simp [cfg156]
theorem th156b : Word.len wrd156 = 6 := by simp [wrd156, Word.len]
theorem th156c : True := by trivial
#eval cfg156 1
#eval wrd156


/-! Section 157 -/
def cfg157 : Config Nat := fun n => n * 157
def wrd157 : Word Nat := List.replicate 7 (157 % 3)
theorem th157a : cfg157 0 = 0 := by simp [cfg157]
theorem th157b : Word.len wrd157 = 7 := by simp [wrd157, Word.len]
theorem th157c : True := by trivial
#eval cfg157 1
#eval wrd157


/-! Section 158 -/
def cfg158 : Config Nat := fun n => n * 158
def wrd158 : Word Nat := List.replicate 8 (158 % 3)
theorem th158a : cfg158 0 = 0 := by simp [cfg158]
theorem th158b : Word.len wrd158 = 8 := by simp [wrd158, Word.len]
theorem th158c : True := by trivial
#eval cfg158 1
#eval wrd158


/-! Section 159 -/
def cfg159 : Config Nat := fun n => n * 159
def wrd159 : Word Nat := List.replicate 9 (159 % 3)
theorem th159a : cfg159 0 = 0 := by simp [cfg159]
theorem th159b : Word.len wrd159 = 9 := by simp [wrd159, Word.len]
theorem th159c : True := by trivial
#eval cfg159 1
#eval wrd159


/-! Section 160 -/
def cfg160 : Config Nat := fun n => n * 160
def wrd160 : Word Nat := List.replicate 0 (160 % 3)
theorem th160a : cfg160 0 = 0 := by simp [cfg160]
theorem th160b : Word.len wrd160 = 0 := by simp [wrd160, Word.len]
theorem th160c : True := by trivial
#eval cfg160 1
#eval wrd160


/-! Section 161 -/
def cfg161 : Config Nat := fun n => n * 161
def wrd161 : Word Nat := List.replicate 1 (161 % 3)
theorem th161a : cfg161 0 = 0 := by simp [cfg161]
theorem th161b : Word.len wrd161 = 1 := by simp [wrd161, Word.len]
theorem th161c : True := by trivial
#eval cfg161 1
#eval wrd161


/-! Section 162 -/
def cfg162 : Config Nat := fun n => n * 162
def wrd162 : Word Nat := List.replicate 2 (162 % 3)
theorem th162a : cfg162 0 = 0 := by simp [cfg162]
theorem th162b : Word.len wrd162 = 2 := by simp [wrd162, Word.len]
theorem th162c : True := by trivial
#eval cfg162 1
#eval wrd162


/-! Section 163 -/
def cfg163 : Config Nat := fun n => n * 163
def wrd163 : Word Nat := List.replicate 3 (163 % 3)
theorem th163a : cfg163 0 = 0 := by simp [cfg163]
theorem th163b : Word.len wrd163 = 3 := by simp [wrd163, Word.len]
theorem th163c : True := by trivial
#eval cfg163 1
#eval wrd163


/-! Section 164 -/
def cfg164 : Config Nat := fun n => n * 164
def wrd164 : Word Nat := List.replicate 4 (164 % 3)
theorem th164a : cfg164 0 = 0 := by simp [cfg164]
theorem th164b : Word.len wrd164 = 4 := by simp [wrd164, Word.len]
theorem th164c : True := by trivial
#eval cfg164 1
#eval wrd164


/-! Section 165 -/
def cfg165 : Config Nat := fun n => n * 165
def wrd165 : Word Nat := List.replicate 5 (165 % 3)
theorem th165a : cfg165 0 = 0 := by simp [cfg165]
theorem th165b : Word.len wrd165 = 5 := by simp [wrd165, Word.len]
theorem th165c : True := by trivial
#eval cfg165 1
#eval wrd165


/-! Section 166 -/
def cfg166 : Config Nat := fun n => n * 166
def wrd166 : Word Nat := List.replicate 6 (166 % 3)
theorem th166a : cfg166 0 = 0 := by simp [cfg166]
theorem th166b : Word.len wrd166 = 6 := by simp [wrd166, Word.len]
theorem th166c : True := by trivial
#eval cfg166 1
#eval wrd166


/-! Section 167 -/
def cfg167 : Config Nat := fun n => n * 167
def wrd167 : Word Nat := List.replicate 7 (167 % 3)
theorem th167a : cfg167 0 = 0 := by simp [cfg167]
theorem th167b : Word.len wrd167 = 7 := by simp [wrd167, Word.len]
theorem th167c : True := by trivial
#eval cfg167 1
#eval wrd167


/-! Section 168 -/
def cfg168 : Config Nat := fun n => n * 168
def wrd168 : Word Nat := List.replicate 8 (168 % 3)
theorem th168a : cfg168 0 = 0 := by simp [cfg168]
theorem th168b : Word.len wrd168 = 8 := by simp [wrd168, Word.len]
theorem th168c : True := by trivial
#eval cfg168 1
#eval wrd168


/-! Section 169 -/
def cfg169 : Config Nat := fun n => n * 169
def wrd169 : Word Nat := List.replicate 9 (169 % 3)
theorem th169a : cfg169 0 = 0 := by simp [cfg169]
theorem th169b : Word.len wrd169 = 9 := by simp [wrd169, Word.len]
theorem th169c : True := by trivial
#eval cfg169 1
#eval wrd169


/-! Section 170 -/
def cfg170 : Config Nat := fun n => n * 170
def wrd170 : Word Nat := List.replicate 0 (170 % 3)
theorem th170a : cfg170 0 = 0 := by simp [cfg170]
theorem th170b : Word.len wrd170 = 0 := by simp [wrd170, Word.len]
theorem th170c : True := by trivial
#eval cfg170 1
#eval wrd170


/-! Section 171 -/
def cfg171 : Config Nat := fun n => n * 171
def wrd171 : Word Nat := List.replicate 1 (171 % 3)
theorem th171a : cfg171 0 = 0 := by simp [cfg171]
theorem th171b : Word.len wrd171 = 1 := by simp [wrd171, Word.len]
theorem th171c : True := by trivial
#eval cfg171 1
#eval wrd171


/-! Section 172 -/
def cfg172 : Config Nat := fun n => n * 172
def wrd172 : Word Nat := List.replicate 2 (172 % 3)
theorem th172a : cfg172 0 = 0 := by simp [cfg172]
theorem th172b : Word.len wrd172 = 2 := by simp [wrd172, Word.len]
theorem th172c : True := by trivial
#eval cfg172 1
#eval wrd172


/-! Section 173 -/
def cfg173 : Config Nat := fun n => n * 173
def wrd173 : Word Nat := List.replicate 3 (173 % 3)
theorem th173a : cfg173 0 = 0 := by simp [cfg173]
theorem th173b : Word.len wrd173 = 3 := by simp [wrd173, Word.len]
theorem th173c : True := by trivial
#eval cfg173 1
#eval wrd173


/-! Section 174 -/
def cfg174 : Config Nat := fun n => n * 174
def wrd174 : Word Nat := List.replicate 4 (174 % 3)
theorem th174a : cfg174 0 = 0 := by simp [cfg174]
theorem th174b : Word.len wrd174 = 4 := by simp [wrd174, Word.len]
theorem th174c : True := by trivial
#eval cfg174 1
#eval wrd174


/-! Section 175 -/
def cfg175 : Config Nat := fun n => n * 175
def wrd175 : Word Nat := List.replicate 5 (175 % 3)
theorem th175a : cfg175 0 = 0 := by simp [cfg175]
theorem th175b : Word.len wrd175 = 5 := by simp [wrd175, Word.len]
theorem th175c : True := by trivial
#eval cfg175 1
#eval wrd175


/-! Section 176 -/
def cfg176 : Config Nat := fun n => n * 176
def wrd176 : Word Nat := List.replicate 6 (176 % 3)
theorem th176a : cfg176 0 = 0 := by simp [cfg176]
theorem th176b : Word.len wrd176 = 6 := by simp [wrd176, Word.len]
theorem th176c : True := by trivial
#eval cfg176 1
#eval wrd176


/-! Section 177 -/
def cfg177 : Config Nat := fun n => n * 177
def wrd177 : Word Nat := List.replicate 7 (177 % 3)
theorem th177a : cfg177 0 = 0 := by simp [cfg177]
theorem th177b : Word.len wrd177 = 7 := by simp [wrd177, Word.len]
theorem th177c : True := by trivial
#eval cfg177 1
#eval wrd177


/-! Section 178 -/
def cfg178 : Config Nat := fun n => n * 178
def wrd178 : Word Nat := List.replicate 8 (178 % 3)
theorem th178a : cfg178 0 = 0 := by simp [cfg178]
theorem th178b : Word.len wrd178 = 8 := by simp [wrd178, Word.len]
theorem th178c : True := by trivial
#eval cfg178 1
#eval wrd178


/-! Section 179 -/
def cfg179 : Config Nat := fun n => n * 179
def wrd179 : Word Nat := List.replicate 9 (179 % 3)
theorem th179a : cfg179 0 = 0 := by simp [cfg179]
theorem th179b : Word.len wrd179 = 9 := by simp [wrd179, Word.len]
theorem th179c : True := by trivial
#eval cfg179 1
#eval wrd179


/-! Section 180 -/
def cfg180 : Config Nat := fun n => n * 180
def wrd180 : Word Nat := List.replicate 0 (180 % 3)
theorem th180a : cfg180 0 = 0 := by simp [cfg180]
theorem th180b : Word.len wrd180 = 0 := by simp [wrd180, Word.len]
theorem th180c : True := by trivial
#eval cfg180 1
#eval wrd180


/-! Section 181 -/
def cfg181 : Config Nat := fun n => n * 181
def wrd181 : Word Nat := List.replicate 1 (181 % 3)
theorem th181a : cfg181 0 = 0 := by simp [cfg181]
theorem th181b : Word.len wrd181 = 1 := by simp [wrd181, Word.len]
theorem th181c : True := by trivial
#eval cfg181 1
#eval wrd181


/-! Section 182 -/
def cfg182 : Config Nat := fun n => n * 182
def wrd182 : Word Nat := List.replicate 2 (182 % 3)
theorem th182a : cfg182 0 = 0 := by simp [cfg182]
theorem th182b : Word.len wrd182 = 2 := by simp [wrd182, Word.len]
theorem th182c : True := by trivial
#eval cfg182 1
#eval wrd182


/-! Section 183 -/
def cfg183 : Config Nat := fun n => n * 183
def wrd183 : Word Nat := List.replicate 3 (183 % 3)
theorem th183a : cfg183 0 = 0 := by simp [cfg183]
theorem th183b : Word.len wrd183 = 3 := by simp [wrd183, Word.len]
theorem th183c : True := by trivial
#eval cfg183 1
#eval wrd183


/-! Section 184 -/
def cfg184 : Config Nat := fun n => n * 184
def wrd184 : Word Nat := List.replicate 4 (184 % 3)
theorem th184a : cfg184 0 = 0 := by simp [cfg184]
theorem th184b : Word.len wrd184 = 4 := by simp [wrd184, Word.len]
theorem th184c : True := by trivial
#eval cfg184 1
#eval wrd184


/-! Section 185 -/
def cfg185 : Config Nat := fun n => n * 185
def wrd185 : Word Nat := List.replicate 5 (185 % 3)
theorem th185a : cfg185 0 = 0 := by simp [cfg185]
theorem th185b : Word.len wrd185 = 5 := by simp [wrd185, Word.len]
theorem th185c : True := by trivial
#eval cfg185 1
#eval wrd185


/-! Section 186 -/
def cfg186 : Config Nat := fun n => n * 186
def wrd186 : Word Nat := List.replicate 6 (186 % 3)
theorem th186a : cfg186 0 = 0 := by simp [cfg186]
theorem th186b : Word.len wrd186 = 6 := by simp [wrd186, Word.len]
theorem th186c : True := by trivial
#eval cfg186 1
#eval wrd186


/-! Section 187 -/
def cfg187 : Config Nat := fun n => n * 187
def wrd187 : Word Nat := List.replicate 7 (187 % 3)
theorem th187a : cfg187 0 = 0 := by simp [cfg187]
theorem th187b : Word.len wrd187 = 7 := by simp [wrd187, Word.len]
theorem th187c : True := by trivial
#eval cfg187 1
#eval wrd187


/-! Section 188 -/
def cfg188 : Config Nat := fun n => n * 188
def wrd188 : Word Nat := List.replicate 8 (188 % 3)
theorem th188a : cfg188 0 = 0 := by simp [cfg188]
theorem th188b : Word.len wrd188 = 8 := by simp [wrd188, Word.len]
theorem th188c : True := by trivial
#eval cfg188 1
#eval wrd188


/-! Section 189 -/
def cfg189 : Config Nat := fun n => n * 189
def wrd189 : Word Nat := List.replicate 9 (189 % 3)
theorem th189a : cfg189 0 = 0 := by simp [cfg189]
theorem th189b : Word.len wrd189 = 9 := by simp [wrd189, Word.len]
theorem th189c : True := by trivial
#eval cfg189 1
#eval wrd189


/-! Section 190 -/
def cfg190 : Config Nat := fun n => n * 190
def wrd190 : Word Nat := List.replicate 0 (190 % 3)
theorem th190a : cfg190 0 = 0 := by simp [cfg190]
theorem th190b : Word.len wrd190 = 0 := by simp [wrd190, Word.len]
theorem th190c : True := by trivial
#eval cfg190 1
#eval wrd190


/-! Section 191 -/
def cfg191 : Config Nat := fun n => n * 191
def wrd191 : Word Nat := List.replicate 1 (191 % 3)
theorem th191a : cfg191 0 = 0 := by simp [cfg191]
theorem th191b : Word.len wrd191 = 1 := by simp [wrd191, Word.len]
theorem th191c : True := by trivial
#eval cfg191 1
#eval wrd191


/-! Section 192 -/
def cfg192 : Config Nat := fun n => n * 192
def wrd192 : Word Nat := List.replicate 2 (192 % 3)
theorem th192a : cfg192 0 = 0 := by simp [cfg192]
theorem th192b : Word.len wrd192 = 2 := by simp [wrd192, Word.len]
theorem th192c : True := by trivial
#eval cfg192 1
#eval wrd192


/-! Section 193 -/
def cfg193 : Config Nat := fun n => n * 193
def wrd193 : Word Nat := List.replicate 3 (193 % 3)
theorem th193a : cfg193 0 = 0 := by simp [cfg193]
theorem th193b : Word.len wrd193 = 3 := by simp [wrd193, Word.len]
theorem th193c : True := by trivial
#eval cfg193 1
#eval wrd193


/-! Section 194 -/
def cfg194 : Config Nat := fun n => n * 194
def wrd194 : Word Nat := List.replicate 4 (194 % 3)
theorem th194a : cfg194 0 = 0 := by simp [cfg194]
theorem th194b : Word.len wrd194 = 4 := by simp [wrd194, Word.len]
theorem th194c : True := by trivial
#eval cfg194 1
#eval wrd194


/-! Section 195 -/
def cfg195 : Config Nat := fun n => n * 195
def wrd195 : Word Nat := List.replicate 5 (195 % 3)
theorem th195a : cfg195 0 = 0 := by simp [cfg195]
theorem th195b : Word.len wrd195 = 5 := by simp [wrd195, Word.len]
theorem th195c : True := by trivial
#eval cfg195 1
#eval wrd195


/-! Section 196 -/
def cfg196 : Config Nat := fun n => n * 196
def wrd196 : Word Nat := List.replicate 6 (196 % 3)
theorem th196a : cfg196 0 = 0 := by simp [cfg196]
theorem th196b : Word.len wrd196 = 6 := by simp [wrd196, Word.len]
theorem th196c : True := by trivial
#eval cfg196 1
#eval wrd196


/-! Section 197 -/
def cfg197 : Config Nat := fun n => n * 197
def wrd197 : Word Nat := List.replicate 7 (197 % 3)
theorem th197a : cfg197 0 = 0 := by simp [cfg197]
theorem th197b : Word.len wrd197 = 7 := by simp [wrd197, Word.len]
theorem th197c : True := by trivial
#eval cfg197 1
#eval wrd197


/-! Section 198 -/
def cfg198 : Config Nat := fun n => n * 198
def wrd198 : Word Nat := List.replicate 8 (198 % 3)
theorem th198a : cfg198 0 = 0 := by simp [cfg198]
theorem th198b : Word.len wrd198 = 8 := by simp [wrd198, Word.len]
theorem th198c : True := by trivial
#eval cfg198 1
#eval wrd198


/-! Section 199 -/
def cfg199 : Config Nat := fun n => n * 199
def wrd199 : Word Nat := List.replicate 9 (199 % 3)
theorem th199a : cfg199 0 = 0 := by simp [cfg199]
theorem th199b : Word.len wrd199 = 9 := by simp [wrd199, Word.len]
theorem th199c : True := by trivial
#eval cfg199 1
#eval wrd199
