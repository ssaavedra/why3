(* This file is generated by Why3's Coq driver *)
(* Beware! Only edit allowed sections below    *)
Require Import ZArith.
Require Import Rbase.
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

Definition bag (a:Type) := (map a Z).

Axiom occ_non_negative : forall (a:Type), forall (b:(map a Z)) (x:a),
  (0%Z <= (get b x))%Z.

Definition eq_bag (a:Type)(a1:(map a Z)) (b:(map a Z)): Prop := forall (x:a),
  ((get a1 x) = (get b x)).
Implicit Arguments eq_bag.

Axiom bag_extensionality : forall (a:Type), forall (a1:(map a Z)) (b:(map a
  Z)), (eq_bag a1 b) -> (a1 = b).

Parameter empty_bag: forall (a:Type),  (map a Z).

Set Contextual Implicit.
Implicit Arguments empty_bag.
Unset Contextual Implicit.

Axiom occ_empty : forall (a:Type), forall (x:a), ((get (empty_bag:(map a Z))
  x) = 0%Z).

Axiom is_empty : forall (a:Type), forall (b:(map a Z)), (forall (x:a),
  ((get b x) = 0%Z)) -> (b = (empty_bag:(map a Z))).

Axiom occ_singleton_eq : forall (a:Type), forall (x:a) (y:a), (x = y) ->
  ((get (set (empty_bag:(map a Z)) x 1%Z) y) = 1%Z).

Axiom occ_singleton_neq : forall (a:Type), forall (x:a) (y:a), (~ (x = y)) ->
  ((get (set (empty_bag:(map a Z)) x 1%Z) y) = 0%Z).

Parameter union: forall (a:Type), (map a Z) -> (map a Z)  -> (map a Z).

Implicit Arguments union.

Axiom occ_union : forall (a:Type), forall (x:a) (a1:(map a Z)) (b:(map a Z)),
  ((get (union a1 b) x) = ((get a1 x) + (get b x))%Z).

Axiom Union_comm : forall (a:Type), forall (a1:(map a Z)) (b:(map a Z)),
  ((union a1 b) = (union b a1)).

Axiom Union_identity : forall (a:Type), forall (a1:(map a Z)), ((union a1
  (empty_bag:(map a Z))) = a1).

Axiom Union_assoc : forall (a:Type), forall (a1:(map a Z)) (b:(map a Z))
  (c:(map a Z)), ((union a1 (union b c)) = (union (union a1 b) c)).

Axiom bag_simpl : forall (a:Type), forall (a1:(map a Z)) (b:(map a Z))
  (c:(map a Z)), ((union a1 b) = (union c b)) -> (a1 = c).

Axiom bag_simpl_left : forall (a:Type), forall (a1:(map a Z)) (b:(map a Z))
  (c:(map a Z)), ((union a1 b) = (union a1 c)) -> (b = c).

Definition add (a:Type)(x:a) (b:(map a Z)): (map a Z) :=
  (union (set (empty_bag:(map a Z)) x 1%Z) b).
Implicit Arguments add.

Axiom occ_add_eq : forall (a:Type), forall (b:(map a Z)) (x:a) (y:a),
  (x = y) -> ((get (add x b) x) = ((get b x) + 1%Z)%Z).

Axiom occ_add_neq : forall (a:Type), forall (b:(map a Z)) (x:a) (y:a),
  (~ (x = y)) -> ((get (add x b) y) = (get b y)).

Parameter card: forall (a:Type), (map a Z)  -> Z.

Implicit Arguments card.

Axiom Card_empty : forall (a:Type), ((card (empty_bag:(map a Z))) = 0%Z).

Axiom Card_singleton : forall (a:Type), forall (x:a),
  ((card (set (empty_bag:(map a Z)) x 1%Z)) = 1%Z).

Axiom Card_union : forall (a:Type), forall (x:(map a Z)) (y:(map a Z)),
  ((card (union x y)) = ((card x) + (card y))%Z).

Axiom Card_zero_empty : forall (a:Type), forall (x:(map a Z)),
  ((card x) = 0%Z) -> (x = (empty_bag:(map a Z))).

Definition array (a:Type) := (map Z a).

Parameter elements: forall (a:Type), (map Z a) -> Z -> Z  -> (map a Z).

Implicit Arguments elements.

Axiom Elements_empty : forall (a:Type), forall (a1:(map Z a)) (i:Z) (j:Z),
  (j <= i)%Z -> ((elements a1 i j) = (empty_bag:(map a Z))).

Axiom Elements_singleton : forall (a:Type), forall (a1:(map Z a)) (i:Z)
  (j:Z), (j = (i + 1%Z)%Z) -> ((elements a1 i j) = (set (empty_bag:(map a Z))
  (get a1 i) 1%Z)).

Axiom Elements_union : forall (a:Type), forall (a1:(map Z a)) (i:Z) (j:Z)
  (k:Z), ((i <= j)%Z /\ (j <= k)%Z) -> ((elements a1 i
  k) = (union (elements a1 i j) (elements a1 j k))).

Axiom Elements_union1 : forall (a:Type), forall (a1:(map Z a)) (i:Z) (j:Z),
  (i <  j)%Z -> ((elements a1 i j) = (add (get a1 i) (elements a1 (i + 1%Z)%Z
  j))).

Axiom Elements_union2 : forall (a:Type), forall (a1:(map Z a)) (i:Z) (j:Z),
  (i <  j)%Z -> ((elements a1 i j) = (add (get a1 (j - 1%Z)%Z) (elements a1 i
  (j - 1%Z)%Z))).

Axiom Elements_set_outside : forall (a:Type), forall (a1:(map Z a)) (i:Z)
  (j:Z), (i <= j)%Z -> forall (k:Z), ((k <  i)%Z \/ (j <= k)%Z) ->
  forall (e:a), ((elements (set a1 k e) i j) = (elements a1 i j)).

Axiom Elements_union3 : forall (a:Type), forall (a1:(map Z a)) (i:Z) (j:Z)
  (e:a), (i <= j)%Z -> ((add e (elements a1 i j)) = (elements (set a1 j e) i
  (j + 1%Z)%Z)).

Axiom Elements_set2 : forall (a:Type), forall (a1:(map Z a)) (i:Z) (j:Z)
  (k:Z), ((i <= k)%Z /\ (k <  j)%Z) -> forall (e:a), ((add (get a1 k)
  (elements (set a1 k e) i j)) = (add e (elements a1 i j))).

(* YOU MAY EDIT THE CONTEXT BELOW *)

(* DO NOT EDIT BELOW *)

Theorem Elements_set_inside : forall (a:Type), forall (a1:(map Z a)) (i:Z)
  (j:Z) (n:Z) (e:a) (b:(map a Z)), ((i <= j)%Z /\ (j <  n)%Z) ->
  (((elements a1 i n) = (add (get a1 j) b)) -> ((elements (set a1 j e) i
  n) = (add e b))).
(* YOU MAY EDIT THE PROOF BELOW *)
intros X a i j n e b Hi H.
apply bag_simpl_left with (a1:=(add (get a j) empty_bag)).
replace (add e b) with (union b (add e empty_bag)).
2: rewrite Union_comm ; unfold add ; rewrite Union_identity; auto.
rewrite Union_assoc.
unfold add; rewrite Union_identity.
unfold add in H; rewrite <- H; clear H.
rewrite Elements_union with (j:=j); auto with zarith.
rewrite Elements_set_outside; auto with zarith.
pattern (elements (set a j e) j n); rewrite Elements_union1; auto with zarith.
rewrite Select_eq; auto.
rewrite Elements_set_outside; auto with zarith.
rewrite Elements_union with (i:=i) (j:=j) (k:=n); auto with zarith.
pattern (elements a j n); rewrite Elements_union1; auto with zarith.
(* AC1 equality *)
rewrite Union_identity.
rewrite Union_assoc.
pattern (union (set empty_bag (get a j) 1%Z) (elements a i j)); rewrite Union_comm.
rewrite <- Union_assoc.
rewrite <- Union_assoc.
apply f_equal.
unfold add.
rewrite <- Union_assoc.
apply f_equal.
apply Union_comm.
Qed.
(* DO NOT EDIT BELOW *)

