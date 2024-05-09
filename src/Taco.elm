module Taco exposing (Taco, TacoMsg(..), getApi, init, update)

import Api


type Taco
    = Taco Api.Api


init : Api.Api -> Taco
init =
    Taco


getApi : Taco -> Api.Api
getApi (Taco api) =
    api


type TacoMsg
    = RefreshToken


update : TacoMsg -> Taco -> Taco
update tacoMsg (Taco api) =
    case tacoMsg of
        RefreshToken ->
            api
                |> Api.refreshToken
                |> Taco
