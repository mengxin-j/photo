			GCONFIG={
				filename:"msn.swf",
				flashname:"msn",
				url:"nb.faqee.com",
				domain:"nb.faqee.com",
				username:"",
				password:"",
				imhandler:"imhandler",
				dotyping:false,
				roomid:'',
				youcity:'',
				cguest:'',
				scity:'',
				map:null,
				pointA:'',
				pointB:''
		   };

		var timeout         = 500;
		var closetimer		= 0;
		var ddmenuitem      = 0;

		function jsddm_open()
		{	jsddm_canceltimer();
			jsddm_close();
			ddmenuitem = $(this).find('ul').eq(0).css('visibility', 'visible');}

		function jsddm_close()
		{	if(ddmenuitem) ddmenuitem.css('visibility', 'hidden');}

		function jsddm_timer()
		{	closetimer = window.setTimeout(jsddm_close, timeout);}

		function jsddm_canceltimer()
		{	if(closetimer)
			{	window.clearTimeout(closetimer);
				closetimer = null;}}

		document.onclick = jsddm_close;

	function setCaret(textObj){  
	  if(textObj.createTextRange){    
	   textObj.caretPos=document.selection.createRange().duplicate();    
	  }  
	}
	function insertAtCaret(textObj,textFeildValue){  
	  if(document.all&&textObj.createTextRange&&textObj.caretPos){       
		  var caretPos=textObj.caretPos;      
		  caretPos.text=caretPos.text.charAt(caretPos.text.length-1)==''?textFeildValue+'':textFeildValue; 
	  }else if(textObj.setSelectionRange){        
		  var rangeStart=textObj.selectionStart;
		  var rangeEnd=textObj.selectionEnd;     
		  var tempStr1=textObj.value.substring(0,rangeStart);      
		  var tempStr2=textObj.value.substring(rangeEnd);      
		  textObj.value=tempStr1+textFeildValue+tempStr2;
		  textObj.focus();
		  var len=textFeildValue.length;
		  textObj.setSelectionRange(rangeStart+len,rangeStart+len);
		  textObj.blur();
	  }else {
		textObj.value+=textFeildValue;
	  } 
	} 
	function sysMessage(str,showTime){
		if(typeof(showTime)=='undefined'){
			showTime = true;
		}
		if(showTime){
			str = "["+luguoUI.showDate()+"]："+str;
		}
		var str = luguoUI.HTMLMODEL.sysinfor.replace(/#mess#/g,str);
		$(".logbox").append(str);
	}
	function firstMessage(str){
		var str = luguoUI.HTMLMODEL.guestinfor.replace(/#mess#/g,str).replace(/#dm#/g,"");
		$(".logbox").append(str);
	}
	function getQueryString(src,name){   
		var reg = new RegExp("(^|\\?|&)"+ name +"=([^&]*)(\\s|&|$)", "i");
		if (reg.test(src)) return RegExp.$2; return ""; 
	}

	function changeText(){
	var ss = $(".chatmsg").val();
	if((GCONFIG.dotyping==false) && (ss!="")){
		GCONFIG.dotyping=true;
		webim.sendGroupMessage(GCONFIG.roomid,"typing`"+webim.status.myname+"");
	}
	if(ss==""){
		GCONFIG.dotyping=false;
		webim.sendGroupMessage(GCONFIG.roomid,"notyping`"+webim.status.myname+"");
	}
    if(typeof(TITLETIMER)!='undefined'){
		window.clearInterval(TITLETIMER);
		document.title="随机视频聊天 — faqee.com";
	}
	webim.status.autoreply = "";
}

  window.onfocus=function(){
    if(typeof(TITLETIMER)!='undefined'){
		window.clearInterval(TITLETIMER);
		document.title="随机视频聊天 — faqee.com";
	}
  }
  window.onunload=function(){
	  //webim.unbindMSN("msn");
	  //webim.unbindMSN("yahoo");
	  //webim.unbindMSN("gtalk");
	  //webim.unbindMSN("icq");
  }
  function sendFileCallback(path,fileName,arg){
	var str = "";
	if(fileName.indexOf(".jpg")>0 || fileName.indexOf(".png")>0 || fileName.indexOf(".gif")>0 || fileName.indexOf(".bmp")){
		str = ("[img]http://l.faqee.com/upload/"+path+"[/img]");
	}else{
		str = ("文件下载地址：[url]http://l.faqee.com/upload/"+path+"[/url]");
	}
	insert2Text(str);
  }

  $(function(){
		var version = swfobject.ua.pv[0];
		try{
			if (version && parseInt(version) < 9) {
				luguoUI.openWnd({title:'系统消息',content:"你的浏览器Flash Player版本太低，请<a href='http://get.adobe.com/flashplayer/'>点击这里升级</a>！"});
				return;
			}		    
		}catch(e){
			luguoUI.openWnd({title:'系统消息',content:"你的浏览器还未安装Flash Player，<a href='http://get.adobe.com/flashplayer/'>点击这里</a>下载才能正常使用本系统！"});
			return;
		}
		luguoUI.openWelcome();
		GCONFIG.roomid = luguoUI.randID();

		webim.toFlash(GCONFIG);

		$(".chatmsg").unbind("keydown").bind("keydown",function(event){
			switch(event.keyCode) {
				case 13:
				{
					$("#send").click();
					return false;
				}
			}
		});	

		$("#send").bind("click",function(){
			if(webim.status.logined){
				var mess = $(".chatmsg").val();
				if($.trim(mess)==""){
					alert("有输东东么,你想干嘛？");
					return;
				}
				luguoUI.sendMessage(GCONFIG.roomid,mess);
				$(".chatmsg").val("");
				GCONFIG.dotyping=false;
				webim.sendGroupMessage(GCONFIG.roomid,"notyping`"+webim.status.myname+"");
			}else{
				sysMessage("您还未连上聊天服务器，无法聊天！");
			}
		});			

		$("#nextBtn").bind("click",function(){
			if(webim.status.logined)
				luguoUI.startChat(true);
			else{
				webim.status.isDelayChat = true;
				luguoUI.showChatWnd();
				sysMessage("正在帮您连接到聊天服务器，请稍候.......");
			}
		});

		 $("#stopBtn").bind("click",function(){	
			if(confirm("是否确定中断当前对话？"))
				luguoUI.leaveRoomMessage();
		 });

		 if($.browser.msie){
			 $(".chatmsg")
			   .click(function(){
				 setCaret($(this).get(0));
			   })
			   .select(function(){
				 setCaret($(this).get(0));
			   })
			   .keyup(function(){
				 setCaret($(this).get(0));
			   });
		}

		$(".chatmsg").bind("keyup",function(){changeText();});

		$('#jsddm > li').bind('mouseover', jsddm_open);
		$('#jsddm > li').bind('mouseout',  jsddm_timer);
		$('#openfaceli > span').bind('click',function(){
			insertAtCaret($(".chatmsg").get(0),"`"+$(this).attr("id")+"`");
			$(".chatmsg").focus();
		});
	 
  });