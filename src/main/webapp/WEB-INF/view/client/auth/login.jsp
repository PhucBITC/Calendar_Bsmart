<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Đăng nhập - BSmart Calendar</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
                <style>
                    body {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        min-height: 100vh;
                        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                    }

                    .login-container {
                        min-height: 100vh;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        padding: 20px;
                    }

                    .login-card {
                        background: white;
                        border-radius: 20px;
                        box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
                        overflow: hidden;
                        width: 100%;
                        max-width: 400px;
                    }

                    .login-header {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: white;
                        padding: 40px 30px 30px;
                        text-align: center;
                    }

                    .login-header h2 {
                        margin: 0;
                        font-weight: 600;
                        font-size: 1.8rem;
                    }

                    .login-header p {
                        margin: 10px 0 0;
                        opacity: 0.9;
                    }

                    .login-body {
                        padding: 40px 30px;
                    }

                    .form-group {
                        margin-bottom: 25px;
                    }

                    .form-label {
                        font-weight: 600;
                        color: #333;
                        margin-bottom: 8px;
                        display: block;
                    }

                    .form-control {
                        border: 2px solid #e1e5e9;
                        border-radius: 10px;
                        padding: 12px 16px;
                        font-size: 16px;
                        transition: all 0.3s ease;
                    }

                    .form-control:focus {
                        border-color: #667eea;
                        box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
                    }

                    .btn-login {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        border: none;
                        border-radius: 10px;
                        padding: 12px;
                        font-weight: 600;
                        font-size: 16px;
                        width: 100%;
                        color: white;
                        transition: transform 0.2s ease;
                    }

                    .btn-login:hover {
                        transform: translateY(-2px);
                        color: white;
                    }

                    .alert {
                        border-radius: 10px;
                        margin-bottom: 20px;
                    }

                    .login-footer {
                        text-align: center;
                        padding: 20px;
                        border-top: 1px solid #eee;
                    }

                    .login-footer a {
                        color: #667eea;
                        text-decoration: none;
                        font-weight: 600;
                    }

                    .login-footer a:hover {
                        text-decoration: underline;
                    }

                    .input-group-text {
                        border: 2px solid #e1e5e9;
                        border-right: none;
                        background: #f8f9fa;
                        border-radius: 10px 0 0 10px;
                    }

                    .input-group .form-control {
                        border-left: none;
                        border-radius: 0 10px 10px 0;
                    }

                    .input-group:focus-within .input-group-text,
                    .input-group:focus-within .form-control {
                        border-color: #667eea;
                    }

                    .remember-me {
                        display: flex;
                        align-items: center;
                        gap: 8px;
                        margin-bottom: 20px;
                    }

                    .form-check-input:checked {
                        background-color: #667eea;
                        border-color: #667eea;
                    }
                </style>
            </head>

            <body>
                <div class="login-container">
                    <div class="login-card">
                        <div class="login-header">
                            <i class="fas fa-calendar-alt fa-2x mb-3"></i>
                            <h2>Đăng nhập</h2>
                            <p>Chào mừng trở lại với BSmart Calendar</p>
                        </div>

                        <div class="login-body">
                            <!-- Thông báo lỗi -->
                            <c:if test="${not empty errorMessage}">
                                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    <i class="fas fa-exclamation-triangle me-2"></i>
                                    ${errorMessage}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                            </c:if>

                            <!-- Thông báo thành công -->
                            <c:if test="${not empty successMessage}">
                                <div class="alert alert-success alert-dismissible fade show" role="alert">
                                    <i class="fas fa-check-circle me-2"></i>
                                    ${successMessage}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                            </c:if>

                            <!-- Form đăng nhập -->
                            <form method="post" action="${pageContext.request.contextPath}/auth/login">
                                <div class="form-group">
                                    <label class="form-label" for="username">
                                        <i class="fas fa-user me-2"></i>Tên đăng nhập hoặc Email
                                    </label>
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="fas fa-user text-muted"></i>
                                        </span>
                                        <input type="text" name="username" class="form-control" id="username"
                                            placeholder="Nhập tên đăng nhập hoặc email" required="true"
                                            autocomplete="username" />
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="form-label" for="password">
                                        <i class="fas fa-lock me-2"></i>Mật khẩu
                                    </label>
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="fas fa-lock text-muted"></i>
                                        </span>
                                        <input type="password" name="password" class="form-control" id="password"
                                            placeholder="Nhập mật khẩu" required="true"
                                            autocomplete="current-password" />
                                    </div>
                                </div>

                                <div class="remember-me">
                                    <input type="checkbox" name="remember-me" class="form-check-input" id="rememberMe" />
                                    <label class="form-check-label" for="rememberMe">
                                        Ghi nhớ đăng nhập
                                    </label>
                                </div>

                                <button type="submit" class="btn btn-login">
                                    <i class="fas fa-sign-in-alt me-2"></i>Đăng nhập
                                </button>
                            </form>
                        </div>

                        <div class="login-footer">
                            <p class="mb-0">Chưa có tài khoản?
                                <a href="/auth/register">Đăng ký ngay</a>
                            </p>
                        </div>
                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
                <script>
                    // Auto dismiss alerts after 5 seconds
                    setTimeout(function () {
                        var alerts = document.querySelectorAll('.alert');
                        alerts.forEach(function (alert) {
                            var bsAlert = new bootstrap.Alert(alert);
                            bsAlert.close();
                        });
                    }, 5000);

                    // Focus on first input field
                    document.addEventListener('DOMContentLoaded', function () {
                        document.getElementById('username').focus();
                    });
                </script>
            </body>

            </html>