<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <html>

        <head>
            <title>Danh sách nhiệm vụ</title>
        </head>

        <body>

            <h2>Danh sách nhiệm vụ đã lưu</h2>

            <table border="1" cellpadding="10">
                <tr>
                    <th>STT</th>
                    <th>Tiêu đề</th>
                    <th>Thời lượng (giờ)</th>
                    <th>Ưu tiên</th>
                    <th>Deadline</th>
                    <th>Ngày tạo</th>
                </tr>

                <c:forEach var="task" items="${tasks}" varStatus="loop">

                    <tr>
                        <td>${loop.index + 1}</td>
                        <td>${task.title}</td>
                        <td>${task.duration}</td>
                        <td>${task.priority}</td>
                        <td>${task.deadline}</td>
                        <td>${task.createdAt}</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/tasks/edit/${task.id}">Sửa</a> |
                            <a href="${pageContext.request.contextPath}/tasks/delete/${task.id}"
                                onclick="return confirm('Bạn chắc chắn muốn xoá?')">Xoá</a>
                        </td>

                    </tr>

                </c:forEach>
            </table>

            <br>
            <a href="${pageContext.request.contextPath}/tasks/add">+ Thêm nhiệm vụ mới</a>

        </body>

        </html>