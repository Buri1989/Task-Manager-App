import { observable, action } from "mobx";
import axios from "axios";

/*http://localhost:8080/user */

interface Task {
  id: number;
  title: string;
  description: string;
  completed: boolean;
}

class UserStore {
  @observable isAuthenticated = false;
  @observable tasks: Task[] = [];

  // Sign up user
  @action
  *signUp(username: string, password: string): Generator<any, void, any> {
    try {
      const response = yield axios.post("/http://localhost:8080/user/signup", {
        username,
        password,
      });
      this.isAuthenticated = true;
    } catch (error: any) {
      // Handle error
      if (error.response) {
        console.error("Sign-up error:", error.response.data);
      } else if (error.request) {
        console.error("No response received:", error.request);
      } else {
        console.error("Error setting up the request:", error.message);
      }
    }
  }

  // User login
  @action
  *login(username: string, password: string): Generator<any, void, any> {
    try {
      const response = yield axios.post("/http://localhost:8080/user/auth", {
        username,
        password,
      });
      const token = response.data.token;
      localStorage.setItem("token", token);
      this.isAuthenticated = true;
    } catch (error: any) {
      // Handle error
      if (error.response) {
        console.error("Login error:", error.response.data);
      } else if (error.request) {
        console.error("No response received:", error.request);
      } else {
        console.error("Error setting up the request:", error.message);
      }
    }
  }

  // Fetch user's tasks
  @action
  *fetchTasks(): Generator<any, void, any> {
    try {
      const token = localStorage.getItem("token");
      const response = yield axios.get("http://localhost:8080/task", {
        headers: { Authorization: `Bearer ${token}` },
      });
      this.tasks = response.data;
    } catch (error: any) {
      // Handle error
      if (error.response) {
        console.error("Fetch tasks error:", error.response.data);
      } else if (error.request) {
        console.error("No response received:", error.request);
      } else {
        console.error("Error setting up the request:", error.message);
      }
    }
  }
}

const userStore = new UserStore();
export default userStore;
