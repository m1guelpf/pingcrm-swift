import { Head } from '@inertiajs/react';

const IndexPage = ({ title }: { title: string }) => {
	return (
		<>
			<Head title={title} />
			<h1>{title}</h1>
		</>
	);
};

export default IndexPage;
