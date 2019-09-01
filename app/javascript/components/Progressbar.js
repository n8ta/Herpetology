import React from "react"
import PropTypes from "prop-types"

import Name from "./Name";

class Progressbar extends React.Component {
    render() {
        let value = 100*this.props.correct/this.props.seen;
        if (this.props.seen == 0) {
            value = 0;
        } else {
        }
        return (
            <div className={"progress-bar"}>
                <span className={'progress-bar-inner'} width={value+"%"}> </span>
                <div className={'progress-bar-text'}>{value.toFixed(0)}%</div>
            </div>
        );
    }
}


Progressbar.propTypes = {
    common_name: PropTypes.string,
    sci_name: PropTypes.string,
    seen: PropTypes.number,
    correct: PropTypes.number,
};


export default Progressbar


