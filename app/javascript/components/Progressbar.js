import React from "react"
import PropTypes from "prop-types"

class Progressbar extends React.Component {

    render() {
        let wide = "";
        if (this.props.wide == true) {
            wide = "wide";
        }

        return (
            <div className={"progress-bar "+wide}>
                <div className={'progress-bar-inner'} style={{width: this.props.width + "%"}}></div>
                <div className={'progress-bar-text'}>{this.props.msg}</div>
            </div>
        );
    }
}


export default Progressbar


Progressbar.propTypes = {
    width: PropTypes.number,
    msg: PropTypes.string,
    wide: PropTypes.bool,
};

