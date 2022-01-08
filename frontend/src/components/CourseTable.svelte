<script>
	export let coursesPerPage = 20;
	export let courses;
	export let fetchMore;
	export let totalPages;
	export let totalPagesLoaded;

	let currentPage = 1;
</script>

<div class="border">
	<table class="border w-full divide-y divide-gray-200 table-auto text-xs md:text-sm">
		<thead class="bg-gray-50">
			<tr>
				<th class="py-2 px-2 text-left  font-medium text-gray-500 uppercase tracking-wider">
					name
				</th>
				<th
					class="hidden md:table-cell py-2 text-left  font-medium text-gray-500 uppercase tracking-wider"
				>
					teacher
				</th>

				<th
					class="hidden md:table-cell  text-left  font-medium text-gray-500 uppercase tracking-wider"
				>
					students
				</th>

				<th
					class="hidden md:table-cell  text-left  font-medium text-gray-500 uppercase tracking-wider"
				>
					address
				</th>
			</tr>
		</thead>
		<tbody class="bg-white divide-y divide-gray-200  ">
			{#each courses.filter((_, idx) => idx >= (currentPage - 1) * coursesPerPage && idx < currentPage * coursesPerPage) as course}
				<tr class="even:bg-gray-100 hover:bg-gray-100 border">
					<td class="whitespace-nowrap px-2 py-1 md:py-2">
						<div class="flex items-center">
							<div class="flex-shrink-0 h-6 w-6">
								<div class="flex h-6 w-6 bg-{course.color}-500  mr-4 rounded-md">
									<i class="mx-auto my-auto bi {course.icon}" />
								</div>
							</div>
							<div class="ml-4">
								<div class=" hover:underline font-medium text-gray-900">
									<a href="/courses/{course.abbreviation}">{course.name} </a>
								</div>
							</div>
						</div>
					</td>
					<td class=" hidden md:table-cell whitespace-nowrap">
						<div class="text-sm text-gray-900">
							<a class="hover:underline" href="/user/{course.teacher.username}"
								>{course.teacher.fullname}</a
							>
						</div>
					</td>
					<td class="hidden md:table-cell whitespace-nowrap">
						<div class="text-sm text-gray-900">
							{course.enrolledStudents} / {course.maxStudents}
						</div>
					</td>
					<td class="hidden md:table-cell">
						<div class="text-sm text-gray-900">{course.address}</div>
					</td>
				</tr>
			{/each}
		</tbody>
	</table>
	<div class="flex justify-end">
		<div class=" p-1 text-sm flex items-center">
			<button
				disabled={currentPage == 1}
				on:click={() => {
					--currentPage;
				}}
				class=" rounded-full px-2 py-1 hover:bg-gray-200 hover:text-black disabled:text-gray-500"
				><i class="bi bi-chevron-left" /></button
			>
			<div class=" p-2 border rounded">{currentPage}/{totalPages}</div>
			<button
				disabled={currentPage == totalPages}
				on:click={() => {
					currentPage++;
					if (currentPage > totalPagesLoaded && currentPage <= totalPages) {
						totalPagesLoaded++;
						fetchMore();
					}
				}}
				class=" rounded-full px-2 py-1 hover:bg-gray-200 hover:text-black disabled:text-gray-500"
				><i class="bi bi-chevron-right" /></button
			>
		</div>
	</div>
</div>
