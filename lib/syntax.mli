val ( let* ) : ('a, 'b) result -> ('a -> ('c, 'b) result) -> ('c, 'b) result
val ( let+ ) : ('a, 'b) result -> ('a -> 'c) -> ('c, 'b) result
val iter_result : ('a -> (unit, 'b) result) -> 'a list -> (unit, 'b) result
val map_result : ('a -> ('b, 'c) result) -> 'a list -> ('b list, 'c) result
