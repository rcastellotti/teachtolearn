<script>
	export let user;


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
		if(user.fullname==="[deleted user]")
			return "https://eu.ui-avatars.com/api/?name=X&background=121212&color=F3F3F3";

		return `https://eu.ui-avatars.com/api/?name=${user.fullname}&background=${stringToColour(user.fullname)}`
	})()

</script>



<div
	class="box-border transition duration-500 ease-in-out transform  hover:shadow-lg 
	border border-gray-400 group hover:border-black flex flex-col justify-between divide-y divide-gray-800 gap-y-2 rounded bg-gray-100"
>
	<div class="flex">
		<img
			class="rounded-l h-auto"
			alt="propic"
			src={propicUrl}
		/>
		<div class="px-2">
			<a class="hover:underline text-base font-bold" href="/user/{user.username}"
				>@{user.username}</a
			>
			<div class=" text-gray-500">{user.fullname}</div>
			<div>
				<i class="bi bi-envelope" />
				<a class="hover:underline" href="mailto:{user.email}">{user.email}</a>
			</div>
		</div>
	</div>
</div>
