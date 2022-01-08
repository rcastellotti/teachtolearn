<script>
	import { goto } from '$app/navigation';
	import { session } from '$app/stores';
	import { apiDeleteUser } from '$src/api.js';
	import { errorMessage, showModal } from '$src/stores';

	export let body, title, button;
	let password = '';
	let responseStatus = '';

	let passwordInput;
	function changePasswordVisibility() {
		if (passwordInput.type === 'password') {
			passwordInput.type = 'text';
		} else {
			passwordInput.type = 'password';
		}
	}

	async function removePassword() {
		let body = JSON.stringify({
			password
		});
		apiDeleteUser(body)
			.then((response) => {
				responseStatus = response.status;
				return response.json();
			})
			.then((response) => {
				$session.profile = '';
				if (responseStatus == 200) {
					goto('/');
					return;
				}
				$errorMessage = response.msg;
			});
	}
</script>

{#if $showModal}
	<div
		class="fixed z-10 inset-0 overflow-y-auto"
		aria-labelledby="modal-title"
		role="dialog"
		aria-modal="true"
	>
		<div
			class="flex items-center justify-center min-h-full pt-4 px-4 pb-20 text-center sm:block sm:p-0"
		>
			<!-- backdrop-filter backdrop-blur -->
			<div class="fixed inset-0 bg-black  bg-opacity-50 transition-opacity" aria-hidden="true" />

			<!-- This element is to trick the browser into centering the modal contents. -->
			<span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true"
				>&#8203;</span
			>

			<div
				class="inline-block align-bottom bg-white rounded text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full"
			>
				<div class="bg-white px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
					<div class="sm:flex sm:items-start">
						<div
							class="mx-auto flex-shrink-0 flex items-center justify-center h-12 w-12 rounded-full bg-red-100 sm:mx-0 sm:h-10 sm:w-10"
						>
							<i class="text-red-600 bi bi-exclamation-triangle-fill text-2xl" />
						</div>
						<div class="mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left">
							<h3 class="text-lg leading-6 font-medium text-gray-900" id="modal-title">
								{title}
							</h3>
							<div class="mt-2">
								<p class="text-sm text-gray-500">
									{body}
								</p>
							</div>
						</div>
					</div>
				</div>

				<div class="bg-gray-100 px-4 py-3 sm:px-6 grid grid-cols-2 gap-2 ">
					<div class="flex flex-row relative  col-span-2">
						<input
							class=" text-sm border bg-white rounded p-1 w-full text-grey-darker md:bg-white"
							id="password"
							type="password"
							bind:this={passwordInput}
							placeholder="confirm your password"
							name="password"
							bind:value={password}
						/>
						<span on:click={changePasswordVisibility} class="absolute right-2 top-1">
							<i class="bi bi-eye-fill" />
						</span>
					</div>

					<button
						tabindex="0"
						on:click={() => ($showModal = false)}
						type="button"
						class="inline-flex justify-center rounded border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 sm:mt-0  sm:w-auto sm:text-sm"
					>
						back
					</button>
					<button
						tabindex="0"
						on:click={() => {
							removePassword();
							$showModal = false;
						}}
						type="button"
						class=" inline-flex justify-center rounded border border-transparent shadow-sm px-4 py-2 bg-red-600 text-base font-medium text-white hover:bg-red-700 sm:w-auto sm:text-sm"
					>
						{button}
					</button>
				</div>
			</div>
		</div>
	</div>
{/if}
