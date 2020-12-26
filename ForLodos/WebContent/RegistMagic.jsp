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
<% String Desc = request.getParameter("desc"); %>
<% String Class = request.getParameter("class"); %>
<% String Property = request.getParameter("property"); %>
<% String Kind = request.getParameter("kind"); %>
<% String Amount = request.getParameter("amount"); %>
<% String ManaConsume = request.getParameter("manaconsume"); %>
<% String Price = request.getParameter("price"); %>
<% String MagicianID = request.getParameter("magicianID"); %>
<% String IngredientID = request.getParameter("ingredientID"); %>
<% String Need = request.getParameter("need"); %>


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
	
	String MagicianName = null;
	
	String MagicianClass = null;
	
	boolean isOK = false;
	
	
	conn=DriverManager.getConnection(jdbcDriver,dbUser,dbPass);
	
	query = "Select * from 마법사 where ID = '" + MagicianID + "';";
	pstmt=conn.prepareStatement(query);
	rs=pstmt.executeQuery();
	rs.next();
	MagicianName = rs.getString("이름");
	MagicianClass = rs.getString("클래스");	
	 
	query = "SELECT * from 마법";
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
	
	if(Integer.parseInt(MagicianClass) >= Integer.parseInt(Class)) {
		query = "Insert into 마법 values(?,?,?,?,?,?,?,?,?,?)";
		pstmt=conn.prepareStatement(query);
		
		pstmt.setString(1, ID);
		 pstmt.setString(2, Name);
		 pstmt.setString(3, Desc);
		 pstmt.setString(4, Class);
		 pstmt.setString(5, Property);
		 pstmt.setString(6, Kind);
		 pstmt.setString(7, Amount);
		 pstmt.setString(8, ManaConsume);
		 pstmt.setString(9, Price);
		 pstmt.setString(10, MagicianID);
		 
		 pstmt.executeUpdate();
		 
		 query = "Insert into 마법의재료 values(?, ?, ?)";
		 pstmt=conn.prepareStatement(query);
			
		 pstmt.setString(1, ID);
	     pstmt.setString(2, IngredientID);
		 pstmt.setString(3, Need);
			 
		 pstmt.executeUpdate();

		 %>
		 	<h3>새로운 마법 등록에 성공했습니다.  </h3>
		 	<h4>
		 	아이디 : <%= ID%> <br>
		 	이름 :  <%=Name %> <br>
		 	설명 : <%=Desc %> <br>
		 	클래스 : <%=Class %> <br>
		 	속성 : <%= Property %> <br>
		 	종류 : <%= Kind %> <br>
		 	효과량 : <%= Amount %> <br>
		 	마나 소모량 : <%= ManaConsume %> <br>
		 	가격 : <%= Price %> <br>
		 	제작 마법사 : <%= MagicianName %> <br>
		 	</h4>
			<input type="button" value="돌아가기" onClick="history.go(-1)"> 
		<% 
	}
	
	else {
		response.sendRedirect("RegistMagicFail.jsp");
	}
	
	
	
		}catch(Exception e) {System.out.println(e);} 
	%>





</body>
</html>