(* This file is generated by Why3's Coq 8.4 driver *)
(* Beware! Only edit allowed sections below    *)
Require Import BuiltIn.
Require BuiltIn.
Require int.Int.
Require map.Map.

(* Why3 assumption *)
Definition unit := unit.

(* Why3 assumption *)
Inductive ref (a:Type) {a_WT:WhyType a} :=
  | mk_ref : a -> ref a.
Axiom ref_WhyType : forall (a:Type) {a_WT:WhyType a}, WhyType (ref a).
Existing Instance ref_WhyType.
Implicit Arguments mk_ref [[a] [a_WT]].

(* Why3 assumption *)
Definition contents {a:Type} {a_WT:WhyType a} (v:(@ref a a_WT)): a :=
  match v with
  | (mk_ref x) => x
  end.

(* Why3 assumption *)
Inductive array
  (a:Type) {a_WT:WhyType a} :=
  | mk_array : Z -> (@map.Map.map Z _ a a_WT) -> array a.
Axiom array_WhyType : forall (a:Type) {a_WT:WhyType a}, WhyType (array a).
Existing Instance array_WhyType.
Implicit Arguments mk_array [[a] [a_WT]].

(* Why3 assumption *)
Definition elts {a:Type} {a_WT:WhyType a} (v:(@array a a_WT)): (@map.Map.map
  Z _ a a_WT) := match v with
  | (mk_array x x1) => x1
  end.

(* Why3 assumption *)
Definition length {a:Type} {a_WT:WhyType a} (v:(@array a a_WT)): Z :=
  match v with
  | (mk_array x x1) => x
  end.

(* Why3 assumption *)
Definition get {a:Type} {a_WT:WhyType a} (a1:(@array a a_WT)) (i:Z): a :=
  (map.Map.get (elts a1) i).

(* Why3 assumption *)
Definition set {a:Type} {a_WT:WhyType a} (a1:(@array a a_WT)) (i:Z)
  (v:a): (@array a a_WT) := (mk_array (length a1) (map.Map.set (elts a1) i
  v)).

(* Why3 assumption *)
Definition make {a:Type} {a_WT:WhyType a} (n:Z) (v:a): (@array a a_WT) :=
  (mk_array n (map.Map.const v:(@map.Map.map Z _ a a_WT))).

Axiom char : Type.
Parameter char_WhyType : WhyType char.
Existing Instance char_WhyType.

(* Why3 assumption *)
Definition matches (a1:(@array char char_WhyType)) (i1:Z) (a2:(@array
  char char_WhyType)) (i2:Z) (n:Z): Prop := ((0%Z <= i1)%Z /\
  (i1 <= ((length a1) - n)%Z)%Z) /\ (((0%Z <= i2)%Z /\
  (i2 <= ((length a2) - n)%Z)%Z) /\ forall (i:Z), ((0%Z <= i)%Z /\
  (i < n)%Z) -> ((get a1 (i1 + i)%Z) = (get a2 (i2 + i)%Z))).

Axiom matches_empty : forall (a1:(@array char char_WhyType)) (a2:(@array
  char char_WhyType)) (i1:Z) (i2:Z), ((0%Z <= i1)%Z /\
  (i1 <= (length a1))%Z) -> (((0%Z <= i2)%Z /\ (i2 <= (length a2))%Z) ->
  (matches a1 i1 a2 i2 0%Z)).

Axiom matches_right_extension : forall (a1:(@array char char_WhyType))
  (a2:(@array char char_WhyType)) (i1:Z) (i2:Z) (n:Z), (matches a1 i1 a2 i2
  n) -> ((i1 <= (((length a1) - n)%Z - 1%Z)%Z)%Z ->
  ((i2 <= (((length a2) - n)%Z - 1%Z)%Z)%Z -> (((get a1 (i1 + n)%Z) = (get a2
  (i2 + n)%Z)) -> (matches a1 i1 a2 i2 (n + 1%Z)%Z)))).

Axiom matches_contradiction_at_first : forall (a1:(@array char char_WhyType))
  (a2:(@array char char_WhyType)) (i1:Z) (i2:Z) (n:Z), (0%Z < n)%Z ->
  ((~ ((get a1 i1) = (get a2 i2))) -> ~ (matches a1 i1 a2 i2 n)).

Axiom matches_contradiction_at_i : forall (a1:(@array char char_WhyType))
  (a2:(@array char char_WhyType)) (i1:Z) (i2:Z) (i:Z) (n:Z), (0%Z < n)%Z ->
  (((0%Z <= i)%Z /\ (i < n)%Z) -> ((~ ((get a1 (i1 + i)%Z) = (get a2
  (i2 + i)%Z))) -> ~ (matches a1 i1 a2 i2 n))).

Axiom matches_right_weakening : forall (a1:(@array char char_WhyType))
  (a2:(@array char char_WhyType)) (i1:Z) (i2:Z) (n:Z) (n':Z), (matches a1 i1
  a2 i2 n) -> ((n' < n)%Z -> (matches a1 i1 a2 i2 n')).

Axiom matches_left_weakening : forall (a1:(@array char char_WhyType))
  (a2:(@array char char_WhyType)) (i1:Z) (i2:Z) (n:Z) (n':Z), (matches a1
  (i1 - (n - n')%Z)%Z a2 (i2 - (n - n')%Z)%Z n) -> ((n' < n)%Z -> (matches a1
  i1 a2 i2 n')).

Axiom matches_sym : forall (a1:(@array char char_WhyType)) (a2:(@array
  char char_WhyType)) (i1:Z) (i2:Z) (n:Z), (matches a1 i1 a2 i2 n) ->
  (matches a2 i2 a1 i1 n).

Axiom matches_trans : forall (a1:(@array char char_WhyType)) (a2:(@array
  char char_WhyType)) (a3:(@array char char_WhyType)) (i1:Z) (i2:Z) (i3:Z)
  (n:Z), (matches a1 i1 a2 i2 n) -> ((matches a2 i2 a3 i3 n) -> (matches a1
  i1 a3 i3 n)).

(* Why3 assumption *)
Definition is_next (p:(@array char char_WhyType)) (j:Z) (n:Z): Prop :=
  ((0%Z <= n)%Z /\ (n < j)%Z) /\ ((matches p (j - n)%Z p 0%Z n) /\
  forall (z:Z), ((n < z)%Z /\ (z < j)%Z) -> ~ (matches p (j - z)%Z p 0%Z z)).

Axiom next_iteration : forall (p:(@array char char_WhyType)) (a:(@array
  char char_WhyType)) (i:Z) (j:Z) (n:Z), ((0%Z < j)%Z /\
  (j < (length p))%Z) -> (((j <= i)%Z /\ (i <= (length a))%Z) -> ((matches a
  (i - j)%Z p 0%Z j) -> ((is_next p j n) -> (matches a (i - n)%Z p 0%Z n)))).

Axiom next_is_maximal : forall (p:(@array char char_WhyType)) (a:(@array
  char char_WhyType)) (i:Z) (j:Z) (n:Z) (k:Z), ((0%Z < j)%Z /\
  (j < (length p))%Z) -> (((j <= i)%Z /\ (i <= (length a))%Z) ->
  ((((i - j)%Z < k)%Z /\ (k < (i - n)%Z)%Z) -> ((matches a (i - j)%Z p 0%Z
  j) -> ((is_next p j n) -> ~ (matches a k p 0%Z (length p)))))).

Axiom next_1_0 : forall (p:(@array char char_WhyType)),
  (1%Z <= (length p))%Z -> (is_next p 1%Z 0%Z).

(* Why3 goal *)
Theorem WP_parameter_initnext : forall (p:Z) (p1:(@map.Map.map Z _
  char char_WhyType)), let p2 := (mk_array p p1) in (((0%Z <= p)%Z /\
  (1%Z <= p)%Z) -> ((0%Z <= p)%Z -> ((0%Z <= p)%Z -> ((1%Z < p)%Z ->
  (((0%Z <= 1%Z)%Z /\ (1%Z < p)%Z) -> forall (next:(@map.Map.map Z _ Z _)),
  ((0%Z <= p)%Z /\ (next = (map.Map.set (map.Map.const 0%Z:(@map.Map.map Z _
  Z _)) 1%Z 0%Z))) -> forall (j:Z) (i:Z) (next1:(@map.Map.map Z _ Z _)),
  (((0%Z <= j)%Z /\ ((j < i)%Z /\ (i <= p)%Z)) /\ ((matches p2 (i - j)%Z p2
  0%Z j) /\ ((forall (z:Z), (((j + 1%Z)%Z < z)%Z /\ (z < (i + 1%Z)%Z)%Z) ->
  ~ (matches p2 ((i + 1%Z)%Z - z)%Z p2 0%Z z)) /\ forall (k:Z),
  ((0%Z < k)%Z /\ (k <= i)%Z) -> (is_next p2 k (map.Map.get next1 k))))) ->
  ((i < (p - 1%Z)%Z)%Z -> (((0%Z <= j)%Z /\ (j < p)%Z) -> (((0%Z <= i)%Z /\
  (i < p)%Z) -> ((~ ((map.Map.get p1 i) = (map.Map.get p1 j))) ->
  ((j = 0%Z) -> forall (i1:Z), (i1 = (i + 1%Z)%Z) -> (((0%Z <= p)%Z /\
  ((0%Z <= i1)%Z /\ (i1 < p)%Z)) -> forall (next2:(@map.Map.map Z _ Z _)),
  ((0%Z <= p)%Z /\ (next2 = (map.Map.set next1 i1 0%Z))) -> forall (z:Z),
  (((j + 1%Z)%Z < z)%Z /\ (z < (i1 + 1%Z)%Z)%Z) -> ~ (matches p2
  ((i1 + 1%Z)%Z - z)%Z p2 0%Z z)))))))))))).
(* Why3 intros p p1 p2 (h1,h2) h3 h4 h5 (h6,h7) next (h8,h9) j i next1
        ((h10,(h11,h12)),(h13,(h14,h15))) h16 (h17,h18) (h19,h20) h21 h22 i1
        h23 (h24,(h25,h26)) next2 (h27,h28) z (h29,h30). *)
(* YOU MAY EDIT THE PROOF BELOW *)
intros n p1.
intro p3. unfold p3. clear p3.
intros _ _ _ hn _ _ _.
intros j i next4 ((hj,hi),(h0,(h1,h2))).
intros hi' _ _ neq j0. subst j.
intros i1 hi1; subst i1.
intros _ _ _ z hz.
red; intro h. unfold matches, length, get in h. simpl in h.
destruct h as (hy1, (hy2, hy3)).

assert (case: (z = 2 \/ 2 < z)%Z) by omega. destruct case.
subst z.
absurd (Map.get p1 i = Map.get p1 0%Z); auto.
generalize (hy3 0%Z).
ring_simplify (i + 1 + 1 - 2 + 0)%Z.
intuition.

apply h1 with (z-1)%Z.
omega.
red; unfold length, get; simpl.
repeat split; try omega.
intros.
replace (i + 1 - (z - 1) + i0)%Z with (i + 1 + 1 - z + i0)%Z by omega.
apply hy3.
omega.
Qed.

