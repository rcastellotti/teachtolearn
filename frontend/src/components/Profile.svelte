<script>
	export let user;
	import { variables } from '$src/variables';
	const propicUrl = `${variables.s3Url}${user.username}`;
</script>

<div
	class="box-border transition duration-500 ease-in-out transform  hover:shadow-lg 
	border border-gray-400 group hover:border-black flex flex-col justify-between divide-y divide-gray-800 gap-y-2 rounded bg-gray-100"
>
	<div class="flex">
		<img class="rounded-l  h-auto" src={propicUrl} alt="propic" />
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
