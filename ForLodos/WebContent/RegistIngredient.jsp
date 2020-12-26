<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.sql.DriverManager" %>

<%@ page import="java.sql.Connection" %>

<%@ page import="java.sql.Statement" %>

<%@ page import="java.sql.ResultSet" %>

<%@ page import = "java.sql.PreparedStatement" %>

<%@ page import="java.sql.SQLException" %>
<% request.setCharacterEncoding("utf-8"); %>
<% String Name = request.getParameter("name"); %>
<% String Origin = request.getParameter("origin"); %>
<% String Kind = request.getParameter("kind"); %>
<% String Price = request.getParameter("price"); %>


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
	
	String ID = null;

	boolean isOK = false;
	
	
	conn=DriverManager.getConnection(jdbcDriver,dbUser,dbPass);
		
	 
	query = "SELECT * from 재료";
	pstmt=conn.prepareStatement(query);
	rs=pstmt.executeQuery();
	
	for(int i=0; i<10000; i++) {
 		String temp = Integer.toString(i);
	 	while(rs.next()) {
			if(rs.getString("ID").equals(temp)) {
				isOK = false;
				break;
			}
			else {
				isOK = true;
				continue;
			}
		}
	 	rs.first();
		if(isOK == true) {
			ID = temp;
			break;
		}
	}	
	
	
		query = "Insert into 재료 values(?,?,?,?,?)";
		pstmt=conn.prepareStatement(query);
		
		pstmt.setString(1, ID);
		 pstmt.setString(2, Name);
		 pstmt.setString(3, Origin);
		 pstmt.setString(4, Kind);
		 pstmt.setString(5, Price);
		 
		 pstmt.executeUpdate();
		 

		 %>
		 	<h3>새로운 재료 등록에 성공했습니다.  </h3>
		 	<h4>
		 	아이디 : <%= ID%> <br>
		 	이름 :  <%=Name %> <br>
		 	원산지 : <%= Origin %> <br>
		 	종류 : <%= Kind %> <br>
		 	가격 : <%= Price %> <br>
		 	
		 	</h4>
			<input type="button" value="돌아가기" onClick="history.go(-1)"> 
		<% 
	
		}catch(Exception e) {System.out.println(e);} 
	%>





</body>
</html>