(********************************************************************)
(*                                                                  *)
(*  The Why3 Verification Platform   /   The Why3 Development Team  *)
(*  Copyright 2010-2012   --   INRIA - CNRS - Paris-Sud University  *)
(*                                                                  *)
(*  This software is distributed under the terms of the GNU Lesser  *)
(*  General Public License version 2.1, with the special exception  *)
(*  on linking described in file LICENSE.                           *)
(*                                                                  *)
(********************************************************************)



let help = "Checks ACSL contracts using Why3"

let global_logic_decls_theory_name = "Global logic declarations"

let programs_module_name = "C Functions"



module Self =
  Plugin.Register
    (struct
       let name = "Jessie3"
       let shortname = "jessie3"
       let help = help
     end)


module Options = struct

end

module Enabled =
  Self.False
    (struct
       let option_name = "-jessie3"
       let help = help
     end)

open Cil_types
open Why3




(***************)
(* environment *)
(***************)

let env,config =
  try
    (* reads the Why3 config file *)
    let config : Whyconf.config = Whyconf.read_config None in
    (* the [main] section of the config file *)
    let main : Whyconf.main = Whyconf.get_main config in
    let env : Env.env = Env.create_env (Whyconf.loadpath main) in
    env,config
  with e ->
    Self.fatal "Exception raised in Why3 env:@ %a" Exn_printer.exn_printer e

let find th s = Theory.ns_find_ls th.Theory.th_export [s]

(* int.Int theory *)
let int_type : Ty.ty = Ty.ty_int
let int_theory : Theory.theory = Env.find_theory env ["int"] "Int"
let add_int : Term.lsymbol = find int_theory "infix +"
let sub_int : Term.lsymbol = find int_theory "infix -"
let minus_int : Term.lsymbol = find int_theory "prefix -"
let mul_int : Term.lsymbol = find int_theory "infix *"
let ge_int : Term.lsymbol = find int_theory "infix >="
let le_int : Term.lsymbol = find int_theory "infix <="
let gt_int : Term.lsymbol = find int_theory "infix >"
let lt_int : Term.lsymbol = find int_theory "infix <"

(* real.Real theory *)
let real_type : Ty.ty = Ty.ty_real
let real_theory : Theory.theory = Env.find_theory env ["real"] "Real"
let add_real : Term.lsymbol = find real_theory "infix +"
let sub_real : Term.lsymbol = find real_theory "infix -"
let minus_real : Term.lsymbol = find real_theory "prefix -"
let mul_real : Term.lsymbol = find real_theory "infix *"
let ge_real : Term.lsymbol = find real_theory "infix >="


(* ref.Ref module *)

let ref_modules, ref_theories =
  Env.read_lib_file (Mlw_main.library_of_env env) ["ref"]

let ref_module : Mlw_module.modul = Stdlib.Mstr.find "Ref" ref_modules

let ref_type : Mlw_ty.T.itysymbol =
  match
    Mlw_module.ns_find_ts ref_module.Mlw_module.mod_export ["ref"]
  with
    | Mlw_module.PT itys -> itys
    | Mlw_module.TS _ -> assert false

let ref_fun : Mlw_expr.psymbol =
  match
    Mlw_module.ns_find_ps ref_module.Mlw_module.mod_export ["ref"]
  with
    | Mlw_module.PS p -> p
    | _ -> assert false

let get_logic_fun : Term.lsymbol =
  find ref_module.Mlw_module.mod_theory "prefix !"

let get_fun : Mlw_expr.psymbol =
  match
    Mlw_module.ns_find_ps ref_module.Mlw_module.mod_export ["prefix !"]
  with
    | Mlw_module.PS p -> p
    | _ -> assert false

let set_fun : Mlw_expr.psymbol =
  match
    Mlw_module.ns_find_ps ref_module.Mlw_module.mod_export ["infix :="]
  with
    | Mlw_module.PS p -> p
    | _ -> assert false


(*********)
(* types *)
(*********)

let unit_type = Ty.ty_tuple []

let ctype ty =
  match ty with
    | TVoid _attr -> Mlw_ty.ity_unit
    | TInt (_, _) -> Mlw_ty.ity_pur Ty.ts_int []
    | TFloat (_, _)
    | TPtr (_, _)
    | TArray (_, _, _, _)
    | TFun (_, _, _, _)
    | TNamed (_, _)
    | TComp (_, _, _)
    | TEnum (_, _)
    | TBuiltin_va_list _
    -> Self.not_yet_implemented "ctype"

let logic_types = Hashtbl.create 257

let type_vars = ref []

let find_type_var v =
  try
    List.assoc v !type_vars
  with Not_found -> Self.fatal "type variable %s not found" v

let push_type_var v =
  let tv = Ty.create_tvsymbol (Ident.id_fresh v) in
  type_vars := (v,tv) :: !type_vars

let pop_type_var v =
  match !type_vars with
    | (w,_) :: r ->
      if v=w then type_vars := r
      else Self.fatal "pop_type_var: %s expected,found %s" v w
    | [] -> Self.fatal "pop_type_var: empty"

let rec logic_type ty =
  match ty with
    | Linteger -> int_type
    | Lreal -> real_type
    | Ltype (lt, args) ->
      begin
        try
          let ts = Hashtbl.find logic_types lt.lt_name in
          Ty.ty_app ts (List.map logic_type args)
        with
            Not_found -> Self.fatal "logic type %s not found" lt.lt_name
      end
    | Lvar v -> Ty.ty_var (find_type_var v)
    | Ctype _
    | Larrow (_, _) ->
        Self.not_yet_implemented "logic_type"



let any _ty =
  Mlw_expr.e_const (Number.ConstInt (Number.int_const_dec "0"))


let mk_ref ty =
    let pv =
      Mlw_ty.create_pvsymbol (Ident.id_fresh "a") (Mlw_ty.vty_value ty)
    in
    let ity = Mlw_ty.ity_app_fresh ref_type [ty] in
    let vta = Mlw_ty.vty_arrow [pv] (Mlw_ty.VTvalue (Mlw_ty.vty_value ity)) in
    Mlw_expr.e_arrow ref_fun vta

let mk_get ref_ty ty =
    let pv = Mlw_ty.create_pvsymbol (Ident.id_fresh "r") ref_ty in
    let vta = Mlw_ty.vty_arrow [pv] (Mlw_ty.VTvalue (Mlw_ty.vty_value ty)) in
    Mlw_expr.e_arrow get_fun vta

let mk_set ref_ty ty =
    (* (:=) has type (r:ref 'a) (v:'a) unit *)
    let pv1 = Mlw_ty.create_pvsymbol (Ident.id_fresh "r") ref_ty in
    let pv2 =
      Mlw_ty.create_pvsymbol (Ident.id_fresh "v") (Mlw_ty.vty_value ty)
    in
    let vta =
      Mlw_ty.vty_arrow [pv1;pv2]
        (Mlw_ty.VTvalue (Mlw_ty.vty_value Mlw_ty.ity_unit))
    in
    Mlw_expr.e_arrow set_fun vta





(*********)
(* terms *)
(*********)

let logic_constant c =
  match c with
    | Integer(_value,Some s) ->
      let c = Literals.integer s in Number.ConstInt c
    | Integer(_value,None) ->
      Self.not_yet_implemented "logic_constant Integer None"
    | LReal(_value,s) ->
      let c = Literals.floating_point s in Number.ConstReal c
    | (LStr _|LWStr _|LChr _|LEnum _) ->
      Self.not_yet_implemented "logic_constant"

let t_app ls args =
  try
    Term.t_app_infer ls args
  with
      Not_found ->
        Self.fatal "lsymbol %s not found" ls.Term.ls_name.Ident.id_string

let bin (ty1,t1) op (ty2,t2) =
  match op,ty1,ty2 with

    | PlusA,Linteger,Linteger -> t_app add_int [t1;t2]
    | PlusA,Lreal,Lreal -> t_app add_real [t1;t2]

    | MinusA,Linteger,Linteger -> t_app sub_int [t1;t2]
    | MinusA,Lreal,Lreal -> t_app sub_real [t1;t2]

    | Mult,Linteger,Linteger -> t_app mul_int [t1;t2]
    | Mult,Lreal,Lreal -> t_app mul_real [t1;t2]

    | PlusA,ty1,ty2 -> Self.not_yet_implemented "bin PlusA(%a,%a)"
      Cil.d_logic_type ty1 Cil.d_logic_type ty2
    | MinusA,_,_ -> Self.not_yet_implemented "bin MinusA"
    | Mult,_,_ -> Self.not_yet_implemented "bin Mult"
    | ((PlusPI|IndexPI|MinusPI|MinusPP|Div|Mod|Shiftlt|Shiftrt|Lt|Gt|
 Le|Ge|Eq|Ne|BAnd|BXor|BOr|LAnd|LOr),_, _)
      -> Self.not_yet_implemented "bin"

let unary op (ty,t) =
  match op,ty with
    | Neg,Linteger -> t_app minus_int [t]
    | Neg,Lreal -> t_app minus_real [t]
    | Neg,_ -> Self.not_yet_implemented "unary Neg,_"
    | BNot,_ -> Self.not_yet_implemented "unary BNot"
    | LNot,_ -> Self.not_yet_implemented "unary LNot"

let bound_vars = Hashtbl.create 257

let create_lvar v =
  let id = Ident.id_fresh v.lv_name in
  let vs = Term.create_vsymbol id (logic_type v.lv_type) in
(*
  Self.result "create logic variable %d" v.lv_id;
*)
  Hashtbl.add bound_vars v.lv_id vs;
  vs

let get_lvar lv =
  try
    Hashtbl.find bound_vars lv.lv_id
  with Not_found ->
    Self.fatal "logic variable %s (%d) not found" lv.lv_name lv.lv_id


let program_vars = Hashtbl.create 257

let create_var v =
  let id = Ident.id_fresh v.vname in
  let ty = ctype v.vtype in
  let def = Mlw_expr.e_app (mk_ref ty) [any ty] in
  let let_defn = Mlw_expr.create_let_defn id def in
  let vs = match let_defn.Mlw_expr.let_sym with
    | Mlw_expr.LetV vs -> vs
    | Mlw_expr.LetA _ -> assert false
  in
(*
  Self.result "create program variable %s (%d)" v.vname v.vid;
*)
  Hashtbl.add program_vars v.vid (vs,true,ty);
  let_defn

let get_var v =
  try
    Hashtbl.find program_vars v.vid
  with Not_found ->
    Self.fatal "program variable %s (%d) not found" v.vname v.vid

let logic_symbols = Hashtbl.create 257

let create_lsymbol li =
  let name = li.l_var_info.lv_name in
  let id = Ident.id_fresh name in
  let args = List.map create_lvar li.l_profile in
  let targs = List.map (fun v -> v.Term.vs_ty) args in
  let ret_ty = Opt.map logic_type li.l_type in
  let vs = Term.create_lsymbol id targs ret_ty in
  Self.result "creating logic symbol %d (%s)" li.l_var_info.lv_id name;
  Hashtbl.add logic_symbols li.l_var_info.lv_id vs;
  vs,args

let get_lsymbol li =
  try
    Hashtbl.find logic_symbols li.l_var_info.lv_id
  with
      Not_found -> Self.fatal "logic symbol %s not found" li.l_var_info.lv_name

let result_vsymbol =
  ref (Term.create_vsymbol (Ident.id_fresh "result") unit_type)

let tlval (host,offset) =
  match host,offset with
    | TResult _, TNoOffset -> Term.t_var !result_vsymbol
    | TVar lv, TNoOffset -> 
      begin
        match lv.lv_origin with
          | None -> Term.t_var (get_lvar lv)
          | Some v -> 
            let (v,is_mutable,_ty) = get_var v in
            if is_mutable then
              t_app get_logic_fun [Term.t_var v.Mlw_ty.pv_vs]
            else
              Term.t_var v.Mlw_ty.pv_vs
      end
    | TVar _, (TField (_, _)|TModel (_, _)|TIndex (_, _)) ->
      Self.not_yet_implemented "tlval TVar"
    | TResult _, _ ->
      Self.not_yet_implemented "tlval Result"
    | TMem _, _ ->
      Self.not_yet_implemented "tlval Mem"

type label = Here | Old | At of string

let rec term_node ~label t =
  match t with
    | TConst cst -> Term.t_const (logic_constant cst)
    | TLval lv -> tlval lv
    | TBinOp (op, t1, t2) -> bin (term ~label t1) op (term ~label t2)
    | TUnOp (op, t) -> unary op (term ~label t)
    | TCastE (_, _) -> Self.not_yet_implemented "term_node TCastE"
    | Tapp (li, labels, args) ->
      begin
        match labels with
          | [] ->
            let ls = get_lsymbol li in
            let args = List.map (fun x -> snd(term ~label x)) args in
            t_app ls args
          | _ ->
            Self.not_yet_implemented "term_node Tapp with labels"
      end
    | Tat (t, lab) ->
      begin
        match lab with
          | LogicLabel(None, "Here") -> snd (term ~label:Here t)
          | LogicLabel(None, "Old") -> snd (term ~label:Old t)
          | LogicLabel(None, lab) -> snd (term ~label:(At lab) t)
          | LogicLabel(Some _, _lab) -> 
            Self.not_yet_implemented "term_node Tat/LogicLabel/Some"
          | StmtLabel _ ->
            Self.not_yet_implemented "term_node Tat/StmtLabel"
      end
    | TSizeOf _
    | TSizeOfE _
    | TSizeOfStr _
    | TAlignOf _
    | TAlignOfE _
    | TAddrOf _
    | TStartOf _
    | Tlambda (_, _)
    | TDataCons (_, _)
    | Tif (_, _, _)
    | Tbase_addr (_, _)
    | Toffset (_, _)
    | Tblock_length (_, _)
    | Tnull
    | TCoerce (_, _)
    | TCoerceE (_, _)
    | TUpdate (_, _, _)
    | Ttypeof _
    | Ttype _
    | Tempty_set
    | Tunion _
    | Tinter _
    | Tcomprehension (_, _, _)
    | Trange (_, _)
    | Tlet (_, _) ->
      Self.not_yet_implemented "term_node"

and term ~label t = (t.term_type, term_node ~label t.term_node)



(****************)
(* propositions *)
(****************)

let rel (ty1,t1) op (ty2,t2) =
  match op,ty1,ty2 with
    | Req,_,_ -> Term.t_equ t1 t2
    | Rneq,_,_ -> Term.t_neq t1 t2
    | Rge,Linteger,Linteger -> t_app ge_int [t1;t2]
    | Rle,Linteger,Linteger -> t_app le_int [t1;t2]
    | Rgt,Linteger,Linteger -> t_app gt_int [t1;t2]
    | Rlt,Linteger,Linteger -> t_app lt_int [t1;t2]
    | Rge,Lreal,Lreal -> t_app ge_real [t1;t2]
    | Rge,_,_ ->
      Self.not_yet_implemented "rel Rge"
    | (Rlt|Rgt|Rle),_,_ ->
      Self.not_yet_implemented "rel"

let rec predicate ~label p =
  match p with
    | Pfalse -> Term.t_false
    | Ptrue -> Term.t_true
    | Prel (op, t1, t2) -> rel (term ~label t1) op (term ~label t2)
    | Pforall (lv, p) ->
      let l = List.map create_lvar lv in
      Term.t_forall_close l [] (predicate_named ~label p)
    | Pimplies (p1, p2) ->
      Term.t_implies (predicate_named ~label p1) (predicate_named ~label p2)
    | Pand (p1, p2) ->
      Term.t_and (predicate_named ~label p1) (predicate_named ~label p2)
    | Papp (_, _, _)
    | Pseparated _
    | Por (_, _)
    | Pxor (_, _)
    | Piff (_, _)
    | Pnot _
    | Pif (_, _, _)
    | Plet (_, _)
    | Pexists (_, _)
    | Pat (_, _)
    | Pvalid_read (_, _)
    | Pvalid (_, _)
    | Pinitialized (_, _)
    | Pallocable (_, _)
    | Pfreeable (_, _)
    | Pfresh (_, _, _, _)
    | Psubtype (_, _) ->
        Self.not_yet_implemented "predicate"

and predicate_named ~label p = predicate ~label p.content






(**********************)
(* logic declarations *)
(**********************)

let use th1 th2 =
  let name = th2.Theory.th_name in
  Theory.close_namespace
    (Theory.use_export (Theory.open_namespace th1 name.Ident.id_string) th2)
    true

let add_decl th d =
  try
    Theory.add_decl th d
  with
      Not_found -> Self.fatal "add_decl"

let add_decls_as_theory theories id decls =
  match decls with
    | [] -> theories
    | _ ->
      let th = Theory.create_theory id in
      let th = use th int_theory in
      let th = use th real_theory in
      let th = List.fold_left use th theories in
      let th = List.fold_left add_decl th (List.rev decls) in
      let th = Theory.close_theory th in
      th :: theories

let rec logic_decl ~in_axiomatic a _loc (theories,decls) =
  match a with
    | Dtype (lt, loc) ->
      let targs =
        List.map (fun s -> Ty.create_tvsymbol (Ident.id_fresh s)) lt.lt_params
      in
      let tdef = match lt.lt_def with
          | None -> None
          | Some _ -> Self.not_yet_implemented "logic_decl Dtype non abstract"
      in
      let ts =
        Ty.create_tysymbol
          (Ident.id_user lt.lt_name (Loc.extract loc)) targs tdef
      in
      Hashtbl.add logic_types lt.lt_name ts;
      let d = Decl.create_ty_decl ts in
      (theories,d::decls)
    | Dfun_or_pred (li, _loc) ->
      begin
        match li.l_labels with
          | [] ->
            List.iter push_type_var li.l_tparams;
            let d =
              match li.l_body with
                | LBnone ->
                  let ls,_ = create_lsymbol li in
                  Decl.create_param_decl ls
                | LBterm d ->
                  let ls,args = create_lsymbol li in
                  let (_ty,d) = term ~label:Here d in
                  let def = Decl.make_ls_defn ls args d in
                  Decl.create_logic_decl [def]
                | _ ->
                  Self.not_yet_implemented "Dfun_or_pred, other bodies"
            in
            List.iter pop_type_var (List.rev li.l_tparams);
            (theories,d :: decls)

          | _ ->
            Self.not_yet_implemented "Dfun_or_pred with labels"
      end
    | Dlemma(name,is_axiom,labels,vars,p,loc) ->
      begin
        match labels,vars with
          | [],[] ->
            assert (in_axiomatic || not is_axiom);
            let d =
              let pr = Decl.create_prsymbol
                (Ident.id_user name (Loc.extract loc))
              in
              Decl.create_prop_decl
                (if is_axiom then Decl.Paxiom else Decl.Plemma)
                pr (predicate_named ~label:Here p)
            in
            (theories,d::decls)
          | _ ->
            Self.not_yet_implemented "Dlemma with labels or vars"
      end
    | Daxiomatic (name, decls', loc) ->
      let theories =
        add_decls_as_theory theories
          (Ident.id_fresh global_logic_decls_theory_name) decls
      in
      let (t,decls'') =
        List.fold_left
          (fun acc d -> logic_decl ~in_axiomatic:true d loc acc)
          ([],[])
          decls'
      in
      assert (t = []);
      let theories =
        add_decls_as_theory theories (Ident.id_user name (Loc.extract loc)) decls''
      in
      (theories,[])
    | Dvolatile (_, _, _, _)
    | Dinvariant (_, _)
    | Dtype_annot (_, _)
    | Dmodel_annot (_, _)
    | Dcustom_annot (_, _, _)
        -> Self.not_yet_implemented "logic_decl"

let identified_proposition p =
  { name = p.ip_name; loc = p.ip_loc; content = p.ip_content }






(**************)
(* statements *)
(**************)



let lval (host,offset) =
  match host,offset with
    | Var v, NoOffset ->
      let v,is_mutable,ty = get_var v in
      if is_mutable then
        begin try
                Mlw_expr.e_app
                  (mk_get v.Mlw_ty.pv_vtv ty)
                  [Mlw_expr.e_value v]
          with e ->
            Self.fatal "Exception raised during application of !@ %a@."
              Exn_printer.exn_printer e
        end
      else
        Mlw_expr.e_value v
    | Var _, (Field (_, _)|Index (_, _)) ->
      Self.not_yet_implemented "lval Var"
    | Mem _, _ ->
      Self.not_yet_implemented "lval Mem"


let seq e1 e2 =
  let l = Mlw_expr.create_let_defn (Ident.id_fresh "_tmp") e1 in
  Mlw_expr.e_let l e2

let annot a e =
  match (Annotations.code_annotation_of_rooted a).annot_content with
  | AAssert ([],pred) ->
    let p = predicate_named ~label:Here pred in
    let a = Mlw_expr.e_assert Mlw_expr.Aassert p in
    seq a e
  | AAssert(_labels,_pred) ->
    Self.not_yet_implemented "annot AAssert"
  | AStmtSpec _ ->
    Self.not_yet_implemented "annot AStmtSpec"
  | AInvariant _ ->
    Self.not_yet_implemented "annot AInvariant"
  | AVariant _ ->
    Self.not_yet_implemented "annot AVariant"
  | AAssigns _ ->
    Self.not_yet_implemented "annot AAssigns"
  | AAllocation _ ->
    Self.not_yet_implemented "annot AAllocation"
  | APragma _ ->
    Self.not_yet_implemented "annot APragma"

let loop_annot a =
  List.fold_left (fun (inv,var) a ->
    match (Annotations.code_annotation_of_rooted a).annot_content with
      | AAssert ([],_pred) ->
        Self.not_yet_implemented "loop_annot AAssert"
      | AAssert(_labels,_pred) ->
        Self.not_yet_implemented "loop_annot AAssert"
      | AStmtSpec _ ->
        Self.not_yet_implemented "loop_annot AStmtSpec"
      | AInvariant([],true,p) ->
        (Term.t_and inv (predicate_named ~label:Here p),var)
      | AInvariant _ ->
        Self.not_yet_implemented "loop_annot AInvariant"
      | AVariant (t, None) ->
        (inv,(snd (term ~label:Here t),None)::var)
      | AVariant (_var, Some _) ->
        Self.not_yet_implemented "loop_annot AVariant/Some"
      | AAssigns _ ->
        Self.not_yet_implemented "loop_annot AAssigns"
      | AAllocation _ ->
        Self.not_yet_implemented "loop_annot AAllocation"
      | APragma _ ->
        Self.not_yet_implemented "loop_annot APragma")
    (Term.t_true, []) a

let binop op e1 e2 =
  let ls,ty =
    match op with
      | PlusA -> add_int, Mlw_ty.ity_int
      | MinusA -> sub_int, Mlw_ty.ity_int
      | Mult -> mul_int, Mlw_ty.ity_int
      | Lt -> lt_int, Mlw_ty.ity_bool
      | Le -> le_int, Mlw_ty.ity_bool
      | Gt | Ge | Eq | Ne ->
        Self.not_yet_implemented "binop comp"
      | PlusPI|IndexPI|MinusPI|MinusPP ->
        Self.not_yet_implemented "binop plus/minus"
      | Div|Mod ->
        Self.not_yet_implemented "binop div/mod"
      | Shiftlt|Shiftrt ->
        Self.not_yet_implemented "binop shift"
      | BAnd|BXor|BOr|LAnd|LOr ->
        Self.not_yet_implemented "binop bool"
  in
  Mlw_expr.e_lapp ls [e1;e2] ty

let constant c =
  match c with
  | CInt64(_t,_ikind, Some s) ->
      Number.ConstInt (Literals.integer s)
  | CInt64(t,_ikind, None) ->
      Number.ConstInt (Literals.integer (My_bigint.to_string t))
  | CStr _
  | CWStr _
  | CChr _
  | CReal (_, _, _)
  | CEnum _ ->
      Self.not_yet_implemented "constant"

let rec expr e =
  match e.enode with
    | Const c -> Mlw_expr.e_const (constant c)
    | Lval lv -> lval lv
    | BinOp (op, e1, e2, _loc) ->
      binop op (expr e1) (expr e2)
    | SizeOf _
    | SizeOfE _
    | SizeOfStr _
    | AlignOf _
    | AlignOfE _
    | UnOp (_, _, _)
    | CastE (_, _)
    | AddrOf _
    | StartOf _
    | Info (_, _)
      -> Self.not_yet_implemented "expr"

let assignment (lhost,offset) e _loc =
  match lhost,offset with
    | Var v , NoOffset ->
      let v,is_mutable,ty = get_var v in
      if is_mutable then
        Mlw_expr.e_app
          (mk_set v.Mlw_ty.pv_vtv ty)
          [Mlw_expr.e_value v; expr e]
      else
        Self.not_yet_implemented "mutation of formal parameters"
    | Var _ , Field _ ->
      Self.not_yet_implemented "assignment Var/Field"
    | Var _ , Index _ ->
      Self.not_yet_implemented "assignment Var/Index"
    | Mem _, _ ->
      Self.not_yet_implemented "assignment Mem"

let instr i =
  match i with
  | Set(lv,e,loc) -> assignment lv e loc
  | Call (_, _, _, _) ->
    Self.not_yet_implemented "instr Call"
  | Asm (_, _, _, _, _, _) ->
    Self.not_yet_implemented "instr Asm"
  | Skip _loc ->
    Mlw_expr.e_void
  | Code_annot (_, _) ->
    Self.not_yet_implemented "instr Code_annot"

let exc_break =
  Mlw_ty.create_xsymbol (Ident.id_fresh "Break") Mlw_ty.ity_unit

let rec stmt s =
  match s.skind with
    | Instr i ->
      let annotations = Annotations.code_annot s in
      let e =
        List.fold_right annot annotations (instr i)
      in e
    | Block b -> block b
    | Return (None, _loc) ->
      Mlw_expr.e_void
    | Return (Some e, _loc) ->
      expr e
    | Goto (_, _) ->
      Self.not_yet_implemented "stmt Goto"
    | Break _loc ->
      Mlw_expr.e_raise exc_break Mlw_expr.e_void
        Mlw_ty.ity_unit
    | Continue _ ->
      Self.not_yet_implemented "stmt Continue"
    | If (c, e1, e2, _loc) ->
      Mlw_expr.e_if (expr c) (block e1) (block e2)
    | Switch (_, _, _, _) ->
      Self.not_yet_implemented "stmt Switch"
    | Loop (annots, body, _loc, _continue, _break) ->
      (*
        "while (1) body" is translated to
        try loop
          try body
          with Continue -> ()
        with Break -> ()
      *)
      assert (annots = []);
      let annots = Annotations.code_annot s in
      let inv, var = loop_annot annots in
      let v =
        Mlw_ty.create_pvsymbol (Ident.id_fresh "_dummy")
          (Mlw_ty.vty_value Mlw_ty.ity_unit)
      in
      Mlw_expr.e_try
        (Mlw_expr.e_loop inv var (block body))
        [exc_break,v,Mlw_expr.e_void]
    | UnspecifiedSequence _ ->
      Self.not_yet_implemented "stmt UnspecifiedSequence"
    | TryFinally (_, _, _) ->
      Self.not_yet_implemented "stmt TryFinally"
    | TryExcept (_, _, _, _) ->
      Self.not_yet_implemented "stmt TryExcept"

and block b =
  let rec mk_seq l =
    match l with
      | [] -> Mlw_expr.e_void
      | [s] -> stmt s
      | s::r -> seq (stmt s) (mk_seq r)
  in
  mk_seq b.bstmts







(*************)
(* contracts *)
(*************)

let extract_simple_contract c =
  let pre,post,ass = List.fold_left
    (fun (pre,post,ass) b ->
      if not (Cil.is_default_behavior b) then
        Self.not_yet_implemented "named behaviors";
      if b.b_assumes <> [] then
        Self.not_yet_implemented "assumes clause";
      let pre =
        List.fold_left
          (fun acc f -> (identified_proposition f) :: acc)
          pre b.b_requires
      in
      let post =
        List.fold_left
          (fun acc (k,f) ->
            if k <> Normal then
              Self.not_yet_implemented "abnormal termination post-condition";
            (identified_proposition f) :: acc)
          post b.b_post_cond
      in
      let ass =
        match b.b_assigns with
        | WritesAny -> ass
        | Writes l ->
          let l = List.map (fun (t,_) ->
            term (* ~in_contract:true Logic_const.here_label *) t.it_content) l in
          match ass with
          | None -> Some l
          | Some l' -> Some (l@l')
      in
      (pre,post, ass))
    ([],[],None) c.spec_behavior
  in
  (Logic_const.pands pre, Logic_const.pands post, ass)






(*************************)
(* function declarations *)
(*************************)

let fundecl fdec =
  let fun_id = fdec.svar in
  let kf = Globals.Functions.get fun_id in
  Self.log "processing function %a" Kernel_function.pretty kf;
  let args =
    match Kernel_function.get_formals kf with
      | [] ->
        [ Mlw_ty.create_pvsymbol
            (Ident.id_fresh "_dummy")
            (Mlw_ty.vty_value Mlw_ty.ity_unit) ]
      | l ->
        List.map (fun v ->
          let ity = ctype v.vtype in
          let vs =
            Mlw_ty.create_pvsymbol
              (Ident.id_fresh v.vname)
              (Mlw_ty.vty_value ity)
          in
          Hashtbl.add program_vars v.vid (vs,false,ity);
          vs)
        l
  in
  let body = fdec.sbody in
  let contract = Annotations.funspec kf in
  let pre,post,_ass = extract_simple_contract contract in
  let ret_type = ctype (Kernel_function.get_return_type kf) in
  let result =
    Term.create_vsymbol (Ident.id_fresh "result")
      (Mlw_ty.ty_of_ity ret_type)
  in
  result_vsymbol := result;
  let locals =
    List.map create_var (Kernel_function.get_locals kf)
  in
  let spec = {
    Mlw_ty.c_pre = predicate_named ~label:Here pre;
    c_post = 
      Term.t_eps 
        (Term.t_close_bound result (predicate_named ~label:Here post));
    c_xpost = Mlw_ty.Mexn.empty;
    c_effect = Mlw_ty.eff_empty;
    c_variant = [];
    c_letrec  = 0;
  }
  in
  let body = block body in
  let full_body = List.fold_right Mlw_expr.e_let locals body in
  let lambda = {
    Mlw_expr.l_args = args;
    l_expr = full_body;
    l_spec = spec;
  }
  in
  let def =
    Mlw_expr.create_fun_defn (Ident.id_fresh fun_id.vname) lambda
  in
  Mlw_decl.create_rec_decl [def]






(***********************)
(* global declarations *)
(***********************)


let global (theories,lemmas,functions) g =
  match g with
    | GFun (fdec,_) ->
      let f = fundecl fdec in
      (theories,lemmas,f::functions)
   | GVar (vi, _init, _loc) ->
(*
        let ty = translate_type vi.vtype in
        let init = match init.init with
        | None -> [AST.Init_space(Csyntax.sizeof ty)]
        | Some _ -> Self.fatal "cannot handle initializer" in
        let g = {
          AST.gvar_info = ty;
          AST.gvar_init = init;
          AST.gvar_readonly = false; (* TODO *)
          AST.gvar_volatile = false; (* TODO *)
        }
        in
        { acc with AST.prog_vars =
          (intern_string vi.vname, g)::acc.AST.prog_vars }
*)
     Self.not_yet_implemented "WARNING: Variable %s not translated" vi.vname

    | GVarDecl(_funspec,vi,_location) ->
      Self.error "WARNING: Variable %s not translated" vi.vname;
      (theories,lemmas,functions)
    | GAnnot (a, loc) ->
      let (t,l) = logic_decl ~in_axiomatic:false a loc (theories,lemmas) in
      (t,l,functions)
    | GText _ ->
      Self.not_yet_implemented "global: GText"
    | GPragma (_, _) ->
      Self.not_yet_implemented "global: GPragma"
    | GAsm (_, _) ->
      Self.not_yet_implemented "global: GAsm"
    | GEnumTagDecl (_, _) ->
      Self.not_yet_implemented "global: GEnumTagDecl"
    | GEnumTag (_, _) ->
      Self.not_yet_implemented "global: GEnumTag"
    | GCompTagDecl (_, _) ->
      Self.not_yet_implemented "global: GCompTagDecl"
    | GCompTag (_, _) ->
      Self.not_yet_implemented "global: GCompTag"
    | GType (_, _)  ->
      Self.not_yet_implemented "global: GType"


let print_id fmt id = Format.fprintf fmt "%s" id.Ident.id_string

let add_pdecl m d =
  try
    Mlw_module.add_pdecl ~wp:true m d
  with
      Not_found ->
        Self.fatal "add_pdecl %a" (Pp.print_list Pp.comma print_id)
          (Ident.Sid.elements d.Mlw_decl.pd_news)

let use m th =
  let name = th.Theory.th_name in
  Mlw_module.close_namespace
    (Mlw_module.use_export_theory
       (Mlw_module.open_namespace m name.Ident.id_string)
       th)
    true

let use_module m modul =
  let name = modul.Mlw_module.mod_theory.Theory.th_name in
  Mlw_module.close_namespace
    (Mlw_module.use_export
       (Mlw_module.open_namespace m name.Ident.id_string)
       modul)
    true

let prog p =
   try
    let theories,decls,functions =
      List.fold_left global ([],[],[]) p.globals
    in
    Self.result "found %d logic decl(s)" (List.length decls);
    let theories =
      add_decls_as_theory theories
        (Ident.id_fresh global_logic_decls_theory_name) decls
    in
    Self.result "made %d theory(ies)" (List.length theories);
    let m = Mlw_module.create_module env
      (Ident.id_fresh programs_module_name)
    in
    let m = use m int_theory in
    let m = use m real_theory in
    let m = List.fold_left use m theories in
    let m = use_module m ref_module in
    let m = List.fold_left add_pdecl m (List.rev functions) in
    Self.result "made %d function(s)" (List.length functions);
    let m = Mlw_module.close_module m in
    List.rev (m.Mlw_module.mod_theory :: theories) ;
  with Exit as e  ->
    Self.fatal "Exception raised during translation to Why3:@ %a@."
      Exn_printer.exn_printer e
