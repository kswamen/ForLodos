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
<% String PW = request.getParameter("pwd"); %>
<% String Age = request.getParameter("age"); %>
<% String Tribe = request.getParameter("tribe"); %>
<% String Hometown = request.getParameter("hometown"); %>
<% String Job = request.getParameter("job"); %>
<% String Class = request.getParameter("class"); %>
<% String Property = request.getParameter("property"); %>
<% String Mana = request.getParameter("mana"); %>
<% String Money = request.getParameter("money"); %>
<% String FirmName = request.getParameter("FirmName"); %>

<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
</head>
<body>

<%
Connection conn=null;

PreparedStatement pstmt=null;

ResultSet rs=null;

String ID = null;
String FirmID = null;

boolean isOK = false;

try{
response.setContentType("text/html; charset=utf-8");
String jdbcDriver ="jdbc:mariadb://localhost:3306/lodos?useUnicode=true&characterEncoding=UTF-8";

String dbUser="root";

String dbPass="31337";

String query = "select * from 마법사";

 //2.데이터 베이스 커넥션 생성

 conn=DriverManager.getConnection(jdbcDriver,dbUser,dbPass);
 pstmt=conn.prepareStatement(query);
 rs=pstmt.executeQuery();
 
	
 	for(int i=0; i<10000; i++) {
 		String temp = null;
	 	temp = "M" + String.format("%04d", i);
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

 	query = "Select 거래허가속성, ID from 마법상회 Where 상호 = '" + FirmName + "'";
 	pstmt=conn.prepareStatement(query);
 	rs=pstmt.executeQuery();
 	
 	while(rs.next()) {
 		if(!Property.equals(rs.getString("거래허가속성"))) {
 	 		response.sendRedirect("FailSignUp.jsp");
 	 		return;
 	 	}
 		FirmID = rs.getString("ID");
 	}
 	
 	query = "Select * from 마법상회 Where ID = '" + FirmID + "'";
 	pstmt=conn.prepareStatement(query);
 	rs=pstmt.executeQuery();
 	
 	while(rs.next()) {
 		if(Integer.parseInt(Class) > Integer.parseInt(rs.getString("거래허가클래스"))) {
 	 		response.sendRedirect("FailSignUp.jsp");
 	 		return;
 	 	}
 	}
 	
 	/*
 	query = "Select * from 마법상회 Where 상호 = '" + FirmName + "'";
 	pstmt=conn.prepareStatement(query);
 	rs=pstmt.executeQuery();
 	rs.next();
 	
 	FirmID = rs.getString("ID");
 	*/
 //3.Statement 생성
 query = "insert into 마법사 values(?, ?, AES_ENCRYPT(?, SHA2('key', 512)), ?, ?, ?, ?, ?, ?, ?, ?, ?);";
 pstmt=conn.prepareStatement(query);
 pstmt.setString(1, ID);
 pstmt.setString(2, Name);
 pstmt.setString(3, PW);
 pstmt.setString(4, Age);
 pstmt.setString(5, Tribe);
 pstmt.setString(6, Hometown);
 pstmt.setString(7, Job);
 pstmt.setString(8, Class);
 pstmt.setString(9, Property);
 pstmt.setString(10, Mana);
 pstmt.setString(11, Money);
 pstmt.setString(12, FirmID);

 pstmt.executeQuery();
 %>
 	<h3>저장 완료!  </h3>
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
 	소속 상회 : <%= FirmName %> <br>
 	</h4>
	<a href="Login.jsp">로그인 페이지로 돌아가기</a>
<% 
	}catch(Exception e) {System.out.println(e);}
%>



</body>
</html>