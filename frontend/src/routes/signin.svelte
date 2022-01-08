<script context="module">
	import { goto } from '$app/navigation';
	import { page, session } from '$app/stores';
	import { apiSignIn } from '$src/api.js';
	import { errorMessage } from '$src/stores';
	export async function load({ session }) {
		let isUserLoggedIn = !!session?.profile?.username;
		if (isUserLoggedIn) {
			return {
				status: 302,
				redirect: '/'
			};
		}
		return {
			props: {}
		};
	}
</script>

<script>
	const redirectUrl = $page.query.get('next');
	let email = null;
	let password = null;
	let responseStatus;
	$: isFormValid = email != null && password != null;

	let passwordInput;

	function changePasswordVisibility() {
		if (passwordInput.type === 'password') {
			passwordInput.type = 'text';
		} else {
			passwordInput.type = 'password';
		}
	}

	async function signIn() {
		let body = JSON.stringify({
			email,
			password
		});
		apiSignIn(body)
			.then((response) => {
				responseStatus = response.status;

				return response.json();
			})
			.then((response) => {
				if (responseStatus == 200) {
					$session.profile = response.msg.profile;
					if (redirectUrl) {
						goto(redirectUrl);
					} else goto('/');
					return;
				}
				$errorMessage = response.msg;
				return;
			});
	}
</script>

<svelte:head>
	<title>TTL - signIn</title>
</svelte:head>

<div class="flex flex-col h-full justify-center">
	<div class="pb-5 px-5 text-sm bg-gray-100 mx-auto shadow rounded">
		<h1 class="text-2xl py-2 font-bold">sign in</h1>
		<label class="font-bold" for="email"> e-mail </label>
		<input
			class="bg-white rounded border p-1 w-full"
			id="email"
			type="email"
			placeholder="email"
			bind:value={email}
		/>

		<label class="font-bold" for="password"> password </label>
		<div class="flex flex-row relative">
			<input
				class="rounded border p-1 w-full bg-white"
				bind:this={passwordInput}
				type="password"
				placeholder="insert your password"
				id="password"
				bind:value={password}
			/>
			<span on:click={changePasswordVisibility} class="absolute right-2 top-1">
				<i class="bi bi-eye-fill" />
			</span>
		</div>

		<div class="flex items-center justify-between my-2">
			<a class="font-bold hover:underline" href="/passwordReset"> forgot password? </a>

			<button
				disabled={!isFormValid}
				on:click={signIn}
				class=" rounded disabled:bg-blue-400 bg-blue-500 hover:bg-blue-600 text-white font-semibold py-1 px-2"
				>sign in
			</button>
		</div>
	</div>
</div>
