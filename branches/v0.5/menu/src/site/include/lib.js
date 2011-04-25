
function grabFocus() {
	// ask content to take focus so key events will be sent to it
	// assumes html document has embed or object labeled 'content'
	window.document.content.focus();
}
