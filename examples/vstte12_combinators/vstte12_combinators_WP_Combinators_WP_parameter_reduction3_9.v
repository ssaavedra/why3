(* This file is generated by Why3's Coq driver *)
(* Beware! Only edit allowed sections below    *)
Require Import BuiltIn.
Require BuiltIn.
Require int.Int.
Require int.Div2.

(* Why3 assumption *)
Definition unit := unit.

Axiom qtmark : Type.
Parameter qtmark_WhyType : WhyType qtmark.
Existing Instance qtmark_WhyType.

(* Why3 assumption *)
Inductive term :=
  | S : term
  | K : term
  | App : term -> term -> term.
Axiom term_WhyType : WhyType term.
Existing Instance term_WhyType.

(* Why3 assumption *)
Fixpoint is_value (t:term) {struct t}: Prop :=
  match t with
  | (K|S) => True
  | ((App K v)|(App S v)) => (is_value v)
  | (App (App S v1) v2) => (is_value v1) /\ (is_value v2)
  | _ => False
  end.

(* Why3 assumption *)
Inductive context :=
  | Hole : context
  | Left : context -> term -> context
  | Right : term -> context -> context.
Axiom context_WhyType : WhyType context.
Existing Instance context_WhyType.

(* Why3 assumption *)
Fixpoint is_context (c:context) {struct c}: Prop :=
  match c with
  | Hole => True
  | (Left c1 _) => (is_context c1)
  | (Right v c1) => (is_value v) /\ (is_context c1)
  end.

(* Why3 assumption *)
Fixpoint subst (c:context) (t:term) {struct c}: term :=
  match c with
  | Hole => t
  | (Left c1 t2) => (App (subst c1 t) t2)
  | (Right v1 c2) => (App v1 (subst c2 t))
  end.

(* Why3 assumption *)
Inductive infix_mnmngt: term -> term -> Prop :=
  | red_K : forall (c:context), (is_context c) -> forall (v1:term) (v2:term),
      (is_value v1) -> ((is_value v2) -> (infix_mnmngt (subst c (App (App K
      v1) v2)) (subst c v1)))
  | red_S : forall (c:context), (is_context c) -> forall (v1:term) (v2:term)
      (v3:term), (is_value v1) -> ((is_value v2) -> ((is_value v3) ->
      (infix_mnmngt (subst c (App (App (App S v1) v2) v3)) (subst c
      (App (App v1 v3) (App v2 v3)))))).

Axiom red_left : forall (t1:term) (t2:term) (t:term), (infix_mnmngt t1 t2) ->
  (infix_mnmngt (App t1 t) (App t2 t)).

Axiom red_right : forall (v:term) (t1:term) (t2:term), (is_value v) ->
  ((infix_mnmngt t1 t2) -> (infix_mnmngt (App v t1) (App v t2))).

(* Why3 assumption *)
Inductive relTR: term -> term -> Prop :=
  | BaseTransRefl : forall (x:term), (relTR x x)
  | StepTransRefl : forall (x:term) (y:term) (z:term), (relTR x y) ->
      ((infix_mnmngt y z) -> (relTR x z)).

Axiom relTR_transitive : forall (x:term) (y:term) (z:term), (relTR x y) ->
  ((relTR y z) -> (relTR x z)).

Axiom red_star_left : forall (t1:term) (t2:term) (t:term), (relTR t1 t2) ->
  (relTR (App t1 t) (App t2 t)).

Axiom red_star_right : forall (v:term) (t1:term) (t2:term), (is_value v) ->
  ((relTR t1 t2) -> (relTR (App v t1) (App v t2))).

Axiom reducible_or_value : forall (t:term), (exists t':term, (infix_mnmngt t
  t')) \/ (is_value t).

(* Why3 assumption *)
Definition irreducible (t:term): Prop := forall (t':term), ~ (infix_mnmngt t
  t').

Axiom irreducible_is_value : forall (t:term), (irreducible t) <-> (is_value
  t).

(* Why3 assumption *)
Inductive only_K: term -> Prop :=
  | only_K_K : (only_K K)
  | only_K_App : forall (t1:term) (t2:term), (only_K t1) -> ((only_K t2) ->
      (only_K (App t1 t2))).

Axiom only_K_reduces : forall (t:term), (only_K t) -> exists v:term, (relTR t
  v) /\ ((is_value v) /\ (only_K v)).

(* Why3 assumption *)
Fixpoint size (t:term) {struct t}: Z :=
  match t with
  | (K|S) => 0%Z
  | (App t1 t2) => ((1%Z + (size t1))%Z + (size t2))%Z
  end.

Axiom size_nonneg : forall (t:term), (0%Z <= (size t))%Z.

Parameter ks: Z -> term.

Axiom ksO : ((ks 0%Z) = K).

Axiom ksS : forall (n:Z), (0%Z <= n)%Z -> ((ks (n + 1%Z)%Z) = (App (ks n)
  K)).

Axiom ks1 : ((ks 1%Z) = (App K K)).

Axiom only_K_ks : forall (n:Z), (0%Z <= n)%Z -> (only_K (ks n)).

Axiom ks_inversion : forall (n:Z), (0%Z <= n)%Z -> ((n = 0%Z) \/
  ((0%Z < n)%Z /\ ((ks n) = (App (ks (n - 1%Z)%Z) K)))).

Axiom ks_injective : forall (n1:Z) (n2:Z), (0%Z <= n1)%Z -> ((0%Z <= n2)%Z ->
  (((ks n1) = (ks n2)) -> (n1 = n2))).

Require Import Why3. 
Ltac ae := why3 "alt-ergo" timelimit 10.

(* Why3 goal *)
Theorem WP_parameter_reduction3 : forall (t:term), (exists n:Z,
  (0%Z <= n)%Z /\ (t = (ks n))) -> forall (x:term) (x1:term), (t = (App x
  x1)) -> ((exists n:Z, (0%Z <= n)%Z /\ (x = (ks n))) ->
  forall (result:term), ((is_value result) /\ forall (n:Z), (0%Z <= n)%Z ->
  (((x = (ks (2%Z * n)%Z)) -> (result = K)) /\
  ((x = (ks ((2%Z * n)%Z + 1%Z)%Z)) -> (result = (App K K))))) ->
  forall (x2:term) (x3:term), (result = (App x2 x3)) -> ((x2 = S) ->
  ((exists n:Z, (0%Z <= n)%Z /\ (x1 = (ks n))) -> forall (o:term), ((is_value
  o) /\ forall (n:Z), (0%Z <= n)%Z -> (((x1 = (ks (2%Z * n)%Z)) ->
  (o = K)) /\ ((x1 = (ks ((2%Z * n)%Z + 1%Z)%Z)) -> (o = (App K K))))) ->
  ((is_value (App (App S x3) o)) /\ forall (n:Z), (0%Z <= n)%Z ->
  ((~ (t = (ks (2%Z * n)%Z))) /\ ~ (t = (ks ((2%Z * n)%Z + 1%Z)%Z))))))).
intros t (n,(h1,h2)) x x1 h3 (n1,(h4,h5)) result (h6,h7) x2 x3 h8 h9
        (n2,(h10,h11)) o (h12,h13).
subst.
destruct (Div2.div2 n1).
intuition; ae.
Qed.

