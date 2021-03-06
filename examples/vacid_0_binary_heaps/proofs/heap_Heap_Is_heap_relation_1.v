(* This file is generated by Why3's Coq 8.4 driver *)
(* Beware! Only edit allowed sections below    *)
Require Import BuiltIn.
Require Import ZOdiv.
Require BuiltIn.
Require int.Int.
Require int.Abs.
Require int.ComputerDivision.
Require map.Map.

(* Why3 assumption *)
Definition left1 (i:Z): Z := ((2%Z * i)%Z + 1%Z)%Z.

(* Why3 assumption *)
Definition right1 (i:Z): Z := ((2%Z * i)%Z + 2%Z)%Z.

(* Why3 assumption *)
Definition parent (i:Z): Z := (ZOdiv (i - 1%Z)%Z 2%Z).

Axiom Parent_inf : forall (i:Z), (0%Z < i)%Z -> ((parent i) < i)%Z.

Axiom Left_sup : forall (i:Z), (0%Z <= i)%Z -> (i < (left1 i))%Z.

Axiom Right_sup : forall (i:Z), (0%Z <= i)%Z -> (i < (right1 i))%Z.

Axiom Parent_right : forall (i:Z), (0%Z <= i)%Z -> ((parent (right1 i)) = i).

Axiom Parent_left : forall (i:Z), (0%Z <= i)%Z -> ((parent (left1 i)) = i).

Axiom Inf_parent : forall (i:Z) (j:Z), ((0%Z < j)%Z /\
  (j <= (right1 i))%Z) -> ((parent j) <= i)%Z.

Axiom Child_parent : forall (i:Z), (0%Z < i)%Z ->
  ((i = (left1 (parent i))) \/ (i = (right1 (parent i)))).

Axiom Parent_pos : forall (j:Z), (0%Z < j)%Z -> (0%Z <= (parent j))%Z.

(* Why3 assumption *)
Definition parentChild (i:Z) (j:Z): Prop := ((0%Z <= i)%Z /\ (i < j)%Z) ->
  ((j = (left1 i)) \/ (j = (right1 i))).

(* Why3 assumption *)
Definition map := (@map.Map.map Z _ Z _).

(* Why3 assumption *)
Definition logic_heap := ((@map.Map.map Z _ Z _)* Z)%type.

(* Why3 assumption *)
Definition is_heap_array (a:(@map.Map.map Z _ Z _)) (idx:Z) (sz:Z): Prop :=
  (0%Z <= idx)%Z -> forall (i:Z) (j:Z), (((idx <= i)%Z /\ (i < j)%Z) /\
  (j < sz)%Z) -> ((parentChild i j) -> ((map.Map.get a i) <= (map.Map.get a
  j))%Z).

(* Why3 assumption *)
Definition is_heap (h:((@map.Map.map Z _ Z _)* Z)%type): Prop :=
  match h with
  | (a, sz) => (0%Z <= sz)%Z /\ (is_heap_array a 0%Z sz)
  end.

Axiom Is_heap_when_no_element : forall (a:(@map.Map.map Z _ Z _)) (idx:Z)
  (n:Z), ((0%Z <= n)%Z /\ (n <= idx)%Z) -> (is_heap_array a idx n).

Axiom Is_heap_sub : forall (a:(@map.Map.map Z _ Z _)) (i:Z) (n:Z),
  (is_heap_array a i n) -> forall (j:Z), ((i <= j)%Z /\ (j <= n)%Z) ->
  (is_heap_array a i j).

Axiom Is_heap_sub2 : forall (a:(@map.Map.map Z _ Z _)) (n:Z), (is_heap_array
  a 0%Z n) -> forall (j:Z), ((0%Z <= j)%Z /\ (j <= n)%Z) -> (is_heap_array a
  j n).

Axiom Is_heap_when_node_modified : forall (a:(@map.Map.map Z _ Z _)) (n:Z)
  (e:Z) (idx:Z) (i:Z), ((0%Z <= i)%Z /\ (i < n)%Z) -> ((is_heap_array a idx
  n) -> (((0%Z < i)%Z -> ((map.Map.get a (parent i)) <= e)%Z) ->
  ((((left1 i) < n)%Z -> (e <= (map.Map.get a (left1 i)))%Z) ->
  ((((right1 i) < n)%Z -> (e <= (map.Map.get a (right1 i)))%Z) ->
  (is_heap_array (map.Map.set a i e) idx n))))).

Axiom Is_heap_add_last : forall (a:(@map.Map.map Z _ Z _)) (n:Z) (e:Z),
  (0%Z < n)%Z -> (((is_heap_array a 0%Z n) /\ ((map.Map.get a
  (parent n)) <= e)%Z) -> (is_heap_array (map.Map.set a n e) 0%Z
  (n + 1%Z)%Z)).

Axiom Parent_inf_el : forall (a:(@map.Map.map Z _ Z _)) (n:Z), (is_heap_array
  a 0%Z n) -> forall (j:Z), ((0%Z < j)%Z /\ (j < n)%Z) -> ((map.Map.get a
  (parent j)) <= (map.Map.get a j))%Z.

Axiom Left_sup_el : forall (a:(@map.Map.map Z _ Z _)) (n:Z), (is_heap_array a
  0%Z n) -> forall (j:Z), ((0%Z <= j)%Z /\ (j < n)%Z) ->
  (((left1 j) < n)%Z -> ((map.Map.get a j) <= (map.Map.get a (left1 j)))%Z).

Axiom Right_sup_el : forall (a:(@map.Map.map Z _ Z _)) (n:Z), (is_heap_array
  a 0%Z n) -> forall (j:Z), ((0%Z <= j)%Z /\ (j < n)%Z) ->
  (((right1 j) < n)%Z -> ((map.Map.get a j) <= (map.Map.get a
  (right1 j)))%Z).


(* Why3 goal *)
Theorem Is_heap_relation : forall (a:(@map.Map.map Z _ Z _)) (n:Z),
  (0%Z < n)%Z -> ((is_heap_array a 0%Z n) -> forall (j:Z), (0%Z <= j)%Z ->
  ((j < n)%Z -> ((map.Map.get a 0%Z) <= (map.Map.get a j))%Z)).
(* Why3 intros a n h1 h2 j h3 h4. *)
Proof.
intros a n H H_heap.
intros j H1.
apply Zlt_lower_bound_ind with (z:=Z0) 
 (P:= fun j => (j < n -> Map.get a 0 <= Map.get a j)%Z); 
  auto with zarith.
intros x Hind H_x_pos H_x_lt_n.
assert (h: (x = 0 \/ 0 < x)%Z) by omega.
  destruct h.
  (*case x = 0*)
  subst; auto with zarith.
  (*case x > 0*)
  apply Zle_trans with (Map.get a (parent x)).
  apply Hind.
  split.
  apply Parent_pos; auto with zarith.
  apply Parent_inf; auto with zarith.
  apply Zlt_trans with x; auto.
  apply Parent_inf; auto with zarith.
  apply Parent_inf_el with (n := n); 
    auto with zarith.
Qed.


