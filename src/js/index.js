import '../main.css';
import { Elm } from '../Main.elm';

const app = Elm.Main.init({
  node: document.getElementById('root'),
  flags: {api: "http://localhost:4000"}
});

app.ports.sendToJs.subscribe(function (data) {
  console.log("JS log", data );
  // localStorage.setItem("user", JSON.stringify(data));
});
