(* This file is generated by Why3's Coq driver *)
(* Beware! Only edit allowed sections below    *)
Require Import ZArith.
Require Import Rbase.
Definition unit  := unit.

Parameter mark : Type.

Parameter at1: forall (a:Type), a -> mark  -> a.

Implicit Arguments at1.

Parameter old: forall (a:Type), a  -> a.

Implicit Arguments old.

Parameter t : Type.

Parameter f: t  -> t.


Parameter x0:  t.


Parameter iter: Z -> t  -> t.


Axiom iter_0 : forall (x:t), ((iter 0%Z x) = x).

Axiom iter_s : forall (k:Z) (x:t), (0%Z <  k)%Z -> ((iter k
  x) = (iter (k - 1%Z)%Z (f x))).

Axiom iter_1 : forall (x:t), ((iter 1%Z x) = (f x)).

Axiom iter_s2 : forall (k:Z) (x:t), (0%Z <  k)%Z -> ((iter k
  x) = (f (iter (k - 1%Z)%Z x))).

Parameter mu:  Z.


Parameter lambda:  Z.


Axiom mu_range : (0%Z <= (mu ))%Z.

Axiom lambda_range : (1%Z <= (lambda ))%Z.

Axiom distinct : forall (i:Z) (j:Z), ((0%Z <= i)%Z /\
  (i <  ((mu ) + (lambda ))%Z)%Z) -> (((0%Z <= j)%Z /\
  (j <  ((mu ) + (lambda ))%Z)%Z) -> ((~ (i = j)) -> ~ ((iter i
  (x0 )) = (iter j (x0 ))))).

Axiom cycle : forall (n:Z), ((mu ) <= n)%Z -> ((iter (n + (lambda ))%Z
  (x0 )) = (iter n (x0 ))).

Inductive ref (a:Type) :=
  | mk_ref : a -> ref a.
Implicit Arguments mk_ref.

Definition contents (a:Type)(u:(ref a)): a :=
  match u with
  | mk_ref contents1 => contents1
  end.
Implicit Arguments contents.

Definition rel(t2:t) (t1:t): Prop := exists i:Z, (t1 = (iter i (x0 ))) /\
  ((t2 = (iter (i + 1%Z)%Z (x0 ))) /\ ((1%Z <= i)%Z /\
  (i <= ((lambda ) + (mu ))%Z)%Z)).

Theorem WP_parameter_tortoise_hare : forall (hare:t), forall (tortoise:t),
  (exists t1:Z, ((1%Z <= t1)%Z /\ (t1 <= ((lambda ) + (mu ))%Z)%Z) /\
  ((tortoise = (iter t1 (x0 ))) /\ ((hare = (iter (2%Z * t1)%Z (x0 ))) /\
  forall (i:Z), ((1%Z <= i)%Z /\ (i <  t1)%Z) -> ~ ((iter i
  (x0 )) = (iter (2%Z * i)%Z (x0 )))))) -> ((~ (tortoise = hare)) ->
  forall (tortoise1:t), (tortoise1 = (f tortoise)) -> forall (hare1:t),
  (hare1 = (f (f hare))) -> exists t1:Z, ((1%Z <= t1)%Z /\
  (t1 <= ((lambda ) + (mu ))%Z)%Z) /\ ((tortoise1 = (iter t1 (x0 ))) /\
  ((hare1 = (iter (2%Z * t1)%Z (x0 ))) /\ forall (i:Z), ((1%Z <= i)%Z /\
  (i <  t1)%Z) -> ~ ((iter i (x0 )) = (iter (2%Z * i)%Z (x0 )))))).
(* YOU MAY EDIT THE PROOF BELOW *)
intros hare tortoise (t0, (ht, (eqt, (eqh, h)))).
intros; subst.
assert (dis: forall i : Z, (1 <= i <= t0)%Z -> iter i x0 <> iter (2 * i) x0).
intros i hi.
assert (case: (i < t0 \/ i = t0)%Z) by omega. destruct case.
apply (h i); omega.
subst; auto.

clear h H.
exists (t0 + 1)%Z; intuition.
assert (case: (t0+1 <= lambda + mu \/ t0+1> lambda+mu)%Z) by omega.
  destruct case.
assumption.
assert (t0 = lambda+mu)%Z by omega. subst.
clear H0 H1.
pose (i := (lambda+mu-(lambda+mu) mod lambda)%Z).
generalize lambda_range mu_range. intros hlam hmu.
assert (lambda_pos: (lambda > 0)%Z) by omega.
generalize (Z_mod_lt (lambda+mu) lambda lambda_pos)%Z. intro hr.
generalize (Z_div_mod_eq (lambda+mu) lambda lambda_pos)%Z. intro hq.
absurd (iter i x0 = iter (2*i) x0).
red; intro; apply (dis i); auto.
subst i; omega.
assert (hi: (mu <= i)%Z) by (subst i; omega).
assert (ind: (forall k: Z, 0 <= k -> iter (i + lambda*k) x0 = iter i x0)%Z).
apply natlike_ind.
ring_simplify (i + lambda * 0)%Z; auto.
intros.
unfold Zsucc.
replace (i + lambda * (x + 1))%Z with ((i+lambda*x)+lambda)%Z by ring.
rewrite cycle; auto.
assert (0 <= lambda * x)%Z.
apply Zmult_le_0_compat; omega.
omega.
replace (2*i)%Z with (i + lambda * ((lambda + mu) / lambda))%Z.
symmetry. apply ind.
apply Z_div_pos; omega.
subst i; omega.

rewrite (iter_s2 (t0+1)%Z); intuition.
ring_simplify (t0+1-1)%Z; auto.
rewrite (iter_s2 (2*(t0+1))%Z); intuition.
ring_simplify (2 * (t0 + 1) - 1) %Z.
rewrite (iter_s2 (2*t0+1)%Z); intuition.
ring_simplify (2 * t0 + 1 - 1) %Z; auto.
apply (dis i); auto.
omega.
Qed.
(* DO NOT EDIT BELOW *)


