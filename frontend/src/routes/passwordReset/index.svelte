<script>
	import { apiGetPasswordResetToken } from '$src/api.js';
	import { errorMessage, infoMessage } from '$src/stores';
	import LoadingSpinner from '$components/LoadingSpinner.svelte';

	let email = '';
	let loading = false;
	let responseStatus = '';
	$: isFormValid = email != null;

	async function reset() {
		loading = true;
		$errorMessage = '';
		let body = JSON.stringify({
			email
		});
		apiGetPasswordResetToken(body)
			.then((response) => {
				responseStatus = response.status;
				return response.json();
			})
			.then((response) => {
				loading = false;
				if (responseStatus == 200) {
					$infoMessage = response;
					return;
				}
				$errorMessage = response;
			});
	}
</script>

<div class="h-full flex flex-col justify-center   ">
	<div class="text-sm pb-5 px-5 bg-gray-100 mx-auto shadow rounded">
		<h1 class="text-2xl py-2 font-bold">password reset</h1>
		<div>Enter your email address to receive a password reset link.</div>
		<label class="font-bold" for="email"> e-mail </label>
		<input
			class="border bg-white rounded w-full p-1"
			id="email"
			type="email"
			placeholder="email"
			bind:value={email}
		/>

		<div class="flex items-center float-right my-2">
			<button
				disabled={!isFormValid}
				on:click={reset}
				class=" rounded disabled:bg-blue-400 bg-blue-500 hover:bg-blue-600 text-white font-semibold py-1 px-2 "
				>reset
				{#if loading}
					<LoadingSpinner />
				{/if}
			</button>
		</div>
	</div>
</div>
