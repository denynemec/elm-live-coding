module Api exposing (Api, createApi, get, refreshToken, tokenV2)

import Http
import Json.Decode as Decode


type Api
    = ApiInternal String (List Http.Header) String


tokenV1 : String
tokenV1 =
    "Bearer HARDCODED V1"


tokenV2 : String
tokenV2 =
    "Bearer UPDATED V2"


createApi : String -> Api
createApi baseApiUrl =
    ApiInternal baseApiUrl [] tokenV1


refreshToken : String -> Api -> Api
refreshToken updatedToken (ApiInternal baseApiUrl headers _) =
    ApiInternal baseApiUrl headers updatedToken


get : String -> (Result Http.Error a -> msg) -> Decode.Decoder a -> Api -> Cmd msg
get endpointSuffix expectMsg decoder (ApiInternal baseApiUrl headers token) =
    Http.request
        { method = "GET"
        , headers = headers ++ [ Http.header "Authorization" token ]
        , url = baseApiUrl ++ endpointSuffix
        , body = Http.emptyBody
        , expect = Http.expectJson expectMsg decoder
        , timeout = Nothing
        , tracker = Nothing
        }
