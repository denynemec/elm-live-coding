import '../main.css';
import { Elm } from '../Main.elm';

const app = Elm.Main.init({
  node: document.getElementById('root'),
  flags: {api: "https://jsonplaceholder.typicode.com"}
});

app.ports.sendToJs.subscribe(function (data) {
  console.log("JS log", data );
  // localStorage.setItem("user", JSON.stringify(data));
});
