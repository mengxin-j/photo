$(docuemnt).ready(function(){
	$('#discount li').click(function(){
		$(this).addClass("discount_youhui").siblings().removeClass("discount_youhui");
	});
});
