Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E85902B253E
	for <lists+ceph-devel@lfdr.de>; Fri, 13 Nov 2020 21:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbgKMUQJ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 13 Nov 2020 15:16:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgKMUQJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 13 Nov 2020 15:16:09 -0500
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C032C0613D1
        for <ceph-devel@vger.kernel.org>; Fri, 13 Nov 2020 12:16:09 -0800 (PST)
Received: by mail-io1-xd41.google.com with SMTP id j12so11083652iow.0
        for <ceph-devel@vger.kernel.org>; Fri, 13 Nov 2020 12:16:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g6r4q1+/dR/r/p8WJ8cN7QHgIKtZyTZrsV/UOxfHnng=;
        b=qyBLlGFSWkx5kNfeEjHVxASszqbauTH62UwLRPplAeZsDOFa69b21KvzMI0PnggH9d
         Yh6UoKHTFRfQ06F7ocYK0bkTaAwXHAMCu/wYNWOIEsevIFRPTklEXA6dgU6kFcoqfogz
         RjWflVFxhG50+s4MHNb/6bdxw6dXgevY69u2Hi935qVMA1LgNvsbN3YEbMFXDSj36Etg
         JrmO17aUwdFvNPxFxOEFz4n+9b9ZDpTAnl6+TNqBQzsZNd6Q9JDiigMvl9TV61m05CQG
         yQ45KaO4Qa6RJwNe/EiKPkDteqx1ubXle6KAZ19aWjKQebI6a7jkR3crll3vPuVu3lI7
         LF9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g6r4q1+/dR/r/p8WJ8cN7QHgIKtZyTZrsV/UOxfHnng=;
        b=i2oomedOyStxIQNkORuod3p/T3LsuvKGQpGr08f7ofdYg+wd1WFukYy3RWS+kcUprz
         uPRnieIbP7AG+fUumtBATfLx2gspPQpinqByOztHEcisEC9raz0M9P1Ylo09+0iA7XqQ
         9OLVrxZXZqir7hrCkMFeAWuRVKHuL7FlTEmXtQ+meM6SW3vZ78DRIpTURP8xJUgQr0Ol
         yGmoyAobLIlYIaxKCigp2/y4AFBIQY6iRS5FH+NZK2t9J2c5ZV2DfxiesmPygUCRmQFQ
         2JRx/M7UKC3ueLThzCo9ngudx3G8hwnHurLbSYHZMIWigiomJqSD73+UIqyJapzqrkHJ
         DUgw==
X-Gm-Message-State: AOAM533YsgXtmx/sGNwViMCcqQWplgNfsJWvG6Ml7N5+HbyD2nmpMQBV
        A2aYA+WqqTmkKc5P1lPAPqtD8rJdx5uYQmMakGo=
X-Google-Smtp-Source: ABdhPJxOrjDH5N+voFr9vfsYtFkPEjG0cFN1mZIUjnuVMXwyBNjgqnVGsUM+8AcTVKV+XY1Q5maiW2+nl+JnDGQ6jqM=
X-Received: by 2002:a5d:8344:: with SMTP id q4mr1162205ior.182.1605298568439;
 Fri, 13 Nov 2020 12:16:08 -0800 (PST)
MIME-Version: 1.0
References: <20201111012940.468289-1-xiubli@redhat.com> <20201111012940.468289-3-xiubli@redhat.com>
 <CA+2bHPZuXcVw6Mwpz0wkg-SDsUc7XZqK0_m2eVQsQOEsQkZiGw@mail.gmail.com> <ce2207b20cdc5305bca62ce91bab85d3925afa38.camel@kernel.org>
In-Reply-To: <ce2207b20cdc5305bca62ce91bab85d3925afa38.camel@kernel.org>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 13 Nov 2020 21:16:09 +0100
Message-ID: <CAOi1vP-C3piyd04v52p0qRkWa1An+=V4ogyy4hZRxxCuSaynYg@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] ceph: add ceph.{cluster_fsid/client_id} vxattrs suppport
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Patrick Donnelly <pdonnell@redhat.com>,
        Xiubo Li <xiubli@redhat.com>, Zheng Yan <zyan@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Nov 13, 2020 at 8:45 PM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Fri, 2020-11-13 at 11:40 -0800, Patrick Donnelly wrote:
> > On Tue, Nov 10, 2020 at 5:29 PM <xiubli@redhat.com> wrote:
> > >
> > > From: Xiubo Li <xiubli@redhat.com>
> > >
> > > These two vxattrs will only exist in local client side, with which
> > > we can easily know which mountpoint the file belongs to and also
> > > they can help locate the debugfs path quickly.
> > >
> > > URL: https://tracker.ceph.com/issues/48057
> > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > ---
> > >  fs/ceph/xattr.c | 42 ++++++++++++++++++++++++++++++++++++++++++
> > >  1 file changed, 42 insertions(+)
> > >
> > > diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> > > index 0fd05d3d4399..e89750a1f039 100644
> > > --- a/fs/ceph/xattr.c
> > > +++ b/fs/ceph/xattr.c
> > > @@ -304,6 +304,23 @@ static ssize_t ceph_vxattrcb_snap_btime(struct ceph_inode_info *ci, char *val,
> > >                                 ci->i_snap_btime.tv_nsec);
> > >  }
> > >
> > > +static ssize_t ceph_vxattrcb_cluster_fsid(struct ceph_inode_info *ci,
> > > +                                         char *val, size_t size)
> > > +{
> > > +       struct ceph_fs_client *fsc = ceph_sb_to_client(ci->vfs_inode.i_sb);
> > > +
> > > +       return ceph_fmt_xattr(val, size, "%pU", &fsc->client->fsid);
> > > +}
> > > +
> > > +static ssize_t ceph_vxattrcb_client_id(struct ceph_inode_info *ci,
> > > +                                      char *val, size_t size)
> > > +{
> > > +       struct ceph_fs_client *fsc = ceph_sb_to_client(ci->vfs_inode.i_sb);
> > > +
> > > +       return ceph_fmt_xattr(val, size, "client%lld",
> > > +                             ceph_client_gid(fsc->client));
> > > +}
> >
> > Let's just have this return the id number. The caller can concatenate
> > that with "client" however they require. Otherwise, parsing it out is
> > needlessly troublesome.
> >
>
> That does seem nicer, but it would be inconsistent with the existing rbd
> attributes. Ilya, would you object?

I'm not married to it, but staying consistent would be good.  Yes,
it concatenates with "client" and yes, without a dot, but the kernel
client has been doing that for a very long time.  This behaviour
actually predates the rbd attributes I mentioned.

>
> > >  #define CEPH_XATTR_NAME(_type, _name)  XATTR_CEPH_PREFIX #_type "." #_name
> > >  #define CEPH_XATTR_NAME2(_type, _name, _name2) \
> > >         XATTR_CEPH_PREFIX #_type "." #_name "." #_name2
> > > @@ -407,6 +424,24 @@ static struct ceph_vxattr ceph_file_vxattrs[] = {
> > >         { .name = NULL, 0 }     /* Required table terminator */
> > >  };
> > >
> > > +static struct ceph_vxattr ceph_common_vxattrs[] = {
> > > +       {
> > > +               .name = "ceph.cluster_fsid",
> > > +               .name_size = sizeof("ceph.cluster_fsid"),
> > > +               .getxattr_cb = ceph_vxattrcb_cluster_fsid,
> > > +               .exists_cb = NULL,
> > > +               .flags = VXATTR_FLAG_READONLY,
> > > +       },
> >
> > I would prefer just "ceph.fsid".
> >
>
> Ilya suggested this name to match existing rbd attributes.

I think "cluster" is particularly important here because people
might mistake it for a filesystem identifier.

Thanks,

                Ilya
