(* This file is generated by Why3's Coq driver *)
(* Beware! Only edit allowed sections below    *)
Require Import BuiltIn.
Require BuiltIn.
Require int.Int.

Axiom t : Type.
Parameter t_WhyType : WhyType t.
Existing Instance t_WhyType.

Parameter le: t -> t -> Prop.

(* Why3 assumption *)
Inductive list (a:Type) {a_WT:WhyType a} :=
  | Nil : list a
  | Cons : a -> (list a) -> list a.
Axiom list_WhyType : forall (a:Type) {a_WT:WhyType a}, WhyType (list a).
Existing Instance list_WhyType.
Implicit Arguments Nil [[a] [a_WT]].
Implicit Arguments Cons [[a] [a_WT]].

(* Why3 assumption *)
Inductive sorted : (list t) -> Prop :=
  | Sorted_Nil : (sorted (Nil :(list t)))
  | Sorted_One : forall (x:t), (sorted (Cons x (Nil :(list t))))
  | Sorted_Two : forall (x:t) (y:t) (l:(list t)), (le x y) ->
      ((sorted (Cons y l)) -> (sorted (Cons x (Cons y l)))).

(* Why3 assumption *)
Fixpoint mem {a:Type} {a_WT:WhyType a}(x:a) (l:(list a)) {struct l}: Prop :=
  match l with
  | Nil => False
  | (Cons y r) => (x = y) \/ (mem x r)
  end.

Axiom sorted_mem : forall (x:t) (l:(list t)), ((forall (y:t), (mem y l) ->
  (le x y)) /\ (sorted l)) <-> (sorted (Cons x l)).

(* Why3 assumption *)
Inductive sorted1 : (list t) -> Prop :=
  | Sorted_Nil1 : (sorted1 (Nil :(list t)))
  | Sorted_One1 : forall (x:t), (sorted1 (Cons x (Nil :(list t))))
  | Sorted_Two1 : forall (x:t) (y:t) (l:(list t)), (le y x) ->
      ((sorted1 (Cons y l)) -> (sorted1 (Cons x (Cons y l)))).

Axiom sorted_mem1 : forall (x:t) (l:(list t)), ((forall (y:t), (mem y l) ->
  (le y x)) /\ (sorted1 l)) <-> (sorted1 (Cons x l)).

(* Why3 assumption *)
Definition compat(s:(list t)) (t1:(list t)): Prop := match (s,
  t1) with
  | ((Cons x _), (Cons y _)) => (le x y)
  | (_, _) => True
  end.

(* Why3 assumption *)
Fixpoint infix_plpl {a:Type} {a_WT:WhyType a}(l1:(list a)) (l2:(list
  a)) {struct l1}: (list a) :=
  match l1 with
  | Nil => l2
  | (Cons x1 r1) => (Cons x1 (infix_plpl r1 l2))
  end.

Axiom Append_assoc : forall {a:Type} {a_WT:WhyType a}, forall (l1:(list a))
  (l2:(list a)) (l3:(list a)), ((infix_plpl l1 (infix_plpl l2
  l3)) = (infix_plpl (infix_plpl l1 l2) l3)).

Axiom Append_l_nil : forall {a:Type} {a_WT:WhyType a}, forall (l:(list a)),
  ((infix_plpl l (Nil :(list a))) = l).

(* Why3 assumption *)
Fixpoint length {a:Type} {a_WT:WhyType a}(l:(list a)) {struct l}: Z :=
  match l with
  | Nil => 0%Z
  | (Cons _ r) => (1%Z + (length r))%Z
  end.

Axiom Length_nonnegative : forall {a:Type} {a_WT:WhyType a}, forall (l:(list
  a)), (0%Z <= (length l))%Z.

Axiom Length_nil : forall {a:Type} {a_WT:WhyType a}, forall (l:(list a)),
  ((length l) = 0%Z) <-> (l = (Nil :(list a))).

Axiom Append_length : forall {a:Type} {a_WT:WhyType a}, forall (l1:(list a))
  (l2:(list a)), ((length (infix_plpl l1
  l2)) = ((length l1) + (length l2))%Z).

Axiom mem_append : forall {a:Type} {a_WT:WhyType a}, forall (x:a) (l1:(list
  a)) (l2:(list a)), (mem x (infix_plpl l1 l2)) <-> ((mem x l1) \/ (mem x
  l2)).

Axiom mem_decomp : forall {a:Type} {a_WT:WhyType a}, forall (x:a) (l:(list
  a)), (mem x l) -> exists l1:(list a), exists l2:(list a),
  (l = (infix_plpl l1 (Cons x l2))).

(* Why3 assumption *)
Fixpoint rev_append {a:Type} {a_WT:WhyType a}(s:(list a)) (t1:(list
  a)) {struct s}: (list a) :=
  match s with
  | (Cons x r) => (rev_append r (Cons x t1))
  | Nil => t1
  end.

Axiom rev_append_append_l : forall {a:Type} {a_WT:WhyType a}, forall (r:(list
  a)) (s:(list a)) (t1:(list a)), ((rev_append (infix_plpl r s)
  t1) = (rev_append s (rev_append r t1))).

Axiom rev_append_append_r : forall {a:Type} {a_WT:WhyType a}, forall (r:(list
  a)) (s:(list a)) (t1:(list a)), ((rev_append r (infix_plpl s
  t1)) = (rev_append (rev_append s r) t1)).

Axiom rev_append_length : forall {a:Type} {a_WT:WhyType a}, forall (s:(list
  a)) (t1:(list a)), ((length (rev_append s
  t1)) = ((length s) + (length t1))%Z).

(* Why3 goal *)
Theorem rev_append_sorted_incr : forall (s:(list t)) (t1:(list t)),
  (sorted (rev_append s t1)) <-> ((sorted1 s) /\ ((sorted t1) /\ (compat s
  t1))).
intros s.
induction s; intros r.
simpl.
intuition.
apply Sorted_Nil1.
unfold compat; auto.
simpl.
split.

intros h.
apply IHs in h.
intuition.
destruct s.
apply Sorted_One1.
apply Sorted_Two1.
unfold compat in H2.
auto.

auto.

destruct r.
apply Sorted_Nil.
inversion H1.
auto.

destruct r.
unfold compat; auto.
unfold compat.
inversion H1.
auto.

intros [h1 [h2 h3]].
apply IHs.
intuition.

inversion h1.
apply Sorted_Nil1.
auto.

destruct r.
apply Sorted_One.
apply Sorted_Two.
unfold compat in h3; auto.
auto.

destruct s; unfold compat; auto.
inversion h1.
auto.
Qed.

