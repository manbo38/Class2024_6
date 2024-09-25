<%@page import="java.text.SimpleDateFormat"%>
<%@page import="reboard.BoardDataBean"%>
<%@page import="java.util.List"%>
<%@page import="reboard.BoardDBBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 목록</title>
</head>
<body>

<%
	//1. 한 화면(페이지)에 출력할 데이터 갯수  
	int page_size = 10;

	String pageNum = request.getParameter("page");
	if(pageNum == null){
		pageNum = "1";		// 1page : 최근글이 보이는 페이지
	}
	
	//2. 현재 페이지 번호
	int currentPage = Integer.parseInt(pageNum);

	//3. 총데이터 갯수
	int count = 0;
	
	BoardDBBean dao = BoardDBBean.getInstance();
	count = dao.getCount();
	System.out.println("count:"+ count);	
	
	// startRow : 각 page에 추출할 데이터의 시작번호
	// endRow : 각 page에 추출할 데이터의 끝번호
	// 1page :  startRow=1,   endRow=10
	// 2page :  startRow=11,  endRow=20
	// 3page :  startRow=21,  endRow=30
	int startRow = (currentPage - 1) * page_size + 1;
	int endRow = currentPage * page_size;
	
	List<BoardDataBean> list = null;
	if(count > 0){
		list =  dao.getList(startRow, endRow);
	}
	System.out.println("list:"+ list);	
	
	if(count == 0){  %>
		작성된 글이 없습니다.
<%	}else{ %>
		<a href="writeForm.jsp">글작성</a>	
		글갯수 : <%=count %>개
		
		<table border=1 width=700 align=center>
			<caption>게시판 목록</caption>
			<tr>
				<th>번호</th>
				<th>제목</th>
				<th>작성자</th>
				<th>작성일</th>
				<th>조회수</th>
				<th>ip주소</th>
			</tr>
<%			
			// number : 웹 브라우저에서 각 페이지에 출력될 시작 번호
			int number = count - (currentPage-1) * page_size;

			SimpleDateFormat sd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 

			for(int i=0; i<list.size(); i++){
				BoardDataBean board = list.get(i);
%>
			<tr>
				<td><%=number-- %></td>			
				<td>
<%
				// 댓글 제목 앞에 여백 추가	
				if(board.getRe_level() > 0){	// 댓글
					for(int j=1; j<=board.getRe_level(); j++){  %>
						&nbsp;&nbsp;					
<%					}					
				}				
%>	
<a href="content.jsp?num=<%=board.getNum()%>&page=<%=currentPage%>">
				<%=board.getSubject() %>
</a>				
				</td>			
				<td><%=board.getWriter() %></td>			
				<td><%=sd.format(board.getReg_date()) %></td>			
				<td><%=board.getReadcount() %></td>			
				<td><%=board.getIp() %></td>			
			</tr>				
<%			}// for end
%>
		</table>
<%	} %>

<!-- 페이지 링크 -->
<center>
<% 
if(count > 0){

	// pageCount : 총 페이지수
	int pageCount = count/page_size + ((count%page_size==0) ? 0 : 1);
	
	// startPage : 각 블럭의 시작 페이지 번호 : 1, 11, 21...
	// endPage : 각 블럭의 끝 페이지 번호 :    10, 20, 30...
	int startPage = ((currentPage-1)/10) * 10 + 1;
	int block = 10;		// 1개의 블럭은 10개의 page로 구성
	int endPage =  startPage + block - 1;	
	
	// 가장 마지막 블럭에는 endPage값을 pageCount값으로 수정
	if(endPage > pageCount){
		endPage = pageCount;
	}
%>	
	<!-- 1page로 이동 -->
	<a href="list.jsp?page=1" style="text-decoration:none"> < </a>
	
<%
	// 이전 블럭으로 이동
	if(startPage > 10){  %>a
		<a href="list.jsp?page=<%=startPage-10%>">[이전]</a>	
<%	}

	// 각 블럭당 10개의 페이지 출력
	for(int i=startPage; i<=endPage; i++){
		if(i == currentPage){   // 현재 페이지 %>
			[<%=i %>]		
<%		}else{   %>
			<a href="list.jsp?page=<%=i%>">[<%=i %>]</a>		
<%		}		
	}
	
	// 다음 블럭으로 이동
	if(endPage < pageCount){   %>
		<a href="list.jsp?page=<%=startPage+10%>">[다음]</a>	
<%	}%>	
	
	<!-- 마지막 페이지로 이동 -->
	<a href="list.jsp?page=<%=pageCount%>" style="text-decoration:none"> > </a>
	
<%	
}  // if end
%>
</center>

</body>
</html>



