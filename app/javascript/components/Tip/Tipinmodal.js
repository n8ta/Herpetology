import React from "react"
import Question from "../svgs/Question";
import Tip from "./Tip";

export default class Tipinmodal extends React.Component {

    constructor(props) {
        super(props);
        this.activate = this.activate.bind(this);
        this.deactivate = this.deactivate.bind(this);
        this.state = {active: false}
    }

    activate() {
        this.setState({active: true});
        let content = <Tip {...this.props}/>;
        window.modal.set_content_and_callback(content,this.deactivate);
        window.modal.show();
    }

    deactivate() {
        this.setState({active: false});
    }

    render() {
        if (this.props.content) {
            return(
                <div className="center">
                    <button onClick={this.activate.bind(this)} className={'small'}>¿ Need help with this one ?</button>
                </div>
            )
        } else {
            return (<React.fragment></React.fragment>)
        }

    }
}

