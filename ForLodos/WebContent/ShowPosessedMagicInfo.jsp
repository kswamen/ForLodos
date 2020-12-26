<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.sql.DriverManager" %>

<%@ page import="java.sql.Connection" %>

<%@ page import="java.sql.Statement" %>

<%@ page import="java.sql.ResultSet" %>

<%@ page import = "java.sql.PreparedStatement" %>

<%@ page import="java.sql.SQLException" %>
<% request.setCharacterEncoding("utf-8"); %>
<% String FirmID = request.getParameter("FirmID").trim(); %>
<% String type = request.getParameter("type").trim(); %>
<% String SearchKey = java.net.URLDecoder.decode(request.getParameter("SearchKey").trim(), "UTF-8"); %>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Insert title here</title>
</head>
<body>
<% 
	String jdbcDriver ="jdbc:mariadb://localhost:3306/lodos";
	
	String dbUser="root";

    String dbPass="31337";
    
    String query = null;
    
    
	    Connection conn=null;
	
	    PreparedStatement pstmt=null;
	
	    ResultSet rs=null;
	    
	    conn=DriverManager.getConnection(jdbcDriver,dbUser,dbPass);
	    
	    if(type.equals("name"))
	    	query="Select * From 마법상회, 마법사, 마법, 재료, 마법의재료 where 마법사.소속상회ID = '" + FirmID + "' and 마법상회.ID = '" + FirmID + "'"
		    		+ " and 마법.제작마법사ID = 마법사.ID and 마법의재료.마법ID = 마법.ID and 마법의재료.재료ID = 재료.ID and 마법.이름 like '%" + SearchKey + "%'";
	    
	    else if(type.equals("class"))
	    	query="Select * From 마법상회, 마법사, 마법, 재료, 마법의재료 where 마법사.소속상회ID = '" + FirmID + "' and 마법상회.ID = '" + FirmID + "'"
		    		+ " and 마법.제작마법사ID = 마법사.ID and 마법의재료.마법ID = 마법.ID and 마법의재료.재료ID = 재료.ID and 마법.클래스 like '%" + SearchKey + "%'";
	    
	    else if(type.equals("property"))
	    	query="Select * From 마법상회, 마법사, 마법, 재료, 마법의재료 where 마법사.소속상회ID = '" + FirmID + "' and 마법상회.ID = '" + FirmID + "'"
		    		+ " and 마법.제작마법사ID = 마법사.ID and 마법의재료.마법ID = 마법.ID and 마법의재료.재료ID = 재료.ID and 마법.속성 like '%" + SearchKey + "%'";
	    else
	    	query="Select * From 마법상회, 마법사, 마법, 재료, 마법의재료 where 마법사.소속상회ID = '" + FirmID + "' and 마법상회.ID = '" + FirmID + "'"
		    		+ " and 마법.제작마법사ID = 마법사.ID and 마법의재료.마법ID = 마법.ID and 마법의재료.재료ID = 재료.ID";
	    
	    try{
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
		     
		     int i=1;
		     while(rs.next()) {
		    	 %>
		    	 	<tr onClick = "PurchaseMagic(<%=i%>);" 
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

	function PurchaseMagic(num) {
		DeleteAll();
		var table = document.getElementById("table");
		var txt = "<form action = 'PurchaseMagic.jsp' method = 'post'>"
			+ "<h3>"+ table.rows[num].cells[2].innerHTML.trim() + "를 구입하시겠습니까? </h3> <br>"
			+ "<input type='hidden' name = 'MagicID' id = 'MagicID' value = '" + table.rows[num].cells[1].innerHTML.trim() + "'>"
			+ "<input type = 'button' value = '구입' onClick = 'InsertPurchasedMagic(" + table.rows[num].cells[1].innerHTML.trim() + ");'>"
			+ "<input type = 'button' value = '닫기' onClick = 'refreshParent();'>"
			+ "</form>";
		document.getElementById("workspace").innerHTML += txt;
	}
	
	function InsertPurchasedMagic(MagicID) {
		var URL = "PurchaseMagic.jsp?MagicID= "+ MagicID;
		var rtnVal = window.showModalDialog(URL, self, "dialogWidth:18; dialogHeight:10; help:no; status:no;");
	}
	
	function refreshParent() {
		var opener = window.dialogArguments;
		self.close();
		opener.document.location.reload();
	}
	
</script>

<div id = "workspace"> 
</div>

</body>
</html>