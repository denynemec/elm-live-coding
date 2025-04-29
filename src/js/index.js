import '../main.css';
import { Elm } from '../Main.elm';

const BASE_API_URL = 'http://localhost:4000';

Elm.Main.init({
  node: document.getElementById('root'),
  flags: { baseApiUrl: BASE_API_URL },
});
