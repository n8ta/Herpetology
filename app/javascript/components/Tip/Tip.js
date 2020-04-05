import React from "react"
import PropTypes from "prop-types"
import Name from "../Name"

class Tip extends React.Component {

    render() {
        return (
            <div>
                <h3>Tip:<br/>
                    <Name commonName={this.props.taxon.common_name} sciName={this.props.taxon.name}/>
                </h3>
                <p>{this.props.content}</p>
            </div>
        )
    }
}

Tip.propTypes = {
    content: PropTypes.string,
    taxon: PropTypes.object,
};
export default Tip
