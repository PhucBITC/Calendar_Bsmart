<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Đăng ký - BSmart Calendar</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
                <style>
                    body {
                        background: linear-gradient(135deg, #0a9b7700 0%, #46ebaf 100%);
                        min-height: 100vh;
                        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                    }

                    .register-container {
                        min-height: 100vh;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        padding: 20px;
                    }

                    .register-card {
                        background: white;
                        border-radius: 20px;
                        box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
                        overflow: hidden;
                        width: 100%;
                        max-width: 500px;
                    }

                    .register-header {
                        background: linear-gradient(135deg, #7eb9aa 0%, #59e2b0 100%);
                        color: white;
                        padding: 30px 30px 25px;
                        text-align: center;
                    }

                    .register-header h2 {
                        margin: 0;
                        font-weight: 600;
                        font-size: 1.8rem;
                    }

                    .register-header p {
                        margin: 8px 0 0;
                        opacity: 0.9;
                    }

                    .register-body {
                        padding: 30px;
                        /* max-height: 70vh; */
                        /* overflow-y: auto; */
                    }

                    .form-group {
                        margin-bottom: 20px;
                    }

                    .form-label {
                        font-weight: 600;
                        color: #333;
                        margin-bottom: 6px;
                        display: block;
                        font-size: 14px;
                    }

                    .form-control {
                        border: 2px solid #e1e5e9;
                        border-radius: 10px;
                        padding: 10px 14px;
                        font-size: 15px;
                        transition: all 0.3s ease;
                    }

                    .form-control:focus {
                        border-color: #51d399;
                        box-shadow: 0 0 0 0.2rem rgba(36, 211, 127, 0.25);
                    }

                    .btn-register {
                        background: linear-gradient(135deg, #7eb9aa 0%, #59e2b0 100%);
                        border: none;
                        border-radius: 10px;
                        padding: 12px;
                        font-weight: 600;
                        font-size: 16px;
                        width: 100%;
                        color: white;
                        transition: transform 0.2s ease;
                    }

                    .btn-register:hover {
                        transform: translateY(-2px);
                        color: white;
                    }

                    .alert {
                        border-radius: 10px;
                        margin-bottom: 20px;
                    }

                    .register-footer {
                        text-align: center;
                        padding: 20px;
                        border-top: 1px solid #eee;
                    }

                    .register-footer a {
                        color: #11624e;
                        text-decoration: none;
                        font-weight: 600;
                    }

                    .register-footer a:hover {
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
                        border-color: #28c38a;
                    }

                    .row {
                        margin-left: -8px;
                        margin-right: -8px;
                    }

                    .col-md-6 {
                        padding-left: 8px;
                        padding-right: 8px;
                    }

                    .password-strength {
                        margin-top: 5px;
                        font-size: 12px;
                    }

                    .strength-weak {
                        color: #dc3545;
                    }

                    .strength-medium {
                        color: #ffc107;
                    }

                    .strength-strong {
                        color: #28a745;
                    }

                    .validation-message {
                        font-size: 12px;
                        margin-top: 3px;
                    }

                    .is-invalid {
                        border-color: #dc3545;
                    }

                    .is-valid {
                        border-color: #28a745;
                    }

                    .spinner-border-sm {
                        width: 1rem;
                        height: 1rem;
                    }

                    @media (max-width: 600px) {
                        .register-card {
                            max-width: 100%;
                            border-radius: 0;
                            box-shadow: none;
                        }

                        .register-body {
                            padding: 16px;
                        }
                    }
                </style>
            </head>

            <body>
                <div class="register-container">
                    <div class="register-card">
                        <div class="register-header">
                            <i class="fas fa-user-plus fa-2x mb-3"></i>
                            <h2>Đăng ký tài khoản</h2>
                            <p>Tạo tài khoản để sử dụng B-Smart Calendar</p>
                        </div>

                        <div class="register-body">
                            <!-- Thông báo lỗi -->
                            <c:if test="${not empty errorMessage}">
                                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                    <i class="fas fa-exclamation-triangle me-2"></i>
                                    ${errorMessage}
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                </div>
                            </c:if>

                            <!-- Form đăng ký -->
                            <form:form method="post" action="/auth/register" modelAttribute="registrationDTO"
                                id="registerForm">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <div class="input-group">
                                                <span class="input-group-text">
                                                    <i class="fas fa-user text-muted"></i>
                                                </span>
                                                <form:input path="username" class="form-control" id="username"
                                                    placeholder="Tên đăng nhập" required="true" minlength="3"
                                                    maxlength="50" onblur="checkUsername()" autocomplete="username" />
                                            </div>
                                            <div id="usernameValidation" class="validation-message"></div>
                                            <form:errors path="username"
                                                cssClass="text-danger validation-message d-block" />
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="form-group">
                                           
                                            <div class="input-group">
                                                <span class="input-group-text">
                                                    <i class="fas fa-envelope text-muted"></i>
                                                </span>
                                                <form:input path="email" type="email" class="form-control" id="email"
                                                    placeholder="Email của bạn" required="true" onblur="checkEmail()"
                                                    autocomplete="email" />
                                            </div>
                                            <div id="emailValidation" class="validation-message"></div>
                                            <form:errors path="email"
                                                cssClass="text-danger validation-message d-block" />
                                        </div>
                                    </div>
                                </div>

                                <div class="form-group">
                                   
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="fas fa-id-card text-muted"></i>
                                        </span>
                                        <form:input path="fullName" class="form-control" id="fullName"
                                            placeholder="Họ và tên của bạn" autocomplete="name" />
                                    </div>
                                    <form:errors path="fullName" cssClass="text-danger validation-message d-block" />
                                </div>

                                <div class="form-group">
                                    <div class="input-group">
                                        <span class="input-group-text">
                                            <i class="fas fa-phone text-muted"></i>
                                        </span>
                                        <form:input path="phoneNumber" class="form-control" id="phoneNumber"
                                            placeholder="Số điện thoại" autocomplete="tel" />
                                    </div>
                                    <form:errors path="phoneNumber" cssClass="text-danger validation-message d-block" />
                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <div class="input-group">
                                                <span class="input-group-text">
                                                    <i class="fas fa-lock text-muted"></i>
                                                </span>
                                                <form:password path="password" class="form-control" id="password"
                                                    placeholder="Mật khẩu" required="true" minlength="6"
                                                    onkeyup="checkPasswordStrength()" autocomplete="new-password" />
                                            </div>
                                            <div id="passwordStrength" class="password-strength"></div>
                                            <form:errors path="password"
                                                cssClass="text-danger validation-message d-block" />
                                        </div>
                                    </div>

                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <div class="input-group">
                                                <span class="input-group-text">
                                                    <i class="fas fa-lock text-muted"></i>
                                                </span>
                                                <form:password path="confirmPassword" class="form-control"
                                                    id="confirmPassword" placeholder="Xác nhận mật khẩu" required="true"
                                                    onkeyup="checkPasswordMatch()" autocomplete="new-password" />
                                            </div>
                                            <div id="passwordMatch" class="validation-message"></div>
                                            <form:errors path="confirmPassword"
                                                cssClass="text-danger validation-message d-block" />
                                        </div>
                                    </div>
                                </div>

                                <button type="submit" class="btn btn-register" id="submitBtn">
                                    <span id="submitText">
                                        <i class="fas fa-user-plus me-2"></i>Đăng ký tài khoản
                                    </span>
                                    <span id="submitLoading" class="d-none">
                                        <span class="spinner-border spinner-border-sm me-2"></span>Đang xử lý...
                                    </span>
                                </button>
                            </form:form>
                        </div>

                        <div class="register-footer">
                            <p class="mb-0">Đã có tài khoản?
                                <a href="/auth/login">Đăng nhập ngay</a>
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

                    // Check username availability
                    function checkUsername() {
                        const username = document.getElementById('username').value;
                        const validationDiv = document.getElementById('usernameValidation');
                        const usernameInput = document.getElementById('username');

                        if (username.length < 3) {
                            validationDiv.innerHTML = '<i class="fas fa-times text-danger"></i> Tên đăng nhập phải có ít nhất 3 ký tự';
                            usernameInput.classList.add('is-invalid');
                            usernameInput.classList.remove('is-valid');
                            return;
                        }

                        fetch('/auth/api/check-username?username=' + encodeURIComponent(username))
                            .then(response => response.json())
                            .then(exists => {
                                if (exists) {
                                    validationDiv.innerHTML = '<i class="fas fa-times text-danger"></i> Tên đăng nhập đã tồn tại';
                                    usernameInput.classList.add('is-invalid');
                                    usernameInput.classList.remove('is-valid');
                                } else {
                                    validationDiv.innerHTML = '<i class="fas fa-check text-success"></i> Tên đăng nhập có thể sử dụng';
                                    usernameInput.classList.add('is-valid');
                                    usernameInput.classList.remove('is-invalid');
                                }
                            })
                            .catch(error => {
                                validationDiv.innerHTML = '<i class="fas fa-exclamation-triangle text-warning"></i> Không thể kiểm tra tên đăng nhập';
                            });
                    }

                    // Check email availability
                    function checkEmail() {
                        const email = document.getElementById('email').value;
                        const validationDiv = document.getElementById('emailValidation');
                        const emailInput = document.getElementById('email');

                        if (!email || !email.includes('@')) {
                            validationDiv.innerHTML = '<i class="fas fa-times text-danger"></i> Email không đúng định dạng';
                            emailInput.classList.add('is-invalid');
                            emailInput.classList.remove('is-valid');
                            return;
                        }

                        fetch('/auth/api/check-email?email=' + encodeURIComponent(email))
                            .then(response => response.json())
                            .then(exists => {
                                if (exists) {
                                    validationDiv.innerHTML = '<i class="fas fa-times text-danger"></i> Email đã được sử dụng';
                                    emailInput.classList.add('is-invalid');
                                    emailInput.classList.remove('is-valid');
                                } else {
                                    validationDiv.innerHTML = '<i class="fas fa-check text-success"></i> Email có thể sử dụng';
                                    emailInput.classList.add('is-valid');
                                    emailInput.classList.remove('is-invalid');
                                }
                            })
                            .catch(error => {
                                validationDiv.innerHTML = '<i class="fas fa-exclamation-triangle text-warning"></i> Không thể kiểm tra email';
                            });
                    }

                    // Check password strength
                    function checkPasswordStrength() {
                        const password = document.getElementById('password').value;
                        const strengthDiv = document.getElementById('passwordStrength');

                        if (password.length === 0) {
                            strengthDiv.innerHTML = '';
                            return;
                        }

                        let strength = 0;
                        if (password.length >= 6) strength++;
                        if (password.match(/[a-z]/)) strength++;
                        if (password.match(/[A-Z]/)) strength++;
                        if (password.match(/[0-9]/)) strength++;
                        if (password.match(/[^a-zA-Z0-9]/)) strength++;

                        switch (strength) {
                            case 0:
                            case 1:
                            case 2:
                                strengthDiv.innerHTML = '<span class="strength-weak"><i class="fas fa-circle"></i> Mật khẩu yếu</span>';
                                break;
                            case 3:
                            case 4:
                                strengthDiv.innerHTML = '<span class="strength-medium"><i class="fas fa-circle"></i> Mật khẩu trung bình</span>';
                                break;
                            case 5:
                                strengthDiv.innerHTML = '<span class="strength-strong"><i class="fas fa-circle"></i> Mật khẩu mạnh</span>';
                                break;
                        }
                    }

                    // Check password match
                    function checkPasswordMatch() {
                        const password = document.getElementById('password').value;
                        const confirmPassword = document.getElementById('confirmPassword').value;
                        const matchDiv = document.getElementById('passwordMatch');
                        const confirmInput = document.getElementById('confirmPassword');

                        if (confirmPassword.length === 0) {
                            matchDiv.innerHTML = '';
                            confirmInput.classList.remove('is-valid', 'is-invalid');
                            return;
                        }

                        if (password === confirmPassword) {
                            matchDiv.innerHTML = '<i class="fas fa-check text-success"></i> Mật khẩu khớp nhau';
                            confirmInput.classList.add('is-valid');
                            confirmInput.classList.remove('is-invalid');
                        } else {
                            matchDiv.innerHTML = '<i class="fas fa-times text-danger"></i> Mật khẩu không khớp';
                            confirmInput.classList.add('is-invalid');
                            confirmInput.classList.remove('is-valid');
                        }
                    }

                    // Form submit handling
                    document.getElementById('registerForm').addEventListener('submit', function (e) {
                        const submitBtn = document.getElementById('submitBtn');
                        const submitText = document.getElementById('submitText');
                        const submitLoading = document.getElementById('submitLoading');

                        submitText.classList.add('d-none');
                        submitLoading.classList.remove('d-none');
                        submitBtn.disabled = true;
                    });

                    // Focus on first input field
                    document.addEventListener('DOMContentLoaded', function () {
                        document.getElementById('username').focus();
                    });
                </script>
            </body>

            </html>