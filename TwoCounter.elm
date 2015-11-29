import Counter
import Html
import Html.Events
import StartApp.Simple

type alias Model =
  { top : Counter.Model
  , bottom : Counter.Model
  }

init : Int -> Int -> Model
init a b =
  { top = Counter.init a
  , bottom = Counter.init b
  }

type Action
  = Top Counter.Action
  | Bottom Counter.Action
  | Reset

update : Action -> Model -> Model
update action model =
  case action of
    Top act ->
      { model |
        top = Counter.update act model.top
      }

    Bottom act ->
      { model |
        bottom = Counter.update act model.bottom
      }

    Reset ->
      init 0 0

view : Signal.Address Action -> Model -> Html.Html
view address model =
  Html.div []
    [ Counter.view
        (Signal.forwardTo address Top)
        model.top
    , Counter.view
        (Signal.forwardTo address Bottom)
        model.bottom
    , Html.button
        [ Html.Events.onClick address Reset ]
        [ Html.text "Reset" ]
    ]

main = StartApp.Simple.start
  { model = init 0 0
  , view = view
  , update = update
  }
