<script>
	import { goto } from '$app/navigation';
	import { clickOutside } from '$src/utils';
	import { apiSearchRealtime } from '$src/api.js';
	import { debug } from '$src/stores';
	$: courses = [];
	$: users = [];
	let searchTerm = '';
	let showSearchResults = false;
	let isSearchOnFocus = false;

	async function search(searchTerm) {
		if (!searchTerm.trim()) {
			courses = users = [];
			return;
		}
		apiSearchRealtime(searchTerm.trim())
			.then((response) => response.json())
			.then((response) => {
				showSearchResults = true;
				courses = response.msg.courses;
				$debug = JSON.stringify(courses, null, 2);
				users = response.msg.users;
				$debug += JSON.stringify(users, null, 2);
			});
	}

	function handleKeydown(event) {
		const keyCode = event.keyCode;
		if (keyCode == 13 && isSearchOnFocus && searchTerm.trim() !== '') {
			goto(`/search?q=${searchTerm}`);
			showSearchResults = false;
			isSearchOnFocus = false;
		}
	}
</script>

<svelte:window on:keydown={handleKeydown} />

<div class=" z-10 flex flex-col relative">
	<div class="flex">
		<input
			type="text"
			id="location"
			class="border rounded-l w-full p-1 overflow-auto focus:outline-none border-black border-r-0"
			on:focus={() => {
				isSearchOnFocus = true;
			}}
			bind:value={searchTerm}
			on:input={() => {
				search(searchTerm);
			}}
			placeholder="start typing..."
		/>
		<button
			disabled={searchTerm.trim() == ''}
			on:click={() => {
				courses = users = [];
				goto(`/search?q=${searchTerm}`);
			}}
			tabindex="-1"
			type="submit"
			class="rounded-r bg-blue-500 hover:bg-blue-600 disabled:bg-blue-400 "
			aria-label="Search"
		>
			<i class="text-white bi bi-search p-5" />
		</button>
	</div>

	{#if showSearchResults}
		<div
			use:clickOutside
			on:click_outside={() => {
				showSearchResults = false;
			}}
		>
			<ul class="text-xs md:text-sm absolute right-0 left-0 bg-gray-100">
				{#if courses.length}
					<span class="pl-1 font-bold"> courses</span>

					{#each courses as course}
						<li
							on:click={() => {
								searchTerm = course.name;
								courses = users = [];
							}}
							tabindex="0"
							class="hover:bg-gray-200  focus:bg-gray-200 focus:outline-none p-1 border-b border-gray-500 border-dashed "
						>
							<div class="flex justify-between whitespace-nowrap overflow-x-hidden">
								<a tabindex="-1" class="hover:underline " href="/courses/{course.abbreviation}">
									{course.name}</a
								>
							</div>
						</li>
					{/each}
				{/if}
				{#if users.length}
					<span class="pl-1 font-bold">users</span>
					{#each users as user}
						<li
							on:click={() => {
								searchTerm = user.fullname;
								courses = users = [];
							}}
							tabindex="0"
							class="hover:bg-gray-200  focus:bg-gray-200 focus:outline-none p-1 border-b border-gray-500 border-dashed"
						>
							<div class=" flex justify-between">
								<span class="whitespace-nowrap overflow-x-hidden">
									<a class="hover:underline " href="/user/{user.username}"> {user.fullname}</a>
								</span>
							</div>
						</li>
					{/each}
				{/if}
			</ul>
		</div>
	{/if}
</div>
