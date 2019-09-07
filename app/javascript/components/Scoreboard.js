import React from "react"
import PropTypes from "prop-types"

class Scoreboard extends React.Component {

    constructor(props) {
        super(props);
        this.state = {'mode': 'loading'};

        let auth_token = document.querySelector("meta[name='csrf-token']").content;
        fetch( '/quiz/scoreboard.json',{
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
                scores: result // { 'rank' 'name' 'score' }
            });
        }).catch(this.failed);

    }


    render() {
        if (this.state.mode == "ready") {
            let scores = [];
            for (let i = 0; i<this.state.scores.length; i++) {
                let score = this.state.scores[i];
                scores.push( <li key={score['rank']}>{score['rank']} {score['name']} {score['score']}</li> )
            }
            return (
                <div id={'scoreboard'}>
                    <p>Scoreboard</p>
                    <ul>
                        { scores }
                    </ul>
                </div>
            );
        } else if (this.state.mode == "loading") {
            return (
                <div id={'scoreboard'}>
                    <p>Loading Scoreboard...</p>
                </div>)
        } else {
            return (
                <div id={'scoreboard'}>
                    <p>Failed to load scoreboard...</p>
                </div>)
        }

    }
}

Scoreboard.propTypes = {
    id: PropTypes.number
};
export default Scoreboard
