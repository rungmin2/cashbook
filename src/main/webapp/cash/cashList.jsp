<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="dao.*" %>
<%@ page import="util.*" %>
<%@ page import="vo.*" %>
<%
	if(session.getAttribute("loginMember") == null) {
	// 로그인 되지 않은 상태
		response.sendRedirect(request.getContextPath()+"/loginForm.jsp");
		return;
	}
	
	
	// Controller : session, request
	//session에 지정된 멤버(현재 로그인 사용자)
	Member loginMember = (Member)session.getAttribute("loginMember");
	String memberId = request.getParameter("memberId");
	// request 년 + 월 넘어와야 함
	int year = 0;
	int month = 0;
	
	if(request.getParameter("year") == null || request.getParameter("month") == null) {
		Calendar today = Calendar.getInstance(); // 오늘날짜
		year = today.get(Calendar.YEAR);
		month = today.get(Calendar.MONTH);	
	} else {
		year = Integer.parseInt(request.getParameter("year"));
		month = Integer. parseInt(request.getParameter("month"));
		// month -> -1, month -> 12 일경우
		if(month == -1) {
			month = 11;
			year -= 1;
		}
		if(month == 12) {
			month = 0;
			year += 1;
		}
	}
	// 출력하고자 하는 년,월과 월의1일의 요일(일요일 1, 월요일 2, 화요일 3, ..........토요일 7)
	Calendar targetDate = Calendar.getInstance();
	targetDate.set(Calendar.YEAR, year);
	targetDate.set(Calendar.MONTH, month);
	targetDate.set(Calendar.DATE, 1);
	
	// firstDay는 1일의 요일
	int firstDay = targetDate.get(Calendar.DAY_OF_WEEK); 
	
	// begin blank 개수는 firstDay - 1
	// 마지막날짜
	int lastDate = targetDate.getActualMaximum(Calendar.DATE);
	
	// 달력 출력테이블의 시작 공백셀(td)과 마지막 공백셀(td)의 개수
	int beginBlank = firstDay -1;
	int endBlank = 0; // beginBlank + lastDate + endBlank --> 7로 나누어 떨어진다
	if((beginBlank +lastDate) % 7 != 0) {
		endBlank = 7 - ((beginBlank +lastDate) % 7);
	}
	
	// 전체 td의 개수 : 7로 나누어 떨어져야 한다
	int totalTd = beginBlank + lastDate + endBlank;
	
	// Model 호출 : 일별 cash 목록
	CashDao cashDao = new CashDao();
	ArrayList<HashMap<String, Object>> list = cashDao.selectCashListByMonth(loginMember.getMemberId(), year, month+1);
	
	// view : 달력출력 + 일별 cash 목록 출력
%>
<!DOCTYPE html>
<html>

<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<link rel="stylesheet" href="../regal/regal/vendors/mdi/css/materialdesignicons.min.css">
	<link rel="stylesheet" href="../regal/regal/vendors/feather/feather.css">
	<link rel="stylesheet" href="../regal/regal/vendors/base/vendor.bundle.base.css">
	<link rel="stylesheet" href="../regal/regal/vendors/flag-icon-css/css/flag-icon.min.css">
	<link rel="stylesheet" href="../regal/regal/vendors/font-awesome/css/font-awesome.min.css">
	<link rel="stylesheet" href="../regal/regal/vendors/jquery-bar-rating/fontawesome-stars-o.css">
	<link rel="stylesheet" href="../regal/regal/vendors/jquery-bar-rating/fontawesome-stars.css">
	<link rel="stylesheet" href="../regal/regal/css/style.css">
	<link rel="shortcut icon" href="../regal/regal/images/favicon.png">
</head>
<body>
	<div>
		<jsp:include page="/inc/header2.jsp"></jsp:include>		        		
	</div>
	<div class="container-fluid page-body-wrapper">	
		<jsp:include page="/inc/main.jsp"></jsp:include>
    		<div class="main-panel">
       			<div class="content-wrapper">
         			<div class="row">
           				<div class="col-sm-12 mb-4 mb-xl-0">
             				<h4 class="font-weight-bold text-dark">Hi, welcome back!</h4>
           					<p class="font-weight-normal mb-2 text-muted"></p>
           				</div>
         			</div>
         			<div class="row mt-3">
           				<div class="col-xl-3 flex-column d-flex grid-margin stretch-card">
             				<div class="row flex-grow">
               					<div class="col-sm-12 grid-margin stretch-card">
                   					<div class="card">
                     					<div class="card-body">
                         					<h2><%=year%>년<%=month+1%>월</h2>
                       						<p class="card-title">이번달 총 수입</p>
                         					<h4 class="text-dark font-weight-bold mb-2">1111</h4>
                       						<img src="../regal/regal/images/faces/smiley.jpg">
                         					<canvas id="customers"></canvas>
                     					</div>
                   					</div>
               					</div>
               					<div class="col-sm-12 stretch-card">
                   					<div class="card">
                     					<div class="card-body">
                        					<h2><%=year%>년<%=month+1%>월</h2>
                         					<p class="card-title">이번달 총 지출</p>
                         					<h4 class="text-dark font-weight-bold mb-2">55,543</h4>
                         					<img src="../regal/regal/images/faces/sad.png">
                         					<canvas id="orders"></canvas>
                     					</div>
                   					</div>
              					</div>
             				</div>
	 					</div>
						<div class="col-xl-9 d-flex grid-margin stretch-card">
               				<div class="card">
                 				<div class="card-body">
                     				<h4 class="card-title">수입지출 목록</h4>
                     				<h3><%=year%>년<%=month+1%>월</h3>
                   					<div class="row">
                       					<div class="col-lg-5">
                         					<p>월 수입과 지출을 확인해보세요</p>
											<a href="<%=request.getContextPath()%>/cash/cashList.jsp?year=<%=year%>&month=<%=month-1%>" class="btn btn-outline-secondary btn-sm">&#8701;이전달</a>
											<a href="<%=request.getContextPath()%>/cash/cashList.jsp?year=<%=year%>&month=<%=month+1%>" class="btn btn-outline-secondary btn-sm">다음달&#8702;</a>
                       					</div>
				                  		<table class="table table-header-bg table-bordered">
												<tr>
													<th>일</th>
													<th>월</th>
													<th>화</th>
													<th>수</th>
													<th>목</th>
													<th>금</th>
													<th>토</th>
												</tr>
												<tr>
													<%
														for(int i=1; i<=totalTd; i++) {
													%>
															<td>
													<%
																int date = i-beginBlank;
																if(date > 0 && date <= lastDate) {			
													%>
																	<div>
																		<a href="<%=request.getContextPath()%>/cash/cashDateList.jsp?year=<%=year%>&month=<%=month+1%>&date=<%=date%>">
																			<%=date%>
																		</a>
																	</div>
																	<div>
																		<%
																			for(HashMap<String, Object> m : list ) {
																				String cashDate = (String)(m.get("cashDate"));
																				if(Integer.parseInt(cashDate.substring(8)) == date) {
																		%>	
																						
																					[<%=(String)(m.get("categoryKind"))%>]
																					<%=(String)(m.get("categoryName"))%>
																					&nbsp;
																					<%=(Long)(m.get("cashPrice"))%>원
																					<br>		
																		<%
																		
																				}
																			}
																		%>
																	</div>
													<%
																}
													%>		
															</td>
													<%
															if(i%7 == 0 && i != totalTd) {
													%>
																</tr><tr> <!-- td7개 만들고 테이블 줄바꿈 -->
													<%
															}
														}
													%>		
												</tr>		
											</table>	
									</div>
								</div>
							</div>
      					</div>
						<div class="row">
         				</div>
         			</div>
       			</div>
        		<!-- content-wrapper ends -->
        		<!-- partial:partials/_footer.html -->
        		<footer class="footer">
   					<div class="d-sm-flex justify-content-center justify-content-sm-between">
          				<span class="text-muted d-block text-center text-sm-left d-sm-inline-block">Copyright © bootstrapdash.com 2020</span>
            			<span class="float-none float-sm-right d-block mt-1 mt-sm-0 text-center"> Free <a href="https://www.bootstrapdash.com/" target="_blank">Bootstrap dashboard templates</a> from Bootstrapdash.com</span>
        			</div>
         			<span class="text-muted d-block text-center text-sm-left d-sm-inline-block mt-2">Distributed By: <a href="https://www.themewagon.com/" target="_blank">ThemeWagon</a></span> 
       			</footer>
       		</div>	
   	</div>		
</body>
</html>