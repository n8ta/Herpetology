import React from "react"
import PropTypes from "prop-types"


class Menubutton extends React.Component {
    constructor(props) {
        console.log("MENU CONS");
        super(props);
        this.state = {mode: ""};
        this.toggle = this.toggle.bind(this)
    }

    toggle() {

        function disableScroll() {
            try {if (window.addEventListener) { FFwindow.addEventListener('DOMMouseScroll', preventDefault, false);} }catch(err) {}
            try {document.addEventListener('wheel', preventDefault, {passive: false})}catch(err){}; // Disable scrolling in Chrome} catch(err) {};
            try {window.onwheel = preventDefault }catch(err){};
            try {window.onmousewheel = document.onmousewheel = preventDefault } catch(err) {};
            try {window.ontouchmove  = preventDefault } catch(err) {};
            try {document.onkeydown  = preventDefaultForScrollKeys } catch(err) {};
        }

        function enableScroll() {
            try {window.removeEventListener('DOMMouseScroll', preventDefault, false)} catch(err){};
            try {document.removeEventListener('wheel', preventDefault, {passive: false});}catch(err){};
            try {window.onmousewheel = document.onmousewheel = null;} catch(err){}
            try {window.onwheel = null;} catch(err){};
            try {window.ontouchmove = null;} catch(err){};
            try {document.onkeydown = null;} catch(err){};
        }



        let menu = document.getElementById('menu');
        let body = document.querySelector('body');
        let content = document.getElementById('content');

        console.log("content:",content);
        if (this.state.mode == "") {
            this.setState({mode: "is-active"});
            menu.style.minHeight = 'unset';
            menu.style.height = '100vh';
            body.style.overflowY = 'hidden';
            disableScroll();
            console.log('branch');
            setTimeout(function(){
                content.style.display = 'none';
                console.log("ran timsseout!!!")
            }, 700);
            console.log('post');
        } else {
            console.log('branch2 ');
            this.setState({mode: ""});
            menu.style.minHeight = 'unset';
            menu.style.height = '0px';
            content.style.display = 'unset';
            body.style.overflowY = 'unset';
            enableScroll();
            console.log('bran h2')
        }

    }


    render() {
        return (
            <div id='menubutton'>
            <button onClick={this.toggle} className={["special","hamburger","hamburger--vortex",this.state.mode].join(" ")}  type="button">
                <span className="hamburger-box">
                    <span className="hamburger-inner"></span>
                </span>
            </button>
            </div>
        );
    }
}

export default Menubutton
