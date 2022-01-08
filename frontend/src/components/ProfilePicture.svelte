<script>
	import { usernameStore, propicUrl, debug } from '$src/stores';
	import { apiGetPresignedUrl } from '$src/api';
	let input = '';
	let base64 = '';
	let isPropicPresentOnS3;
	if($usernameStore?.length > 0)
		fetch($propicUrl).then((response) => (isPropicPresentOnS3 = response.status == '200'));

	async function uploadImage(filename) {
		let presignedURL = await apiGetPresignedUrl(filename).then((response) => response.json());
		presignedURL = presignedURL.msg;

		let response = await fetch(base64);
		const blob = await response.blob();

		await fetch(presignedURL, {
			method: 'PUT',
			body: blob
		});
	}
	function update() {
		const file = input.files[0];
		const reader = new FileReader();

		reader.addEventListener(
			'load',
			function () {
				base64 = reader.result;
			},
			false
		);
		reader.readAsDataURL(file);
		$debug = $usernameStore;
		if(!$usernameStore?.length > 0)
			uploadImage($usernameStore);
	}
</script>

<input id="upload-photo" bind:this={input} on:change={update} disabled={$usernameStore?.length == 0} type="file" />
{#if isPropicPresentOnS3}
	<div class="mx-auto group relative h-16 w-16 md:w-24 md:h-24 rounded-full bg-black cursor-pointer">
		<!-- picture is updated whenever a file is uploaded clientside -->
		<img
			class="transition group-hover:opacity-50 rounded-full h-16 w-16  md:w-24 md:h-24"
			src={base64 ? base64 : $propicUrl}
			alt="propic"
		/>
		<label for="upload-photo">
			<i
				class="opacity-0 transition group-hover:scale-110 absolute top-1/2 left-1/2 transform -translate-x-1/2 
				-translate-y-1/2 text-dark  group-hover:text-white group-hover:opacity-100  text-4xl md:text-6xl bi bi-plus cursor-pointer"
			/>
		</label>
	</div>
{:else}
	<div class="h-16 w-16  md:w-24 md:h-24 mx-auto cursor-pointer">
		<div class=" mx-auto relative md:w-24 md:h-24 h-16 w-16  rounded-full">
			<div class=" bg-gray-200 z-50 filter  rounded-full md:w-24 md:h-24 h-16 w-16 " />
			<div
				class="animate-pulse flex justify-center items-center absolute top-1/2 left-1/2 transform -translate-x-1/2 
				-translate-y-1/2 w-8 h-8"
			>
				<label for="upload-photo"
					><i class=" hover:text-black  text-4xl md:text-6xl bi bi-plus" />
				</label>
			</div>
		</div>
	</div>
{/if}

<style>
	input {
		display: none;
	}
</style>
