import React, { useState } from "react";
import taskStore from "./TaskStore";

const TaskFormView: React.FC = () => {
  const [title, setTitle] = useState("");

  const handleSubmit = (event: React.FormEvent<HTMLFormElement>): void => {
    event.preventDefault();
    taskStore.createTask(title);
    setTitle("");
  };

  return (
    <div>
      <h2>Create/Edit</h2>
      <form onSubmit={handleSubmit}>
        <input
          type="text"
          value={title}
          onChange={(event) => setTitle(event.target.value)}
        />
        <button type="submit">Save</button>
      </form>
    </div>
  );
};

export default TaskFormView;
