<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %>
<%@ page import = "dao.*" %>
<%@ page import = "vo.*" %> 
<%@ page import = "java.net.*"%>
<%
	//Controller
	request.setCharacterEncoding("UTF-8"); // 인코딩
	
	if(session.getAttribute("loginMember") == null) {
		// 로그인 되지 않은 상태
			response.sendRedirect(request.getContextPath()+"/loginForm.jsp");
			return;
		}
	//session에 지정된 멤버(현재 로그인 사용자)
	Member loginMember = (Member)session.getAttribute("loginMember");
	
	// null값이나 공백있으면 돌려보내기
	if(request.getParameter("helpNo") == null ||
		request.getParameter("helpNo").equals("") ||
		request.getParameter("helpMemo") == null ||
		request.getParameter("helpMemo").equals("")) {
			response.sendRedirect(request.getContextPath()+"/admin/categoryList.jsp");
			return;

	}
		
	int helpNo = Integer.parseInt(request.getParameter("helpNo"));
	String helpMemo = request.getParameter("helpMemo");
	
	// Model 호출
	HelpDao helpDao = new HelpDao();
	int row = helpDao.updateHelp(helpMemo, helpNo);
	
	if(row == 1) {
		System.out.println("수정성공");
		response.sendRedirect(request.getContextPath()+"/help/helpList.jsp");
		return;
	} else {
		System.out.println("수정실패");
	}
%>
	
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

</body>
</html>