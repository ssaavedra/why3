(* This file is generated by Why3's Coq driver *)
(* Beware! Only edit allowed sections below    *)
Require Import ZArith.
Require Import Rbase.
Require int.Int.

(* Why3 assumption *)
Definition implb(x:bool) (y:bool): bool := match (x,
  y) with
  | (true, false) => false
  | (_, _) => true
  end.

(* Why3 assumption *)
Inductive datatype  :=
  | TYunit : datatype 
  | TYint : datatype 
  | TYbool : datatype .

(* Why3 assumption *)
Inductive value  :=
  | Vvoid : value 
  | Vint : Z -> value 
  | Vbool : bool -> value .

(* Why3 assumption *)
Inductive operator  :=
  | Oplus : operator 
  | Ominus : operator 
  | Omult : operator 
  | Ole : operator .

(* Why3 assumption *)
Definition ident  := Z.

(* Why3 assumption *)
Inductive term  :=
  | Tvalue : value -> term 
  | Tvar : Z -> term 
  | Tderef : Z -> term 
  | Tbin : term -> operator -> term -> term .

(* Why3 assumption *)
Inductive fmla  :=
  | Fterm : term -> fmla 
  | Fand : fmla -> fmla -> fmla 
  | Fnot : fmla -> fmla 
  | Fimplies : fmla -> fmla -> fmla 
  | Flet : Z -> term -> fmla -> fmla 
  | Fforall : Z -> datatype -> fmla -> fmla .

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

Axiom Const : forall (b:Type) (a:Type), forall (b1:b) (a1:a),
  ((get (const b1:(map a b)) a1) = b1).

(* Why3 assumption *)
Definition env  := (map Z value).

(* Why3 assumption *)
Inductive list (a:Type) :=
  | Nil : list a
  | Cons : a -> (list a) -> list a.
Set Contextual Implicit.
Implicit Arguments Nil.
Unset Contextual Implicit.
Implicit Arguments Cons.

(* Why3 assumption *)
Definition stack  := (list (Z* value)%type).

Parameter eval_bin: value -> operator -> value -> value.

Axiom eval_bin_def : forall (x:value) (op:operator) (y:value), match (x,
  y) with
  | ((Vint x1), (Vint y1)) =>
      match op with
      | Oplus => ((eval_bin x op y) = (Vint (x1 + y1)%Z))
      | Ominus => ((eval_bin x op y) = (Vint (x1 - y1)%Z))
      | Omult => ((eval_bin x op y) = (Vint (x1 * y1)%Z))
      | Ole => ((x1 <= y1)%Z -> ((eval_bin x op y) = (Vbool true))) /\
          ((~ (x1 <= y1)%Z) -> ((eval_bin x op y) = (Vbool false)))
      end
  | (_, _) => ((eval_bin x op y) = (Vbool false))
  end.

Parameter get_stack: Z -> (list (Z* value)%type) -> value.

Axiom get_stack_def : forall (i:Z) (pi:(list (Z* value)%type)),
  match pi with
  | Nil => ((get_stack i pi) = Vvoid)
  | (Cons (x, v) r) => ((x = i) -> ((get_stack i pi) = v)) /\ ((~ (x = i)) ->
      ((get_stack i pi) = (get_stack i r)))
  end.

Axiom get_stack_eq : forall (x:Z) (v:value) (r:(list (Z* value)%type)),
  ((get_stack x (Cons (x, v) r)) = v).

Axiom get_stack_neq : forall (x:Z) (i:Z) (v:value) (r:(list (Z*
  value)%type)), (~ (x = i)) -> ((get_stack i (Cons (x, v) r)) = (get_stack i
  r)).

(* Why3 assumption *)
Set Implicit Arguments.
Fixpoint eval_term(sigma:(map Z value)) (pi:(list (Z* value)%type))
  (t:term) {struct t}: value :=
  match t with
  | (Tvalue v) => v
  | (Tvar id) => (get_stack id pi)
  | (Tderef id) => (get sigma id)
  | (Tbin t1 op t2) => (eval_bin (eval_term sigma pi t1) op (eval_term sigma
      pi t2))
  end.
Unset Implicit Arguments.

(* Why3 assumption *)
Set Implicit Arguments.
Fixpoint eval_fmla(sigma:(map Z value)) (pi:(list (Z* value)%type))
  (f:fmla) {struct f}: Prop :=
  match f with
  | (Fterm t) => ((eval_term sigma pi t) = (Vbool true))
  | (Fand f1 f2) => (eval_fmla sigma pi f1) /\ (eval_fmla sigma pi f2)
  | (Fnot f1) => ~ (eval_fmla sigma pi f1)
  | (Fimplies f1 f2) => (eval_fmla sigma pi f1) -> (eval_fmla sigma pi f2)
  | (Flet x t f1) => (eval_fmla sigma (Cons (x, (eval_term sigma pi t)) pi)
      f1)
  | (Fforall x TYint f1) => forall (n:Z), (eval_fmla sigma (Cons (x,
      (Vint n)) pi) f1)
  | (Fforall x TYbool f1) => forall (b:bool), (eval_fmla sigma (Cons (x,
      (Vbool b)) pi) f1)
  | (Fforall x TYunit f1) => (eval_fmla sigma (Cons (x, Vvoid) pi) f1)
  end.
Unset Implicit Arguments.

Parameter subst_term: term -> Z -> Z -> term.

Axiom subst_term_def : forall (e:term) (r:Z) (v:Z),
  match e with
  | ((Tvalue _)|(Tvar _)) => ((subst_term e r v) = e)
  | (Tderef x) => ((r = x) -> ((subst_term e r v) = (Tvar v))) /\
      ((~ (r = x)) -> ((subst_term e r v) = e))
  | (Tbin e1 op e2) => ((subst_term e r v) = (Tbin (subst_term e1 r v) op
      (subst_term e2 r v)))
  end.

(* Why3 assumption *)
Set Implicit Arguments.
Fixpoint fresh_in_term(id:Z) (t:term) {struct t}: Prop :=
  match t with
  | (Tvalue _) => True
  | (Tvar v) => ~ (id = v)
  | (Tderef _) => True
  | (Tbin t1 _ t2) => (fresh_in_term id t1) /\ (fresh_in_term id t2)
  end.
Unset Implicit Arguments.

Axiom eval_subst_term : forall (sigma:(map Z value)) (pi:(list (Z*
  value)%type)) (e:term) (x:Z) (v:Z), (fresh_in_term v e) ->
  ((eval_term sigma pi (subst_term e x v)) = (eval_term (set sigma x
  (get_stack v pi)) pi e)).

Axiom eval_term_change_free : forall (t:term) (sigma:(map Z value)) (pi:(list
  (Z* value)%type)) (id:Z) (v:value), (fresh_in_term id t) ->
  ((eval_term sigma (Cons (id, v) pi) t) = (eval_term sigma pi t)).

(* Why3 assumption *)
Set Implicit Arguments.
Fixpoint fresh_in_fmla(id:Z) (f:fmla) {struct f}: Prop :=
  match f with
  | (Fterm e) => (fresh_in_term id e)
  | ((Fand f1 f2)|(Fimplies f1 f2)) => (fresh_in_fmla id f1) /\
      (fresh_in_fmla id f2)
  | (Fnot f1) => (fresh_in_fmla id f1)
  | (Flet y t f1) => (~ (id = y)) /\ ((fresh_in_term id t) /\
      (fresh_in_fmla id f1))
  | (Fforall y ty f1) => (~ (id = y)) /\ (fresh_in_fmla id f1)
  end.
Unset Implicit Arguments.

(* Why3 assumption *)
Set Implicit Arguments.
Fixpoint subst(f:fmla) (x:Z) (v:Z) {struct f}: fmla :=
  match f with
  | (Fterm e) => (Fterm (subst_term e x v))
  | (Fand f1 f2) => (Fand (subst f1 x v) (subst f2 x v))
  | (Fnot f1) => (Fnot (subst f1 x v))
  | (Fimplies f1 f2) => (Fimplies (subst f1 x v) (subst f2 x v))
  | (Flet y t f1) => (Flet y (subst_term t x v) (subst f1 x v))
  | (Fforall y ty f1) => (Fforall y ty (subst f1 x v))
  end.
Unset Implicit Arguments.

Axiom eval_subst : forall (f:fmla) (sigma:(map Z value)) (pi:(list (Z*
  value)%type)) (x:Z) (v:Z), (fresh_in_fmla v f) -> ((eval_fmla sigma pi
  (subst f x v)) <-> (eval_fmla (set sigma x (get_stack v pi)) pi f)).

Axiom eval_swap : forall (f:fmla) (sigma:(map Z value)) (pi:(list (Z*
  value)%type)) (id1:Z) (id2:Z) (v1:value) (v2:value), (~ (id1 = id2)) ->
  ((eval_fmla sigma (Cons (id1, v1) (Cons (id2, v2) pi)) f) <->
  (eval_fmla sigma (Cons (id2, v2) (Cons (id1, v1) pi)) f)).

Axiom eval_change_free : forall (f:fmla) (sigma:(map Z value)) (pi:(list (Z*
  value)%type)) (id:Z) (v:value), (fresh_in_fmla id f) -> ((eval_fmla sigma
  (Cons (id, v) pi) f) <-> (eval_fmla sigma pi f)).

(* Why3 assumption *)
Inductive expr  :=
  | Evalue : value -> expr 
  | Ebin : expr -> operator -> expr -> expr 
  | Evar : Z -> expr 
  | Ederef : Z -> expr 
  | Eassign : Z -> expr -> expr 
  | Eseq : expr -> expr -> expr 
  | Elet : Z -> expr -> expr -> expr 
  | Eif : expr -> expr -> expr -> expr 
  | Eassert : fmla -> expr 
  | Ewhile : expr -> fmla -> expr -> expr .

(* Why3 assumption *)
Inductive one_step : (map Z value) -> (list (Z* value)%type) -> expr -> (map
  Z value) -> (list (Z* value)%type) -> expr -> Prop :=
  | one_step_assign_ctxt : forall (sigma:(map Z value)) (sigmaqt:(map Z
      value)) (pi:(list (Z* value)%type)) (piqt:(list (Z* value)%type)) (x:Z)
      (e:expr) (eqt:expr), (one_step sigma pi e sigmaqt piqt eqt) ->
      (one_step sigma pi (Eassign x e) sigmaqt piqt (Eassign x eqt))
  | one_step_assign_value : forall (sigma:(map Z value)) (pi:(list (Z*
      value)%type)) (x:Z) (v:value), (one_step sigma pi (Eassign x
      (Evalue v)) (set sigma x v) pi (Evalue Vvoid))
  | one_step_seq_ctxt : forall (sigma:(map Z value)) (sigmaqt:(map Z value))
      (pi:(list (Z* value)%type)) (piqt:(list (Z* value)%type)) (e1:expr)
      (e1qt:expr) (e2:expr), (one_step sigma pi e1 sigmaqt piqt e1qt) ->
      (one_step sigma pi (Eseq e1 e2) sigmaqt piqt (Eseq e1qt e2))
  | one_step_seq_value : forall (sigma:(map Z value)) (pi:(list (Z*
      value)%type)) (e:expr), (one_step sigma pi (Eseq (Evalue Vvoid) e)
      sigma pi e)
  | one_step_let_ctxt : forall (sigma:(map Z value)) (sigmaqt:(map Z value))
      (pi:(list (Z* value)%type)) (piqt:(list (Z* value)%type)) (id:Z)
      (e1:expr) (e1qt:expr) (e2:expr), (one_step sigma pi e1 sigmaqt piqt
      e1qt) -> (one_step sigma pi (Elet id e1 e2) sigmaqt piqt (Elet id e1qt
      e2))
  | one_step_let_value : forall (sigma:(map Z value)) (pi:(list (Z*
      value)%type)) (id:Z) (v:value) (e:expr), (one_step sigma pi (Elet id
      (Evalue v) e) sigma (Cons (id, v) pi) e)
  | one_step_if_ctxt : forall (sigma:(map Z value)) (sigmaqt:(map Z value))
      (pi:(list (Z* value)%type)) (piqt:(list (Z* value)%type)) (e1:expr)
      (e1qt:expr) (e2:expr) (e3:expr), (one_step sigma pi e1 sigmaqt piqt
      e1qt) -> (one_step sigma pi (Eif e1 e2 e3) sigmaqt piqt (Eif e1qt e2
      e3))
  | one_step_if_true : forall (sigma:(map Z value)) (pi:(list (Z*
      value)%type)) (e1:expr) (e2:expr), (one_step sigma pi
      (Eif (Evalue (Vbool true)) e1 e2) sigma pi e1)
  | one_step_if_false : forall (sigma:(map Z value)) (pi:(list (Z*
      value)%type)) (e1:expr) (e2:expr), (one_step sigma pi
      (Eif (Evalue (Vbool false)) e1 e2) sigma pi e2)
  | one_step_assert : forall (sigma:(map Z value)) (pi:(list (Z*
      value)%type)) (f:fmla), (eval_fmla sigma pi f) -> (one_step sigma pi
      (Eassert f) sigma pi (Evalue Vvoid))
  | one_step_while : forall (sigma:(map Z value)) (pi:(list (Z* value)%type))
      (e:expr) (inv:fmla) (eqt:expr), (one_step sigma pi (Ewhile e inv eqt)
      sigma pi (Eif e (Eseq eqt (Ewhile e inv eqt)) (Evalue Vvoid))).

(* Why3 assumption *)
Inductive many_steps : (map Z value) -> (list (Z* value)%type) -> expr
  -> (map Z value) -> (list (Z* value)%type) -> expr -> Z -> Prop :=
  | many_steps_refl : forall (sigma:(map Z value)) (pi:(list (Z*
      value)%type)) (i:expr), (many_steps sigma pi i sigma pi i 0%Z)
  | many_steps_trans : forall (sigma1:(map Z value)) (sigma2:(map Z value))
      (sigma3:(map Z value)) (pi1:(list (Z* value)%type)) (pi2:(list (Z*
      value)%type)) (pi3:(list (Z* value)%type)) (i1:expr) (i2:expr)
      (i3:expr) (n:Z), (one_step sigma1 pi1 i1 sigma2 pi2 i2) ->
      ((many_steps sigma2 pi2 i2 sigma3 pi3 i3 n) -> (many_steps sigma1 pi1
      i1 sigma3 pi3 i3 (n + 1%Z)%Z)).

Axiom steps_non_neg : forall (sigma1:(map Z value)) (sigma2:(map Z value))
  (pi1:(list (Z* value)%type)) (pi2:(list (Z* value)%type)) (i1:expr)
  (i2:expr) (n:Z), (many_steps sigma1 pi1 i1 sigma2 pi2 i2 n) ->
  (0%Z <= n)%Z.

Axiom many_steps_seq : forall (sigma1:(map Z value)) (sigma3:(map Z value))
  (pi1:(list (Z* value)%type)) (pi3:(list (Z* value)%type)) (e1:expr)
  (e2:expr) (n:Z), (many_steps sigma1 pi1 (Eseq e1 e2) sigma3 pi3
  (Evalue Vvoid) n) -> exists sigma2:(map Z value), exists pi2:(list (Z*
  value)%type), exists n1:Z, exists n2:Z, (many_steps sigma1 pi1 e1 sigma2
  pi2 (Evalue Vvoid) n1) /\ ((many_steps sigma2 pi2 e2 sigma3 pi3
  (Evalue Vvoid) n2) /\ (n = ((1%Z + n1)%Z + n2)%Z)).

(* Why3 goal *)
Theorem many_steps_let : forall (sigma1:(map Z value)) (sigma3:(map Z value))
  (pi1:(list (Z* value)%type)) (pi3:(list (Z* value)%type)) (id:Z) (e1:expr)
  (e2:expr) (v2:value) (n:Z), (many_steps sigma1 pi1 (Elet id e1 e2) sigma3
  pi3 (Evalue v2) n) -> exists sigma2:(map Z value), exists pi2:(list (Z*
  value)%type), exists v1:value, exists n1:Z, exists n2:Z, (many_steps sigma1
  pi1 e1 sigma2 pi2 (Evalue v1) n1) /\ ((many_steps sigma2 (Cons (id, v1)
  pi2) e2 sigma3 pi3 (Evalue v2) n2) /\ (n = ((1%Z + n1)%Z + n2)%Z)).
intros s1 s3 p1 p3 id i1 i2 v n Hred.
generalize Hred.
generalize (steps_non_neg _ _ _ _ _ _ _ Hred).
clear Hred.
intros H.
generalize s1 p1 i1; clear s1 p1 i1.
pattern n; apply Z_lt_induction; auto.
intros.
inversion Hred; subst; clear Hred.
inversion H1; subst; clear H1.
(* case i1 not a value *)
assert (h:(0 <= n0 < n0+1)%Z).
  generalize (steps_non_neg _ _ _ _ _ _ _ H2); omega.
generalize (H0 n0 h _ _ _ H2).
intros (s4 & p4 & v4 & n4 & n5 & h1 & h2 & h3).
exists s4.
exists p4.
exists v4.
exists (n4+1)%Z.
exists n5.
split.
apply many_steps_trans with (1:=H11); auto.
split; auto with zarith.

(* case i1 is a value *)
exists sigma2.
exists p1.
exists v0.
exists 0%Z.
exists n0.
split.
constructor.
split; auto with zarith.
Qed.


