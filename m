Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00C1515A57D
	for <lists+ceph-devel@lfdr.de>; Wed, 12 Feb 2020 10:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728843AbgBLJ7j (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 Feb 2020 04:59:39 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:35739 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728734AbgBLJ7i (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 12 Feb 2020 04:59:38 -0500
Received: by mail-io1-f65.google.com with SMTP id h8so1562296iob.2
        for <ceph-devel@vger.kernel.org>; Wed, 12 Feb 2020 01:59:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VYjmkygREKbun2vHuJy2CoKN6Z4b0yoGmRNdOTMUGUg=;
        b=PqfKRAsL/DPOqCppDXF4GHl31WDFtQO/PjHs8V7oWJSjICv0oxDxXR9FrYq6SKZGrF
         Xwmnu1OnACg8E+r0RkTT5AaFUoRA9GaARluN4aSQ/cMo875pan7WtcGFCvoEGNsiD2xF
         tKMh36Ket4mbZC8vud1dw/dCvsYEJJ9OeG7du/mJBDeW6zwPu/n728xQaDIgPaomhiE+
         pNmPtCR/PcuIfEij0uMLo3g22fqbNjVaL6NCvsvSE+36FuU2stbcxD7j8swpgIrJHG7d
         pd66IdJgRVlgtmAyGoqlVekMm042ZlZ3vAzvgjBjiQAMqP64G3T5CRgIHr/lW5p5auih
         HYQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VYjmkygREKbun2vHuJy2CoKN6Z4b0yoGmRNdOTMUGUg=;
        b=JWnfQlEkqLtRnUsCh6yIqCo2RYC9+PzCiGk0qHZxqawxSpCcjVT6yz+VGr3BvDx7Ic
         IJh3WYHq3FpoHB4bqEBc587z8LqVtbsObHYSbfpekXh3N+V6KIZ29+tdVTVEyC3SAacF
         diBdZi5xv3hOXVAb7zjq7dpfXIZWCT4orNC2ToLth3xHGx0Vz5hvxnbiQX6Ntqy+NmAX
         k0LbAgpFb+G3m+Qe5PpWBYpht0j1acZSlu675Dnh1Z5CdrtaJXyvgkxnITbscWqfdmWO
         X42f2FyqgLnldZq7ogZFcRavD7mQSc3AnRNvyq0anfB8Vl0S9TVy0jri9NKM/Y9NIHDa
         mmUA==
X-Gm-Message-State: APjAAAUjE0BUcK9BMsnyzcbz+Hrbw21TApaQ0AlY5Iy9n57bMtzKd81A
        3g04kdTVn+Bm7THfto7tERj7PxFm6yPbKsZmzv0=
X-Google-Smtp-Source: APXvYqzzu1tcdODslK50lTbrGtBMt3e1EXpKE9O/5AGjiTrE++bbTP6Ra1y3prI3n43zpH85nn/Mk/jicdsMRaDn1CA=
X-Received: by 2002:a02:8587:: with SMTP id d7mr17964813jai.39.1581501578195;
 Wed, 12 Feb 2020 01:59:38 -0800 (PST)
MIME-Version: 1.0
References: <20200212082435.18118-1-xiubli@redhat.com>
In-Reply-To: <20200212082435.18118-1-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 12 Feb 2020 10:59:57 +0100
Message-ID: <CAOi1vP88LOiZ051+xNkPTaxb0Z=iM=Ygs=reW3EQwOyRpyON0A@mail.gmail.com>
Subject: Re: [PATCH] ceph: remove CEPH_MOUNT_OPT_FSCACHE flag
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Feb 12, 2020 at 9:24 AM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> Since we can figure out whether the fscache is enabled or not by
> using the fscache_uniq and this flag is redundant.
>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/super.c | 9 +++------
>  fs/ceph/super.h | 9 ++++-----
>  2 files changed, 7 insertions(+), 11 deletions(-)
>
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 48f86eb82b9b..8df506dd9039 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -383,10 +383,7 @@ static int ceph_parse_mount_param(struct fs_context *fc,
>  #ifdef CONFIG_CEPH_FSCACHE
>                 kfree(fsopt->fscache_uniq);
>                 fsopt->fscache_uniq = NULL;
> -               if (result.negated) {
> -                       fsopt->flags &= ~CEPH_MOUNT_OPT_FSCACHE;
> -               } else {
> -                       fsopt->flags |= CEPH_MOUNT_OPT_FSCACHE;
> +               if (!result.negated) {
>                         fsopt->fscache_uniq = param->string;
>                         param->string = NULL;
>                 }
> @@ -605,7 +602,7 @@ static int ceph_show_options(struct seq_file *m, struct dentry *root)
>                 seq_puts(m, ",nodcache");
>         if (fsopt->flags & CEPH_MOUNT_OPT_INO32)
>                 seq_puts(m, ",ino32");
> -       if (fsopt->flags & CEPH_MOUNT_OPT_FSCACHE) {
> +       if (fsopt->fscache_uniq) {
>                 seq_show_option(m, "fsc", fsopt->fscache_uniq);
>         }
>         if (fsopt->flags & CEPH_MOUNT_OPT_NOPOOLPERM)
> @@ -969,7 +966,7 @@ static struct dentry *ceph_real_mount(struct ceph_fs_client *fsc,
>                         goto out;
>
>                 /* setup fscache */
> -               if (fsc->mount_options->flags & CEPH_MOUNT_OPT_FSCACHE) {
> +               if (fsc->mount_options->fscache_uniq) {
>                         err = ceph_fscache_register_fs(fsc, fc);
>                         if (err < 0)
>                                 goto out;
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index ebc25072b19b..ad44b98f3c3b 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -38,11 +38,10 @@
>  #define CEPH_MOUNT_OPT_NOASYNCREADDIR  (1<<7) /* no dcache readdir */
>  #define CEPH_MOUNT_OPT_INO32           (1<<8) /* 32 bit inos */
>  #define CEPH_MOUNT_OPT_DCACHE          (1<<9) /* use dcache for readdir etc */
> -#define CEPH_MOUNT_OPT_FSCACHE         (1<<10) /* use fscache */
> -#define CEPH_MOUNT_OPT_NOPOOLPERM      (1<<11) /* no pool permission check */
> -#define CEPH_MOUNT_OPT_MOUNTWAIT       (1<<12) /* mount waits if no mds is up */
> -#define CEPH_MOUNT_OPT_NOQUOTADF       (1<<13) /* no root dir quota in statfs */
> -#define CEPH_MOUNT_OPT_NOCOPYFROM      (1<<14) /* don't use RADOS 'copy-from' op */
> +#define CEPH_MOUNT_OPT_NOPOOLPERM      (1<<10) /* no pool permission check */
> +#define CEPH_MOUNT_OPT_MOUNTWAIT       (1<<11) /* mount waits if no mds is up */
> +#define CEPH_MOUNT_OPT_NOQUOTADF       (1<<12) /* no root dir quota in statfs */
> +#define CEPH_MOUNT_OPT_NOCOPYFROM      (1<<13) /* don't use RADOS 'copy-from' op */
>
>  #define CEPH_MOUNT_OPT_DEFAULT                 \
>         (CEPH_MOUNT_OPT_DCACHE |                \

Hi Xiubo,

Did you test this both with and without supplying a uniquifier (i.e.
both "-o fsc=<uniquifier>" and "-o fsc" cases?  I'm pretty sure this
breaks "-o fsc" case...

Thanks,

                Ilya
