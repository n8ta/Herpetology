import React from "react"
import PropTypes from "prop-types"
import Zoom from "./Zoom";
import Progressbar from "./Progressbar";

class Learn2 extends React.Component {

    constructor(props) {
        super(props);


        this.state = {
            mode: "loading",
            taxons: this.props.taxons,
            startup: {'loaded': 0},
        };
        let auth_token = document.querySelector("meta[name='csrf-token']").content;

        for (let i = 0; i < this.props.taxons.length; i++) {
            let stored_txn = window.localStorage.getItem(this.props.region_id + '-' + this.props.taxons[i].id);
            if (stored_txn != undefined) {
                stored_txn = JSON.parse(stored_txn);
                this.state.taxons[i].score = stored_txn.score;
                this.state.taxons[i].seen = stored_txn.seen;
                this.state.taxons[i].correct = stored_txn.correct;
            } else {
                this.state.taxons[i].seen = 0;
                this.state.taxons[i].correct = 0;
                this.state.taxons[i].score = 0.0;
                this.state.taxons[i].photos = [];

            }

            fetch("/taxons/" + this.props.taxons[i].id + "/photos/plenty", {
                method: 'GET',
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json',
                    'X-CSRF-Token': auth_token,
                    'X-Requested-With': 'XMLHttpRequest',
                },
                credentials: 'same-origin',
            }).then(res => res.json()).then((result) => {
                // Setup photos
                for (let j = 0; j < result.length; j++) {
                    this.state.taxons[i].photos.push(result[j]);
                    this.state.startup['loaded'] += 1;
                }
            });

        }
        this.render = this.render.bind(this);
    }

    render() {
        return (
            <div className="center">
                <h3>Loading</h3>
                <Progressbar msg={this.state.startup['loaded']+"/"+this.state.taxons.length}
                             width={100 * this.state.taxons.length / this.props.taxons.length }
                             wide={true}></Progressbar>
            </div>
        )
    }
}

Learn2.propTypes = {
    taxons: PropTypes.array,
    working_size: PropTypes.number,
    factor: PropTypes.number,
    region_name: PropTypes.string,
    region_id: PropTypes.number,
    root_taxon_name: PropTypes.string,
    mastery_cutoff_score: PropTypes.number,
};


export default Learn2
