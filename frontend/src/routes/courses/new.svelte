<script>
	import CourseEditor from '$components/CourseEditor.svelte';
	import LectureEditor from '$components/LectureEditor.svelte';

	let course = null;
</script>

<svelte:head>
	<title>TTL - Create new course</title>
</svelte:head>

<div class="h-full flex flex-col justify-center md:w-8/12 mx-auto">
	<div class="bg-gray-100 p-5 rounded">
		<h1 class="text-2xl font-bold">add course</h1>
		<CourseEditor bind:course edit={false} />
		<LectureEditor {course} />
	</div>
</div>
