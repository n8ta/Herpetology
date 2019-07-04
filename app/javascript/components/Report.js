import React from "react"
import PropTypes from "prop-types"
import Zoom from './Zoom.js';

import SpeciesPicker from "./SpeciesPicker";

class Report extends React.Component {
    constructor(props) {
        super(props);
        let auth_token = document.querySelector("meta[name='csrf-token']").content;
        this.state = {
            csrf: auth_token
        };
    }


    render() {
        return (
            <form action="/reports" acceptCharset="UTF-8" method="post"><input name="utf8" type="hidden"
                                                                               defaultValue="✓"/><input
                type="hidden" name="authenticity_token"
                defaultValue={this.state.csrf}/>
                <Zoom url={this.props.url} venomous={this.props.venomous} no_text={true}/>
                <div className="field hidden">
                    <label htmlFor="report_photo_id">Photo</label>
                    <input defaultValue={847} type="text" name="report[photo_id]" id="report_photo_id"/>
                </div>
                <div className="field">
                    <label htmlFor="report[suggested_taxon]">Correct Species</label><br/>
                    <input list="taxons_list" id="report_suggested_taxon_input" name="report[suggested_taxon]"/>
                    <datalist id="taxons_list">
                    </datalist>
                </div>
                <div className="field">
                    <input defaultValue="venomous" name="report[venomous]" type="radio" id="report_venomous"/>
                    <label htmlFor="report_venomous">Venomous</label>
                    <br/>
                    <input defaultValue="nonvenomous" name="report[venomous]" type="radio"
                           id="report_nonvenomous"/>
                    <label htmlFor="report_nonvenomous">Nonvenomous</label>
                    <br/>
                    <input defaultValue="unknown" name="report[venomous]" type="radio" id="report_unknown"/>
                    <label htmlFor="report_unknown">Unknown</label>
                    <br/>
                    {/*        <a>Clear</a>*/}
                </div>
                <div className="field">
                    <input type="checkbox" id="report_no_herp"/>
                    <label htmlFor="report_no_herp" name="report[no_herp]">Empty photo?</label>
                </div>
                <div className="actions">
                    <input type="submit" id="submit" name="commit" defaultValue="Create Report"
                           data-disable-with="Create Report" />
                </div>
            </form>

        );
    }
}

export default Report


Report.propTypes = {
    options: PropTypes.array,
    photo_id: PropTypes.number,
    url: PropTypes.string,
    venomous: PropTypes.string,
};
