module Api exposing (Api, get, init, refreshToken)

import Http
import Json.Decode as Decode


type alias ApiPayload =
    { apiPrefix : String
    , token : String
    }


type Api
    = Api ApiPayload


init : ApiPayload -> Api
init =
    Api


type Method
    = GET


methodToString : Method -> String
methodToString method =
    case method of
        GET ->
            "GET"


createAuthorizationHeader : String -> Http.Header
createAuthorizationHeader token =
    Http.header "Authorization" <| String.join " " [ "BEARER", token ]


updatedToken : String
updatedToken =
    "UPDATED TOKEN"


refreshToken : Api -> Api
refreshToken (Api apiPayload) =
    Api { apiPayload | token = updatedToken }


getHeaders : String -> List Http.Header
getHeaders token =
    [ createAuthorizationHeader token
    , Http.header "X-HEADER" "X-HEADER-TEST-VALUE"
    ]


get : String -> (Result Http.Error data -> msg) -> Decode.Decoder data -> Api -> Cmd msg
get url msg decoder (Api { apiPrefix, token }) =
    Http.request
        { method = methodToString GET
        , headers = getHeaders token
        , url = apiPrefix ++ url
        , body = Http.emptyBody
        , expect = Http.expectJson msg decoder
        , timeout = Nothing
        , tracker = Nothing
        }
