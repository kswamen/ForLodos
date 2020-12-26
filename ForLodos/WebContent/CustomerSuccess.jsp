<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %>
<%@ page import="java.sql.DriverManager" %>

<%@ page import="java.sql.Connection" %>

<%@ page import="java.sql.Statement" %>

<%@ page import="java.sql.ResultSet" %>

<%@ page import = "java.sql.PreparedStatement" %>

<%@ page import="java.sql.SQLException" %>

<%@ page import="java.util.ArrayList" %>

<% request.setCharacterEncoding("utf-8"); %>

<% String ID = request.getParameter("name"); %>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
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
	
	String jdbcDriver ="jdbc:mariadb://localhost:3306/lodos";
	
	String dbUser="root";

    String dbPass="31337";
    
    String query = null;
    
    
	    Connection conn=null;
	
	    PreparedStatement pstmt=null;
	
	    ResultSet rs=null;
	    
	    conn=DriverManager.getConnection(jdbcDriver,dbUser,dbPass);
	    
	    String MyID = null;
	    String MyName = null;
	    String MyProperty = null;
	    String MyAccount = null;
	    String MyAddress = null;
	    String MyAge = null;
	    String Fund = null;
	    
	    try{
	
	    query="select * from 소비자 where ID=?";
	
	     pstmt=conn.prepareStatement(query);
	     pstmt.setString(1, (String)session.getAttribute("ID"));
	     rs=pstmt.executeQuery();
	     rs.next();
	     
	     MyID = rs.getString("ID");
	     MyName = rs.getString("이름");
	     MyProperty = rs.getString("속성");
	     MyAddress = rs.getString("주소");
	     MyAge = rs.getString("나이");
	     Fund = rs.getString("소지금");
	     
	    }catch(Exception e) {}
	%>
	
	<script>
	var i = 0;
	var MyID = "<%=MyID%>";
	var MyName = "<%=MyName%>";
	var MyProperty = "<%=MyProperty%>";
	var MyAccount = "<%=MyAccount%>";
	var MyAddress = "<%=MyAddress%>";
	var MyAge = "<%=MyAge%>";
	var Fund = "<%=Fund%>";
	var type = null;
	var SearchKey = null;
	
		function DeleteAll() {
	 		document.getElementById("workspace").innerHTML = "";
		}
		
		function ManageMyFirmInfo() {
			
			DeleteAll();
			
			var txt = "<form action = 'UpdateCustomerInfo.jsp' method = 'post'>"  
				+ "ID : <input type = 'text' name = 'ID' value = " + MyID + " readonly> <br>" 
				+ "이름 : <input type = 'text' name = 'name' value = '" + MyName + "'> <br>" //홑따옴표 추가하면 공백 인식함
				+ "나이 : <input type = 'number' name = 'age' value = '" + MyAge + "'> <br> "
				+ "주소 : <input type = 'text' name = 'address' value = '" + MyAddress + "'> <br>" 
				+ "속성 : <input type = 'text' name = 'propertyAccessed' value = " + MyProperty + " readonly> <br> "
				+ "소지금 : <input type = 'number' name = 'money' min = '0' value = " + Fund + "> <br> <br>" 
				+ "<input type = 'submit' value = '정보 수정'> "
				+ "<br> <br>거래처 : <br> <table id = 'table1' border = '1'> "
				+ "<th> 번호 </th>"
				+ "<th> ID </th>"
				+ "<th> 이름 </th>"
				+ "<th> 속성 </th>";
			<% 
				int i=1;
				query = "select * from 소비자, 마법상회, 거래처  where 거래처.소비자ID = 소비자.ID and 거래처.상회ID = 마법상회.ID and 소비자.ID = '" + MyID + "'";
			    pstmt=conn.prepareStatement(query);
			    rs=pstmt.executeQuery();
				while(rs.next()) {
			%>
					txt += "<tr onClick = 'ShowAccountDetails(" + '<%=rs.getString("거래처.상회ID")%>' + ");'  style = 'cursor:pointer;' id = '<%= rs.getString("거래처.상회ID") %>'>"
						+ "<td>" + '<%=i%>' + "</td>"
						+ "<td>" + '<%=rs.getString("마법상회.ID")%>' + "</td>"
						+ "<td>" + '<%=rs.getString("마법상회.상호")%>' + "</td>"
						+ "<td>" + '<%=rs.getString("마법상회.거래허가속성")%>' + "</td>";
			<%
					i++;
				}
			%>
			
			txt += "</table> <br> <br> 보유 마법 목록 : <br> <table id = 'table2' border = '1'>"
				+ "<th> 번호 </th>"
				+ "<th> ID </th>"
				+ "<th> 이름 </th>"
				+ "<th> 설명 </th>"
				+ "<th> 재료 </th>"
				+ "<th> 재료양 </th>"
				+ "<th> 비고 </th>"
			<%
				i=1;
				query = "select * from 소비자보유마법, 마법, 마법의재료, 재료  where 소비자ID = '" + MyID + "' and 소비자보유마법.마법ID = 마법.ID and 마법의재료.마법ID = 마법.ID"
						+ " and 재료.ID = 마법의재료.재료ID";
				
			    pstmt=conn.prepareStatement(query);
			    rs=pstmt.executeQuery();
			    
			    
				while(rs.next()) {
				    String query2 = "Select * from 소비자보유재료, 재료, 마법의재료 where 소비자ID = '" + MyID + "' and 소비자보유재료.재료ID = '" + rs.getString("마법의재료.재료ID") 
				    		+ "' and 재료.ID = '" + rs.getString("마법의재료.재료ID") + "' and 마법의재료.마법ID = '" + rs.getString("마법.ID") + "'";
				    PreparedStatement pstmt2=conn.prepareStatement(query2);
				    ResultSet rs2 = pstmt2.executeQuery();
			%>
					txt += "<tr onClick = 'ShowMagicDetails(" + '<%=rs.getString("마법ID")%>' + ");'  style = 'cursor:pointer;' id = '<%= rs.getString("마법ID") %>'>"
						+ "<td>" + '<%=i%>' + "</td>"
						+ "<td>" + '<%=rs.getString("소비자보유마법.마법ID")%>' + "</td>"
						+ "<td>" + '<%=rs.getString("마법.이름")%>' + "</td>"
						+ "<td>" + '<%=rs.getString("마법.설명")%>' + "</td>"
						+ "<td>" + '<%=rs.getString("재료.이름")%>' + "</td>"
						+ "<td>" + '<%=rs.getString("마법의재료.투입량")%>' + "</td>";
						
			<%
					if(rs2.next()) {
						if(rs2.getInt("투입량") > rs2.getInt("소비자보유재료.보유량")){
							%>
							txt += "<td>" + "재료 부족!" + "</td>"
							<%
						}
					}
					else {
						%>
						txt += "<td>" + "재료 부족!" + "</td>"
						<%
					}
					i++;
				}
			%>
			
			txt += "</table> <br> <br> 보유 재료 목록 : <br> <table id = 'table3' border = '1'>"
				+ "<th> 번호 </th>"
				+ "<th> ID </th>"
				+ "<th> 이름 </th>"
				+ "<th> 원산지 </th>"
				+ "<th> 보유량 </th>"
			<%
				i=1;
				query = "select * from 소비자보유재료, 재료  where 소비자ID = '" + MyID + "' and 소비자보유재료.재료ID = 재료.ID";
			    pstmt=conn.prepareStatement(query);
			    rs=pstmt.executeQuery();
				while(rs.next()) {
			%>
					txt += "<tr onClick = 'ShowIngredientDetails(" + '<%=rs.getString("재료ID")%>' + ");'  style = 'cursor:pointer;' id = '<%= rs.getString("재료ID") %>'>"
						+ "<td>" + '<%=i%>' + "</td>"
						+ "<td>" + '<%=rs.getString("소비자보유재료.재료ID")%>' + "</td>"
						+ "<td>" + '<%=rs.getString("재료.이름")%>' + "</td>"
						+ "<td>" + '<%=rs.getString("재료.원산지")%>' + "</td>"
						+ "<td>" + '<%=rs.getString("소비자보유재료.보유량")%>' + "</td>"
			<%
					i++;
				}
			%>
			
				txt += "</table> <br> <br>"
				+ "</form>" ;
			document.getElementById("workspace").innerHTML = document.getElementById("workspace").innerHTML + txt;
		}
		
		function ShowAccountDetails(String) {
			var FirmID = String.cells[1].innerText.trim();
			var URL = "ShowFirmInfo.jsp?FirmID= "+ FirmID + "&CustomerID= " + MyID;
			var rtnVal = window.showModalDialog(URL, self, "dialogWidth:20; dialogHeight:20; help:no; status:no;");
		}
		
		function ShowMagicDetails(String) {
			var MagicID = String;
			var URL = "ShowMagicInfo.jsp?MagicID= "+ MagicID;
			var rtnVal = window.showModalDialog(URL, self, "dialogWidth:20; dialogHeight:20; help:no; status:no;");
		}
		
		function ShowIngredientDetails(String) {
			var ProductID = String;
			var URL = "ShowProductInfo.jsp?ProductID= "+ ProductID;
			var rtnVal = window.showModalDialog(URL, self, "dialogWidth:20; dialogHeight:20; help:no; status:no;");
		}
		
		function ShowPosessedMagic(String) {
			type = document.getElementById("type").value.trim();
			SearchKey = encodeURI(document.getElementById("SearchKey").value.trim());
			var FirmID = String.cells[1].innerText.trim();
			var URL = "ShowPosessedMagicInfo.jsp?FirmID= "+ FirmID + "&type= " + type + "&SearchKey= " + encodeURI(SearchKey, "UTF-8");
			var rtnVal = window.showModalDialog(URL, self, "dialogWidth:50; dialogHeight:30; help:no; status:no;");
		}
		
		function ShowPosessedProduct(String) {
			type = document.getElementById("type").value.trim();
			SearchKey = encodeURI(document.getElementById("SearchKey").value.trim());
			var FirmID = String.cells[1].innerText.trim();
			var URL = "ShowPosessedProductInfo.jsp?FirmID= "+ FirmID + "&type= " + type + "&SearchKey= " + encodeURI(SearchKey, "UTF-8");
			var rtnVal = window.showModalDialog(URL, self, "dialogWidth:32; dialogHeight:25; help:no; status:no;");
		}
		
		function PurchaseMagic() {
			DeleteAll();
			
			var txt = "<table id = 'table1' border = '1'> "
					+ "<th> 번호 </th>"
					+ "<th> ID </th>"
					+ "<th> 상호 </th>"
					+ "<th> 속성 </th>"
			<% 
					i=1;
					query = "select * from 마법상회, 거래처 where 거래처.상회ID = 마법상회.ID and 거래처.소비자ID = '" + MyID + "'";
				    pstmt=conn.prepareStatement(query);
				    rs=pstmt.executeQuery();
					while(rs.next()) {
			%>
						txt += "<tr onClick = 'ShowPosessedMagic(" + '<%=rs.getString("ID")%>' + ");'  style = 'cursor:pointer;' id = '<%= rs.getString("ID") %>'>"
							+ "<td>" + '<%=i%>' + "</td>"
							+ "<td>" + '<%=rs.getString("마법상회.ID")%>' + "</td>"
							+ "<td>" + '<%=rs.getString("마법상회.상호")%>' + "</td>"
							+ "<td>" + '<%=rs.getString("마법상회.거래허가속성")%>' + "</td>";
			<%
						i++;
					}
			%>
				txt += "</table> <br> <br>"
					+ "<h3>검색 조건을 설정하고 원하는 상회를 클릭하세요.<h3> <br>"
					+ "<select name = 'type' id = 'type'>"
					+ "<option value = ''>" + "검색할 키워드 선택" + "</option>"
					+ "<option value = 'name'>" + "마법 이름" + "</option>"
					+ "<option value = 'class'>" + "클래스" + "</option>"
					+ "<option value = 'property'>" + "속성" + "</option>"
					+ "</select>"
					+ "<input type = 'text' name = 'SearchKey' id = 'SearchKey' size = '50'>"
					+ "</form>" ;
			document.getElementById("workspace").innerHTML = document.getElementById("workspace").innerHTML + txt;
			
		}
		
		function PurchaseProduct() {
			DeleteAll();
			
			var txt = "<table id = 'table1' border = '1'> "
					+ "<th> 번호 </th>"
					+ "<th> ID </th>"
					+ "<th> 상호 </th>"
					+ "<th> 속성 </th>"
			<% 
					i=1;
					query = "select * from 마법상회, 거래처 where 거래처.상회ID = 마법상회.ID and 거래처.소비자ID = '" + MyID + "'";
				    pstmt=conn.prepareStatement(query);
				    rs=pstmt.executeQuery();
					while(rs.next()) {
			%>
						txt += "<tr onClick = 'ShowPosessedProduct(" + '<%=rs.getString("ID")%>' + ");'  style = 'cursor:pointer;' id = '<%= rs.getString("ID") %>'>"
							+ "<td>" + '<%=i%>' + "</td>"
							+ "<td>" + '<%=rs.getString("마법상회.ID")%>' + "</td>"
							+ "<td>" + '<%=rs.getString("마법상회.상호")%>' + "</td>"
							+ "<td>" + '<%=rs.getString("마법상회.거래허가속성")%>' + "</td>";
			<%
						i++;
					}
			%>
				txt += "</table> <br> <br>"
					+ "<h3>검색 조건을 설정하고 원하는 상회를 클릭하세요.<h3> <br>"
					+ "<select name = 'type' id = 'type'>"
					+ "<option value = ''>" + "검색할 키워드 선택" + "</option>"
					+ "<option value = 'name'>" + "재료 이름" + "</option>"
					+ "<option value = 'origin'>" + "원산지" + "</option>"
					+ "<option value = 'kind'>" + "종류" + "</option>"
					+ "</select>"
					+ "<input type = 'text' name = 'SearchKey' id = 'SearchKey' size = '50'>"
					+ "</form>" ;
			document.getElementById("workspace").innerHTML = document.getElementById("workspace").innerHTML + txt;
		}
		
		function EnrollNewAccount() {
			DeleteAll();
			
			var txt = "<form action = 'AccountSearch.jsp' method = 'post'>"
				+ "<select name = 'type' id = 'type'>"
				+ "<option value = ''>" + "검색할 키워드 선택" + "</option>"
				+ "<option value = '상호'>" + "상호" + "</option>"
				+ "<option value = '대표자이름'>" + "대표자이름" + "</option>"
				+ "<option value = '거래허가속성'>" + "거래허가속성" + "</option>"
				+ "</select>"
				+ "<input type = 'text' name = 'SearchKey' id = 'SearchKey' size = '50'>"
				+ "<input type = 'submit' name = 'send' value = '검색'>"
				+ "</form>"
			document.getElementById("workspace").innerHTML += txt;
		}
		
		function ShowMyTradeInfo() {
			DeleteAll();
			
			var txt = "<h3> 마법거래내역 </h3>"
				+ "<table id = 'table' border = '1'>"
	 			+ "<th> 상회명 </th>"
	 			+ "<th> 마법명 </th>"
	 			+ "<th> 판매일자 </th>"
	 			+ "<th> 판매가격 </th>";
				
			<%
				 query="select * from 고객마법거래정보, 마법상회, 소비자, 마법  "
				 	+ "where 고객마법거래정보.상회ID = 마법상회.ID and 고객마법거래정보.고객ID = 소비자.ID and "
				 	+ "고객마법거래정보.마법ID = 마법.ID and 소비자.ID = '" + MyID + "' order by 판매일자 desc";
				
			     pstmt=conn.prepareStatement(query); 
			     rs=pstmt.executeQuery();
			  
			     while(rs.next()) {
			    	 %>
			    	 txt += "<tr>" 
			    	  	+ "<td>" + '<%= rs.getString("마법상회.상호") %>' + "</td>"
			    	  	+ "<td>" + '<%= rs.getString("마법.이름") %>' + "</td>"
			    	  	+ "<td>" + '<%= rs.getString("고객마법거래정보.판매일자") %>' + "</td>"
			    	  	+ "<td>" + '<%= rs.getString("고객마법거래정보.판매가격") %>' + "</td>"
			    		+ "</tr>";
			    	 <%
			     }
			     
			%>
				txt +=  "</table> <br> <br>";
				
				txt += "<h3> 재료거래내역 </h3>"
					+ "<table id = 'table2' border = '1'>"
		 			+ "<th> 상회명 </th>"
		 			+ "<th> 재료명 </th>"
		 			+ "<th> 판매일자 </th>"
		 			+ "<th> 판매가격 </th>";
					
				<%
					 query="select * from 고객재료거래정보, 마법상회, 소비자, 재료  "
					 	+ "where 고객재료거래정보.상회ID = 마법상회.ID and 고객재료거래정보.고객ID = 소비자.ID and "
					 	+ "고객재료거래정보.재료ID = 재료.ID and 소비자.ID = '" + MyID + "' order by 판매일자 desc";
					
				     pstmt=conn.prepareStatement(query); 
				     rs=pstmt.executeQuery();
				  
				     while(rs.next()) {
				    	 %>
				    	 txt += "<tr>" 
				    	  	+ "<td>" + '<%= rs.getString("마법상회.상호") %>' + "</td>"
				    	  	+ "<td>" + '<%= rs.getString("재료.이름") %>' + "</td>"
				    	  	+ "<td>" + '<%= rs.getString("고객재료거래정보.판매일자") %>' + "</td>"
				    	  	+ "<td>" + '<%= rs.getString("고객재료거래정보.판매가격") %>' + "</td>"
				    		+ "</tr>";
				    	 <%
				     }
				     
				%>
					txt +=  "</table> <br> <br>";
				
			document.getElementById("workspace").innerHTML += txt;
		}
	
	</script>
	
	<h1> 어서 오세요, <%=MyName%>. </h1>
	<br> <br>

	
	<input type='button' value='내 정보 관리' onclick = "ManageMyFirmInfo();">
	<input type='button' value='마법 구매' onclick = "PurchaseMagic();">
	<input type='button' value='재료 구매' onclick = "PurchaseProduct();">
	<input type='button' value='새로운 거래처 등록' onclick = "EnrollNewAccount();">
	<input type='button' value='거래내역 확인' onclick = "ShowMyTradeInfo();">
	
	
	<br> <br>
	
	<div id = "workspace"> 
	
	</div>
	
	
</body>
</html>