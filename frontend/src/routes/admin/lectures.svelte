<script context="module">
	import { successMessage, errorMessage, debug, showModal } from '$src/stores';
	import { apiAdminGetLectures, apiBanLecture, apiunBanLecture } from '$src/api';
	import Modal from '$components/Modal.svelte';

	export async function load() {
		const lectures = await apiAdminGetLectures(1);
		return {
			props: {
				lectures: await lectures
			}
		};
	}
</script>

<script>
	function banLecture(id, i) {
		apiBanLecture(id).then((response) => {
			if (response.ok) {
				$successMessage = 'successfully banned lecture';
				lectures[i].isBanned = true;
				return;
			}
			$errorMessage = 'could not ban lecture';
		});
	}
	function unbanLecture(id, i) {
		apiunBanLecture(id).then((response) => {
			if (response.ok) {
				$successMessage = 'successfully unbanned lecture';
				lectures[i].isBanned = false;
				return;
			}
			$errorMessage = 'could not unban lecture';
		});
	}
	export let lectures;
	let pages = lectures.msg.pages;
	lectures = lectures.msg.lectures;
	$debug = JSON.stringify(lectures, null, 2);
	let page = 1;

	async function fetchDataTable(page) {
		apiAdminGetLectures(page).then((response) => {
			lectures = response.msg.lectures;
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
							course
						</th>

						<th
							class="hidden md:table-cell  text-left  font-medium text-gray-500 uppercase tracking-wider"
						>
							teacher
						</th>
						<th
							class="hidden md:table-cell  text-left  font-medium text-gray-500 uppercase tracking-wider"
						>
							date
						</th>
						<th
							class="hidden lg:table-cell  text-left  font-medium text-gray-500 uppercase tracking-wider"
						>
							start
						</th>
						<th
							class="hidden lg:table-cell  text-left  font-medium text-gray-500 uppercase tracking-wider"
						>
							end
						</th>
						<th class="text-left  font-medium text-gray-500 uppercase tracking-wider" />
					</tr>
				</thead>
				<tbody class="bg-white divide-y divide-gray-200  ">
					{#if lectures?.length}
						{#each lectures as lecture, i}
							<tr class="even:bg-gray-100 hover:bg-gray-100 border">
								<td class="whitespace-nowrap px-2 py-1 md:py-2">
									<div class="flex items-center">
										<div class="flex-shrink-0 h-6 w-6">
											<div class="flex h-6 w-6 bg-{lecture.courseColor}-500  mr-4 rounded-md">
												<i class="mx-auto my-auto bi {lecture.courseIcon}" />
											</div>
										</div>
										<div class="ml-4">
											<div class="hover:underline text-xs font-medium text-gray-900">
												<a href={`/courses/${lecture.courseAbbreviation}`}
													>{lecture.courseName} - L{lecture.index}</a
												>
											</div>
										</div>
									</div>
								</td>
								<td class="hidden md:table-cell">
									<div class="text-sm text-gray-900 hover:underline">
										<a href={`/user/${lecture.teacher.username}`}>{lecture.teacher.username}</a>
										</div>
								</td>
								<td class="hidden md:table-cell">
									<div class="text-sm text-gray-900">{lecture.date}</div>
								</td>
								<td class="hidden lg:table-cell">
									<div class="text-sm text-gray-900">{lecture.start.slice(0, 5)}</div>
								</td>
								<td class="hidden lg:table-cell">
									<div class="text-sm text-gray-900">{lecture.end.slice(0, 5)}</div>
								</td>
								<td class="whitespace-nowrap">
									<div class="text-sm text-gray-900 text-center">
										{#if lecture.isBanned}
											<button
												on:click={() => {
													$showModal = true;
													modalBody = 'do you really want to unban this lecture?';
													modalTitle = 'unban lecture';
													modalColor = 'green';
													modalButton = 'unban';
													modalFunction = () => unbanLecture(lecture.id, i);
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
													modalBody = 'do you really want to ban this lecture?';
													modalTitle = 'ban lecture';
													modalColor = 'red';
													modalButton = 'ban';
													modalFunction = () => banLecture(lecture.id, i);
												}}
												type="button"
												class="rounded  bg-red-500 text-white h-6 w-6 hover:bg-red-600"
											>
												<i class="bi bi-x-lg" />
											</button>
										{/if}
									</div>
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
						class=" rounded-full p-2 hover:bg-gray-200 hover:text-black disabled:text-gray-500"
						><i class="bi bi-chevron-left" /></button
					>
					<div class=" p-2 border rounded">{page}/{pages}</div>
					<button
						disabled={page == pages}
						on:click={() => {
							++page;
							fetchDataTable(page);
						}}
						class=" rounded-full p-2 hover:bg-gray-200 hover:text-black disabled:text-gray-500"
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
