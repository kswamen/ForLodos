<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.sql.DriverManager" %>

<%@ page import="java.sql.Connection" %>

<%@ page import="java.sql.Statement" %>

<%@ page import="java.sql.ResultSet" %>

<%@ page import = "java.sql.PreparedStatement" %>

<%@ page import="java.sql.SQLException" %>
<% request.setCharacterEncoding("utf-8"); %>
<% String ID = request.getParameter("ID"); %>
<% String Name = request.getParameter("name"); %>
<% String Address = request.getParameter("address"); %>
<% String Representative = request.getParameter("representative"); %>
<% String PropertyAccessed = request.getParameter("propertyAccessed"); %>
<% String Money = request.getParameter("money"); %>
<% String ClassAccessed = request.getParameter("classAccessed"); %>


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
	
	String FirmProperty = null;
	
	query = "Update 마법상회 set 상호 = ?, 주소 = ?, 대표자이름 = ?, 소지금 = ?, 거래허가클래스= ? where ID = '" + ID + "'";
	
	conn=DriverManager.getConnection(jdbcDriver,dbUser,dbPass);
	pstmt=conn.prepareStatement(query);
	pstmt.setString(1, Name);
	pstmt.setString(2, Address);
	pstmt.setString(3, Representative);
	pstmt.setString(4, Money);
	pstmt.setString(5, ClassAccessed);

	pstmt.executeUpdate();
	 %>
	 	<h3>정보 변경에 성공했습니다.  </h3>
	 	<h4>
	 	아이디 : <%= ID%> <br>
	 	상호 :  <%=Name %> <br>
	 	주소 : <%=Address %> <br>
	 	대표자이름 : <%=Representative %> <br>
	 	소지금 : <%= Money %> <br>
	 	거래허가속성 : <%= PropertyAccessed %> <br>
	 	거래허가클래스 : <%= ClassAccessed %> <br>
	 	</h4>
		<input type="button" value="돌아가기" onClick="history.go(-1)"> 
	<% 
		}catch(Exception e) {System.out.println(e);} 
	%>





</body>
</html>