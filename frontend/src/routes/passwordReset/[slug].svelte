<script>
	import { page } from '$app/stores';
	import { successMessage, errorMessage, debug } from '$src/stores';
	import { apiPasswordReset } from '$src/api';

	let password1, confirmPassword;
	let responseStatus;
	$: isFormValid = password1 != null && confirmPassword != null;
	function reset() {
		if (password1 != confirmPassword) {
			$errorMessage = 'passwords do not match';
			return;
		}
		const password = password1;
		const body = JSON.stringify({ password: password }, null, 2);
		$debug = body;
		apiPasswordReset($page.params.slug, body)
			.then((response) => {
				responseStatus = response.status;
				return response.json();
			})
			.then((response) => {
				if (responseStatus == 200) {
					$successMessage = response.msg;
					return;
				}
				$errorMessage = response.msg;
			});
	}
</script>

<div class="h-full flex flex-col justify-center">
	<div class="text-sm flex-col pb-5 px-5 bg-gray-100 mx-auto md:w-5/12 shadow rounded">
		<h1 class="text-2xl p-2 font-bold">reset password</h1>
		<label class="font-bold" for="password">password</label>
		<input
			class="rounded border p-1 w-full bg-white"
			type="password"
			placeholder="password"
			id="password"
			bind:value={password1}
		/>

		<label class="font-bold" for="confirmPassword">confirm password</label>
		<input
			class="rounded border p-1 w-full bg-white"
			type="password"
			placeholder="repeat password"
			id="confirmPassword"
			bind:value={confirmPassword}
		/>

		<div class="flex float-right items-center my-2">
			<button
				on:click={reset}
				disabled={!isFormValid}
				class="rounded disabled:bg-blue-400 bg-blue-500 hover:bg-blue-600 text-white font-semibold py-1 px-2 "
				>reset
			</button>
		</div>
	</div>
</div>
