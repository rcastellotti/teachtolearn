<script>
	import { usernameStore, isPropicPresentOnS3, propicUrl, debug } from '$src/stores';
	import { apiGetPresignedUrl } from '$src/api';

	async function uploadImage(filename) {
		let presignedURL = await apiGetPresignedUrl(filename).then((response) => response.json());
		presignedURL = presignedURL.msg;
		var file = new File([base64], 'filename');
		await fetch(presignedURL, {
			method: 'PUT',
			body: file
		});
	}
	async function update() {
		let url = window.URL.createObjectURL(this.files[0]);
		document.getElementById('blah').src = url;
		base64 = await fetch(url).then((r) => r.blob());
		$debug = $usernameStore;
		uploadImage($usernameStore);
	}
</script>

<input id="upload-photo" on:change={update} disabled={!$usernameStore?.length > 0} type="file" />
<div class="mx-auto group relative h-16 w-16 md:w-24 md:h-24 rounded-full bg-black cursor-pointer">
	<img
		class="transition group-hover:opacity-50 rounded-full h-16 w-16  md:w-24 md:h-24"
		alt="propic"
		id="blah"
		src={`http://192.168.1.201:9000/ttl-dev/${$usernameStore}`}
	/>
	<label for="upload-photo">
		<i
			class="opacity-0 transition group-hover:scale-110 absolute top-1/2 left-1/2 transform -translate-x-1/2 
				-translate-y-1/2 text-dark  group-hover:text-white group-hover:opacity-100  text-4xl md:text-6xl bi bi-plus cursor-pointer"
		/>
	</label>
</div>

<style>
	input {
		display: none;
	}
</style>
