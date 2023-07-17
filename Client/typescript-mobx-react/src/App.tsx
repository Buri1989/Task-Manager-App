import React from "react";
import TaskListView from "./TaskListView";
import TaskForm from "./TaskForm";

function App(): JSX.Element {
  return (
    <div>
      <h1>Task Management System</h1>
      <TaskListView /> <br />
      <br />
      <TaskForm />
    </div>
  );
}

export default App;
