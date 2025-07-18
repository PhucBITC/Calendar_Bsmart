<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <html>

        <head>
            <title>Lịch gợi ý</title>
            <style>
                table {
                    width: 90%;
                    border-collapse: collapse;
                    margin: 20px auto;
                }

                th,
                td {
                    padding: 12px;
                    border: 1px solid #ddd;
                    text-align: center;
                }

                th {
                    background-color: #f2f2f2;
                }

                .btn {
                    display: inline-block;
                    padding: 8px 16px;
                    background-color: #4CAF50;
                    color: white;
                    text-decoration: none;
                    margin-left: 20px;
                    border-radius: 4px;
                }

                .btn:hover {
                    background-color: #45a049;
                }

                h2 {
                    text-align: center;
                    margin-top: 30px;
                }
            </style>
        </head>

        <body>

            <h2>Lịch biểu được gợi ý</h2>

            <table>
                <thead>
                    <tr>
                        <th>Tên nhiệm vụ</th>
                        <th>Thứ</th>
                        <th>Bắt đầu</th>
                        <th>Kết thúc</th>
                        <th>Ưu tiên</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${suggestedSchedule}">
                        <tr>
                            <td>${item.taskTitle}</td>
                            <td>${item.dayOfWeek}</td>
                            <td>${item.startTime}</td>
                            <td>${item.endTime}</td>
                            <td>${item.priority}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <div style="text-align: center;">
                <a href="${pageContext.request.contextPath}/schedule/list" class="btn">Quay lại danh sách</a>
            </div>

        </body>

        </html>