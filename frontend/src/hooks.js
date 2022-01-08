import { parse } from 'cookie';
import { variables } from '$src/variables';
// server side
export async function handle({ request, resolve }) {
    const url = variables.apiUrl + 'users/getProfile';
    const cookies = parse(request.headers.cookie || '');
    if (cookies.sessionToken) {
        const session = await fetch(url, {
            headers: {
                cookie: `sessionToken=${cookies.sessionToken}`
            }
        });
        if (session) {
            const response = await session.json();
            request.locals = response.msg.profile;
        }
    }
    return resolve(request);
}
// client side
export function getSession(request) {
    return request?.locals ? { profile: request.locals } : {};
}