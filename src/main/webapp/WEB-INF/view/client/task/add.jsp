<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <html>

        <head>
            <title>Thêm nhiệm vụ mới</title>
        </head>

        <body>

            <h2>Thêm nhiệm vụ mới</h2>

            <form action="${pageContext.request.contextPath}/tasks/save" method="post">

                <label for="title">Tiêu đề:</label>
                <input type="text" id="title" name="title" required><br><br>

                <label for="duration">Thời lượng (giờ):</label>
                <input type="number" id="duration" name="duration" required><br><br>

                <label for="priority">Mức độ ưu tiên:</label>
                <select id="priority" name="priority">
                    <option value="HIGH">Cao</option>
                    <option value="MEDIUM">Trung bình</option>
                    <option value="LOW">Thấp</option>
                </select><br><br>

                <label for="deadline">Deadline:</label>
                <input type="date" id="deadline" name="deadline" required><br><br>

                <button type="submit">Lưu nhiệm vụ</button>
            </form>

        </body>

        </html>