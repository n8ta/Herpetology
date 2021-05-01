export const jsonFetch = (method, url, cb, body={}) => {
    let auth_token = document.querySelector("meta[name='csrf-token']").content;
    if (Object.keys(body).length !== 0) {
        console.info(body)
        fetch(url, {
            method,
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
                'X-CSRF-Token': auth_token,
                'X-Requested-With': 'XMLHttpRequest',
            },
            body: JSON.stringify(body),
            credentials: 'same-origin',
        }).then(res => res.json()).then((result) => {
            cb(result)
        })
    } else {
        fetch(url, {
            method,
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
                'X-CSRF-Token': auth_token,
                'X-Requested-With': 'XMLHttpRequest',
            },
            credentials: 'same-origin',
        }).then(res => res.json()).then((result) => {
            cb(result)
        })
    }
}