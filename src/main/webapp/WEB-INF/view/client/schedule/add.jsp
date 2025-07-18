<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <html>

        <head>
            <title>${schedule.id == null ? 'Thêm lịch cố định' : 'Chỉnh sửa lịch'}</title>
        </head>

        <body>

            <h2>${schedule.id == null ? 'Thêm lịch cố định' : 'Chỉnh sửa lịch'}</h2>

            <form action="${pageContext.request.contextPath}/schedule/save" method="post">
                <input type="hidden" name="id" value="${schedule.id}" />

                <label for="dayOfWeek">Thứ trong tuần:</label>
                <select name="dayOfWeek" id="dayOfWeek" required>
                    <option value="MONDAY">Thứ 2</option>
                    <option value="TUESDAY">Thứ 3</option>
                    <option value="WEDNESDAY">Thứ 4</option>
                    <option value="THURSDAY">Thứ 5</option>
                    <option value="FRIDAY">Thứ 6</option>
                    <option value="SATURDAY">Thứ 7</option>
                    <option value="SUNDAY">Chủ nhật</option>
                </select><br><br>

                <label for="startTime">Giờ bắt đầu:</label>
                <input type="time" id="startTime" name="startTime" value="${schedule.startTime}" required><br><br>

                <label for="endTime">Giờ kết thúc:</label>
                <input type="time" id="endTime" name="endTime" value="${schedule.endTime}" required><br><br>

                <label for="description">Mô tả:</label>
                <input type="text" id="description" name="description" value="${schedule.description}" required><br><br>

                <button type="submit">Lưu</button>
            </form>

            <br>
            <a href="${pageContext.request.contextPath}/schedule/list">← Quay lại danh sách</a>

        </body>

        </html>