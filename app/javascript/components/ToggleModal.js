import React from "react"
import PropTypes from "prop-types"

export default class ToggleModal extends React.Component {
    constructor() {
        super();
        this.state = {on: true};
        this.modal_has_closed = this.modal_has_closed.bind(this);
    }

    modal_has_closed() {
        this.setState({on: false});
        console.debug("Modal closed!")
    }

    open() {
        this.setState({on: true});
        let content = <div><span onClick={() => window.modal.hide()}>CLOSE</span><h1>Passing content</h1><p>Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.</p></div>;
        window.modal.set_content_and_callback(content,this.modal_has_closed);
        window.modal.show();
    }

    render() {
        if (this.state.on)  {
            return (
                <div onClick={this.open.bind(this)}>Modal open</div>
            );
        } else {
            return (
                <div>Open modal</div>
            );
        }

    }
}