import React from "react"
import PropTypes from "prop-types"
import Name from "../Name"

class Tip extends React.Component {

    constructor(props) {
        super(props);
        console.debug("Props",props);
    }


    render() {
        return (
            <div>
                <h3><Name taxon={this.props.taxon} link={true}/>
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
