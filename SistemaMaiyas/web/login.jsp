<%-- 
    Document   : login.jsp
    Created on : 02-18-2026, 08:32:10 PM
    Author     : Karol
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %> 
<!DOCTYPE html>
<html>
<head>
    <title>Login - Soluciones Maiyas</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <style>
        /* Fondo corporativo elegante */
        body {
            background: linear-gradient(135deg, #e0f7ff, #ccefff);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        /* Tarjeta login */
        .card-login {
            width: 400px;
            background: #ffffffdd;
            padding: 45px 35px;
            border-radius: 20px;
            box-shadow: 0 20px 50px rgba(0,0,0,0.15);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .card-login:hover {
            transform: translateY(-5px);
            box-shadow: 0 30px 60px rgba(0,0,0,0.2);
        }

        /* Logo */
        .logo-container {
            text-align: center;
        }
        .logo-container img {
            width: 180px;
            border-radius: 18px;
            transition: transform 0.3s ease;
        }
        .logo-container img:hover {
            transform: scale(1.05);
        }

        /* Título */
        .text-title {
            text-align: center;
            font-size: 2rem;
            font-weight: 700;
            color: #0099cc;
            margin-bottom: 30px;
        }

        /* Inputs con icono */
        .input-group-text {
            background-color: #0099cc;
            color: white;
            border-radius: 12px 0 0 12px;
            border: none;
        }
        .form-control {
            border-radius: 0 12px 12px 0;
            border: 1px solid #0099cc;
            transition: all 0.3s;
        }
        .form-control:focus {
            border-color: #0077aa;
            box-shadow: 0 0 10px rgba(0,153,204,0.3);
            outline: none;
        }
        .input-group {
            margin-bottom: 20px;
        }

        /* Botón login premium */
        .btn-login {
            width: 100%;
            background: linear-gradient(90deg, #00bfff, #007acc);
            color: white;
            font-weight: 600;
            padding: 12px 0;
            border-radius: 12px;
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(0,191,255,0.4);
        }
        .btn-login:hover {
            background: linear-gradient(90deg, #007acc, #00bfff);
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0,191,255,0.6);
        }

        /* Mensaje de error */
        .text-danger {
            font-size: 0.9rem;
            text-align: center;
            margin-top: 10px;
        }

        /* Responsive */
        @media (max-width: 480px) {
            .card-login {
                width: 90%;
                padding: 30px 20px;
            }
            .text-title {
                font-size: 1.6rem;
            }
        }
    </style>
</head>
<body>
<div class="card-login shadow">
    <div class="logo-container">
        <img src="images/logo_maiyas.png" alt="Logo Maiyas">
    </div>
    <h1 class="text-title">Soluciones Maiyas</h1>
    <form action="LoginServlet" method="post">
        <div class="input-group">
            <span class="input-group-text"><i class="fa fa-user"></i></span>
            <input type="text" name="usuario" class="form-control" placeholder="Usuario" required>
        </div>
        <div class="input-group">
            <span class="input-group-text"><i class="fa fa-lock"></i></span>
            <input type="password" id="password" name="password" class="form-control" placeholder="Contraseña" required>
            <span class="input-group-text" style="cursor:pointer;" onclick="togglePassword()">
                <i id="toggleIcon" class="fa fa-eye-slash"></i>
            </span>
        </div>
        <button class="btn btn-login">Ingresar</button>
    </form>
    <p class="text-danger">
        <%= request.getParameter("error") != null ? request.getParameter("error") : "" %>
    </p>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/js/all.min.js"></script>

<script>
function togglePassword() {
    const passwordInput = document.getElementById('password');
    const toggleIcon = document.getElementById('toggleIcon');

    if (passwordInput.type === 'password') {
        passwordInput.type = 'text';
        toggleIcon.classList.remove('fa-eye-slash');
        toggleIcon.classList.add('fa-eye'); // visible = ojo
    } else {
        passwordInput.type = 'password';
        toggleIcon.classList.remove('fa-eye');
        toggleIcon.classList.add('fa-eye-slash'); // oculta = ojo con pleca
    }
}
</script>

</body>
</html>