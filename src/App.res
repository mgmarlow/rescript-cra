@react.component
let make = () => {
  let url = RescriptReactRouter.useUrl()

  switch url.path {
  | list{"pokemon"} => <PokemonList />
  | list{} => <Home />
  | _ => <NotFound />
  }
}

let default = make
