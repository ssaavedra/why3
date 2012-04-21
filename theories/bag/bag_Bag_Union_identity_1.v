(* This file is generated by Why3's Coq driver *)
(* Beware! Only edit allowed sections below    *)
Require Import ZArith.
Require Import Rbase.
Require int.Int.

Parameter bag : forall (a:Type), Type.

Parameter nb_occ: forall (a:Type), a -> (bag a) -> Z.
Implicit Arguments nb_occ.

Axiom occ_non_negative : forall (a:Type), forall (b:(bag a)) (x:a),
  (0%Z <= (nb_occ x b))%Z.

(* Why3 assumption *)
Definition mem (a:Type)(x:a) (b:(bag a)): Prop := (0%Z <  (nb_occ x b))%Z.
Implicit Arguments mem.

(* Why3 assumption *)
Definition eq_bag (a:Type)(a1:(bag a)) (b:(bag a)): Prop := forall (x:a),
  ((nb_occ x a1) = (nb_occ x b)).
Implicit Arguments eq_bag.

Axiom bag_extensionality : forall (a:Type), forall (a1:(bag a)) (b:(bag a)),
  (eq_bag a1 b) -> (a1 = b).

Parameter empty_bag: forall (a:Type), (bag a).
Set Contextual Implicit.
Implicit Arguments empty_bag.
Unset Contextual Implicit.

Axiom occ_empty : forall (a:Type), forall (x:a), ((nb_occ x (empty_bag :(bag
  a))) = 0%Z).

Axiom is_empty : forall (a:Type), forall (b:(bag a)), (forall (x:a),
  ((nb_occ x b) = 0%Z)) -> (b = (empty_bag :(bag a))).

Parameter singleton: forall (a:Type), a -> (bag a).
Implicit Arguments singleton.

Axiom occ_singleton : forall (a:Type), forall (x:a) (y:a), ((x = y) /\
  ((nb_occ y (singleton x)) = 1%Z)) \/ ((~ (x = y)) /\ ((nb_occ y
  (singleton x)) = 0%Z)).

Axiom occ_singleton_eq : forall (a:Type), forall (x:a) (y:a), (x = y) ->
  ((nb_occ y (singleton x)) = 1%Z).

Axiom occ_singleton_neq : forall (a:Type), forall (x:a) (y:a), (~ (x = y)) ->
  ((nb_occ y (singleton x)) = 0%Z).

Parameter union: forall (a:Type), (bag a) -> (bag a) -> (bag a).
Implicit Arguments union.

Axiom occ_union : forall (a:Type), forall (x:a) (a1:(bag a)) (b:(bag a)),
  ((nb_occ x (union a1 b)) = ((nb_occ x a1) + (nb_occ x b))%Z).

Axiom Union_comm : forall (a:Type), forall (a1:(bag a)) (b:(bag a)),
  ((union a1 b) = (union b a1)).


(* Why3 goal *)
Theorem Union_identity : forall (a:Type), forall (a1:(bag a)), ((union a1
  (empty_bag :(bag a))) = a1).
(* YOU MAY EDIT THE PROOF BELOW *)
intros X a.
apply bag_extensionality; intro x.
rewrite occ_union.
rewrite occ_empty; auto with zarith.
Qed.

