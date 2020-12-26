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
<% String ProductID = request.getParameter("ProductID").trim(); %>
<% String FirmID = request.getParameter("FirmID").trim(); %>
<% String num = request.getParameter("num").trim(); %>


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
		
		if(Integer.parseInt(num) <= 0)
			throw null;
		
		response.setContentType("text/html; charset=utf-8");
		String jdbcDriver ="jdbc:mariadb://localhost:3306/lodos?useUnicode=true&characterEncoding=UTF-8";
		
		String dbUser="root";
		
		String dbPass="31337";
		
		String query = null;
		
		conn=DriverManager.getConnection(jdbcDriver,dbUser,dbPass);
		
		query = "Select * from 재료 where ID = '" + ProductID + "'";
		pstmt=conn.prepareStatement(query);
		rs=pstmt.executeQuery();
		rs.next();
		
		int Price = rs.getInt("가격");
		int Sum = Price * Integer.parseInt(num);
		
		query = "Update 소비자 set 소지금 = 소지금 - '" + Sum + "' where ID = '" + ID + "'";
		pstmt=conn.prepareStatement(query);
		pstmt.executeUpdate();
		
		query = "Update 상회보유재료 set 보유량 = 보유량 - '" + num + "' where 재료ID = '" + ProductID + "' and 상회ID = '" + FirmID + "'";
		pstmt=conn.prepareStatement(query);
		pstmt.executeUpdate();
		
		query = "Update 마법상회 set 소지금 = 소지금 + '" + Sum + "' where ID = '" + FirmID + "'";
		pstmt=conn.prepareStatement(query);
		pstmt.executeUpdate();
		
		try{
			query = "Insert into 소비자보유재료 values('" + ID.trim() + "', '" + ProductID.trim() + "', '" + num + "')";
			pstmt=conn.prepareStatement(query);
			pstmt.executeUpdate();
		}catch(Exception e) {
			query = "Update 소비자보유재료 set 보유량 = 보유량 + '" + num + "' where 재료ID = '" + ProductID + "'";
			pstmt=conn.prepareStatement(query);
			pstmt.executeUpdate();
		}
		
		java.util.Date utilDate = new java.util.Date();
		java.sql.Timestamp sqlDate = new java.sql.Timestamp(utilDate.getTime());
		
		query = "Insert into 고객재료거래정보 values('" + FirmID.trim() + "', '" + ID.trim() + "', '" + ProductID 
				+ "', '" + num + "', '" + sqlDate + "', '" + Integer.toString(Sum) +"')";
		pstmt=conn.prepareStatement(query);
		pstmt.executeUpdate();

		 %>
		 	<h4>
		 	구매 성공! <br>
		 	</h4>
			<input type="button" value="돌아가기" onClick="window.close()"> 
	
		<% 
	}catch(Exception e) {
		%>
			<h5> 구매가 불가능합니다. </h5>
			<h5> 해당 상회가 보유한 재고수를 초과하여 구매를 시도했거나,</h5>
			<h5> 자금이 부족한 건 아닌지 다시 확인해 주세요.</h5>
			<input type="button" value = "돌아가기" onClick="window.close()">
		<%
	} 
	%>





</body>
</html>