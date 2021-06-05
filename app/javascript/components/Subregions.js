import React from "react"
import PropTypes from "prop-types"
import {jsonFetch} from "./fetch";

class Subregions extends React.Component {
    constructor(props) {
        super(props);
        this.state = {'mode': 'loading'};
        this.load = this.load.bind(this);
        this.failed = this.failed.bind(this);
        this.load();
    }


    load() {
        let url = "";
        if (this.props.id) {
            url = '/taxons/' + this.props.taxon_id + '/regions/' + this.props.id+'.json'
        } else {
            url = '/taxons/' + this.props.taxon_id + '.json'
        }
        jsonFetch('GET', url, (result) => {
            if (this.props.id) {
                this.setState({
                    mode: 'ready',
                    tier2s: result['subregions']
                });
            } else {
                this.setState({
                    mode: 'ready',
                    tier2s: result.countries,
                });
            }
        })
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
            let subregions = [];
            let key = "";
            for (let i = 0; i < this.state.tier2s.length; i ++) {
                let t2 = this.state.tier2s[i];

                subregions.push(
                    <tr key={t2['id']}>
                        <td><a href={t2['game_url']}>{t2['name']}</a></td>
                    </tr>
                )
            }
            return (
                <table id={"tier-list"}>
                    <tbody>
                    {subregions}
                    </tbody>
                </table>
            )
        }
    }
}

Subregions.propTypes = {
    id: PropTypes.number,
    taxon_id: PropTypes.number
};
export default Subregions
