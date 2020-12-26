<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.sql.DriverManager" %>

<%@ page import="java.sql.Connection" %>

<%@ page import="java.sql.Statement" %>

<%@ page import="java.sql.ResultSet" %>

<%@ page import = "java.sql.PreparedStatement" %>

<%@ page import="java.sql.SQLException" %>
<% request.setCharacterEncoding("utf-8"); %>
<% String FirmID = (String)session.getAttribute("ID"); %>
<% String MagicianID = request.getParameter("ID"); %>

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
		
		query = "Select * from 마법상회 where ID = '" + FirmID + "'";
		pstmt=conn.prepareStatement(query);
		rs=pstmt.executeQuery();
		rs.next();
		
		String PropertyAccessed = rs.getString("거래허가속성");
		
		query = "Select * from 마법사 where 마법사.ID = '" + MagicianID + "'";
		pstmt=conn.prepareStatement(query);
		rs=pstmt.executeQuery();
		rs.next();
		
		if(!PropertyAccessed.equals(rs.getString("속성"))) {
			response.sendRedirect("FailEnrollMagician.jsp");
			return;
		}
		
		query = "Select * from 마법사, 마법상회 where 마법사.ID = '" + MagicianID + "' and 마법상회.ID = '" + FirmID + "'";
		pstmt=conn.prepareStatement(query);
		rs=pstmt.executeQuery();
		rs.next();
		
		if(rs.getInt("마법사.클래스") > rs.getInt("마법상회.거래허가클래스")) {
			response.sendRedirect("FailEnrollMagician.jsp");
			return;
		}
		
		
			query = "Update 마법사 set 소속상회ID = '" + FirmID + "' where ID = '" + MagicianID + "'";
			pstmt=conn.prepareStatement(query);
			pstmt.executeUpdate();
			
		
		 %>
		 	<h4>
		 	등록에 성공했습니다!
		 	</h4>
			<input type="button" value="돌아가기" onClick="history.go(-2)"> 
		
	
	<% 
	}catch(Exception e) {System.out.println(e);} 
	%>





</body>
</html>