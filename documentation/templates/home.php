<?php $this->layout('theme::layout/00_layout') ?>
<div class="navbar navbar-static-top hidden-print">
    <div class="container">
        <?php $this->insert('theme::partials/navbar_content', ['params' => $params]); ?>
    </div>
</div>
<?php if ($params['html']['repo']) { ?>
    <a href="https://github.com/<?= $params['html']['repo']; ?>" target="_blank" id="github-ribbon" class="hidden-print"><img src="https://s3.amazonaws.com/github/ribbons/forkme_right_darkblue_121621.png" alt="Fork me on GitHub"></a>
<?php } ?>

<div class="homepage-hero container-fluid">
    <div class="container">
        <div class="row">
            <div class="text-center col-sm-12">
                <?php if ($params['tagline']) {
                    echo '<h2>' . $params['tagline'] . '</h2>';
                } ?>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-10 col-sm-offset-1">
                <?php if ($params['image']) {
                    echo '<img class="homepage-image img-responsive" src="' . $params['image'] . '" alt="' . $params['title'] . '">';
                } ?>
            </div>
        </div>
    </div>
</div>

<div class="homepage-content container-fluid">
    <div class="container">
        <div class="row">
            <div class="col-sm-10 col-sm-offset-1">
                <?= $page['content']; ?>
            </div>
        </div>
    </div>
</div>
