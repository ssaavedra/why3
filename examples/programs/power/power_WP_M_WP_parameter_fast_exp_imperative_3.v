(* This file is generated by Why3's Coq driver *)
(* Beware! Only edit allowed sections below    *)
Require Import ZArith.
Require Import Rbase.
Require Import ZOdiv.
Definition unit  := unit.

Parameter mark : Type.

Parameter at1: forall (a:Type), a -> mark -> a.

Implicit Arguments at1.

Parameter old: forall (a:Type), a -> a.

Implicit Arguments old.

Axiom Abs_le : forall (x:Z) (y:Z), ((Zabs x) <= y)%Z <-> (((-y)%Z <= x)%Z /\
  (x <= y)%Z).

Parameter power: Z -> Z -> Z.


Axiom Power_0 : forall (x:Z), ((power x 0%Z) = 1%Z).

Axiom Power_s : forall (x:Z) (n:Z), (0%Z <  n)%Z -> ((power x
  n) = (x * (power x (n - 1%Z)%Z))%Z).

Axiom Power_1 : forall (x:Z), ((power x 1%Z) = x).

Axiom Power_sum : forall (x:Z) (n:Z) (m:Z), (0%Z <= n)%Z -> ((0%Z <= m)%Z ->
  ((power x (n + m)%Z) = ((power x n) * (power x m))%Z)).

Axiom Power_mult : forall (x:Z) (n:Z) (m:Z), (0%Z <= n)%Z -> ((0%Z <= m)%Z ->
  ((power x (n * m)%Z) = (power (power x n) m))).

Axiom Power_mult2 : forall (x:Z) (y:Z) (n:Z), (0%Z <= n)%Z ->
  ((power (x * y)%Z n) = ((power x n) * (power y n))%Z).

Inductive ref (a:Type) :=
  | mk_ref : a -> ref a.
Implicit Arguments mk_ref.

Definition contents (a:Type)(u:(ref a)): a :=
  match u with
  | mk_ref contents1 => contents1
  end.
Implicit Arguments contents.

(* YOU MAY EDIT THE CONTEXT BELOW *)

(* DO NOT EDIT BELOW *)

Theorem WP_parameter_fast_exp_imperative : forall (x:Z), forall (n:Z),
  (0%Z <= n)%Z -> forall (e:Z), forall (p:Z), forall (r:Z), ((0%Z <= e)%Z /\
  ((r * (power p e))%Z = (power x n))) -> ((0%Z <  e)%Z ->
  ((~ ((ZOmod e 2%Z) = 1%Z)) -> forall (p1:Z), (p1 = (p * p)%Z) ->
  forall (e1:Z), (e1 = (ZOdiv e 2%Z)) -> ((r * (power p1 e1))%Z = (power x
  n)))).
(* YOU MAY EDIT THE PROOF BELOW *)
intros x n Hn e0 p0 r0 (He0,Hind).
intros He0' Hmod p1 Hp e1 He.
rewrite <- Hind.
apply f_equal.
subst.
assert (h: (e0 = e0/2 + e0/2)%Z).
assert (e0 mod 2 = 0).
generalize (ZOmod_lt_pos e0 2).
unfold Zabs; omega.
rewrite (ZO_div_mod_eq e0 2) at 1; omega.
rewrite Power_mult2; auto with zarith.
rewrite h at 3.
rewrite Power_sum; omega.
Qed.
(* DO NOT EDIT BELOW *)

