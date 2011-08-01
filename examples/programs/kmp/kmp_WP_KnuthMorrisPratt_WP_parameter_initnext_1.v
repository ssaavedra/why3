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

Inductive ref (a:Type) :=
  | mk_ref : a -> ref a.
Implicit Arguments mk_ref.

Definition contents (a:Type)(u:(ref a)): a :=
  match u with
  | mk_ref contents1 => contents1
  end.
Implicit Arguments contents.

Parameter map : forall (a:Type) (b:Type), Type.

Parameter get: forall (a:Type) (b:Type), (map a b) -> a  -> b.

Implicit Arguments get.

Parameter set: forall (a:Type) (b:Type), (map a b) -> a -> b  -> (map a b).

Implicit Arguments set.

Axiom Select_eq : forall (a:Type) (b:Type), forall (m:(map a b)),
  forall (a1:a) (a2:a), forall (b1:b), (a1 = a2) -> ((get (set m a1 b1)
  a2) = b1).

Axiom Select_neq : forall (a:Type) (b:Type), forall (m:(map a b)),
  forall (a1:a) (a2:a), forall (b1:b), (~ (a1 = a2)) -> ((get (set m a1 b1)
  a2) = (get m a2)).

Parameter const: forall (b:Type) (a:Type), b  -> (map a b).

Set Contextual Implicit.
Implicit Arguments const.
Unset Contextual Implicit.

Axiom Const : forall (b:Type) (a:Type), forall (b1:b) (a1:a), ((get (const(
  b1):(map a b)) a1) = b1).

Inductive array (a:Type) :=
  | mk_array : Z -> (map Z a) -> array a.
Implicit Arguments mk_array.

Definition elts (a:Type)(u:(array a)): (map Z a) :=
  match u with
  | mk_array _ elts1 => elts1
  end.
Implicit Arguments elts.

Definition length (a:Type)(u:(array a)): Z :=
  match u with
  | mk_array length1 _ => length1
  end.
Implicit Arguments length.

Definition get1 (a:Type)(a1:(array a)) (i:Z): a := (get (elts a1) i).
Implicit Arguments get1.

Definition set1 (a:Type)(a1:(array a)) (i:Z) (v:a): (array a) :=
  match a1 with
  | mk_array xcl0 _ => (mk_array xcl0 (set (elts a1) i v))
  end.
Implicit Arguments set1.

Parameter char : Type.

Definition matches(a1:(array char)) (i1:Z) (a2:(array char)) (i2:Z)
  (n:Z): Prop := ((0%Z <= i1)%Z /\ (i1 <= ((length a1) - n)%Z)%Z) /\
  (((0%Z <= i2)%Z /\ (i2 <= ((length a2) - n)%Z)%Z) /\ forall (i:Z),
  ((0%Z <= i)%Z /\ (i <  n)%Z) -> ((get1 a1 (i1 + i)%Z) = (get1 a2
  (i2 + i)%Z))).

Axiom matches_empty : forall (a1:(array char)) (a2:(array char)) (i1:Z)
  (i2:Z), ((0%Z <= i1)%Z /\ (i1 <= (length a1))%Z) -> (((0%Z <= i2)%Z /\
  (i2 <= (length a2))%Z) -> (matches a1 i1 a2 i2 0%Z)).

Axiom matches_right_extension : forall (a1:(array char)) (a2:(array char))
  (i1:Z) (i2:Z) (n:Z), (matches a1 i1 a2 i2 n) ->
  ((i1 <= (((length a1) - n)%Z - 1%Z)%Z)%Z ->
  ((i2 <= (((length a2) - n)%Z - 1%Z)%Z)%Z -> (((get1 a1
  (i1 + n)%Z) = (get1 a2 (i2 + n)%Z)) -> (matches a1 i1 a2 i2
  (n + 1%Z)%Z)))).

Axiom matches_contradiction_at_first : forall (a1:(array char)) (a2:(array
  char)) (i1:Z) (i2:Z) (n:Z), (0%Z <  n)%Z -> ((~ ((get1 a1 i1) = (get1 a2
  i2))) -> ~ (matches a1 i1 a2 i2 n)).

Axiom matches_contradiction_at_i : forall (a1:(array char)) (a2:(array char))
  (i1:Z) (i2:Z) (i:Z) (n:Z), (0%Z <  n)%Z -> (((0%Z <= i)%Z /\ (i <  n)%Z) ->
  ((~ ((get1 a1 (i1 + i)%Z) = (get1 a2 (i2 + i)%Z))) -> ~ (matches a1 i1 a2
  i2 n))).

Axiom matches_right_weakening : forall (a1:(array char)) (a2:(array char))
  (i1:Z) (i2:Z) (n:Z) (nqt:Z), (matches a1 i1 a2 i2 n) -> ((nqt <  n)%Z ->
  (matches a1 i1 a2 i2 nqt)).

Axiom matches_left_weakening : forall (a1:(array char)) (a2:(array char))
  (i1:Z) (i2:Z) (n:Z) (nqt:Z), (matches a1 (i1 - (n - nqt)%Z)%Z a2
  (i2 - (n - nqt)%Z)%Z n) -> ((nqt <  n)%Z -> (matches a1 i1 a2 i2 nqt)).

Axiom matches_sym : forall (a1:(array char)) (a2:(array char)) (i1:Z) (i2:Z)
  (n:Z), (matches a1 i1 a2 i2 n) -> (matches a2 i2 a1 i1 n).

Axiom matches_trans : forall (a1:(array char)) (a2:(array char)) (a3:(array
  char)) (i1:Z) (i2:Z) (i3:Z) (n:Z), (matches a1 i1 a2 i2 n) -> ((matches a2
  i2 a3 i3 n) -> (matches a1 i1 a3 i3 n)).

Definition is_next(p:(array char)) (j:Z) (n:Z): Prop := ((0%Z <= n)%Z /\
  (n <  j)%Z) /\ ((matches p (j - n)%Z p 0%Z n) /\ forall (z:Z),
  ((n <  z)%Z /\ (z <  j)%Z) -> ~ (matches p (j - z)%Z p 0%Z z)).

Axiom next_iteration : forall (p:(array char)) (a:(array char)) (i:Z) (j:Z)
  (n:Z), ((0%Z <  j)%Z /\ (j <  (length p))%Z) -> (((j <= i)%Z /\
  (i <= (length a))%Z) -> ((matches a (i - j)%Z p 0%Z j) -> ((is_next p j
  n) -> (matches a (i - n)%Z p 0%Z n)))).

Axiom next_is_maximal : forall (p:(array char)) (a:(array char)) (i:Z) (j:Z)
  (n:Z) (k:Z), ((0%Z <  j)%Z /\ (j <  (length p))%Z) -> (((j <= i)%Z /\
  (i <= (length a))%Z) -> ((((i - j)%Z <  k)%Z /\ (k <  (i - n)%Z)%Z) ->
  ((matches a (i - j)%Z p 0%Z j) -> ((is_next p j n) -> ~ (matches a k p 0%Z
  (length p)))))).

Axiom next_1_0 : forall (p:(array char)), (1%Z <= (length p))%Z -> (is_next p
  1%Z 0%Z).

Definition lt_nat(x:Z) (y:Z): Prop := (0%Z <= y)%Z /\ (x <  y)%Z.

Inductive lex : (Z* Z)%type -> (Z* Z)%type -> Prop :=
  | Lex_1 : forall (x1:Z) (x2:Z) (y1:Z) (y2:Z), (lt_nat x1 x2) -> (lex (x1,
      y1) (x2, y2))
  | Lex_2 : forall (x:Z) (y1:Z) (y2:Z), (lt_nat y1 y2) -> (lex (x, y1) (x,
      y2)).

Parameter p:  (array char).


Parameter next:  (array Z).


Theorem WP_parameter_initnext : forall (next1:Z), forall (p1:Z),
  forall (next2:(map Z Z)), forall (p2:(map Z char)), let p3 := (mk_array p1
  p2) in (((1%Z <= next1)%Z /\ (next1 = p1)) -> ((1%Z <  p1)%Z ->
  (((0%Z <= 1%Z)%Z /\ (1%Z <  next1)%Z) -> forall (next3:(map Z Z)),
  (next3 = (set next2 1%Z 0%Z)) -> forall (j:Z), forall (i:Z),
  forall (next4:(map Z Z)), (((0%Z <= j)%Z /\ (j <= p1)%Z) /\ (((j <  i)%Z /\
  (i <= p1)%Z) /\ ((matches p3 (i - j)%Z p3 0%Z j) /\ ((forall (z:Z),
  (((j + 1%Z)%Z <  z)%Z /\ (z <  (i + 1%Z)%Z)%Z) -> ~ (matches p3
  ((i + 1%Z)%Z - z)%Z p3 0%Z z)) /\ forall (k:Z), ((0%Z <  k)%Z /\
  (k <= i)%Z) -> (is_next p3 k (get next4 k)))))) ->
  ((i <  (p1 - 1%Z)%Z)%Z -> (((0%Z <= i)%Z /\ (i <  p1)%Z) ->
  (((0%Z <= j)%Z /\ (j <  p1)%Z) -> (((get p2 i) = (get p2 j)) ->
  forall (i1:Z), (i1 = (i + 1%Z)%Z) -> forall (j1:Z), (j1 = (j + 1%Z)%Z) ->
  (((0%Z <= i1)%Z /\ (i1 <  next1)%Z) -> forall (next5:(map Z Z)),
  (next5 = (set next4 i1 j1)) -> forall (z:Z), (((j1 + 1%Z)%Z <  z)%Z /\
  (z <  (i1 + 1%Z)%Z)%Z) -> ~ (matches p3 ((i1 + 1%Z)%Z - z)%Z p3 0%Z
  z))))))))).
(* YOU MAY EDIT THE PROOF BELOW *)
intros n n1 next1 p1.
intro p3. unfold p3. clear p3.
intros (_, eqn). subst n1. intros hn _ _ _.
intros j i next4 (hj, (hi, (h1, (h2, h3)))).
intros hi' _ _ eq.
intros i1 hi1; subst i1.
intros j1 hji1; subst j1.
intros _ _ _ z hz.
red; intro h. unfold matches, length , get1 in h. simpl in h.
destruct h as (hy1, (hy2, hy3)).

Qed.
(* DO NOT EDIT BELOW *)


