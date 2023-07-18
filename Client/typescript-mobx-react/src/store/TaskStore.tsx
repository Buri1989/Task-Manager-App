import { observable, computed, action, flow, override } from "mobx";
import axios from "axios";

/*http://localhost:8080/task */
interface Task {
  id: number;
  title: string;
  description: string;
  completed: boolean;
}

class TaskStore {
  @observable tasks: Task[] = [];

  generateUniqueId(): number {
    /*Generate a random number between 1 and 10000 to be a unique Id for tasks*/
    const randomNumber = Math.floor(Math.random() * 10000) + 1;
    /*Check if the generated unique Id is already used in the tasks */
    const isDuplicateId = this.tasks.some((task) => task.id === randomNumber);
    /*If the Id is duplicate, recursively call the function again and again to generate a new Id */
    if (isDuplicateId) {
      return this.generateUniqueId();
    }
    return randomNumber;
  }

  @computed get completedTasksCounter(): number {
    return this.tasks.filter((task) => task.completed).length;
  }

  @action fetchTasks = flow(function* (this: TaskStore) {
    try {
      const response = yield axios.get("http://localhost:8080/task");
      this.tasks = response.data;
    } catch (error) {
      console.error("Error fetching tasks:", error);
    }
  });

  @action createTask = flow(function* (this: TaskStore, task: Task) {
    /*Check if a task already exists  */
    task.id = this.generateUniqueId();
    try {
      const response = yield axios.post("http://localhost:8080/task", task);
      const createNewTask = response.data;
      this.tasks.push(createNewTask);
    } catch (error) {
      console.error("Error creating task:", error);
    }
  });

  @action updateTask = flow(function* (this: TaskStore, task: Task) {
    try {
      yield axios.put(`http://localhost:8080/task$/{task.id}`, task);
      const index = this.tasks.findIndex((tsk) => tsk.id === task.id);
      if (index !== -1) {
        this.tasks[index] = task;
      }
    } catch (error) {
      console.error("Error updating task:", error);
    }
  });

  @action deleteTask = flow(function* (this: TaskStore, taskId: number) {
    try {
      yield axios.delete(`http://localhost:8080/task$/{taskId}`);
      this.tasks = this.tasks.filter((task) => task.id !== taskId);
    } catch (error) {
      console.error("Error deleting task:", error);
    }
  });
}

const taskStore = new TaskStore();
export default taskStore;
