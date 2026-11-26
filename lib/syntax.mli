(** Binding operators and list functions for [result] values. *)

val ( let* ) : ('a, 'b) result -> ('a -> ('c, 'b) result) -> ('c, 'b) result
(** [let* x = r in e] is [Result.bind]: [e] is evaluated with [x] bound to [v]
    if [r] is [Ok v], and [r] is returned as is if it is an error. *)

val ( let+ ) : ('a, 'b) result -> ('a -> 'c) -> ('c, 'b) result
(** [let+ x = r in e] is [Result.map]: it is [Ok e], with [x] bound to [v], if
    [r] is [Ok v], and [r] as is if it is an error. *)

val iter_result : ('a -> (unit, 'b) result) -> 'a list -> (unit, 'b) result
(** [iter_result f l] applies [f] to the elements of [l], in order. It stops at
    the first error and returns it. *)

val map_result : ('a -> ('b, 'c) result) -> 'a list -> ('b list, 'c) result
(** [map_result f l] is the list of the results of [f] on the elements of [l],
    in the same order. It stops at the first error and returns it. *)
