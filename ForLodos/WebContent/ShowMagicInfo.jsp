<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.sql.DriverManager" %>

<%@ page import="java.sql.Connection" %>

<%@ page import="java.sql.Statement" %>

<%@ page import="java.sql.ResultSet" %>

<%@ page import = "java.sql.PreparedStatement" %>

<%@ page import="java.sql.SQLException" %>
<% request.setCharacterEncoding("utf-8"); %>
<% String ID = request.getParameter("MagicID"); %>

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
	    	
		    query="select * from 마법 where ID=?";
		
		     pstmt=conn.prepareStatement(query);
		     pstmt.setString(1, ID.trim());
		     rs=pstmt.executeQuery();
		     rs.next();
		     
		     
		     %>
		     <h5>마법 ID : <%=rs.getString("ID")%></h5>
		     <h5>마법명 : <%=rs.getString("이름")%></h5>
		     <h5>설명 : <%=rs.getString("설명")%></h5>
		     <h5>클래스 : <%=rs.getString("클래스")%></h5>
		     <h5>속성 : <%=rs.getString("속성")%></h5>
		     <h5>종류 : <%=rs.getString("종류")%></h5>
		     <h5>효과량 : <%=rs.getString("효과량")%></h5>
		     <h5>마나소비량 : <%=rs.getString("마나소비량")%></h5>
		     <% 
		     
		    }catch(Exception e) {System.out.println(e);}
%>
<script>
	
</script>
</body>
</html>