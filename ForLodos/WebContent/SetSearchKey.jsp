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
	 query = "select * from 재료 where 이름 like '%" + SearchKey + "%'";
 
 else if(type.equals("원산지"))
	query = "select * from 재료 where 원산지 like '%" + SearchKey + "%'";
 
 else if(type.equals("종류"))
	 query = "select * from 재료 where 종류 like '%" + SearchKey + "%'";
 
 else
	 query = "select * from 재료";
 
 pstmt=conn.prepareStatement(query);
 rs=pstmt.executeQuery();
 
 %>
 
 <table id = "table" border = "1">
 	<th> 번호 </th>
 	<th> ID </th>
 	<th> 이름 </th>
 	<th> 원산지 </th>
 	<th> 종류 </th>
 	<th> 가격 </th>
 <% 
 int i=1;
 while(rs.next()) {
	 %>
	 	<tr onClick = "PurchaseProduct(<%=i%>);"
	 		style = "cursor:pointer;">
	 		<td> <%= i %> </td>
	 		<td> <%= rs.getString("ID") %> </td>
	 		<td> <%= rs.getString("이름") %> </td>
	 		<td> <%= rs.getString("원산지") %> </td>
	 		<td> <%= rs.getString("종류") %> </td>
	 		<td> <%= rs.getString("가격") %> </td>
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
	
	function PurchaseProduct(num) {
		DeleteAll();
		var table = document.getElementById("table");
		
		var txt = "<form action = 'PurchaseProduct.jsp' method = 'post'>"
			+ "ID : <input type = 'text' name = 'productID' value = '" + table.rows[num].cells[1].innerHTML.trim() + "' readonly> <br>"
			+ "이름 : <input type = 'text' name = 'name' value= '" + table.rows[num].cells[2].innerHTML.trim() + "' readonly> <br>"
			+ "가격 : <input type = 'number' name = 'price' value = '" + table.rows[num].cells[5].innerHTML.trim() + "' readonly> <br>"
			+ "개수 : <input type = 'number' name = 'num' value = '1' min = '1'> <br>"
			+ "<input type = 'submit' value = '구매'"
			+ "</form>";
		document.getElementById("workspace").innerHTML += txt;
	}

</script>

	<div id = "workspace">
	</div>

</body>
</html>