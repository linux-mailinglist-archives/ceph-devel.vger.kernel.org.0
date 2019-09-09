Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2399DAD742
	for <lists+ceph-devel@lfdr.de>; Mon,  9 Sep 2019 12:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729250AbfIIKwD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 9 Sep 2019 06:52:03 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:34205 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbfIIKwD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 9 Sep 2019 06:52:03 -0400
Received: by mail-io1-f68.google.com with SMTP id k13so12287865ioj.1;
        Mon, 09 Sep 2019 03:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OumiOIJEPhPfHX5dK0P0xxTqIrTCWsgzAGpuo1pQXeg=;
        b=mDA4y0M2Q3oyouELzAP3Ak2NyxthvX8OJhQpGK1GnqHjCGcJ4AtOcNxROPKPTpgVM6
         VZ86/KZO9GJebgJztvrx9OlcqE7Rp+ybceqg79HrvJdaSCOMXlxXpvOSCtyROLB5TORd
         RmWggneA4xEo3bq9FTfIrmDBFG72c2b7jlXFGdpPF5nYsfxgWFfj72iOQno2U+5NOyqd
         fybSPJjUhtbbf2BmG333F2yTWjYL0NXNfR6yR2uzDqc4zWa7O87cukU7YKl9fvqS+nEx
         3RSQI4mw+TXAbi16bTK7MaJOy6OD0U8hL3LwReSPHYZASmL8qTTSxGf1citkc/D0l9l1
         1+mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OumiOIJEPhPfHX5dK0P0xxTqIrTCWsgzAGpuo1pQXeg=;
        b=ehbn7Vu0pvZMtCKSRM7Khfv+WoHjMG7KkDo37Whq81Kgaw2vFcv4QswEbm5+lfYlTC
         hpeCYTMPg/SN0svRGGmgZ4WddsJFxPL2j4WWenovawAth1DpQrqOJrZlV62PjSMjr5jL
         tc1Ag1FsAljDvxX+ZchnYqQBlvHPborcQqk4dZXW9OBezng+Ao8YE8WA5ytWJ/1ImFwa
         pgAwiLrTUnoruY/mbQ8b+AFUzy9yigL5/50LlawLc14vib6GKd9SFV/RpfgQuzIbexIf
         iyn/EhsDaAH/BGawK8mUvdLsy5/3siQCHNNpgFrNIqMLTdkjGVA+SY7y3fJnxht74MFr
         Ol1Q==
X-Gm-Message-State: APjAAAXY7rIyStII0SYJsE+0pVJjB6tH78ETv9MR71jbKm27UHy6sapj
        S9JKi9aybDDXhBgUDniLwjPenOlSB/3wAtj2okQ=
X-Google-Smtp-Source: APXvYqwFPsE8JsUrp2ZeKXcrvB1Q5sFoC493FNbafm+vzdNQ+EUQwm2iO3gFZGTHsz0H5knM8OkwKM/uM88ZiqcMdQE=
X-Received: by 2002:a5e:d60e:: with SMTP id w14mr1974094iom.215.1568026322276;
 Mon, 09 Sep 2019 03:52:02 -0700 (PDT)
MIME-Version: 1.0
References: <87k1ahojri.fsf@suse.com> <20190909102834.16246-1-lhenriques@suse.com>
In-Reply-To: <20190909102834.16246-1-lhenriques@suse.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 9 Sep 2019 12:51:55 +0200
Message-ID: <CAOi1vP-3fM8ZTKAOTY0E7ZQUU+wr=TaBhg-=vUWCSDBdFU0WmQ@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: allow object copies across different filesystems
 in the same cluster
To:     Luis Henriques <lhenriques@suse.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Sep 9, 2019 at 12:29 PM Luis Henriques <lhenriques@suse.com> wrote:
>
> OSDs are able to perform object copies across different pools.  Thus,
> there's no need to prevent copy_file_range from doing remote copies if the
> source and destination superblocks are different.  Only return -EXDEV if
> they have different fsid (the cluster ID).
>
> Signed-off-by: Luis Henriques <lhenriques@suse.com>
> ---
>  fs/ceph/file.c | 18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)
>
> Hi,
>
> Here's the patch changelog since initial submittion:
>
> - Dropped have_fsid checks on client structs
> - Use %pU to print the fsid instead of raw hex strings (%*ph)
> - Fixed 'To:' field in email so that this time the patch hits vger
>
> Cheers,
> --
> Luis
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 685a03cc4b77..4a624a1dd0bb 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -1904,6 +1904,7 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
>         struct ceph_inode_info *src_ci = ceph_inode(src_inode);
>         struct ceph_inode_info *dst_ci = ceph_inode(dst_inode);
>         struct ceph_cap_flush *prealloc_cf;
> +       struct ceph_fs_client *src_fsc = ceph_inode_to_client(src_inode);
>         struct ceph_object_locator src_oloc, dst_oloc;
>         struct ceph_object_id src_oid, dst_oid;
>         loff_t endoff = 0, size;
> @@ -1915,8 +1916,17 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
>
>         if (src_inode == dst_inode)
>                 return -EINVAL;
> -       if (src_inode->i_sb != dst_inode->i_sb)
> -               return -EXDEV;
> +       if (src_inode->i_sb != dst_inode->i_sb) {
> +               struct ceph_fs_client *dst_fsc = ceph_inode_to_client(dst_inode);
> +
> +               if (ceph_fsid_compare(&src_fsc->client->fsid,
> +                                     &dst_fsc->client->fsid)) {
> +                       dout("Copying object across different clusters:");
> +                       dout("  src fsid: %pU dst fsid: %pU\n",
> +                            &src_fsc->client->fsid, &dst_fsc->client->fsid);

Hi Luis,

This should be a single dout.

Thanks,

                Ilya
