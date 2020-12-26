<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" errorPage = "SessionFinished.jsp" %>

<%@ page import="java.sql.DriverManager" %>

<%@ page import="java.sql.Connection" %>

<%@ page import="java.sql.Statement" %>

<%@ page import="java.sql.ResultSet" %>

<%@ page import = "java.sql.PreparedStatement" %>

<%@ page import="java.util.ArrayList" %>

<%@ page import="java.sql.SQLException" %>
<% request.setCharacterEncoding("utf-8"); %>
<% String type = (String)request.getParameter("type").trim(); %>
<% String SearchKey = (String)request.getParameter("SearchKey").trim(); %>


<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Insert title here</title>
</head>
<body>
<%  // 인증된 세션이 없는경우, 해당페이지를 볼 수 없게 함.

	response.setHeader("pragma","No-cache");

	response.setHeader("Cache-Control","no-cache");

	response.addHeader("Cache-Control","No-store");

	response.setDateHeader("Expires",1L);
	
	if (session.getAttribute("ID") == null) {
	    response.sendRedirect("SessionFinished.jsp");
	}
%>



	<div align = "right">
		<a href="Logout.jsp">로그아웃</a>
	</div>


<%
Connection conn=null;

PreparedStatement pstmt=null;

ResultSet rs=null;

boolean isOK = false;

ArrayList<String> ingredlist = new ArrayList<String>();

String MagicianClass = null;


try{
response.setContentType("text/html; charset=utf-8");
String jdbcDriver ="jdbc:mariadb://localhost:3306/lodos?useUnicode=true&characterEncoding=UTF-8";

String dbUser="root";

String dbPass="31337";

String query = null;

 conn=DriverManager.getConnection(jdbcDriver,dbUser,dbPass);
 
 
 if(type.equals("이름"))
	 query = "select * from 마법사 where 이름 like '%" + SearchKey + "%'";
 
 else if(type.equals("종족"))
	query = "select * from 마법사 where 종족 like '%" + SearchKey + "%'";
 
 else if(type.equals("클래스"))
	 query = "select * from 마법사 where 클래스 like '%" + SearchKey + "%'";
 
 else if(type.equals("속성"))
	 query = "select * from 마법사 where 속성 like '%" + SearchKey + "%'";
 
 else
	 query = "select * from 마법사";
 
 pstmt=conn.prepareStatement(query);
 rs=pstmt.executeQuery();
 
 %>
 
 <table id = "table" border = "1">
 	<th> 번호 </th>
 	<th> ID </th>
 	<th> 이름 </th>
 	<th> 나이 </th>
 	<th> 종족 </th>
 	<th> 출신지 </th>
 	<th> 직업 </th>
 	<th> 클래스 </th>
 	<th> 속성 </th>
 	<th> 마나량 </th>
 	<th> 자금 </th>
 <% 
 int i=1;
 while(rs.next()) {
	 %>
	 	<tr onClick = "EnrollMagician(<%=i%>);"
	 		style = "cursor:pointer;">
	 		<td> <%= i %> </td>
	 		<td> <%= rs.getString("ID") %> </td>
	 		<td> <%= rs.getString("이름") %> </td>
	 		<td> <%= rs.getString("나이") %> </td>
	 		<td> <%= rs.getString("종족") %> </td>
	 		<td> <%= rs.getString("출신지") %> </td>
	 		<td> <%= rs.getString("직업") %> </td>
	 		<td> <%= rs.getString("클래스") %> </td>
	 		<td> <%= rs.getString("속성") %> </td>
	 		<td> <%= rs.getString("마나량") %> </td>
	 		<td> <%= rs.getString("자금") %> </td>
	 	</tr> 
	 <% 
	 	i++;
	 }
 %>
 	</table> <br> <br>
 <% 
	}catch(Exception e){}
%>

<script>

	function DeleteAll() {
		document.getElementById("workspace").innerHTML = "";
	}
	
	function EnrollMagician(num) {
		DeleteAll();
		var table = document.getElementById("table");
		
		var txt = "<form action = 'EnrollMagician.jsp' method = 'post'>"
			+ "<h3>"+ table.rows[num].cells[2].innerHTML.trim() + "를 해당 상회의 새로운 마법사로 등록하시겠습니까? </h3> <br>"
			+ "<input type='hidden' name = 'ID' id = 'ID' value = '" + table.rows[num].cells[1].innerHTML.trim() + "'>"
			+ "<input type = 'submit' value = '등록'"
			+ "</form>";
		document.getElementById("workspace").innerHTML += txt;
	}

</script>

	<div id = "workspace">
	</div>

</body>
</html>