import Counter
import StartApp.Simple
import Html
import Html.Events

main = StartApp.Simple.start { model = model, view = view, update = update }

type alias Model =
  { counters : List (ID, Counter.Model)
  , nextID : ID
  }

type alias ID = Int

model : Model
model =
  { counters = []
  , nextID = 0
  }


type Action
  = Add
  | RemoveOldest
  | Modify ID Counter.Action
  | ResetAll
  | Remove ID

viewCounter : Signal.Address Action -> (ID, Counter.Model) -> Html.Html
viewCounter address (id, model) =
  Html.div []
    [ Counter.view
        (Signal.forwardTo address (Modify id))
        model
    , Html.button [ Html.Events.onClick address (Remove id) ] [ Html.text "Remove" ]
    ]

view : Signal.Address Action -> Model -> Html.Html
view address model =
  let
    controls =
      [ Html.button [ Html.Events.onClick address Add ]
        [ Html.text "Add" ]
      , Html.button [ Html.Events.onClick address RemoveOldest ]
        [ Html.text "Remove Oldest" ]
      , Html.button [ Html.Events.onClick address ResetAll ]
        [ Html.text "Reset All" ]
      ]
    counters =
      List.map (viewCounter address) model.counters
  in
    Html.div [] (controls ++ counters)

update : Action -> Model -> Model
update action model =
  case action of
    Add ->
      { model | counters = model.counters ++ [ (model.nextID, Counter.init 0) ]
      , nextID = model.nextID + 1
      }

    RemoveOldest ->
      { model | counters = List.drop 1 model.counters
      , nextID = model.nextID + 1
      }

    Modify id act ->
      let
        updateCounter (i, counter) =
          if i == id
            then
              (i, Counter.update act counter)
            else
              (i, counter)
      in
        { model |
          counters = List.map updateCounter model.counters
        }

    ResetAll ->
      let
        resetCounter (i, counter) =
          (i, Counter.update Counter.Reset counter)
      in
        { model |
          counters =
            List.map resetCounter model.counters
        }

    Remove id ->
      { model |
        counters = List.filter (\(i, _) -> i /= id) model.counters
      }
