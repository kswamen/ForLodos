<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.sql.DriverManager" %>

<%@ page import="java.sql.Connection" %>

<%@ page import="java.sql.Statement" %>

<%@ page import="java.sql.ResultSet" %>

<%@ page import = "java.sql.PreparedStatement" %>

<%@ page import="java.sql.SQLException" %>
<% request.setCharacterEncoding("utf-8"); %>
<% String ID = request.getParameter("MagicianID"); %>

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
	    	
		    query="select * from 마법사 where ID=?";
		
		     pstmt=conn.prepareStatement(query);
		     pstmt.setString(1, ID.trim());
		     rs=pstmt.executeQuery();
		     rs.next();
		     
		     
		     %>
		     <h5>마법사 ID : <%=rs.getString("ID")%></h5>
		     <h5>이름 : <%=rs.getString("이름")%></h5>
		     <h5>나이 : <%=rs.getString("나이")%></h5>
		     <h5>종족 : <%=rs.getString("종족")%></h5>
		     <h5>출신지 : <%=rs.getString("출신지")%></h5>
		     <h5>직업 : <%=rs.getString("직업")%></h5>
		     <h5>클래스 : <%=rs.getString("클래스")%></h5>
		     <h5>속성 : <%=rs.getString("속성")%></h5>
		     <h5>마나량 : <%=rs.getString("마나량")%></h5>
		     <h5>자금 : <%=rs.getString("자금")%></h5>
		     <input type = "Button" value = "해당 마법사 제거" onClick = "DeleteMagician();">
		     <% 
		     
		    }catch(Exception e) {System.out.println(e);}
%>
<script>
	var opener = window.dialogArguments;
	function DeleteMagician() {
		<%
			query = "Update 마법사 set 소속상회ID = NULL where ID = '" + rs.getString("ID") + "'";
			 pstmt=conn.prepareStatement(query);
		     pstmt.executeUpdate();
		%>
		self.close();
		opener.document.location.reload();
	}
</script>
</body>
</html>