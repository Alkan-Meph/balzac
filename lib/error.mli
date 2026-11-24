type t = [ `Msg of string ]

val msgf : ('a, Format.formatter, unit, ('b, t) result) format4 -> 'a
