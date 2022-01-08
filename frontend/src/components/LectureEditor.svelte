<script>
	import { successMessage, errorMessage } from '$src/stores';
	import { apiAddLecture, apiUpdateLecture, apiDeleteLecture } from '$src/api';

	export let course;
	$: lectures = course?.lectures?.reverse() || [];

	let date = '';
	let start = '';
	let end = '';
	let summary = '';

	$: idx = lectures?.length ? lectures[0].index + 1 : 1;

	$: hasSummary = summary?.length>0 && summary.length <= 1024;
	$: isInputMissing = !end || !start || !date;
	let dateTimeAreValid = false;
	$: {
		const now = new Date();
		dateTimeAreValid =
			new Date(date) >= new Date(now.toLocaleDateString()) &&
			now.getTime() <= new Date(`${date} ${start}`).getTime() &&
			new Date(`${date} ${end}`) > new Date(`${date} ${start}`);
	}

	$: newLectureIsValid = hasSummary && !isInputMissing && dateTimeAreValid;

	function addLecture() {
		if (!course) {
			$errorMessage = 'no course selected';
			return;
		}

		let body = JSON.stringify({
			courseAbbreviation: course.abbreviation,
			summary,
			date,
			start: start + ':00',
			end: end + ':00'
		});

		let responseStatus;
		apiAddLecture(body)
			.then((response) => {
				responseStatus = response.status;
				return response.json();
			})
			.then((response) => {
				if (responseStatus != 200) {
					$errorMessage = response.msg;
					return;
				}
				summary = '';
				start = '';
				end = '';
				date = '';
				$successMessage = response.msg;
				lectures = [response.lecture, ...lectures];
			});
	}

	function updateLecture(lecture) {
		if (!course) {
			$errorMessage = 'no course selected';
			return;
		}

		let body = JSON.stringify(
			{
				summary: lecture.summary
			},
			null,
			2
		);
		let responseStatus;
		apiUpdateLecture(lecture.id, body)
			.then((response) => {
				responseStatus = response.status;
				return response.json();
			})
			.then((response) => {
				if (responseStatus == 200) {
					$successMessage = response.msg;
					return;
				}
				$errorMessage = response.msg;
			});
	}

	function deleteLecture(lecture) {
		if (!course) {
			$errorMessage = 'no course selected';
			return;
		}

		let responseStatus;
		apiDeleteLecture(lecture.id)
			.then((response) => {
				responseStatus = response.status;
				return response.json();
			})
			.then((response) => {
				if (responseStatus == 200) {
					$successMessage = response.msg;
					lectures = lectures.filter((current) => current.id != lecture.id);
					return;
				}
				$errorMessage = response.msg;
			});
	}
</script>

{#if course}
	<table class="w-full divide-y divide-gray-200 table-auto">
		<thead class="bg-gray-50">
			<tr>
				<th scope="col" class="py-2 text-center font-medium text-gray-500 uppercase tracking-wider">
					index
				</th>
				<th scope="col" class="text-center font-medium text-gray-500 uppercase tracking-wider">
					start/end
				</th>
				<th scope="col" class="text-center font-medium text-gray-500 uppercase tracking-wider">
					summary
				</th>
				<th scope="col" class="text-center font-medium text-gray-500 uppercase tracking-wider" />
			</tr>
		</thead>
		<tbody class="bg-white divide-y divide-gray-200 ">
			{#if lectures && lectures.length < 20}
				<tr class="even:bg-gray-100">
					<td class="table-cell text-center">
						<span class="text-sm font-medium">{idx}</span>
					</td>
					<td class="">
						<div class="text-sm flex flex-col items-center justify-center gap-2">
							<form>
								<input
									class=" border rounded p-1 {idx % 2 == 0 ? 'bg-white' : 'bg-gray-100'} "
									class:input-not-valid={(end || start || date) && !dateTimeAreValid}
									type="date"
									required
									bind:value={date}
								/>
								<input
									class=" border rounded p-1 {idx % 2 == 0 ? 'bg-white' : 'bg-gray-100'} "
									type="time"
									class:input-not-valid={(end || start || date) && !dateTimeAreValid}
									required
									bind:value={start}
								/>
								<input
									class=" border rounded p-1 {idx % 2 == 0 ? 'bg-white' : 'bg-gray-100'} "
									type="time"
									class:input-not-valid={(end || start || date) && !dateTimeAreValid}
									required
									bind:value={end}
								/>
							</form>
							{#if (end || start || date) && !dateTimeAreValid}
								<p class="text-red-500 text-xs">datetime combination not valid</p>
							{/if}
						</div>
					</td>
					<td class="table-cell">
						<textarea
							maxlength="1024"
							rows="3"
							required
							class="align-middle rounded border p-1 my-2 w-full text-grey-darker
                                        {idx % 2 == 0 ? 'bg-white' : 'bg-gray-100'}"
							class:input-not-valid={summary?.length>0 && !hasSummary}
							
							bind:value={summary}
							placeholder="insert a short summary"
						/>
					</td>
					<td class="table-cell text-center">
						<button
							class="mx-auto rounded h-6 w-6 flex justify-center items-center bg-{course.color}-500 hover:bg-{course.color}-600 text-white disabled:opacity-50"
							disabled={!newLectureIsValid}
							on:click={addLecture}
						>
							<i class="bi bi-plus-lg" />
						</button>
					</td>
				</tr>
			{/if}
			{#if lectures?.length}
				{#each lectures as lecture, index}
					<tr class="even:bg-gray-100">
						<td class="table-cell text-center">
							<span class="text-sm font-medium">{lecture.index}</span>
						</td>
						<td class="">
							<div class="text-sm flex justify-center gap-2">
								<form>
									<input
										class=" border rounded p-1 {index % 2 == 0 ? 'bg-white' : 'bg-gray-100'} "
										type="date"
										disabled
										readonly
										value={lecture.date}
									/>
									<input
										class=" border rounded p-1 {index % 2 == 0 ? 'bg-white' : 'bg-gray-100'} "
										type="time"
										disabled
										readonly
										value={lecture.start}
									/>
									<input
										class=" border rounded p-1 {index % 2 == 0 ? 'bg-white' : 'bg-gray-100'} "
										type="time"
										disabled
										readonly
										value={lecture.end}
									/>
								</form>
							</div>
						</td>
						<td class="table-cell">
							<textarea
								maxlength="1024"
								rows="3"
								class="align-middle rounded border p-1 my-2 w-full text-grey-darker
                                            {index % 2 == 0 ? 'bg-white' : 'bg-gray-100'}"
								bind:value={lecture.summary}
								placeholder="insert a short summary"
							/>
						</td>
						<td class="table-cell text-center">
							<div class="flex flex-col gap-2">
								<button
									class="mx-auto rounded h-6 w-6 flex justify-center items-center bg-{course.color}-500 hover:bg-{course.color}-600 text-white disabled:opacity-50"
									disabled={!lecture.summary || lecture.summary.length > 1024}
									on:click={() => updateLecture(lecture)}
								>
									<i class="bi bi-cloud-arrow-up-fill" />
								</button>
								<button
									class="mx-auto rounded h-6 w-6 flex justify-center items-center bg-red-500 hover:bg-red-600 text-white"
								>
									<i on:click={() => deleteLecture(lecture)} class="bi bi-trash-fill" />
								</button>
							</div>
						</td>
					</tr>
				{/each}
			{/if}
		</tbody>
	</table>
{/if}
