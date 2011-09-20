(* This file is generated by Why3's Coq driver *)
(* Beware! Only edit allowed sections below    *)
Require Import ZArith.
Require Import Rbase.
Require Import ZOdiv.
Axiom Abs_le : forall (x:Z) (y:Z), ((Zabs x) <= y)%Z <-> (((-y)%Z <= x)%Z /\
  (x <= y)%Z).

Definition left(i:Z): Z := ((2%Z * i)%Z + 1%Z)%Z.

Definition right(i:Z): Z := ((2%Z * i)%Z + 2%Z)%Z.

Definition parent(i:Z): Z := (ZOdiv (i - 1%Z)%Z 2%Z).

Axiom Parent_inf : forall (i:Z), (0%Z <  i)%Z -> ((parent i) <  i)%Z.

Axiom Left_sup : forall (i:Z), (0%Z <= i)%Z -> (i <  (left i))%Z.

Axiom Right_sup : forall (i:Z), (0%Z <= i)%Z -> (i <  (right i))%Z.

Axiom Parent_right : forall (i:Z), (0%Z <= i)%Z -> ((parent (right i)) = i).

Axiom Parent_left : forall (i:Z), (0%Z <= i)%Z -> ((parent (left i)) = i).

Axiom Inf_parent : forall (i:Z) (j:Z), ((0%Z <  j)%Z /\
  (j <= (right i))%Z) -> ((parent j) <= i)%Z.

Axiom Child_parent : forall (i:Z), (0%Z <  i)%Z ->
  ((i = (left (parent i))) \/ (i = (right (parent i)))).

Axiom Parent_pos : forall (j:Z), (0%Z <  j)%Z -> (0%Z <= (parent j))%Z.

Definition parentChild(i:Z) (j:Z): Prop := ((0%Z <= i)%Z /\ (i <  j)%Z) ->
  ((j = (left i)) \/ (j = (right i))).

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

Parameter const: forall (b:Type) (a:Type), b -> (map a b).

Set Contextual Implicit.
Implicit Arguments const.
Unset Contextual Implicit.

Axiom Const : forall (b:Type) (a:Type), forall (b1:b) (a1:a), ((get (const(
  b1):(map a b)) a1) = b1).

Definition map1  := (map Z Z).

Definition logic_heap  := ((map Z Z)* Z)%type.

Definition is_heap_array(a:(map Z Z)) (idx:Z) (sz:Z): Prop :=
  (0%Z <= idx)%Z -> forall (i:Z) (j:Z), (((idx <= i)%Z /\ (i <  j)%Z) /\
  (j <  sz)%Z) -> ((parentChild i j) -> ((get a i) <= (get a j))%Z).

Definition is_heap(h:((map Z Z)* Z)%type): Prop :=
  match h with
  | (a, sz) => (0%Z <= sz)%Z /\ (is_heap_array a 0%Z sz)
  end.

Axiom Is_heap_when_no_element : forall (a:(map Z Z)) (idx:Z) (n:Z),
  ((0%Z <= n)%Z /\ (n <= idx)%Z) -> (is_heap_array a idx n).

Axiom Is_heap_sub : forall (a:(map Z Z)) (i:Z) (n:Z), (is_heap_array a i
  n) -> forall (j:Z), ((i <= j)%Z /\ (j <= n)%Z) -> (is_heap_array a i j).

Axiom Is_heap_sub2 : forall (a:(map Z Z)) (n:Z), (is_heap_array a 0%Z n) ->
  forall (j:Z), ((0%Z <= j)%Z /\ (j <= n)%Z) -> (is_heap_array a j n).

Axiom Is_heap_when_node_modified : forall (a:(map Z Z)) (n:Z) (e:Z) (idx:Z)
  (i:Z), ((0%Z <= i)%Z /\ (i <  n)%Z) -> ((is_heap_array a idx n) ->
  (((0%Z <  i)%Z -> ((get a (parent i)) <= e)%Z) -> ((((left i) <  n)%Z ->
  (e <= (get a (left i)))%Z) -> ((((right i) <  n)%Z -> (e <= (get a
  (right i)))%Z) -> (is_heap_array (set a i e) idx n))))).

Axiom Is_heap_add_last : forall (a:(map Z Z)) (n:Z) (e:Z), (0%Z <  n)%Z ->
  (((is_heap_array a 0%Z n) /\ ((get a (parent n)) <= e)%Z) ->
  (is_heap_array (set a n e) 0%Z (n + 1%Z)%Z)).

Axiom Parent_inf_el : forall (a:(map Z Z)) (n:Z), (is_heap_array a 0%Z n) ->
  forall (j:Z), ((0%Z <  j)%Z /\ (j <  n)%Z) -> ((get a (parent j)) <= (get a
  j))%Z.

Axiom Left_sup_el : forall (a:(map Z Z)) (n:Z), (is_heap_array a 0%Z n) ->
  forall (j:Z), ((0%Z <= j)%Z /\ (j <  n)%Z) -> (((left j) <  n)%Z -> ((get a
  j) <= (get a (left j)))%Z).

Axiom Right_sup_el : forall (a:(map Z Z)) (n:Z), (is_heap_array a 0%Z n) ->
  forall (j:Z), ((0%Z <= j)%Z /\ (j <  n)%Z) -> (((right j) <  n)%Z ->
  ((get a j) <= (get a (right j)))%Z).

(* YOU MAY EDIT THE CONTEXT BELOW *)

(* DO NOT EDIT BELOW *)

Theorem Is_heap_relation : forall (a:(map Z Z)) (n:Z), (0%Z <  n)%Z ->
  ((is_heap_array a 0%Z n) -> forall (j:Z), (0%Z <= j)%Z -> ((j <  n)%Z ->
  ((get a 0%Z) <= (get a j))%Z)).
(* YOU MAY EDIT THE PROOF BELOW *)
intros a n H H_heap.
intros j H1.
apply Zlt_lower_bound_ind with (z:=0) 
 (P:= fun j => j < n -> get a 0 <= get a j); 
  auto with zarith.
intros x Hind H_x_pos H_x_lt_n.
assert (h: x=0 \/ 0 < x) by omega.
  destruct h.
  (*case x = 0*)
  subst; auto with zarith.
  (*case x > 0*)
  apply Zle_trans with (get a (parent x)).
  apply Hind.
  split.
  apply Parent_pos; auto with zarith.
  apply Parent_inf; auto with zarith.
  apply Zlt_trans with x; auto.
  apply Parent_inf; auto with zarith.
  apply Parent_inf_el with (n := n); 
    auto with zarith.
Qed.
(* DO NOT EDIT BELOW *)


