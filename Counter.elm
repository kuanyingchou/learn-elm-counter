module Counter where

import StartApp.Simple as StartApp
import Html.Events
import Html

main : Signal Html.Html
main =
  StartApp.start { model = model, view = view, update = update }

type alias Model = Int
model : Model
model = init 0

init : Int -> Model
init value =
  value

view : Signal.Address Action -> Model -> Html.Html
view address model =
  Html.div []
    [ Html.button [ Html.Events.onClick address Increment ]
      [ Html.text "+" ]
    , Html.div []
      [ Html.text (Basics.toString model) ]
    , Html.button [ Html.Events.onClick address Decrement ]
      [ Html.text "-" ]
    ]

type Action = Increment | Decrement | Reset

update : Action -> Model -> Model
update action model =
  case action of
    Increment ->
      model + 1
    Decrement ->
      model - 1
    Reset ->
      0
