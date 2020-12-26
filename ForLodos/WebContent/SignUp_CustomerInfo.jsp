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
<% String Address = request.getParameter("address"); %>
<% String Property = request.getParameter("property"); %>
<% String Money = request.getParameter("money"); %>

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

String query = "select * from 소비자";

 //2.데이터 베이스 커넥션 생성

 conn=DriverManager.getConnection(jdbcDriver,dbUser,dbPass);
 pstmt=conn.prepareStatement(query);
 rs=pstmt.executeQuery();
 
	
 	for(int i=0; i<10000; i++) {
 		String temp = null;
	 	temp = "C" + String.format("%04d", i);
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

 	
 	
 //3.Statement 생성
 query = "insert into 소비자 values(?, ?, AES_ENCRYPT(?, SHA2('key', 512)), ?, ?, ?, ?);";
 pstmt=conn.prepareStatement(query);
 pstmt.setString(1, ID);
 pstmt.setString(2, Name);
 pstmt.setString(3, PW);
 pstmt.setString(4, Age);
 pstmt.setString(5, Address);
 pstmt.setString(6, Property);
 pstmt.setString(7, Money);

 pstmt.executeQuery();
 %>
 	<h3>저장 완료!  </h3>
 	<h4>
 	아이디 : <%= ID%> <br>
 	이름 :  <%=Name %> <br>
 	나이 : <%=Age %> <br>
 	주소: : <%=Address %> <br>
 	속성 : <%= Property %> <br>
 	보유 자금 : <%= Money %> <br>
 	
 	</h4>
	<a href="Login.jsp">로그인 페이지로 돌아가기</a>
<% 
	}catch(Exception e) {System.out.println(e);}
%>



</body>
</html>