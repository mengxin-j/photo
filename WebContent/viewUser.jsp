<%@ page language="java" import="java.util.*,java.sql.*,chatsys.db.*"  contentType="text/html;charset=utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>查看个人信息</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="css/chat.css" />
<script type="text/javascript" src="jquery.js"></script>
</head>
<body>
<%
	String toUser=request.getParameter("touser");
	String toUserImg="";
	String memberName="";
	String sex="";
	String qq="";
	String email="";
	ConnDB conn=new ConnDB();
	String sql = "select * from member where loginName='"+toUser+"'";
	ResultSet rs=conn.doQuery(sql);
	if(rs.next()){
		toUserImg=rs.getString("MemberPic");
		memberName=rs.getString("memberName");
		sex=rs.getString("sex");
		qq=rs.getString("qq");
		email=rs.getString("email");
	}
%>
<div class="regBox">
    <div class="chat03">
	    <div class="chat03_title">
	        <label class="chat03_title_t">查看用户资料</label>
	    </div>
	    <div class="chat03_content" >
		     &nbsp;<img src="<%=toUserImg %>" /> 
		     &nbsp;<span style="font-size:28px;"><%=toUser %></span><br/><br/>
		     <div style="line-height:28px;background:#fffeee" >
			     <p style="font-size:14px;">&nbsp;&nbsp;昵称：<%=memberName %> </p>
			     <p style="font-size:14px;">&nbsp;&nbsp;性别：<%=sex %> </p>
			     <p style="font-size:14px;">&nbsp;&nbsp;邮箱：<%=email %></p>
			     <p style="font-size:14px;">&nbsp;&nbsp;QQ：<%=qq %> </p>
		     </div>     
	     </div>
	</div>
</div>
</body>
</html>

