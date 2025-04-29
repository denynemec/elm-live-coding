module Utils.Api exposing (Api, get, init, updateRefreshToken)

import Http
import Json.Decode as Decode
import RemoteData


type Api
    = Api ApiPayload


type alias ApiPayload =
    { baseApiUrl : String
    , headerList : List Http.Header
    , token : String
    }


tokenInit : String
tokenInit =
    "Bearer api ..."


token2 : String
token2 =
    "Bearer api updated ..."


init : String -> Api
init baseApiUrl =
    Api
        { baseApiUrl = baseApiUrl
        , headerList = []
        , token = tokenInit
        }


updateRefreshToken : Api -> Api
updateRefreshToken (Api apiPayload) =
    Api { apiPayload | token = token2 }


get : String -> (RemoteData.WebData a -> msg) -> Decode.Decoder a -> Api -> Cmd msg
get endpoint msg decoder (Api { baseApiUrl, headerList, token }) =
    Http.request
        { method = "GET"
        , headers = headerList ++ [ authHeader token ]
        , url = baseApiUrl ++ endpoint
        , body = Http.emptyBody
        , expect = Http.expectJson (RemoteData.fromResult >> msg) decoder
        , timeout = Nothing
        , tracker = Nothing
        }


authHeader : String -> Http.Header
authHeader =
    Http.header "authentification"
