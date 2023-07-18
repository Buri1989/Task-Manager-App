import React, { useState } from "react";
import { observer } from "mobx-react-lite";
import taskStore from "../store/TaskStore";

const TaskForm: React.FC = observer(() => {
  const [title, setTitle] = useState("");
  const [description, setDescription] = useState("");

  const handleSubmit = (event: React.FormEvent) => {
    event.preventDefault();
    const createNewTask = {
      id: taskStore.generateUniqueId(),
      title,
      description,
      completed: false,
    };
    taskStore.createTask(createNewTask);
    setTitle("");
    setDescription("");
  };
  return (
    <form onSubmit={handleSubmit}>
      <input
        type="text"
        placeholder="Title"
        value={title}
        onChange={(event) => setTitle(event.target.value)}
      />
      <textarea
        placeholder="Description"
        value={description}
        onChange={(event) => setDescription(event.target.value)}
      />
      <button type="submit">Add Task</button>
    </form>
  );
});

export default TaskForm;
