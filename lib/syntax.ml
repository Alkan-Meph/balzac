let ( let* ) = Result.bind
let ( let+ ) r f = Result.map f r

let rec iter_result f = function
  | [] -> Ok ()
  | hd :: tl ->
      let* () = f hd in
      iter_result f tl

let map_result f l =
  let rec map acc = function
    | [] -> Ok (List.rev acc)
    | hd :: tl ->
        let* result = f hd in
        map (result :: acc) tl
  in
  map [] l
