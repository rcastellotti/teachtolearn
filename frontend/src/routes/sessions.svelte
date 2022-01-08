<script context="module">
	import { debug, successMessage, errorMessage, showModal } from '$src/stores';
	import { session } from '$app/stores';
	import { goto } from '$app/navigation';
	import { apiGetSessions, apiDeleteSession, apiGetProfile, apiLogout } from '$src/api';
	import Modal from '$components/Modal.svelte';
	export const ssr = false;

	export async function load({ session }) {
		let isUserLoggedIn = Object.keys(session?.profile).length !== 0;
		if (!isUserLoggedIn) {
			return {
				status: 302,
				redirect: '/signin?next=/sessions'
			};
		}
		return {
			props: {}
		};
	}
</script>

<script>
	let sessions = [];
	let modalFunction;

	apiGetProfile()
		.then((response) => response.json())
		.then((response) => ($session.profile = response.msg.profile));

	apiGetSessions().then((response) => {
		sessions = response['msg']['sessions'];
		$debug = JSON.stringify(sessions, null, 2);
		$debug += '\n';
		$debug += JSON.stringify($session.profile, null, 2);
	});

	function deleteSession(id, i) {
		if (id == $session.profile.id) {
			apiLogout();
			$session.profile = {};
			goto('/');
		} else {
			apiDeleteSession(id).then((response) => {
				if (response.ok) {
					sessions.splice(i, 1);
					sessions = sessions;
					$successMessage = 'successfully removed session';
				}
				$errorMessage = 'could not remove session';
			});
		}
	}

	let map = {
		Windows: 'windows',
		Iphone: 'apple',
		'Mac OS X': 'apple',
		Android: 'phone-fill',
		Other: 'pc-display',
		Linux: 'pc-display',
		iOS: 'apple'
	};
</script>

<svelte:head>
	<title>TTL - Sessions</title>
</svelte:head>

<div class="h-full flex flex-col justify-center">
	<div
		class="pb-5 px-5  bg-gray-100 mx-auto md:w-5/12 text-sm shadow overflow-hidden border-b border-gray-200 rounded"
	>
		<h1 class="text-2xl  font-bold p-2">sessions</h1>
		<table class="border min-w-full divide-y divide-gray-200 table-auto">
			<thead class="bg-gray-50">
				<tr>
					<th class="py-2 pl-2 text-left font-medium text-gray-500 uppercase tracking-wider">
						session
					</th>
					<th class="py-2 text-left font-medium text-gray-500 uppercase tracking-wider">
						ip address
					</th>
					<th class="text-left  font-medium text-gray-500 uppercase tracking-wider">
						last login time
					</th>
					<th class="text-left  font-medium text-gray-500 uppercase tracking-wider" />
				</tr>
			</thead>
			<tbody class="bg-white divide-y divide-gray-200 ">
				{#each sessions as sess, i}
					<tr class="even:bg-gray-100 ">
						<td class="py-2 pl-2 w-1/3">
							<div class="flex items-center">
								<div class="flex-shrink-0 h-6 w-6">
									<i class="h-6 w-6 rounded-full bi bi-{map[sess.platform]}">
										{#if sess.id == $session.profile.id}
											<div
												class=" w-2 h-2 animate-ping inline-flex rounded-full bg-black opacity-75"
											/>
										{/if}
									</i>
								</div>
								<div class="text-sm font-medium text-gray-900">{sess.platform}</div>
							</div>
						</td>
						<td class="w-1/3">
							<div class="text-sm  text-gray-900">{sess.ip}</div>
						</td>
						<td>{sess.lastLoginTime}</td>
						<td class="table-cell text-center">
							<button
								class="mx-auto rounded h-6 w-6 flex justify-center items-center bg-red-500 hover:bg-red-600 text-white"
							>
								<i
									on:click={() => {
										$showModal = true;
										modalFunction = () => deleteSession(sess.id, i);
									}}
									class="bi bi-x-lg"
								/>
							</button>
						</td>
					</tr>
				{/each}
			</tbody>
		</table>
	</div>
</div>

<Modal
	body="do you really want to remove this session?"
	title="remove session"
	func={modalFunction}
	color={'red'}
	button={'remove'}
/>
