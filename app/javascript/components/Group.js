import React from "react"
import PropTypes from "prop-types"
import {jsonFetch} from './fetch'

const LOADING = 'LOADING' // Init state
const READY = 'READY' // Waiting on sure to make the choice
const AWAITING_SERVER = 'AWAITING_SERVER' // User has made the choice waiting for server
const ACKED = 'ACKED' // Server has replied

const VISIBLE = 'VISIBLE'
const HIDDEN = 'HIDDEN'

const str = (bool) => {
    return bool ? "venomous" : "harmless"
}

class Group extends React.Component {
    constructor(props) {
        super(props)
        this.state = {
            name: props.name,
            id: props.id,
            mode: LOADING,
            warning: VISIBLE
        }
        this.get_next()
    }


    hide = () => {
        this.setState({warning: HIDDEN})
    }
    answer = (venomous) => {
        console.info(venomous)
        this.setState({
            mode: AWAITING_SERVER,
            guess: venomous,
        })
        jsonFetch('POST', "/groups/" + this.state.id + "/next",
            (result) => {
                this.setState({
                    correct: result.specie.venomous === venomous,
                    prior: result.specie,
                    mode: ACKED,
                    next_photo: result.photo,
                })
            },
            {venomous, photo_id: this.state.photo.id})
    }

    cont = () => {
        this.setState({
                photo: this.state.next_photo,
                next_photo: null,
                mode: READY,
            }
        )

    }

    get_next = () => {
        jsonFetch('GET', "/groups/" + this.state.id + "/next", (result) => {
            this.setState({
                mode: READY,
                photo: result
            })
        })
    }


    render() {
        let message = <div></div>;
        if (this.state.mode === ACKED) {
            if (this.state.correct) {
                message = <div>🎉 You are Correct
                    🎉<br/>the {this.state.prior.common_name} is {str(this.state.prior.venomous)}</div>;
            } else {
                message =
                    <div>😥 Incorrect.... 😥<br/>the {this.state.prior.common_name} is {str(this.state.prior.venomous)}
                    </div>;
            }
        } else {
            message = "Take your best guess"
        }


        if (this.state.warning === VISIBLE) {
            return (<div>
                <h3 className={'text-center'} style={{marginBottom: 0}}>
                    ⚠️
                    This site is actively being worked on. Some snakes are incorrectly tagged as venomous / non-venomous right now.
                </h3>
                <div className={'center'}>
                    <button onClick={this.hide}>Continue</button>
                </div>
            </div>)
        }
        if (this.state.mode === LOADING) {
            return (
                <div>
                    <h1>{this.state.name}</h1>
                    <p>Loading first image...</p>
                </div>
            )
        } else {
            return (
                <div>
                    <h1>{this.state.name}</h1>
                    <p className={'text-center'} style={{marginBottom: 0}}>{message}</p>
                    <div className={'center'}>
                        <button disabled={this.state.mode !== READY} onClick={() => this.answer(true)}>Venomous</button>
                        &nbsp;
                        <button disabled={this.state.mode !== READY} onClick={() => this.answer(false)}>Harmless
                        </button>
                        &nbsp;
                        <button disabled={this.state.mode !== ACKED} onClick={this.cont}>Continue</button>
                    </div>
                    <br/>

                    <div className={'center'}>

                        <img src={this.state.photo.url} alt={"Image of a snake"}/>
                    </div>

                    <br/>
                </div>
            )
        }
    }
}

Group.propTypes =
    {
        name: PropTypes.string,
        id
:
PropTypes.number,
    photo
:
PropTypes.string,
    mode
:
PropTypes.string,
    species
:
PropTypes.object
}
;

export default Group