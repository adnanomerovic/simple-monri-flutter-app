package com.example.simple_monri_flutter_app.monri_http_helper;

@FunctionalInterface
public interface Consumer<T> {
    void accept(T t);
}
