<script context="module">
	import { apiAdminGetReviews, apiBanReview, apiunBanReview } from '$src/api';
	import { successMessage, errorMessage, debug, showModal } from '$src/stores';
	import Modal from '$components/Modal.svelte';

	export async function load() {
		const reviews = await apiAdminGetReviews(1);
		return {
			props: {
				reviews: await reviews
			}
		};
	}
</script>

<script>
import ProfilePicture from "$components/ProfilePicture.svelte";

	function banReview(id, i) {
		apiBanReview(id).then((response) => {
			if (response.ok) {
				$successMessage = 'successfully banned review';
				reviews[i].isBanned = true;
				return;
			}
			$errorMessage = 'could not ban review';
		});
	}
	function unbanReview(id, i) {
		apiunBanReview(id).then((response) => {
			if (response.ok) {
				$successMessage = 'successfully unbanned review';
				reviews[i].isBanned = false;
				return;
			}
			$errorMessage = 'could not unban review';
		});
	}
	export let reviews;
	let pages = reviews.msg.pages;
	reviews = reviews.msg.reviews;
	$debug = JSON.stringify(reviews, null, 2);
	let page = 1;

	async function fetchDataTable(page) {
		apiAdminGetReviews(page).then((response) => {
			reviews = response.msg.reviews;
			console.log(reviews);
		});
	}
	let modalColor;
	let modalBody;
	let modalTitle;
	let modalFunction;
	let modalButton;
</script>

<div
	class="absolute  w-11/12 right-1/2 justify-center max-h-[90%] flex  left-1/2 top-1/2 transform -translate-y-1/2 -translate-x-1/2
"
>
	<div class="w-full space-y-2 overflow-scroll">
		<div class="border">
			<table class="border min-w-full divide-y divide-gray-200 table-auto">
				<thead class="bg-gray-50">
					<tr>
						<th class="py-2 px-2 text-left font-medium text-gray-500 uppercase tracking-wider">
							reviewer
						</th>

						<th class="py-2 px-2 text-left font-medium text-gray-500 uppercase tracking-wider">
							reviewee
						</th>

						<th
							class="text-center hidden md:table-cell font-medium text-gray-500 uppercase tracking-wider"
						>
							review
						</th>
						<th class=" text-center hidden lg:table-cell font-medium text-gray-500 uppercase tracking-wider">
							rating
						</th>

						<th class="text-left font-medium text-gray-500 uppercase tracking-wider" />
					</tr>
				</thead>
				<tbody class="bg-white divide-y divide-gray-200">
					{#if reviews?.length}
						{#each reviews as review, i}
							<tr class="even:bg-gray-100 hover:bg-gray-100 border">
								<td class=" p-2 whitespace-nowrap">
									<div class="flex items-center">
										<div class="flex-shrink-0 h-8 w-8">
											<ProfilePicture size=8 md_size=8 fullname={review.reviewer.fullname} />
										</div>
										<div class="ml-2">
											<div class="text-sm font-medium text-gray-900">
												<a class="hover:underline" href="/user/{review.reviewer.username}">{review.reviewer.username}</a
												>
											</div>
										</div>
									</div>
								</td>

								<td class="w-1/5 text-justify">
									<div class="text-sm text-gray-900">{review.courseAbbreviation}</div>
								</td>

								<td class="w-2/5 text-justify hidden md:table-cell">
									<div class="text-sm text-gray-900">{review.review}</div>
								</td>
								<td class="w-1/5 text-center hidden lg:table-cell ">
									<div class="text-sm text-gray-900">{review.rating}</div>
								</td>
								<td class="whitespace-nowrap">
									<div class="text-sm text-gray-900 text-center">
										{#if review.isBanned}
											<button
												on:click={() => {
													$showModal = true;
													modalBody = 'do you really want to unban this review?';
													modalTitle = 'unban review';
													modalColor = 'green';
													modalButton = 'unban';
													modalFunction = () => unbanReview(review.id, i);
												}}
												type="button"
												class="rounded  bg-green-500 text-white h-6 w-6 hover:bg-green-600"
											>
												<i class="bi bi-arrow-counterclockwise" />
											</button>
										{:else}
											<button
												on:click={() => {
													$showModal = true;
													modalBody = 'do you really want to ban this review?';
													modalTitle = 'ban review';
													modalColor = 'red';
													modalButton = 'ban';
													modalFunction = () => banReview(review.id, i);
												}}
												type="button"
												class="rounded  bg-red-500 text-white h-6 w-6 hover:bg-red-600"
											>
												<i class="bi bi-x-lg" />
											</button>
										{/if}
									</div>
								</td>
							</tr>
						{/each}
					{/if}
				</tbody>
			</table>
			<div class="flex justify-end">
				<div class=" p-1 text-sm flex items-center">
					<button
						disabled={page == 1}
						on:click={() => {
							--page;
							fetchDataTable(page);
						}}
						class=" rounded-full px-2 py-1 hover:bg-gray-200 hover:text-black disabled:text-gray-500"
						><i class="bi bi-chevron-left" /></button
					>
					<div class=" p-2 border rounded">{page}/{pages}</div>
					<button
						disabled={page == pages}
						on:click={() => {
							++page;
							fetchDataTable(page);
						}}
						class=" rounded-full px-2 py-1 hover:bg-gray-200 hover:text-black disabled:text-gray-500"
						><i class="bi bi-chevron-right" /></button
					>
				</div>
			</div>
		</div>
	</div>
</div>

<Modal
	body={modalBody}
	title={modalTitle}
	func={modalFunction}
	button={modalButton}
	color={modalColor}
/>
