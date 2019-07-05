import React from "react"
import PropTypes from "prop-types"
import Zoom from './Zoom.js';

import SpeciesPicker from "./SpeciesPicker";

class Report extends React.Component {
    constructor(props) {
        super(props);
        let auth_token = document.querySelector("meta[name='csrf-token']").content;
        this.state = {
            csrf: auth_token,
            search_results: [],
        };
        this.updateDataList = this.updateDataList.bind(this);
        this.radio = this.radio.bind(this);
        this.clear_radio = this.clear_radio.bind(this);
        this.select = this.select.bind(this);
        this.render = this.render.bind(this);
        this.empty = this.empty.bind(this);
    }

    radio() {
        this.setState({radio_valid: true, specie_error: ''})
    }

    empty() {
        if (this.state.empty_valid == undefined) {
            this.setState({empty_valid: true, specie_error: ''})
        } else {
            this.setState({empty_valid: undefined})
        }
    }

    updateDataList() {
        this.clear_radio();
        let search = document.getElementById('report_taxon_input');
        fetch('/taxons/search/' + encodeURI(search.value), {
            method: 'get',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
                'X-CSRF-Token': this.state.csrf,
                'X-Requested-With': 'XMLHttpRequest',
            },
            credentials: 'same-origin',
        }).then(res => res.json()).then((result) => {
            if (result.length == 1 && (result[0].common_name == search.value || result[0].name == search.value)) {
                this.setState({specie_class: 'valid', specie_error: ''})
                this.clear_radio()
            } else {
                this.setState({specie_class: 'invalid', specie_error: 'Invalid name, will not be submitted', search_results: result})
            }
        });

    };

    select(name) {
        document.getElementById('report_taxon_input').value = name;
        this.setState({specie_error: '', specie_class: 'valid', search_results: [], });
        this.clear_radio();
        this.render();

    }

    clear_radio() {
        let radios = document.querySelectorAll('input[type=radio]')
        for (let i =0; i<radios.length; i++) {
            radios[i].checked = false
        }
        this.setState({radio_valid: undefined})

    }

    render() {

        let ready = ""
        if (this.state.specie_class == "valid" || this.state.radio_valid == true || this.state.empty_valid == true) {
            ready = "ready"
        }

        let options = [];
        for (let i = 0; i < this.state.search_results.length; i++) {
            let name = this.state.search_results[i]['name'];
            let comm = this.state.search_results[i]['common_name'];
            options.push(<a href='#' onClick={function () {this.select(name)}.bind(this) }  key={name}> {name} -- {comm}</a>)
        }

        let taxon_disabled = "";
        let venom_disabled = "";
        let clear = ""
        let no_herp_disabled = "";
        if (this.state.specie_class == "valid") {
            venom_disabled = "disabled";
            no_herp_disabled = "disabled";
        } else if (this.state.empty_valid) {
            venom_disabled = "disabled";
            taxon_disabled = "disabled";
            options = "";
            document.getElementById('report_taxon_input').value = "";
        } else if (this.state.radio_valid) {
            no_herp_disabled = "disabled";
            taxon_disabled = "disabled";
            options = "";
            document.getElementById('report_taxon_input').value = "";
            clear = <a href='#' onClick={this.clear_radio}>Clear</a>

        }


        return (

            <form action="/reports" acceptCharset="UTF-8" method="post" id='report_form'><input name="utf8" type="hidden"
                                                                               defaultValue="✓"/><input
                type="hidden" name="authenticity_token"
                defaultValue={this.state.csrf}/>
                <input type="hidden" name="return_url" value={window.location}/>

                <Zoom url={this.props.url} venomous={this.props.venomous} no_text={true}/>
                <p>Fill out one of these options</p>

                <div className="field hidden">
                    <label htmlFor="report_photo_id">Photo</label>
                    <input defaultValue={this.props.photo_id} type="text"
                           name="report[photo_id]" id="report_photo_id"/>
                </div>

                <div className="field">
                    <label htmlFor="report_taxon_input">Species Incorrect, Shold be:</label><br/>
                    <div className={'warning top'}>{this.state.specie_error}</div>
                    <input disabled={taxon_disabled} className={this.state.specie_class} type='text' onKeyDown={this.updateDataList} id="report_taxon_input"
                           name="report[taxon]"/>


                    <div id={'report_suggestions'}>
                        {options}
                    </div>
                </div>
                <div className="field">
                    <label>Species venomous tag is wrong</label><br/>
                    <input disabled={venom_disabled} onClick={this.radio} defaultValue="venomous" name="report[venomous]" type="radio" id="report_venomous"/>
                    <label htmlFor="report_venomous">Venomous</label>
                    <br/>
                    <input disabled={venom_disabled} onClick={this.radio} defaultValue="nonvenomous" name="report[venomous]" type="radio"
                           id="report_nonvenomous"/>
                    <label htmlFor="report_nonvenomous">Nonvenomous</label>
                    <br/>
                    <input disabled={venom_disabled} onClick={this.radio} defaultValue="unknown" name="report[venomous]" type="radio" id="report_unknown"/>
                    <label htmlFor="report_unknown">Unknown</label>
                    <br/>
                    {clear}
                    {/*        <a>Clear</a>*/}
                </div>
                <div className="field">
                    <input disabled={no_herp_disabled} onClick={this.empty} type="checkbox" id="report_no_herp" name="report[no_herp]"/>
                    <label htmlFor="report_no_herp">Empty photo?</label>
                </div>

                <div className="actions">
                    <input className={ready} type="submit" value="Create Report" id="submit" name="commit" defaultValue="Create Report"
                           data-disable-with="Create Report"/>
                </div>
            </form>

        );
    }
}

export default Report


Report.propTypes = {
    photo_id: PropTypes.number,
    url: PropTypes.string,
    venomous: PropTypes.string,
};
