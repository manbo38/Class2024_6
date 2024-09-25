<%@page import="reboard.BoardDBBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%  request.setCharacterEncoding("utf-8"); %>

<jsp:useBean id="board" class="reboard.BoardDataBean"/>
<jsp:setProperty property="*" name="board"/>    

<%
	// 클라이언트의 ip주소 구하기
	String ip = request.getRemoteAddr();
	board.setIp(ip);
	
	BoardDBBean dao = BoardDBBean.getInstance();
	int result = dao.insert(board);		// 원문 글작성
	
	if(result == 1){
%>
		<script>
			alert("글작성 성공");
			location.href="list.jsp";
		</script>		
<%	}else{ %>
		<script>
			alert("글작성 실패");
			history.go(-1);
		</script>
<%	} %>