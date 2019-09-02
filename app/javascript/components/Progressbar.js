import React from "react"
import PropTypes from "prop-types"

import Tippy from '@tippy.js/react'

class Progressbar extends React.Component {

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
            <p>Score: {this.props.score}</p>
            <p>{this.props.correct} / {this.props.seen}</p>
        </div>;
        return (
            <Tippy content={content} placement={'bottom'}>
            <div className={"progress-bar"}>
                <div className={'progress-bar-inner'} style={{width: this.props.score*100+"%"}}> </div>
                <div className={'progress-bar-text'}>{msg}</div>
            </div>
            </Tippy>
        );
    }
}


Progressbar.propTypes = {
    common_name: PropTypes.string,
    sci_name: PropTypes.string,
    score: PropTypes.number,
};


export default Progressbar


