import React from "react";
import TaskListView from "./TaskListView";
import TaskFormView from "./TaskFormView";

function App(): JSX.Element {
  return (
    <div>
      <TaskListView /> <br />
      <br />
      <TaskFormView />
    </div>
  );
}

export default App;
