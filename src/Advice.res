let adviceUrl = "https://api.adviceslip.com/advice"

type slip = {
  advice: string,
  id: int,
}

type advice = {slip: slip}

module Decode = {
  open Json.Decode

  let slip = data => {
    advice: field("advice", string, data),
    id: field("id", int, data),
  }

  let adviceData = (data: Js.Json.t) => {
    slip: field("slip", slip, data),
  }
}

let getAdvice = () => {
  Fetch.fetch(adviceUrl)
  ->Js.Promise.then_(Fetch.Response.json, _)
  ->Js.Promise.then_(obj => obj->Decode.adviceData->Js.Promise.resolve, _)
}

module GenerateAdvice = {
  @react.component
  let make = (~onCreateAdvice) => {
    let (fetching, setFetching) = React.useState(_ => false)

    let onClick = _ => {
      setFetching(_ => true)

      let _ = getAdvice()->Js.Promise.then_(rst => {
        onCreateAdvice(rst.slip.advice)
        setFetching(_ => false)
        Js.Promise.resolve(rst)
      }, _)
    }

    <button disabled={fetching} onClick> {React.string("generate")} </button>
  }
}

@react.component
let make = () => {
  let (advice, setAdvice) = React.useState(_ => "")

  let onCreateAdvice = (advice: string) => {
    setAdvice(_ => advice)
  }

  <div>
    <h2> {React.string("advice")} </h2>
    <GenerateAdvice onCreateAdvice />
    <p> {React.string(advice)} </p>
  </div>
}
