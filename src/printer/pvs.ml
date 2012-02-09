(**************************************************************************)
(*                                                                        *)
(*  Copyright (C) 2010-2011                                               *)
(*    François Bobot                                                      *)
(*    Jean-Christophe Filliâtre                                           *)
(*    Claude Marché                                                       *)
(*    Andrei Paskevich                                                    *)
(*                                                                        *)
(*  This software is free software; you can redistribute it and/or        *)
(*  modify it under the terms of the GNU Library General Public           *)
(*  License version 2.1, with the special exception on linking            *)
(*  described in file LICENSE.                                            *)
(*                                                                        *)
(*  This software is distributed in the hope that it will be useful,      *)
(*  but WITHOUT ANY WARRANTY; without even the implied warranty of        *)
(*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                  *)
(*                                                                        *)
(**************************************************************************)

(** PVS printer *)

open Format
open Pp
open Util
open Ident
open Ty
open Term
open Decl
open Printer

let black_list =
  [ "and"; "conjecture"; "fact"; "let"; "table";
    "andthen"; "containing"; "false"; "library"; "then";
    "array"; "conversion"; "forall"; "macro"; "theorem";
    "assuming"; "conversion+"; "formula"; "measure"; "theory";
    "assumption"; "conversion-"; "from"; "nonempty"; "type"; "true";
    "auto"; "rewrite"; "corollary"; "function"; "not"; "type";
    "auto"; "rewrite+";" datatype"; "has"; "type"; "o"; "type+";
    "auto"; "rewrite-"; "else"; "if"; "obligation"; "var";
    "axiom"; "elsif"; "iff"; "of"; "when";
    "begin"; "end"; "implies"; "or"; "where";
    "but"; "endassuming"; "importing"; "orelse"; "with";
    "by"; "endcases"; "in"; "postulate"; "xor";
    "cases"; "endcond"; "inductive"; "proposition";
    "challenge"; "endif"; "judgement"; "recursive";
    "claim"; "endtable"; "lambda"; "sublemma";
    "closure"; "exists"; "law"; "subtypes";
    "cond"; "exporting"; "lemma"; "subtype"; "of"; ]

let iprinter =
  let isanitize = sanitizer char_to_lalpha char_to_lalnumus in
  create_ident_printer black_list ~sanitizer:isanitize

let forget_all () = forget_all iprinter

let tv_set = ref Sid.empty

(* type variables *)

let print_tv fmt tv =
  let n = id_unique iprinter tv.tv_name in
  fprintf fmt "%s" n

let print_tv_binder fmt tv =
  tv_set := Sid.add tv.tv_name !tv_set;
  let n = id_unique iprinter tv.tv_name in
  fprintf fmt "(%s:Type)" n

let print_implicit_tv_binder fmt tv =
  tv_set := Sid.add tv.tv_name !tv_set;
  let n = id_unique iprinter tv.tv_name in
  fprintf fmt "{%s:Type}" n

let print_ne_params fmt stv =
  Stv.iter
    (fun tv -> fprintf fmt "@ %a" print_tv_binder tv)
    stv

let print_ne_params_list fmt ltv =
  List.iter
    (fun tv -> fprintf fmt "@ %a" print_tv_binder tv)
    ltv

let print_params fmt stv =
  if Stv.is_empty stv then () else
    fprintf fmt "forall%a,@ " print_ne_params stv

let print_implicit_params fmt stv =
  Stv.iter (fun tv -> fprintf fmt "%a@ " print_implicit_tv_binder tv) stv

let print_params_list fmt ltv =
  match ltv with
    | [] -> ()
    | _ -> fprintf fmt "forall%a,@ " print_ne_params_list ltv

let forget_tvs () =
  Sid.iter (forget_id iprinter) !tv_set;
  tv_set := Sid.empty

(* logic variables *)
let print_vs fmt vs =
  let n = id_unique iprinter vs.vs_name in
  fprintf fmt "%s" n

let forget_var vs = forget_id iprinter vs.vs_name

let print_ts fmt ts =
  fprintf fmt "%s" (id_unique iprinter ts.ts_name)

let print_ls fmt ls =
  fprintf fmt "%s" (id_unique iprinter ls.ls_name)

let print_pr fmt pr =
  fprintf fmt "%s" (id_unique iprinter pr.pr_name)

(* info *)

type info = {
  info_syn : syntax_map;
  symbol_printers : (Theory.theory * ident_printer) Mid.t;
  realization : bool;
}

let print_path = print_list (constant_string ".") string

let print_id fmt id = string fmt (id_unique iprinter id)

let print_id_real info fmt id =
        try let th,ipr = Mid.find id info.symbol_printers in
        fprintf fmt "%a.%s.%s"
          print_path th.Theory.th_path
          th.Theory.th_name.id_string
          (id_unique ipr id)
        with Not_found -> print_id fmt id

let print_ls_real info fmt ls = print_id_real info fmt ls.ls_name
let print_ts_real info fmt ts = print_id_real info fmt ts.ts_name
let print_pr_real info fmt pr = print_id_real info fmt pr.pr_name

(** Types *)

let rec print_ty info fmt ty = match ty.ty_node with
  | Tyvar v -> print_tv fmt v
  | Tyapp (ts, tl) when is_ts_tuple ts ->
      begin
        match tl with
          | []  -> fprintf fmt "unit"
          | [ty] -> print_ty info fmt ty
          | _   -> fprintf fmt "(%a)%%type" (print_list star (print_ty info)) tl
      end
  | Tyapp (ts, tl) ->
      begin match query_syntax info.info_syn ts.ts_name with
        | Some s -> syntax_arguments s (print_ty info) fmt tl
        | None ->
            begin
              match tl with
                | []  -> (print_ts_real info) fmt ts
                | l   -> fprintf fmt "(%a@ %a)" (print_ts_real info) ts
                    (print_list space (print_ty info)) l
            end
      end

(* can the type of a value be derived from the type of the arguments? *)
let unambig_fs fs =
  let rec lookup v ty = match ty.ty_node with
    | Tyvar u when tv_equal u v -> true
    | _ -> ty_any (lookup v) ty
  in
  let lookup v = List.exists (lookup v) fs.ls_args in
  let rec inspect ty = match ty.ty_node with
    | Tyvar u when not (lookup u) -> false
    | _ -> ty_all inspect ty
  in
  inspect (of_option fs.ls_value)

(** Patterns, terms, and formulas *)

let lparen_l fmt () = fprintf fmt "@ ("
let lparen_r fmt () = fprintf fmt "(@,"
let print_paren_l fmt x = print_list_delim lparen_l rparen comma fmt x
let print_paren_r fmt x = print_list_delim lparen_r rparen comma fmt x

let arrow fmt () = fprintf fmt "@ -> "
let print_arrow_list fmt x = print_list arrow fmt x
let print_space_list fmt x = print_list space fmt x
let print_comma_list fmt x = print_list comma fmt x

let rec print_pat info fmt p = match p.pat_node with
  | Pwild -> fprintf fmt "_"
  | Pvar v -> print_vs fmt v
  | Pas (p,v) ->
      fprintf fmt "(%a as %a)" (print_pat info) p print_vs v
  | Por (p,q) ->
      fprintf fmt "(%a|%a)" (print_pat info) p (print_pat info) q
  | Papp (cs,pl) when is_fs_tuple cs ->
      fprintf fmt "%a" (print_paren_r (print_pat info)) pl
  | Papp (cs,pl) ->
      begin match query_syntax info.info_syn cs.ls_name with
        | Some s -> syntax_arguments s (print_pat info) fmt pl
        | _ when pl = [] -> (print_ls_real info) fmt cs
        | _ -> fprintf fmt "(%a %a)"
          (print_ls_real info) cs (print_list space (print_pat info)) pl
      end

let print_vsty_nopar info fmt v =
  fprintf fmt "%a:%a" print_vs v (print_ty info) v.vs_ty

let print_vsty info fmt v =
  fprintf fmt "(%a)" (print_vsty_nopar info) v

let print_binop fmt = function
  | Tand -> fprintf fmt "AND"
  | Tor -> fprintf fmt "OR"
  | Timplies -> fprintf fmt "=>"
  | Tiff -> fprintf fmt "<=>"

(* TODO: labels are lost, but we could print them as "% label \n",
   it would result in an ugly output, though *)
let print_label _fmt (_l,_) = () (*fprintf fmt "(*%s*)" l*)

let protect_on x s = if x then "(" ^^ s ^^ ")" else s

let rec print_term info fmt t = print_lrterm false false info fmt t
and     print_fmla info fmt f = print_lrfmla false false info fmt f
and print_opl_term info fmt t = print_lrterm true  false info fmt t
and print_opl_fmla info fmt f = print_lrfmla true  false info fmt f
and print_opr_term info fmt t = print_lrterm false true  info fmt t
and print_opr_fmla info fmt f = print_lrfmla false true  info fmt f

and print_lrterm opl opr info fmt t = match t.t_label with
  | _ -> print_tnode opl opr info fmt t

and print_lrfmla opl opr info fmt f = match f.t_label with
  | _ -> print_fnode opl opr info fmt f

and print_tnode opl opr info fmt t = match t.t_node with
  | Tvar v ->
      print_vs fmt v
  | Tconst c ->
      let number_format = {
          Print_number.long_int_support = true;
          Print_number.dec_int_support = Print_number.Number_custom "%s";
          Print_number.hex_int_support = Print_number.Number_unsupported;
          Print_number.oct_int_support = Print_number.Number_unsupported;
          Print_number.bin_int_support = Print_number.Number_unsupported;
          Print_number.def_int_support = Print_number.Number_unsupported;
          Print_number.dec_real_support = Print_number.Number_unsupported;
          Print_number.hex_real_support = Print_number.Number_unsupported;
          Print_number.frac_real_support = Print_number.Number_custom
            (Print_number.PrintFracReal
               ("%s%%R", "(%s * %s)%%R", "(%s / %s)%%R"));
          Print_number.def_real_support = Print_number.Number_unsupported;
        }
      in
      Print_number.print number_format fmt c
  | Tif (f, t1, t2) ->
    fprintf fmt (protect_on opr "IF %a@ THEN %a@ ELSE %a")
        (print_fmla info) f (print_term info) t1 (print_opl_term info) t2
  | Tlet (t1, tb) ->
      let v,t2 = t_open_bound tb in
      fprintf fmt (protect_on opr "LET %a =@ %a IN@ %a")
        print_vs v (print_opl_term info) t1 (print_opl_term info) t2;
      forget_var v
  | Tcase (t,bl) ->
      fprintf fmt "CASES %a OF@\n@[<hov>%a@]@\nENDCASES"
        (print_term info) t
        (print_list newline (print_tbranch info)) bl
  | Teps fb ->
      let v,f = t_open_bound fb in
      fprintf fmt (protect_on opr "epsilon(LAMBDA %a:@ %a)")
        (print_vsty info) v (print_opl_fmla info) f;
      forget_var v
  | Tapp (fs, []) when is_fs_tuple fs ->
      fprintf fmt "tt"
  | Tapp (fs, pl) when is_fs_tuple fs ->
      fprintf fmt "%a" (print_paren_r (print_term info)) pl
  | Tapp (fs, tl) ->
    begin match query_syntax info.info_syn fs.ls_name with
      | Some s ->
        syntax_arguments s (print_term info) fmt tl
      | _ ->
        if unambig_fs fs then
          if tl = [] then fprintf fmt "%a" (print_ls_real info) fs
          else fprintf fmt "%a(%a)" (print_ls_real info) fs
            (print_comma_list (print_term info)) tl
        else
          fprintf fmt (protect_on opl "(%a(%a)::%a)") (print_ls_real info) fs
            (print_space_list (print_term info)) tl (print_ty info) (t_type t)
    end
  | Tquant _ | Tbinop _ | Tnot _ | Ttrue | Tfalse -> raise (TermExpected t)

and print_fnode opl opr info fmt f = match f.t_node with
  | Tquant (Tforall, fq) ->
      let vl,_tl,f = t_open_quant fq in
      fprintf fmt (protect_on opr "FORALL %a:@ %a")
        (print_space_list (print_vsty info)) vl
        (* (print_tl info) tl *) (print_fmla info) f;
      List.iter forget_var vl
  | Tquant (Texists,fq) ->
      let vl,_tl,f = t_open_quant fq in
      let rec aux fmt vl = match vl with
        | [] ->
          print_fmla info fmt f
        | v :: vr ->
          fprintf fmt (protect_on opr "EXISTS %a:@ %a")
            (print_vsty_nopar info) v aux vr
      in
      aux fmt vl;
      List.iter forget_var vl
  | Ttrue ->
      fprintf fmt "TRUE"
  | Tfalse ->
      fprintf fmt "FALSE"
  | Tbinop (b, f1, f2) ->
      fprintf fmt (protect_on (opl || opr) "%a %a@ %a")
        (print_opr_fmla info) f1 print_binop b (print_opl_fmla info) f2
  | Tnot f ->
      fprintf fmt (protect_on opr "NOT %a") (print_opl_fmla info) f
  | Tlet (t, f) ->
      let v,f = t_open_bound f in
      fprintf fmt (protect_on opr "LET %a =@ %a IN@ %a")
        print_vs v (print_opl_term info) t (print_opl_fmla info) f;
      forget_var v
  | Tcase (t, bl) ->
      fprintf fmt "CASES %a OF@\n@[<hov>%a@]@\nENDCASES"
        (print_term info) t
        (print_list newline (print_fbranch info)) bl
  | Tif (f1, f2, f3) ->
      fprintf fmt (protect_on opr "IF %a@ THEN %a@ ELSE %a")
        (print_fmla info) f1 (print_fmla info) f2 (print_opl_fmla info) f3
  | Tapp (ps, tl) ->
    begin match query_syntax info.info_syn ps.ls_name with
      | Some s ->
          syntax_arguments s (print_term info) fmt tl
      | _ ->
          fprintf fmt "%a(%a)" (print_ls_real info) ps
            (print_space_list (print_term info)) tl
    end
  | Tvar _ | Tconst _ | Teps _ ->
      raise (FmlaExpected f)

and print_tbranch info fmt br =
  let p,t = t_open_branch br in
  fprintf fmt "@[<hov 4>| %a:@ %a@]"
    (print_pat info) p (print_term info) t;
  Svs.iter forget_var p.pat_vars

and print_fbranch info fmt br =
  let p,f = t_open_branch br in
  fprintf fmt "@[<hov 4>| %a:@ %a@]"
    (print_pat info) p (print_fmla info) f;
  Svs.iter forget_var p.pat_vars

let print_expr info fmt =
  TermTF.t_select (print_term info fmt) (print_fmla info fmt)

(** Declarations *)

let print_constr info _ts fmt cs =
  match cs.ls_args with
    | [] ->
        fprintf fmt "@[<hov 4>%a: %a?@]" print_ls cs print_ls cs
    | l ->
        fprintf fmt "@[<hov 4>%a(%a): %a?@]" print_ls cs
          (print_comma_list (print_ty info)) l print_ls cs

let ls_ty_vars ls =
  let ty_vars_args = List.fold_left Ty.ty_freevars Stv.empty ls.ls_args in
  let ty_vars_value = option_fold Ty.ty_freevars Stv.empty ls.ls_value in
  (ty_vars_args, ty_vars_value, Stv.union ty_vars_args ty_vars_value)

let definition fmt info =
  fprintf fmt "%s" (if info.realization then "Definition" else "Parameter")

(*

  copy of old user scripts

*)

let copy_user_script begin_string end_string ch fmt =
  fprintf fmt "%s@\n" begin_string;
  try
    while true do
      let s = input_line ch in
      fprintf fmt "%s@\n" s;
      if s = end_string then raise Exit
    done
  with
    | Exit -> fprintf fmt "@\n"
    | End_of_file -> fprintf fmt "%s@\n@\n" end_string

let proof_begin = "% YOU MAY EDIT THE PROOF BELOW"
let proof_end = "% DO NOT EDIT BELOW"
let context_begin = "% YOU MAY EDIT THE CONTEXT BELOW *)"
let context_end = "% DO NOT EDIT BELOW *)"

(* current kind of script in an old file *)
type old_file_state = InContext | InProof | NoWhere

let copy_proof s ch fmt =
  copy_user_script proof_begin proof_end ch fmt;
  s := NoWhere

let copy_context s ch fmt =
  copy_user_script context_begin context_end ch fmt;
  s := NoWhere

let lookup_context_or_proof old_state old_channel =
  match !old_state with
    | InProof | InContext -> ()
    | NoWhere ->
        let rec loop () =
          let s = input_line old_channel in
          if s = proof_begin then old_state := InProof else
            if s = context_begin then old_state := InContext else
              loop ()
        in
        try loop ()
        with End_of_file -> ()

let print_empty_context fmt =
  fprintf fmt "%s@\n" context_begin;
  fprintf fmt "@\n";
  fprintf fmt "%s@\n@\n" context_end

let print_empty_proof ?(def=false) fmt =
  fprintf fmt "%s@\n" proof_begin;
  if not def then fprintf fmt "intuition.@\n";
  fprintf fmt "@\n";
  fprintf fmt "%s.@\n" (if def then "Defined" else "Qed");
  fprintf fmt "%s@\n@\n" proof_end

(*
let print_next_proof ?def ch fmt =
  try
    while true do
      let s = input_line ch in
      if s = proof_begin then
        begin
          fprintf fmt "%s@\n" proof_begin;
          while true do
            let s = input_line ch in
            fprintf fmt "%s@\n" s;
            if s = proof_end then raise Exit
          done
        end
    done
  with
    | End_of_file -> print_empty_proof ?def fmt
    | Exit -> fprintf fmt "@\n"
*)

let print_context ~old fmt =
  match old with
    | None -> print_empty_context fmt
    | Some(s,ch) ->
        lookup_context_or_proof s ch;
        match !s with
          | InProof | NoWhere -> print_empty_context fmt
          | InContext -> copy_context s ch fmt

let print_proof ~old ?def fmt =
  match old with
    | None ->
        print_empty_proof ?def fmt
    | Some(s, ch) ->
        lookup_context_or_proof s ch;
        match !s with
          | InContext | NoWhere -> print_empty_proof ?def fmt
          | InProof -> copy_proof s ch fmt

let produce_remaining_contexts_and_proofs ~old fmt =
  match old with
    | None -> ()
    | Some(s,ch) ->
        let rec loop () =
          lookup_context_or_proof s ch;
          match !s with
            | NoWhere -> ()
            | InContext -> copy_context s ch fmt; loop ()
            | InProof -> copy_proof s ch fmt; loop ()
        in
        loop ()

(*
let produce_remaining_proofs ~old fmt =
  match old with
    | None -> ()
    | Some ch ->
  try
    while true do
      let s = input_line ch in
      if s = proof_begin then
        begin
          fprintf fmt "(* OBSOLETE PROOF *)@\n";
          try while true do
            let s = input_line ch in
            if s = proof_end then
              begin
                fprintf fmt "(* END OF OBSOLETE PROOF *)@\n@\n";
                raise Exit
              end;
            fprintf fmt "%s@\n" s;
          done
          with Exit -> ()
        end
    done
  with
    | End_of_file -> fprintf fmt "@\n"
*)

let realization ~old ?def fmt produce_realization =
  if produce_realization then
    print_proof ~old ?def fmt
(*
    begin match old with
      | None -> print_empty_proof ?def fmt
      | Some ch -> print_next_proof ?def ch fmt
    end
*)
  else
    fprintf fmt "@\n"

let print_type_decl ~old info fmt (ts,def) =
  if is_ts_tuple ts then () else
  match def with
    | Tabstract -> begin match ts.ts_def with
        | None ->
            fprintf fmt "@[<hov 2>%a%a: TYPE@]@\n%a"
              print_ts ts print_params_list ts.ts_args
              (realization ~old ~def:true) info.realization
        | Some ty ->
            fprintf fmt "@[<hov 2>%a%a: TYPE =@ %a@]@\n@\n"
              print_ts ts (print_list space print_tv_binder) ts.ts_args
              (print_ty info) ty
        end
    | Talgebraic csl ->
        fprintf fmt
          "@[<hov 1>%a%a: DATATYPE@\n@[<hov 1>BEGIN@\n%a@\nEND %a@]@\n@]"
          print_ts ts (print_list space print_tv_binder) ts.ts_args
          (print_list newline (print_constr info ts)) csl
          print_ts ts;
        fprintf fmt "@\n"

let print_type_decl ~old info fmt d =
  if not (Mid.mem (fst d).ts_name info.info_syn) then
    (print_type_decl ~old info fmt d; forget_tvs ())

let print_ls_type ?(arrow=false) info fmt ls =
  if arrow then fprintf fmt " ->@ ";
  match ls with
  | None -> fprintf fmt "Prop"
  | Some ty -> print_ty info fmt ty

let print_logic_decl ~old info fmt (ls,ld) =
  let _ty_vars_args, _ty_vars_value, all_ty_params = ls_ty_vars ls in
  begin
    match ld with
      | Some ld ->
          let vl,e = open_ls_defn ld in
          fprintf fmt "@[<hov 2>%a%a(%a): %a =@ %a@]@\n"
            print_ls ls
            print_ne_params all_ty_params
            (print_comma_list (print_vsty info)) vl
            (print_ls_type info) ls.ls_value
            (print_expr info) e;
          List.iter forget_var vl
      | None ->
          fprintf fmt "@[<hov 2>%a %a: %a%a%a@]@\n%a"
            definition info
            print_ls ls
            print_params all_ty_params
            (print_arrow_list (print_ty info)) ls.ls_args
            (print_ls_type ~arrow:(ls.ls_args <> []) info) ls.ls_value
            (realization ~old ~def:true) info.realization
  end;
  fprintf fmt "@\n"

let print_logic_decl ~old info fmt d =
  if not (Mid.mem (fst d).ls_name info.info_syn) then
    (print_logic_decl ~old info fmt d; forget_tvs ())

let print_recursive_decl info tm fmt (ls,ld) =
  let _, _, all_ty_params = ls_ty_vars ls in
  let il = try Mls.find ls tm with Not_found -> assert false in
  let i = match il with [i] -> i | _ -> assert false in
  begin match ld with
    | Some ld ->
        let vl,e = open_ls_defn ld in
        fprintf fmt "%a%a%a {struct %a}: %a :=@ %a.@]@\n"
          print_ls ls
          print_ne_params all_ty_params
          (print_space_list (print_vsty info)) vl
          print_vs (List.nth vl i)
          (print_ls_type info) ls.ls_value
          (print_expr info) e;
        List.iter forget_var vl
    | None ->
        assert false
  end

let print_recursive_decl info fmt dl =
  let tm = check_termination dl in
  let d, dl = match dl with d :: dl -> d, dl | [] -> assert false in
  fprintf fmt "Set Implicit Arguments.@\n";
  fprintf fmt "@[<hov 2>Fixpoint ";
  print_recursive_decl info tm fmt d; forget_tvs ();
  List.iter
    (fun d ->
       fprintf fmt "@[<hov 2>with ";
       print_recursive_decl info tm fmt d; forget_tvs ())
    dl;
  fprintf fmt "Unset Implicit Arguments.@\n@\n"

let print_ind info fmt (pr,f) =
  fprintf fmt "@[<hov 4>| %a : %a@]" print_pr pr (print_fmla info) f

let print_ind_decl info fmt (ps,bl) =
  let _ty_vars_args, _ty_vars_value, all_ty_params = ls_ty_vars ps in
  fprintf fmt "@[<hov 2>Inductive %a%a : %a -> Prop :=@ @[<hov>%a@].@]@\n"
     print_ls ps print_implicit_params all_ty_params
    (print_arrow_list (print_ty info)) ps.ls_args
     (print_list newline (print_ind info)) bl;
  fprintf fmt "@\n"

let print_ind_decl info fmt d =
  if not (Mid.mem (fst d).ls_name info.info_syn) then
    (print_ind_decl info fmt d; forget_tvs ())

let print_pkind info fmt = function
  | Paxiom ->
      if info.realization then
        fprintf fmt "LEMMA"
      else
        fprintf fmt "AXIOM"
  | Plemma -> fprintf fmt "LEMMA"
  | Pgoal  -> fprintf fmt "THEOREM"
  | Pskip  -> assert false (* impossible *)

let print_proof ~old info fmt = function
  | Plemma | Pgoal ->
      realization ~old fmt true
  | Paxiom ->
      realization ~old fmt info.realization
  | Pskip -> ()

let print_proof_context ~old info fmt = function
  | Plemma | Pgoal ->
      print_context ~old fmt
  | Paxiom ->
      if info.realization then print_context ~old fmt
  | Pskip -> ()

let print_decl ~old info fmt d = match d.d_node with
  | Dtype tl  ->
      print_list nothing (print_type_decl ~old info) fmt tl
  | Dlogic [s, _ as ld] when not (Sid.mem s.ls_name d.d_syms) ->
      print_logic_decl ~old info fmt ld
  | Dlogic ll ->
      print_recursive_decl info fmt ll
  | Dind il   ->
      print_list nothing (print_ind_decl info) fmt il
  | Dprop (_, pr, _) when Mid.mem pr.pr_name info.info_syn ->
      ()
  | Dprop (k, pr, f) ->
      print_proof_context ~old info fmt k;
      let params = t_ty_freevars Stv.empty f in
      fprintf fmt "@[<hov 2>%a: %a %a%a@]@\n"
        print_pr pr
        (print_pkind info) k
        print_params params
        (print_fmla info) f (* (print_proof ~old info) k *);
      forget_tvs ()

let print_decls ~old info fmt dl =
  fprintf fmt "@[<hov>%a@\n@]" (print_list nothing (print_decl ~old info)) dl

let init_printer th =
  let isanitize = sanitizer char_to_alpha char_to_alnumus in
  let pr = create_ident_printer black_list ~sanitizer:isanitize in
  Sid.iter (fun id -> ignore (id_unique pr id)) th.Theory.th_local;
  pr

(* TODO: add a driver meta and make lookup for realized theories a bit
   more efficient *)
let realized_theories = Coq_config.realized_theories

let print_task _env pr thpr realize ?old fmt task =
  forget_all ();
  print_prelude fmt pr;
  print_th_prelude task fmt thpr;
  let symbol_printers,decls =
      let used = Task.used_theories task in
      let used = Mid.filter
        (fun _ th ->
          List.mem
            (th.Theory.th_path @ [th.Theory.th_name.id_string])
            realized_theories)
        used
      in
      (* 2 cases: goal is clone T with [] or goal is a real goal *)
      let used = match task with
        | None -> assert false
        | Some { Task.task_decl = { Theory.td_node = Theory.Clone (th,_) }} ->
            Sid.iter
              (fun id -> ignore (id_unique iprinter id))
              th.Theory.th_local;
            Mid.remove th.Theory.th_name used
        | _ -> used
      in
      Mid.iter
        (fun id th -> fprintf fmt "Require %a.%s.@\n"
          print_path th.Theory.th_path id.id_string)
        used;
      let symbols = Task.used_symbols used in
      (* build the printers for each theories *)
      let printers = Mid.map init_printer used in
      let decls = Task.local_decls task symbols in
      let symbols =
        Mid.map (fun th -> (th,Mid.find th.Theory.th_name printers))
          symbols
      in
      symbols, decls
  in
  let info = {
    info_syn = get_syntax_map task;
    symbol_printers = symbol_printers;
    realization = realize;
  }
  in
  let old = match old with
    | None -> None
    | Some ch -> Some (ref NoWhere, ch)
  in
  fprintf fmt "@[<hov 1>goal: THEORY@\n@[<hov 1>BEGIN@\n";
  print_decls ~old info fmt decls;
  fprintf fmt "END goal@\n@]@]"

let print_task_full env pr thpr ?old fmt task =
  print_task env pr thpr false ?old fmt task

let print_task_real env pr thpr ?old fmt task =
  print_task env pr thpr true  ?old fmt task

let () = register_printer "pvs" print_task_full
let () = register_printer "pvs-realize" print_task_real

(*
Local Variables:
compile-command: "unset LANG; make -C ../.. "
End:
*)