/**
 * Created by buhe on 16/5/4.
 */
import React, {Component} from 'react';
import {requireNativeComponent, View} from 'react-native';
import PropTypes from 'prop-types';
class Live extends Component {

    constructor(props, context) {
        super(props, context);
        //console.log(props)
        this._onReady = this
            ._onReady
            .bind(this);
        this._onLoading = this
            ._onLoading
            .bind(this);
        this._onPaused = this
            ._onPaused
            .bind(this);
        this._onStop = this
            ._onStop
            .bind(this);
        this._onError = this
            ._onError
            .bind(this);
        this._onPlaying = this
            ._onPlaying
            .bind(this);
        this._onAutoReconnecting = this
            ._onAutoReconnecting
            .bind(this);
        this._onProg = this
            ._onProg
            .bind(this);
    }
    setNativeProps(nativeProps) {
        this
            ._root
            .setNativeProps(nativeProps);
    }
    seek = (time) => {
        this.setNativeProps({seek: time})
    }
    _onReady(event) {
        this.props.onReady && this
            .props
            .onReady(event.nativeEvent)
    }
    _onAutoReconnecting(event) {
        this.props.onAutoReconnecting && this
            .props
            .onAutoReconnecting(event.nativeEvent)
    }
    _onCompleted(event) {
        this.props.onCompleted && this
            .props
            .onCompleted(event.nativeEvent)
    }
    _onLoading(event) {
        this.props.onLoading && this
            .props
            .onLoading(event.nativeEvent);
    }

    _onPaused(event) {
        this.props.onPaused && this
            .props
            .onPaused(event.nativeEvent);
    }

    _onStop(event) {
        this.props._onStop && this
            .props
            ._onStop(event.nativeEvent);
    }

    _onError(event) {
        this.props.onError && this
            .props
            .onError(event.nativeEvent);
    }

    _onPlaying(event) {
        this.props.onPlaying && this
            .props
            .onPlaying(event.nativeEvent);
    }

    _onProg(event) {
        this.props.onProg && this
            .props
            .onProg(event.nativeEvent)
    }
    render() {
        const nativeProps = Object.assign({}, this.props);
        Object.assign(nativeProps, {
            onLoading: this._onLoading,
            onPaused: this._onPaused,
            onStop: this._onStop,
            onError: this._onError,
            onPlaying: this._onPlaying,
            onReady: this._onReady,
            onAutoReconnecting: this._onAutoReconnecting,
            onCompleted: this.on_onCompleted,
            onProg: this._onProg

        });
        return (<RCTLive ref={component => this._root = component} {...nativeProps}/>)
    }
}

Live.propTypes = {
    source: PropTypes
        .shape({ // 是否符合指定格式的物件
        uri: PropTypes.string.isRequired,
        controller: PropTypes.bool, //Android only
        timeout: PropTypes.number, //Android only
        hardCodec: PropTypes.bool, //Android only
        live: PropTypes.bool, //Android only
    }).isRequired,
    paused: PropTypes.bool,
    muted: PropTypes.bool, //iOS only
    //autoPlay:PropTypes.bool,
    aspectRatio: PropTypes.oneOf([0, 1, 2, 3, 4]),
    onLoading: PropTypes.func,
    onPaused: PropTypes.func,
    onStop: PropTypes.func,
    onError: PropTypes.func,
    onPlaying: PropTypes.func,
    onReady: PropTypes.func,
    onAutoReconnecting: PropTypes.func,
    onProg: PropTypes.func,
    ...View.propTypes
}

const RCTLive = requireNativeComponent('RCTLive', Live);

module.exports = Live;
