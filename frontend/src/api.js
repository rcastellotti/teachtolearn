// idea from https://leonardini.dev
// some functions are in the routes because we need to update local variables

import { variables } from '$src/variables';

function api(endpoint, method = 'GET', body) {
    const url = variables.apiUrl + endpoint;
    const headers = {
        Accept: 'application/json',
        'Content-Type': 'application/json'
    };

    return fetch(url, {
        method,
        headers,
        credentials: 'include',
        body: body ? body : null
    });
}

export function ping() {
    return api('ping');
}

export function apiLogout() {
    api('users/signOut', 'DELETE');
}

export function apiSearchRealtime(searchTerm) {
    const url = `search/realtime?q=${searchTerm}`;
    return api(url, 'GET');
}

export function apiGetProfile() {
    return api('users/getProfile');
}

export function apiUpdateProfile(body) {
    return api('users/updateProfile', 'PUT', body);
}

export function apiSignIn(body) {
    return api('users/signIn', 'POST', body);
}

export function apiSignUp(body) {
    return api('users/signUp', 'POST', body);
}

export function apiCreateCourse(body) {
    return api('courses/addCourse', 'POST', body);
}

export function apiDeleteUser(body) {
    return api('users/deleteUser', 'DELETE', body);
}

export function apiGetPasswordResetToken(body) {
    return api('users/getPasswordResetToken', 'POST', body);
}

export function apiGetCourse(courseAbbreviation) {
    return api(`courses/${courseAbbreviation}`, 'GET').then((response) => response.json());
}

export function apiGetCourses(page) {
    return api(`courses/getCourses?page=${page}`, 'GET').then((response) => response.json());
}

export function apiUpdateCourse(courseAbbreviation, body) {
    return api(`courses/${courseAbbreviation}`, 'PUT', body);
}

export function apiDeleteCourse(courseAbbreviation) {
    return api(`courses/${courseAbbreviation}`, 'DELETE');
}

export function apiGetPresignedUrl(filename) {
    return api('users/getPresignedUrl/' + filename, 'GET');
}

export function apiAddLecture(lecture) {
    return api('lectures/addLecture', 'POST', lecture);
}

export function apiUpdateLecture(id, lecture) {
    return api(`lectures/${id}`, 'PUT', lecture);
}

export function apiDeleteteLecture(lectureId) {
    return api(`lectures/${lectureId}`, 'DELETE');
}

export function apiPasswordReset(token, body) {
    return api(`users/passwordReset/${token}`, 'POST', body);
}

export function apiGetSessions() {
    return api('users/getSessions', 'GET').then((response) => response.json());
}

export function apiDeleteSession(id) {
    return api(`users/session/${id}`, 'DELETE');
}

export function apiGetUserReservations(page) {
    return api(`reservations?page=${page}`, 'GET').then((response) => response.json());
}

export function apiGetReservationState(abbreviation) {
    return api(`reservations/${abbreviation}/state`, 'GET').then((response) => response.json());
}

export function apiGetReservations(abbreviation) {
    return api(`reservations/${abbreviation}`, 'GET').then((response) => response.json());
}

export function apiDeleteReservation(id) {
    return api(`reservations/${id}`, 'DELETE');
}

export function apiDeleteLecture(id) {
    return api(`lectures/${id}`, 'DELETE');
}

export function apiBanCourse(id) {
    return api(`admin/course/${id}`, 'DELETE');
}

export function apiunBanCourse(id) {
    return api(`admin/course/${id}`, 'PUT');
}

export function apiAdminGetCourses(page) {
    return api(`admin/getCourses?page=${page}`, 'GET').then((response) => response.json());
}

export function apiAdminGetUsers(page) {
    return api(`admin/getUsers?page=${page}`, 'GET').then((response) => response.json());
}

export function apiBanLecture(id) {
    return api(`admin/lecture/${id}`, 'DELETE');
}

export function apiunBanLecture(id) {
    return api(`admin/lecture/${id}`, 'PUT');
}

export function apiAdminGetLectures(page) {
    return api(`admin/getLectures?page=${page}`, 'GET').then((response) => response.json());
}

export function apiBanReview(id) {
    return api(`admin/review/${id}`, 'DELETE');
}

export function apiunBanReview(id) {
    return api(`admin/review/${id}`, 'PUT');
}

export function apiAdminGetReviews(page) {
    return api(`admin/getReviews?page=${page}`, 'GET').then((response) => response.json());
}

export function apiBanUser(id) {
    return api(`admin/user/${id}`, 'DELETE');
}

export function apiunBanUser(id) {
    return api(`admin/user/${id}`, 'PUT');
}

export function apiGetUserCourses(username, page) {
    return api(`courses/user/${username}?page=${page}`, 'GET').then((response) => response.json());
}

export function apiGetPublicProfile(username) {
    return api(`users/getPublicProfile/${username}`, 'GET').then((response) => response.json());
}

export function apiSearch(query) {
    return api(`search?q=${query}`, 'GET').then((response) => response.json());
}

export function apiGetReviews(abbreviation) {
    return api(`reviews/${abbreviation}`, 'GET').then((response) => response.json());
}

export function apiAddReview(abbreviation, body) {
    return api(`reviews/addReview/${abbreviation}`, 'POST', body);
}

export function apiDeleteReview(id) {
    return api(`reviews/${id}`, 'DELETE');
}

export function apiAddReservation(abbreviation) {
    return api(`reservations/${abbreviation}`, 'POST');
}

export function apiActivate(token) {
    return api(`users/activate/${token}`, 'GET');
}