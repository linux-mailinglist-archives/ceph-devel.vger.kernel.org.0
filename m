Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90DFF3BE252
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Jul 2021 07:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbhGGFIU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 7 Jul 2021 01:08:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43585 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230108AbhGGFIU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 7 Jul 2021 01:08:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625634340;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gUe4C8s26yOI6zOx5iacmjpX3gVQRmQL1Gp8bwfm/ds=;
        b=BpUiORI/t1NlfGN/KZMj1FhouTgtnrm0qZr2ZMFyIa+O/emJubkkB40M6MjEZRJPpY2zpM
        Vp4hN67ZbuqGJS9ki95PJR7ubMthkaVaqQ65PyBlAR+Ev2M1DpxHlyOCNaOGc5Q/z0aHQO
        k/e+lCFrdZuS6L/iwAt0t7+7V5Xbnxk=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-517-I_aAfe5bPoGzciSfi7nH0g-1; Wed, 07 Jul 2021 01:05:38 -0400
X-MC-Unique: I_aAfe5bPoGzciSfi7nH0g-1
Received: by mail-ej1-f70.google.com with SMTP id k1-20020a17090666c1b029041c273a883dso133368ejp.3
        for <ceph-devel@vger.kernel.org>; Tue, 06 Jul 2021 22:05:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=gUe4C8s26yOI6zOx5iacmjpX3gVQRmQL1Gp8bwfm/ds=;
        b=dzP5bp1Pbrb9iWZbXzWW1WL1qk4gaT+FI/e4ikAI5BUiEgSra/0FFf2YwJ2YKEBFwy
         pjrpR1bHxNfguXOvZQzyxyNBMvM5NnLvVoD6NkwnMICpQw8MVJ5+kldrAYv5SQE7Uy83
         DRKayX9p7MPEgWhSistlbH+uA2VBeg9zkso4W/2bPF0Ocm0FtNldIPPXz+ZIintfRg8o
         bzM1opF+QuomBtqx3TAFRN6O87BrWYLA5zqQM31B8Sdx8Ig19gn1e4U1e7Qu69zkhSHI
         RMtAbB08zFVAG9ZgfTmG147FLfoIxzGohcBri92I1ldrxEB+a2AQWXwomd+ZO+aChiAl
         tnTQ==
X-Gm-Message-State: AOAM531L5l5ucPT8+1z23dChCa2KVRbKP/VFF9OORbTrskSo1GTQdVMW
        q9FUdUA/YpyqAyjjFh3a/BGIWmwyj/HePboSd5lf34gPy3aTUb9B4XUDKwTg3EwOR5fnwZ0GfRG
        V4oOimIdFcBg8lT2/fs9pj8+f5WgluurljZcuzw==
X-Received: by 2002:a17:906:f0d1:: with SMTP id dk17mr2148831ejb.424.1625634337357;
        Tue, 06 Jul 2021 22:05:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyn2lJcdiGAOiRPz/6L3EoDfHfmHFNELGFjs5zKpx/9f3MuPO+N1xDlhAAgI477KusxKvFJLQn9PF9j9cwc38U=
X-Received: by 2002:a17:906:f0d1:: with SMTP id dk17mr2148822ejb.424.1625634337181;
 Tue, 06 Jul 2021 22:05:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210702064821.148063-1-vshankar@redhat.com> <20210702064821.148063-3-vshankar@redhat.com>
 <YN7t9TJlDG8YcbqM@suse.de> <CACPzV1=J_7n4kSjny-92OV2_rpWZn3fOK_sdHjJ6nnC9BgEOXw@mail.gmail.com>
 <YN8ZhNG0jiA2CFln@suse.de> <CACPzV1k6Wsym5sxb=3d3h-yMg2biJn=g9Ec-gzfi6CyF1xFJKg@mail.gmail.com>
 <b844de4ab0b086c7d2d824507bb27242c96f64b4.camel@redhat.com>
In-Reply-To: <b844de4ab0b086c7d2d824507bb27242c96f64b4.camel@redhat.com>
From:   Venky Shankar <vshankar@redhat.com>
Date:   Wed, 7 Jul 2021 10:35:01 +0530
Message-ID: <CACPzV1=vTQvtiQBpGxB4Z3oFM0FZDw--K0=h+X0E=bR+YTAvFQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] ceph: validate cluster FSID for new device syntax
To:     Jeff Layton <jlayton@redhat.com>
Cc:     Luis Henriques <lhenriques@suse.de>,
        Ilya Dryomov <idryomov@gmail.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jul 7, 2021 at 12:05 AM Jeff Layton <jlayton@redhat.com> wrote:
>
> On Fri, 2021-07-02 at 20:27 +0530, Venky Shankar wrote:
> > On Fri, Jul 2, 2021 at 7:20 PM Luis Henriques <lhenriques@suse.de> wrot=
e:
> > >
> > > On Fri, Jul 02, 2021 at 04:40:18PM +0530, Venky Shankar wrote:
> > > > On Fri, Jul 2, 2021 at 4:14 PM Luis Henriques <lhenriques@suse.de> =
wrote:
> > > > >
> > > > > On Fri, Jul 02, 2021 at 12:18:19PM +0530, Venky Shankar wrote:
> > > > > > The new device syntax requires the cluster FSID as part
> > > > > > of the device string. Use this FSID to verify if it matches
> > > > > > the cluster FSID we get back from the monitor, failing the
> > > > > > mount on mismatch.
> > > > > >
> > > > > > Also, rename parse_fsid() to ceph_parse_fsid() as it is too
> > > > > > generic.
> > > > > >
> > > > > > Signed-off-by: Venky Shankar <vshankar@redhat.com>
> > > > > > ---
> > > > > >  fs/ceph/super.c              | 9 +++++++++
> > > > > >  fs/ceph/super.h              | 1 +
> > > > > >  include/linux/ceph/libceph.h | 1 +
> > > > > >  net/ceph/ceph_common.c       | 5 +++--
> > > > > >  4 files changed, 14 insertions(+), 2 deletions(-)
> > > > > >
> > > > > > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > > > > > index 0b324e43c9f4..03e5f4bb2b6f 100644
> > > > > > --- a/fs/ceph/super.c
> > > > > > +++ b/fs/ceph/super.c
> > > > > > @@ -268,6 +268,9 @@ static int ceph_parse_new_source(const char=
 *dev_name, const char *dev_name_end,
> > > > > >       if (!fs_name_start)
> > > > > >               return invalfc(fc, "missing file system name");
> > > > > >
> > > > > > +     if (ceph_parse_fsid(fsid_start, &fsopt->fsid))
> > > > > > +             return invalfc(fc, "invalid fsid format");
> > > > > > +
> > > > > >       ++fs_name_start; /* start of file system name */
> > > > > >       fsopt->mds_namespace =3D kstrndup(fs_name_start,
> > > > > >                                       dev_name_end - fs_name_st=
art, GFP_KERNEL);
> > > > > > @@ -750,6 +753,12 @@ static struct ceph_fs_client *create_fs_cl=
ient(struct ceph_mount_options *fsopt,
> > > > > >       }
> > > > > >       opt =3D NULL; /* fsc->client now owns this */
> > > > > >
> > > > > > +     /* help learn fsid */
> > > > > > +     if (fsopt->new_dev_syntax) {
> > > > > > +             ceph_check_fsid(fsc->client, &fsopt->fsid);
> > > > >
> > > > > This call to ceph_check_fsid() made me wonder what would happen i=
f I use
> > > > > the wrong fsid with the new syntax.  And the result is:
> > > > >
> > > > > [   41.882334] libceph: mon0 (1)192.168.155.1:40594 session estab=
lished
> > > > > [   41.884537] libceph: bad fsid, had d52783e6-efc2-4dce-ad01-aa3=
272fa5f66 got 90bdb539-9d95-402e-8f23-b0e26cba8b1b
> > > > > [   41.885955] libceph: bad fsid, had d52783e6-efc2-4dce-ad01-aa3=
272fa5f66 got 90bdb539-9d95-402e-8f23-b0e26cba8b1b
> > > > > [   41.889313] libceph: bad fsid, had d52783e6-efc2-4dce-ad01-aa3=
272fa5f66 got 90bdb539-9d95-402e-8f23-b0e26cba8b1b
> > > > > [   41.892578] libceph: osdc handle_map corrupt msg
> > > > >
> > > > > ... followed by a msg dump.
> > > > >
> > > > > I guess this means that manually setting the fsid requires change=
s to the
> > > > > messenger (I've only tested with v1) so that it gracefully handle=
s this
> > > > > scenario.
> > > >
> > > > Yes, this results in a big dump of messages. I haven't looked at
> > > > gracefully handling these.
> > > >
> > > > I'm not sure if it needs to be done in these set of patches though.
> > >
> > > Ah, sure!  I didn't meant you'd need to change the messenger to handl=
e it
> > > (as I'm not even sure it's the messenger or the mons client that requ=
ire
> > > changes).  But I also don't think that this patchset can be merged wi=
thout
> > > making sure we can handle a bad fsid correctly and without all this n=
oise.
> >
> > True. However, for most cases users really won't be filling in the
> > fsid and the mount helper would fill the "correct" one automatically.
> >
>
> Yes, but some of them may and I think we do need to handle this
> gracefully. Let's step back a moment and consider:
>
> AIUI, the fsid is only here to disambiguate when you have multiple
> clusters. The kernel doesn't really care about this value at all. All it
> cares about is whether it's talking to the right mons (as evidenced by
> the fact that we don't pass the fsid in at mount time today).
>
> So probably the right thing to do is to just return an error (-EINVAL?)
> to mount() when there is a mismatch between the fsid and the one in the
> maps. Is that possible?

Gracefully handling this is the correct way forward. With these
changes, a fsid mismatch results in a big splat of message dumps and
mount failure.

I haven't yet figured where (all) to plumb in the work to handle this,
but looks doable.

>
> > >
> > > Cheers,
> > > --
> > > Lu=C3=ADs
> > >
> > > >
> > > > >
> > > > > Cheers,
> > > > > --
> > > > > Lu=C3=ADs
> > > > >
> > > > > > +             fsc->client->have_fsid =3D true;
> > > > > > +     }
> > > > > > +
> > > > > >       fsc->client->extra_mon_dispatch =3D extra_mon_dispatch;
> > > > > >       ceph_set_opt(fsc->client, ABORT_ON_FULL);
> > > > > >
> > > > > > diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> > > > > > index 8f71184b7c85..ce5fb90a01a4 100644
> > > > > > --- a/fs/ceph/super.h
> > > > > > +++ b/fs/ceph/super.h
> > > > > > @@ -99,6 +99,7 @@ struct ceph_mount_options {
> > > > > >       char *server_path;    /* default NULL (means "/") */
> > > > > >       char *fscache_uniq;   /* default NULL */
> > > > > >       char *mon_addr;
> > > > > > +     struct ceph_fsid fsid;
> > > > > >  };
> > > > > >
> > > > > >  struct ceph_fs_client {
> > > > > > diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/=
libceph.h
> > > > > > index 409d8c29bc4f..75d059b79d90 100644
> > > > > > --- a/include/linux/ceph/libceph.h
> > > > > > +++ b/include/linux/ceph/libceph.h
> > > > > > @@ -296,6 +296,7 @@ extern bool libceph_compatible(void *data);
> > > > > >  extern const char *ceph_msg_type_name(int type);
> > > > > >  extern int ceph_check_fsid(struct ceph_client *client, struct =
ceph_fsid *fsid);
> > > > > >  extern void *ceph_kvmalloc(size_t size, gfp_t flags);
> > > > > > +extern int ceph_parse_fsid(const char *str, struct ceph_fsid *=
fsid);
> > > > > >
> > > > > >  struct fs_parameter;
> > > > > >  struct fc_log;
> > > > > > diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
> > > > > > index 97d6ea763e32..da480757fcca 100644
> > > > > > --- a/net/ceph/ceph_common.c
> > > > > > +++ b/net/ceph/ceph_common.c
> > > > > > @@ -217,7 +217,7 @@ void *ceph_kvmalloc(size_t size, gfp_t flag=
s)
> > > > > >       return p;
> > > > > >  }
> > > > > >
> > > > > > -static int parse_fsid(const char *str, struct ceph_fsid *fsid)
> > > > > > +int ceph_parse_fsid(const char *str, struct ceph_fsid *fsid)
> > > > > >  {
> > > > > >       int i =3D 0;
> > > > > >       char tmp[3];
> > > > > > @@ -247,6 +247,7 @@ static int parse_fsid(const char *str, stru=
ct ceph_fsid *fsid)
> > > > > >       dout("parse_fsid ret %d got fsid %pU\n", err, fsid);
> > > > > >       return err;
> > > > > >  }
> > > > > > +EXPORT_SYMBOL(ceph_parse_fsid);
> > > > > >
> > > > > >  /*
> > > > > >   * ceph options
> > > > > > @@ -465,7 +466,7 @@ int ceph_parse_param(struct fs_parameter *p=
aram, struct ceph_options *opt,
> > > > > >               break;
> > > > > >
> > > > > >       case Opt_fsid:
> > > > > > -             err =3D parse_fsid(param->string, &opt->fsid);
> > > > > > +             err =3D ceph_parse_fsid(param->string, &opt->fsid=
);
> > > > > >               if (err) {
> > > > > >                       error_plog(&log, "Failed to parse fsid: %=
d", err);
> > > > > >                       return err;
> > > > > > --
> > > > > > 2.27.0
> > > > > >
> > > > >
> > > >
> > > >
> > > > --
> > > > Cheers,
> > > > Venky
> > > >
> > >
> >
> >
>
> --
> Jeff Layton <jlayton@redhat.com>
>


--=20
Cheers,
Venky

