<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "vo.*" %>
<%@ page import = "dao.*"%>
<%@ page import = "java.util.*"%>
<%@ page import = "java.net.*" %>
<%@ page import = "java.sql.*" %>
<%
	//Controller
	Member loginMember = (Member)session.getAttribute("loginMember");
	if(loginMember == null || loginMember.getMemberLevel() < 1) {
		response.sendRedirect(request.getContextPath()+"/loginForm.jsp");
		return;
	}
	
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	
	
	// Model 호출

	NoticeDao noticeDao = new NoticeDao();
	Notice updateNotice = noticeDao.selectNoticeOne(noticeNo);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>공지 수정</h1>
	<form action="<%=request.getContextPath()%>/admin/noticeUpdateAction.jsp" method="post">
		<table>
			<tr>
				<td>공지 내용</td>
				<td><textarea rows="5" cols="100" name="noticeMemo"><%=updateNotice.getNoticeMemo()%></textarea></td>
			</tr>
		</table>
		<input type="hidden" name="noticeNo" value="<%=updateNotice.getNoticeNo()%>">
		<button type="submit">수정</button>
	</form>
</body>
</html>