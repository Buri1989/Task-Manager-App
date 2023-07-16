import { observable, computed, action } from "mobx";
import axios from "axios";

/*Define the Task interface*/
interface Task {
  id: number;
  title: string;
  completed: boolean;
}

/*Create a store for tasks */
class TaskStore {
  @observable tasks: Task[] = [];

  /*Computed property to get the number of completed tasks */
  @computed get completedTaskCount(): number {
    return this.tasks.filter((task) => task.completed).length;
  }

  /*Action to fetch tasks from the server */
  @action async fetchTaskFromServer(): Promise<void> {
    try {
      const response = await axios.get(
        "api/tasks"
      ); /*TODO:add the server from the backend */
      this.tasks = response.data.tasks;
    } catch (error) {
      console.error("The error fetching data is: ", error);
    }
  }

  /*Action to create a new task */
  @action createTask(title: string): void {
    const newTask: Task = {
      id: Date.now(),
      title,
      completed: false,
    };
    this.tasks.push(newTask);
  }

  /*Action to update a task */
  @action updateTask(taskId: number, title: string): void {
    const task = this.tasks.find((task) => task.id === taskId);
    if (task) {
      task.title = title;
    }
  }

  /*Action to delete a task */
  @action deleteTask(taskId: number): void {
    this.tasks = this.tasks.filter((task) => task.id !== taskId);
  }
}

const taskStore = new TaskStore();

export default taskStore;
