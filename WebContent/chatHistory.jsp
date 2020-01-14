<%@ page language="java" import="java.util.*,java.sql.*,chatsys.db.*"  contentType="text/html;charset=utf-8"%>
<html>
<head>
<title>历史聊天记录</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link rel="stylesheet" type="text/css" href="css/chat.css" />
    <script src="Scripts/jquery.js" type="text/javascript"></script>
    <script src="Scripts/jquery.pagination.js" type="text/javascript"></script> 
    <link href="Scripts/jquery.pagination.css" rel="stylesheet" type="text/css" />
</head>
<script type="text/javascript">	 
var userName="<%=request.getParameter("user")%>";
var toUserName="<%=request.getParameter("touser")%>";
var sumNum=0; // 总行数

//载入分页记录
function getUserChatHistory(){
	$.ajax({
		type: "post",
		url: "ChatUserServlet?action=getUserChatHistory&t="+new Date().getTime(),
		data:"user="+userName+"&toUser="+toUserName,
		success:function(responseText){
			var chatlog=eval("("+responseText+")");
			var chatHistory=""; //需要加载的所有聊天历史记录
			for (var i = 0; i < chatlog.length; i++) {
				var user = chatlog[i].user;
				var cltext = chatlog[i].cltext;
				var cltime = chatlog[i].cltime;
				var chatRow="";//每行聊天记录
				
				//显示聊天记录的时候要替换表情代替符
				function replaceFace(){
					if (cltext.indexOf(":emo_")!=-1) {
						cltext=cltext.replace("<:","<img src='img/").replace(":>",".gif'/>");
						replaceFace(); //递归调用
					}
				}
				replaceFace();
				//格式化每一行聊天记录的样式
				chatRow="<div class='message clearfix'>"
				+"<div class='wrap-text' background>"
				+"<div style='color:blue;font-weight:bold;'>【用户】&nbsp;"+user+"</div>"
				+"<div style='padding-left:10px'>"+ cltext + "</div>"
				+"</div>"
				+"<div class='wrap-ri'>"+"<div class='clearfix'><span>"+ cltime +"</span></div>"+"</div>"
				+"<div style='clear:both;'></div>"
				+"</div>";
				chatHistory+= chatRow;
			}
			$("#hiddenresult").html(chatHistory);
			initPagination(); //分页载入
		}
	});
}

//引入 jquery.pagination.js 插件  通过ajax实现分页
function initPagination(){
	sumNum = $(".message.clearfix").length; //所有行数
	$("#Pagination").pagination(sumNum,{
		num_edge_entries: 1, //两侧显示的首尾分页数
		num_display_entries: 3, //连续分页主体部分显示的分页数
		callback: psCallback, //调用加载每页聊天内容的方法
		items_per_page: 3, //每页显示的行数
		prev_text: "前一页",
		next_text: "后一页"
	});
};

//加载每页的聊天内容，page_index是页码 pageObj代表分页工具栏对象,pageObj代表分页工具栏对象
function psCallback(page_index, pageObj){
	var items_per_page = 3;//每页显示的函数
	var max_elem = Math.min((page_index+1) * items_per_page, sumNum);
	//清空上一页内容
	$("#Searchresult").html("");
	for (var i=page_index*items_per_page;i<max_elem;i++) {
		$("#Searchresult").append($(".message.clearfix:eq("+i+")").clone());
	}
}

$(document).ready(function(){
	getUserChatHistory();
});

</script>
<body> 
           
<div class="regBox" style="width:650px;height:400px;margin-top:30px;">
    <div class="chat03">
	    <div class="chat03_title">
	        <label class="chat03_title_t">历史聊天记录</label>
	    </div>
	    <!-- 这里是加载的所有记录 -->
        <div id="hiddenresult" style="display:none;">
        </div>
	    <!-- 这里是分页区 -->
	    <div id="Searchresult">正在加载数据...</div>
        <!-- 这里显示分页工具栏 -->
	    <div id="Pagination" class="pagination"></div>	    
	</div>
</div>
</body>
</html>
