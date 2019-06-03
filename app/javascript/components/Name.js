import React from "react"
import PropTypes from "prop-types"

class Name extends React.Component {
    render() { return (
            <React.Fragment>
                <span className="common_name">{this.props.commonName} </span>
                (<span className="sci_name">{this.props.sciName}</span>)
            </React.Fragment>
        );
    }
}
Name.propTypes = {
    sciName: PropTypes.string,
    commonName: PropTypes.string
};
export default Name
