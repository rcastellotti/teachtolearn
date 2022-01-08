<script>
	import { onMount } from 'svelte';
	import { activeTabCourses, debug } from '$src/stores.js';
	import { apiGetCourses } from '$src/api.js';
	import InternalNav from '$components/InternalNav.svelte';
	import InfiniteScroll from '$components/InfiniteScroll.svelte';
	import Course from '$components/Course.svelte';
	import CourseTable from '$components/CourseTable.svelte';

	let courses = [];
	let pages;
	let page = 1;
	let newBatch = [];

	async function fetchData() {
		apiGetCourses(page).then((response) => {
			newBatch = response.msg.courses;
			pages = response.msg.pages;
		});
	}

	onMount(() => {
		fetchData();
		$debug = JSON.stringify(courses, null, 2);
	});

	$: courses = [...courses, ...newBatch];

	let tabs = [
		{ display: 'list', tabName: 'list', icon: 'bi-view-list' },
		{ display: 'table', tabName: 'table', icon: 'bi-table' }
	];
</script>

<svelte:head>
	<title>TTL - Courses</title>
</svelte:head>

{#if courses?.length}
	<div class="max-h-full  h-full overflow-scroll">
		<div class="text-center my-2">
			<InternalNav {tabs} store={activeTabCourses} />
		</div>
		{#if $activeTabCourses == 'list'}
			<div class="lg:w-7/12 space-y-2  mx-auto">
				{#each courses as course}
					<Course {course} button="more" url={`/courses/${course.abbreviation}`} />
				{/each}
			</div>
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
	</div>
{/if}
