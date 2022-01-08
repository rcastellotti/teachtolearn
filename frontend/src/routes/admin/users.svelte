<script context="module">
	import { successMessage, errorMessage, debug, showModal } from '$src/stores';
	import { apiAdminGetUsers, apiBanUser, apiunBanUser } from '$src/api';
	import { variables } from '$src/variables';
	import Modal from '$components/Modal.svelte';

	export async function load() {
		const users = await apiAdminGetUsers(1);
		return {
			props: {
				users: await users
			}
		};
	}
</script>

<script>
	function banUser(id, i) {
		apiBanUser(id).then((response) => {
			if (response.ok) {
				$successMessage = 'successfully banned user';
				users[i].isBanned = true;
				return;
			}
			$errorMessage = 'could not ban user';
		});
	}
	function unbanUser(id, i) {
		apiunBanUser(id).then((response) => {
			if (response.ok) {
				$successMessage = 'successfully unbanned user';
				users[i].isBanned = false;
				return;
			}
			$errorMessage = 'could not unban user';
		});
	}
	export let users;
	let pages = users.msg.pages;
	users = users.msg.users;
	$debug = JSON.stringify(users, null, 2);
	let page = 1;

	async function fetchDataTable(page) {
		apiAdminGetUsers(page).then((response) => {
			users = response.msg.users;
		});
	}
	let modalColor;
	let modalBody;
	let modalTitle;
	let modalFunction;
	let modalButton;
</script>

<div
	class="absolute  w-11/12 right-1/2 justify-center max-h-[90%] flex  left-1/2 top-1/2 transform -translate-y-1/2 -translate-x-1/2
"
>
	<div class="w-full space-y-2 overflow-scroll">
		<div class="border">
			<table class="border min-w-full divide-y divide-gray-200 table-auto">
				<thead class="bg-gray-50">
					<tr>
						<th class="py-2 px-2 text-left  font-medium text-gray-500 uppercase tracking-wider">
							user
						</th>

						<th
							class=" text-center hidden md:table-cell font-medium text-gray-500 uppercase tracking-wider"
						>
							role
						</th>

						<th class="text-center  font-medium text-gray-500 uppercase tracking-wider">
							ban/unban
						</th>
					</tr>
				</thead>
				<tbody class="bg-white divide-y divide-gray-200  ">
					{#if users?.length}
						{#each users as user, i}
							<tr class="even:bg-gray-100 hover:bg-gray-100 border">
								<td class="p-2 w-1/3 whitespace-nowrap text-center">
									<div class="flex items-center">
										<div class="flex-shrink-0 h-6 w-6">
											<img
												class="h-6 w-6 rounded-full"
												src="{variables.s3Url}{user.username}"
												alt=""
											/>
										</div>
										<div class="ml-2 text-left">
											<div class=" text-sm font-medium text-gray-900">
												<a class="hover:underline" href="/user/{user.username}">{user.fullname}</a>
											</div>
											<div class=" text-gray-500">{user.email}</div>
										</div>
									</div>
								</td>

								<td class="w-1/3 text-center hidden md:table-cell ">
									{#if user.isAdmin}
										<span
											class="px-2 inline-flex   font-semibold rounded-full bg-blue-100 text-blue-800"
										>
											admin
										</span>
									{:else}
										<span
											class="px-2 inline-flex   font-semibold rounded-full bg-teal-100 text-teal-800
											-800"
										>
											user
										</span>
									{/if}
								</td>
								<td class="whitespace-nowrap">
									{#if !user.isAdmin}
										<div class="text-sm text-gray-900 text-center">
											{#if user.isBanned}
												<button
													on:click={() => {
														$showModal = true;
														modalBody = 'do you really want to unban this user?';
														modalTitle = 'unban user';
														modalColor = 'green';
														modalButton = 'unban';
														modalFunction = () => unbanUser(user.id, i);
													}}
													type="button"
													class="rounded  bg-green-500 text-white h-6 w-6 hover:bg-green-600"
												>
													<i class="bi bi-arrow-counterclockwise" />
												</button>
											{:else}
												<button
													on:click={() => {
														$showModal = true;
														modalBody = 'do you really want to ban this user?';
														modalTitle = 'ban user';
														modalColor = 'red';
														modalButton = 'ban';
														modalFunction = () => banUser(user.id, i);
													}}
													type="button"
													class="rounded  bg-red-500 text-white h-6 w-6 hover:bg-red-600"
												>
													<i class="bi bi-x-lg" />
												</button>
											{/if}
										</div>
									{/if}
								</td>
							</tr>
						{/each}
					{/if}
				</tbody>
			</table>
			<div class="flex justify-end">
				<div class=" p-1 text-sm flex items-center">
					<button
						disabled={page == 1}
						on:click={() => {
							--page;
							fetchDataTable(page);
						}}
						class=" rounded-full px-2 py-1 hover:bg-gray-200 hover:text-black disabled:text-gray-500"
						><i class="bi bi-chevron-left" /></button
					>
					<div class=" p-2 border rounded">{page}/{pages}</div>
					<button
						disabled={page == pages}
						on:click={() => {
							++page;
							fetchDataTable(page);
						}}
						class=" rounded-full px-2 py-1 hover:bg-gray-200 hover:text-black disabled:text-gray-500"
						><i class="bi bi-chevron-right" /></button
					>
				</div>
			</div>
		</div>
	</div>
</div>

<Modal
	body={modalBody}
	title={modalTitle}
	func={modalFunction}
	button={modalButton}
	color={modalColor}
/>
