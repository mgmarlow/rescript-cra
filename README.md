# Starting a rescript + create-react-app project

Install dependencies:

```
npx create-react-app a-todo-list
yarn add rescript @rescript/react
```

Add a `bsconfig.json` to your project w/ `@reason/react` defaults:

```
cat > bsconfig.json << EOF
{
  "name": "your-project-name",
  "sources": [
    {
      "dir": "src",
      "subdirs": true
    }
  ],
  "package-specs": [
    {
      "module": "es6",
      "in-source": true
    }
  ],
  "suffix": ".bs.js",
  "bs-dependencies": [
    "@rescript/react"
  ],
  "reason": { "react-jsx": 3 }
}
EOF
```

Add concurrently

```
yarn add concurrently
```

Update `package.json` with rescript toolchain:

```json
{
  "start": "concurrently \"yarn re:start\" \"react-scripts start\"",
  "re:build": "rescript",
  "re:start": "rescript build -w"
}
```

Create a new component, `App.res`:

```res
@react.component
let make = () => {
  <div> {React.string("Hello world")} </div>
}

let default = make
```

Update `index.js` with new Rescript output:

```js
// ...
import App from "./App.bs";
```
