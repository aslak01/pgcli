open Lwt
open Cohttp
open Cohttp_lwt_unix

let http_get_cmd url = 
  Client.get (Uri.of_string url) >>= fun (resp, body) ->
  let code = resp |> Response.status |> Code.code_of_status in
  Printf.printf "Response code: %d\n" code;
  Printf.printf "Headers: %s\n" (resp |> Response.headers |> Header.to_string);
  body |> Cohttp_lwt.Body.to_string >|= fun body ->
  Printf.printf "Body of length: %d\n" (String.length body);
  body

let () =
  match Array.to_list Sys.argv with
  | _ :: url :: _ -> 
      let result = Lwt_main.run (http_get_cmd url) in
      Printf.printf "Result: %s\n" result
  | _ ->
      let error = "Usage: cli (<url>)" in
      Printf.printf "Error: %s\n" error
