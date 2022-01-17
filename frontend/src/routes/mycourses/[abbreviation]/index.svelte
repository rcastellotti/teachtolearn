<script context="module">
	import { activeTabCourse, debug, successMessage, errorMessage, showModal } from '$src/stores';
	import { apiDeleteReservation, apiGetReservations, apiGetCourse, apiGetReviews } from '$src/api';

	export async function load({ page, session }) {
		const abbreviation = page.params.abbreviation.toUpperCase();
		let course = apiGetCourse(abbreviation);
		course = await course;
		const teacher = course.msg.course.teacher.username;
		if (teacher !== session?.profile?.username) {
			return {
				status: 302,
				redirect: `/courses/${abbreviation}`
			};
		}
		let reviews = apiGetReviews(abbreviation);
		let reservations = apiGetReservations(abbreviation);
		return {
			props: {
				course: course,
				reservations: await reservations,
				reviews: await reviews
			}
		};
	}
</script>

<script>
	import InternalNav from '$components/InternalNav.svelte';
	import Modal from '$components/Modal.svelte';
	import CourseShowcase from '$components/CourseShowcase.svelte';
	import ReviewList from '$components/ReviewList.svelte';
	import LectureTable from '$components/LectureTable.svelte';

	export let course, reservations, reviews;
	course = course.msg.course;
	reservations = reservations.msg.reservations;
	reviews = reviews.msg.reviews;

	$debug =
		JSON.stringify(reservations, null, 2) +
		JSON.stringify(course, null, 2) +
		JSON.stringify(reviews, null, 2);

	let modalFunction;

	$: tabs = (() => {
		let tabs = [];

		if (course?.lectures?.length)
			tabs.push({ display: 'lectures', tabName: 'lectures', icon: 'bi-easel-fill' });
		if (reservations?.length)
			tabs.push({ display: 'reservations', tabName: 'reservations', icon: 'bi-people-fill' });
		if (reviews?.length)
			tabs.push({ display: 'reviews', tabName: 'reviews', icon: 'bi-star-fill' });

		return tabs;
	})();

	function deleteReservation(id, i) {
		apiDeleteReservation(id).then((response) => {
			if (response.ok) {
				reservations = reservations.filter((_, idx) => idx != i);
				$successMessage = 'successfully removed reservation';
				return;
			}
			$errorMessage = 'could not remove reservation';
		});
	}
</script>

<svelte:head>
	<title>
		TTL - {course.abbreviation}
	</title>
</svelte:head>

<div class="mx-auto h-full pt-10">
	<div class="bg-gray-100 flex-col rounded">
		<CourseShowcase {course} />
		<div>
			<div class="text-right my-2 mx-2 flex flex-row align-center justify-between">
				<button
					class="rounded disabled:opacity-50  bg-{course.color}-500 hover:bg-{course.color}-600 opacity-80 text-white px-3 py-1"
				>
					<a href={`/mycourses/${course.abbreviation}/edit`}>edit course</a>
				</button>
				<InternalNav {tabs} store={activeTabCourse} />
			</div>
			{#if $activeTabCourse == 'lectures'}
				{#if course.lectures}
					<LectureTable lectures={course.lectures} />
				{/if}
			{:else if $activeTabCourse == 'reservations'}
				{#if reservations?.length}
					<table class="border min-w-full divide-y divide-gray-200 table-auto">
						<thead class="bg-gray-50">
							<tr>
								<th
									scope="col"
									class="py-3 px-2 text-left  font-medium text-gray-500 uppercase tracking-wider"
								>
									id
								</th>

								<th
									scope="col"
									class="py-3 text-left  font-medium text-gray-500 uppercase tracking-wider"
								>
									fullname
								</th>

								<th
									scope="col"
									class=" py-3 text-center  font-medium text-gray-500 uppercase tracking-wider"
								>
									remove
								</th>
							</tr>
						</thead>
						<tbody class="bg-white divide-y divide-gray-200  ">
							{#each reservations as reservation, i}
								<tr class="even:bg-gray-100 hover:bg-gray-100 border">
									<td class="whitespace-nowrap px-2 py-2">
										<div class="flex items-center">
											<div class="text-sm font-medium text-gray-900">
												#{reservation.id}
											</div>
										</div>
									</td>
									<td class="whitespace-nowrap">
										<div class="text-sm text-gray-900">
											{reservation.fullname}
										</div>
									</td>

									<td class="whitespace-nowrap">
										<div class="text-sm text-gray-900 text-center">
											<button
												on:click={() => {
													$showModal = true;
													modalFunction = () => {
														deleteReservation(reservation.id, i);
													};
												}}
												type="button"
												class="rounded  bg-red-500 text-white h-6 w-6 hover:bg-red-600"
											>
												<i class="bi bi-trash2-fill" />
											</button>
										</div>
									</td>
								</tr>
							{/each}
						</tbody>
					</table>
				{/if}
			{:else if reviews}
				<ReviewList {reviews} />
			{/if}
		</div>
	</div>
</div>

<Modal
	body="do you really want to remove this reservation?"
	title="remove reservation"
	color="red"
	button="remove"
	func={modalFunction}
/>
