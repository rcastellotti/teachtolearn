<script>
	import { successMessage, errorMessage, showModal } from '$src/stores';
	import { apiDeleteReview } from '$src/api';
	import Modal from '$components/Modal.svelte';
	import { session } from '$app/stores';
	import ProfilePicture from '$components/ProfilePicture.svelte';

	export let reviews;

	let idToDelete;
	function deleteReview() {
		apiDeleteReview(idToDelete).then((response) => {
			if (response.ok) {
				$successMessage = 'successfully removed review';
				reviews = reviews.filter((review) => review.id !== idToDelete);
			} else {
				$errorMessage = 'could not remove review';
			}
		});
	}
</script>

<ul class="space-y-3 mx-auto px-2 w-full">
	{#each reviews as review}
		<li class="bg-white px-2 flex-col py-1 w-full flex gap-x-2 items-start rounded">
			<div class=" flex flex-col w-full">
				<div class="flex items-start gap-x-2 w-full">
					<ProfilePicture size=10 md_size=10 fullname={review.reviewer.fullname} />
					<div class="flex flex-col w-full">
						<div class="flex w-full justify-between">
							{#if review.reviewer.fullname != '[deleted user]'}
								<a class="font-semibold hover:underline" href="/user/{review.reviewer.username}"
									>{review.reviewer.fullname}</a
								>
							{:else}
								<p class="text-gray-500 font-semibold">{review.reviewer.username}</p>
							{/if}
							<span class="flex gap-x-0.5">
								{#each Array(review.rating) as i}
									<i class="bi bi-star-fill" />
								{/each}
								{#if $session?.profile?.username == review.reviewer.username}
									<span class="self-end">
										<button
											on:click={() => {
												idToDelete = review.id;
												$showModal = true;
											}}
											class="rounded-full bg-red-500 hover:bg-red-600 w-5 h-5 flex hover:text-bold text-white justify-center ml-2 my-auto"
										>
											<i class="bi bi-x-lg text-sm" /></button
										>
									</span>
								{/if}
							</span>
						</div>
						<p>{review.review}</p>
					</div>
				</div>
			</div>
		</li>
	{/each}
</ul>

<Modal
	body="do you really want to remove this review?"
	title="remove review"
	func={deleteReview}
	color="red"
	button={'remove'}
/>
