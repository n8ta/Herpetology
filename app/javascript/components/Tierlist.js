import React from "react"
import PropTypes from "prop-types"

class Tierlist extends React.Component {
    constructor(props) {
        super(props);
        this.state = {'mode': 'loading'};
        this.load = this.load.bind(this);
        this.failed = this.failed.bind(this);
        this.load();
    }


    load() {
        let auth_token = document.querySelector("meta[name='csrf-token']").content;
        fetch( '/tier1s/' + this.props.id+'.json', {
            method: 'GET',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
                'X-CSRF-Token': auth_token,
                'X-Requested-With': 'XMLHttpRequest',
            },
            credentials: 'same-origin',
        }).then(res => res.json()).then((result) => {
            this.setState({
                mode: 'ready',
                tier2s: result['tier2s']
            });

        }).catch(this.failed);
    }

    failed() {
        this.setState({'mode': 'failed'})
    }

    render() {


        if (this.state.mode == "loading") {
            return (
                <h3>Loading subregions...</h3>
            )
        } else if (this.state.mode == "failed") {
            return (
                <h3>Failed to load subregions, try reloading?</h3>
            );
        } else {
            console.log('ready');
            console.log(this.state)
            let subregions = [];
            for (let i = 0; i < this.state.tier2s.length; i ++) {
                let t2 = this.state.tier2s[i];
                subregions.push(
                    <li key={t2['id']}><a href={t2['quiz_url']}>{t2['name']}</a></li>
                )
            }
            return (
                <ul className='tier-list'>
                    {subregions}
                </ul>
            )
        }
    }
}

Tierlist.propTypes = {
    id: PropTypes.number
};
export default Tierlist
