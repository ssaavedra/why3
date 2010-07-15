(**************************************************************************)
(*                                                                        *)
(*  Copyright (C) 2010-                                                   *)
(*    Francois Bobot                                                      *)
(*    Jean-Christophe Filliatre                                           *)
(*    Johannes Kanig                                                      *)
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

open Ident
open Ty
open Term
open Decl

(** Namespace *)

module Snm : Set.S with type elt = string
module Mnm : Map.S with type key = string

type namespace = private {
  ns_ts : tysymbol Mnm.t;   (* type symbols *)
  ns_ls : lsymbol Mnm.t;    (* logic symbols *)
  ns_pr : prsymbol Mnm.t;   (* propositions *)
  ns_ns : namespace Mnm.t;  (* inner namespaces *)
}

val ns_find_ts : namespace -> string list -> tysymbol
val ns_find_ls : namespace -> string list -> lsymbol
val ns_find_pr : namespace -> string list -> prsymbol

(** Meta properties *)

type meta_arg_type =
  | MTtysymbol
  | MTlsymbol
  | MTprsymbol
  | MTstring
  | MTint

type meta_arg =
  | MAts  of tysymbol
  | MAls  of lsymbol
  | MApr  of prsymbol
  | MAstr of string
  | MAint of int

val register_meta     : string -> meta_arg_type list -> string
val register_meta_exc : string -> meta_arg_type list -> string

val lookup_meta : string -> meta_arg_type list
val is_meta_exc : string -> bool

val list_meta : unit -> string list

(** Theory *)

type theory = private {
  th_name   : ident;      (* theory name *)
  th_decls  : tdecl list; (* theory declarations *)
  th_export : namespace;  (* exported namespace *)
  th_known  : known_map;  (* known identifiers *)
  th_local  : Sid.t;      (* locally declared idents *)
  th_used   : Sid.t;      (* used theories *)
}

and tdecl = private {
  td_node : tdecl_node;
  td_tag  : int;
}

and tdecl_node = private
  | Decl  of decl
  | Use   of theory
  | Clone of theory * tysymbol Mts.t * lsymbol Mls.t * prsymbol Mpr.t
  | Meta  of string * meta_arg list

module Stdecl : Set.S with type elt = tdecl
module Mtdecl : Map.S with type key = tdecl
module Htdecl : Hashtbl.S with type key = tdecl
module Wtdecl : Hashweak.S with type key = tdecl

val td_equal : tdecl -> tdecl -> bool

(** Constructors and utilities *)

type theory_uc  (* a theory under construction *)

val create_theory : preid -> theory_uc
val close_theory  : theory_uc -> theory

val open_namespace  : theory_uc -> theory_uc
val close_namespace : theory_uc -> bool -> string option -> theory_uc

val get_namespace : theory_uc -> namespace
val get_known : theory_uc -> known_map

(** Declaration constructors *)

val create_decl : decl -> tdecl

val add_decl : theory_uc -> decl -> theory_uc

val add_ty_decl : theory_uc -> ty_decl list -> theory_uc
val add_logic_decl : theory_uc -> logic_decl list -> theory_uc
val add_ind_decl : theory_uc -> ind_decl list -> theory_uc
val add_prop_decl : theory_uc -> prop_kind -> prsymbol -> fmla -> theory_uc

val add_ty_decls : theory_uc -> ty_decl list -> theory_uc
val add_logic_decls : theory_uc -> logic_decl list -> theory_uc
val add_ind_decls : theory_uc -> ind_decl list -> theory_uc

(** Use *)

val create_use : theory -> tdecl

val use_export : theory_uc -> theory -> theory_uc

(** Clone *)

type th_inst = {
  inst_ts    : tysymbol Mts.t; (* old to new *)
  inst_ls    : lsymbol  Mls.t;
  inst_lemma : Spr.t;
  inst_goal  : Spr.t;
}

val empty_inst : th_inst

val create_inst :
  ts    : (tysymbol * tysymbol) list ->
  ls    : (lsymbol  * lsymbol)  list ->
  lemma : prsymbol list ->
  goal  : prsymbol list -> th_inst

val clone_theory : ('a -> tdecl -> 'a) -> 'a -> theory -> th_inst -> 'a

val create_clone : tdecl list -> theory -> th_inst -> tdecl list

val clone_export : theory_uc -> theory -> th_inst -> theory_uc

val create_null_clone : theory -> tdecl

(** Meta *)

val create_meta : string -> meta_arg list -> tdecl

val add_meta : theory_uc -> string -> meta_arg list -> theory_uc

val clone_meta : tdecl -> theory -> tdecl -> tdecl
(* [clone_meta td_meta th td_clone] produces from [td_meta]
 * a new Meta tdecl instantiated with respect to [td_clone].
 * The [th] argument must be the same as in [td_clone]. *)

(** Base theories *)

val builtin_theory : theory

val tuple_theory : int -> theory

(* exceptions *)

exception NonLocal of ident
exception CannotInstantiate of ident
exception BadInstance of ident * ident

exception CloseTheory
exception NoOpenedNamespace
exception ClashSymbol of string

exception KnownMeta of string
exception UnknownMeta of string
exception BadMetaArity of string * int * int
exception MetaTypeMismatch of string * meta_arg_type * meta_arg_type

