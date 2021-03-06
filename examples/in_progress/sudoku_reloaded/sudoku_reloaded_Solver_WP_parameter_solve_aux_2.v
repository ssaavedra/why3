(* This file is generated by Why3's Coq driver *)
(* Beware! Only edit allowed sections below    *)
Require Import BuiltIn.
Require BuiltIn.
Require int.Int.
Require int.Abs.
Require int.EuclideanDivision.
Require int.ComputerDivision.
Require int.Power.
Require map.Map.
Require bool.Bool.

(* Why3 assumption *)
Definition unit := unit.

Axiom qtmark : Type.
Parameter qtmark_WhyType : WhyType qtmark.
Existing Instance qtmark_WhyType.

Axiom int31 : Type.
Parameter int31_WhyType : WhyType int31.
Existing Instance int31_WhyType.

Parameter to_int: int31 -> Z.

(* Why3 assumption *)
Definition in_bounds (n:Z): Prop := ((-1073741824%Z)%Z <= n)%Z /\
  (n <= 1073741823%Z)%Z.

Axiom to_int_in_bounds : forall (n:int31), (in_bounds (to_int n)).

Axiom extensionality : forall (x:int31) (y:int31),
  ((to_int x) = (to_int y)) -> (x = y).

Axiom val_two_power_size : (2147483648%Z = (int.Power.power 2%Z 31%Z)).

Axiom t : Type.
Parameter t_WhyType : WhyType t.
Existing Instance t_WhyType.

Parameter nth: t -> Z -> bool.

(* Why3 assumption *)
Definition eq (v1:t) (v2:t): Prop := forall (n:Z), ((0%Z <= n)%Z /\
  (n < 31%Z)%Z) -> ((nth v1 n) = (nth v2 n)).

Axiom Extensionality : forall (x:t) (y:t), (eq x y) -> (x = y).

Parameter zero: t.

Axiom Nth_zero : forall (n:Z), ((0%Z <= n)%Z /\ (n < 31%Z)%Z) -> ((nth zero
  n) = false).

Parameter ones: t.

Axiom Nth_ones : forall (n:Z), ((0%Z <= n)%Z /\ (n < 31%Z)%Z) -> ((nth ones
  n) = true).

Parameter bw_and: t -> t -> t.

Axiom Nth_bw_and : forall (v1:t) (v2:t) (n:Z), ((0%Z <= n)%Z /\
  (n < 31%Z)%Z) -> ((nth (bw_and v1 v2) n) = (Init.Datatypes.andb (nth v1
  n) (nth v2 n))).

Parameter bw_or: t -> t -> t.

Axiom Nth_bw_or : forall (v1:t) (v2:t) (n:Z), ((0%Z <= n)%Z /\
  (n < 31%Z)%Z) -> ((nth (bw_or v1 v2) n) = (Init.Datatypes.orb (nth v1
  n) (nth v2 n))).

Parameter bw_xor: t -> t -> t.

Axiom Nth_bw_xor : forall (v1:t) (v2:t) (n:Z), ((0%Z <= n)%Z /\
  (n < 31%Z)%Z) -> ((nth (bw_xor v1 v2) n) = (Init.Datatypes.xorb (nth v1
  n) (nth v2 n))).

Parameter bw_not: t -> t.

Axiom Nth_bw_not : forall (v:t) (n:Z), ((0%Z <= n)%Z /\ (n < 31%Z)%Z) ->
  ((nth (bw_not v) n) = (Init.Datatypes.negb (nth v n))).

Parameter rotate_left: t -> t.

Axiom Nth_rotate_left_high : forall (v:t) (n:Z), ((0%Z < n)%Z /\
  (n < 31%Z)%Z) -> ((nth (rotate_left v) n) = (nth v (n - 1%Z)%Z)).

Axiom Nth_rotate_left_low : forall (v:t), ((nth (rotate_left v) 0%Z) = (nth v
  (31%Z - 1%Z)%Z)).

Parameter rotate_right: t -> t.

Axiom Nth_rotate_right_high : forall (v:t), ((nth (rotate_right v)
  (31%Z - 1%Z)%Z) = (nth v 0%Z)).

Axiom Nth_rotate_right_low : forall (v:t) (n:Z), ((0%Z <= n)%Z /\
  (n < (31%Z - 1%Z)%Z)%Z) -> ((nth (rotate_right v) n) = (nth v
  (n + 1%Z)%Z)).

Parameter lsr: t -> Z -> t.

Axiom Lsr_nth_low : forall (b:t) (n:Z) (s:Z), ((0%Z <= s)%Z /\
  (s < 31%Z)%Z) -> (((0%Z <= n)%Z /\ (n < 31%Z)%Z) ->
  (((n + s)%Z < 31%Z)%Z -> ((nth (lsr b s) n) = (nth b (n + s)%Z)))).

Axiom Lsr_nth_high : forall (b:t) (n:Z) (s:Z), ((0%Z <= s)%Z /\
  (s < 31%Z)%Z) -> (((0%Z <= n)%Z /\ (n < 31%Z)%Z) ->
  ((31%Z <= (n + s)%Z)%Z -> ((nth (lsr b s) n) = false))).

Parameter lsr_bv: t -> t -> t.

Parameter asr: t -> Z -> t.

Axiom Asr_nth_low : forall (b:t) (n:Z) (s:Z), ((0%Z <= s)%Z /\
  (s < 31%Z)%Z) -> (((0%Z <= n)%Z /\ (n < 31%Z)%Z) ->
  (((0%Z <= (n + s)%Z)%Z /\ ((n + s)%Z < 31%Z)%Z) -> ((nth (asr b s)
  n) = (nth b (n + s)%Z)))).

Axiom Asr_nth_high : forall (b:t) (n:Z) (s:Z), ((0%Z <= s)%Z /\
  (s < 31%Z)%Z) -> (((0%Z <= n)%Z /\ (n < 31%Z)%Z) ->
  ((31%Z <= (n + s)%Z)%Z -> ((nth (asr b s) n) = (nth b (31%Z - 1%Z)%Z)))).

Parameter asr_bv: t -> t -> t.

Parameter lsl: t -> Z -> t.

Axiom Lsl_nth_high : forall (b:t) (n:Z) (s:Z), ((0%Z <= s)%Z /\
  (s < 31%Z)%Z) -> (((0%Z <= n)%Z /\ (n < 31%Z)%Z) ->
  (((0%Z <= (n - s)%Z)%Z /\ ((n - s)%Z < 31%Z)%Z) -> ((nth (lsl b s)
  n) = (nth b (n - s)%Z)))).

Axiom Lsl_nth_low : forall (b:t) (n:Z) (s:Z), ((0%Z <= s)%Z /\
  (s < 31%Z)%Z) -> (((0%Z <= n)%Z /\ (n < 31%Z)%Z) -> (((n - s)%Z < 0%Z)%Z ->
  ((nth (lsl b s) n) = false))).

Parameter lsl_bv: t -> t -> t.

Parameter to_uint: t -> Z.

Axiom to_uint_extensionality : forall (v:t) (v':t),
  ((to_uint v) = (to_uint v')) -> (v = v').

Axiom to_uint_zero : ((to_uint zero) = 0%Z).

Axiom to_uint_ones : ((to_uint ones) = 4294967295%Z).

Parameter to_int1: t -> Z.

Axiom to_int_extensionality : forall (v:t) (v':t),
  ((to_int1 v) = (to_int1 v')) -> (v = v').

Parameter of_int: Z -> t.

Axiom of_int_is_mod : forall (i:Z),
  ((to_uint (of_int i)) = (int.EuclideanDivision.mod1 i 2147483648%Z)).

Axiom of_int_extmod : forall (i:Z) (j:Z), ((of_int i) = (of_int j)) ->
  ((int.EuclideanDivision.mod1 i
  2147483648%Z) = (int.EuclideanDivision.mod1 j 2147483648%Z)).

Parameter of_int_const: Z -> t.

Axiom of_int_const_to_int : forall (i:Z),
  ((to_int1 (of_int_const i)) = (int.EuclideanDivision.mod1 i 2147483648%Z)).

Axiom of_int_const_to_uint : forall (i:Z),
  ((to_uint (of_int_const i)) = (int.EuclideanDivision.mod1 i 2147483648%Z)).

Parameter add: t -> t -> t.

Parameter sub: t -> t -> t.

Parameter neg: t -> t.

Parameter mul: t -> t -> t.

Parameter udiv: t -> t -> t.

Parameter urem: t -> t -> t.

Parameter sdiv: t -> t -> t.

Parameter srem: t -> t -> t.

Parameter smod: t -> t -> t.

(* Why3 assumption *)
Definition slt (v1:t) (v2:t): Prop := ((to_int1 v1) < (to_int1 v2))%Z.

(* Why3 assumption *)
Definition sle (v1:t) (v2:t): Prop := ((to_int1 v1) <= (to_int1 v2))%Z.

(* Why3 assumption *)
Definition sgt (v1:t) (v2:t): Prop := ((to_int1 v2) < (to_int1 v1))%Z.

(* Why3 assumption *)
Definition sge (v1:t) (v2:t): Prop := ((to_int1 v2) <= (to_int1 v1))%Z.

(* Why3 assumption *)
Definition ult (v1:t) (v2:t): Prop := ((to_uint v1) < (to_uint v2))%Z.

(* Why3 assumption *)
Definition ule (v1:t) (v2:t): Prop := ((to_uint v1) <= (to_uint v2))%Z.

(* Why3 assumption *)
Definition ugt (v1:t) (v2:t): Prop := ((to_uint v2) < (to_uint v1))%Z.

(* Why3 assumption *)
Definition uge (v1:t) (v2:t): Prop := ((to_uint v2) <= (to_uint v1))%Z.

(* Why3 assumption *)
Definition grid := (map.Map.map Z int31).

(* Why3 assumption *)
Definition is_index (i:Z): Prop := (0%Z <= i)%Z /\ (i < 81%Z)%Z.

(* Why3 assumption *)
Definition valid_values (g:(map.Map.map Z int31)): Prop := forall (i:Z),
  (is_index i) -> ((0%Z <= (to_int (map.Map.get g i)))%Z /\
  ((to_int (map.Map.get g i)) <= 9%Z)%Z).

(* Why3 assumption *)
Definition grid_eq_sub (g1:(map.Map.map Z int31)) (g2:(map.Map.map Z int31))
  (a:Z) (b:Z): Prop := forall (j:Z), ((a <= j)%Z /\ (j < b)%Z) ->
  ((to_int (map.Map.get g1 j)) = (to_int (map.Map.get g2 j))).

Axiom grid_eq_sub1 : forall (g1:(map.Map.map Z int31)) (g2:(map.Map.map Z
  int31)) (a:Z) (b:Z), (((0%Z <= a)%Z /\ (a <= 81%Z)%Z) /\ (((0%Z <= b)%Z /\
  (b <= 81%Z)%Z) /\ (grid_eq_sub g1 g2 0%Z 81%Z))) -> (grid_eq_sub g1 g2 a
  b).

(* Why3 assumption *)
Inductive array
  (a:Type) :=
  | mk_array : int31 -> (map.Map.map Z a) -> array a.
Axiom array_WhyType : forall (a:Type) {a_WT:WhyType a}, WhyType (array a).
Existing Instance array_WhyType.
Implicit Arguments mk_array [[a]].

(* Why3 assumption *)
Definition elts {a:Type} {a_WT:WhyType a} (v:(array a)): (map.Map.map Z a) :=
  match v with
  | (mk_array x x1) => x1
  end.

(* Why3 assumption *)
Definition length {a:Type} {a_WT:WhyType a} (v:(array a)): int31 :=
  match v with
  | (mk_array x x1) => x
  end.

(* Why3 assumption *)
Definition get {a:Type} {a_WT:WhyType a} (a1:(array a)) (i:Z): a :=
  (map.Map.get (elts a1) i).

(* Why3 assumption *)
Definition set {a:Type} {a_WT:WhyType a} (a1:(array a)) (i:Z) (v:a): (array
  a) := (mk_array (length a1) (map.Map.set (elts a1) i v)).

(* Why3 assumption *)
Definition make {a:Type} {a_WT:WhyType a} (n:int31) (v:a): (array a) :=
  (mk_array n (map.Map.const v: (map.Map.map Z a))).

(* Why3 assumption *)
Inductive sudoku_chunks :=
  | mk_sudoku_chunks : (array int31) -> (array int31) -> (array int31) ->
      (array int31) -> (array int31) -> (array int31) -> sudoku_chunks.
Axiom sudoku_chunks_WhyType : WhyType sudoku_chunks.
Existing Instance sudoku_chunks_WhyType.

(* Why3 assumption *)
Definition square_offsets (v:sudoku_chunks): (array int31) :=
  match v with
  | (mk_sudoku_chunks x x1 x2 x3 x4 x5) => x5
  end.

(* Why3 assumption *)
Definition square_start (v:sudoku_chunks): (array int31) :=
  match v with
  | (mk_sudoku_chunks x x1 x2 x3 x4 x5) => x4
  end.

(* Why3 assumption *)
Definition row_offsets (v:sudoku_chunks): (array int31) :=
  match v with
  | (mk_sudoku_chunks x x1 x2 x3 x4 x5) => x3
  end.

(* Why3 assumption *)
Definition row_start (v:sudoku_chunks): (array int31) :=
  match v with
  | (mk_sudoku_chunks x x1 x2 x3 x4 x5) => x2
  end.

(* Why3 assumption *)
Definition column_offsets (v:sudoku_chunks): (array int31) :=
  match v with
  | (mk_sudoku_chunks x x1 x2 x3 x4 x5) => x1
  end.

(* Why3 assumption *)
Definition column_start (v:sudoku_chunks): (array int31) :=
  match v with
  | (mk_sudoku_chunks x x1 x2 x3 x4 x5) => x
  end.

(* Why3 assumption *)
Definition chunk_valid_indexes (start:(array int31)) (offsets:(array
  int31)): Prop := ((to_int (length start)) = 81%Z) /\
  (((to_int (length offsets)) = 9%Z) /\ forall (i:Z) (o:Z), ((is_index i) /\
  ((0%Z <= o)%Z /\ (o < 9%Z)%Z)) -> (is_index ((to_int (get start
  i)) + (to_int (get offsets o)))%Z)).

(* Why3 assumption *)
Definition disjoint_chunks (start:(array int31)) (offsets:(array
  int31)): Prop := ((to_int (length start)) = 81%Z) /\
  (((to_int (length offsets)) = 9%Z) /\ forall (i1:Z) (i2:Z) (o:Z),
  ((is_index i1) /\ ((is_index i2) /\ ((0%Z <= o)%Z /\ (o < 9%Z)%Z))) ->
  let s2 := (to_int (get start i2)) in ((~ ((to_int (get start i1)) = s2)) ->
  ~ (i1 = (s2 + (to_int (get offsets o)))%Z))).

(* Why3 assumption *)
Definition well_formed_sudoku (s:sudoku_chunks): Prop := (chunk_valid_indexes
  (column_start s) (column_offsets s)) /\ ((chunk_valid_indexes (row_start s)
  (row_offsets s)) /\ ((chunk_valid_indexes (square_start s)
  (square_offsets s)) /\ ((disjoint_chunks (column_start s)
  (column_offsets s)) /\ ((disjoint_chunks (row_start s) (row_offsets s)) /\
  (disjoint_chunks (square_start s) (square_offsets s)))))).

(* Why3 assumption *)
Definition valid_chunk (g:(map.Map.map Z int31)) (i:Z) (start:(array int31))
  (offsets:(array int31)): Prop := let s := (to_int (get start i)) in
  forall (o1:Z) (o2:Z), (((0%Z <= o1)%Z /\ (o1 < 9%Z)%Z) /\
  (((0%Z <= o2)%Z /\ (o2 < 9%Z)%Z) /\ ~ (o1 = o2))) -> let i1 :=
  (s + (to_int (get offsets o1)))%Z in let i2 := (s + (to_int (get offsets
  o2)))%Z in ((((1%Z <= (to_int (map.Map.get g i1)))%Z /\
  ((to_int (map.Map.get g i1)) <= 9%Z)%Z) /\ ((1%Z <= (to_int (map.Map.get g
  i2)))%Z /\ ((to_int (map.Map.get g i2)) <= 9%Z)%Z)) ->
  ~ ((to_int (map.Map.get g i1)) = (to_int (map.Map.get g i2)))).

(* Why3 assumption *)
Definition valid_column (s:sudoku_chunks) (g:(map.Map.map Z int31))
  (i:Z): Prop := (valid_chunk g i (column_start s) (column_offsets s)).

(* Why3 assumption *)
Definition valid_row (s:sudoku_chunks) (g:(map.Map.map Z int31))
  (i:Z): Prop := (valid_chunk g i (row_start s) (row_offsets s)).

(* Why3 assumption *)
Definition valid_square (s:sudoku_chunks) (g:(map.Map.map Z int31))
  (i:Z): Prop := (valid_chunk g i (square_start s) (square_offsets s)).

(* Why3 assumption *)
Definition valid (s:sudoku_chunks) (g:(map.Map.map Z int31)): Prop :=
  forall (i:Z), (is_index i) -> ((valid_column s g i) /\ ((valid_row s g
  i) /\ (valid_square s g i))).

(* Why3 assumption *)
Definition full (g:(map.Map.map Z int31)): Prop := forall (i:Z), (is_index
  i) -> ((1%Z <= (to_int (map.Map.get g i)))%Z /\ ((to_int (map.Map.get g
  i)) <= 9%Z)%Z).

(* Why3 assumption *)
Definition included (g1:(map.Map.map Z int31)) (g2:(map.Map.map Z
  int31)): Prop := forall (i:Z), ((is_index i) /\
  ((1%Z <= (to_int (map.Map.get g1 i)))%Z /\ ((to_int (map.Map.get g1
  i)) <= 9%Z)%Z)) -> ((to_int (map.Map.get g2 i)) = (to_int (map.Map.get g1
  i))).

Axiom subset_valid_chunk : forall (g:(map.Map.map Z int31)) (h:(map.Map.map Z
  int31)), (included g h) -> forall (i:Z) (s:(array int31)) (o:(array
  int31)), ((is_index i) /\ ((chunk_valid_indexes s o) /\ (valid_chunk h i s
  o))) -> (valid_chunk g i s o).

Axiom subset_valid : forall (s:sudoku_chunks) (g:(map.Map.map Z int31))
  (h:(map.Map.map Z int31)), ((well_formed_sudoku s) /\ ((included g h) /\
  (valid s h))) -> (valid s g).

(* Why3 assumption *)
Definition is_solution_for (s:sudoku_chunks) (sol:(map.Map.map Z int31))
  (data:(map.Map.map Z int31)): Prop := (included data sol) /\ ((full sol) /\
  (valid s sol)).

(* Why3 assumption *)
Inductive array1 (a:Type) :=
  | mk_array1 : Z -> (map.Map.map Z a) -> array1 a.
Axiom array1_WhyType : forall (a:Type) {a_WT:WhyType a}, WhyType (array1 a).
Existing Instance array1_WhyType.
Implicit Arguments mk_array1 [[a]].

(* Why3 assumption *)
Definition elts1 {a:Type} {a_WT:WhyType a} (v:(array1 a)): (map.Map.map Z
  a) := match v with
  | (mk_array1 x x1) => x1
  end.

(* Why3 assumption *)
Definition length1 {a:Type} {a_WT:WhyType a} (v:(array1 a)): Z :=
  match v with
  | (mk_array1 x x1) => x
  end.

(* Why3 assumption *)
Definition get1 {a:Type} {a_WT:WhyType a} (a1:(array1 a)) (i:Z): a :=
  (map.Map.get (elts1 a1) i).

(* Why3 assumption *)
Definition set1 {a:Type} {a_WT:WhyType a} (a1:(array1 a)) (i:Z)
  (v:a): (array1 a) := (mk_array1 (length1 a1) (map.Map.set (elts1 a1) i v)).

(* Why3 assumption *)
Definition make1 {a:Type} {a_WT:WhyType a} (n:Z) (v:a): (array1 a) :=
  (mk_array1 n (map.Map.const v: (map.Map.map Z a))).

(* Why3 assumption *)
Definition valid_chunk_up_to (g:(map.Map.map Z int31)) (i:Z) (start:(array
  int31)) (offsets:(array int31)) (off:Z): Prop := let s :=
  (to_int (get start i)) in forall (o1:Z) (o2:Z), (((0%Z <= o1)%Z /\
  (o1 < off)%Z) /\ (((0%Z <= o2)%Z /\ (o2 < off)%Z) /\ ~ (o1 = o2))) ->
  let i1 := (s + (to_int (get offsets o1)))%Z in let i2 :=
  (s + (to_int (get offsets o2)))%Z in ((((1%Z <= (to_int (map.Map.get g
  i1)))%Z /\ ((to_int (map.Map.get g i1)) <= 9%Z)%Z) /\
  ((1%Z <= (to_int (map.Map.get g i2)))%Z /\ ((to_int (map.Map.get g
  i2)) <= 9%Z)%Z)) -> ~ ((to_int (map.Map.get g i1)) = (to_int (map.Map.get g
  i2)))).

(* Why3 assumption *)
Inductive ref (a:Type) :=
  | mk_ref : a -> ref a.
Axiom ref_WhyType : forall (a:Type) {a_WT:WhyType a}, WhyType (ref a).
Existing Instance ref_WhyType.
Implicit Arguments mk_ref [[a]].

(* Why3 assumption *)
Definition contents {a:Type} {a_WT:WhyType a} (v:(ref a)): a :=
  match v with
  | (mk_ref x) => x
  end.

(* Why3 assumption *)
Definition valid_up_to (s:sudoku_chunks) (g:(map.Map.map Z int31))
  (i:Z): Prop := forall (j:Z), ((0%Z <= j)%Z /\ (j < i)%Z) -> ((valid_column
  s g j) /\ ((valid_row s g j) /\ (valid_square s g j))).

(* Why3 assumption *)
Definition full_up_to (g:(map.Map.map Z int31)) (i:Z): Prop := forall (j:Z),
  ((0%Z <= j)%Z /\ (j < i)%Z) -> ((1%Z <= (to_int (map.Map.get g j)))%Z /\
  ((to_int (map.Map.get g j)) <= 9%Z)%Z).

Axiom full_up_to_change : forall (g:(map.Map.map Z int31)) (i:Z) (x:int31),
  ((is_index i) /\ (full_up_to g i)) -> (((1%Z <= (to_int x))%Z /\
  ((to_int x) <= 9%Z)%Z) -> (full_up_to (map.Map.set g i x) (i + 1%Z)%Z)).

Axiom full_up_to_frame : forall (g1:(map.Map.map Z int31)) (g2:(map.Map.map Z
  int31)) (i:Z), (((0%Z <= i)%Z /\ (i <= 81%Z)%Z) /\ ((grid_eq_sub g1 g2 0%Z
  i) /\ (full_up_to g1 i))) -> (full_up_to g2 i).

Axiom full_up_to_frame_all : forall (g1:(map.Map.map Z int31))
  (g2:(map.Map.map Z int31)) (i:Z), (((0%Z <= i)%Z /\ (i <= 81%Z)%Z) /\
  ((grid_eq_sub g1 g2 0%Z 81%Z) /\ (full_up_to g1 i))) -> (full_up_to g2 i).

Axiom valid_unchanged_chunks : forall (g:(map.Map.map Z int31)) (i1:Z) (i2:Z)
  (k:int31) (start:(array int31)) (offsets:(array int31)), (disjoint_chunks
  start offsets) -> (((is_index i1) /\ ((is_index i2) /\
  ((1%Z <= (to_int k))%Z /\ ((to_int k) <= 9%Z)%Z))) -> (((~ ((get start
  i1) = (get start i2))) /\ (valid_chunk g i2 start offsets)) -> (valid_chunk
  (map.Map.set g i1 k) i2 start offsets))).

Axiom valid_changed_chunks : forall (g:(map.Map.map Z int31)) (i1:Z) (i2:Z)
  (k:int31) (start:(array int31)) (offsets:(array int31)), ((is_index i1) /\
  ((is_index i2) /\ ((1%Z <= (to_int k))%Z /\ ((to_int k) <= 9%Z)%Z))) ->
  let h := (map.Map.set g i1 k) in ((((get start i1) = (get start i2)) /\
  (valid_chunk h i1 start offsets)) -> (valid_chunk h i2 start offsets)).

Axiom valid_up_to_change : forall (s:sudoku_chunks) (g:(map.Map.map Z int31))
  (i:Z) (x:int31), ((well_formed_sudoku s) /\ ((is_index i) /\ ((valid_up_to
  s g i) /\ (((1%Z <= (to_int x))%Z /\ ((to_int x) <= 9%Z)%Z) /\
  ((valid_column s (map.Map.set g i x) i) /\ ((valid_row s (map.Map.set g i
  x) i) /\ (valid_square s (map.Map.set g i x) i))))))) -> (valid_up_to s
  (map.Map.set g i x) (i + 1%Z)%Z).

(* Why3 goal *)
Theorem WP_parameter_solve_aux : forall (s:int31) (s1:(map.Map.map Z int31))
  (s2:int31) (s3:(map.Map.map Z int31)) (s4:int31) (s5:(map.Map.map Z int31))
  (s6:int31) (s7:(map.Map.map Z int31)) (s8:int31) (s9:(map.Map.map Z int31))
  (s10:int31) (s11:(map.Map.map Z int31)) (g:int31) (g1:(map.Map.map Z
  int31)) (i:int31), let s12 := (mk_sudoku_chunks (mk_array s s1)
  (mk_array s2 s3) (mk_array s4 s5) (mk_array s6 s7) (mk_array s8 s9)
  (mk_array s10 s11)) in (((((0%Z <= (to_int s))%Z /\
  ((0%Z <= (to_int s2))%Z /\ ((0%Z <= (to_int s4))%Z /\
  ((0%Z <= (to_int s6))%Z /\ ((0%Z <= (to_int s8))%Z /\
  (0%Z <= (to_int s10))%Z))))) /\ (0%Z <= (to_int g))%Z) /\
  ((well_formed_sudoku s12) /\ (((to_int g) = 81%Z) /\ ((valid_values g1) /\
  (((0%Z <= (to_int i))%Z /\ ((to_int i) <= 81%Z)%Z) /\ ((valid_up_to s12 g1
  (to_int i)) /\ (full_up_to g1 (to_int i)))))))) -> ((in_bounds 0%Z) ->
  forall (n0:int31), ((to_int n0) = 0%Z) -> ((in_bounds 1%Z) ->
  forall (n1:int31), ((to_int n1) = 1%Z) -> ((in_bounds 9%Z) ->
  forall (n9:int31), ((to_int n9) = 9%Z) -> ((in_bounds 81%Z) ->
  forall (n81:int31), ((to_int n81) = 81%Z) -> forall (result:bool),
  ((result = true) <-> ((to_int i) = (to_int n81))) ->
  ((~ (result = true)) -> (((0%Z <= (to_int i))%Z /\
  ((to_int i) < (to_int g))%Z) -> (((map.Map.get g1 (to_int i)) = n0) ->
  forall (k:int31) (g2:(map.Map.map Z int31)), (((1%Z <= (to_int k))%Z /\
  ((to_int k) <= 10%Z)%Z) /\ ((grid_eq_sub g1 (map.Map.set g2 (to_int i) n0)
  0%Z 81%Z) /\ ((full_up_to g2 (to_int i)) /\ forall (k':int31),
  ((1%Z <= (to_int k'))%Z /\ ((to_int k') < (to_int k))%Z) ->
  forall (h:(map.Map.map Z int31)), ((included (map.Map.set g1 (to_int i) k')
  h) /\ (full h)) -> ~ (valid s12 h)))) -> forall (result1:bool),
  ((result1 = true) <-> ((to_int k) <= (to_int n9))%Z) ->
  ((result1 = true) -> (((0%Z <= (to_int g))%Z /\ ((0%Z <= (to_int i))%Z /\
  ((to_int i) < (to_int g))%Z)) -> forall (g3:(map.Map.map Z int31)),
  ((0%Z <= (to_int g))%Z /\ (g3 = (map.Map.set g2 (to_int i) k))) -> let o :=
  (mk_array s2 s3) in let o1 := (mk_array s s1) in ((((to_int g) = 81%Z) /\
  ((valid_values g3) /\ ((is_index (to_int i)) /\ (chunk_valid_indexes o1
  o)))) -> ((valid_chunk g3 (to_int i) o1 o) -> let o2 := (mk_array s6 s7) in
  let o3 := (mk_array s4 s5) in ((((to_int g) = 81%Z) /\ ((valid_values
  g3) /\ ((is_index (to_int i)) /\ (chunk_valid_indexes o3 o2)))) ->
  ((~ (valid_chunk g3 (to_int i) o3 o2)) -> ((grid_eq_sub g3 (map.Map.set g1
  (to_int i) k) 0%Z 81%Z) -> ~ (valid s12 (map.Map.set g1 (to_int i)
  k))))))))))))))))).
(* Why3 intros s s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 g g1 i s12
        (((h1,(h2,(h3,(h4,(h5,h6))))),h7),(h8,(h9,(h10,((h11,h12),(h13,h14))))))
        h15 n0 h16 h17 n1 h18 h19 n9 h20 h21 n81 h22 result h23 h24 (h25,h26)
        h27 k g2 ((h28,h29),(h30,(h31,h32))) result1 h33 h34 (h35,(h36,h37))
        g3 (h38,h39) o o1 (h40,(h41,(h42,h43))) h44 o2 o3
        (h45,(h46,(h47,h48))) h49 h50. *)
intros s s1 s2 s3 s4 s5 s6 s7 s8 s9 s10 s11 g g1 i s12
(((h1,(h2,(h3,(h4,(h5,h6))))),h7),(h8,(h9,(h10,((h11,h12),(h13,h14)))))) h15
n0 h16 h17 n1 h18 h19 n9 h20 h21 n81 h22 result h23 h24 (h25,h26) h27 k g2
((h28,h29),(h30,(h31,h32))) result1 h33 h34 (h35,(h36,h37)) g3 (h38,h39) o o1
(h40,(h41,(h42,h43))) h44 o2 o3 (h45,(h46,(h47,h48))) h49.
intro h; apply h49; clear h49.
unfold valid in h.
generalize (proj1 (proj2 (h (to_int i) h47))); clear h.
unfold valid_row; intro H.
unfold row_start, row_offsets in H.
simpl in H.
subst o3 o2.
clear h44.
subst g3.
Qed.

