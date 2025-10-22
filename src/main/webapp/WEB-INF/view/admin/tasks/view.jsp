<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>View Task - B-Smart</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.0/css/all.min.css" />
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', sans-serif; background: #f5f7fa; }
        .container { max-width: 800px; margin: 0 auto; padding: 20px; }
        .header { background: white; padding: 20px; border-radius: 10px; margin-bottom: 20px; }
        .task-details { background: white; padding: 30px; border-radius: 10px; }
        .task-header { border-bottom: 1px solid #eee; padding-bottom: 20px; margin-bottom: 20px; }
        .task-title { font-size: 24px; color: #2c3e50; margin-bottom: 10px; }
        .task-meta { display: flex; gap: 20px; flex-wrap: wrap; }
        .meta-item { display: flex; align-items: center; gap: 8px; }
        .badge { padding: 4px 8px; border-radius: 12px; font-size: 11px; font-weight: 600; }
        .badge-high { background: #f8d7da; color: #721c24; }
        .badge-medium { background: #fff3cd; color: #856404; }
        .badge-low { background: #d1ecf1; color: #0c5460; }
        .badge-pending { background: #fff3cd; color: #856404; }
        .badge-in-progress { background: #d1ecf1; color: #0c5460; }
        .badge-completed { background: #d4edda; color: #155724; }
        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 20px; }
        .info-section { background: #f8f9fa; padding: 20px; border-radius: 8px; }
        .info-section h3 { color: #2c3e50; margin-bottom: 15px; font-size: 16px; }
        .info-item { display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px solid #eee; }
        .info-item:last-child { border-bottom: none; }
        .info-label { color: #7f8c8d; font-weight: 600; }
        .info-value { color: #2c3e50; }
        .btn { padding: 10px 20px; border: none; border-radius: 5px; text-decoration: none; cursor: pointer; margin-right: 10px; }
        .btn-primary { background: #3498db; color: white; }
        .btn-secondary { background: #95a5a6; color: white; }
        .btn-warning { background: #f39c12; color: white; }
        @media (max-width: 768px) {
            .info-grid { grid-template-columns: 1fr; }
            .task-meta { flex-direction: column; }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Task Details</h1>
            <p>View detailed information about the task</p>
        </div>
        
        <div class="task-details">
            <div class="task-header">
                <div class="task-title">${task.title}</div>
                <div class="task-meta">
                    <div class="meta-item">
                        <span class="badge badge-${task.priority.name().toLowerCase()}">${task.priority.name()}</span>
                    </div>
                    <div class="meta-item">
                        <span class="badge badge-${task.status.name().toLowerCase().replace('_', '-')}">${task.status.name().replace('_', ' ')}</span>
                    </div>
                </div>
            </div>
            
            <div class="info-grid">
                <div class="info-section">
                    <h3>Task Information</h3>
                    <div class="info-item">
                        <span class="info-label">Description:</span>
                        <span class="info-value">${task.description != null ? task.description : 'No description'}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Duration:</span>
                        <span class="info-value">${task.duration} hours</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Estimated Duration:</span>
                        <span class="info-value">${task.estimatedDuration != null ? task.estimatedDuration : 'N/A'} minutes</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Deadline:</span>
                        <span class="info-value">${task.deadline != null ? task.deadline : 'No deadline'}</span>
                    </div>
                </div>
                
                <div class="info-section">
                    <h3>Assignment Information</h3>
                    <div class="info-item">
                        <span class="info-label">Assigned To:</span>
                        <span class="info-value">${task.user != null ? task.user.username : 'Unassigned'}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">User Full Name:</span>
                        <span class="info-value">${task.user != null && task.user.fullName != null ? task.user.fullName : 'N/A'}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">User Email:</span>
                        <span class="info-value">${task.user != null ? task.user.email : 'N/A'}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">Created:</span>
                        <span class="info-value">${task.createdAt}</span>
                    </div>
                </div>
            </div>
            
            <div style="margin-top: 30px;">
                <a href="/admin/tasks/edit/${task.id}" class="btn btn-warning">
                    <i class="fa-solid fa-edit"></i> Edit Task
                </a>
                <a href="/admin/tasks" class="btn btn-secondary">
                    <i class="fa-solid fa-arrow-left"></i> Back to Tasks
                </a>
            </div>
        </div>
    </div>
</body>
</html>
