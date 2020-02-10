Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3E6D1583E2
	for <lists+ceph-devel@lfdr.de>; Mon, 10 Feb 2020 20:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727688AbgBJTpT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 10 Feb 2020 14:45:19 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:37685 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727518AbgBJTpT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 10 Feb 2020 14:45:19 -0500
Received: by mail-il1-f194.google.com with SMTP id v13so1313909iln.4
        for <ceph-devel@vger.kernel.org>; Mon, 10 Feb 2020 11:45:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w7zbGPUtqRtNtdVyE+sNC2x7xtulbH/aeb759+oE4+k=;
        b=fjjUz5MKNyYQCrIVNkGpjXQ2SKF2UREyiK1sMc4CysPLodZdAH6XYl/+OXwwUWDh8G
         a30mhv5n4DJmO2hJCokK6+enz7pFkyLhysC7s6oKhZe/hajzFoameyz+5zNhuwCFjPe0
         YJevskTF1Hq91FVCpxc4rKoxneuOh67iak1qvD09S235it+cd+J4V6HibrmDJ31h4hqH
         A8Qh0GK3Hk6q71k5TTesQkL33cKH4IgKtqb9IWk/KJ4LzSf9/GCZhGOpb7bHwN+0c58d
         vbt4azTjv7UfeejXyCV10MO2+MasEEv0y8+9s/anxrJbdvYbTBh5G7q9fM4vU7n0xv+Y
         /hOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w7zbGPUtqRtNtdVyE+sNC2x7xtulbH/aeb759+oE4+k=;
        b=O3CX0S+EoKtDm1gv5HdARStEwYX84yVPi1UCjaz7xV10ypzfBxC8v9p9MFDFoanqa2
         ErzfIrfAcr4J8rl+6cFCFRakeL0wukJED9lrrtJvjAYsO/L7HqLmbY2JMWL4+souudxm
         XEJHnw9tZZaZ/Bf+XmFIIdqszbYkdYzgyI3KhIi45s4mPyQbttIe/6OSzuf565zRbqDu
         cz+yLEjm8vSzn1iFTn6l4bcuPa0DQ7cZ5TRZVRM8M6TIGK1aIOp/ukSW6iIrE0/lw5Fh
         sov8mrsEFl2qsTKlVoW171BsNz/lTvU45W7twm3x7/elZeEw98Lk9TMPnrp/cHdgC0kO
         QoAQ==
X-Gm-Message-State: APjAAAVvT5yZ4W8Q1P11kvNBqPxK0FXpaUArUF28Hb9jnSv37vpQnk4E
        EJyb3g4+2xBcpuFgAdkbFiZ1f1wFAdZHa5ppJyM=
X-Google-Smtp-Source: APXvYqyMcuKD2w5f7GaqEDS6HfK0ukAJ2vmDrPrc8VtPckWL39/rV0BBKhuV6W4RHW08lUhdsn9M8WZ6VcUsusnSOUY=
X-Received: by 2002:a92:3a8d:: with SMTP id i13mr3130293ilf.112.1581363918249;
 Mon, 10 Feb 2020 11:45:18 -0800 (PST)
MIME-Version: 1.0
References: <20200210135841.21177-1-xiubli@redhat.com> <e2614ef4-7dc1-d9ac-752a-d48b806dd561@redhat.com>
In-Reply-To: <e2614ef4-7dc1-d9ac-752a-d48b806dd561@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Mon, 10 Feb 2020 20:45:36 +0100
Message-ID: <CAOi1vP9Pw+=JGJsBLphO44j9RYu=O11VsgJs3fJGG1=gT=Q0UA@mail.gmail.com>
Subject: Re: [PATCH] ceph: fix posix acl couldn't be settable
To:     Xiubo Li <xiubli@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Feb 10, 2020 at 3:52 PM Xiubo Li <xiubli@redhat.com> wrote:
>
> On 2020/2/10 21:58, xiubli@redhat.com wrote:
> > From: Xiubo Li <xiubli@redhat.com>
> >
> > For the old mount API, the module parameters parseing function will
> > be called in ceph_mount() and also just after the default posix acl
> > flag set, so we can control to enable/disable it via the mount option.
> >
> > But for the new mount API, it will call the module parameters
> > parseing function before ceph_get_tree(), so the posix acl will always
> > be enabled.
> >
> > Fixes: 82995cc6c5ae ("libceph, rbd, ceph: convert to use the new mount API")
> > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > ---
> >   fs/ceph/super.c | 8 ++++----
> >   1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > index 5fef4f59e13e..69fa498391dc 100644
> > --- a/fs/ceph/super.c
> > +++ b/fs/ceph/super.c
> > @@ -341,6 +341,10 @@ static int ceph_parse_mount_param(struct fs_context *fc,
> >       unsigned int mode;
> >       int token, ret;
> >
> > +#ifdef CONFIG_CEPH_FS_POSIX_ACL
> > +     fc->sb_flags |= SB_POSIXACL;
> > +#endif
> > +
>
> Maybe we should move this to ceph_init_fs_context().

Hi Xiubo,

Yes -- so it is together with fsopt defaults.

Thanks,

                Ilya
