<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import="java.sql.DriverManager" %>

<%@ page import="java.sql.Connection" %>

<%@ page import="java.sql.Statement" %>

<%@ page import="java.sql.ResultSet" %>

<%@ page import = "java.sql.PreparedStatement" %>

<%@ page import="java.sql.SQLException" %>

<% request.setCharacterEncoding("utf-8"); %>

<% String ID =request.getParameter("id"); %>
<% String PW = request.getParameter("pwd"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
</head>
<body>
<% 
    Connection conn=null;

    PreparedStatement pstmt=null;

    ResultSet rs=null;

    

    try{

    String jdbcDriver ="jdbc:mariadb://localhost:3306/lodos";

	String dbUser="root";

    String dbPass="31337";

    String query="select count(*) as cnt from 마법사 where ID=? and 비밀번호 = AES_ENCRYPT(?, SHA2('key', 512))";

     //2.데이터 베이스 커넥션 생성

     conn=DriverManager.getConnection(jdbcDriver,dbUser,dbPass);

     //3.Statement 생성

     pstmt=conn.prepareStatement(query);
     pstmt.setString(1, ID);
     pstmt.setString(2, PW);
     rs=pstmt.executeQuery();
     rs.next();
     
     if(rs.getString("cnt").equals("1")) {
    	 session.setAttribute("ID", ID);
    	 session.setAttribute("PW", PW);
    	 response.sendRedirect("MagicianSuccess.jsp");
     }
     else {
    	 query = "select count(*) as cnt from 마법상회 where ID=? and 비밀번호 = AES_ENCRYPT(?, SHA2('key', 512))";
    	 
    	 pstmt=conn.prepareStatement(query);
         pstmt.setString(1, ID);
         pstmt.setString(2, PW);
         rs=pstmt.executeQuery();
         rs.next();
         
         if(rs.getString("cnt").equals("1")) {
        	 session.setAttribute("ID", ID);
        	 session.setAttribute("PW", PW);
        	 response.sendRedirect("FirmSuccess.jsp");
         }
         else {
        	 query = "select count(*) as cnt from 소비자 where ID=? and 비밀번호 = AES_ENCRYPT(?, SHA2('key', 512))";
        	 
        	 pstmt=conn.prepareStatement(query);
             pstmt.setString(1, ID);
             pstmt.setString(2, PW);
             rs=pstmt.executeQuery();
             rs.next();
             
             if(rs.getString("cnt").equals("1")) {
            	 session.setAttribute("ID", ID);
            	 session.setAttribute("PW", PW);
            	 response.sendRedirect("CustomerSuccess.jsp");
             }
             else {
            	 response.sendRedirect("Fail.jsp");
             }
         }
     }
    }catch(Exception e) {}

%>
</body>
</html>