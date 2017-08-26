module Request.Utils exposing (..)


apiUrl : String -> String
apiUrl rest =
    "https://api.github.com" ++ rest
