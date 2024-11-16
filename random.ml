(*
  ------------------------------------------------------------------------------
  This module implements a Monte Carlo simulation for estimating the solution to
  the November 2024 puzzle at https://www.janestreet.com/puzzles

  Author: Jack Bullen
  Date: 2024-11-15
  ------------------------------------------------------------------------------
*)

(* Initialize the random seed *)
Random.self_init ();;

(* Squared euclidean distance *)
let dist (a1, a2) (b1, b2) =
  let dx = b1 -. a1 in
  let dy = b2 -. a2 in
  dx ** 2. +. dy ** 2.;;

(* Random point in triangle with vertices
   (0, 0), (0.5, 0), and (0.5, -0.5) *)
let rec rand_blue () =
  let bx = Random.float 0.5 in
  let by = Random.float 0.5 in
  if bx < 0.5 && by < bx then (bx, -1.*.by)
  else rand_blue ();;

(* Random point in the square with vertices 
   (0, 0), (1, 0), (0, -1), (1, -1) *)
let rand_red () =
  (Random.float 1., -1. *. Random.float 1.);;

(* Experiment returns 1 if success and 0 if fail *)
let exp () = 
  let blue = rand_blue () in
  let red  = rand_red () in
  
  let rl = dist blue (0., 0.) in
  let rr = dist blue (1., 0.) in

  let rdl = dist red (0., 0.) in
  let rdr = dist red (1., 0.) in

  if (rdl > rl && rdr > rr) || (rdl < rl && rdr < rr) 
    then 0 else 1;;

(* Monte carlo simulation *)
let rec sim n acc = 
  if n = 0 then acc else
  sim (n-1) (acc + exp ());;

(* Run simulation for n trials and print 4 digits of probability *)
let n = 1000000;;
let res = sim n 0;;
Printf.printf "%.4f\n" (float_of_int res /. float_of_int n);;