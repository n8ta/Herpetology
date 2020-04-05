import React from "react"
import Venomreport from './Venomreport.js';
import PropTypes from "prop-types"
import Tipinmodal from "./Tip/Tipinmodal";

class Zoom extends React.Component {
    constructor(props) {
        console.debug("zoom constructed -----===-=---");
        super(props);
        this.mouseMove = this.mouseMove.bind(this);
        this.mouseLeave = this.mouseLeave.bind(this);
        this.apply_style = this.apply_style.bind(this);
        this.state = {
            mode: 'waiting',
        };
        this.container_ref = React.createRef();
        this.main_ref = React.createRef();
        this.image_ref = React.createRef();
        setTimeout(this.apply_style.bind(this), .01);
    }

    mouseMove(e) {
        let cont = this.container_ref.current;
        let pageX = e.clientX - cont.getBoundingClientRect().left;
        let pageY = e.clientY - cont.getBoundingClientRect().top;
        let origin = pageX + 'px ' + pageY + 'px';
        this.setState({
            mode: 'live',
            origin: origin
        });
        this.apply_style();
    }

    mouseLeave() {
        this.state.mode = 'waiting'
    }

    apply_style() {
        let main = this.main_ref.current;
        if (main == null) { return }

        main.style.backgroundImage = "url('" + this.props.url + "')";
        if (this.state && this.state.mode == 'live') {
            main.style.transformOrigin = this.state.origin
        }
    }


    render() {
        this.apply_style();
        let venomous = "";
        let tip = "";

        if (this.props.tip && this.props.tip != undefined) {
            tip = <div className={'tip_area'}><Tipinmodal  {...this.props.tip} /></div>
        }


        if (this.props.no_text == true) {

        } else {

            if (this.props.venomous == "venomous") {
                venomous = <div className='poison_icon'>Venomous</div>
            } else if (this.props.venomous == "nonvenomous") {
                venomous = <div className='poison_icon'>Nonvenomous</div>
            } else if (this.props.venomous == "unknown") {
                venomous = <div className='poison_icon'>
                    <Venomreport photo_id={this.props.photo_id}></Venomreport></div>
            }
        }

        return (

            <React.Fragment>
                <div className={'zoom_outer'}>
                    {venomous}
                    <div className={'zoom_inner'} ref={this.container_ref} onMouseLeave={this.mouseLeave}
                         onMouseMove={this.mouseMove}>
                        <div className={'zoom'} ref={this.main_ref} >
                            <img alt='Photo of an unknown herp' className={'zoom_image'}
                                 src={this.props.url}
                                 ref={this.image_ref}
                            />
                        </div>
                    </div>
                    {tip}
                </div>
            </React.Fragment>
        )
            ;
    }
}

Zoom.propTypes = {
    url: PropTypes.string,
    photo_id: PropTypes.number,
    venomous: PropTypes.string,
    no_text: PropTypes.bool,
    tip: PropTypes.object,
};
export default Zoom
