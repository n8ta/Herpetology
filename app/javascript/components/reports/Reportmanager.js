import React from "react"
import PropTypes from "prop-types"
import Noherpreport from "./Noherpreport.js";
import Deadherpreport from "./Deadherpreport.js";
import Badregionreport from "./Badregionreport.js";
import Badidreport from "./Badidreport.js";
import Progressbar from "../Progressbar";

class Reportmanager extends React.Component {

    constructor(props) {
        super(props);
        this.bad_id_fullscreen = this.bad_id_fullscreen.bind(this);
        this.render = this.render.bind(this);
        this.state = {bad_id_only: false, complete: false}
    }

    // Maximize bad id report it needs the whole width
    bad_id_fullscreen() {
        this.setState({bad_id_only: true})
    }

    after_report() {
        this.setState({bad_id_only: false, complete: true});
        setTimeout(() => {window.location = window.location;},1500)
    }

    render() {
        let disabled = this.props.taxon_id == undefined
        if (this.state.complete) {
            return (
                <div>
                    <h2>Report submitted</h2>
                    <p className={'center'}>Thank you</p>
                </div>
            )
        }
        if (this.state.bad_id_only) {
            return (
                <React.Fragment>
                    <Badidreport
                        after_report={this.after_report.bind(this)}
                        no_flash={true} active={true}
                        callback_fullscreen={this.bad_id_fullscreen} disabled={disabled}
                        photo_id={this.props.photo_id}
                        taxon_com={this.props.common_name} taxon_sci={this.props.sci_name}/>
                </React.Fragment>)

        } else {
            return (
                <React.Fragment>
                    <h3>What's the issue?</h3>
                    <div className={'center report-manager'}>
                        <Noherpreport after_report={this.after_report.bind(this)} no_flash={true} photo_id={this.props.photo_id}></Noherpreport>
                        <Deadherpreport after_report={this.after_report.bind(this)} no_flash={true} photo_id={this.props.photo_id}></Deadherpreport>
                        <Badregionreport after_report={this.after_report.bind(this)} no_flash={true} disabled={disabled} taxon_id={this.props.taxon_id} region_id={this.props.region_id}></Badregionreport>
                        <Badidreport after_report={this.after_report.bind(this)} no_flash={true} callback_fullscreen={this.bad_id_fullscreen} disabled={disabled} photo_id={this.props.photo_id} taxon_com={this.props.common_name} taxon_sci={this.props.sci_name}/>
                    </div>
                </React.Fragment>
            );
        }
    }
}

Reportmanager.propTypes = {
    photo_id: PropTypes.number,
    taxon_id: PropTypes.number,
    region_id: PropTypes.number,
    no_flash: PropTypes.bool,
};

export default Reportmanager
