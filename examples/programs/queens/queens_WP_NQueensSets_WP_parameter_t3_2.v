(* This file is generated by Why3's Coq driver *)
(* Beware! Only edit allowed sections below    *)
Require Import ZArith.
Require Import Rbase.
Require int.Int.

(* Why3 assumption *)
Definition unit  := unit.

Parameter set : forall (a:Type), Type.

Parameter mem: forall (a:Type), a -> (set a) -> Prop.
Implicit Arguments mem.

(* Why3 assumption *)
Definition infix_eqeq (a:Type)(s1:(set a)) (s2:(set a)): Prop :=
  forall (x:a), (mem x s1) <-> (mem x s2).
Implicit Arguments infix_eqeq.

Axiom extensionality : forall (a:Type), forall (s1:(set a)) (s2:(set a)),
  (infix_eqeq s1 s2) -> (s1 = s2).

(* Why3 assumption *)
Definition subset (a:Type)(s1:(set a)) (s2:(set a)): Prop := forall (x:a),
  (mem x s1) -> (mem x s2).
Implicit Arguments subset.

Axiom subset_trans : forall (a:Type), forall (s1:(set a)) (s2:(set a))
  (s3:(set a)), (subset s1 s2) -> ((subset s2 s3) -> (subset s1 s3)).

Parameter empty: forall (a:Type), (set a).
Set Contextual Implicit.
Implicit Arguments empty.
Unset Contextual Implicit.

(* Why3 assumption *)
Definition is_empty (a:Type)(s:(set a)): Prop := forall (x:a), ~ (mem x s).
Implicit Arguments is_empty.

Axiom empty_def1 : forall (a:Type), (is_empty (empty :(set a))).

Parameter add: forall (a:Type), a -> (set a) -> (set a).
Implicit Arguments add.

Axiom add_def1 : forall (a:Type), forall (x:a) (y:a), forall (s:(set a)),
  (mem x (add y s)) <-> ((x = y) \/ (mem x s)).

Parameter remove: forall (a:Type), a -> (set a) -> (set a).
Implicit Arguments remove.

Axiom remove_def1 : forall (a:Type), forall (x:a) (y:a) (s:(set a)), (mem x
  (remove y s)) <-> ((~ (x = y)) /\ (mem x s)).

Axiom subset_remove : forall (a:Type), forall (x:a) (s:(set a)),
  (subset (remove x s) s).

Parameter union: forall (a:Type), (set a) -> (set a) -> (set a).
Implicit Arguments union.

Axiom union_def1 : forall (a:Type), forall (s1:(set a)) (s2:(set a)) (x:a),
  (mem x (union s1 s2)) <-> ((mem x s1) \/ (mem x s2)).

Parameter inter: forall (a:Type), (set a) -> (set a) -> (set a).
Implicit Arguments inter.

Axiom inter_def1 : forall (a:Type), forall (s1:(set a)) (s2:(set a)) (x:a),
  (mem x (inter s1 s2)) <-> ((mem x s1) /\ (mem x s2)).

Parameter diff: forall (a:Type), (set a) -> (set a) -> (set a).
Implicit Arguments diff.

Axiom diff_def1 : forall (a:Type), forall (s1:(set a)) (s2:(set a)) (x:a),
  (mem x (diff s1 s2)) <-> ((mem x s1) /\ ~ (mem x s2)).

Axiom subset_diff : forall (a:Type), forall (s1:(set a)) (s2:(set a)),
  (subset (diff s1 s2) s1).

Parameter choose: forall (a:Type), (set a) -> a.
Implicit Arguments choose.

Axiom choose_def : forall (a:Type), forall (s:(set a)), (~ (is_empty s)) ->
  (mem (choose s) s).

Parameter cardinal: forall (a:Type), (set a) -> Z.
Implicit Arguments cardinal.

Axiom cardinal_nonneg : forall (a:Type), forall (s:(set a)),
  (0%Z <= (cardinal s))%Z.

Axiom cardinal_empty : forall (a:Type), forall (s:(set a)),
  ((cardinal s) = 0%Z) <-> (is_empty s).

Axiom cardinal_add : forall (a:Type), forall (x:a), forall (s:(set a)),
  (~ (mem x s)) -> ((cardinal (add x s)) = (1%Z + (cardinal s))%Z).

Axiom cardinal_remove : forall (a:Type), forall (x:a), forall (s:(set a)),
  (mem x s) -> ((cardinal s) = (1%Z + (cardinal (remove x s)))%Z).

Axiom cardinal_subset : forall (a:Type), forall (s1:(set a)) (s2:(set a)),
  (subset s1 s2) -> ((cardinal s1) <= (cardinal s2))%Z.

Axiom cardinal1 : forall (a:Type), forall (s:(set a)),
  ((cardinal s) = 1%Z) -> forall (x:a), (mem x s) -> (x = (choose s)).

Parameter nth: forall (a:Type), Z -> (set a) -> a.
Implicit Arguments nth.

Axiom nth_injective : forall (a:Type), forall (s:(set a)) (i:Z) (j:Z),
  ((0%Z <= i)%Z /\ (i < (cardinal s))%Z) -> (((0%Z <= j)%Z /\
  (j < (cardinal s))%Z) -> (((nth i s) = (nth j s)) -> (i = j))).

Axiom nth_surjective : forall (a:Type), forall (s:(set a)) (x:a), (mem x
  s) -> exists i:Z, ((0%Z <= i)%Z /\ (i < (cardinal s))%Z) -> (x = (nth i
  s)).

Parameter min_elt: (set Z) -> Z.

Axiom min_elt_def1 : forall (s:(set Z)), (~ (is_empty s)) -> (mem (min_elt s)
  s).

Axiom min_elt_def2 : forall (s:(set Z)), (~ (is_empty s)) -> forall (x:Z),
  (mem x s) -> ((min_elt s) <= x)%Z.

Parameter max_elt: (set Z) -> Z.

Axiom max_elt_def1 : forall (s:(set Z)), (~ (is_empty s)) -> (mem (max_elt s)
  s).

Axiom max_elt_def2 : forall (s:(set Z)), (~ (is_empty s)) -> forall (x:Z),
  (mem x s) -> (x <= (max_elt s))%Z.

Parameter below: Z -> (set Z).

Axiom below_def : forall (x:Z) (n:Z), (mem x (below n)) <-> ((0%Z <= x)%Z /\
  (x < n)%Z).

Axiom cardinal_below : forall (n:Z), ((0%Z <= n)%Z ->
  ((cardinal (below n)) = n)) /\ ((~ (0%Z <= n)%Z) ->
  ((cardinal (below n)) = 0%Z)).

Parameter succ: (set Z) -> (set Z).

Axiom succ_def : forall (s:(set Z)) (i:Z), (mem i (succ s)) <->
  ((1%Z <= i)%Z /\ (mem (i - 1%Z)%Z s)).

Parameter pred: (set Z) -> (set Z).

Axiom pred_def : forall (s:(set Z)) (i:Z), (mem i (pred s)) <->
  ((0%Z <= i)%Z /\ (mem (i + 1%Z)%Z s)).

(* Why3 assumption *)
Inductive ref (a:Type) :=
  | mk_ref : a -> ref a.
Implicit Arguments mk_ref.

(* Why3 assumption *)
Definition contents (a:Type)(v:(ref a)): a :=
  match v with
  | (mk_ref x) => x
  end.
Implicit Arguments contents.

Parameter map : forall (a:Type) (b:Type), Type.

Parameter get: forall (a:Type) (b:Type), (map a b) -> a -> b.
Implicit Arguments get.

Parameter set1: forall (a:Type) (b:Type), (map a b) -> a -> b -> (map a b).
Implicit Arguments set1.

Axiom Select_eq : forall (a:Type) (b:Type), forall (m:(map a b)),
  forall (a1:a) (a2:a), forall (b1:b), (a1 = a2) -> ((get (set1 m a1 b1)
  a2) = b1).

Axiom Select_neq : forall (a:Type) (b:Type), forall (m:(map a b)),
  forall (a1:a) (a2:a), forall (b1:b), (~ (a1 = a2)) -> ((get (set1 m a1 b1)
  a2) = (get m a2)).

Parameter const: forall (a:Type) (b:Type), b -> (map a b).
Set Contextual Implicit.
Implicit Arguments const.
Unset Contextual Implicit.

Axiom Const : forall (a:Type) (b:Type), forall (b1:b) (a1:a),
  ((get (const b1:(map a b)) a1) = b1).

Parameter n: Z.

(* Why3 assumption *)
Definition solution  := (map Z Z).

(* Why3 assumption *)
Definition eq_prefix (a:Type)(t:(map Z a)) (u:(map Z a)) (i:Z): Prop :=
  forall (k:Z), ((0%Z <= k)%Z /\ (k < i)%Z) -> ((get t k) = (get u k)).
Implicit Arguments eq_prefix.

(* Why3 assumption *)
Definition partial_solution(k:Z) (s:(map Z Z)): Prop := forall (i:Z),
  ((0%Z <= i)%Z /\ (i < k)%Z) -> (((0%Z <= (get s i))%Z /\ ((get s
  i) < n)%Z) /\ forall (j:Z), ((0%Z <= j)%Z /\ (j < i)%Z) -> ((~ ((get s
  i) = (get s j))) /\ ((~ (((get s i) - (get s j))%Z = (i - j)%Z)) /\
  ~ (((get s i) - (get s j))%Z = (j - i)%Z)))).

Axiom partial_solution_eq_prefix : forall (u:(map Z Z)) (t:(map Z Z)) (k:Z),
  (partial_solution k t) -> ((eq_prefix t u k) -> (partial_solution k u)).

(* Why3 assumption *)
Definition lt_sol(s1:(map Z Z)) (s2:(map Z Z)): Prop := exists i:Z,
  ((0%Z <= i)%Z /\ (i < n)%Z) /\ ((eq_prefix s1 s2 i) /\ ((get s1
  i) < (get s2 i))%Z).

(* Why3 assumption *)
Definition solutions  := (map Z (map Z Z)).

(* Why3 assumption *)
Definition sorted(s:(map Z (map Z Z))) (a:Z) (b:Z): Prop := forall (i:Z)
  (j:Z), (((a <= i)%Z /\ (i < j)%Z) /\ (j < b)%Z) -> (lt_sol (get s i) (get s
  j)).

Axiom no_duplicate : forall (s:(map Z (map Z Z))) (a:Z) (b:Z), (sorted s a
  b) -> forall (i:Z) (j:Z), (((a <= i)%Z /\ (i < j)%Z) /\ (j < b)%Z) ->
  ~ (eq_prefix (get s i) (get s j) n).



(* Why3 goal *)
Theorem WP_parameter_t3 : forall (a:(set Z)) (b:(set Z)) (c:(set Z)),
  forall (s:Z) (sol:(map Z (map Z Z))) (k:Z) (col:(map Z Z)),
  ((0%Z <= k)%Z /\ (((k + (cardinal a))%Z = n) /\ ((0%Z <= s)%Z /\
  ((forall (i:Z), (mem i a) <-> (((0%Z <= i)%Z /\ (i < n)%Z) /\ forall (j:Z),
  ((0%Z <= j)%Z /\ (j < k)%Z) -> ~ ((get col j) = i))) /\ ((forall (i:Z),
  (0%Z <= i)%Z -> ((~ (mem i b)) <-> forall (j:Z), ((0%Z <= j)%Z /\
  (j < k)%Z) -> ~ ((get col j) = ((i + j)%Z - k)%Z))) /\ ((forall (i:Z),
  (0%Z <= i)%Z -> ((~ (mem i c)) <-> forall (j:Z), ((0%Z <= j)%Z /\
  (j < k)%Z) -> ~ ((get col j) = ((i + k)%Z - j)%Z))) /\ (partial_solution k
  col))))))) -> ((~ (is_empty a)) -> forall (f:Z) (e:(set Z)) (s1:Z)
  (sol1:(map Z (map Z Z))) (k1:Z) (col1:(map Z Z)), (((f = (s1 - s)%Z) /\
  (0%Z <= (s1 - s)%Z)%Z) /\ ((k1 = k) /\ ((subset e (diff (diff a b) c)) /\
  ((partial_solution k1 col1) /\ ((sorted sol1 s s1) /\ ((forall (i:Z) (j:Z),
  (mem i (diff (diff (diff a b) c) e)) -> ((mem j e) -> (i < j)%Z)) /\
  ((forall (t:(map Z Z)), ((partial_solution n t) /\ ((eq_prefix col1 t
  k1) /\ (mem (get t k1) (diff (diff (diff a b) c) e)))) <-> exists i:Z,
  ((s <= i)%Z /\ (i < s1)%Z) /\ (eq_prefix t (get sol1 i) n)) /\
  ((eq_prefix col col1 k1) /\ (eq_prefix sol sol1 s))))))))) ->
  ((is_empty e) -> forall (t:(map Z Z)), ((partial_solution n t) /\
  (eq_prefix col1 t k1)) -> exists i:Z, ((s <= i)%Z /\ (i < s1)%Z) /\
  (eq_prefix t (get sol1 i) n))).
(* YOU MAY EDIT THE PROOF BELOW *)
intuition.
subst k1.
assert (k < n)%Z.
generalize (cardinal_nonneg _ a).
generalize (cardinal_empty _ a).
intuition.
assert (case: (cardinal a = 0 \/ cardinal a > 0)%Z) by omega. destruct case.
absurd (is_empty a); auto.
omega.
destruct (H15 t) as (h1,_).
apply h1; intuition.
destruct (diff_def1 _ (diff (diff a b) c) e (get t k)) as (_, h); apply h; clear h; split.
destruct (diff_def1 _ (diff a b) c (get t k)) as (_, h); apply h; clear h; split.
destruct (diff_def1 _ a b (get t k)) as (_, h); apply h; clear h; split.
(* mem .. a *)
destruct (H3 (get t k)) as (_,h); apply h; clear h.
split.
destruct (H19 k) as (h,_).
omega.
assumption.
intros j hj.
rewrite H16.
rewrite H20.
destruct (H19 k) as (_,h). omega.
destruct (h j); intuition.
assumption.
assumption.
(* not (mem ... b) *)
destruct (H4 (get t k)) as (_,h).
destruct (H19 k); omega.
red; intro h1; apply h; clear h; auto.
intros j hj.
rewrite H16; try omega.
rewrite H20; try omega.
destruct (H19 k); intuition.
destruct (H22 j); intuition.
(* not (mem ... c) *)
destruct (H5 (get t k)) as (_,h).
destruct (H19 k); omega.
red; intro h1; apply h; clear h; auto.
intros j hj.
rewrite H16; try omega.
rewrite H20; try omega.
destruct (H19 k); intuition.
destruct (H22 j); intuition.
(* not (mem ... e) *)
apply H8.
Qed.


