Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2FE53B9F7D
	for <lists+ceph-devel@lfdr.de>; Fri,  2 Jul 2021 13:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbhGBLN3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 2 Jul 2021 07:13:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47816 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230424AbhGBLN3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 2 Jul 2021 07:13:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625224257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Dq2AOatYYogQX86LO71OV5fSn0StcPBEGTUgiBmJCos=;
        b=ii85w0dkXITtktC3aweCj9PIxGF9z8tJULYNvgIOCRKFihpmYJlC1ZBrLCKc209J1/ifsD
        lrM7vf8G3is59mDHmgy2FW/NDneYYNCgv3bx3Z816yFh/R4pCTQaeH0h2EHjzuEGiSiqy5
        WVV24c6fsON0Bbo6KcP/seVWCkpPMqM=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-C370-iSIMDK1NS5PkbCZ1A-1; Fri, 02 Jul 2021 07:10:56 -0400
X-MC-Unique: C370-iSIMDK1NS5PkbCZ1A-1
Received: by mail-ed1-f71.google.com with SMTP id u13-20020aa7d88d0000b0290397eb800ae3so925332edq.9
        for <ceph-devel@vger.kernel.org>; Fri, 02 Jul 2021 04:10:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Dq2AOatYYogQX86LO71OV5fSn0StcPBEGTUgiBmJCos=;
        b=qPmgsoNYl1KDLFbsUEByEyp19W3k0hzmWkVXHUIhv7FAWvc1BhQu3EgKzON1OxPU7z
         nSi5p1tUGrdvEqafJDET1jOuORUJXTaEbcv1yQWT5HsYzaE0xYmW1+VaxVYeDFvu4Abd
         DTg9Tuz9nh2jBpjHy483fDeVfZ2DU8kn/BKfbT8Dz/LDOFteb2ybgOYGkFK8XgY6hN4x
         hGyk/12xyVUpSv/jj+tqC+kB7OoIGj6qsRpiXlYgcidDjHOrq7Fatf4Q5xPzv6k7FXiI
         GniFGcGD83jW3cK/nzbkcXq2fYkKPQasfqe51bLs0wHIqwFgbz8d0G1MWQ6KOtcYMmPl
         wupw==
X-Gm-Message-State: AOAM532IczmQj21wsN2BkVHD7bl+xu/xIWKI8Y5Kxg1wxvcKDAsjkLko
        ebe6L5cRdevSw6rD0ziwPtTsZbykRKFaRUoVfSVxNxdeJsf4e1kZ/Js9Fk0wNvXpTOdAaoMIy3f
        fvW5GrgQzZwNchazbFJ7yHVrVrYYj7d/F8sZ6Yw==
X-Received: by 2002:a17:907:1c1c:: with SMTP id nc28mr4793783ejc.367.1625224254907;
        Fri, 02 Jul 2021 04:10:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwg8pwyFZK0HDAEcdwOFqfXs17r5UrhGGqKDEhTm2B5bk04MHhHr0EtOs3J8CERXeuQ5YTzovJJbJO3vrEH4Po=
X-Received: by 2002:a17:907:1c1c:: with SMTP id nc28mr4793762ejc.367.1625224254659;
 Fri, 02 Jul 2021 04:10:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210702064821.148063-1-vshankar@redhat.com> <20210702064821.148063-3-vshankar@redhat.com>
 <YN7t9TJlDG8YcbqM@suse.de>
In-Reply-To: <YN7t9TJlDG8YcbqM@suse.de>
From:   Venky Shankar <vshankar@redhat.com>
Date:   Fri, 2 Jul 2021 16:40:18 +0530
Message-ID: <CACPzV1=J_7n4kSjny-92OV2_rpWZn3fOK_sdHjJ6nnC9BgEOXw@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] ceph: validate cluster FSID for new device syntax
To:     Luis Henriques <lhenriques@suse.de>
Cc:     Jeff Layton <jlayton@redhat.com>, idryomov@gmail.com,
        Patrick Donnelly <pdonnell@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Jul 2, 2021 at 4:14 PM Luis Henriques <lhenriques@suse.de> wrote:
>
> On Fri, Jul 02, 2021 at 12:18:19PM +0530, Venky Shankar wrote:
> > The new device syntax requires the cluster FSID as part
> > of the device string. Use this FSID to verify if it matches
> > the cluster FSID we get back from the monitor, failing the
> > mount on mismatch.
> >
> > Also, rename parse_fsid() to ceph_parse_fsid() as it is too
> > generic.
> >
> > Signed-off-by: Venky Shankar <vshankar@redhat.com>
> > ---
> >  fs/ceph/super.c              | 9 +++++++++
> >  fs/ceph/super.h              | 1 +
> >  include/linux/ceph/libceph.h | 1 +
> >  net/ceph/ceph_common.c       | 5 +++--
> >  4 files changed, 14 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > index 0b324e43c9f4..03e5f4bb2b6f 100644
> > --- a/fs/ceph/super.c
> > +++ b/fs/ceph/super.c
> > @@ -268,6 +268,9 @@ static int ceph_parse_new_source(const char *dev_na=
me, const char *dev_name_end,
> >       if (!fs_name_start)
> >               return invalfc(fc, "missing file system name");
> >
> > +     if (ceph_parse_fsid(fsid_start, &fsopt->fsid))
> > +             return invalfc(fc, "invalid fsid format");
> > +
> >       ++fs_name_start; /* start of file system name */
> >       fsopt->mds_namespace =3D kstrndup(fs_name_start,
> >                                       dev_name_end - fs_name_start, GFP=
_KERNEL);
> > @@ -750,6 +753,12 @@ static struct ceph_fs_client *create_fs_client(str=
uct ceph_mount_options *fsopt,
> >       }
> >       opt =3D NULL; /* fsc->client now owns this */
> >
> > +     /* help learn fsid */
> > +     if (fsopt->new_dev_syntax) {
> > +             ceph_check_fsid(fsc->client, &fsopt->fsid);
>
> This call to ceph_check_fsid() made me wonder what would happen if I use
> the wrong fsid with the new syntax.  And the result is:
>
> [   41.882334] libceph: mon0 (1)192.168.155.1:40594 session established
> [   41.884537] libceph: bad fsid, had d52783e6-efc2-4dce-ad01-aa3272fa5f6=
6 got 90bdb539-9d95-402e-8f23-b0e26cba8b1b
> [   41.885955] libceph: bad fsid, had d52783e6-efc2-4dce-ad01-aa3272fa5f6=
6 got 90bdb539-9d95-402e-8f23-b0e26cba8b1b
> [   41.889313] libceph: bad fsid, had d52783e6-efc2-4dce-ad01-aa3272fa5f6=
6 got 90bdb539-9d95-402e-8f23-b0e26cba8b1b
> [   41.892578] libceph: osdc handle_map corrupt msg
>
> ... followed by a msg dump.
>
> I guess this means that manually setting the fsid requires changes to the
> messenger (I've only tested with v1) so that it gracefully handles this
> scenario.

Yes, this results in a big dump of messages. I haven't looked at
gracefully handling these.

I'm not sure if it needs to be done in these set of patches though.

>
> Cheers,
> --
> Lu=C3=ADs
>
> > +             fsc->client->have_fsid =3D true;
> > +     }
> > +
> >       fsc->client->extra_mon_dispatch =3D extra_mon_dispatch;
> >       ceph_set_opt(fsc->client, ABORT_ON_FULL);
> >
> > diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> > index 8f71184b7c85..ce5fb90a01a4 100644
> > --- a/fs/ceph/super.h
> > +++ b/fs/ceph/super.h
> > @@ -99,6 +99,7 @@ struct ceph_mount_options {
> >       char *server_path;    /* default NULL (means "/") */
> >       char *fscache_uniq;   /* default NULL */
> >       char *mon_addr;
> > +     struct ceph_fsid fsid;
> >  };
> >
> >  struct ceph_fs_client {
> > diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.=
h
> > index 409d8c29bc4f..75d059b79d90 100644
> > --- a/include/linux/ceph/libceph.h
> > +++ b/include/linux/ceph/libceph.h
> > @@ -296,6 +296,7 @@ extern bool libceph_compatible(void *data);
> >  extern const char *ceph_msg_type_name(int type);
> >  extern int ceph_check_fsid(struct ceph_client *client, struct ceph_fsi=
d *fsid);
> >  extern void *ceph_kvmalloc(size_t size, gfp_t flags);
> > +extern int ceph_parse_fsid(const char *str, struct ceph_fsid *fsid);
> >
> >  struct fs_parameter;
> >  struct fc_log;
> > diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
> > index 97d6ea763e32..da480757fcca 100644
> > --- a/net/ceph/ceph_common.c
> > +++ b/net/ceph/ceph_common.c
> > @@ -217,7 +217,7 @@ void *ceph_kvmalloc(size_t size, gfp_t flags)
> >       return p;
> >  }
> >
> > -static int parse_fsid(const char *str, struct ceph_fsid *fsid)
> > +int ceph_parse_fsid(const char *str, struct ceph_fsid *fsid)
> >  {
> >       int i =3D 0;
> >       char tmp[3];
> > @@ -247,6 +247,7 @@ static int parse_fsid(const char *str, struct ceph_=
fsid *fsid)
> >       dout("parse_fsid ret %d got fsid %pU\n", err, fsid);
> >       return err;
> >  }
> > +EXPORT_SYMBOL(ceph_parse_fsid);
> >
> >  /*
> >   * ceph options
> > @@ -465,7 +466,7 @@ int ceph_parse_param(struct fs_parameter *param, st=
ruct ceph_options *opt,
> >               break;
> >
> >       case Opt_fsid:
> > -             err =3D parse_fsid(param->string, &opt->fsid);
> > +             err =3D ceph_parse_fsid(param->string, &opt->fsid);
> >               if (err) {
> >                       error_plog(&log, "Failed to parse fsid: %d", err)=
;
> >                       return err;
> > --
> > 2.27.0
> >
>


--=20
Cheers,
Venky

