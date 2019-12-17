Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71199122EC6
	for <lists+ceph-devel@lfdr.de>; Tue, 17 Dec 2019 15:31:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728299AbfLQObe (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 17 Dec 2019 09:31:34 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:38950 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727855AbfLQObe (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 17 Dec 2019 09:31:34 -0500
Received: by mail-qv1-f65.google.com with SMTP id y8so4232296qvk.6
        for <ceph-devel@vger.kernel.org>; Tue, 17 Dec 2019 06:31:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R7qazf8k6/d4lYDggVbAjcqGZSW7PV4m+7zt8qavMKM=;
        b=ESv6PNxWEZGU15goZifOOJI7xs3IozvuZGhBraN9jle1hr9ON1yYpzIoCYE5MCAur1
         SXMNiFU/oP57KsXgzY7YxJf0w4MTMDx+p03zqrTqXK5joeAJMEpVKN/3/+ovC71PYhB1
         Glaqk8pObGuX1go1ptNO4AGhI0h2QzaWBU3VLdlOJjgobD79isK4M0xmykrkNcAXEc2l
         o+aCOpJQADIW/dzwiCxTf7wRNAa3sxNX5fn38rWKlGtM3c7NHZU/Wef7TOs6TU03eIrH
         3M3Ug8VDC9iwVCcUrPHMqeGBK22OOZsP2Qt4Rl8VOkBSasT9/dktT4hwSqoP5E8Kq86X
         tjHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R7qazf8k6/d4lYDggVbAjcqGZSW7PV4m+7zt8qavMKM=;
        b=SL+qDqDgJ0TT6z9RzP5Yjv3VohuA6zb8sbNofcBLqY+bkP/cgfRCw8fyKhrsPts59L
         4EfltOV/bM8H4ixAUP3KSDoXwL95DbaV6+1jxHrsglBSXZGRVIjGNgt/xt/HbefxUxvV
         mkg3vIXUyWG3zA8Q8XdAwPc1MpX114qLSYHXE784SAdivffrnxHWewizJrBcYkE73c3G
         hYShcJJLYYs8RS9L5Cf/dCuoDUjFY0Z/BgTwU5Z3OOalmLIrORwrq5jQNPEgPVZcp/gU
         yO9FyuAcp/50aztTey+X3ZeUWdb7G3zLPFu1aRrpNiA2Z/sl3HXxuoORyUmkN+XNSreQ
         4iyQ==
X-Gm-Message-State: APjAAAUcrNxW2TdYH9akhUJPJ6qDpZuaXKsdWkWazixRayVnEyFMQ29/
        P88fNsrXzl4O0mrRjtl0CZWxFjneKXmnLFOnxKc=
X-Google-Smtp-Source: APXvYqzYyCnmp06zgDu3zautIP1vKEZ73tc/sQo6sm0rqxVwGyPip4EfHjDlQZOAe39F7UzsfVEZo6qE1ROV0nc+DeQ=
X-Received: by 2002:ad4:5525:: with SMTP id ba5mr4739928qvb.117.1576593092642;
 Tue, 17 Dec 2019 06:31:32 -0800 (PST)
MIME-Version: 1.0
References: <20191212142717.23656-1-jlayton@kernel.org> <20191217135059.22402-1-jlayton@kernel.org>
In-Reply-To: <20191217135059.22402-1-jlayton@kernel.org>
From:   "Yan, Zheng" <ukernel@gmail.com>
Date:   Tue, 17 Dec 2019 22:31:21 +0800
Message-ID: <CAAM7YAm4OiYyiC4dfH+PRypyC45QtQZWbTSd8PqZRziQutxdgQ@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: don't clear I_NEW until inode metadata is fully populated
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.com>,
        Zheng Yan <zyan@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Dec 17, 2019 at 9:53 PM Jeff Layton <jlayton@kernel.org> wrote:
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
>  fs/ceph/inode.c | 27 +++++++++++++++++++++++----
>  1 file changed, 23 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 5bdc1afc2bee..64634c5af403 100644
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

I wonder if it's better to move these code into fill_inode()?

>         }
>
>         /*
> @@ -1496,7 +1502,14 @@ static int readdir_prepopulate_inodes_only(struct ceph_mds_request *req,
>                 if (rc < 0) {
>                         pr_err("fill_inode badness on %p got %d\n", in, rc);
>                         err = rc;
> +                       if (in->i_state & I_NEW) {
> +                               ihold(in);
> +                               discard_new_inode(in);
> +                       }
> +               } else if (in->i_state & I_NEW) {
> +                       unlock_new_inode(in);
>                 }
> +
>                 /* avoid calling iput_final() in mds dispatch threads */
>                 ceph_async_iput(in);
>         }
> @@ -1698,12 +1711,18 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
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
