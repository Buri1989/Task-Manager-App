import React from "react";
import { observer } from "mobx-react-lite";
import taskStore from "../store/TaskStore";

interface TaskProps {
  task: {
    id: number;
    title: string;
    description: string;
    completed: boolean;
  };
}

const TaskItem: React.FC<TaskProps> = observer(({ task }) => {
  const handleDelete = () => {
    taskStore.deleteTask(task.id);
  };

  const handleToggleCompleted = () => {
    taskStore.updateTask({ ...task, completed: !task.completed });
  };

  return (
    <>
      <h3>{task.title}</h3>
      <p>{task.description}</p>
      <p>Completed:{task.completed ? "Yes" : "No"}</p>
      <button onClick={handleToggleCompleted}>
        {task.completed ? "Mark Incomplete" : "Mark Complete"}
      </button>
      <button onClick={handleDelete}>Delete</button>
    </>
  );
});

export default TaskItem;
