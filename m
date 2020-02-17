Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A639616151C
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Feb 2020 15:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729223AbgBQOwJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 17 Feb 2020 09:52:09 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:36820 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728375AbgBQOwJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 17 Feb 2020 09:52:09 -0500
Received: by mail-io1-f65.google.com with SMTP id d15so18720548iog.3
        for <ceph-devel@vger.kernel.org>; Mon, 17 Feb 2020 06:52:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZdUWVF1+EdJoFrgsRc/fHZy8lP/rutiJ4mJ7XJz3W3c=;
        b=QuyFLYudubIxQuX1jDqfXvfVZELpKJ5sxIEgJi/Cw/RigvvBWzU0ESArsmU/sinHgT
         J8Fx2OVd1kKXP+awc8GbRaj4ErztMosNY4/7yCVA610NUaxeqhNFm/HzC5QmaL/YmCJ4
         R6ZWV7CqZncB+tRgScHcws2nmwju96sRZsBRaEqWpCnlI313HiMU6GflAwpHTT640o1u
         R5UH5iaSl3qTAQMauGjrkyVkG5UiDT+IrBaTrLPf4Usz+ZpzwmO2tphru0Ehfw4L+obX
         Ecb+JBVqc1y8z3wf27jOBoH8fJnm3WDPGvwLRkcKprOSu41nmkjLHQ+8irBl7NRGxxIx
         V71A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZdUWVF1+EdJoFrgsRc/fHZy8lP/rutiJ4mJ7XJz3W3c=;
        b=msJhVbG4BFBCZySx47v6yWwAOVGyLbEg21AT4UlE7cM/iXyJeKzToQCtnA86nOIV9T
         3zoRGLrrZFW6/Ye10hfmCwCGnhfaf3EoRNvvoM98iawlGKpmngQNaicaNJiFeEktpEKL
         bNZ9W6BzE/6kFU+J0uJB3fK6udgC8+Scvfvwxb2wrqSaQBzRbJoi/jL0QJGMXYN0C+fX
         doKdoAMMr5Ewild9ZHRMS2HQiaAhkUL0ZuehLQ7+tzsmaaBQvG/A+EBOy6VfUxWlQlIM
         Eum3BZlkI5ILF/XXYnuMdoiLFbvru12BtBXPlTTBO148v/LZ20YcEa6jUEI+ukm4R7e0
         NxKw==
X-Gm-Message-State: APjAAAUwn6zuNVYlpC9RVeToId/u0ghPPXc+p/3PlqwapFdWfaRlR+KP
        gRmDwxAQzmopS00A7YKuCEBmFVF/J3O0usbwYns=
X-Google-Smtp-Source: APXvYqyE3kPtbIZJFAWwQi0kjqMda2S2q9dtF8SCIBGIa7Wh/Pv3wVkbFlE6holiyVLVbTkMc+Uw5H7kdNQiJoRyHtQ=
X-Received: by 2002:a6b:1781:: with SMTP id 123mr11725360iox.282.1581951128158;
 Mon, 17 Feb 2020 06:52:08 -0800 (PST)
MIME-Version: 1.0
References: <20200217112806.30738-1-xiubli@redhat.com>
In-Reply-To: <20200217112806.30738-1-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 17 Feb 2020 15:52:33 +0100
Message-ID: <CAOi1vP_bCGoni+tmvVri6Gcv7QRN4+qvHUrrweHLpnTyAzQw=A@mail.gmail.com>
Subject: Re: [PATCH] ceph: fix dout logs for null pointers
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

On Mon, Feb 17, 2020 at 12:28 PM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> For example, if dentry and inode is NULL, the log will be:
> ceph:  lookup result=000000007a1ca695
> ceph:  submit_request on 0000000041d5070e for inode 000000007a1ca695
>
> The will be confusing without checking the corresponding code carefully.
>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/dir.c        | 2 +-
>  fs/ceph/mds_client.c | 6 +++++-
>  2 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index ffeaff5bf211..245a262ec198 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -798,7 +798,7 @@ static struct dentry *ceph_lookup(struct inode *dir, struct dentry *dentry,
>         err = ceph_handle_snapdir(req, dentry, err);
>         dentry = ceph_finish_lookup(req, dentry, err);
>         ceph_mdsc_put_request(req);  /* will dput(dentry) */
> -       dout("lookup result=%p\n", dentry);
> +       dout("lookup result=%d\n", err);
>         return dentry;
>  }
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index b6aa357f7c61..e34f159d262b 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2772,7 +2772,11 @@ int ceph_mdsc_submit_request(struct ceph_mds_client *mdsc, struct inode *dir,
>                 ceph_get_cap_refs(ceph_inode(req->r_old_dentry_dir),
>                                   CEPH_CAP_PIN);
>
> -       dout("submit_request on %p for inode %p\n", req, dir);
> +       if (dir)
> +               dout("submit_request on %p for inode %p\n", req, dir);
> +       else
> +               dout("submit_request on %p\n", req);

Hi Xiubo,

It's been this way for a couple of years now.  There are a lot more
douts in libceph, ceph and rbd that are sometimes fed NULL pointers.
I don't think replacing them with conditionals is the way forward.

I honestly don't know what security concern is addressed by hashing
NULL pointers, but that is what we have...  Ultimately, douts are just
for developers, and when you find yourself having to chase individual
pointers, you usually have a large enough piece of log to figure out
what the NULL hash is.

Thanks,

                Ilya
