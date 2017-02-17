(function($) {
	$(function() {

		function formatSumm(sum) {
			return String(sum).replace(/(\d)(?=(\d\d\d)+([^\d]|$))/g, '$1 ');
		}

	$(document).ready(function() {
		$.getJSON( "/udata://emarket/cart.json", function(data){
		if (data.summary.amount > 0) {
			$('.summary>span').text(formatSumm(data.summary.price.actual.toFixed(2)));
			$('#toBasket').text(data.summary.amount);
		}
		});
	
		var rows = $('table[data-role=objects] tbody>tr');
			
			rows.each(function (i, el) {
			var a = localStorage.getItem($(el).data('id'));
			if (a) {
				console.log(el);
				$(el).find(".jq-number__field>input[type='number']").val(a);
			}
		});
	});

	function viewCartData(e, toId, toOrder, toParent, addCountNow) {
			$.ajax({
					url: '/emarket/basket/put/element/' +toId+ '?amount='+ addCountNow,
					success: function (data) {
						localStorage.setItem(toId, addCountNow);
						var inOrder = addCountNow + e.target.dataset.unit;
						var ordMessage = document.createElement("span");
						ordMessage.className = 'inorder';
						ordMessage.id = 'to'+toId;
						ordMessage.innerHTML = inOrder;
						$( toParent ).append( ordMessage );
						$(ordMessage).fadeOut(3500);
						$.getJSON( "/udata://emarket/cart.json", function( data ) {
							$('#toBasket').text(data.summary.amount);
							$('.summary>span').text(formatSumm(data.summary.price.actual.toFixed(2)));
							$('.itemstotal>a>span').text(formatSumm(data.summary.price.actual.toFixed(2)));
							$('.itemstotal>a').show();
						});
						setTimeout(function(){
							$(ordMessage).remove();
						}, 3000);
					},
					complete: function (data) {
				    $(e.target).liTip({posY: 'left', content: 'в заказе:'+ e.target.value + e.target.dataset.unit});
					},
					error: function (data) {
						console.log('Error');
					}
			});
	}
		
	$('table[data-role=objects]').on('change blur', 'input', function (e) {
		var toId 				= $(this).parents('tr').data('id');
		var toOrder 		= $(this).parents('tr').data('orderId');
		var toParent 		= $(this).parents('td');
		var addCountNow = e.currentTarget.value;
		if(toOrder) {
			var currentSumm = $(toParent).siblings('.item-order');
			$(currentSumm[0].firstChild).text(formatSumm((e.target.value * e.target.dataset.price).toFixed(2)));
		}
		if (addCountNow > 0) {
				viewCartData (e, toId, toOrder, toParent, addCountNow);
		}
	});

	$('input').on('keypress', function(e) {
			if(e.keyCode==13) {
				$(e.target).parents('tr').nextAll().find('input').first().focus(); // переход на след. поле
				e.preventDefault();
			}
		});
	
	$('#clearCart').click(function() {
		$.ajax({
			url: '/emarket/basket/remove_all/',
			success: function (data) {
				localStorage.clear();
				console.log('clear');				
			},
			complete: function (data) {
				location.reload();
			}
		});

	});

	});
})(jQuery);
