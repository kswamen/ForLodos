<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
</head>
<body>

    <%
    session.invalidate();
    // 2: 로그인 페이지로 이동시킴.
    response.sendRedirect("Login.jsp");
	%>
	

</body>
</html>