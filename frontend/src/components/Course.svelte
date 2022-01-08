<script>
	export let course;
	export let url;
	export let button;
</script>

<div
	class="text-sm box-border rounded flex transition duration-500 ease-in-out transform hover:shadow-lg border-gray-400 hover:border-black border"
>
	<div class="object-left w-3/12 h-auto bg-{course.color}-500 flex rounded-l">
		<i class="bi {course.icon} text-7xl mx-auto my-auto " />
	</div>
	<div class="px-4 py-2 w-9/12 h-full bg-gray-100 rounded-r flex flex-col justify-between">
		<div>
			<div class="flex whitespace-nowrap">
				<h1 class=" overflow-auto font-semibold text-sm md:text-2xl">
					{course.abbreviation} - {course.name}
				</h1>
			</div>

			<div class="text-gray-600 py-1">
				{course.syllabus}
			</div>
			<div class="flex flex-col space-y-1">
				{#if course.address}
					<div class="flex whitespace-nowrap">
						<i class="bi bi-geo-alt-fill" />
						<div class="overflow-auto">{course.address}</div>
					</div>
				{/if}
				<div class="box-border flex justify-between items-center">
					<div class="flex flex-col">
						{#if course.beginDate}
							<span>
								<i class="bi bi-calendar-event-fill" />
								{course.beginDate}
							</span>
						{/if}
						<span>
							<i class="bi bi-person-fill" />
							{course.enrolledStudents}/{course.maxStudents}</span
						>
					</div>

					<button
						class="rounded disabled:opacity-50 bg-{course.color}-500 opacity-80 hover:opacity-100 text-white pl-3 pr-1 py-1 mb-1"
					>
						<a href={url}>{button}<i class="bi bi-chevron-right" /> </a>
					</button>
				</div>
			</div>
		</div>
		<div class="flex flex-col box-border">
			<div class="flex justify-between  py-1 border-gray-400 border-t-2 box-border ">
				<a
					href="/user/{course.teacher.username}"
					class=" text-gray-800 font-semibold hover:underline">@{course.teacher.username}</a
				>
				{#if course.reviewAvg}
					<span>
						<i class="bi bi-star-fill" />
						<span>{course.reviewAvg}/10 </span>
					</span>
				{/if}
			</div>
		</div>
	</div>
</div>
