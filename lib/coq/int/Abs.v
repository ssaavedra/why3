(* This file is generated by Why3's Coq driver *)
(* Beware! Only edit allowed sections below    *)
Require Import ZArith.
Require Import Rbase.
(*Add Rec LoadPath "/home/guillaume/bin/why3/share/why3/theories".*)
(*Add Rec LoadPath "/home/guillaume/bin/why3/share/why3/modules".*)
Require int.Int.

Notation abs := Zabs (only parsing).

(* YOU MAY EDIT THE CONTEXT BELOW *)

(* DO NOT EDIT BELOW *)

Lemma abs_def : forall (x:Z), ((0%Z <= x)%Z -> ((abs x) = x)) /\
  ((~ (0%Z <= x)%Z) -> ((abs x) = (-x)%Z)).
(* YOU MAY EDIT THE PROOF BELOW *)
intros x.
split ; intros H.
now apply Zabs_eq.
apply Zabs_non_eq.
apply Znot_gt_le.
contradict H.
apply Zlt_le_weak.
now apply Zgt_lt.
Qed.
(* DO NOT EDIT BELOW *)

(* YOU MAY EDIT THE CONTEXT BELOW *)

(* DO NOT EDIT BELOW *)

Lemma Abs_le : forall (x:Z) (y:Z), ((abs x) <= y)%Z <-> (((-y)%Z <= x)%Z /\
  (x <= y)%Z).
(* YOU MAY EDIT THE PROOF BELOW *)
intros x y.
zify.
omega.
Qed.
(* DO NOT EDIT BELOW *)

(* YOU MAY EDIT THE CONTEXT BELOW *)

(* DO NOT EDIT BELOW *)

Lemma Abs_pos : forall (x:Z), (0%Z <= (abs x))%Z.
(* YOU MAY EDIT THE PROOF BELOW *)
exact Zabs_pos.
Qed.
(* DO NOT EDIT BELOW *)

