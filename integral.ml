(*
  ------------------------------------------------------------------------------
  This module numerically approximates an integral for estimating the solution to
  the November 2024 puzzle at https://www.janestreet.com/puzzles

  Author: Jack Bullen
  Date: 2024-11-15
  ------------------------------------------------------------------------------
*)

(* Integrand *)
(* --------- *)

let sqr x = x *. x;;

let rl xb yb =
  sqrt(sqr(xb)+.sqr(yb));;

let rr xb yb =
  sqrt(sqr(1.-.xb)+.sqr(yb));;

let integrand_left x xb yb =
  0.5*.(sqr(rr xb yb)*.asin((x-.1.)/.(rr xb yb)) +. (x-.1.)*.sqrt(sqr(rr xb yb)-.sqr(x-.1.)));;

let integrand_right x xb yb = 
  0.5*.(sqr(rl xb yb)*.asin((x)/.(rl xb yb)) +. (x)*.sqrt(sqr(rl xb yb)-.sqr(x)));;

let area_left xb yb =
  integrand_left xb xb yb -. integrand_left (1. -. sqrt(sqr(1.-.xb) +. sqr(yb))) xb yb;;

let area_right xb yb =
  integrand_right (sqrt(sqr(xb)+.sqr(yb))) xb yb -. integrand_right xb xb yb;;

let area xb yb = 
  Float.pi *. (sqr(rl xb yb) +. sqr(rr xb yb)) /. 4. (* Quarter circles *)
    -. 2.*.(area_left xb yb+.area_right xb yb);;     (* - 2 * Half intersection *)

(* Numerical integration *)
(* --------------------- *)

let integral f a b tol = 
  let simp f a b = 
    (b -. a) /. 6. *. (f a +. 4.*.f ((a+.b)/.2.) +. f b)
  in 
  let rec aux f a m b curr tol =
    let left = simp f a m in
    let right = simp f m b in
    if abs_float (left +. right -. curr) < tol
      then left +. right
      else aux f a ((m +. a) /. 2.) m left (0.5*.tol)
        +. aux f m ((b +. m) /. 2.) b right (0.5*.tol)
  in
  let m = (b -. a) /. 2. in
  let curr = simp f a b in
  aux f a m b curr tol;;

let partial x = integral (area x) (-1.*.x) 0.0 1.0e-10;;
let res = integral partial 1.0e-9 0.5 1.0e-10;;
Printf.printf "%.10f\n" (8.*.res);;
