<script>
	import '$src/app.css';
	import '../../node_modules/bootstrap-icons/font/bootstrap-icons.css';
	import { session } from '$app/stores';
	import {
		debug,
		errorMessage,
		successMessage,
		infoMessage,
		propicUrl,
		usernameStore
	} from '$src/stores';
	import { apiLogout } from '$src/api';
	import { goto } from '$app/navigation';
	import { variables } from '$src/variables.js';
	import PropicDropdownMenu from '$components/PropicDropdownMenu.svelte';
	import Toast from '$components/Toast.svelte';
	import Logo from '$components/Logo.svelte';
	import Search from '$components/Search.svelte';

	let showDebug = false;
	let showMenuMobile = false;
	$propicUrl = `${variables.s3Url}${$session?.profile?.username}`;
	$debug = JSON.stringify($session?.profile, null, 2);
	$usernameStore = $session?.profile?.username;
	$: isUserLoggedIn = !!$session?.profile?.username;

	function logout() {
		apiLogout();
		$session.profile = {};
		goto('/');
	}

	let routes = [
		{
			display: 'home',
			url: '/',
			areSubRoutesVisible: false,
			role: '',
			subRoutes: []
		},
		{
			display: 'add course',
			url: '/courses/new',
			areSubRoutesVisible: false,
			role: '',
			subRoutes: []
		},
		{
			display: 'profile',
			role: '',
			areSubRoutesVisible: false,
			subRoutes: [
				{
					display: 'my profile',
					url: '/profile'
				},
				{
					display: 'my courses',
					url: '/mycourses'
				},
				{
					display: 'my reservations',
					url: '/myreservations'
				},
				{
					display: 'reset password',
					url: '/passwordReset'
				},
				{
					display: 'sessions',
					url: '/sessions'
				}
			]
		},
		{
			display: 'admin',
			url: '/admin',
			role: 'admin',
			areSubRoutesVisible: false,
			subRoutes: [
				{
					display: 'users',
					url: '/admin/users'
				},
				{
					display: 'courses',
					url: '/admin/courses'
				},
				{
					display: 'lectures',
					url: '/admin/lectures'
				},
				{
					display: 'reviews',
					url: '/admin/reviews'
				}
			]
		}
	];
</script>

<div class=" flex flex-col justify-between flex-auto inset-0 absolute text-[15px]">
	<nav class="bg-gray-100 shadow flex items-center">
		<div class="flex justify-between items-center w-11/12 h-16 mx-auto ">
			<div class="flex w-full items-center justify-between">
				<div class="flex items-center">
					<a href="/">
						<Logo />
					</a>
					<a href="/courses" class="hidden md:block font-medium hover:underline ml-5">courses </a>
				</div>
				<div class="mr-5 flex-end w-full hidden md:block md:w-9/12 lg:w-7/12 xl:w-4/12 2xl:w-3/12">
					<Search />
				</div>
			</div>
			{#if isUserLoggedIn}
				<div class="flex items-center ml-auto">
					<PropicDropdownMenu {routes} bind:showMenuMobile={showMenuMobile} />
				</div>
			{:else}
				<div class="hidden md:flex items-center font-medium whitespace-nowrap">
					<a class="px-3 text-gray-600 hover:text-gray-900 hover:underline" href="/signin"
						>sign in</a
					>
					<a href="/signup" class="px-2 py-1 rounded text-white  bg-blue-500 hover:bg-blue-600">
						sign up
					</a>
				</div>
				<button class="md:hidden  text-gray-600 hover:text-gray-900">
					<div class="text-2xl">
						{#if showMenuMobile}
							<i on:click={() => (showMenuMobile = false)} class="bi bi-x-lg" />
						{:else}
							<i on:click={() => (showMenuMobile = true)} class="bi bi-list" />
						{/if}
					</div>
				</button>
			{/if}
		</div>
	</nav>
	{#if showMenuMobile}
		<div class="h-full w-full flex flex-col justify-between">
			<div class="w-11/12 mx-auto">
				<div class="mx-auto my-3 flex-end">
					<Search />
				</div>
				<ul class="text-xl font-normal">
					<li class="block border-b border-gray-300">
						<a
							on:click={() => (showMenuMobile = false)}
							href="/courses"
							class="block py-4 text-gray-600 hover:text-gray-900">courses</a
						>
					</li>

					<li class="block border-b border-gray-300">
						<a
							on:click={() => (showMenuMobile = false)}
							href="/courses/new"
							class="block py-4 text-gray-600 hover:text-gray-900">add course</a
						>
					</li>

					{#if isUserLoggedIn}
						<li class="block border-b border-gray-300">
							<a
								on:click={() => (showMenuMobile = false)}
								href="/profile"
								class="block py-4 text-gray-600 hover:text-gray-900">my profile</a
							>
						</li>

						<li class="block border-b border-gray-300">
							<a
								on:click={() => (showMenuMobile = false)}
								href="/mycourses"
								class="block py-4 text-gray-600 hover:text-gray-900">my courses</a
							>
						</li>

						<li class="block border-b border-gray-300">
							<a
								on:click={() => (showMenuMobile = false)}
								href="/myreservations"
								class="block py-4 text-gray-600 hover:text-gray-900">my reservations</a
							>
						</li>

						<li class="block border-b border-gray-300">
							<a
								on:click={() => (showMenuMobile = false)}
								href="/passwordReset"
								class="block py-4 text-gray-600 hover:text-gray-900">reset password</a
							>
						</li>

						<li class="block border-b border-gray-300">
							<a
								on:click={() => (showMenuMobile = false)}
								href="/sessions"
								class="block py-4 text-gray-600 hover:text-gray-900">sessions</a
							>
						</li>
					{/if}
				</ul>
				{#if $session?.profile?.role === 'admin'}
					<h3>Admin</h3>
					<ul class="text-xl font-normal">
						<li class="block border-b border-gray-300">
							<a
								on:click={() => (showMenuMobile = false)}
								href="/admin/users"
								class="block py-4 text-gray-600 hover:text-gray-900">users</a
							>
						</li>
					</ul>
					<ul class="text-xl font-normal">
						<li class="block border-b border-gray-300">
							<a
								on:click={() => (showMenuMobile = false)}
								href="/admin/courses"
								class="block py-4 text-gray-600 hover:text-gray-900">courses</a
							>
						</li>
					</ul>
					<ul class="text-xl font-normal">
						<li class="block border-b border-gray-300">
							<a
								on:click={() => (showMenuMobile = false)}
								href="/admin/lectures"
								class="block py-4 text-gray-600 hover:text-gray-900">lectures</a
							>
						</li>
					</ul>
					<ul class="text-xl font-normal">
						<li class="block border-b border-gray-300">
							<a
								on:click={() => (showMenuMobile = false)}
								href="/admin/reviews"
								class="block py-4 text-gray-600 hover:text-gray-900"
								>reviews
							</a>
						</li>
					</ul>
				{/if}
			</div>
			<div class="grid grid-cols-2 gap-2 w-11/12 mx-auto mb-3">
				{#if !$session?.profile?.username}
					<a
						on:click={() => (showMenuMobile = false)}
						href="/signin"
						class="font-medium  button p-2 border border-gray-400 rounded bg-white button-border whitespace-nowrap flex justify-center"
						><span class="mx-auto">sign in</span></a
					>
					<a
						on:click={() => (showMenuMobile = false)}
						href="/signup"
						class=" font-medium text-white  button  p-2 border border-gray-400 rounded bg-blue-500 button-border whitespace-nowrap flex justify-center"
						><span class="mx-auto">sign up</span></a
					>
				{:else}
					<button
						class="font-medium button p-2 border border-gray-400 rounded bg-white button-border whitespace-nowrap flex justify-center col-span-2"
						on:click={logout}
					>
						logout
					</button>
				{/if}
			</div>
		</div>
	{:else}
		<div class="h-full overflow-auto mx-auto w-11/12">
			<slot />
		</div>
	{/if}

	<footer class="text-xs md:text-sm mb-1 flex flex-col justify-center items-center">
		<div>
			made with 🎓,🧑‍🏫,📚 by
			<a class="ml-1 text-blue-500 hover:underline" href="https://rcastellotti.dev">rcastellotti</a
			>,
			<a class="ml-1 text-blue-500 hover:underline" href="https://fabifont.github.io">fabifont</a>,
			<a class="ml-1 text-blue-500 hover:underline" href="https://github.com/fedfontana"
				>fedfontana</a
			>
		</div>
	</footer>
</div>

{#if showDebug}
	<div class="fixed inset-0 bg-black z-40 bg-opacity-90  transition-opacity overflow-auto">
		<pre class="debug relative text-xs top-4 left-4  overflow-auto  rounded  text-white ">
			<code>{$debug}</code>
		</pre>
	</div>
{/if}

{#if variables.environment === 'development'}
	<button
		on:click={() => (showDebug = !showDebug)}
		class="bg-neutral-800 rounded absolute bottom-2 z-50 right-2 700 px-2 py-1 text-white text-sm"
	>
		debug
	</button>
{/if}

{#if $errorMessage}
	<Toast type={'error'} message={$errorMessage} />
{/if}
{#if $successMessage}
	<Toast type={'success'} message={$successMessage} />
{/if}
{#if $infoMessage}
	<Toast type={'info'} message={$infoMessage} />
{/if}
