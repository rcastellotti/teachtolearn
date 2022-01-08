<script context="module">
	import { apiGetCourse } from '$src/api';

	export async function load({ session, page }) {
		return apiGetCourse(page.params.abbreviation.toUpperCase()).then((response) => {
			let course = response.msg.course;
			if (session?.profile?.username !== course.teacher.username)
				return {
					status: 302,
					redirect: `/courses/${course.abbreviation}`
				};

			return {
				props: {
					course: course
				}
			};
		});
	}
</script>

<script>
	import CourseEditor from '$components/CourseEditor.svelte';
	import LectureEditor from '$components/LectureEditor.svelte';

	export let course;
</script>

<svelte:head>
	<title>
		TTL - edit {course.abbreviation}
	</title>
</svelte:head>

<div class="bg-gray-100 px-5 rounded mx-auto mt-10 p-5">
	<h2 class="text-2xl pb-3 font-bold">Edit course</h2>
	<div class="mb-3">
		<CourseEditor bind:course edit={true} />
	</div>
	<LectureEditor {course} />
</div>
