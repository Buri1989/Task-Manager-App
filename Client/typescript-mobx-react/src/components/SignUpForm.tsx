import React, { useState } from "react";
import { observer } from "mobx-react-lite";
import userStore from "../store/UserStore";

const SignUpForm: React.FC = observer(() => {
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");

  const handleSignUp = () => {
    userStore.signUp(username, password);
  };

  return (
    <div>
      <h2>Sign Up</h2>
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
      <button onClick={handleSignUp}>Sign Up</button>
    </div>
  );
});

export default SignUpForm;
