import React from "react"
import PropTypes from "prop-types"


export default class Modal extends React.Component {

    keydown_func(event){
        if(event.keyCode === 27 && this.state.active) { this.hide() } }

    componentDidMount(){
        document.addEventListener("keydown", this.keydown_func.bind(this), false);
    }

    constructor(props) {
        super(props);
        this.state = {
            content: <div></div>,
            active: false,
            callback: undefined,
        };
        this.modal_ref = React.createRef();
        window.modal = {
            hide: this.hide.bind(this),
            show: this.show.bind(this),
            set_content_and_callback: this.set_content_and_callback.bind(this)
        }
    }

    set_content_and_callback(content, callback) {
        let wrapped = <div><button onClick={this.hide.bind(this)} className={'special'} id={'modal_close'}>✗</button>{content}</div>;
        this.setState({content: wrapped, callback: callback})
    }

    show() {
        this.setState({active: true});
        this.modal_ref.current.style.display = "true";
        document.querySelector('body').style.overflow = 'hidden';
    }

    hide() {
        this.modal_ref.current.style.display = "false";
        this.setState({active: false});
        this.state.callback();
    }


    render() {
        let modal_class = this.state.active ? "active" : "inactive";
        return (
            <div onClick={this.hide.bind(this)} className={modal_class} ref={this.modal_ref} id={'modal'}>
                <div onClick={(event) => {event.stopPropagation();}} id={'modal_inner'}>
                    {this.state.content}
                </div>
            </div>
        );
    }
}
