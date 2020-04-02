import React from "react"
import PropTypes from "prop-types"

class Tip extends React.Component {
    constructor(props) {
        super(props);
    }

    render() {
        return (
            <React.Fragment>
            </React.Fragment>
        )
            ;
    }
}

Tip.propTypes = {
    content: PropTypes.string,
    taxon_id: PropTypes.number,
    venomous: PropTypes.string,
    no_text: PropTypes.bool,
    tips: PropTypes.array,
};
export default Tip
