<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.sql.DriverManager" %>

<%@ page import="java.sql.Connection" %>

<%@ page import="java.sql.Statement" %>

<%@ page import="java.sql.ResultSet" %>

<%@ page import = "java.sql.PreparedStatement" %>

<%@ page import = "java.util.Calendar" %>

<%@ page import="java.sql.SQLException" %>
<% request.setCharacterEncoding("utf-8"); %>
<% String ID = ((String)session.getAttribute("ID")).trim(); %>
<% String MagicID = request.getParameter("MagicID").trim(); %>


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
		
		
		query = "Insert into 소비자보유마법 values('" + ID.trim() + "', '" + MagicID.trim() + "')";
		pstmt=conn.prepareStatement(query);
		pstmt.executeUpdate();
		
		query = "Select * from 마법, 마법상회, 마법사, 소비자 where 마법.제작마법사ID = 마법사.ID and 마법사.소속상회ID = 마법상회.ID"
				+ " and 마법.ID = '" + MagicID.trim() + "' and 소비자.ID = '" + ID + "'";
		pstmt=conn.prepareStatement(query);
		rs=pstmt.executeQuery();
		rs.next();
		
		String MagicianID = rs.getString("마법사.ID");
		String FirmID = rs.getString("마법상회.ID");
		double Price = rs.getInt("마법.판매가격");
		String MagicProperty = rs.getString("마법.속성");
		String ConsumerProperty = rs.getString("소비자.속성");
		
		if(MagicProperty.equals(ConsumerProperty)) 
			Price = (int)(Price * 0.9);
		
		query = "Update 소비자 set 소지금 = 소지금 - " + Integer.toString((int)Price) + " where ID = '" + ID + "'";
		pstmt=conn.prepareStatement(query);
		pstmt.executeUpdate();
		
		query = "Update 마법상회 set 소지금 = 소지금 + " + Integer.toString((int)Math.round(Price/2.0)) + " where ID = '" + FirmID.trim() + "'";
		pstmt=conn.prepareStatement(query);
		pstmt.executeUpdate();
		
		query = "Update 마법사 set 자금 = 자금 + " + Integer.toString((int)(Price/2.0)) + " where ID = '" + MagicianID.trim() + "'";
		pstmt=conn.prepareStatement(query);
		pstmt.executeUpdate();
		
		java.util.Date utilDate = new java.util.Date();
		java.sql.Timestamp sqlDate = new java.sql.Timestamp(utilDate.getTime());
		query = "Insert into 고객마법거래정보 values('" + FirmID + "', '" + ID + "', '" + MagicID + "', '"
				+ sqlDate + "', '" + Integer.toString((int)Price) + "')"; 
		pstmt=conn.prepareStatement(query);
		pstmt.executeUpdate();
		
		 %>
		 	<h4>
		 	구매 성공! <br>
		 	가격: <%=(int)Price %>
		 	</h4>
			<input type="button" value="돌아가기" onClick="window.close()"> 
	
		<% 
	}catch(Exception e) {
		
		%>
			<h5> 해당 마법을 이미 구매하셨거나, </h5>
			<h5> 자금이 부족한 건 아닌지 다시 확인해 주세요.</h5>
			<input type="button" value = "돌아가기" onClick="window.close()">
		<%
		
	} 
	%>





</body>
</html>