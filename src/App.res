@react.component
let make = () => {
  let url = RescriptReactRouter.useUrl()

  switch url.path {
  | list{"pokemon"} => <PokemonList />
  | list{} => <TodoList />
  | _ => <NotFound />
  }
}

let default = make
