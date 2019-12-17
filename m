Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94DCD122AD2
	for <lists+ceph-devel@lfdr.de>; Tue, 17 Dec 2019 12:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbfLQL7p (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 17 Dec 2019 06:59:45 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:41683 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726571AbfLQL7p (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 17 Dec 2019 06:59:45 -0500
Received: by mail-qv1-f67.google.com with SMTP id x1so2730412qvr.8
        for <ceph-devel@vger.kernel.org>; Tue, 17 Dec 2019 03:59:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8lX39ZdJAczCwFSX5c6ypakB6wmql41+hIyuRlLj2JI=;
        b=sXgw7yhubkwUb9gYqRX/+Fe9M9zDh2xN0NcJCvKHrlb7+AOaw1Jcy/YN/C0ZCgrMbg
         qq7rsZmwY6mOhfnT9n1A+8QceUCBAwTuginYx2bn9xbCN4/blG3AjHX/5zdHXUNbuuPU
         G2wpLYO+5vtYIcPFzK/Xm5IcVFn+C4v9F+A9PVtH7FntT541CKWPkBuYZfGTbBM3LxJj
         drcExpV9PA+WV7BLowRJVOy+eeTdr6czhgsTJYWQeCZD2AqD1GG8k0Byonpe8/bHSzP2
         p/uUMYFxtuUnxV3bu2w6bo4XtOBw7FIlE00x5JEl7bOUIZret4RanXxlwqJuYN4TMG2o
         /Lvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8lX39ZdJAczCwFSX5c6ypakB6wmql41+hIyuRlLj2JI=;
        b=ctfkeorlXIN70MKuIxc5st3LaAujIQ6btdj1Oycn1XvYYZIAEA0wZ4NzWaOgQ41Qu3
         RF3KisN274PaUCkn6Hq9Nzi+mxHXBnOEzkTrNP0DXzJWphMB4S71QD1vhbfnA2H0/oVv
         4MswpOVPeVVkY0xbz+QzgIFysiVcn3nrIn6VJw3u28RngEhjHiLEFfLH3ZrBXL2bA4uY
         iK1kClGrMzGLFyF5uyLVzMpqKXhh0vgruIVJMkGSSSgTdMXUMJiY+nVICjObBeh+oqRg
         2KAjxTQ1VJoKX31E1cM6+KervVZEAZNyKcsHEvgUeajnRl6pLIlsRnIFogunA7aqgP/T
         Wy3g==
X-Gm-Message-State: APjAAAXVrdiUJy+I1iVeci4mbTJWsnFi4E5OmK1wGstcdmvae/sObL8q
        pxaFH66iJ9dkK3CwZoQ9YINbvxBt0YWLK9W7y8s=
X-Google-Smtp-Source: APXvYqxHbMehZI3KJuBQ0w7jSefb5PLMAb63zostmvc/AftjSTma4avMXwg/DjIHifg9rp3LSCnB6o4wZLFAddYQH0M=
X-Received: by 2002:a0c:b515:: with SMTP id d21mr4235132qve.106.1576583984022;
 Tue, 17 Dec 2019 03:59:44 -0800 (PST)
MIME-Version: 1.0
References: <20191212142717.23656-1-jlayton@kernel.org>
In-Reply-To: <20191212142717.23656-1-jlayton@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Tue, 17 Dec 2019 19:59:32 +0800
Message-ID: <CAAM7YA=Csi3+0AsR2Sa7cUVQQ0ME7VPcAugcPC=LesUBFV9zuw@mail.gmail.com>
Subject: Re: [PATCH] ceph: don't clear I_NEW until inode metadata is fully populated
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.com>,
        Zheng Yan <zyan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Dec 12, 2019 at 10:28 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> Currently, we could have an open-by-handle (or NFS server) call
> into the filesystem and start working with an inode before it's
> properly filled out.
>
> Don't clear I_NEW until we have filled out the inode, and discard it
> properly if that fails. Note that we occasionally take an extra
> reference to the inode to ensure that we don't put the last reference in
> discard_new_inode, but rather leave it for ceph_async_iput.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/inode.c | 25 +++++++++++++++++++++----
>  1 file changed, 21 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 5bdc1afc2bee..11672f8192b9 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -55,11 +55,9 @@ struct inode *ceph_get_inode(struct super_block *sb, struct ceph_vino vino)
>         inode = iget5_locked(sb, t, ceph_ino_compare, ceph_set_ino_cb, &vino);
>         if (!inode)
>                 return ERR_PTR(-ENOMEM);
> -       if (inode->i_state & I_NEW) {
> +       if (inode->i_state & I_NEW)
>                 dout("get_inode created new inode %p %llx.%llx ino %llx\n",
>                      inode, ceph_vinop(inode), (u64)inode->i_ino);
> -               unlock_new_inode(inode);
> -       }
>
>         dout("get_inode on %lu=%llx.%llx got %p\n", inode->i_ino, vino.ino,
>              vino.snap, inode);
> @@ -88,6 +86,10 @@ struct inode *ceph_get_snapdir(struct inode *parent)
>         inode->i_fop = &ceph_snapdir_fops;
>         ci->i_snap_caps = CEPH_CAP_PIN; /* so we can open */
>         ci->i_rbytes = 0;
> +
> +       if (inode->i_state & I_NEW)
> +               unlock_new_inode(inode);
> +
>         return inode;
>  }
>
> @@ -1301,7 +1303,6 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
>                         err = PTR_ERR(in);
>                         goto done;
>                 }
> -               req->r_target_inode = in;
>
>                 err = fill_inode(in, req->r_locked_page, &rinfo->targeti, NULL,
>                                 session,
> @@ -1311,8 +1312,13 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
>                 if (err < 0) {
>                         pr_err("fill_inode badness %p %llx.%llx\n",
>                                 in, ceph_vinop(in));
> +                       if (in->i_state & I_NEW)
> +                               discard_new_inode(in);
>                         goto done;
>                 }
> +               req->r_target_inode = in;
> +               if (in->i_state & I_NEW)
> +                       unlock_new_inode(in);
>         }
>
>         /*
> @@ -1496,7 +1502,12 @@ static int readdir_prepopulate_inodes_only(struct ceph_mds_request *req,
>                 if (rc < 0) {
>                         pr_err("fill_inode badness on %p got %d\n", in, rc);
>                         err = rc;
> +                       ihold(in);
> +                       discard_new_inode(in);
no check for I_NEW?

> +               } else if (in->i_state & I_NEW) {
> +                       unlock_new_inode(in);
>                 }
> +
>                 /* avoid calling iput_final() in mds dispatch threads */
>                 ceph_async_iput(in);
>         }
> @@ -1698,12 +1709,18 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
>                         if (d_really_is_negative(dn)) {
>                                 /* avoid calling iput_final() in mds
>                                  * dispatch threads */
> +                               if (in->i_state & I_NEW) {
> +                                       ihold(in);
> +                                       discard_new_inode(in);
> +                               }
>                                 ceph_async_iput(in);
>                         }
>                         d_drop(dn);
>                         err = ret;
>                         goto next_item;
>                 }
> +               if (in->i_state & I_NEW)
> +                       unlock_new_inode(in);
>
>                 if (d_really_is_negative(dn)) {
>                         if (ceph_security_xattr_deadlock(in)) {
> --
> 2.23.0
>
