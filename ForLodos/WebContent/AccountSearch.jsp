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
<% String MyID = (String)session.getAttribute("ID"); %>
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
 
 
 if(type.equals("상호"))
	 query = "select * from 마법상회 where 상호 like '%" + SearchKey + "%'";
 
 else if(type.equals("대표자이름"))
	query = "select * from 마법상회 where 대표자이름 like '%" + SearchKey + "%'";
 
 else if(type.equals("거래허가속성"))
	 query = "select * from 마법상회 where 거래허가속성 like '%" + SearchKey + "%'";
 
 else
	 query = "select * from 마법상회";
 
 pstmt=conn.prepareStatement(query);
 rs=pstmt.executeQuery();
 
 %>
 
 <table id = "table" border = "1">
 	<th> 번호 </th>
 	<th> ID </th>
 	<th> 상호 </th>
 	<th> 주소 </th>
 	<th> 대표자이름 </th>
 	<th> 거래허가속성 </th>
 <% 
 int i=1;
 while(rs.next()) {
	 %>
	 	<tr onClick = "EnrollAccount(<%=i%>);"
	 		style = "cursor:pointer;">
	 		<td> <%= i %> </td>
	 		<td> <%= rs.getString("ID") %> </td>
	 		<td> <%= rs.getString("상호") %> </td>
	 		<td> <%= rs.getString("주소") %> </td>
	 		<td> <%= rs.getString("대표자이름") %> </td>
	 		<td> <%= rs.getString("거래허가속성") %> </td>
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
	
	function EnrollAccount(num) {
		DeleteAll();
		var table = document.getElementById("table");
		
		var txt = "<form action = 'EnrollAccount.jsp' method = 'post'>"
			+ "<h3>"+ table.rows[num].cells[2].innerHTML.trim() + "를 새로운 거래처로 등록하시겠습니까? </h3> <br>"
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