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
    // 2: �α��� �������� �̵���Ŵ.
    response.sendRedirect("Login.jsp");
	%>
	

</body>
</html>