<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.sql.DriverManager" %>

<%@ page import="java.sql.Connection" %>

<%@ page import="java.sql.Statement" %>

<%@ page import="java.sql.ResultSet" %>

<%@ page import = "java.sql.PreparedStatement" %>

<%@ page import="java.sql.SQLException" %>
<% request.setCharacterEncoding("utf-8"); %>
<% String MagicianID = (String)session.getAttribute("ID"); %>
<% String FirmID = request.getParameter("ID"); %>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Insert title here</title>
</head>
<body>
<%
Connection conn=null;

PreparedStatement pstmt=null;

ResultSet rs=null;

boolean fail = false;

try{
		response.setContentType("text/html; charset=utf-8");
		String jdbcDriver ="jdbc:mariadb://localhost:3306/lodos?useUnicode=true&characterEncoding=UTF-8";
		
		String dbUser="root";
		
		String dbPass="31337";
		
		String query = null;
		
		conn=DriverManager.getConnection(jdbcDriver,dbUser,dbPass);
		
		
			query = "Insert into 거래처 values('" + MagicianID + "', '" + FirmID + "')";
			pstmt=conn.prepareStatement(query);
			pstmt.executeUpdate();
		
		 %>
		 	<h4>
		 	등록에 성공했습니다!
		 	</h4>
			<input type="button" value="돌아가기" onClick="history.go(-2)"> 
		
	
	<% 
	}catch(Exception e) {
	%>
		<h4>
		이미 등록되어 있는 상회입니다.
		</h4>
		<input type="button" value="돌아가기" onClick="history.go(-2)"> 
	<%
	} 
	%>





</body>
</html>