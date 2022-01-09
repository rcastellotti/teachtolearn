<script>
	export let fullname;

	export let size = 16;
	export let md_size = 24;

	function stringToColour(str) {
		var hash = 0;
		for (var i = 0; i < str.length; i++) {
			hash = str.charCodeAt(i) + ((hash << 5) - hash);
		}
		var colour = '';
		for (var i = 0; i < 3; i++) {
			var value = (hash >> (i * 8)) & 0xFF;
			colour += ('00' + value.toString(16)).substr(-2);
		}
		return colour.toUpperCase();
	}


	let propicUrl =  (() => {
		if(fullname==="[deleted user]")
			return "https://eu.ui-avatars.com/api/?name=X&background=121212&color=F3F3F3";

		return `https://eu.ui-avatars.com/api/?name=${fullname}&background=${stringToColour(fullname)}`
	})()

</script>

<img
	class="transition group-hover:opacity-50 rounded-full h-{size} w-{size} md:w-{md_size} md:h-{md_size}"
	alt="propic"
	src={propicUrl}
/>