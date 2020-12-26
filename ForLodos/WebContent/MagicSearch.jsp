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
<% String MagicianID = request.getParameter("magicianID"); %>
<% String Name = request.getParameter("name"); %>
<% String Class = request.getParameter("class"); %>
<% String Kind = request.getParameter("kind"); %>

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


 //2.데이터 베이스 커넥션 생성
 
 if(Name == null) {
	 Name = "";
 }
 if(Class == null) {
	 Class = "";
 }
 if(Kind == null) {
	 Kind = "";
 }
 conn=DriverManager.getConnection(jdbcDriver,dbUser,dbPass);
 
 query = "select * from 재료";
 pstmt=conn.prepareStatement(query);
 rs=pstmt.executeQuery();
 
 while(rs.next()) {
	 ingredlist.add(rs.getString("ID") + ", " + rs.getString("이름"));
 }

 
 query = "select * from 마법사 where ID = '" + MagicianID + "'";
pstmt=conn.prepareStatement(query);
 rs=pstmt.executeQuery();
 rs.next();
 MagicianClass = rs.getString("클래스");
 
 //3.Statement 생성
 query = "Select * from 마법, 마법의재료, 재료 Where 제작마법사ID = '" + MagicianID + "' and 마법.이름 like '%" 
 		+ Name + "%' and 마법.클래스 like '%" + Class + "%' and 마법.종류 like '%" + Kind + "%' and "
 		+ "마법의재료.마법ID = 마법.ID and 마법의재료.재료ID = 재료.ID;";
 pstmt=conn.prepareStatement(query);
 
 rs=pstmt.executeQuery();
 %>

 <table id = "table" border = "1">
 		<th> 번호 </th>
		<th> ID </th>
		<th> 이름 </th>
		<th> 설명 </th>
		<th> 클래스 </th>
		<th> 속성 </th>
		<th> 종류 </th>
		<th> 효과량 </th>
		<th> 마나소비량 </th>
		<th> 판매가격 </th>
		<th> 필요재료 </th>
		<th> 재료의 양 </th>
		<th> 재료ID</th>
 <%
 int i = 1;
 while(rs.next()) {
%>
	<tr onClick = "UpdateMagicInfo(<%=i%>);" 
			style = "cursor:pointer;" id = <%= rs.getString("마법.ID") %>>
		<td> <%= i %> </td>
		<td> <%= rs.getString("마법.ID") %> </td>
		<td> <%= rs.getString("마법.이름") %> </td>
		<td> <%= rs.getString("설명") %> </td>
		<td> <%= rs.getString("클래스") %> </td>
		<td> <%= rs.getString("속성") %> </td>
		<td> <%= rs.getString("종류") %> </td>
		<td> <%= rs.getString("효과량") %> </td>
		<td> <%= rs.getString("마나소비량") %> </td>
		<td> <%= rs.getString("판매가격") %> </td>
		<td> <%= rs.getString("재료.이름") %> </td>
		<td> <%= rs.getString("투입량") %> </td>
		<td> <%= rs.getString("재료.ID") %> </td>
	</tr>
<% 
		i++;
 }
 %>
 	</table> <br> <br>
<% 
	}catch(Exception e) {System.out.println(e);}
%>

<script>
	function DeleteAll() {
			document.getElementById("workspace").innerHTML = "";
	}

	function UpdateMagicInfo(num) {
		DeleteAll();
		
		var max = '<%= MagicianClass%>';
		var table = document.getElementById("table");
	
		var txt = "<form action = 'UpdateMagicInfo.jsp' method = 'post'>" 
			+ "아이디 : <input type = 'text' name = 'ID' value = '" + table.rows[num].cells[1].innerHTML + "' readonly> <br>"
			+ "이름 : <input type = 'text' name = 'name' value = '" + table.rows[num].cells[2].innerHTML + "'> <br>"
			+ "설명 : <input type = 'text' size = '50' name = 'desc' value = '" + table.rows[num].cells[3].innerHTML + "'> <br>"
			+ "클래스 : <input type = 'number' name = 'class' min = '0' max = '" + max + "' value = '" + table.rows[num].cells[4].innerHTML + "'> <br>"
			+ "속성 : <input type = 'text' name = 'property' value = '" + table.rows[num].cells[5].innerHTML + "' readonly> <br>"
			+ "종류 :  <select name = 'kind'>"
			+ "<option value = " + table.rows[num].cells[6].innerHTML + "> 현 마법 종류 : " + table.rows[num].cells[6].innerHTML + "</option>" 
			+ "<option value = '공격'> 공격 </option>"
			+ "<option value = '도움'> 도움 </option>"
			+ "<option value = '변형'> 변형 </option>"
			+ "<option value = '창조'> 창조 </option>"
			+ "</select> <br>"
			+ "효과량 : <input type = 'number' name = 'amount' min = '0' value = '" + table.rows[num].cells[7].innerHTML + "'> <br>"
			+ "마나소비량 : <input type = 'number' name = 'manaconsume' min = '0' value = '" + table.rows[num].cells[8].innerHTML + "'> <br>"
			+ "판매가격 : <input type = 'number' name = 'price' min = '0' value = '" + table.rows[num].cells[9].innerHTML + "'> <br>"
			+ "필요 재료 : <select name = 'ingredientID'>"
			+ "<option value = " + table.rows[num].cells[12].innerHTML + "> 현재 재료 : " + table.rows[num].cells[10].innerHTML + " </option>";  
			<%for(int i=0; i<ingredlist.size(); i++) {%>
				txt = txt + "<option value = " 
					+ '<%= ingredlist.get(i).split(",")[0]%>' + ">" + '<%=ingredlist.get(i)%>' + "</option>";
			<%}%>
			
		txt = txt + "</select> <br> 재료의 양 : <input type = 'number' name = 'need' min = '1' value = '" + table.rows[num].cells[11].innerHTML + "'> <br>"
			+ "<input type = 'submit' value = '마법 정보 수정'>"
			+ "</form>";
			
		document.getElementById("workspace").innerHTML += txt;
	}

</script>


	<div id = "workspace">
	</div>

</body>
</html>