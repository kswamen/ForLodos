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
    
    request.setCharacterEncoding("utf-8");
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
	    
	    String myID = null;
	    String myname = null;
	    String myage = null;
	    String mytribe = null;
	    String myhometown = null;
	    String myjob = null;
	    String myclass = null;
	    String myproperty = null;
	    String mymana = null;
	    String mymoney = null;
	    String myfirm = null;
	    String myfirmID = null;
	    ArrayList<String> firmlist = new ArrayList<String>();
		ArrayList<String> ingredlist = new ArrayList<String>();
	    
	    try{
	
	    query="select * from 마법사 where ID=?";
	
	     pstmt=conn.prepareStatement(query);
	     pstmt.setString(1, (String)session.getAttribute("ID"));
	     rs=pstmt.executeQuery();
	     rs.next();
	     
	     myID = rs.getString("ID");
	     myname = rs.getString("이름");
	     myage = rs.getString("나이");
	     mytribe = rs.getString("종족");
	     myhometown = rs.getString("출신지");
	     myjob = rs.getString("직업");
	     myclass = rs.getString("클래스");
	     myproperty = rs.getString("속성");
	     mymana = rs.getString("마나량");
	     mymoney = rs.getString("자금");
	     myfirmID = rs.getString("소속상회ID");
	     
	     query = "select * from 마법사, 마법상회 where 마법사.ID = ? and 마법사.소속상회ID = 마법상회.ID";
	     pstmt=conn.prepareStatement(query);
	     pstmt.setString(1, (String)session.getAttribute("ID"));
	     rs=pstmt.executeQuery();
	     rs.next();
	     
	     myfirm = rs.getString("마법상회.상호");
	     
	     query = "select * from 마법상회";
	     pstmt=conn.prepareStatement(query);
	     rs=pstmt.executeQuery();
	     
	     while(rs.next()) {
	    	 String a = null;
	    	 String b = null;
	    	 String c = null;
	    	 
	    	 a = rs.getString("상호");
	    	 b = rs.getString("거래허가속성");
	    	 c = rs.getString("ID");
	    	 
	    	 firmlist.add(a + ", " + b + ", " + c);
	     }
	     
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
	var myID = "<%=myID%>";
	var myname = "<%=myname%>";
	var myage = "<%=myage%>";
	var mytribe = "<%=mytribe%>";
	var myhometown = "<%=myhometown%>";
	var myjob = "<%=myjob%>";
	var myclass = "<%=myclass%>";
	var myproperty = "<%=myproperty%>";
	var mymana = "<%=mymana%>";
	var mymoney = "<%=mymoney%>";
	var myfirm = "<%=myfirm%>";
	var myfirmID = "<%=myfirmID%>"
		
		function DeleteAll() {
	 		document.getElementById("workspace").innerHTML = "";
		}
	
		function ShowMyInfo() {
			
			DeleteAll();
			
			var txt = "<form action = 'UpdateMagicianInfo.jsp' method = 'post'>"  
				+ "ID : <input type = 'text' name = 'ID' value = " + myID + " readonly> <br>" 
				+ "이름 : <input type = 'text' name = 'name' value = " + myname + "> <br>" 
				+ "나이 : <input type = 'number' name = 'age' min = '1' max = '3000' value = " + myage + "> <br>" 
				+ "종족 : <input type = 'text' name = 'tribe' value = " + mytribe + "> <br>" 
				+ "출신지 : <input type = 'text' name = 'hometown' value = " + myhometown + "> <br>" 
				+ "직업 : <input type = 'text' name = 'job' value = " + myjob + "> <br>" 
				+ "클래스 : <input type = 'number' name = 'class' min = '1' max = '10' value = " + myclass + "> <br>" 
				+ "속성 : <select name = 'property'>"
				+ "<option value = " + myproperty + ">" + "현재 속성 : " + myproperty + "</option> <br>" 
				+ "<option value = '그림자'> 그림자 </option>"
				+ "<option value = '불'> 불 </option>"
				+ "<option value = '빛'> 빛 </option>"
				+ "<option value = '얼음'> 얼음 </option>"
				+ "<option value = '전기'> 전기 </option>"
				+ "<option value = '바람'> 바람 </option>"
				+ "<option value = '독'> 독 </option>"
				+ "<option value = '대지'> 대지 </option>"
				+ "<option value = '바다'> 바다 </option>"				
			 	+ "</select> <br>"
				+ "마나량 : <input type = 'text' name = 'mana' value = " + mymana + "> <br>" 
				+ "자금 : <input type = 'number' name = 'money' min = '0' value = " + mymoney + "> <br>" 
				+ "소속상회 : <select name = 'FirmID'>"
				+ "<option value = " + myfirmID + ">" + "현재 소속 상회 : " + myfirm + "</option>";
				
				<%for(int i=0; i<firmlist.size(); i++) {%>
					txt = txt + "<option value = " + '<%= firmlist.get(i).split(",")[2]%>' + ">" + '<%=firmlist.get(i)%>' + "</option>";
				<%}%>
			
			txt = txt + "</select> <br>" 
				+ "<input type = 'submit' value = '정보 수정'>"
				+ "</form>" ;
			document.getElementById("workspace").innerHTML += txt;
		}
		
		function RegistMagic() {
			DeleteAll();
			
			var txt = "<form action = 'RegistMagic.jsp' method = 'post'>"
				+ "이름 : <input type = 'text' name = 'name'> <br>"
				+ "설명 : <input type = 'text' size = '50' name = 'desc'> <br>"
				+ "클래스 : <input type = 'number' name = 'class' min = '1' max = '10'> <br>" 
				+ "속성 : <input type = 'text' name = 'property' value = " + myproperty + " readonly> <br>"
				+ "종류 :  <select name = 'kind'>"
				+ "<option value = ''>" + "마법 종류 선택" + "</option>" 
				+ "<option value = '공격'> 공격 </option>"
				+ "<option value = '도움'> 도움 </option>"
				+ "<option value = '변형'> 변형 </option>"
				+ "<option value = '창조'> 창조 </option>"
				+ "</select> <br>"
				+ "효과량 : <input type = 'number' name = 'amount' min = '1'> <br>" 
				+ "필요 재료 : <select name = 'ingredientID'>"
				+ "<option value = ''> 재료 선택 </option>";  
				<%for(int i=0; i<ingredlist.size(); i++) {%>
				txt = txt + "<option value = " 
				+ '<%= ingredlist.get(i).split(",")[0]%>' + ">" + '<%=ingredlist.get(i)%>' + "</option>";
				<%}%>
			txt = txt + "</select>"
				+ "필요한 재료의 양: <input type = 'number' name = 'need' min = '0'> <br>"
				+ "마나소비량 : <input type = 'number' name = 'manaconsume' min = '0'> <br>" 
				+ "판매가격 : <input type = 'number' name = 'price' min = '0'> <br>" 
				+ "제작마법사ID : <input type = 'text' name = 'magicianID' value = " + myID + " readonly> <br>" 
				+ "<input type = 'submit' value = '마법 등록'>"
				+ "</form>";
			document.getElementById("workspace").innerHTML += txt;
		}
		
		function ShowMyMagicList() {
			DeleteAll();
			
			var txt = "<form action = 'MagicSearch.jsp' method = 'post'>" 
				+ "마법사 ID : <input type = 'text' name = 'magicianID' value = " + myID + " readonly>"
				+ "마법 이름 : <input type = 'text' name = 'name'>"
				+ "클래스 : <input type = 'number' min = '1' max = '10' name = 'class'>" 
				+ "종류 :  <select name = 'kind'>"
				+ "<option value = ''>" + "마법 종류 선택" + "</option>" 
				+ "<option value = '공격'> 공격 </option>"
				+ "<option value = '도움'> 도움 </option>"
				+ "<option value = '변형'> 변형 </option>"
				+ "<option value = '창조'> 창조 </option>"
				+ "</select>"
				+ "<input type = 'submit' value = '검색' >"
				+ "</form>";
			document.getElementById("workspace").innerHTML += txt;
		}
		
		function RegistIngredient() {
			DeleteAll();
			
			var txt = "<form action = 'RegistIngredient.jsp' method = 'post'>"
				+ "이름 : <input type = 'text' name = 'name'> <br>"
				+ "원산지 : <input type = 'text' name = 'origin'> <br>"
				+ "종류 :  <select name = 'kind'>"
				+ "<option value = ''>" + "재료 종류 선택" + "</option>" 
				+ "<option value = '식물성'> 식물성 </option>"
				+ "<option value = '동물성'> 동물성 </option>"
				+ "<option value = '광물성'> 광물성 </option>"
				+ "</select> <br>"
				+ "가격 : <input type = 'number' name = 'price' min = '0'> <br>" 
				+ "<input type = 'submit' value = '재료 등록'>"
				+ "</form>";
			document.getElementById("workspace").innerHTML += txt;
		}
		
		function ShowMyMagicTrade() {
			DeleteAll();
			
			var txt = "<table id = 'table' border = '1'>"
	 			+ "<th> 상회명 </th>"
	 			+ "<th> 고객명 </th>"
	 			+ "<th> 마법명 </th>"
	 			+ "<th> 판매일자 </th>"
	 			+ "<th> 판매가격 </th>";
				
			<%
				 query="select * from 고객마법거래정보, 마법상회, 소비자, 마법 "
				 	+ "where 고객마법거래정보.상회ID = 마법상회.ID and 고객마법거래정보.고객ID = 소비자.ID and "
				 	+ "고객마법거래정보.마법ID = 마법.ID and 마법.제작마법사ID = '" + myID + "';";
				
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
			     
					 %>
				txt +=  "</table> <br> <br>";
			document.getElementById("workspace").innerHTML += txt;
		}
	
	</script>
	
	<h1> 어서 오세요, <%=myname%>. </h1> <br> <br>
	
	<input type='button' value='내 정보 보기' onclick = "ShowMyInfo();">
	<input type='button' value='새로운 마법 등록' onclick = "RegistMagic();">
	<input type='button' value='내가 창조한 마법 보기' onclick = "ShowMyMagicList();">
	<input type='button' value='새로운 재료 등록' onclick = "RegistIngredient();">
	<input type='button' value='마법 거래 내역 확인' onclick = "ShowMyMagicTrade();"> <br> <br>
	
	<div id = "workspace"> 
	</div>
	
	
</body>
</html>