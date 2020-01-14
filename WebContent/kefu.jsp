<%@ page import="java.util.*,java.sql.*,chatsys.db.*"  contentType="text/html;charset=utf-8" %>
<html>
<head>
    <title>咨询</title>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" type="text/css"  href="css/cssMain.css" /> 
    <link rel="stylesheet" type="text/css"  href="css/cssStyle.css" />    
	<link rel="stylesheet" type="text/css" href="css/chat.css" />
	<script type="text/javascript" src="Scripts/jquery.js"></script>
	<script type="text/javascript"  src="Scripts/jquery.contextmenu.js"></script>
<style type="text/css">
       .contextMenu {display:none}
       ul li {font-size:9pt}
</style>    
</head>
<body >
<%
String cust="";      //顾客账号
String custName="";  //顾客姓名
String custImg="";   //顾客头像

String serv="kefu1";     //客服账号
String servImg="img/head/kefu1.jpg";//客服头像
String servName="客服小飞"; //客服姓名

String userName="";      //发送人账号
String userImg = "";     //发送人头像
String toUserName="";    //接收人账号
String toUserImg = "";   //接收人头像

ConnDB conn=new ConnDB();
if(request.getParameter("cust")!=null){//客服进入聊天界面,发送人为客服
	cust=request.getParameter("cust");
	String sql1="select * from member where loginName='"+cust+"'";
	ResultSet rs=conn.doQuery(sql1);
	if(rs.next()){
		custImg=rs.getString("MemberPic");
		custName=rs.getString("MemberName");
	}
	out.print("<script>document.title = '客服小飞';</script>");	
	userName=serv;              
	userImg = servImg;  
	toUserName=cust;        
	toUserImg = custImg;   
}else{ //顾客进行聊天界面,发送人为顾客
	if(session.getAttribute("loginName")!=null){
		cust=session.getAttribute("loginName").toString();
		String sql1="select * from member where loginName='"+cust+"'";
		ResultSet rs=conn.doQuery(sql1);
		if(rs.next()){
			custImg=rs.getString("MemberPic");
			custName=rs.getString("MemberName");
		}
	}
	out.print("<script>document.title ='"+cust+"在线咨询'</script>");	
	userName=cust;              
	userImg = custImg;  
	toUserName=serv;        
	toUserImg = servImg;
}
 %>
<div class="top">
    <div class="topcontent">
        <div class="logo">
            <img src="img/logo.png" width=142 height=30 />
            <div id="flashcontent"></div>
        </div>
        <div class="status">
            <img src="img/online.gif" /><%=userName%>，<a href="LoginServlet?action=Logout" style="color:white">安全退出</a>
        </div>
    </div>
</div>

<div id="divMain">  
<div class="chatBox" >
	<div class="paneLeft" >
		<img src="img/mall1.png " href="index.html" />
	    <div class="divkefu"><img src="img/head/kefu1.jpg" /><span class="kefutxt" >客服小飞</span></div> 
	</div>
    <div class="chatLeft" >
        <div class="chat01">
            <div class="chat01_title">
                <ul class="talkTo">
                    <li><a href="javascript:;"><span id="user" style="display:none"><%=cust %></span> 
                        <span id="touser"><%=cust%>，正在咨询</span></a>
                    </li>
                </ul>
                <a class="close_btn" href="javascript:;"></a>
            </div>
            <div class="chat01_content" >
                <!-- 聊天内容显示区-->
           		<div class="message_box mes1" style="display: block;"> </div>
           		<div class="message_box mes2" > </div>
                <div class="message_box mes3" > </div>
            </div>
        </div>
        <div class="chat02">
            <div class="chat02_title">
                <!-- 表情面板开关按钮-->
                <a class="chat02_title_btn ctb01" href="javascript:;"></a>
                <label class="chat02_title_t"><a href="chatHistory.jsp?user=<%=cust%>&touser=<%=serv%>" target="_blank">聊天记录</a></label>
                <!-- 表情面板-->
                <div class="wl_faces_box">
                    <div class="wl_faces_content">
                        <div class="title">
                            <ul>
                                <li class="title_name">常用表情</li><li class="wl_faces_close"><span>&nbsp;</span></li>
                            </ul>
                        </div>
                        <div class="wl_faces_main">
                            <ul>
                            </ul>
                        </div>
                    </div>
                    <div class="wlf_icon">
                    </div>
                </div>
            </div>
            <div class="chat02_content">
                 <div id="textarea" style="width:552px;height:96px;" contenteditable="true"></div>              
            </div>
            <div class="chat02_bar">
                <ul>
                    <li style="left: 20px; top: 10px; padding-left: 30px;">24小时在线为您服务！</li>
                    <li style="right: 5px; top: 5px;"><a href="javascript:;"><img src="img/send_btn.jpg"></a></li>
                </ul>
            </div>
        </div>
    </div>   
   
    <div class="chatRight">
        <div class="chat03">
            <div class="chat03_title">
                <label class="chat03_title_t">客户中心</label>
            </div>
            <div class="chat03_content" id="chat03_content">
                <ul>
                    <li class="choosed" id="<%=cust%>">
                        <label class="online"></label>
                        <a href="javascript:;"><img src="<%=custImg%>"></a>
                        <a href="javascript:;" class="chat03_name" > <%=cust%></a>
                    </li>
                </ul>
            </div>
        </div>
    </div>
    
    <div style="clear: both;"></div>
</div>       
</div>

<div class="divfoot">
	<span class="pt"> 在线客服 | Copyright © 2016-2020 GDKM All Right Reserved  版权所有《商城智能客服系统服务条款》 </span>
</div>

<!-- 右键菜单 -->
<div class="contextMenu" id="sysMenu">
  <ul>
     <li id="Li1"><img src="img/new.png" /> 查看信息</li>
     <li id="Li2"><img src="img/folder.png" /> 发送邮件</li>
     <li id="Li3"><img src="img/disk.png" /> 保存聊天</li>
     <hr />
     <li id="Li4"><img src="img/cross.png" /> 删除记录</li>
   </ul>
</div>  
</body>
</html>
<script>
var userName="<%=userName%>";       //发送人账号
var userImg = "<%=userImg%>";       //发送人头像
var toUserName="<%=toUserName%>";   //接收人账号
var toUserImg = "<%=toUserImg%>";   //接收人头像

//根据聊天内容格式化聊天记录
function formatChat(user,userName,userImg,toUserName,toUserImg,cltext,cltime){
    var chatStr="";
    if(user==userName){
         //格式化发送人的每条聊天纪录
   	     chatStr = "<div class='message clearfix'>" 
   	     + "<div class='user-logo'><img src='" + userImg + "'/>" + "</div>" 
         + "<div class='wrap-text'>" + "<div>" + cltext + "</div>"  + "</div>" 
         + "<div class='wrap-ri'>" + "<div clsss='clearfix'><span>" + cltime + "</span></div>" + "</div>" 
         + "<div style='clear:both;'></div>" 
         + "</div>" ;
    }
    if(user==toUserName){
         //格式化接收人的每条聊天纪录                
   	     chatStr = "<div class='message clearfix' style='background-color:#EBFBE3' >" 
   	     + "<div class='user-logo'><img src='" + toUserImg + "'/>" + "</div>" 
         + "<div class='wrap-text'>" + "<div>" + cltext + "</div>"  + "</div>" 
         + "<div class='wrap-ri'>" + "<div clsss='clearfix'><span>" + cltime + "</span></div>" + "</div>" 
         + "<div style='clear:both;'></div>" 
         + "</div>" ;				                        	
     } 
     return chatStr;
}

//实现聊天表情面板上的操作
function showFacePanel(){
	//加载表情
	var faceHtml="";
	for(var i=1;i<=60;i++){
		faceHtml+="<li><a href='javascript:;'><img src='img/emo_"+i+".gif' id='emo_"+i+"'></a></li> ";	
	}
	
	$(".wl_faces_main ul").html(faceHtml);
	
	//移动到表情面板开关按钮的显示和关闭
	$(".ctb01").hover(function(){
		$(".wl_faces_box").show();
	},function(){
		$(".wl_faces_box").hide();
	});
	
	//移动到表情面板 显示和关闭
	$(".wl_faces_box").hover(function(){
		$(".wl_faces_box").show();
	},function(){
		$(".wl_faces_box").hide();
	});
	
	//关闭按钮
	$(".wl_faces_close").click(function(){
		$(".wl_faces_box").hide();
	});
}

//请求获得顾客和客服之间的所有聊天记录
function getUserChat(){
	$.ajax({
		type:"post",
		url:"ChatUserServlet?action=getUserChat&t="+new Date().getTime(),
		data:"user="+userName+"&toUser="+toUserName,
		success:function(responseText){
			var chatlog=eval("("+responseText+")");
			var chatContent=""; //所有聊天记录
			for(var i =0;i<chatlog.length;i++){
				var user=chatlog[i].user;
				var cltext=chatlog[i].cltext;
				var cltime=chatlog[i].cltime;
				var userChat=""; //格式化每一条聊天记录
				function replaceFace(){
					if (cltext.indexOf(":emo_")!=-1) {
						cltext=cltext.replace("<:","<img src='img/").replace(":>",".gif'/>");
						replaceFace(); //递归调用
					}
				}
				replaceFace();
				userChat=formatChat(user,userName,userImg,toUserName,toUserImg,cltext,cltime);
				chatContent+=userChat;
			}
			$(".mes1").html(chatContent); //显示聊天记录
			$(".chat01_content").scrollTop($(".mes1")[0].scrollHeight); //设置滚动条在最底部
		}
	});
	setTimeout(getUserChat,1000);
}

//发送聊天内容
function sendChat(){
	//点击表情放入聊天框
	$(".wl_faces_main img").click(function(){
		$("#textarea").append("<img src='img/"+$(this).attr("id")+".gif'/>");
		$(".wl_faces_box").hide();
	});
	
	$(".chat02_bar img").click(function(){
		var chat=$("#textarea").html(); //获取文本框的内容
		//替换图片的那啥
		function replaceFace1(){
			if (chat.indexOf(":emo_")!=-1) {
				chat=chat.replace("<img src=\"img/","<:").replace(".gif\">",":>");
				replaceFace1(); //递归调用
			}
		}
		replaceFace1();
		//发送聊天内容本体
		if (chat!="") {
			$.ajax({
				type:"post",
				url:"ChatUserServlet?action=sendChatContent&t="+new Date().getTime(),
				data:"user="+userName+"&toUser="+toUserName+"&chatcontent="+chat,
				success:function(responseText){
					if (responseText=="ChatTrue") {
						$("#textarea").html("");
						getUserChat();
					}else{
						alert("消息发送失败!");
					}
				}
			});	
		} else {
			alert("聊天内容不能为空!");
		}
	});
}

//引入jquery.contextmenu.js，实现右键菜单
function rightMenu(){
	//contextMenu()调用右键菜单 第一个参数是右键菜单的id 第二个是菜单的配置项
	$("#chat03_content ul li").contextMenu('sysMenu',
		{	bindings: {
			//右键菜单每个选项的事件处理
			'Li1': function(Item){
				window.open("viewUser.jsp?touser="+Item.id,"_blank");
			},
			'Li2': function(Item){
				alert("用户为："+Item.id);
			},
			'Li3': function(Item){
				alert("用户为："+Item.id);
			},
			'Li4': function(Item){
				alert("用户为："+Item.id);
			}
		},
		menuStyle: { //右键菜单外框样式，可更改css
			border: '2px solid #999'
		},
		itemStyle: { //右键菜单选项样式，可更改css
			fontFamily: 'verdana',
			backgroundColor: '#666',
			color: 'white',
			border: 'none',
			padding: '1px'
		},
		itemHoverStyle:{ //设置右键菜单鼠标悬浮样式，可更改css
			color: '#666',
			backgroundColor: '#f7f7f7',
			border: 'none'
		}
	});
}

$(document).ready(function(){
	showFacePanel();
	getUserChat();
	sendChat();
	rightMenu();
});
</script>