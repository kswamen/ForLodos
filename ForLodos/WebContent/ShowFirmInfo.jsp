<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.sql.DriverManager" %>

<%@ page import="java.sql.Connection" %>

<%@ page import="java.sql.Statement" %>

<%@ page import="java.sql.ResultSet" %>

<%@ page import = "java.sql.PreparedStatement" %>

<%@ page import="java.sql.SQLException" %>
<% request.setCharacterEncoding("utf-8"); %>
<% String ID = request.getParameter("FirmID"); %>
<% String CustomerID = request.getParameter("CustomerID"); %>

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
	    	
		    query="select * from 마법상회 where ID=?";
		
		     pstmt=conn.prepareStatement(query);
		     pstmt.setString(1, ID.trim());
		     rs=pstmt.executeQuery();
		     rs.next();
		     
		     
		     %>
		     <h5>마법상회 ID : <%=rs.getString("ID")%></h5>
		     <h5>상호 : <%=rs.getString("상호")%></h5>
		     <h5>거래허가속성 : <%=rs.getString("거래허가속성")%></h5>
		     <h5>주소 : <%=rs.getString("주소")%></h5>
		     <h5>대표자이름 : <%=rs.getString("대표자이름")%></h5>
		     <input type = "Button" value = "해당 거래처 제거" onClick = "DeleteFirm();">
		     <% 
		     
		    }catch(Exception e) {System.out.println(e);}
%>
<script>
	var opener = window.dialogArguments;
	function DeleteFirm() {
		<%
			query = "Delete From 거래처 where 상회ID = '" + ID.trim() + "' and 소비자ID = '" + CustomerID.trim() + "'";
			 pstmt=conn.prepareStatement(query);
		     pstmt.executeUpdate();
		%>
		self.close();
		opener.document.location.reload();
	}
</script>
</body>
</html>