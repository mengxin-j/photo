<%@ page import="java.util.*,java.sql.*,chatsys.db.*"  contentType="text/html;charset=utf-8" %>
<html>
<head>
    <title>商城客服中心</title>
    <meta charset="utf8">
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" type="text/css"  href="css/cssMain.css" /> 
    <link rel="stylesheet" type="text/css"  href="css/cssStyle.css" />    
	<link rel="stylesheet" type="text/css"  href="css/chat.css" />
	<script type="text/javascript" src="Scripts/jquery.js"></script>
	<script type="text/javascript"  src="Scripts/jquery.contextmenu.js"></script>
<style type="text/css">
       .contextMenu {display:none}
       ul li {font-size:9pt}
</style>    
</head>
<body >
<div class="top">
    <div class="topcontent">
        <div class="logo">
            <img src="img/logo.png" width=142 height=30 />
            <div id="flashcontent"></div>
        </div>
        <div class="status">
            <img src="img/online.gif" /><span id="online">客服服务中心</span>
        </div>
    </div>
</div>

<div id="divMain">  
<div class="userListBox" >  
    <div class="userListPane" >
        <div class="chat03">
            <div class="chat03_title">
                <label class="chat03_title_t">客户咨询</label>
            </div>
            <div class="chat03_content" id="chat03_content">
                <ul>

                </ul>
            </div>
        </div>
    </div>
    
    <div style="clear: both;"></div>
</div>       
</div>

<div class="divfoot">
	<span class="pt"> 在线客服 | Copyright © 2016-2020 GDKM All Right Reserved  版权所有《乐乒商城智能客服系统服务条款》 </span>
</div>

</body>
</html>
<script>
//请求加载群聊用户列表
function getOnlineList(){
	$.ajax({
		type: "post",
		url: "KefuServlet?action=OnlineList&t="+new Date().getTime(),
		success:function(responseText){
			var userObj=eval("("+responseText+")");
			var userList="";
			for (var i = 0; i < userObj.length; i++) {
				var userli="<li class='choosed' id='"+userObj[i]["loginName"]+"'>"
					+"<label class='online'></label>"
					+"<a target='_blank' href='kefu.jsp?cust="+userObj[i]["loginName"]+"'><img src='"+userObj[i]["memberPic"]+"'></a>"
					+"<a target='_blank' href='kefu.jsp?cust="+userObj[i]["loginName"]+"' class='chat03_name'>"+userObj[i]["loginName"]+"</a></li>";
				userList+=userli;
			}
			$(".chat03_content ul").html(userList);
		}
	});
	setTimeout(getOnlineList,2000);
}

$(document).ready(function(){
	getOnlineList();
});
</script>
