<script context="module">
	export async function load({ session }) {
		if (!session?.profile?.username) {
			return {
				status: 302,
				redirect: '/signin?next=/myreservations'
			}
		}
		return {status: 200};
	}
</script>

<script>
	import { onMount } from 'svelte';
	import { activeTabCourses, debug } from '$src/stores.js';
	import { apiGetUserReservations } from '$src/api.js';
	import InfiniteScroll from '$components/InfiniteScroll.svelte';
	import InternalNav from '$components/InternalNav.svelte';
	import Course from '$components/Course.svelte';
	import CourseTable from '$components/CourseTable.svelte';

	let courses = [];
	let pages;
	let page = 1;
	let newBatch = [];

	async function fetchData() {
		let response = await apiGetUserReservations(page);
		newBatch = response.msg.courses;
		pages = response.msg.pages;
	}

	onMount(() => {
		fetchData();
	});

	$: courses = [...courses, ...newBatch];

	$: {
		$debug = JSON.stringify(courses, null, 2);
	}

	let tabs = [
		{ display: 'list', tabName: 'list', icon: 'bi-view-list' },
		{ display: 'table', tabName: 'table', icon: 'bi-table' }
	];
</script>

<svelte:head>
	<title>TTL - my reservations</title>
</svelte:head>

<div class="max-h-full w-full h-full space-y-2 overflow-scroll">
	{#if !courses?.length}
		<div class="flex flex-col items-center justify-center gap-6 h-full">
			<p class="text-xl font-medium">You still haven't enrolled in any course</p>
			<button
				class="font-medium text-white button py-2 px-3 border border-gray-400 rounded bg-blue-500 button-border whitespace-nowrap"
			>
				<a href="/courses"> Enroll in your first course now! </a>
			</button>
		</div>
	{:else}
		<div class="text-center mt-2 mr-1">
			<InternalNav {tabs} store={activeTabCourses} />
		</div>
		{#if $activeTabCourses == 'list'}
			{#if courses?.length}
				{#each courses as course}
					<Course {course} button="more" url={`/courses/${course.abbreviation}`} />
				{/each}
			{/if}
			<InfiniteScroll
				hasMore={newBatch.length}
				threshold={100}
				on:loadMore={() => {
					if (++page <= pages) fetchData();
				}}
			/>
		{:else}
			<CourseTable
				{courses}
				fetchMore={fetchData}
				totalPages={pages}
				bind:totalPagesLoaded={page}
			/>
		{/if}
	{/if}
</div>
