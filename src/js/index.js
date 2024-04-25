import '../main.css';
import { Elm } from '../Main.elm';

const app = Elm.Main.init({
  node: document.getElementById('root'),
  flags: {
    api: 'http://localhost:4000/',
    counter: +localStorage.getItem('counter'),
  },
});

app.ports.saveCounter.subscribe((counter) => {
  localStorage.setItem('counter', counter);
});
