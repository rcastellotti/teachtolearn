<script>
	import { apiLogout } from '$src/api';
	import { clickOutside } from '$src/utils.js';
	import { session } from '$app/stores';
	import { goto } from '$app/navigation';
	import ProfilePicture from '$components/ProfilePicture.svelte';

	let showDropdownProfile = false;
	export let routes, showMenuMobile;

	function logout() {
		apiLogout();
		$session.profile = {};
		goto('/');
	}
</script>

<button
	type="button"
	class="focus:ring focus:ring-black focus:ring-opacity-50 w-18 h-8 rounded-full"
	aria-expanded="true"
	aria-haspopup="true"
	on:click={() => {
		if(document.documentElement.clientWidth < 768)
			showMenuMobile = !showMenuMobile;
		showDropdownProfile = !showDropdownProfile;
	}}
>
	<ProfilePicture size=8 md_size=8 fullname={$session.profile.fullname} />
</button>

{#if showDropdownProfile}
	<div class="z-50 relative text-left hidden md:inline-block">
		<div
			class=" origin-top-right absolute right-0 mt-7 w-36 rounded-md shadow-lg bg-white ring-1 ring-black ring-opacity-5 divide-y divide-gray-100 focus:outline-none"
			use:clickOutside
			on:click_outside={() => {
				showDropdownProfile = false;
			}}
		>
			<div>
				{#each routes as route}
					{#if (route.role == 'admin' && $session.profile.isAdmin) || route.role == ''}
						<div
							class=" flex items-stretch justify-between text-gray-700 hover:bg-gray-100  px-4 py-2 text-sm 0"
						>
							{#if route.subRoutes.length > 0}
								<button
									on:click={() => (route.areSubRoutesVisible = !route.areSubRoutesVisible)}
									class="w-full h-full  flex justify-between"
								>
									<span>{route.display}</span>

									<i class="bi bi-chevron-down" />
								</button>
							{:else}
								<a
									on:click={() => (showDropdownProfile = !showDropdownProfile)}
									href={route.url}
									class=" w-full h-full flex items-stretch justify-between"
								>
									<span>{route.display}</span>
									<i class="bi bi-chevron-right" />
								</a>
							{/if}
						</div>
						{#if route.areSubRoutesVisible}
							<div class="border-t">
								{#each route.subRoutes as subRoute}
									<div
										class=" flex items-stretch justify-between text-gray-700 bg-gray-100 hover:bg-white px-4 py-2 text-sm 0"
									>
										<a
											on:click={() => {
												showDropdownProfile = !showDropdownProfile;
											}}
											href={subRoute.url}
											class=" w-full h-full flex items-stretch justify-between"
										>
											<span>{subRoute.display}</span>
										</a>
									</div>
								{/each}
							</div>
						{/if}
					{/if}
				{/each}
			</div>

			<div class="py-1 hover:bg-gray-100 rounded-b-md" role="none">
				<button class="hover:bg-gray-100 w-full flex  justify-start" on:click={logout}>
					<span class=" w-full block px-4 py-1 text-sm text-gray-700 font-semibold "> logout </span>
				</button>
			</div>
		</div>
	</div>
{/if}
