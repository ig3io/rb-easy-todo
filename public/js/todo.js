function toggle(e, tr) {
	e.stopPropagation();
	var span = tr.find('span');
	var list_id = tr.data('list-id');
	var item_id = tr.data('item-id');
		if (tr.hasClass('done')) {
		    jQuery.post('/unmark/' + list_id + '/' + item_id, document.cookie);
		    tr.removeClass('done');
		    span.removeClass('glyphicon-ok')
		    span.addClass('glyphicon-remove')
		}
		else {
		    jQuery.post('/mark/' + list_id + '/' + item_id, document.cookie);
		    tr.addClass('done');
		    span.removeClass('glyphicon-remove')
		    span.addClass('glyphicon-ok')
		}
}

function a_handler(e) {
	e.stopPropagation();
}

function check_delete() {
	return confirm("Are you sure you want to delete the list?");
}
