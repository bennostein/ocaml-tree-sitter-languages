(*
   Simple utilities to work on the types defined in Tree_sitter_output.atd.
*)

open Tree_sitter_API
open Tree_sitter_output_t

let rec of_ts_node get_node_id ts_node =
  let id = get_node_id () in
  let type_ = Node.type_ ts_node in
  let start_pos = Node.start_point ts_node in
  let end_pos = Node.end_point ts_node in
  let children = read_children get_node_id ts_node in
  {
    type_;
    start_pos;
    end_pos;
    children;
    id;
  }

and read_children get_node_id ts_node =
  match Node.child_count ts_node with
  | 0 -> []
  | child_count ->
      List.init child_count (fun i ->
        of_ts_node get_node_id (Node.child ts_node i)
      )

let of_ts_tree ts_tree =
  let root = Tree.root_node ts_tree in
  let counter = ref (-1) in
  let get_node_id () =
    incr counter;
    !counter
  in
  of_ts_node get_node_id root