(** Errors.

    Every function of the library that can fail returns a [result] whose error
    is a message meant for the user. *)

type t = [ `Msg of string ]
(** An error: a message. This is the error type of [Bos], [Fpath] and [Yaml], so
    their results compose with the ones of this library. *)

val msgf : ('a, Format.formatter, unit, ('b, t) result) format4 -> 'a
(** [msgf fmt ...] is [Error (`Msg msg)], where [msg] is formatted according to
    [fmt]. *)
