package com.example.tasks;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import org.junit.jupiter.api.Test;
import org.springframework.web.server.ResponseStatusException;

class TaskServiceTest {
    @Test
    void createsTrimmedTaskAndUpdatesCompletion() {
        TaskService service = new TaskService();
        Task created = service.create("  Write tests  ");

        assertEquals("Write tests", created.title());
        assertFalse(created.completed());
        assertTrue(service.setCompleted(created.id(), true).completed());
    }

    @Test
    void rejectsBlankTitle() {
        TaskService service = new TaskService();
        assertThrows(IllegalArgumentException.class, () -> service.create("  "));
    }

    @Test
    void rejectsMissingTaskWhenDeleting() {
        TaskService service = new TaskService();
        assertThrows(ResponseStatusException.class, () -> service.delete(999));
    }
}
