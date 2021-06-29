Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 061BF3B6DB3
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Jun 2021 06:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbhF2Ep3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Jun 2021 00:45:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50985 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231598AbhF2Ep0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 29 Jun 2021 00:45:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624941779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4cGzdP+uQ/InHx7d/hJO3OSYFexWfSAiw2xa0UY4JHg=;
        b=ZB6MO6vIqKoN1m6lRfBqHEqJ2JUXbAxe6CM5Vs6Biko7MWRz8cOBTL3tN3ZwD68OhXLuKI
        3PDhhB0HXTuyZCgNWD34N7PWBfM6i1yT/b287D2hGe4v/7zt9UWvyC8WAc/8zltygyXWeE
        YabfB0sviqqsGFzz8RvT6ZNUzJof4Mk=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-427-gDHZXG3BOq6zm4OkPjN41g-1; Tue, 29 Jun 2021 00:42:57 -0400
X-MC-Unique: gDHZXG3BOq6zm4OkPjN41g-1
Received: by mail-ej1-f70.google.com with SMTP id lt4-20020a170906fa84b0290481535542e3so5267369ejb.18
        for <ceph-devel@vger.kernel.org>; Mon, 28 Jun 2021 21:42:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4cGzdP+uQ/InHx7d/hJO3OSYFexWfSAiw2xa0UY4JHg=;
        b=obrPMxpMFrZp16h1RVZ9O4dtgIE6tNcoeBND5tbqRpEKdhgcH5Bz5+wwMDKOzXxK10
         ps8GUHOqw+0NFZfMiNrD8oUyJJzXPakbP/GG1L2kyarkxxTVxTGMRFMmA+TYDghDz2XA
         4c91AKNZIv/LVSyFYiS8Uh6HU4VNK0GuznwMRzg7siEdVmif3VNHFZJ7v0FUFaIBuZLo
         d+l0eSSYoNYum8Qsjxr6qcHb8RoGm1wpxC5wLTPdg3zl+LKtu6L6LkWXt3UFPnKpOqnh
         B+tZh+2n23+U5KZTKkuDEhWnz3DGhHvLqG9xrIW1/ftXKkdHzjt5virEwR/XWV/hMT/9
         LCag==
X-Gm-Message-State: AOAM5308cUl1nw4jz7zJZfgQZ5KpR8yuqpr3W67ZGYTU9B8CLgy4LfY2
        gEoCLrj7v/ymWWfxgM/yo5JRKtvzywbnh2qVT65uKAnoPEAb0EIUm0fyo6k0wu0Rbs24md8PX4p
        Djv5yETwRv+YwdoYwya7xOgSp6/oZqPexoAP++A==
X-Received: by 2002:a17:906:1951:: with SMTP id b17mr28237266eje.468.1624941776297;
        Mon, 28 Jun 2021 21:42:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwi2wMh/VrtPYGnDwMzq3DTWovDaKDiBND4S8+6t1T6NoSxakjdV5z4taMLiRv1oKEhUWQrwxR1t78a20vnFb4=
X-Received: by 2002:a17:906:1951:: with SMTP id b17mr28237260eje.468.1624941776186;
 Mon, 28 Jun 2021 21:42:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210628075545.702106-1-vshankar@redhat.com> <20210628075545.702106-3-vshankar@redhat.com>
 <77c1bc3093a7f74c92a1deb35c0e80291c4d9b52.camel@redhat.com>
In-Reply-To: <77c1bc3093a7f74c92a1deb35c0e80291c4d9b52.camel@redhat.com>
From:   Venky Shankar <vshankar@redhat.com>
Date:   Tue, 29 Jun 2021 10:12:20 +0530
Message-ID: <CACPzV1=BmxmQUCwM1P-hLcY0RcZAXLPTxF=Kj8c3Jgn8Xn8kvA@mail.gmail.com>
Subject: Re: [PATCH 2/4] ceph: validate cluster FSID for new device syntax
To:     Jeff Layton <jlayton@redhat.com>
Cc:     idryomov@gmail.com, ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jun 28, 2021 at 8:34 PM Jeff Layton <jlayton@redhat.com> wrote:
>
> On Mon, 2021-06-28 at 13:25 +0530, Venky Shankar wrote:
> > The new device syntax requires the cluster FSID as part
> > of the device string. Use this FSID to verify if it matches
> > the cluster FSID we get back from the monitor, failing the
> > mount on mismatch.
> >
> > Signed-off-by: Venky Shankar <vshankar@redhat.com>
> > ---
> >  fs/ceph/super.c              | 9 +++++++++
> >  fs/ceph/super.h              | 1 +
> >  include/linux/ceph/libceph.h | 1 +
> >  net/ceph/ceph_common.c       | 3 ++-
> >  4 files changed, 13 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > index 950a28ad9c59..84bc06e51680 100644
> > --- a/fs/ceph/super.c
> > +++ b/fs/ceph/super.c
> > @@ -266,6 +266,9 @@ static int ceph_parse_new_source(const char *dev_name, const char *dev_name_end,
> >       if (!fs_name_start)
> >               return invalfc(fc, "missing file system name");
> >
> > +     if (parse_fsid(fsid_start, &fsopt->fsid))
> > +             return invalfc(fc, "invalid fsid format");
> > +
> >       ++fs_name_start; /* start of file system name */
> >       fsopt->mds_namespace = kstrndup(fs_name_start,
> >                                       dev_name_end - fs_name_start, GFP_KERNEL);
> > @@ -748,6 +751,12 @@ static struct ceph_fs_client *create_fs_client(struct ceph_mount_options *fsopt,
> >       }
> >       opt = NULL; /* fsc->client now owns this */
> >
> > +     /* help learn fsid */
> > +     if (fsopt->new_dev_syntax) {
> > +             ceph_check_fsid(fsc->client, &fsopt->fsid);
> > +             fsc->client->have_fsid = true;
> > +     }
> > +
> >       fsc->client->extra_mon_dispatch = extra_mon_dispatch;
> >       ceph_set_opt(fsc->client, ABORT_ON_FULL);
> >
> > diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> > index 557348ff3203..cfd8ec25a9a8 100644
> > --- a/fs/ceph/super.h
> > +++ b/fs/ceph/super.h
> > @@ -100,6 +100,7 @@ struct ceph_mount_options {
> >       char *server_path;    /* default NULL (means "/") */
> >       char *fscache_uniq;   /* default NULL */
> >       char *mon_addr;
> > +     struct ceph_fsid fsid;
> >  };
> >
> >  struct ceph_fs_client {
> > diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
> > index 409d8c29bc4f..24c1f4e9144d 100644
> > --- a/include/linux/ceph/libceph.h
> > +++ b/include/linux/ceph/libceph.h
> > @@ -296,6 +296,7 @@ extern bool libceph_compatible(void *data);
> >  extern const char *ceph_msg_type_name(int type);
> >  extern int ceph_check_fsid(struct ceph_client *client, struct ceph_fsid *fsid);
> >  extern void *ceph_kvmalloc(size_t size, gfp_t flags);
> > +extern int parse_fsid(const char *str, struct ceph_fsid *fsid);
> >
> >  struct fs_parameter;
> >  struct fc_log;
> > diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
> > index 97d6ea763e32..db21734462a4 100644
> > --- a/net/ceph/ceph_common.c
> > +++ b/net/ceph/ceph_common.c
> > @@ -217,7 +217,7 @@ void *ceph_kvmalloc(size_t size, gfp_t flags)
> >       return p;
> >  }
> >
> > -static int parse_fsid(const char *str, struct ceph_fsid *fsid)
> > +int parse_fsid(const char *str, struct ceph_fsid *fsid)
> >  {
> >       int i = 0;
> >       char tmp[3];
> > @@ -247,6 +247,7 @@ static int parse_fsid(const char *str, struct ceph_fsid *fsid)
> >       dout("parse_fsid ret %d got fsid %pU\n", err, fsid);
> >       return err;
> >  }
> > +EXPORT_SYMBOL(parse_fsid);
>
> This function name is too generic. Maybe rename it to "ceph_parse_fsid"?

Makes sense. ACK.

>
> >
> >  /*
> >   * ceph options
>
> --
> Jeff Layton <jlayton@redhat.com>
>


-- 
Cheers,
Venky

