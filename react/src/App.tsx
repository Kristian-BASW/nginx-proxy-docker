import "./index.css";
import { useEffect, useState } from "react";

import minion from "./assets/minion.png";

export function App() {
  const [apiStatus, setApiStatus] = useState("Henter minions fra API'et …");

  useEffect(() => {
    fetch("/api/minions")
      .then(response => {
        if (!response.ok) throw new Error(`HTTP ${response.status}`);
        return response.json();
      })
      .then(minions => setApiStatus(minions.map((item: { name: string }) => item.name).join(", ")))
      .catch(error => setApiStatus(`API-fejl: ${error.message}`));
  }, []);

  return (
    <div className="app">
      <div className="logo-container">
        <img src={minion} alt="Minion" className="logo bun-logo" />
      </div>

      <h1>Minions + React</h1>
      <p>{apiStatus}</p>
    </div>
  );
}

export default App;
