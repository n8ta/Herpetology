import React from "react"
import PropTypes from "prop-types"
import Noherpreport from "./Noherpreport.js";
import Deadherpreport from "./Deadherpreport.js";
import Badregionreport from "./Badregionreport.js";
import Badidreport from "./Badidreport.js";
import Alert from "../Alert";

class Reportmanager extends React.Component {

    constructor(props) {
        super(props);
        this.activate = this.activate.bind(this);
        this.deactivate = this.deactivate.bind(this);
        this.bad_id_fullscreen = this.bad_id_fullscreen.bind(this);
        this.render = this.render.bind(this);
        this.after_report = this.after_report.bind(this);
        this.state = {active: false}
    }

    activate() {
        this.setState({active: true})
    }

    deactivate() {
        this.setState({active: false, bad_id_only: false})
    }

    // Maximize bad id report it needs the whole width
    bad_id_fullscreen() {
        this.setState({bad_id_only: true})
    }

    after_report() {

        setTimeout(this.deactivate.bind(this),1000);
        setTimeout(this.props.after_report,1000)
    }

    render() {


        let disabled = this.props.taxon_id == undefined
        if (this.state.active == true) {
            if (this.state.bad_id_only) {
                return (
                    <React.Fragment>
                        <Badidreport
                            no_flash={true} after_report={this.after_report.bind(this)}
                            active={true}
                            callback_fullscreen={this.bad_id_fullscreen} disabled={disabled}
                            photo_id={this.props.photo_id}
                            taxon_com={this.props.common_name}
                            taxon_sci={this.props.sci_name}/>
                            <div className={'center'}>
                                <button onClick={this.deactivate} className={'small cancel'}>Cancel</button>
                            </div>

                    </React.Fragment>)

            } else {
                return (
                    <React.Fragment>
                        <div className={'center'}>

                        <Noherpreport no_flash={true} after_report={this.after_report.bind(this)} photo_id={this.props.photo_id}></Noherpreport>
                        <Deadherpreport no_flash={true} after_report={this.after_report.bind(this)} photo_id={this.props.photo_id}></Deadherpreport>
                        <Badregionreport no_flash={true} after_report={this.after_report.bind(this)} disabled={disabled}
                                         taxon_id={this.props.taxon_id}
                                         region_id={this.props.region_id}></Badregionreport>
                        <Badidreport no_flash={true} after_report={this.after_report.bind(this)} callback_fullscreen={this.bad_id_fullscreen} disabled={disabled}
                                     photo_id={this.props.photo_id}
                                     taxon_com={this.props.common_name}
                                     taxon_sci={this.props.sci_name}/>
                        <button onClick={this.deactivate} className={'small cancel'}>Cancel</button>
                        </div>
                    </React.Fragment>
                );
            }
        } else {
            return (
                <div className="center">
                    <button onClick={this.activate} className={'small'}><Alert/>Report an issue</button>
                </div>
            )
        }
    }
}

Reportmanager.propTypes = {
    photo_id: PropTypes.number,
    taxon_id: PropTypes.number,
    region_id: PropTypes.number,
    after_report: PropTypes.func,
    no_flash: PropTypes.bool,
};

export default Reportmanager
