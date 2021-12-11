open Belt

type todo = {
  id: int,
  text: string,
  done: bool,
}

let initialTodos = [
  {id: 1, text: "buy groceries", done: false},
  {id: 2, text: "eat trail mix", done: true},
  {id: 3, text: "play video games", done: false},
]

module TodoItem = {
  @react.component
  let make = (~item, ~onTodoClick) => {
    let style = if item.done {
      ReactDOM.Style.make(~textDecoration="line-through", ())
    } else {
      ReactDOM.Style.make()
    }

    let onClick = _ => {
      onTodoClick(item)
    }

    <span onClick style> {React.string(item.text)} </span>
  }
}

module TodoInput = {
  @react.component
  let make = (~onAdd) => {
    let (text, setText) = React.useState(_ => "")

    let onChange = e => {
      let value = ReactEvent.Form.target(e)["value"]
      setText(value)
    }

    let onClick = _ => {
      onAdd(text)
      setText(_ => "")
    }

    <div> <input onChange value=text /> <button onClick> {React.string("add")} </button> </div>
  }
}

@react.component
let make = () => {
  let (todos, setTodos) = React.useState(_ => initialTodos)

  let onTodoClick = todo => {
    setTodos(prevTodos => {
      prevTodos->Array.map(prev => {
        if prev.id == todo.id {
          {...todo, done: !prev.done}
        } else {
          prev
        }
      })
    })
  }

  let onAdd = text => {
    setTodos(prev => {
      let nextTodo = {id: Array.length(prev) + 1, text: text, done: false}
      prev->Array.concat([nextTodo])
    })
  }

  let items =
    todos->Array.map(item => <li key={Int.toString(item.id)}> <TodoItem item onTodoClick /> </li>)

  <div>
    <h2> {React.string("Todo list")} </h2> <ul> {React.array(items)} </ul> <TodoInput onAdd />
  </div>
}
