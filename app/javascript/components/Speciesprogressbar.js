import React from "react"
import PropTypes from "prop-types"
import Progressbar from "./Progressbar";
import Tippy from '@tippy.js/react'

class Speciesprogressbar extends React.Component {

    constructor(props) {
        super(props);
    }

    render() {
        let msg = (this.props.score*100).toFixed(0)+"%";
        if (this.props.score >= 1.0 ) {
            msg = "✓✓✓"
        }

        let content = <div>
            <div className='common_name'>{this.props.common_name} </div>
            <div>(<span className='sci_name'>{this.props.sci_name}</span>)</div>
            <p>{this.props.correct} Correct / {this.props.seen} Chances</p>
        </div>;
        return (
            <Tippy content={content} placement={'bottom'}>
                <span>
                <Progressbar width={this.props.score*100} msg={this.props.score*100+"%"}/>
                </span>
            </Tippy>
        );
    }
}


Speciesprogressbar.propTypes = {
    common_name: PropTypes.string,
    sci_name: PropTypes.string,
    score: PropTypes.number,
};


export default Speciesprogressbar


