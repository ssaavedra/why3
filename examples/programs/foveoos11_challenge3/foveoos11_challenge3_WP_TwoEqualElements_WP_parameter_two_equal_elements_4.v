(* This file is generated by Why3's Coq driver *)
(* Beware! Only edit allowed sections below    *)
Require Import ZArith.
Require Import Rbase.
Require int.Int.

(* Why3 assumption *)
Definition unit  := unit.

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

Parameter set: forall (a:Type) (b:Type), (map a b) -> a -> b -> (map a b).
Implicit Arguments set.

Axiom Select_eq : forall (a:Type) (b:Type), forall (m:(map a b)),
  forall (a1:a) (a2:a), forall (b1:b), (a1 = a2) -> ((get (set m a1 b1)
  a2) = b1).

Axiom Select_neq : forall (a:Type) (b:Type), forall (m:(map a b)),
  forall (a1:a) (a2:a), forall (b1:b), (~ (a1 = a2)) -> ((get (set m a1 b1)
  a2) = (get m a2)).

Parameter const: forall (a:Type) (b:Type), b -> (map a b).
Set Contextual Implicit.
Implicit Arguments const.
Unset Contextual Implicit.

Axiom Const : forall (a:Type) (b:Type), forall (b1:b) (a1:a),
  ((get (const b1:(map a b)) a1) = b1).

(* Why3 assumption *)
Inductive array (a:Type) :=
  | mk_array : Z -> (map Z a) -> array a.
Implicit Arguments mk_array.

(* Why3 assumption *)
Definition elts (a:Type)(v:(array a)): (map Z a) :=
  match v with
  | (mk_array x x1) => x1
  end.
Implicit Arguments elts.

(* Why3 assumption *)
Definition length (a:Type)(v:(array a)): Z :=
  match v with
  | (mk_array x x1) => x
  end.
Implicit Arguments length.

(* Why3 assumption *)
Definition get1 (a:Type)(a1:(array a)) (i:Z): a := (get (elts a1) i).
Implicit Arguments get1.

(* Why3 assumption *)
Definition set1 (a:Type)(a1:(array a)) (i:Z) (v:a): (array a) :=
  (mk_array (length a1) (set (elts a1) i v)).
Implicit Arguments set1.

(* Why3 assumption *)
Definition appear_twice(a:(array Z)) (v:Z) (u:Z): Prop := exists i:Z,
  ((0%Z <= i)%Z /\ (i < u)%Z) /\ (((get1 a i) = v) /\ exists j:Z,
  ((0%Z <= j)%Z /\ (j < u)%Z) /\ ((~ (j = i)) /\ ((get1 a j) = v))).


(* Why3 goal *)
Theorem WP_parameter_two_equal_elements : forall (a:Z) (n:Z), forall (a1:(map
  Z Z)), let a2 := (mk_array a a1) in (((a = (n + 2%Z)%Z) /\ ((2%Z <= n)%Z /\
  ((forall (i:Z), ((0%Z <= i)%Z /\ (i < a)%Z) -> ((0%Z <= (get a1 i))%Z /\
  ((get a1 i) < n)%Z)) /\ exists v1:Z, (appear_twice a2 v1 (n + 2%Z)%Z) /\
  exists v2:Z, (appear_twice a2 v2 (n + 2%Z)%Z) /\ ~ (v2 = v1)))) ->
  ((0%Z <= n)%Z -> ((0%Z <= (n + 1%Z)%Z)%Z -> forall (v2:Z) (v1:Z)
  (deja_vu:(map Z bool)), forall (i:Z), ((0%Z <= i)%Z /\
  (i <= (n + 1%Z)%Z)%Z) -> ((((v1 = (-1%Z)%Z) -> (v2 = (-1%Z)%Z)) /\
  (((~ (v1 = (-1%Z)%Z)) -> (appear_twice a2 v1 i)) /\
  (((~ (v2 = (-1%Z)%Z)) -> ((appear_twice a2 v2 i) /\ ~ (v2 = v1))) /\
  ((forall (v:Z), ((0%Z <= v)%Z /\ (v < n)%Z) -> ((((get deja_vu
  v) = true) /\ exists j:Z, ((0%Z <= j)%Z /\ (j < i)%Z) /\ ((get a1
  j) = v)) \/ ((~ ((get deja_vu v) = true)) /\ forall (j:Z), ((0%Z <= j)%Z /\
  (j < i)%Z) -> ~ ((get a1 j) = v)))) /\ (((v1 = (-1%Z)%Z) -> forall (v:Z),
  ((0%Z <= v)%Z /\ (v < n)%Z) -> ~ (appear_twice a2 v i)) /\
  ((v2 = (-1%Z)%Z) -> forall (v:Z), ((0%Z <= v)%Z /\ (v < n)%Z) ->
  ((~ (v = v1)) -> ~ (appear_twice a2 v i)))))))) -> (((0%Z <= i)%Z /\
  (i < a)%Z) -> let v := (get a1 i) in (((0%Z <= v)%Z /\ (v < n)%Z) ->
  ((~ ((get deja_vu v) = true)) -> (((0%Z <= v)%Z /\ (v < n)%Z) ->
  forall (deja_vu1:(map Z bool)), (deja_vu1 = (set deja_vu v true)) ->
  ((v2 = (-1%Z)%Z) -> forall (v3:Z), ((0%Z <= v3)%Z /\ (v3 < n)%Z) ->
  ((~ (v3 = v1)) -> ~ (appear_twice a2 v3 (i + 1%Z)%Z))))))))))).
(* YOU MAY EDIT THE PROOF BELOW *)
intuition.
intuition.
destruct (H17 (get a1 i)); intuition.
red in H24.
destruct H24 as (i0, (h0, (h1, (j, (h2, (h3, h4)))))).
assert (v3 <> get a1 i).
assert (case: (i0 < i \/ j < i)%Z) by omega. destruct case.
red; intro; apply (H28 i0). omega. unfold get1 in h1; simpl in h1. omega.
red; intro; apply (H28 j). omega. unfold get1 in h4; simpl in h4. omega.
apply (H22 v3); auto.
red; exists i0; intuition.
assert (case: (i0 < i \/ i0 = i)%Z) by omega. destruct case.
auto.
subst i0.
unfold get1 in h1; simpl in h1.
omega.
exists j; intuition.
assert (case: (j < i \/ j = i)%Z) by omega. destruct case.
auto.
subst j.
unfold get1 in h4; simpl in h4.
omega.
Qed.


