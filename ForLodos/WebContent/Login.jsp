<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Insert title here</title>
</head>
<body>
	<h3>로도스 왕국 상업 및 유통 시스템에 접속하신 걸 환영합니다.</h3> <br>
	<form action = "session_Login.jsp" method = "post">
		<label> ID: </label>
		<input name = "id" type = "text"> <br>
		
		<label> PW: </label>
		<input name = "pwd" type = "password"> <br>
		
		<input type = "submit" value = "로그인">
	</form>
	<form action = "SignUp.jsp" method = "post">
		<input type = "submit" value = "회원가입">
	</form>
</body>
</html>