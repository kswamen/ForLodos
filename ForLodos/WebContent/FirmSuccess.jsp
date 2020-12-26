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
	    
	    String FirmID = null;
	    String FirmName = null;
	    String FirmAddress = null;
	    String RepresentativeName = null;
	    String PropertyAccessed = null;
	    String ClassAccessed = null;
	    String Fund = null;
	   
	    ArrayList<String> firmlist = new ArrayList<String>();
		ArrayList<String> ingredlist = new ArrayList<String>();
	    
	    try{
	
	    query="select * from 마법상회 where ID=?";
	
	     pstmt=conn.prepareStatement(query);
	     pstmt.setString(1, (String)session.getAttribute("ID"));
	     rs=pstmt.executeQuery();
	     rs.next();
	     
	     FirmID = rs.getString("ID");
	     FirmName = rs.getString("상호");
	     FirmAddress = rs.getString("주소");
	     RepresentativeName = rs.getString("대표자이름");
	     PropertyAccessed = rs.getString("거래허가속성");
	     ClassAccessed = rs.getString("거래허가클래스");
	     Fund = rs.getString("소지금");
	     
	     query = "select * from 재료";
	     pstmt=conn.prepareStatement(query);
	     rs=pstmt.executeQuery();
	     
	     while(rs.next()) {
	    	 ingredlist.add(rs.getString("ID") + ", " + rs.getString("이름"));
	     }
	     
	    }catch(Exception e) {}
	%>
	
	<script>
	var i = 0;
	var FirmID = "<%=FirmID%>";
	var FirmName = "<%=FirmName%>";
	var FirmAddress = "<%=FirmAddress%>";
	var RepresentativeName = "<%=RepresentativeName%>";
	var PropertyAccessed = "<%=PropertyAccessed%>";
	var ClassAccessed = "<%=ClassAccessed%>"
	var Fund = "<%=Fund%>";
	var SearchKey = null;
		
		function DeleteAll() {
	 		document.getElementById("workspace").innerHTML = "";
		}
		
		function ManageMyFirmInfo() {
			
			DeleteAll();
			
			var txt = "<form action = 'UpdateFirmInfo.jsp' method = 'post'>"  
				+ "ID : <input type = 'text' name = 'ID' value = " + FirmID + " readonly> <br>" 
				+ "상호명 : <input type = 'text' name = 'name' value = '" + '<%=FirmName%>' + "'> <br>" //홑따옴표 추가하면 공백 인식함
				+ "회사 주소 : <input type = 'text' name = 'address' value = " + FirmAddress + "> <br>" 
				+ "대표자 이름 : <input type = 'text' name = 'representative' value = " + RepresentativeName + "> <br>" 
				+ "허가 속성 : <input type = 'text' name = 'propertyAccessed' value = " + PropertyAccessed + " readonly> <br> "
				+ "허가 클래스 : <input type = 'number' name = 'classAccessed' value = " + ClassAccessed + " min = '" + ClassAccessed + "' max = '10'> <br> "	
				+ "회사 보유 자금 : <input type = 'number' name = 'money' min = '0' value = " + Fund + "> <br> <br>" 
				+ "<input type = 'submit' value = '정보 수정'> "
				+ "<br> <br>소속 마법사 목록 : <br> <table id = 'table' border = '1'> "
				+ "<th> 번호 </th>"
				+ "<th> ID </th>"
				+ "<th> 이름 </th>"
				+ "<th> 속성 </th>";
			<% 
				int i=1;
				query = "select * from 마법사 where 소속상회ID = '" + FirmID + "'";
			    pstmt=conn.prepareStatement(query);
			    rs=pstmt.executeQuery();
				while(rs.next()) {
			%>
					txt += "<tr onClick = 'ShowMagicianDetails(" + '<%=rs.getString("마법사.ID")%>' + ");'  style = 'cursor:pointer;' id = '<%= rs.getString("마법사.ID") %>'>"
						+ "<td>" + '<%=i%>' + "</td>"
						+ "<td>" + '<%=rs.getString("마법사.ID")%>' + "</td>"
						+ "<td>" + '<%=rs.getString("마법사.이름")%>' + "</td>"
						+ "<td>" + '<%=rs.getString("마법사.속성")%>' + "</td>";
			<%
					i++;
				}
			%>
				txt += "</table> <br> <br>"
				+ "보유 재고 목록 : <br> <table id = 'tabl2' border = '1'> "
				+ "<th> 번호 </th>"
				+ "<th> ID </th>"
				+ "<th> 이름 </th>"
				+ "<th> 가격 </th>"
				+ "<th> 보유량 </th>";
			<%
				i = 1;
				query = "select * from 상회보유재료, 마법상회, 재료 where 재료.ID = 상회보유재료.재료ID and 상회보유재료.상회ID = 마법상회.ID and 상회ID = '" + FirmID + "'";
				pstmt=conn.prepareStatement(query);
			    rs=pstmt.executeQuery();
				while(rs.next()) {
			%>
					txt += "<tr onClick = 'ShowProductDetails(" + '<%= rs.getString("재료.ID")%>' + ");' style = 'cursor:pointer;' id = '<%= rs.getString("재료.ID") %>'>"
						+ "<td>" + '<%=i%>' + "</td>"
						+ "<td>" + '<%=rs.getString("재료.ID")%>' + "</td>"
						+ "<td>" + '<%=rs.getString("재료.이름")%>' + "</td>"
						+ "<td>" + '<%=rs.getString("재료.가격")%>' + "</td>"
						+ "<td>" + '<%=rs.getString("보유량")%>' + "</td>"
			<%		
					i++;
				}
			%>
				txt += "</table <br> <br>"
				+ "</form>" ;
			document.getElementById("workspace").innerHTML = document.getElementById("workspace").innerHTML + txt;
		}
		
		function ShowMagicianDetails(String) {
			var MagicianID = String.cells[1].innerText.trim();
			var URL = "ShowMagicianInfo.jsp?MagicianID= "+ MagicianID;
			var rtnVal = window.showModalDialog(URL, self, "dialogWidth:20; dialogHeight:20; help:no; status:no;");
		}
		
		function ShowProductDetails(num) {
			var ProductID = num;
			var URL = "ShowProductInfo.jsp?ProductID= "+ ProductID;
			var rtnVal = window.showModalDialog(URL, "", "dialogWidth:20; dialogHeight:20; help:no; status:no;");
		}
		
		function IngredientManage() {
			DeleteAll();
			
			var txt = "<form action = 'SetSearchKey.jsp' method = 'post'>"
				+ "<select name = 'type' id = 'type'>"
				+ "<option value = ''>" + "검색할 키워드 선택" + "</option>"
				+ "<option value = '이름'>" + "재료 이름" + "</option>"
				+ "<option value = '원산지'>" + "원산지" + "</option>"
				+ "<option value = '종류'>" + "종류" + "</option>"
				+ "</select>"
				+ "<input type = 'text' name = 'SearchKey' id = 'SearchKey' size = '50'>"
				+ "<input type = 'submit' name = 'send' value = '검색'>"
				+ "</form>"
			document.getElementById("workspace").innerHTML += txt;
		}
	
		
		function EnrollMagician() {
			DeleteAll();
			
			var txt = "<form action = 'MagicianSearch.jsp' method = 'post'>"
				+ "<select name = 'type' id = 'type'>"
				+ "<option value = ''>" + "검색할 키워드 선택" + "</option>"
				+ "<option value = '이름'>" + "이름" + "</option>"
				+ "<option value = '종족'>" + "종족" + "</option>"
				+ "<option value = '클래스'>" + "종류" + "</option>"
				+ "<option value = '속성'>" + "속성" + "</option>"
				+ "</select>"
				+ "<input type = 'text' name = 'SearchKey' id = 'SearchKey' size = '50'>"
				+ "<input type = 'submit' name = 'send' value = '검색'>"
				+ "</form>"
			document.getElementById("workspace").innerHTML += txt;
		}
		
		function ShowFirmTradeInfo() {
			DeleteAll();
			
			var txt = "<table id = 'table' border = '1'>"
	 			+ "<th> 상회명 </th>"
	 			+ "<th> 고객명 </th>"
	 			+ "<th> 상품명 </th>"
	 			+ "<th> 판매일자 </th>"
	 			+ "<th> 판매가격 </th>";
				
			<%
				 query="select * from 고객마법거래정보, 마법상회, 소비자, 마법, 마법사 "
				 	+ "where 고객마법거래정보.상회ID = 마법상회.ID and 고객마법거래정보.고객ID = 소비자.ID and "
				 	+ "고객마법거래정보.마법ID = 마법.ID and 마법.제작마법사ID = 마법사.ID and 마법사.소속상회ID = '" + FirmID + "' order by 판매일자 desc";
				
			     pstmt=conn.prepareStatement(query); 
			     rs=pstmt.executeQuery();
			  
			     while(rs.next()) {
			    	 %>
			    	 txt += "<tr>" 
			    	  	+ "<td>" + '<%= rs.getString("마법상회.상호") %>' + "</td>"
			    	  	+ "<td>" + '<%= rs.getString("소비자.이름") %>' + "</td>"
			    	  	+ "<td>" + '<%= rs.getString("마법.이름") %>' + "</td>"
			    	  	+ "<td>" + '<%= rs.getString("고객마법거래정보.판매일자") %>' + "</td>"
			    	  	+ "<td>" + '<%= rs.getString("고객마법거래정보.판매가격") %>' + "</td>"
			    		+ "</tr>";
			    	 <%
			     }
			     
			     query="select * from 고객재료거래정보, 마법상회, 소비자, 재료, 상회보유재료 "
			    		+ "where 고객재료거래정보.상회ID = '"+ FirmID + "' and 고객재료거래정보.고객ID = 소비자.ID and 마법상회.ID = '"+ FirmID + "' and "
			    		+ "고객재료거래정보.재료ID = 재료.ID and 재료.ID = 상회보유재료.재료ID and 상회보유재료.상회ID = '"+ FirmID + "' order by 판매일자 desc";
			     
			     pstmt=conn.prepareStatement(query); 
			     rs=pstmt.executeQuery();
			     
			     while(rs.next()) {
			    	 %>
			    	 txt += "<tr>" 
			    	  	+ "<td>" + '<%= rs.getString("마법상회.상호") %>' + "</td>"
			    	  	+ "<td>" + '<%= rs.getString("소비자.이름") %>' + "</td>"
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
	
	<h1> 어서 오세요, <%=RepresentativeName%>. </h1>
	<h1> 귀사 <%=FirmName%>의 관리화면입니다.</h1>
	<br> <br>
	
	<input type='button' value='마법상회 정보 관리' onclick = "ManageMyFirmInfo();">
	<input type='button' value='재료 재고 관리' onclick = "IngredientManage();">
	<input type='button' value='신규 마법사 등록' onclick = "EnrollMagician();">
	<input type='button' value='상회 거래 내역 확인' onclick = "ShowFirmTradeInfo();">
	
	<br> <br>
	
	<div id = "workspace"> 
	</div>
	
	
</body>
</html>