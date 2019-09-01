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

        tippy('#learn', {
            animateFill: true,
            animation: 'scale',
            placement: 'top',
            content: "Welcome to learn mode"
        });


        window.addEventListener('keydown', this.keydown.bind(this));
        this.state = {
            mode: "loading",
            progress: 0,
            taxons: this.props.taxons,
            num_taxons: this.props.taxons.length,
            loaded_taxons: 0,
            left_is_correct: undefined,
            left_class: '', // correct or incorrect
            right_class: '',
            incorrect_answer: undefined,
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
                    (this.state.taxons[i].photos = this.state.taxons[i].photos || []).push(url);
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
        return this.state.taxons[0]
    }

    new_question() {
        if (!(this.state.mode == "answered" || this.state.mode == "loading")) {
            return
        }
        let left_correct = Math.random() > .5;

        let place = Math.floor(Math.random() * this.state.taxons.length);
        let reordered = this.state.taxons;
        let cur = reordered.pop();
        reordered.splice(place, 0, cur);
        this.setState({taxons: reordered});


        let incorrect_answer = this.state.taxons[Math.floor(Math.random() * this.state.taxons.length)];
        while (incorrect_answer.id == this.state.taxons[0].id) {
            incorrect_answer = this.state.taxons[Math.floor(Math.random() * this.state.taxons.length)];
        }

        let correct_photo = this.current().photos[Math.floor(Math.random() * this.current().photos.length)];
        let incorrect_photo = incorrect_answer.photos[Math.floor(Math.random() * incorrect_answer.photos.length)];
        this.setState({
            incorrect_answer: incorrect_answer,
            correct_answer: this.state.taxons[0],
            left_is_correct: left_correct,
            correct_photo: correct_photo,
            incorrect_photo: incorrect_photo,
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
        let correct = ((this.state.left_is_correct && clicked_left) || (!this.state.left_is_correct && !clicked_left))
        this.setState({
            correct: correct,
            mode: "answered", clicked_left: clicked_left,
            left_class: this.state.left_is_correct ? "correct" : "",
            right_class: this.state.left_is_correct ? "" : "correct"
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
            if (!this.state.left_is_correct) {
                let tmp = zoom_left;
                zoom_left = zoom_right;
                zoom_right = tmp;
            }
            if (this.state.mode == "answered") {

                next_button = <div title='You can use the up arrow as well' id={'next'} className={"center"}>
                    <button className={'main happypath'} onClick={this.new_question}>Next (▲) <br/></button>
                </div>;

                if (this.state.correct == true) {
                    msg = <span>🎉 <span class="font-heavy">Correct</span> 🎉 <br/>the other was a <Name
                        commonName={this.state.incorrect_answer.common_name}
                        sciName={this.state.incorrect_answer.name}></Name></span>;
                    if (this.state.left_is_correct) {
                        left_text = "✓";
                        right_text = "✗"
                    } else {
                        right_text = "✓";
                        left_text = "✗"
                    }
                } else {
                    msg = <span>❌ <span className="font-heavy">Incorrect</span> ❌ <br/>that was a <Name
                        commonName={this.state.incorrect_answer.common_name}
                        sciName={this.state.incorrect_answer.name}></Name></span>;
                    if (this.state.left_is_correct) {
                        left_text = "✓";
                        right_text = "✗"
                    } else {
                        right_text = "✓";
                        left_text = "✗"
                    }
                }
            } else {
                left_text = "◀ This one!";
                right_text = "This one! ▶";
            }


            return (<div id={"learn"}>
                <div>
                    <Progressbar seen={10} correct={5} sci_name={"Morelia Viridis"} common_name={"Green Tree Python"}></Progressbar>
                    <Progressbar seen={0} correct={0} sci_name={"Morelia Viridis"} common_name={"Green Tree Python"}></Progressbar>
                    <Progressbar seen={10} correct={10} sci_name={"Morelia Viridis"} common_name={"Green Tree Python"}></Progressbar>
                    <Progressbar seen={3} correct={1} sci_name={"Morelia Viridis"} common_name={"Green Tree Python"}></Progressbar>
                </div>
                <p className={"text-center lead"}>
                    {msg}
                </p>

                <div className={'two-col'}>

                    <div>
                        <div className={'center'}>
                            <button title={'Left arrow key'} disabled={this.state.mode == "answered"}
                                    onClick={function () {
                                        this.answer(true)
                                    }.bind(this)} className={'main ' + this.state.left_class}><h4>{left_text}</h4>
                            </button>
                        </div>
                        {zoom_left}
                    </div>

                    <div>
                        <div className={'center'}>
                            <button title={'Right arrow keys'} disabled={this.state.mode == "answered"}
                                    onClick={function () {
                                        this.answer(false)
                                    }.bind(this)} className={'main ' + this.state.right_class}><h4>{right_text}</h4>
                            </button>
                        </div>
                        {zoom_right}
                    </div>
                </div>
                {next_button}


            </div>)
        }
    }
}

Learn.propTypes = {
    taxons: PropTypes.array,
    working_size: PropTypes.number,
};


export default Learn
