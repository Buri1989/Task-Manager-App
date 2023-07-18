import React from "react";
import { Routes, Route, Link } from "react-router-dom";
import { observer } from "mobx-react-lite";
import TaskList from "./components/TaskList";
import TaskForm from "./components/TaskForm";

const App: React.FC = observer(() => {
  return (
    <Routes>
      <div>
        <h1>Task Management System</h1>
        <nav>
          <ul>
            <li>
              <Link to="/">Task List</Link>
            </li>
            <li>
              <Link to="/create">Create Task</Link>
            </li>
          </ul>
        </nav>
        <Route path="/" element={<TaskList />} />
        <Route path="/create" element={<TaskForm />} />
      </div>
    </Routes>
  );
});

export default App;
