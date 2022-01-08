<script>
	export let lectures;
</script>

<table class="border min-w-full divide-y divide-gray-200 table-auto">
	<thead class="bg-gray-50">
		<tr>
			<th
				scope="col"
				class="py-3 px-2 text-left font-medium text-gray-500 uppercase tracking-wider"
			>
				index
			</th>

			<th scope="col" class="py-3 text-left font-medium text-gray-500 uppercase tracking-wider">
				date
			</th>

			<th
				scope="col"
				class="hidden md:table-cell py-3 text-left  font-medium text-gray-500 uppercase tracking-wider"
			>
				summary
			</th>
		</tr>
	</thead>
	<tbody class="bg-white divide-y divide-gray-200  ">
		{#each lectures as lecture, i}
			<tr class="even:bg-gray-100 hover:bg-gray-100 border">
				<td class="whitespace-nowrap px-2 md:py-2">
					<div class="flex items-center hover:underline text-sm font-medium text-gray-900">
						{lecture.index}
					</div>
				</td>
				<td class="whitespace-nowrap">
					<div class="text-sm text-gray-900">
						{lecture.date} - {lecture.start.slice(0, 5)}:{lecture.end.slice(0, 5)}
					</div>
				</td>
				<td class="hidden md:table-cell">
					<div class="text-sm text-gray-900">{lecture.summary}</div>
				</td>
			</tr>
		{/each}
	</tbody>
</table>
