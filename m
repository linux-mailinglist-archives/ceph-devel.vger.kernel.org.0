Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D16A16BEF7
	for <lists+ceph-devel@lfdr.de>; Tue, 25 Feb 2020 11:39:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730336AbgBYKjq (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 25 Feb 2020 05:39:46 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:45556 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729417AbgBYKjq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 25 Feb 2020 05:39:46 -0500
Received: by mail-io1-f66.google.com with SMTP id w9so945120iob.12
        for <ceph-devel@vger.kernel.org>; Tue, 25 Feb 2020 02:39:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=emKWni3n9XbtAMERNtuPJABhS9GINFpOTurUafhLJl4=;
        b=ZY/OfKjBeRMnpRYlTDuhqJPypoNmR6qbsx0c7+AAMuY37LIggJ19G6ATae65ogrPLa
         7cuh8v1D2lLiVU+TnzSk4P18gGOWEKgc1S3IhXHfxlPGuxh3Fz0MYiTrBYJZifvOcVsB
         EUvCQmUbOuwVtNd3T8I4+eWufU3BGymvcCDspN38FCY/bZFL9sPxNyYgPh7H/OT+XKiO
         c+gjgI5Qq2mh9jNaGdg9w8RYnE2a+LNMI74afr5iYagw5X9x+RXtpCoPv4T6iMAMtHSg
         pPun00OSrSaNRBVpuV/wEe9rJdpjhG7zNB7/hvkNfMesTfchwF1rNWFVDt3TxddI4yJA
         AMFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=emKWni3n9XbtAMERNtuPJABhS9GINFpOTurUafhLJl4=;
        b=s6N2n+16hSoGf/smYsVQokQ84aME8FqSQvw9J/mfGzkHQZsjTcev4xTKGxh1vMJ+20
         8+0+zxHkPIh2xg9TGI2waTSx9L5xXbUeo2LI/6BVA9PhYpovCB+qzkuzfVjJWfgwd7I0
         DxXKNpzFYAiG8rXzdWl6DMYP4qEs0u3iix5WM3SQNY8dskFwbJ4VBhtFfLgV7HdaW8dP
         zmzB6gzYtOCkN4WNg94BscWHvZQE/GdxPxPGPgCvq2BHjQTgzIAc/nDNtjzllCqF8hgC
         K2+4LQC26/2H1FB3f8sqS2ruklal1wJyN55NClHyF2Z1Wxsc4KmM20WBD7M0TIh/Q7Uz
         361w==
X-Gm-Message-State: APjAAAVTFAPcUm5eDO3IAxZgqW4dW6+GmVt5KA3iH8ZDA6xGnYktqMWE
        vCFzIsi2aiXs9FOfvbaYfGIC+qBDcKEgXhdlATkqhvLZbm8=
X-Google-Smtp-Source: APXvYqydzV9uAiqnrRb4Rxl3hM1XbHILzUFaXlUhdo1iDmkY4S3Uw3IM0SQDPHvDBIxpvtAa1X8lKgMO7qyj1rUwFLo=
X-Received: by 2002:a02:cd12:: with SMTP id g18mr57799604jaq.76.1582627185395;
 Tue, 25 Feb 2020 02:39:45 -0800 (PST)
MIME-Version: 1.0
References: <20200225033013.4832-1-xiubli@redhat.com>
In-Reply-To: <20200225033013.4832-1-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 25 Feb 2020 11:39:36 +0100
Message-ID: <CAOi1vP8J9UaTM+FLHuBVoy_O4mwc=+VK0sCjA=VpAwPhBWBLiw@mail.gmail.com>
Subject: Re: [PATCH] ceph: show more detail logs during mount
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

On Tue, Feb 25, 2020 at 4:30 AM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> Print the logs in error level to give a helpful hint to make it
> more user-friendly to debug.
>
> URL: https://tracker.ceph.com/issues/44215
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/super.c       | 8 ++++++--
>  net/ceph/mon_client.c | 2 ++
>  2 files changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index c7f150686a53..e33c2f86647b 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -905,8 +905,10 @@ static struct dentry *ceph_real_mount(struct ceph_fs_client *fsc,
>                                      fsc->mount_options->server_path + 1 : "";
>
>                 err = __ceph_open_session(fsc->client, started);
> -               if (err < 0)
> +               if (err < 0) {
> +                       pr_err("mount joining the ceph cluster fail %d\n", err);
>                         goto out;
> +               }
>
>                 /* setup fscache */
>                 if (fsc->mount_options->flags & CEPH_MOUNT_OPT_FSCACHE) {
> @@ -922,6 +924,8 @@ static struct dentry *ceph_real_mount(struct ceph_fs_client *fsc,
>                 root = open_root_dentry(fsc, path, started);
>                 if (IS_ERR(root)) {
>                         err = PTR_ERR(root);
> +                       pr_err("mount opening the root directory fail %d\n",
> +                              err);

Hi Xiubo,

Given that these are new user-level filesystem log messages, they
should probably go into fs_context log.

>                         goto out;
>                 }
>                 fsc->sb->s_root = dget(root);
> @@ -1079,7 +1083,7 @@ static int ceph_get_tree(struct fs_context *fc)
>
>  out_splat:
>         if (!ceph_mdsmap_is_cluster_available(fsc->mdsc->mdsmap)) {
> -               pr_info("No mds server is up or the cluster is laggy\n");
> +               pr_err("No mds server is up or the cluster is laggy\n");
>                 err = -EHOSTUNREACH;
>         }

If you are changing this one, it should be directed to fs_context log
as well.

>
> diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
> index 9d9e4e4ea600..6f1372f5f2a7 100644
> --- a/net/ceph/mon_client.c
> +++ b/net/ceph/mon_client.c
> @@ -1179,6 +1179,8 @@ static void handle_auth_reply(struct ceph_mon_client *monc,
>
>         if (ret < 0) {
>                 monc->client->auth_err = ret;
> +               pr_err("authenticate fail on mon%d %s\n", monc->cur_mon,
> +                       ceph_pr_addr(&monc->con.peer_addr));

I don't think this is needed.  Authentication errors are already logged
in ceph_handle_auth_reply().

Thanks,

                Ilya
