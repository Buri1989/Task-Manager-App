import React, { useState } from "react";
import { observer } from "mobx-react-lite";
import userStore from "../store/UserStore";

const LoginForm: React.FC = observer(() => {
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");

  const handleLogin = () => {
    userStore.login(username, password);
  };

  return (
    <div>
      <h2>Login</h2>
      <input
        type="text"
        value={username}
        onChange={(event) => setUsername(event.target.value)}
      />
      <input
        type="password"
        value={password}
        onChange={(event) => setPassword(event.target.value)}
      />
      <button onClick={handleLogin}>Login</button>
    </div>
  );
});

export default LoginForm;
