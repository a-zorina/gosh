import { BrowserRouter } from "react-router-dom";
import "../assets/styles/index.scss";
import Router from "./router";
import { HelmetProvider } from 'react-helmet-async';

const App = () => {
  return (
    <HelmetProvider>
      <BrowserRouter>
        <Router />
      </BrowserRouter>
    </HelmetProvider>
  );
};



export default App;
