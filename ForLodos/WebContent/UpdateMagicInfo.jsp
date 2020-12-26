<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.sql.DriverManager" %>

<%@ page import="java.sql.Connection" %>

<%@ page import="java.sql.Statement" %>

<%@ page import="java.sql.ResultSet" %>

<%@ page import = "java.sql.PreparedStatement" %>

<%@ page import="java.sql.SQLException" %>
<% request.setCharacterEncoding("utf-8"); %>
<% String ID = request.getParameter("ID"); %>
<% String Name = request.getParameter("name"); %>
<% String Desc = request.getParameter("desc"); %>
<% String Class = request.getParameter("class"); %>
<% String Property = request.getParameter("property"); %>
<% String Kind = request.getParameter("kind"); %>
<% String Amount = request.getParameter("amount"); %>
<% String ManaConsume = request.getParameter("manaconsume"); %>
<% String Price = request.getParameter("price"); %>

<% String IngredientID = request.getParameter("ingredientID"); %>
<% String Need = request.getParameter("need"); %>
<% String MagicianID = (String)session.getAttribute("ID"); %>


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
	
	
		query = "Update 마법 set 이름 = ?, 설명 = ?, 클래스 = ?, 속성 = ?, 종류 = ?, 효과량 = ?, 마나소비량 = ?, 판매가격 = ?, 제작마법사ID = ?  where ID =?;";
		pstmt=conn.prepareStatement(query);
		
		 pstmt.setString(1, Name.trim());
		 
		 pstmt.setString(2, Desc.trim());
		 pstmt.setString(3, Class.replaceAll(" ", ""));
		 pstmt.setString(4, Property.replaceAll(" ", ""));
		 pstmt.setString(5, Kind.replaceAll(" ", ""));
		 pstmt.setString(6, Amount.replaceAll(" ", ""));
		 pstmt.setString(7, ManaConsume.replaceAll(" ", ""));
		 pstmt.setString(8, Price.replaceAll(" ", ""));
		 pstmt.setString(9, MagicianID.replaceAll(" ", ""));
		 pstmt.setString(10, ID.replaceAll(" ", ""));
		 
		 pstmt.executeUpdate();
		
		 query = "UPDATE 마법의재료 SET 재료ID = ?, 투입량 = ? WHERE 마법ID = ?;"; 
		 pstmt=conn.prepareStatement(query);
		 
		 pstmt.setString(1, IngredientID);
		 pstmt.setString(2, Need);
		 pstmt.setString(3, ID.replaceAll(" ", ""));
		 pstmt.executeUpdate();
		
		 %>
		 	<h3>마법 정보 수정에 성공했습니다.  </h3>
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
		 	재료 ID : <%= IngredientID %> <br>
		 	투입량 : <%= Need %>
		 	</h4>
			<input type="button" value="돌아가기" onClick="history.go(-2)"> 
		
	
	<% 
		}catch(Exception e) {System.out.println(e);} 
	%>





</body>
</html>