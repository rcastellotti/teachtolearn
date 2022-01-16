<script context="module">
	import { apiSignUp } from '$src/api.js';
	import { successMessage, errorMessage, usernameStore } from '$src/stores';
	import { goto } from '$app/navigation';
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
	let email = '';
	let username = '';
	let password = '';
	let passwordConfirm = '';
	let fullname = '';
	let bio = '';
	let responseStatus = '';
	const usernameRegex = /^[\w\-\.]+$/;
	$: $usernameStore = username;

	let isPasswordVisible = false;
	let passwordInput;
	let passwordConfirmInput;

	function changePasswordVisibility() {
		isPasswordVisible = !isPasswordVisible;
		if (isPasswordVisible) {
			passwordInput.type = 'text';
			passwordConfirmInput.type = 'text';
		} else {
			passwordInput.type = 'password';
			passwordConfirmInput.type = 'password';
		}
	}

	async function signUp() {
		if (password != passwordConfirm) {
			error = 'passwords do not match';
			return;
		}
		let body = JSON.stringify({
			email,
			password,
			fullname,
			username,
			bio
		});
		apiSignUp(body)
			.then((response) => {
				responseStatus = response.status;
				return response.json();
			})
			.then((response) => {
				if (responseStatus == 200) {
					$successMessage = response.msg;
					setTimeout(() => {
						goto('/');
					}, 2000);
					return;
				}
				$errorMessage = response.msg;
			});
	}

	function validateEmail(email) {
		var re =
			/^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
		return re.test(email);
	}
	$: emailIsValid = email.length && validateEmail(email);
	$: usernameIsValid = username != null && usernameRegex.test(username) && username.length <= 64;
	$: fullnameIsValid = fullname != null && fullname.length <= 64;
	$: passwordIsValid = password.length >= 8 && password.length <= 64;
	$: passwordConfirmLengthIsValid = passwordConfirm.length >= 8 && passwordConfirm.length <= 64;
	$: passwordConfirmMatchesPassword = password == passwordConfirm;
	$: isFormValid =
		emailIsValid &&
		usernameIsValid &&
		fullnameIsValid &&
		passwordIsValid &&
		passwordConfirmLengthIsValid &&
		passwordConfirmMatchesPassword;
</script>

<svelte:head>
	<title>TTL - signUp</title>
</svelte:head>

<div class="h-full flex flex-col shrink-0 justify-center">
	<div class="text-sm bg-gray-100 md:w-5/12 mx-auto rounded shadow pb-2 px-5">
		<div class="flex justify-between items-center py-2">
			<h1 class="text-2xl  font-bold">sign up</h1>
		</div>
		<label class="font-bold" for="email">e-mail</label>
		<input
			class="bg-white rounded border p-1 w-full"
			class:input-not-valid={email.length > 0 && !emailIsValid}
			id="email"
			type="text"
			placeholder="email"
			required
			bind:value={email}
		/>
		{#if email.length > 0 && !emailIsValid}
			<div class="text-red-500 text-xs">not a valid email address</div>
		{/if}
		<label class="font-bold" for="username">username </label>
		<input
			class=" border bg-white rounded p-1 w-full text-grey-darker md:bg-white"
			class:input-not-valid={username.length > 0 && !usernameIsValid}
			id="username"
			type="text"
			required
			placeholder="username"
			bind:value={username}
		/>
		{#if username.length > 0 && !usernameIsValid}
			<div class="text-red-500 text-xs">
				username should only contain letters, numbers and - _ .
			</div>
		{/if}
		<label class="font-bold" for="fullname">fullname </label>
		<input
			class="borderbg-white rounded w-full p-1"
			class:input-not-valid={fullname.length > 0 && !fullnameIsValid}
			id="fullname"
			type="text"
			required
			placeholder="fullname"
			bind:value={fullname}
		/>
		{#if fullname.length > 0 && !fullnameIsValid}
			<div class="w-full text-red-500 text-xs">
				fullname must be provided and its length should be less than 65
			</div>
		{/if}

		<label class="font-bold" for="password"> password </label>
		<div class="flex flex-row relative">
			<input
				class="bg-white rounded border p-1 w-full"
				type="password"
				bind:this={passwordInput}
				placeholder="insert your password"
				id="password"
				required
				bind:value={password}
			/>
			<span on:click={changePasswordVisibility} class="absolute right-2 top-1">
				<i class="bi bi-eye-fill" />
			</span>
		</div>
		{#if password.length > 0 && !passwordIsValid}
			<div class="w-full text-red-500 text-xs">
				password length should be at least 8 and less than 65
			</div>
		{/if}

		<label class="font-bold" for="confirmPassword"> confirm password </label>
		<div class="flex flex-row relative">
			<input
				class="bg-white rounded border p-1 w-full"
				type="password"
				placeholder="confirm  password"
				id="confirmPassword"
				required
				bind:value={passwordConfirm}
				bind:this={passwordConfirmInput}
			/>
			<span on:click={changePasswordVisibility} class="absolute right-2 top-1">
				<i class="bi bi-eye-fill" />
			</span>
		</div>
		{#if passwordConfirm.length > 0 && !passwordConfirmMatchesPassword}
			<div class="w-full text-red-500 text-xs">passwords do not match</div>
		{/if}
		<label class="font-bold" for="bio"> bio </label>
		<textarea
			maxlength="1024"
			id="bio"
			rows="5"
			class="bg-white rounded border p-1 w-full"
			bind:value={bio}
			placeholder="insert a short bio"
		/>
		<div class="flex items-center justify-between mt-2">
			<a class="font-bold  hover:underline" href="/signin"> signin </a>
			<button
				disabled={!isFormValid}
				on:click={signUp}
				class=" rounded disabled:bg-blue-400 bg-blue-500 hover:bg-blue-600 text-white font-semibold py-1 px-2"
				>sign up
			</button>
		</div>
	</div>
</div>
