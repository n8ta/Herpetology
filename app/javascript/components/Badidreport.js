import React from "react"
import PropTypes from "prop-types"
import SpeciesPicker from "./SpeciesPicker";

class Badidreport extends React.Component {
    constructor(props) {
        super(props);
        this.state = {active: false, submitted: false, search_results: [], specie_error: '', search_class: ''};
        this.updateDataList = this.updateDataList.bind(this)
        this.activate = this.activate.bind(this)
    }

    updateDataList() {
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
                this.setState({specie_class: 'valid', specie_error: ''});
            } else {
                this.setState({
                    specie_class: 'invalid',
                    specie_error: 'Invalid name, will not be submitted',
                    search_results: result
                })
            }
        });

    };

    select(taxon_id) {
        this.setState({specie_error: '', specie_class: 'valid', search_results: [], submitted: true});
        this.render();

        let auth_token = document.querySelector("meta[name='csrf-token']").content;
        this.setState({mode: 'loading'});
        fetch('/reports?type=BadIdReport&photo_id='+this.props.photo_id+'&taxon_id='+taxon_id, {
            method: 'POST',
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
                'X-CSRF-Token': auth_token,
                'X-Requested-With': 'XMLHttpRequest',
            },
            credentials: 'same-origin',

        }).then(res => res.json()).then((result) => {
            console.log('submitted report');
        });

        setTimeout(function() {
            window.location.reload();
        }, 1000)

    }

    activate() {
        this.setState({active: true})
    }


    render() {
        let options = [ ];
        for (let i = 0; i < this.state.search_results.length; i++) {
            let name = this.state.search_results[i]['name'];
            let comm = this.state.search_results[i]['common_name'];
            let id = this.state.search_results[i]['id'];
            options.push(<a href='#' onClick={function () {this.select(id)}.bind(this)} key={name}> {name} - {comm}</a>)
        }

        if (this.state.active == false && this.state.submitted == false) {

            return (
                <div className="center">
                    <button onClick={this.activate} className={'small'}>This ID is wrong!</button>
                </div>)

        } else if (this.state.active == true && this.state.submitted == false) {
            return (
                <form id='bad_id_report' className={'centered_md_col'}>
                    <div className={'warning top'}>{this.state.specie_error}</div>
                    <label htmlFor={'report_taxon_input'}>Enter then click the correct species</label>
                    <input type='text' onKeyDown={this.updateDataList} id="report_taxon_input" name="report[taxon]"/>
                    <div id={'report_suggestions'}>
                        {options}
                    </div>
                </form>)
        } else {
            return (
                <div id={'bad_id_report'}>
                    <div className="center">
                        <button className={'small submitted'}>Submitted, this will not count against your stats.
                        </button>
                    </div>
                </div>)
        }
    }
}

Badidreport.propTypes = {
    photo_id: PropTypes.number,
    taxon_com: PropTypes.string,
    taxon_sci: PropTypes.string,
};


export default Badidreport


