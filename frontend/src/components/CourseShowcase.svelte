<script>
	import { variables } from '$src/variables';

	export let course;

	function generateGeoJSONString(latitude, longitude) {
		const json = JSON.stringify({
			type: 'FeatureCollection',
			features: [
				{
					type: 'Feature',
					properties: {},
					geometry: {
						type: 'Point',
						coordinates: [longitude, latitude]
					}
				}
			]
		});
		return `geojson(${encodeURIComponent(json)})`;
	}
</script>

<div class="box-border group rounded flex hover:shadow-lg min-h-[14rem]">
	<div
		class="border-gray-400 group-hover:border-black border-l border-t border-b 
				         p-0 object-left w-3/12 h-auto bg-{course.color}-500 flex rounded-l"
	>
		<i class="bi {course.icon} text-7xl mx-auto my-auto " />
	</div>
	<div
		class="w-9/12   flex flex-col justify-between 
				border-gray-400 group-hover:border-black border-t border-b border-r rounded-r md:rounded-none"
		class:md:border-r-0={course.address}
	>
		<div class=" text-sm h-full flex flex-col justify-between">
			<div class="p-2">
				<h1 class="font-semibold  ">{course.abbreviation} - {course.name}</h1>
				<p class="text-gray-600">
					{course.syllabus}
				</p>
			</div>

			<span class="p-2 flex justify-between items-end">
				<div>
					{#if course.address}
						<div>
							<i class="bi bi-geo-alt-fill" />
							{course.address}
						</div>
					{/if}
					{#if course.beginDate}
						<div>
							<i class="bi bi-calendar-event-fill" />
							{course.beginDate}
						</div>
					{/if}
					<i class="bi bi-person-fill" />
					{course.enrolledStudents}/{course.maxStudents}
				</div>
			</span>
		</div>

		<div class="flex flex-col box-border">
			<div class="flex justify-between border-gray-400 border-t-2 box-border px-2">
				<a
					href={`/user/${course.teacher.username}`}
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
	{#if course.address}
		<div
			class="hidden md:flex rounded-r
				border-gray-400  group-hover:border-black border-r border-t border-b"
		>
			<a
				href={`https://www.openstreetmap.org/?mlat=${course.latitude}&mlon=${course.longitude}#map=14/${course.latitude}/${course.longitude}`}
				target="_blank"
				rel="noopener noreferrer"
			>
				<img
					class="rounded-r"
					src={`https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/${generateGeoJSONString(
						course.latitude,
						course.longitude
					)}/${course.longitude},${course.latitude},15,0,0/300x300?access_token=${
						variables.mapboxToken
					}`}
					alt="course location on map"
				/>
			</a>
		</div>
	{/if}
</div>
