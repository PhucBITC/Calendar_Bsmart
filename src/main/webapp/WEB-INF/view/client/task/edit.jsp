<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <html>

        <head>
            <title>Sửa nhiệm vụ</title>
        </head>

        <body>

            <h2>Cập nhật nhiệm vụ</h2>

            <form action="${pageContext.request.contextPath}/tasks/save" method="post">

                <input type="hidden" name="id" value="${task.id}" />

                <label for="title">Tiêu đề:</label>
                <input type="text" id="title" name="title" value="${task.title}" required><br><br>

                <label for="duration">Thời lượng (giờ):</label>
                <input type="number" id="duration" name="duration" value="${task.duration}" required><br><br>

                <label for="priority">Ưu tiên:</label>
                <select id="priority" name="priority">
                    <option value="HIGH">Cao</option>
                    <option value="MEDIUM">Trung bình</option>
                    <option value="LOW">Thấp</option>
                </select><br><br>

                <label for="deadline">Deadline:</label>
                <input type="date" id="deadline" name="deadline" value="${task.deadline}" required><br><br>

                <button type="submit">Cập nhật</button>
            </form>

        </body>

        </html>