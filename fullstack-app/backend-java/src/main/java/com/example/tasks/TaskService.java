package com.example.tasks;

import java.util.Comparator;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicLong;

import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import static org.springframework.http.HttpStatus.NOT_FOUND;

@Service
public class TaskService {
    private final ConcurrentHashMap<Long, Task> tasks = new ConcurrentHashMap<>();
    private final AtomicLong nextId = new AtomicLong(1);

    public TaskService() {
        create("Try the task manager");
        create("Connect the app to the three-tier infrastructure");
    }

    public List<Task> list() {
        return tasks.values().stream()
                .sorted(Comparator.comparingLong(Task::id))
                .toList();
    }

    public Task create(String title) {
        String normalized = title == null ? "" : title.trim();
        if (normalized.isEmpty() || normalized.length() > 200) {
            throw new IllegalArgumentException("Title must contain 1 to 200 characters.");
        }
        Task task = new Task(nextId.getAndIncrement(), normalized, false);
        tasks.put(task.id(), task);
        return task;
    }

    public Task setCompleted(long id, boolean completed) {
        return tasks.compute(id, (taskId, current) -> {
            if (current == null) {
                throw new ResponseStatusException(NOT_FOUND, "Task not found.");
            }
            return new Task(current.id(), current.title(), completed);
        });
    }

    public void delete(long id) {
        if (tasks.remove(id) == null) {
            throw new ResponseStatusException(NOT_FOUND, "Task not found.");
        }
    }
}
