import React from "react"
import PropTypes from "prop-types"
import Zoom from "./Zoom";
import Name from "./Name";
import Progressbar from "./Progressbar";

class Learn extends React.Component {

    preload(image_path) {
        let image = new Image();
        image.onload;
        image.src = image_path;
    }

    keydown(ev) {
        if (ev.key == " " || ev.key == "ArrowUp") {
            ev.preventDefault();
            this.new_question();
        }
        if (ev.key == "ArrowLeft") {
            this.answer(true)
        }
        if (ev.key == "ArrowRight") {
            this.answer(false)
        }
    }

    constructor(props) {

        super(props);

        window.addEventListener('keydown', this.keydown.bind(this));
        let txns = this.props.taxons;
        for (let i = 0; i < txns.length; i++) {
            txns[i].seen = 0;
            txns[i].correct = 0;
            txns[i].score = 0.0; // rolling average
            txns[i].photos = [];
        }
        this.state = {
            mode: "loading",
            complete_taxons: [],
            progress: 0,
            taxons: txns,
            num_taxons: this.props.taxons.length,
            loaded_taxons: 0,
            left_is_correct: undefined,
            left_class: '', // correct or incorrect
            right_class: '',
            incorrect_answer: undefined,
            current: this.props.taxons[0],
            correct: undefined,
            working_set: this.props.taxons.slice(1, 6), // TODO : Local storage
            pending_set: this.props.taxons.slice(6, 100),
            mastered: false, // Last species was mastered
            done: false,

        };
        let taxons = this.props.taxons;
        let auth_token = document.querySelector("meta[name='csrf-token']").content;
        for (let i = 0; i < taxons.length; i++) {

            fetch("/taxons/" + taxons[i].id + "/photos/plenty", {
                method: 'GET',
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json',
                    'X-CSRF-Token': auth_token,
                    'X-Requested-With': 'XMLHttpRequest',
                },
                credentials: 'same-origin',
            }).then(res => res.json()).then((result) => {
                for (let j = 0; j < result.length; j++) {
                    let url = result[j]['url'];
                    this.preload(url);
                    // Create and push to array, how bout that syntax
                    this.state.taxons[i].photos.push(url);
                    if (this.props.taxons.length - (this.state.loaded_taxons + 1) < 1) {
                        this.new_question();
                        this.setState({mode: "ready"});
                    }
                }
                this.setState({loaded_taxons: this.state.loaded_taxons + 1});
            });
        }
        this.render = this.render.bind(this);
        this.current = this.current.bind(this);
        this.new_question = this.new_question.bind(this);
        this.keydown = this.keydown.bind(this);

    }

    current(which) {
        return this.state.current
    }

    new_question() {
        if (!(this.state.mode == "answered" || this.state.mode == "loading")) {
            return
        }

        let left_correct = Math.random() > .5;

        let place = Math.floor(Math.random() * this.state.working_set.length);

        let reordered = this.state.working_set;


        if (this.state.current.score >= 0.75) {
            if (this.state.pending_set.length > 0) {
                let pending_set = this.state.pending_set;
                let new_taxon = pending_set.pop();
                this.setState({pending_set: pending_set});
                reordered.push(new_taxon)
            } else {
                ga('send', 'event', 'learn', 'done', 'true');
                this.setState({done: true})

            }
        } else {
            reordered.splice(place, 0, this.state.current);
        }

        // new correct answer
        let correct_answer = reordered.pop();
        // new incorrect
        let incorrect_answer = this.state.taxons[Math.floor(Math.random() * this.state.taxons.length)];
        while (incorrect_answer.id == correct_answer.id) {
            incorrect_answer = this.state.taxons[Math.floor(Math.random() * this.state.taxons.length)];
        }


        console.log(correct_answer.photos.length);
        let correct_photo = correct_answer.photos[Math.floor(Math.random() * correct_answer.photos.length)];
        let incorrect_photo = incorrect_answer.photos[Math.floor(Math.random() * incorrect_answer.photos.length)];
        this.setState({
            incorrect_answer: incorrect_answer,
            current: correct_answer,
            left_is_correct: left_correct,
            correct_photo: correct_photo,
            incorrect_photo: incorrect_photo,
            working_set: reordered,
            left_class: '',
            right_class: '',
            mode: 'ready',
            correct: undefined,
        })
    }


    answer(clicked_left) {
        if (this.state.mode == "answered") {
            return
        }
        // If they clicked left and left is correct, they got it right
        // If they click right and right is correct, they got it right
        // This looks more complex than it is
        let correct = ((this.state.left_is_correct && clicked_left) || (!this.state.left_is_correct && !clicked_left));

        ga('send', 'event', 'learn', 'answer', correct);

        let current = this.state.current;
        if (correct) {
            current.correct += 1;
            current.score = (current.score * this.props.factor) + (1.0 - this.props.factor);
        } else {
            current.score = current.score * this.props.factor;
        }
        current.seen += 1;
        this.state.taxons[0].seen += 1;
        this.setState({
            correct: correct,
            current: current,
            mode: "answered", clicked_left: clicked_left,
            left_class: this.state.left_is_correct ? "correct" : "",
            right_class: this.state.left_is_correct ? "" : "correct",
            mastered: current.score >= 0.75,

        });
    }


    render() {
        if (this.state.mode == "loading") {
            return (<div id={'learn'}>
                <h3 className="center">Loading...</h3>
                <div className={'center'}>
                    <progress max={1.0} value={this.state.loaded_taxons / this.state.num_taxons}></progress>
                </div>
            </div>)
        } else {
            // Default to left correct, if it's not switch everything
            let msg = <span>Which of these is a<span
                className={'common_name'}> {this.current().common_name} </span>(<span
                className={'sci_name'}>{this.current().name}</span>)?<br/></span>;
            let next_button = "";
            let zoom_left = <Zoom url={this.state.correct_photo}/>;
            let zoom_right = <Zoom url={this.state.incorrect_photo}/>;
            let left_text = undefined;
            let right_text = undefined;
            let hide_arrows_class = "";
            if (!this.state.left_is_correct) {
                let tmp = zoom_left;
                zoom_left = zoom_right;
                zoom_right = tmp;
            }
            if (this.state.mode == "answered") {

                next_button = <div title='You can use the up arrow as well' className={"center"}>
                    <button onClick={this.new_question}>Next (▲) <br/></button>
                </div>;

                if (this.state.correct == true) {

                    if (this.state.mastered) {
                        if (this.state.done) {
                            msg = <span>🎉 <span
                                className={"font-heavy"}>You've just learned the {this.props.root_taxon_name} of {this.props.region_name}</span></span>
                            next_button = <a href={window.location}>
                                <div id={'next'} className={"center"}>
                                    <button className={'main happypath'}>Start over?<br/></button>
                                </div>
                            </a>;
                        } else {
                            msg = <span>🎉 <span
                                className={"font-heavy"}>Mastered</span> 🎉 <br/>You just mastered the <Name
                                commonName={this.state.current.common_name}
                                sciName={this.state.current.name}></Name></span>;
                        }

                    } else {
                        msg = <span>✓ <span className={"font-heavy"}>Correct</span> ✓ <br/>the other was a <Name
                            commonName={this.state.incorrect_answer.common_name}
                            sciName={this.state.incorrect_answer.name}></Name></span>;
                    }
                    hide_arrows_class = "hidden";
                } else {
                    msg = <span>❌ <span className="font-heavy">Incorrect</span> ❌ <br/>that was a <Name
                        commonName={this.state.incorrect_answer.common_name}
                        sciName={this.state.incorrect_answer.name}></Name></span>;
                        hide_arrows_class = "hidden"
                }
            } else {
                left_text = "This one";
                right_text = "This one";
            }

            let progbars = this.state.working_set.concat(this.state.current);
            progbars = progbars.sort(function (a, b) {
                return a.id - b.id
            });

            progbars = progbars.map((taxon) =>
                <Progressbar key={Math.random()} score={taxon.score * 1.334}
                             seen={taxon.seen} correct={taxon.correct}
                             sci_name={taxon.name} common_name={taxon.common_name}></Progressbar>
            );

            console.log(hide_arrows_class);
            return (<div id={"learn"}>
                <div className={'center'}>
                    {progbars}
                </div>
                <div className={"text-center lead"}>
                    <div className={'lead_text'}>{msg}</div>
                    {next_button}
                </div>


                <div className={'two-col'}>

                    <div onClick={function () {
                        this.answer(false)
                    }.bind(this)}>
                        <div className={'center'}>
                            <button  title={'Left arrow key'} disabled={this.state.mode == "answered"}
                                    className={hide_arrows_class + ' main ' + this.state.left_class}><h4>{left_text}</h4>
                            </button>
                        </div>
                        {zoom_left}
                    </div>

                    <div onClick={function () {
                        this.answer(false)
                    }.bind(this)}>
                        <div className={'center'}>
                            <button title={'Right arrow keys'} disabled={this.state.mode == "answered"} className={hide_arrows_class + ' main ' + this.state.right_class}><h4>{right_text}</h4>
                            </button>
                        </div>
                        {zoom_right}
                    </div>
                </div>


            </div>)
        }
    }
}

Learn.propTypes = {
    taxons: PropTypes.array,
    working_size: PropTypes.number,
    factor: PropTypes.number,
    region_name: PropTypes.string,
    root_taxon_name: PropTypes.string,
};


export default Learn
