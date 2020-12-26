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
	    	query="Select * from 상회보유재료, 재료, 마법상회 where 마법상회.ID = '" + FirmID + "' and 상회보유재료.상회ID = '" + FirmID 
	    		+ "' and 상회보유재료.재료ID = 재료.ID and 재료.이름 like '%" + SearchKey + "%'";
	    
	    else if(type.equals("origin"))
	    	query="Select * from 상회보유재료, 재료, 마법상회 where 마법상회.ID = '" + FirmID + "' and 상회보유재료.상회ID = '" + FirmID 
    		+ "' and 상회보유재료.재료ID = 재료.ID and 재료.원산지 like '%" + SearchKey + "%'";
	    
	    else if(type.equals("kind"))
	    	query="Select * from 상회보유재료, 재료, 마법상회 where 마법상회.ID = '" + FirmID + "' and 상회보유재료.상회ID = '" + FirmID 
    		+ "' and 상회보유재료.재료ID = 재료.ID and 재료.종류 like '%" + SearchKey + "%'";
	    else
	    	query="Select * from 상회보유재료, 재료, 마법상회 where 마법상회.ID = '" + FirmID + "' and 상회보유재료.상회ID = '" + FirmID 
    		+ "' and 상회보유재료.재료ID = 재료.ID";
	    
	    try{
		     pstmt=conn.prepareStatement(query);
		     rs=pstmt.executeQuery();
		     
		     %>

		     <table id = "table" border = "1">
		     		<th> 번호 </th>
		    		<th> ID </th>
		    		<th> 이름 </th>
		    		<th> 원산지 </th>
		    		<th> 종류 </th>
		    		<th> 판매가격 </th>
		    		<th> 보유량 </th>
		     <%
		     
		     int i=1;
		     while(rs.next()) {
		    	 %>
		    	 	<tr onClick = "PurchaseProduct(<%=i%>);" 
		    	 			style = "cursor:pointer;" id = <%= rs.getString("재료.ID") %>>
		    	 		<td> <%= i %> </td>
		    	 		<td> <%= rs.getString("재료.ID") %> </td>
		    	 		<td> <%= rs.getString("재료.이름") %> </td>
		    	 		<td> <%= rs.getString("재료.원산지") %> </td>
		    	 		<td> <%= rs.getString("재료.종류") %> </td>
		    	 		<td> <%= rs.getString("재료.가격") %> </td>
		    	 		<td> <%= rs.getString("상회보유재료.보유량") %>
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

	function PurchaseProduct(num) {
		DeleteAll();
		var table = document.getElementById("table");
		var txt = "<form action = 'PurchaseProduct.jsp' method = 'post'>"
			+ "<h3>"+ table.rows[num].cells[2].innerHTML.trim() + "를 구입하시겠습니까? </h3> <br>"
			+ "<h4> 갯수: <input type = 'text' min = '1' max = '100' name = 'num' id = 'num'>"
			+ "<input type='hidden' name = 'ProductID' id = 'ProductID' value = '" + table.rows[num].cells[1].innerHTML.trim() + "'>"
			+ "<input type='hidden' name = 'FirmID' id = 'FirmID' value = '" + '<%=FirmID.trim()%>' + "'>"
			+ "<input type = 'button' value = '구입' onClick = 'InsertPurchasedProduct(" + table.rows[num].cells[1].innerHTML.trim() + ");'>"
			+ "<input type = 'button' value = '닫기' onClick = 'refreshParent();'>"
			+ "</form>";
		document.getElementById("workspace").innerHTML += txt;
	}
	
	function InsertPurchasedProduct(ProductID) {
		var URL = "CustomerPurchaseProduct.jsp?ProductID= "+ ProductID + "&num= " + document.getElementById("num").value
				+ "&FirmID= " + '<%=FirmID.trim()%>';
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