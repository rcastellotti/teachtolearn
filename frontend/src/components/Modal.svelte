<script>
	import { showModal } from '$src/stores.js';

	export let body, title, func, button, color;
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
			<div
				class="fixed inset-0  backdrop-filter backdrop-blur bg-black bg-opacity-50 transition-opacity"
				aria-hidden="true"
			/>

			<!-- This element is to trick the browser into centering the modal contents. -->
			<span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">
				&#8203;
			</span>

			<div
				class="z-40 inline-block align-bottom bg-white rounded text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full"
			>
				<div class="bg-white px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
					<div class="sm:flex sm:items-start">
						<div
							class="mx-auto flex-shrink-0 flex items-center justify-center h-12 w-12 rounded-full bg-{color}-100 sm:mx-0 sm:h-10 sm:w-10"
						>
							<i class="text-{color}-600 bi bi-exclamation-triangle-fill text-2xl" />
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
				<div class="bg-gray-50 px-4 py-3 sm:px-6 grid grid-cols-2 gap-2 ">
					<button
						on:click={() => {
							$showModal = false;
						}}
						type="button"
						class="inline-flex justify-center rounded border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none  sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm"
					>
						back
					</button>
					<button
						on:click={() => {
							func();
							$showModal = false;
						}}
						type="button"
						class=" inline-flex justify-center rounded border border-transparent shadow-sm px-4 py-2 bg-{color}-600 text-base font-medium text-white hover:bg-{color}-700 focus:outline-none  sm:ml-3 sm:w-auto sm:text-sm"
					>
						{button}
					</button>
				</div>
			</div>
		</div>
	</div>
{/if}
