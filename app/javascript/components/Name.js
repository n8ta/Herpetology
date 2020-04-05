import React from "react"
import PropTypes from "prop-types"

export default class Name extends React.Component {
    render() {
        if (this.props.link && this.props.link == true) {
            return (
                <a href={"/taxons/" + this.props.taxon.id}><span><span
                    className="common_name">{this.props.taxon ? this.props.taxon.common_name : this.props.commonName} </span>(<span
                    className="sci_name">{this.props.taxon ? this.props.taxon.name : this.props.sciName}</span></span></a>)

        } else {
            return ( <span><span
                className="common_name">{this.props.taxon ? this.props.taxon.common_name : this.props.commonName} </span>(<span
                className="sci_name">{this.props.taxon ? this.props.taxon.name : this.props.sciName}</span></span>)
        }
    }
}

Name.propTypes = {
    link: PropTypes.bool,
    taxon: PropTypes.object,
    sciName: PropTypes.string,
    commonName: PropTypes.string
};
