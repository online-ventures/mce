setTimeout(function(){
	var scripts = document.getElementsByTagName('script');
	for (var i=0; i < scripts.length; i++) {
		var script = scripts[i];
		if(script.innerHTML.match(/NREUMQ/) || script.src.match(/new-relic-cleaner/)){
			script.outerHTML = '';
		}
		scripts[i] = script;
	}
}, 50);