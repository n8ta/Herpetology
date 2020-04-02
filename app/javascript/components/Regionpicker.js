import React from "react"
import PropTypes from "prop-types"

class Regionpicker extends React.Component {

    constructor(props) {
        super(props);
        this.state = {options: this.props.regions}
    }

    filter() {
        let term = document.getElementById('subregion_search_input').value;
        let regions = [];
        term = term.toUpperCase();
        for (let i = 0; i < this.props.regions.length; i++) {
            let region = this.props.regions[i];
            let name = region.name.toUpperCase();
            if (name.includes(term)) {
                regions.push(region)
            }

        }
        this.setState({options: regions})
    }

    render() {

        let lis = this.state.options.map(x => <li key={x.id}><a
            href={'/taxons/' + this.props.taxon.id + '/regions/' + x.id+'/game'}>{x.name}</a></li>);
        return (
            <React.Fragment>
                <h2>Pick your Region</h2>
                <div className={'center'}><br/>
                <input id={'subregion_search_input'} onChange={this.filter.bind(this)}
                                                 type={'text'}
                                                 placeholder={'Search...'}/>
                </div>
                <ul id="pick_region">
                    {lis}

                </ul>
            </React.Fragment>
        );
    }
}

Regionpicker.propTypes = {
    regions: PropTypes.array,
    taxon: PropTypes.object,
};

export default Regionpicker
