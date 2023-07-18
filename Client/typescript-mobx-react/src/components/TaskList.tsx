import React, { useEffect } from "react";
import { observer } from "mobx-react-lite";
import taskStore from "../store/TaskStore";
import TaskItem from "./TaskItem";

const TaskList: React.FC = observer(() => {
  useEffect(() => {
    taskStore.fetchTasks();
  }, []);
  return (
    <>
      <h2>Task List</h2>
      <p>Completed tasks: {taskStore.completedTasksCounter}</p>
      {taskStore.tasks.map((task) => (
        <TaskItem key={task.id} task={task}></TaskItem>
      ))}
    </>
  );
});

export default TaskList;
