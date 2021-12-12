open Belt

type swrResponse<'data> = {
  data: option<'data>,
  error: option<string>,
  isValidating: bool,
}

type pokemonResource = {
  name: string,
  url: string,
}

type pokemonResponse = {
  count: int,
  next: string,
  results: array<pokemonResource>,
}

module Decode = {
  open Json.Decode

  let pokemon = data => {
    name: field("name", string, data),
    url: field("url", string, data),
  }

  let results = data => {
    array(pokemon, data)
  }

  let pokemonResponse = (data: Js.Json.t) => {
    count: field("count", int, data),
    next: field("next", string, data),
    results: field("results", results, data),
  }
}

@module("swr")
external useSWR: (string, string => Js.Promise.t<'data>) => swrResponse<'data> = "default"

let fetcher = url => {
  Fetch.fetch(url)
  ->Js.Promise.then_(Fetch.Response.json, _)
  ->Js.Promise.then_(obj => obj->Decode.pokemonResponse->Js.Promise.resolve, _)
}

@react.component
let make = () => {
  let {data} = useSWR("https://pokeapi.co/api/v2/pokemon", fetcher)

  switch data {
  | Some(data) => {
      let items =
        data.results->Array.mapWithIndex((i, p) =>
          <li key={Int.toString(i)}> {React.string(p.name)} </li>
        )

      <ul> {React.array(items)} </ul>
    }
  | None => <p> {React.string("loading...")} </p>
  }
}
