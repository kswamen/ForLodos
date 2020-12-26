<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.DriverManager" %>

<%@ page import="java.sql.Connection" %>

<%@ page import="java.sql.Statement" %>

<%@ page import="java.sql.ResultSet" %>

<%@ page import = "java.sql.PreparedStatement" %>

<%@ page import="java.sql.SQLException" %>
   
<% String type =request.getParameter("radio"); %>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Insert title here</title>
</head>
<body>
	<%
		if(type.equals("Magician")) {
	%>
	<form action = "SignUp_MagicianInfo.jsp" method = "post">
		이름 : <input type= "text" name = "name"> <br>
		비밀번호: <input type = "password" name = "pwd"> <br>
		나이 : <input type = "number" name = "age" min = "1" max = "3000"> <br>
		종족 : <input type = "text"  name = "tribe"> <br>
		출신지 : <input type = "text" name = "hometown"> <br>
		직업 : <input type = "text" name = "job"> <br>
		클래스: <input type = "number" name = "class" min = "1" max = "10"> <br>
		속성 : <select name = "property">
			<option value = ""> 속성 선택 </option>
			<option value = "그림자"> 그림자 </option>
			<option value = "대지"> 대지 </option>
			<option value = "불"> 불 </option>
			<option value = "빛"> 빛 </option>
			<option value = "얼음"> 얼음 </option>
			<option value = "전기"> 전기 </option>
			<option value = "바람"> 바람 </option>
			<option value = "독"> 독 </option>
			<option value = "바다"> 바다 </option>
		</select> <br>
		마나량 : <input type= "text" name = "mana"> <br>
		자금 : <input type = "number" name = "money" value = "1000" min = "0"> <br>
		소속상회 : <select name = "FirmName">
			<%
				Connection conn=null;
				PreparedStatement pstmt=null;
				ResultSet rs=null;
				
				try{
					response.setContentType("text/html; charset=utf-8");
					String jdbcDriver ="jdbc:mariadb://localhost:3306/lodos?useUnicode=true&characterEncoding=UTF-8";

					String dbUser="root";

					String dbPass="31337";

					String query = "select ID, 상호, 거래허가속성 from 마법상회";

				 	conn=DriverManager.getConnection(jdbcDriver,dbUser,dbPass);
					pstmt=conn.prepareStatement(query);
					rs=pstmt.executeQuery();
					
			 
			%>
					<option value=""> 상회 선택 </option>
			<% 
					while(rs.next()) {
						String temp = rs.getString("상호") + "(" + rs.getString("거래허가속성") + ")";
			%>
						<option value='<%= rs.getString("상호") %>'> <%=temp%> </option> 
			<%
					}
				}catch(Exception e) { 
				System.out.println(e);
			}
			%>
		</select>
		<br>
		<input type = "submit" value = "확인">
	</form>
	<%
		}
	
		else if(type.equals("Firm")) {
	%>
	<form action = "SignUp_FirmInfo.jsp" method = "post"> 
		상호 : <input type= "text" name = "name"> <br>
		비밀번호: <input type = "password" name = "pwd"> <br>
		주소 : <input type = "text" name = "address"> <br>
		대표자 이름 : <input type= "text" name = "owner"> <br>
		거래허가속성 : <select name = "property">
			<option value = ""> 속성 선택 </option>
			<option value = "그림자"> 그림자 </option>
			<option value = "대지"> 대지 </option>
			<option value = "불"> 불 </option>
			<option value = "빛"> 빛 </option>
			<option value = "얼음"> 얼음 </option>
			<option value = "전기"> 전기 </option>
			<option value = "바람"> 바람 </option>
			<option value = "독"> 독 </option>
			<option value = "바다"> 바다 </option>
		</select> <br>
		거래허가클래스 : <input type = "number" name = "class" min = "1"> <br>
		소지금 : <input type = "number" name = "money" value = "1000000" min = "0"> <br>
		<input type = "submit" value = "확인">
	</form>
	<% 
		}
	
		else if(type.equals("Customer")) {
	%>
	<form action = "SignUp_CustomerInfo.jsp" method = "post">
		이름 : <input type= "text" name = "name"> <br>
		비밀번호: <input type = "password" name = "pwd"> <br>
		나이 : <input type = "number" name = "age" min = "1" max = "3000"> <br>
		주소 : <input type = "text" name = "address"> <br>
		속성 : <select name = "property">
			<option value = ""> 속성 선택 </option>
			<option value = "그림자"> 그림자 </option>
			<option value = "대지"> 대지 </option>
			<option value = "불"> 불 </option>
			<option value = "빛"> 빛 </option>
			<option value = "얼음"> 얼음 </option>
			<option value = "전기"> 전기 </option>
			<option value = "바람"> 바람 </option>
			<option value = "독"> 독 </option>
			<option value = "바다"> 바다 </option>
		</select> <br>
		소지금 : <input type = "number" name = "money" value = "1000" min = "0"> <br>
		<input type = "submit" value = "확인">
	</form>
	<% 
	
		}
	%>
	
</body>
</html>