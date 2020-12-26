<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.sql.DriverManager" %>

<%@ page import="java.sql.Connection" %>

<%@ page import="java.sql.Statement" %>

<%@ page import="java.sql.ResultSet" %>

<%@ page import = "java.sql.PreparedStatement" %>

<%@ page import="java.sql.SQLException" %>
<% request.setCharacterEncoding("utf-8"); %>
<% String ID = (String)session.getAttribute("ID"); %>
<% String IngredientID = request.getParameter("productID"); %>
<% String Name = request.getParameter("name"); %>
<% int Num = Integer.parseInt(request.getParameter("num")); %>
<% int Price = Integer.parseInt(request.getParameter("price"));  %>
<% int Sum = Num * Price; %>


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
	
		query = "Select * from 마법상회 where ID = '" + ID + "'";
		pstmt=conn.prepareStatement(query);
		rs=pstmt.executeQuery();
		rs.next();
		if(rs.getInt("소지금") < Sum) 
			response.sendRedirect("FailPurchase.jsp");
		
		else {
			query = "Update 마법상회 set 소지금 = '" + Integer.toString(rs.getInt("소지금") - Sum) + "' where ID = '" + ID + "'";
			pstmt=conn.prepareStatement(query);
			pstmt.executeUpdate();
			
			try {
				query = "Insert into 상회보유재료 values(?, ?, ?)";
				pstmt=conn.prepareStatement(query);
				pstmt.setString(1, ID);
				pstmt.setString(2, IngredientID);
				pstmt.setString(3, Integer.toString(Num));
				pstmt.executeUpdate();
			}
			catch(java.sql.SQLIntegrityConstraintViolationException e) {
				query = "Update 상회보유재료 set 보유량 = 보유량 + " + Integer.toString(Num) + " where 상회ID = '"
						+ ID + "' and 재료ID = '" + IngredientID + "'";
				pstmt=conn.prepareStatement(query);
				pstmt.executeUpdate();
			}
		
		 %>
		 	<h4>
		 	구매 성공!
		 	</h4>
			<input type="button" value="돌아가기" onClick="history.go(-2)"> 
		
	
	<% 
		}
	}catch(Exception e) {System.out.println(e);} 
	%>





</body>
</html>