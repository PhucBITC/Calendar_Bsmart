<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add Task - B-Smart</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.0/css/all.min.css" />
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', sans-serif; background: #f5f7fa; }
        .container { max-width: 800px; margin: 0 auto; padding: 20px; }
        .header { background: white; padding: 20px; border-radius: 10px; margin-bottom: 20px; }
        .form-container { background: white; padding: 30px; border-radius: 10px; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: 600; color: #2c3e50; }
        .form-control { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 5px; font-size: 14px; }
        .btn { padding: 10px 20px; border: none; border-radius: 5px; text-decoration: none; cursor: pointer; margin-right: 10px; }
        .btn-primary { background: #3498db; color: white; }
        .btn-secondary { background: #95a5a6; color: white; }
        textarea.form-control { resize: vertical; min-height: 100px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Add New Task</h1>
            <p>Create a new task and assign it to a user</p>
        </div>
        
        <div class="form-container">
            <form method="POST" action="/admin/tasks/add">
                <div class="form-group">
                    <label for="title">Task Title *</label>
                    <input type="text" id="title" name="title" class="form-control" required>
                </div>
                
                <div class="form-group">
                    <label for="description">Description</label>
                    <textarea id="description" name="description" class="form-control" placeholder="Enter task description..."></textarea>
                </div>
                
                <div class="form-group">
                    <label for="priority">Priority *</label>
                    <select id="priority" name="priority" class="form-control" required>
                        <option value="">Select Priority</option>
                        <option value="HIGH">High</option>
                        <option value="MEDIUM">Medium</option>
                        <option value="LOW">Low</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="status">Status *</label>
                    <select id="status" name="status" class="form-control" required>
                        <option value="">Select Status</option>
                        <option value="PENDING">Pending</option>
                        <option value="IN_PROGRESS">In Progress</option>
                        <option value="COMPLETED">Completed</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="deadline">Deadline</label>
                    <input type="date" id="deadline" name="deadline" class="form-control">
                </div>
                
                <div class="form-group">
                    <label for="user">Assign To</label>
                    <select id="user" name="user.id" class="form-control">
                        <option value="">Select User</option>
                        <c:forEach var="user" items="${users}">
                            <option value="${user.id}">${user.username} (${user.fullName != null ? user.fullName : 'N/A'})</option>
                        </c:forEach>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="duration">Duration (hours)</label>
                    <input type="number" id="duration" name="duration" class="form-control" min="0" value="0">
                </div>
                
                <div class="form-group">
                    <label for="estimatedDuration">Estimated Duration (minutes)</label>
                    <input type="number" id="estimatedDuration" name="estimatedDuration" class="form-control" min="0">
                </div>
                
                <div class="form-group">
                    <button type="submit" class="btn btn-primary">
                        <i class="fa-solid fa-save"></i> Create Task
                    </button>
                    <a href="/admin/tasks" class="btn btn-secondary">
                        <i class="fa-solid fa-arrow-left"></i> Back to Tasks
                    </a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
