<script context="module">
	import { activeTabCourse, debug, successMessage, errorMessage, propicUrl } from '$src/stores';
	import { page } from '$app/stores';
	import {
		apiGetCourse,
		apiGetReviews,
		apiAddReservation,
		apiGetReservationState,
		apiDeleteReservation,
		apiAddReview
	} from '$src/api';

	import InternalNav from '$components/InternalNav.svelte';

	export async function load({ page, session }) {
		const abbreviation = page.params.abbreviation.toUpperCase();
		let course = apiGetCourse(abbreviation);
		let reviews = await apiGetReviews(abbreviation);
		if (session?.profile?.username) {
			reviews.msg.reviews.sort((_, el2) => el2.reviewer.username == session.profile.username);
			let reservationState = await apiGetReservationState(abbreviation);
			return {
				props: {
					course: await course,
					reviews: reviews,
					reservationState
				}
			};
		}
		return {
			props: {
				course: await course,
				reviews: reviews
			}
		};
	}
</script>

<script>
	import CourseShowcase from '$components/CourseShowcase.svelte';
	import LectureTable from '$components/LectureTable.svelte';
	import ReviewList from '$components/ReviewList.svelte';

	import { session } from '$app/stores';

	export let course, reviews, reservationState;

	if ($session?.profile?.username) reservationState = reservationState.msg;

	course = course.msg.course;
	reviews = reviews.msg.reviews;

	$: userCanPostReview = (() => {
		if (!$session?.profile?.username) return false;

		let userIsTheTeacher = $session.profile.username === course.teacher.username;
		let userHasAlreadyReviewed = reviews.filter(
			(review) => review.reviewer.username === $session.profile.username
		).length;

		let courseHasStarted =
			course?.beginDate && new Date(course.beginDate) < new Date(new Date().toLocaleDateString());

		return (
			reservationState.status && !userIsTheTeacher && !userHasAlreadyReviewed && courseHasStarted
		);
	})();

	$debug = JSON.stringify(course, null, 2) + JSON.stringify(reviews, null, 2);

	$: tabs = (() => {
		let tabs = [];
		if (course?.lectures?.length)
			tabs.push({ display: 'lectures', tabName: 'lectures', icon: 'bi-easel-fill' });
		tabs.push({ display: 'reviews', tabName: 'reviews', icon: 'bi-star-fill' });
		return tabs;
	})();

	let review = '';
	let rating = 4;
	let responseStatus;

	function addReview() {
		let body = JSON.stringify({ review, rating: rating + 1 });
		apiAddReview($page.params.abbreviation, body)
			.then((response) => {
				responseStatus = response.status;
				return response.json();
			})
			.then((response) => {
				if (responseStatus != 200) {
					$errorMessage = response.msg;
					return;
				}
				$successMessage = response.msg;
				reviews = [response.review, ...reviews];
				review = '';
				rating = 4;
			});
	}

	function enroll() {
		apiAddReservation($page.params.abbreviation)
			.then((response) => {
				responseStatus = response.status;
				return response.json();
			})
			.then((response) => {
				if (responseStatus == 200) {
					$successMessage = response.msg;
					reservationState.reservation = response.reservation;
					reservationState.status = true;
					return;
				}
				$errorMessage = response.msg;
				return;
			});
	}

	async function cancelEnrollment(id) {
		apiDeleteReservation(id).then((response) => {
			if (response.status == 200) {
				$successMessage = 'Reservation successfully deleted';
				delete reservationState.reservation;
				reservationState.status = false;
				return;
			}
			$errorMessage = 'There was an error deleting your reservation';
		});
	}

	function switchEnrollmentStatus() {
		if (reservationState.status == true) {
			cancelEnrollment(reservationState.reservation.id);
			return;
		}
		enroll();
	}
</script>

<svelte:head>
	<title>
		TTL - {course.abbreviation}
	</title>
</svelte:head>

<div class="mx-auto h-full pt-10">
	<div class="bg-gray-100 p-5 flex-col rounded">
		<CourseShowcase {course} />
		<div>
			<div class="text-right my-2 mx-2 flex flex-row align-center justify-between">
				{#if $session?.profile?.username && $session?.profile?.username !== course.teacher.username}
					<button
						class="rounded disabled:opacity-50  bg-{course.color}-500 hover:bg-{course.color}-600 opacity-80 text-white px-3 py-1"
						disabled={course.enrolledStudents === course.maxStudents}
						on:click={switchEnrollmentStatus}
					>
						{reservationState.status === true ? 'cancel enrollment' : 'enroll'}
					</button>
				{/if}
				<InternalNav {tabs} store={activeTabCourse} />
			</div>
			{#if $activeTabCourse == 'lectures'}
				{#if course.lectures}
					<LectureTable lectures={course.lectures} />
				{/if}
			{:else}
				<div class="mx-auto flex flex-col items-center w-full mb-2">
					{#if userCanPostReview}
						<div class="p-2 flex flex-col gap-y-1 w-full mx-auto rounded">
							<div class="flex w-full gap-x-2 items-start">
								<img src={$propicUrl} class="w-10 h-10 rounded-full" alt="" />
								<textarea
									maxlength="1024"
									rows="5"
									review
									class="bg-white rounded border p-1 w-full focus:outline-none"
									bind:value={review}
									placeholder="add a review"
								/>
							</div>

							<div class="pl-12 flex justify-between">
								<span>
									{#each Array(10) as _, i}
										<i
											on:mouseover={() => (rating = i)}
											on:focus={() => (rating = i)}
											class="bi text-base {rating > i - 1 ? 'bi-star-fill' : 'bi-star'}"
										/>
									{/each}
								</span>
								<button
									on:click={() => addReview()}
									disabled={review.length == 0}
									class="self-end bg-blue-500 disabled:bg-blue-400 hover:bg-blue-600 px-2 py-1 font-semibold text-white rounded"
									>post
								</button>
							</div>
						</div>
					{/if}
					{#if reviews}
						<ReviewList bind:reviews />
					{/if}
				</div>
			{/if}
		</div>
	</div>
</div>
