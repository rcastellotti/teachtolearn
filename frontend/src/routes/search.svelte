<script context="module">
	import { apiSearch } from '$src/api';
	import { debug, activeTabSearch } from '$src/stores';
	import Course from '$components/Course.svelte';
	import Profile from '$components/Profile.svelte';
	import InternalNav from '$components/InternalNav.svelte';

	export async function load({ page }) {
		let searchResults = await apiSearch(page.query.get(['q']));
		return {
			props: {
				searchResults: await searchResults
			}
		};
	}
</script>

<script>
	export let searchResults;
	$debug = JSON.stringify(searchResults, null, 2);

	$: tabs = (() => {
		let tabs = [];
		if (searchResults.msg?.courses?.length)
			tabs.push({ display: 'courses', tabName: 'courses', icon: 'bi-easel-fill' });
		if (searchResults.msg?.users?.length)
			tabs.push({ display: 'users', tabName: 'users', icon: 'bi-people-fill' });
		return tabs;
	})();

	$: courses = searchResults.msg.courses;
	$: users = searchResults.msg.users;
</script>

<svelte:head>
	<title>TTL - Search</title>
</svelte:head>

<div class="hidden md:flex justify-between items-start mt-3">
	<div class="w-2/3 space-y-2 overflow-scroll">
		{#if courses?.length}
			<h2 class="text-2xl font-bold">courses</h2>
			{#each courses as course}
				<Course {course} button="more" url={`/courses/${course.abbreviation}`} />
			{/each}
		{:else}
			<div class="text-gray-700 text-[1.15rem]">no matching courses found</div>
		{/if}
	</div>
	<div class="space-y-1 flex flex-col justify-center overflow-scroll">
		{#if users?.length}
			<h2 class="text-2xl font-bold">users</h2>
			{#each users as user}
				<Profile {user} />
			{/each}
		{:else}
			<div class="text-gray-700 text-[1.15rem]">no matching users found</div>
		{/if}
	</div>
</div>

<div class="md:hidden">
	<div class="text-center my-3">
		<InternalNav {tabs} store={activeTabSearch} />
	</div>
	{#if $activeTabSearch == 'courses'}
		<div class="flex-col space-y-2 flex justify-center overflow-scroll">
			{#if courses?.length}
				{#each courses as course}
					<Course {course} button="more" url={`/courses/${course.abbreviation}`} />
				{/each}
			{:else}
				<div class="text-gray-700 text-[1.15rem]">no matching courses found</div>
			{/if}
		</div>
	{:else}
		<div class="space-y-2 flex flex-col justify-center overflow-scroll">
			{#if users?.length}
				{#each users as user}
					<Profile {user} />
				{/each}
			{:else}
				<div class="text-gray-700 text-[1.15rem]">no matching users found</div>
			{/if}
		</div>
	{/if}
</div>
