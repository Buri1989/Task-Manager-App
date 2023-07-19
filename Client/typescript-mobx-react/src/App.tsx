import React, { useEffect } from "react";
import { Routes, Route, Link, Navigate } from "react-router-dom";
import { observer } from "mobx-react-lite";
import TaskList from "./components/TaskList";
import TaskForm from "./components/TaskForm";
import LoginForm from "./components/LoginForm";
import SignUpForm from "./components/LoginForm";
import UserStore from "./store/UserStore";

const App: React.FC = observer(() => {
  useEffect(() => {
    // Check if the user is already authenticated
    if (localStorage.getItem("token")) {
      UserStore.isAuthenticated = true;
      UserStore.fetchTasks();
    }
  }, []);

  const handleLogout = () => {
    // Clear user data and token
    UserStore.isAuthenticated = false;
    UserStore.tasks = [];
    localStorage.removeItem("token");
  };

  return (
    <Routes>
      <div>
        <h1>Task Management System</h1>
        <nav>
          {UserStore.isAuthenticated ? (
            <ul>
              <li>
                <Link to="/">Task List</Link>
              </li>
              <li>
                <Link to="/create">Create Task</Link>
              </li>
              <li>
                <button onClick={handleLogout}>Logout</button>
              </li>
            </ul>
          ) : (
            <ul>
              <li>
                <Link to="/signup">Sign Up</Link>
              </li>
              <li>
                <Link to="/login">Login</Link>
              </li>
            </ul>
          )}
        </nav>
        <Route
          path="/"
          element={
            UserStore.isAuthenticated ? <TaskList /> : <Navigate to="/login" />
          }
        />
        <Route
          path="/create"
          element={
            UserStore.isAuthenticated ? <TaskForm /> : <Navigate to="/login" />
          }
        />
        <Route path="/signup" element={<SignUpForm />} />
        <Route path="/login" element={<LoginForm />} />
      </div>
    </Routes>
  );
});

export default App;
