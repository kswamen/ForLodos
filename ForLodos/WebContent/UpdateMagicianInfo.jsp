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
<% String Age = request.getParameter("age"); %>
<% String Tribe = request.getParameter("tribe"); %>
<% String Hometown = request.getParameter("hometown"); %>
<% String Job = request.getParameter("job"); %>
<% String Class = request.getParameter("class"); %>
<% String Property = request.getParameter("property"); %>
<% String Mana = request.getParameter("mana"); %>
<% String Money = request.getParameter("money"); %>
<% String FirmID = request.getParameter("FirmID"); %>

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

String FirmProperty = null;

String FirmClass = null;

query = "SELECT * from 마법상회 WHERE ID = '" + FirmID + "';";

conn=DriverManager.getConnection(jdbcDriver,dbUser,dbPass);
pstmt=conn.prepareStatement(query);
rs=pstmt.executeQuery();
rs.next();
FirmProperty = rs.getString("거래허가속성");
FirmClass = rs.getString("거래허가클래스");

if(!Property.equals(FirmProperty)) {
		response.sendRedirect("FailUpdate.jsp");
		return;
}

else if(Integer.parseInt(Class) > Integer.parseInt(FirmClass)) {
	response.sendRedirect("FailUpdate.jsp");
	return;
}


	query = "UPDATE 마법사 SET 이름 = ?, 나이 = ?, 종족 = ?, 출신지 = ?, 직업 = ?, 클래스 = ?,"
			+ " 속성 = ?, 마나량 = ?, 자금 = ?, 소속상회ID = ? WHERE ID = ?;";

	 
	 pstmt=conn.prepareStatement(query); 
	 pstmt.setString(1, Name);
	 pstmt.setString(2, Age);
	 pstmt.setString(3, Tribe);
	 pstmt.setString(4, Hometown);
	 pstmt.setString(5, Job);
	 pstmt.setString(6, Class);
	 pstmt.setString(7, Property);
	 pstmt.setString(8, Mana);
	 pstmt.setString(9, Money);
	 pstmt.setString(10, FirmID);
	 pstmt.setString(11, ID);

	 pstmt.executeUpdate();


	 %>
	 	<h3>정보 변경에 성공했습니다.  </h3>
	 	<h4>
	 	아이디 : <%= ID%> <br>
	 	이름 :  <%=Name %> <br>
	 	나이 : <%=Age %> <br>
	 	종족: : <%=Tribe %> <br>
	 	출신지 : <%= Hometown %> <br>
	 	직업 : <%= Job %> <br>
	 	클래스 : <%= Class %> <br>
	 	속성 : <%= Property %> <br>
	 	마나 : <%= Mana %> <br>
	 	보유 자금 : <%= Money %> <br>
	 	소속 상회 : <%= FirmID %> <br>
	 	</h4>
		<input type="button" value="돌아가기" onClick="history.go(-1)"> 
	<% 
		}catch(Exception e) {System.out.println(e);} 
	%>





</body>
</html>