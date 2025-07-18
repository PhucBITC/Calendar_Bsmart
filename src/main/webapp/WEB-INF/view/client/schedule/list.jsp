<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <html>

        <head>
            <title>Danh sách lịch học cố định</title>
        </head>

        <body>

            <h2>Danh sách lịch học cố định</h2>

            <a href="${pageContext.request.contextPath}/schedule/add">+ Thêm lịch mới</a>
            <br><br>

            <c:if test="${not empty schedules}">
                <table border="1" cellpadding="8" cellspacing="0">
                    <thead>
                        <tr>
                            <th>Thứ</th>
                            <th>Bắt đầu</th>
                            <th>Kết thúc</th>
                            <th>Mô tả</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="schedule" items="${schedules}">
                            <tr>
                                <td>${schedule.dayOfWeek}</td>
                                <td>${schedule.startTime}</td>
                                <td>${schedule.endTime}</td>
                                <td>${schedule.description}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/schedule/edit/${schedule.id}">Sửa</a> |
                                    <a href="${pageContext.request.contextPath}/schedule/delete/${schedule.id}"
                                        onclick="return confirm('Xoá lịch này?')">Xoá</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>

            <c:if test="${empty schedules}">
                <p>Chưa có lịch nào được thêm.</p>
            </c:if>

            <div style="text-align: center; margin-bottom: 20px;">
                <form action="${pageContext.request.contextPath}/schedule/auto-generate" method="get">
                    <button type="submit" style="
            padding: 10px 20px;
            background-color: #2196F3;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;">
                        Tự động lập lịch
                    </button>
                </form>
            </div>

            <br>
        </body>

        </html>