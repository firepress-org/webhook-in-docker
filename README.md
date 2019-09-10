&nbsp;

<p align="center">
    Brought to you by
</p>

<p align="center">
  <a href="https://firepress.org/">
    <img src="https://user-images.githubusercontent.com/6694151/50166045-2cc53000-02b4-11e9-8f7f-5332089ec331.jpg" width="340px" alt="FirePress" />
  </a>
</p>

<p align="center">
    <a href="https://firepress.org/">FirePress.org</a> |
    <a href="https://play-with-ghost.com/">play-with-ghost</a> |
    <a href="https://github.com/firepress-org/">GitHub</a> |
    <a href="https://twitter.com/askpascalandy">Twitter</a>
    <br /> <br />
</p>

&nbsp;

# [webhook-in-docker](https://github.com/firepress-org/webhook-in-docker)

## What is this?

The simplest usage of **webhook** image is for one to host the hooks JSON file on their machine and mount the directory in which those are kept as a volume to the Docker container. 

## How to use it

<details><summary>Expand content (click here).</summary>
<p>

## How to use it

```
docker run -d -p 9000:9000 -v /dir/to/hooks/on/host:/etc/webhook --name=webhook \
  almir/webhook -verbose -hooks=/etc/webhook/hooks.json -hotreload
```

Another method of using this Docker image is to create a simple `Dockerfile`:

```
FROM almir/webhook
COPY hooks.json.example /etc/webhook/hooks.json
```

This `Dockerfile` and `hooks.json.example` files should be placed inside the same directory. After that run `docker build -t my-webhook-image .` and then start your container:

```
docker run -d -p 9000:9000 --name=webhook my-webhook-image -verbose -hooks=/etc/webhook/hooks.json -hotreload
```

Additionally, one can specify the parameters to be passed to [webhook](https://github.com/adnanh/webhook/) in `Dockerfile` simply by adding one more line to the previous example:

```
FROM almir/webhook
COPY hooks.json.example /etc/webhook/hooks.json
CMD ["-verbose", "-hooks=/etc/webhook/hooks.json", "-hotreload"]
```

Now, after building your Docker image with `docker build -t my-webhook-image .`, you can start your container by running just:

```
docker run -d -p 9000:9000 --name=webhook my-webhook-image
```

## Docker hub

Always check on docker hub the most recent build:<br>
https://hub.docker.com/r/devmtl/webhook/tags

You should use **this tag format** in production.<br>
`${VERSION} _ ${DATE} _ ${HASH-COMMIT}` 

```
devmtl/webhook:2.6.9_2019-08-29_23H00s56_a54f96b
```

These tags are also available to try stuff quickly:

```
devmtl/webhook:2.6.9
devmtl/webhook:stable
devmtl/webhook:latest
```

## Related docker images

[See README-related.md](./README-related.md)

</p>
</details>

## Website hosting

If you are looking for an alternative to WordPress, [Ghost](https://firepress.org/en/faq/#what-is-ghost) might be the CMS you are looking for. Check out our [hosting plans](https://firepress.org/en).

![ghost-v2-review](https://user-images.githubusercontent.com/6694151/64218253-f144b300-ce8e-11e9-8d75-312a2b6a3160.gif)


## Why, Contributing, License

<details><summary>Expand content (click here).</summary>
<p>

## Why all this work?

Our [mission](https://firepress.org/en/our-mission/) is to empower freelancers and small organizations to build an outstanding mobile-first website.

Because we believe your website should speak up in your name, we consider our mission completed once your site has become your impresario.

Find me on Twitter [@askpascalandy](https://twitter.com/askpascalandy).

— [The FirePress Team](https://firepress.org/) 🔥📰

## Contributing

The power of communities pull request and forks means that `1 + 1 = 3`. You can help to make this repo a better one! Here is how:

1. Fork it
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request

Check this post for more details: [Contributing to our Github project](https://pascalandy.com/blog/contributing-to-our-github-project/). Also, by contributing you agree to the [Contributor Code of Conduct on GitHub](https://pascalandy.com/blog/contributor-code-of-conduct-on-github/). 

## License

- This git repo is under the **GNU V3** license. [Find it here](./LICENSE).

</p>
</details>
