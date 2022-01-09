<script context="module">
	import { apiGetUserCourses, apiGetPublicProfile } from '$src/api';
	import { variables } from '$src/variables';
	import { debug } from '$src/stores';

	export async function load({ page }) {
		let user = apiGetPublicProfile(page.params.slug);
		user = await user;
		if(!user.msg.profile?.username)
			return {
				status: 404,
			}

		let courses = apiGetUserCourses(page.params.slug, 1);
		return {
			props: {
				user: await user,
				courses: await courses
			}
		};
	}
</script>

<script>
	export let user, courses;
	user = user.msg.profile;
	courses = courses.msg.courses;
	const propicUrl = `${variables.s3Url}${user.username}`;

	$debug = `${JSON.stringify(user, null, 2)}\n${JSON.stringify(courses, null, 2)}`;
</script>

<svelte:head>
	<title>
		TTL - {user.username}'s profile
	</title>
</svelte:head>

<div class="h-full flex flex-col justify-center">
	<div class=" py-3 px-3 flex flex-col justify-between gap-y-2 rounded bg-gray-100">
		<div class="flex flex-col space-y-1">
			<div class="flex justify-between">
				<div>
					<div class="text-2xl font-bold">@{user.username}</div>
					<div class=" text-gray-500">{user.fullname}</div>
					<div><a class="hover:underline" href="mailto:{user.email}">{user.email}</a></div>
				</div>
				<img class="rounded-lg w-16 h-16 border border-gray-600" src={propicUrl} alt="propic" />
			</div>
			<div class="text-gray-500">{user.bio}</div>
		</div>
		{#if courses.length}
			<h2 class="font-semibold">Courses created by the user</h2>
			<ul class="pt-2 divide-y divide-gray-800">
				{#each courses as course}
					<li
						class="flex justify-start gap-2 items-center border-b border-gray-500 border-dashed p-1"
					>
						<div class="flex-shrink-0 h-6 w-6">
							<div class="flex h-6 w-6 bg-{course.color}-500  mr-4 rounded-md">
								<i class="mx-auto my-auto bi {course.icon}" />
							</div>
						</div>
						<a
							href="/courses/{course.abbreviation}"
							class="hover:underline whitespace-nowrap overflow-auto w-2/4"
							>{course.abbreviation} - {course.name}</a
						>
					</li>
				{/each}
			</ul>
		{/if}
	</div>
</div>
