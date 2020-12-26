<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Insert title here</title>
</head>
<body>
	<h3> 회원 가입 섹션</h3><br><br>
	<h4>생성할 회원 유형을 선택해 주세요.</h4> <br>
	
	<form action = "SignUpSelected.jsp" method = "post">
		<input type="radio" name="radio" id="r1" value="Magician" checked><label for="r1">마법사</label>
	 	<input type="radio" name="radio" id="r2" value="Firm"><label for="r2">마법상회</label>
	 	<input type="radio" name="radio" id="r3" value="Customer"><label for="r3">고객</label>
 	
		<input type = "submit" value = "회원가입">
	</form>
</body>
</html>