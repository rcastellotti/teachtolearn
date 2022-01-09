<script context="module">
	import { session } from '$app/stores';
	import { apiUpdateProfile } from '$src/api.js';
	import { successMessage, errorMessage, debug, showModal } from '$src/stores';
	import ModalPassword from '$components/ModalPassword.svelte';

	export async function load({ session }) {
		let isUserLoggedIn = !!session?.profile?.username;
		if (!isUserLoggedIn) {
			return {
				status: 302,
				redirect: '/signin?next=/profile'
			};
		}
		return {
			props: {
				profile: session.profile
			}
		};
	}
</script>

<script>
	let email = $session.profile.email;
	let oldUsername = $session.profile.username;
	let username = $session.profile.username;
	let fullname = $session.profile.fullname;
	let bio = $session.profile.bio;
	let password = '';
	let responseStatus = '';
	let modal = {
		title: 'delete account',
		body: 'please confirm your password to delete your account',
		button: 'delete'
	};
	async function updateProfile() {
		let newUsername = oldUsername;
		let body = JSON.stringify({
			email,
			newUsername,
			oldUsername,
			password,
			bio
		});
		apiUpdateProfile(body)
			.then((response) => {
				responseStatus = response.status;
				return response.json();
			})
			.then((response) => {
				if (responseStatus == 200) {
					$successMessage = response;
					return;
				}
				$errorMessage = response;
			});
	}

	const usernameRegex = /^[\w\-\.]+$/;
	$: usernameIsValid = username != null && usernameRegex.test(username);
	$: fullnameIsValid = fullname.length > 0;
	$: passwordIsValid = password.length > 0;
	$: isFormValid = usernameIsValid && fullnameIsValid && passwordIsValid;
	$debug = JSON.stringify($session.profile, null, 2);
</script>

<svelte:head>
	<title>TTL - Profile</title>
</svelte:head>

<div class="h-full flex flex-col justify-center">
	<div class="text-sm bg-gray-100 mx-auto md:w-5/12 rounded pb-5 px-5">
		<div class="flex justify-between items-center py-2">
			<h1 class="text-2xl  font-bold">edit profile</h1>
		</div>
		<label class="font-bold" for="email"> e-mail </label>
		<input
			class="bg-white rounded border p-1 w-full"
			type="text"
			placeholder="email"
			name="email"
			bind:value={email}
			disabled
		/>
		<label class="font-bold" for="username">username </label>
		<input
			class="border bg-white rounded p-1 w-full"
			class:input-not-valid={username.length > 0 && !usernameIsValid}
			type="text"
			placeholder="username"
			id="username"
			bind:value={username}
		/>
		{#if username.length > 0 && !usernameIsValid}
			<p class="text-red-500 text-xs">username should only contain letters, numbers and - _ .</p>
		{/if}
		<label class="font-bold" for="fullname">fullname </label>
		<input
			class="border bg-white rounded w-full p-1"
			class:input-not-valid={fullname.length == 0}
			type="text"
			placeholder="fullname"
			id="fullname"
			bind:value={fullname}
		/>
		{#if fullname.length == 0}
			<p class="text-red-500 text-xs">fullname required</p>
		{/if}
		<label class="font-bold" for="password"> password </label>
		<input
			class="bg-white rounded border p-1 w-full"
			type="password"
			placeholder="insert your password"
			id="password"
			bind:value={password}
		/>
		<label class="font-bold" for="bio"> bio </label>
		<textarea
			maxlength="1024"
			id="bio"
			rows="5"
			class="bg-white rounded border p-1 w-full"
			bind:value={bio}
			placeholder="if you feel like it, insert a short bio"
		/>
		<div class="flex items-center justify-between mt-2">
			<button
				on:click={() => {
					$showModal = true;
				}}
				class="rounded bg-red-700 text-white py-2 px-4 font-semibold">delete account</button
			>

			<button
				disabled={!isFormValid}
				on:click={updateProfile}
				class="rounded disabled:bg-blue-400 bg-blue-500 hover:bg-blue-600 text-white font-semibold py-2 px-4 "
				>update
			</button>
		</div>
	</div>
</div>
<ModalPassword {...modal} />
