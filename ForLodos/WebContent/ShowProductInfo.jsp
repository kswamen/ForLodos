<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.sql.DriverManager" %>

<%@ page import="java.sql.Connection" %>

<%@ page import="java.sql.Statement" %>

<%@ page import="java.sql.ResultSet" %>

<%@ page import = "java.sql.PreparedStatement" %>

<%@ page import="java.sql.SQLException" %>
<% request.setCharacterEncoding("utf-8"); %>
<% String ID = request.getParameter("ProductID").toString(); %>

<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
</head>
<body>
<% 
	String jdbcDriver ="jdbc:mariadb://localhost:3306/lodos";
	
	String dbUser="root";

    String dbPass="31337";
    
    String query = null;
    
    
	    Connection conn=null;
	
	    PreparedStatement pstmt=null;
	
	    ResultSet rs=null;
	    
	    conn=DriverManager.getConnection(jdbcDriver,dbUser,dbPass);
	    
	    try{
	    	
		    query="select * from 재료 where ID=?";
		
		     pstmt=conn.prepareStatement(query);
		     pstmt.setString(1, ID.trim());
		     rs=pstmt.executeQuery();
		     rs.next();
		     
		     
		     %>
		     <h5>재료 ID : <%=rs.getString("ID")%></h5>
		     <h5>이름 : <%=rs.getString("이름")%></h5>
		     <h5>원산지 : <%=rs.getString("원산지")%></h5>
		     <h5>종류 : <%=rs.getString("종류")%></h5>
		     <h5>가격 : <%=rs.getString("가격")%></h5>
		     <% 
		     
		    }catch(Exception e) {System.out.println(e);}
%>
</body>
</html>