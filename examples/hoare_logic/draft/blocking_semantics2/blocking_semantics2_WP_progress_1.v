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
Inductive list (a:Type) :=
  | Nil : list a
  | Cons : a -> (list a) -> list a.
Set Contextual Implicit.
Implicit Arguments Nil.
Unset Contextual Implicit.
Implicit Arguments Cons.

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

Parameter mident : Type.

Parameter ident : Type.

Parameter result: ident.

(* Why3 assumption *)
Inductive term  :=
  | Tvalue : value -> term 
  | Tvar : ident -> term 
  | Tderef : mident -> term 
  | Tbin : term -> operator -> term -> term .

(* Why3 assumption *)
Inductive fmla  :=
  | Fterm : term -> fmla 
  | Fand : fmla -> fmla -> fmla 
  | Fnot : fmla -> fmla 
  | Fimplies : fmla -> fmla -> fmla 
  | Flet : ident -> term -> fmla -> fmla 
  | Fforall : ident -> datatype -> fmla -> fmla .

(* Why3 assumption *)
Inductive expr  :=
  | Evalue : value -> expr 
  | Ebin : expr -> operator -> expr -> expr 
  | Evar : ident -> expr 
  | Ederef : mident -> expr 
  | Eassign : mident -> expr -> expr 
  | Eseq : expr -> expr -> expr 
  | Elet : ident -> expr -> expr -> expr 
  | Eif : expr -> expr -> expr -> expr 
  | Eassert : fmla -> expr 
  | Ewhile : expr -> fmla -> expr -> expr .

(* Why3 assumption *)
Definition type_value(v:value): datatype :=
  match v with
  | Vvoid => TYunit
  | (Vint int1) => TYint
  | (Vbool bool1) => TYbool
  end.

(* Why3 assumption *)
Inductive type_operator : operator -> datatype -> datatype
  -> datatype -> Prop :=
  | Type_plus : (type_operator Oplus TYint TYint TYint)
  | Type_minus : (type_operator Ominus TYint TYint TYint)
  | Type_mult : (type_operator Omult TYint TYint TYint)
  | Type_le : (type_operator Ole TYint TYint TYbool).

(* Why3 assumption *)
Definition type_stack  := (list (ident* datatype)%type).

Parameter get_vartype: ident -> (list (ident* datatype)%type) -> datatype.

Axiom get_vartype_def : forall (i:ident) (pi:(list (ident* datatype)%type)),
  match pi with
  | Nil => ((get_vartype i pi) = TYunit)
  | (Cons (x, ty) r) => ((x = i) -> ((get_vartype i pi) = ty)) /\
      ((~ (x = i)) -> ((get_vartype i pi) = (get_vartype i r)))
  end.

(* Why3 assumption *)
Definition type_env  := (map mident datatype).

(* Why3 assumption *)
Inductive type_term : (map mident datatype) -> (list (ident* datatype)%type)
  -> term -> datatype -> Prop :=
  | Type_value : forall (sigma:(map mident datatype)) (pi:(list (ident*
      datatype)%type)) (v:value), (type_term sigma pi (Tvalue v)
      (type_value v))
  | Type_var : forall (sigma:(map mident datatype)) (pi:(list (ident*
      datatype)%type)) (v:ident) (ty:datatype), ((get_vartype v pi) = ty) ->
      (type_term sigma pi (Tvar v) ty)
  | Type_deref : forall (sigma:(map mident datatype)) (pi:(list (ident*
      datatype)%type)) (v:mident) (ty:datatype), ((get sigma v) = ty) ->
      (type_term sigma pi (Tderef v) ty)
  | Type_bin : forall (sigma:(map mident datatype)) (pi:(list (ident*
      datatype)%type)) (t1:term) (t2:term) (op:operator) (ty1:datatype)
      (ty2:datatype) (ty:datatype), (type_term sigma pi t1 ty1) ->
      ((type_term sigma pi t2 ty2) -> ((type_operator op ty1 ty2 ty) ->
      (type_term sigma pi (Tbin t1 op t2) ty))).

(* Why3 assumption *)
Inductive type_fmla : (map mident datatype) -> (list (ident* datatype)%type)
  -> fmla -> Prop :=
  | Type_term : forall (sigma:(map mident datatype)) (pi:(list (ident*
      datatype)%type)) (t:term), (type_term sigma pi t TYbool) ->
      (type_fmla sigma pi (Fterm t))
  | Type_conj : forall (sigma:(map mident datatype)) (pi:(list (ident*
      datatype)%type)) (f1:fmla) (f2:fmla), (type_fmla sigma pi f1) ->
      ((type_fmla sigma pi f2) -> (type_fmla sigma pi (Fand f1 f2)))
  | Type_neg : forall (sigma:(map mident datatype)) (pi:(list (ident*
      datatype)%type)) (f:fmla), (type_fmla sigma pi f) -> (type_fmla sigma
      pi (Fnot f))
  | Type_implies : forall (sigma:(map mident datatype)) (pi:(list (ident*
      datatype)%type)) (f1:fmla) (f2:fmla), (type_fmla sigma pi f1) ->
      ((type_fmla sigma pi f2) -> (type_fmla sigma pi (Fimplies f1 f2)))
  | Type_let : forall (sigma:(map mident datatype)) (pi:(list (ident*
      datatype)%type)) (x:ident) (t:term) (f:fmla) (ty:datatype),
      (type_term sigma pi t ty) -> ((type_fmla sigma (Cons (x, ty) pi) f) ->
      (type_fmla sigma pi (Flet x t f)))
  | Type_forall1 : forall (sigma:(map mident datatype)) (pi:(list (ident*
      datatype)%type)) (x:ident) (f:fmla), (type_fmla sigma (Cons (x, TYint)
      pi) f) -> (type_fmla sigma pi (Fforall x TYint f))
  | Type_forall2 : forall (sigma:(map mident datatype)) (pi:(list (ident*
      datatype)%type)) (x:ident) (f:fmla), (type_fmla sigma (Cons (x, TYbool)
      pi) f) -> (type_fmla sigma pi (Fforall x TYbool f))
  | Type_forall3 : forall (sigma:(map mident datatype)) (pi:(list (ident*
      datatype)%type)) (x:ident) (f:fmla), (type_fmla sigma (Cons (x, TYunit)
      pi) f) -> (type_fmla sigma pi (Fforall x TYunit f)).

(* Why3 assumption *)
Inductive type_expr : (map mident datatype) -> (list (ident* datatype)%type)
  -> expr -> datatype -> Prop :=
  | Type_evalue : forall (sigma:(map mident datatype)) (pi:(list (ident*
      datatype)%type)) (v:value), (type_expr sigma pi (Evalue v)
      (type_value v))
  | Type_evar : forall (sigma:(map mident datatype)) (pi:(list (ident*
      datatype)%type)) (v:ident) (ty:datatype), ((get_vartype v pi) = ty) ->
      (type_expr sigma pi (Evar v) ty)
  | Type_ederef : forall (sigma:(map mident datatype)) (pi:(list (ident*
      datatype)%type)) (v:mident) (ty:datatype), ((get sigma v) = ty) ->
      (type_expr sigma pi (Ederef v) ty)
  | Type_ebin : forall (sigma:(map mident datatype)) (pi:(list (ident*
      datatype)%type)) (e1:expr) (e2:expr) (op:operator) (ty1:datatype)
      (ty2:datatype) (ty:datatype), (type_expr sigma pi e1 ty1) ->
      ((type_expr sigma pi e2 ty2) -> ((type_operator op ty1 ty2 ty) ->
      (type_expr sigma pi (Ebin e1 op e2) ty)))
  | Type_eseq : forall (sigma:(map mident datatype)) (pi:(list (ident*
      datatype)%type)) (e1:expr) (e2:expr) (ty:datatype), (type_expr sigma pi
      e1 TYunit) -> ((type_expr sigma pi e2 ty) -> (type_expr sigma pi
      (Eseq e1 e2) ty))
  | Type_eassigns : forall (sigma:(map mident datatype)) (pi:(list (ident*
      datatype)%type)) (x:mident) (e:expr) (ty:datatype), ((get sigma
      x) = ty) -> ((type_expr sigma pi e ty) -> (type_expr sigma pi
      (Eassign x e) TYunit))
  | Type_elet : forall (sigma:(map mident datatype)) (pi:(list (ident*
      datatype)%type)) (x:ident) (e1:expr) (e2:expr) (ty1:datatype)
      (ty2:datatype), (type_expr sigma pi e1 ty1) -> ((type_expr sigma
      (Cons (x, ty2) pi) e2 ty2) -> (type_expr sigma pi (Elet x e1 e2) ty2))
  | Type_eif : forall (sigma:(map mident datatype)) (pi:(list (ident*
      datatype)%type)) (e1:expr) (e2:expr) (e3:expr) (ty:datatype),
      (type_expr sigma pi e1 TYbool) -> ((type_expr sigma pi e2 ty) ->
      ((type_expr sigma pi e3 ty) -> (type_expr sigma pi (Eif e1 e2 e3) ty)))
  | Type_eassert : forall (sigma:(map mident datatype)) (pi:(list (ident*
      datatype)%type)) (p:fmla), (type_fmla sigma pi p) -> (type_expr sigma
      pi (Eassert p) TYbool)
  | Type_ewhile : forall (sigma:(map mident datatype)) (pi:(list (ident*
      datatype)%type)) (guard:expr) (body:expr) (inv:fmla), (type_fmla sigma
      pi inv) -> ((type_expr sigma pi guard TYbool) -> ((type_expr sigma pi
      body TYunit) -> (type_expr sigma pi (Ewhile guard inv body) TYunit))).

(* Why3 assumption *)
Definition env  := (map mident value).

(* Why3 assumption *)
Definition stack  := (list (ident* value)%type).

Parameter get_stack: ident -> (list (ident* value)%type) -> value.

Axiom get_stack_def : forall (i:ident) (pi:(list (ident* value)%type)),
  match pi with
  | Nil => ((get_stack i pi) = Vvoid)
  | (Cons (x, v) r) => ((x = i) -> ((get_stack i pi) = v)) /\ ((~ (x = i)) ->
      ((get_stack i pi) = (get_stack i r)))
  end.

Axiom get_stack_eq : forall (x:ident) (v:value) (r:(list (ident*
  value)%type)), ((get_stack x (Cons (x, v) r)) = v).

Axiom get_stack_neq : forall (x:ident) (i:ident) (v:value) (r:(list (ident*
  value)%type)), (~ (x = i)) -> ((get_stack i (Cons (x, v) r)) = (get_stack i
  r)).

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
  | (_, _) => ((eval_bin x op y) = Vvoid)
  end.

(* Why3 assumption *)
Set Implicit Arguments.
Fixpoint eval_term(sigma:(map mident value)) (pi:(list (ident* value)%type))
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
Fixpoint eval_fmla(sigma:(map mident value)) (pi:(list (ident* value)%type))
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

Parameter msubst_term: term -> mident -> ident -> term.

Axiom msubst_term_def : forall (e:term) (r:mident) (v:ident),
  match e with
  | ((Tvalue _)|(Tvar _)) => ((msubst_term e r v) = e)
  | (Tderef x) => ((r = x) -> ((msubst_term e r v) = (Tvar v))) /\
      ((~ (r = x)) -> ((msubst_term e r v) = e))
  | (Tbin e1 op e2) => ((msubst_term e r v) = (Tbin (msubst_term e1 r v) op
      (msubst_term e2 r v)))
  end.

Parameter subst_term: term -> ident -> ident -> term.

Axiom subst_term_def : forall (e:term) (r:ident) (v:ident),
  match e with
  | ((Tvalue _)|(Tderef _)) => ((subst_term e r v) = e)
  | (Tvar x) => ((r = x) -> ((subst_term e r v) = (Tvar v))) /\
      ((~ (r = x)) -> ((subst_term e r v) = e))
  | (Tbin e1 op e2) => ((subst_term e r v) = (Tbin (subst_term e1 r v) op
      (subst_term e2 r v)))
  end.

(* Why3 assumption *)
Set Implicit Arguments.
Fixpoint fresh_in_term(id:ident) (t:term) {struct t}: Prop :=
  match t with
  | (Tvalue _) => True
  | (Tvar v) => ~ (id = v)
  | (Tderef _) => True
  | (Tbin t1 _ t2) => (fresh_in_term id t1) /\ (fresh_in_term id t2)
  end.
Unset Implicit Arguments.

Axiom eval_msubst_term : forall (sigma:(map mident value)) (pi:(list (ident*
  value)%type)) (e:term) (x:mident) (v:ident), (fresh_in_term v e) ->
  ((eval_term sigma pi (msubst_term e x v)) = (eval_term (set sigma x
  (get_stack v pi)) pi e)).

Axiom eval_subst_term : forall (sigma:(map mident value)) (pi:(list (ident*
  value)%type)) (e:term) (x:ident) (v:ident), (fresh_in_term v e) ->
  ((eval_term sigma pi (subst_term e x v)) = (eval_term sigma (Cons (x,
  (get_stack v pi)) pi) e)).

Axiom eval_term_change_free : forall (t:term) (sigma:(map mident value))
  (pi:(list (ident* value)%type)) (id:ident) (v:value), (fresh_in_term id
  t) -> ((eval_term sigma (Cons (id, v) pi) t) = (eval_term sigma pi t)).

(* Why3 assumption *)
Set Implicit Arguments.
Fixpoint fresh_in_fmla(id:ident) (f:fmla) {struct f}: Prop :=
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
Fixpoint subst(f:fmla) (x:ident) (v:ident) {struct f}: fmla :=
  match f with
  | (Fterm e) => (Fterm (subst_term e x v))
  | (Fand f1 f2) => (Fand (subst f1 x v) (subst f2 x v))
  | (Fnot f1) => (Fnot (subst f1 x v))
  | (Fimplies f1 f2) => (Fimplies (subst f1 x v) (subst f2 x v))
  | (Flet y t f1) => (Flet y (subst_term t x v) (subst f1 x v))
  | (Fforall y ty f1) => (Fforall y ty (subst f1 x v))
  end.
Unset Implicit Arguments.

(* Why3 assumption *)
Set Implicit Arguments.
Fixpoint msubst(f:fmla) (x:mident) (v:ident) {struct f}: fmla :=
  match f with
  | (Fterm e) => (Fterm (msubst_term e x v))
  | (Fand f1 f2) => (Fand (msubst f1 x v) (msubst f2 x v))
  | (Fnot f1) => (Fnot (msubst f1 x v))
  | (Fimplies f1 f2) => (Fimplies (msubst f1 x v) (msubst f2 x v))
  | (Flet y t f1) => (Flet y (msubst_term t x v) (msubst f1 x v))
  | (Fforall y ty f1) => (Fforall y ty (msubst f1 x v))
  end.
Unset Implicit Arguments.

Axiom subst_fresh : forall (f:fmla) (x:ident) (v:ident), (fresh_in_fmla x
  f) -> ((subst f x v) = f).

Axiom let_subst : forall (t:term) (f:fmla) (x:ident) (id':ident) (id:mident),
  ((msubst (Flet x t f) id id') = (Flet x (msubst_term t id id') (msubst f id
  id'))).

Axiom eval_msubst : forall (f:fmla) (sigma:(map mident value)) (pi:(list
  (ident* value)%type)) (x:mident) (v:ident), (fresh_in_fmla v f) ->
  ((eval_fmla sigma pi (msubst f x v)) <-> (eval_fmla (set sigma x
  (get_stack v pi)) pi f)).

Axiom eval_subst : forall (f:fmla) (sigma:(map mident value)) (pi:(list
  (ident* value)%type)) (x:ident) (v:ident), (fresh_in_fmla v f) ->
  ((eval_fmla sigma pi (subst f x v)) <-> (eval_fmla sigma (Cons (x,
  (get_stack v pi)) pi) f)).

Axiom eval_swap : forall (f:fmla) (sigma:(map mident value)) (pi:(list
  (ident* value)%type)) (id1:ident) (id2:ident) (v1:value) (v2:value),
  (~ (id1 = id2)) -> ((eval_fmla sigma (Cons (id1, v1) (Cons (id2, v2) pi))
  f) <-> (eval_fmla sigma (Cons (id2, v2) (Cons (id1, v1) pi)) f)).

Axiom eval_change_free : forall (f:fmla) (sigma:(map mident value)) (pi:(list
  (ident* value)%type)) (id:ident) (v:value), (fresh_in_fmla id f) ->
  ((eval_fmla sigma (Cons (id, v) pi) f) <-> (eval_fmla sigma pi f)).

(* Why3 assumption *)
Definition valid_fmla(p:fmla): Prop := forall (sigma:(map mident value))
  (pi:(list (ident* value)%type)), (eval_fmla sigma pi p).

Axiom let_equiv : forall (id:ident) (id':ident) (t:term) (f:fmla),
  forall (sigma:(map mident value)) (pi:(list (ident* value)%type)),
  (fresh_in_fmla id' f) -> ((eval_fmla sigma pi (Flet id' t (subst f id
  id'))) -> (eval_fmla sigma pi (Flet id t f))).

Axiom let_equiv2 : forall (id:ident) (id':ident) (t:term) (f:fmla),
  forall (sigma:(map mident value)) (pi:(list (ident* value)%type)),
  (fresh_in_fmla id' f) -> ((eval_fmla sigma pi (Flet id' t (subst f id
  id'))) -> (eval_fmla sigma pi (Flet id t f))).

Axiom let_implies : forall (id:ident) (t:term) (p:fmla) (q:fmla),
  (valid_fmla (Fimplies p q)) -> (valid_fmla (Fimplies (Flet id t p) (Flet id
  t q))).

(* Why3 assumption *)
Set Implicit Arguments.
Fixpoint fresh_in_expr(id:ident) (e:expr) {struct e}: Prop :=
  match e with
  | (Evalue _) => True
  | ((Eseq e1 e2)|(Ebin e1 _ e2)) => (fresh_in_expr id e1) /\
      (fresh_in_expr id e2)
  | (Evar v) => ~ (id = v)
  | (Ederef _) => True
  | (Eassign _ e1) => (fresh_in_expr id e1)
  | (Elet v e1 e2) => (~ (id = v)) /\ ((fresh_in_expr id e1) /\
      (fresh_in_expr id e2))
  | (Eif e1 e2 e3) => (fresh_in_expr id e1) /\ ((fresh_in_expr id e2) /\
      (fresh_in_expr id e3))
  | (Eassert f) => (fresh_in_fmla id f)
  | (Ewhile cond inv body) => (fresh_in_expr id cond) /\ ((fresh_in_fmla id
      inv) /\ (fresh_in_expr id body))
  end.
Unset Implicit Arguments.

(* Why3 assumption *)
Inductive one_step : (map mident value) -> (list (ident* value)%type) -> expr
  -> (map mident value) -> (list (ident* value)%type) -> expr -> Prop :=
  | one_step_var : forall (sigma:(map mident value)) (pi:(list (ident*
      value)%type)) (v:ident), (one_step sigma pi (Evar v) sigma pi
      (Evalue (get_stack v pi)))
  | one_step_deref : forall (sigma:(map mident value)) (pi:(list (ident*
      value)%type)) (v:mident), (one_step sigma pi (Ederef v) sigma pi
      (Evalue (get sigma v)))
  | one_step_bin_ctxt1 : forall (sigma:(map mident value)) (sigma':(map
      mident value)) (pi:(list (ident* value)%type)) (pi':(list (ident*
      value)%type)) (op:operator) (e1:expr) (e1':expr) (e2:expr),
      (one_step sigma pi e1 sigma' pi' e1') -> (one_step sigma pi (Ebin e1 op
      e2) sigma' pi' (Ebin e1' op e2))
  | one_step_bin_ctxt2 : forall (sigma:(map mident value)) (sigma':(map
      mident value)) (pi:(list (ident* value)%type)) (pi':(list (ident*
      value)%type)) (op:operator) (v1:value) (e2:expr) (e2':expr),
      (one_step sigma pi e2 sigma' pi' e2') -> (one_step sigma pi
      (Ebin (Evalue v1) op e2) sigma' pi' (Ebin (Evalue v1) op e2'))
  | one_step_bin_value : forall (sigma:(map mident value)) (sigma':(map
      mident value)) (pi:(list (ident* value)%type)) (pi':(list (ident*
      value)%type)) (op:operator) (v1:value) (v2:value), (one_step sigma pi
      (Ebin (Evalue v1) op (Evalue v2)) sigma' pi' (Evalue (eval_bin v1 op
      v2)))
  | one_step_assign_ctxt : forall (sigma:(map mident value)) (sigma':(map
      mident value)) (pi:(list (ident* value)%type)) (pi':(list (ident*
      value)%type)) (x:mident) (e:expr) (e':expr), (one_step sigma pi e
      sigma' pi' e') -> (one_step sigma pi (Eassign x e) sigma' pi'
      (Eassign x e'))
  | one_step_assign_value : forall (sigma:(map mident value)) (pi:(list
      (ident* value)%type)) (x:mident) (v:value), (one_step sigma pi
      (Eassign x (Evalue v)) (set sigma x v) pi (Evalue Vvoid))
  | one_step_seq_ctxt : forall (sigma:(map mident value)) (sigma':(map mident
      value)) (pi:(list (ident* value)%type)) (pi':(list (ident*
      value)%type)) (e1:expr) (e1':expr) (e2:expr), (one_step sigma pi e1
      sigma' pi' e1') -> (one_step sigma pi (Eseq e1 e2) sigma' pi' (Eseq e1'
      e2))
  | one_step_seq_value : forall (sigma:(map mident value)) (pi:(list (ident*
      value)%type)) (e:expr), (one_step sigma pi (Eseq (Evalue Vvoid) e)
      sigma pi e)
  | one_step_let_ctxt : forall (sigma:(map mident value)) (sigma':(map mident
      value)) (pi:(list (ident* value)%type)) (pi':(list (ident*
      value)%type)) (id:ident) (e1:expr) (e1':expr) (e2:expr),
      (one_step sigma pi e1 sigma' pi' e1') -> (one_step sigma pi (Elet id e1
      e2) sigma' pi' (Elet id e1' e2))
  | one_step_let_value : forall (sigma:(map mident value)) (pi:(list (ident*
      value)%type)) (id:ident) (v:value) (e:expr), (one_step sigma pi
      (Elet id (Evalue v) e) sigma (Cons (id, v) pi) e)
  | one_step_if_ctxt : forall (sigma:(map mident value)) (sigma':(map mident
      value)) (pi:(list (ident* value)%type)) (pi':(list (ident*
      value)%type)) (e1:expr) (e1':expr) (e2:expr) (e3:expr), (one_step sigma
      pi e1 sigma' pi' e1') -> (one_step sigma pi (Eif e1 e2 e3) sigma' pi'
      (Eif e1' e2 e3))
  | one_step_if_true : forall (sigma:(map mident value)) (pi:(list (ident*
      value)%type)) (e1:expr) (e2:expr), (one_step sigma pi
      (Eif (Evalue (Vbool true)) e1 e2) sigma pi e1)
  | one_step_if_false : forall (sigma:(map mident value)) (pi:(list (ident*
      value)%type)) (e1:expr) (e2:expr), (one_step sigma pi
      (Eif (Evalue (Vbool false)) e1 e2) sigma pi e2)
  | one_step_assert : forall (sigma:(map mident value)) (pi:(list (ident*
      value)%type)) (f:fmla), (eval_fmla sigma pi f) -> (one_step sigma pi
      (Eassert f) sigma pi (Evalue Vvoid))
  | one_step_while : forall (sigma:(map mident value)) (pi:(list (ident*
      value)%type)) (cond:expr) (inv:fmla) (body:expr), (eval_fmla sigma pi
      inv) -> (one_step sigma pi (Ewhile cond inv body) sigma pi (Eif cond
      (Eseq body (Ewhile cond inv body)) (Evalue Vvoid))).

(* Why3 assumption *)
Inductive many_steps : (map mident value) -> (list (ident* value)%type)
  -> expr -> (map mident value) -> (list (ident* value)%type) -> expr
  -> Z -> Prop :=
  | many_steps_refl : forall (sigma:(map mident value)) (pi:(list (ident*
      value)%type)) (e:expr), (many_steps sigma pi e sigma pi e 0%Z)
  | many_steps_trans : forall (sigma1:(map mident value)) (sigma2:(map mident
      value)) (sigma3:(map mident value)) (pi1:(list (ident* value)%type))
      (pi2:(list (ident* value)%type)) (pi3:(list (ident* value)%type))
      (e1:expr) (e2:expr) (e3:expr) (n:Z), (one_step sigma1 pi1 e1 sigma2 pi2
      e2) -> ((many_steps sigma2 pi2 e2 sigma3 pi3 e3 n) ->
      (many_steps sigma1 pi1 e1 sigma3 pi3 e3 (n + 1%Z)%Z)).

Axiom steps_non_neg : forall (sigma1:(map mident value)) (sigma2:(map mident
  value)) (pi1:(list (ident* value)%type)) (pi2:(list (ident* value)%type))
  (e1:expr) (e2:expr) (n:Z), (many_steps sigma1 pi1 e1 sigma2 pi2 e2 n) ->
  (0%Z <= n)%Z.

Axiom many_steps_seq : forall (sigma1:(map mident value)) (sigma3:(map mident
  value)) (pi1:(list (ident* value)%type)) (pi3:(list (ident* value)%type))
  (e1:expr) (e2:expr) (n:Z), (many_steps sigma1 pi1 (Eseq e1 e2) sigma3 pi3
  (Evalue Vvoid) n) -> exists sigma2:(map mident value), exists pi2:(list
  (ident* value)%type), exists n1:Z, exists n2:Z, (many_steps sigma1 pi1 e1
  sigma2 pi2 (Evalue Vvoid) n1) /\ ((many_steps sigma2 pi2 e2 sigma3 pi3
  (Evalue Vvoid) n2) /\ (n = ((1%Z + n1)%Z + n2)%Z)).

Axiom many_steps_let : forall (sigma1:(map mident value)) (sigma3:(map mident
  value)) (pi1:(list (ident* value)%type)) (pi3:(list (ident* value)%type))
  (id:ident) (e1:expr) (e2:expr) (v2:value) (n:Z), (many_steps sigma1 pi1
  (Elet id e1 e2) sigma3 pi3 (Evalue v2) n) -> exists sigma2:(map mident
  value), exists pi2:(list (ident* value)%type), exists v1:value,
  exists n1:Z, exists n2:Z, (many_steps sigma1 pi1 e1 sigma2 pi2 (Evalue v1)
  n1) /\ ((many_steps sigma2 (Cons (id, v1) pi2) e2 sigma3 pi3 (Evalue v2)
  n2) /\ (n = ((1%Z + n1)%Z + n2)%Z)).

Axiom one_step_change_free : forall (e:expr) (e':expr) (sigma:(map mident
  value)) (sigma':(map mident value)) (pi:(list (ident* value)%type))
  (pi':(list (ident* value)%type)) (id:ident) (v:value), (fresh_in_expr id
  e) -> ((one_step sigma (Cons (id, v) pi) e sigma' pi' e') ->
  (one_step sigma pi e sigma' pi' e')).

(* Why3 assumption *)
Definition valid_triple(p:fmla) (e:expr) (q:fmla): Prop := forall (sigma:(map
  mident value)) (pi:(list (ident* value)%type)), (eval_fmla sigma pi p) ->
  forall (sigma':(map mident value)) (pi':(list (ident* value)%type))
  (v:value) (n:Z), (many_steps sigma pi e sigma' pi' (Evalue v) n) ->
  (eval_fmla sigma' (Cons (result, v) pi') q).

(* Why3 assumption *)
Definition total_valid_triple(p:fmla) (e:expr) (q:fmla): Prop :=
  forall (sigma:(map mident value)) (pi:(list (ident* value)%type)),
  (eval_fmla sigma pi p) -> exists sigma':(map mident value),
  exists pi':(list (ident* value)%type), exists v:value, exists n:Z,
  (many_steps sigma pi e sigma' pi' (Evalue v) n) /\ (eval_fmla sigma'
  (Cons (result, v) pi') q).

Parameter set1 : forall (a:Type), Type.

Parameter mem: forall (a:Type), a -> (set1 a) -> Prop.
Implicit Arguments mem.

(* Why3 assumption *)
Definition infix_eqeq (a:Type)(s1:(set1 a)) (s2:(set1 a)): Prop :=
  forall (x:a), (mem x s1) <-> (mem x s2).
Implicit Arguments infix_eqeq.

Axiom extensionality : forall (a:Type), forall (s1:(set1 a)) (s2:(set1 a)),
  (infix_eqeq s1 s2) -> (s1 = s2).

(* Why3 assumption *)
Definition subset (a:Type)(s1:(set1 a)) (s2:(set1 a)): Prop := forall (x:a),
  (mem x s1) -> (mem x s2).
Implicit Arguments subset.

Axiom subset_trans : forall (a:Type), forall (s1:(set1 a)) (s2:(set1 a))
  (s3:(set1 a)), (subset s1 s2) -> ((subset s2 s3) -> (subset s1 s3)).

Parameter empty: forall (a:Type), (set1 a).
Set Contextual Implicit.
Implicit Arguments empty.
Unset Contextual Implicit.

(* Why3 assumption *)
Definition is_empty (a:Type)(s:(set1 a)): Prop := forall (x:a), ~ (mem x s).
Implicit Arguments is_empty.

Axiom empty_def1 : forall (a:Type), (is_empty (empty :(set1 a))).

Parameter add: forall (a:Type), a -> (set1 a) -> (set1 a).
Implicit Arguments add.

Axiom add_def1 : forall (a:Type), forall (x:a) (y:a), forall (s:(set1 a)),
  (mem x (add y s)) <-> ((x = y) \/ (mem x s)).

Parameter remove: forall (a:Type), a -> (set1 a) -> (set1 a).
Implicit Arguments remove.

Axiom remove_def1 : forall (a:Type), forall (x:a) (y:a) (s:(set1 a)), (mem x
  (remove y s)) <-> ((~ (x = y)) /\ (mem x s)).

Axiom subset_remove : forall (a:Type), forall (x:a) (s:(set1 a)),
  (subset (remove x s) s).

Parameter union: forall (a:Type), (set1 a) -> (set1 a) -> (set1 a).
Implicit Arguments union.

Axiom union_def1 : forall (a:Type), forall (s1:(set1 a)) (s2:(set1 a)) (x:a),
  (mem x (union s1 s2)) <-> ((mem x s1) \/ (mem x s2)).

Parameter inter: forall (a:Type), (set1 a) -> (set1 a) -> (set1 a).
Implicit Arguments inter.

Axiom inter_def1 : forall (a:Type), forall (s1:(set1 a)) (s2:(set1 a)) (x:a),
  (mem x (inter s1 s2)) <-> ((mem x s1) /\ (mem x s2)).

Parameter diff: forall (a:Type), (set1 a) -> (set1 a) -> (set1 a).
Implicit Arguments diff.

Axiom diff_def1 : forall (a:Type), forall (s1:(set1 a)) (s2:(set1 a)) (x:a),
  (mem x (diff s1 s2)) <-> ((mem x s1) /\ ~ (mem x s2)).

Axiom subset_diff : forall (a:Type), forall (s1:(set1 a)) (s2:(set1 a)),
  (subset (diff s1 s2) s1).

Parameter choose: forall (a:Type), (set1 a) -> a.
Implicit Arguments choose.

Axiom choose_def : forall (a:Type), forall (s:(set1 a)), (~ (is_empty s)) ->
  (mem (choose s) s).

Parameter all: forall (a:Type), (set1 a).
Set Contextual Implicit.
Implicit Arguments all.
Unset Contextual Implicit.

Axiom all_def : forall (a:Type), forall (x:a), (mem x (all :(set1 a))).

(* Why3 assumption *)
Definition assigns(sigma:(map mident value)) (a:(set1 mident)) (sigma':(map
  mident value)): Prop := forall (i:mident), (~ (mem i a)) -> ((get sigma
  i) = (get sigma' i)).

Axiom assigns_refl : forall (sigma:(map mident value)) (a:(set1 mident)),
  (assigns sigma a sigma).

Axiom assigns_trans : forall (sigma1:(map mident value)) (sigma2:(map mident
  value)) (sigma3:(map mident value)) (a:(set1 mident)), ((assigns sigma1 a
  sigma2) /\ (assigns sigma2 a sigma3)) -> (assigns sigma1 a sigma3).

Axiom assigns_union_left : forall (sigma:(map mident value)) (sigma':(map
  mident value)) (s1:(set1 mident)) (s2:(set1 mident)), (assigns sigma s1
  sigma') -> (assigns sigma (union s1 s2) sigma').

Axiom assigns_union_right : forall (sigma:(map mident value)) (sigma':(map
  mident value)) (s1:(set1 mident)) (s2:(set1 mident)), (assigns sigma s2
  sigma') -> (assigns sigma (union s1 s2) sigma').

(* Why3 assumption *)
Set Implicit Arguments.
Fixpoint expr_writes(e:expr) (w:(set1 mident)) {struct e}: Prop :=
  match e with
  | ((Evalue _)|((Evar _)|((Ederef _)|(Eassert _)))) => True
  | (Ebin e1 _ e2) => (expr_writes e1 w) /\ (expr_writes e2 w)
  | (Eassign id _) => (mem id w)
  | (Eseq e1 e2) => (expr_writes e1 w) /\ (expr_writes e2 w)
  | (Elet id e1 e2) => (expr_writes e1 w) /\ (expr_writes e2 w)
  | (Eif e1 e2 e3) => (expr_writes e1 w) /\ ((expr_writes e2 w) /\
      (expr_writes e3 w))
  | (Ewhile cond _ body) => (expr_writes cond w) /\ (expr_writes body w)
  end.
Unset Implicit Arguments.

Parameter fresh_from: fmla -> expr -> ident.

Axiom fresh_from_fmla : forall (e:expr) (f:fmla),
  (fresh_in_fmla (fresh_from f e) f).

Axiom fresh_from_expr : forall (e:expr) (f:fmla),
  (fresh_in_expr (fresh_from f e) e).

Parameter abstract_effects: expr -> fmla -> fmla.

(* Why3 assumption *)
Set Implicit Arguments.
Fixpoint wp(e:expr) (q:fmla) {struct e}: fmla :=
  match e with
  | (Evalue v) => (Flet result (Tvalue v) q)
  | (Evar v) => (Flet result (Tvar v) q)
  | (Ederef x) => (Flet result (Tderef x) q)
  | (Eassert f) => (Fand f (Fimplies f q))
  | (Eseq e1 e2) => (wp e1 (wp e2 q))
  | (Elet id e1 e2) => (wp e1 (Flet id (Tvar result) (wp e2 q)))
  | (Ebin e1 op e2) => let t1 := (fresh_from q e) in let t2 :=
      (fresh_from (Fand (Fterm (Tvar t1)) q) e) in let q' := (Flet result
      (Tbin (Tvar t1) op (Tvar t2)) q) in let f := (wp e2 (Flet t2
      (Tvar result) q')) in (wp e1 (Flet t1 (Tvar result) f))
  | (Eassign x e1) => let id := (fresh_from q e1) in let q' := (Flet result
      (Tvalue Vvoid) q) in (wp e1 (Flet id (Tvar result) (msubst q' x id)))
  | (Eif e1 e2 e3) => let f := (Fand (Fimplies (Fterm (Tvar result)) (wp e2
      q)) (Fimplies (Fnot (Fterm (Tvar result))) (wp e3 q))) in (wp e1 f)
  | (Ewhile cond inv body) => (Fand inv (abstract_effects body (wp cond
      (Fand (Fimplies (Fand (Fterm (Tvar result)) inv) (wp body inv))
      (Fimplies (Fand (Fnot (Fterm (Tvar result))) inv) q)))))
  end.
Unset Implicit Arguments.

Axiom distrib_conj : forall (sigma:(map mident value)) (pi:(list (ident*
  value)%type)) (e:expr) (p:fmla) (q:fmla), (eval_fmla sigma pi (wp e (Fand p
  q))) <-> ((eval_fmla sigma pi (wp e p)) /\ (eval_fmla sigma pi (wp e q))).

Axiom monotonicity : forall (e:expr) (p:fmla) (q:fmla),
  (valid_fmla (Fimplies p q)) -> (valid_fmla (Fimplies (wp e p) (wp e q))).

Axiom wp_reduction : forall (sigma:(map mident value)) (sigma':(map mident
  value)) (pi:(list (ident* value)%type)) (pi':(list (ident* value)%type))
  (e:expr) (e':expr), (one_step sigma pi e sigma' pi' e') -> forall (q:fmla),
  (eval_fmla sigma pi (wp e q)) -> (eval_fmla sigma' pi' (wp e' q)).

(* Why3 assumption *)
Definition is_value(e:expr): Prop :=
  match e with
  | (Evalue _) => True
  | _ => False
  end.

Axiom decide_value : forall (e:expr), (~ (is_value e)) \/ exists v:value,
  (e = (Evalue v)).

Axiom bool_value : forall (v:value) (sigmat:(map mident datatype)) (pit:(list
  (ident* datatype)%type)), (type_expr sigmat pit (Evalue v) TYbool) ->
  ((v = (Vbool false)) \/ (v = (Vbool true))).

Axiom unit_value : forall (v:value) (sigmat:(map mident datatype)) (pit:(list
  (ident* datatype)%type)), (type_expr sigmat pit (Evalue v) TYunit) ->
  (v = Vvoid).

(* Why3 goal *)
Theorem progress : forall (e:expr) (sigma:(map mident value)) (pi:(list
  (ident* value)%type)) (sigmat:(map mident datatype)) (pit:(list (ident*
  datatype)%type)) (ty:datatype) (q:fmla), (type_expr sigmat pit e ty) ->
  ((type_fmla sigmat (Cons (result, ty) pit) q) -> ((eval_fmla sigma pi (wp e
  q)) -> ((~ (is_value e)) -> exists sigma':(map mident value),
  exists pi':(list (ident* value)%type), exists e':expr, (one_step sigma pi e
  sigma' pi' e')))).
induction e.
simpl; tauto.
(* case 1: e = bin e1 op e2 *)
(* case 1.1: e1 not a value *)
destruct (decide_value e1).
intros sigma pi typ_sigma typ_pi ty q h1 h2 h3 _.
inversion h1; subst; clear h1.
simpl in h3.
pose (q' := (Flet (fresh_from q (Ebin e1 o e2)) (Tvar result)
             (wp e2
                (Flet
                   (fresh_from
                      (Fand (Fterm (Tvar (fresh_from q (Ebin e1 o e2)))) q)
                      (Ebin e1 o e2)) (Tvar result)
                   (Flet result
                      (Tbin (Tvar (fresh_from q (Ebin e1 o e2))) o
                         (Tvar
                            (fresh_from
                               (Fand
                                  (Fterm (Tvar (fresh_from q (Ebin e1 o e2))))
                                  q) (Ebin e1 o e2)))) q))))).
fold q' in h3.
generalize (IHe1 sigma pi _ _ _ q' H5).
intros h4; clear IHe1 IHe2.
assert (h: type_fmla typ_sigma (Cons (result, ty1) typ_pi) q').
eapply Type_let.
constructor; auto.
admit.
admit.
(*generalize (h4 h h3 H); clear h4.
intro h4.
destruct h4 as (sigma' & pi' & e' & h5 ).
exists sigma'.
exists pi'.
exists (Ebin e' o e2).
apply one_step_bin_ctxt1; auto.*)

(* case 1.2: e1 is a value *)
elim H; clear H; intros v He1_v.
subst e1.
(* case 1.2.1: e2 not a value *)
destruct (decide_value e2).
intros sigma pi typ_sigma typ_pi type q h1 h2 h3 _.
(*generalize (IHe2 _ _ _ (conj h1 H)).
intros (sigma' & pi' & e' & h).
exists sigma'.
eexists.
exists (Ebin (Evalue v) o e').
apply one_step_bin_ctxt2.
assert (Hfresh : fresh_in_expr 
   (fresh_from q (Ebin (Evalue v) o e2)) e2).
  assert (Hf : fresh_in_expr 
   (fresh_from q (Ebin (Evalue v) o e2)) (Ebin (Evalue v) o e2)).
  apply fresh_from_expr.
  simpl in Hf; tauto.
generalize (one_step_change_free _ _ _ _ _ _ _ _ Hfresh h).
apply one_step_change_free.*)
admit. (* typage *)
(* case 1.2.2: e2 is a value *)
elim H; clear H; intros v2 He2_v.
subst e2.
intros sigma pi typ_sigma typ_pi type q h1 h2 h3 h4.
exists sigma.
exists pi.
exists (Evalue (eval_bin v o v2)).
apply one_step_bin_value.

(* case 2 : e = var *)
intros sigma pi typ_sigma typ_pi type q h1 h2 h3 h4.
eexists.
eexists.
eexists.
apply one_step_var.

(* case 3 : e = deref *)
intros sigma pi typ_sigma typ_pi type q h1 h2 h3 h4.
eexists.
eexists.
eexists.
apply one_step_deref.

(* case 4 : e = assign x e' *)
(* case 4.1: e' not a value *)
destruct (decide_value e).
intros sigma pi typ_sigma typ_pi type q h1 h2 h3 h4.
inversion h1; subst.
(*
generalize (IHe sigma pi _ _ _ _ H6  h3 H).

simpl in h3.
pose (q' := (Flet (fresh_from q e) (Tvar result)
             (Flet result (msubst_term (Tvalue Vvoid) m (fresh_from q e))
                (msubst q m (fresh_from q e))))).
fold q' in h3.

intro; clear IHe.

intros (sigma' & pi' & e' & h).
exists sigma'.
exists pi'.
exists (Eassign i e').
apply one_step_assign_ctxt; auto.*)
admit.
(* case 4.2: e' is a value *)
elim H; clear H; intros v He_v.
subst e.
intros sigma pi q h2 h3.
eexists.
exists pi.
eexists.
eapply one_step_assign_value.

(* case 5: e = e1; e2 *)
destruct (decide_value e1).
(* case 5.1: e1 not a value *)
(*intros sigma pi q (h1 & _).
generalize (IHe1 _ _ _ (conj h1 H)).
intros (sigma' & pi' & e' & h).
exists sigma'.
exists pi'.
exists (Eseq e' e2).
eapply one_step_seq_ctxt; auto.*)
admit.
(* case 5.2: e1 is a value *)
elim H; clear H; intros v He_v.
subst e1.
clear IHe1 IHe2.
intros sigma pi sigmat pit ty q h1 _ _ _.
inversion h1; subst.
assert (v = Vvoid).
apply unit_value with sigmat pit; auto.
subst.
eexists.
exists pi.
eexists.
eapply one_step_seq_value.

(* case 6: e = let i = e1 in e2 *)
destruct (decide_value e1).
(* case 6.1: e1 not a value *)
intros sigma pi sigmat pit ty q h1 h2 h3 h4.
(*generalize (IHe1 _ _ _(conj h1 H)).
intros (sigma' & pi' & e' & h).
exists sigma'.
exists pi'.
exists (Elet i e' e2).
eapply one_step_let_ctxt; auto.*)
admit.

(* case 6.2: e1 is a value *)
elim H; clear H; intros v He_v.
subst e1.
intros sigma pi _ _ _ _ _ _ _ _.
eexists.
eexists.
eexists.
eapply one_step_let_value.

(* case 7: e = if e1 then e2 else e3 *)
destruct (decide_value e1).
(* case 7.1: e1 not a value *)
clear IHe2 IHe3.
intros sigma pi sigmat pit ty q h1 h2 h3 h4.
inversion h1; subst.
simpl in h3.
pose (q' := Fand (Fimplies (Fterm (Tvar result)) (wp e2 q))
             (Fimplies (Fnot (Fterm (Tvar result))) (wp e3 q))).
fold q' in h3.
generalize (IHe1 sigma pi _ _ _ q' H5); clear IHe1.
intros (h5, h6); auto.
(*
generalize (H0 h2 _ H).
exists sigma'.
exists pi'.
exists (Eif e' e2 e3).
eapply one_step_if_ctxt; auto.*)
admit.
admit.
(* case 7.2: e1 is a value *)
elim H; clear H; intros v He_v.
subst.
intros sigma pi sigmat pit ty q h1 h2 h3 h4.
eexists sigma.
exists pi.
inversion h1; subst.
assert (h: v = Vbool false \/ v = Vbool true).
eapply bool_value with sigmat pit; auto.
destruct h; subst; eexists.
(* v = false *)
apply one_step_if_false.
(* v = true *)
apply one_step_if_true.

(* case 8 : e = assert f *)
intros sigma pi _ _  ty q _ _ h3 _.
simpl in h3.
destruct h3.
eexists.
eexists.
eexists.
apply one_step_assert; auto.

(* case 9: e = while cond inv body *)
intros sigma pi sigmat pit ty q _ _ h1 _.
simpl in h1.
destruct h1.
eexists.
eexists.
eexists.
eapply one_step_while; auto.

Qed.


