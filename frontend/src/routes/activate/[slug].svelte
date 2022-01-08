<script>
	import { goto } from '$app/navigation';
	import { page } from '$app/stores';
	import { successMessage, errorMessage } from '$src/stores';
	import { apiActivate } from '$src/api';

	apiActivate($page.params.slug).then((response) => {
		if (response.ok) {
			$successMessage = 'you succesfully activated your account';

			setTimeout(() => {
				goto('/');
			}, 2000);

			return;
		}
		$errorMessage = 'account activation failed';
	});
</script>

<svelte:head>
	<title>TTL - Activate your account</title>
</svelte:head>
