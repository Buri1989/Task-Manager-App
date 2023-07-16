import React, { useEffect } from "react";
import { observer } from "mobx-react";
import taskStore from "./TaskStore";

const TaskListView: React.FC = observer(() => {
  useEffect(() => {
    taskStore.fetchTaskFromServer();
  }, []);

  const handleUpdateTask = (taskId: number, title: string): void => {
    taskStore.updateTask(taskId, title);
  };

  const handleDeleteTask = (taskId: number): void => {
    taskStore.deleteTask(taskId);
  };
  return (
    <div>
      <h2>Task List</h2>
      {taskStore.tasks.map((task) => (
        <div key={task.id}>
          <span>{task.title}</span>
          <button onClick={() => handleUpdateTask(task.id, task.title)}>
            Edit
          </button>
          <button onClick={() => handleDeleteTask(task.id)}>Delete</button>
        </div>
      ))}
      <p>Completed tasks:{taskStore.completedTaskCount}</p>
    </div>
  );
});

export default TaskListView;
