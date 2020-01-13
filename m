Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65CEE139723
	for <lists+ceph-devel@lfdr.de>; Mon, 13 Jan 2020 18:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728757AbgAMRKS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 13 Jan 2020 12:10:18 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34379 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728712AbgAMRKS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 13 Jan 2020 12:10:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578935417;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=358mpDBEzHCQmeK2H62qwUT1/nFtDqoOyWcZYpkRbVs=;
        b=GZ9n7OnKSzcNN/0mjC8kTToVtWnOGO+I3CqB0yy90xpLICx5Z7a3MIs/SREAs/g7MHKXBk
        8Gub9J6ODE1m+NoLlp0bpeDjC1jqbPRiD/puNG5s1tKQeOXERc6g3tbZh4/9vJUOld6p8s
        QqADNHPbP2hpK8V7DCkFuBbsPshD+GI=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-CGmJc1kVMRGDs74X8A7lrg-1; Mon, 13 Jan 2020 12:10:14 -0500
X-MC-Unique: CGmJc1kVMRGDs74X8A7lrg-1
Received: by mail-qk1-f197.google.com with SMTP id u30so6368052qke.13
        for <ceph-devel@vger.kernel.org>; Mon, 13 Jan 2020 09:10:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=358mpDBEzHCQmeK2H62qwUT1/nFtDqoOyWcZYpkRbVs=;
        b=aCw04mUKO+KWacHdccrn2EdNPw/JdYhguAzcFRqZCHd/AxXMiEjq3Rm3gH0hChu4AE
         KcU2//wwMn+pyjefQQDOo23S3utsko4Wmczkup/vzfCDiICz2+zwgOIc3wQ3DCVHYueW
         csASDEWOQy/cXZfSstKpdoB7cEaoSGKfNBUKFkW82no0LIOiH9hJ1h0mnk84oT3B6fUE
         b6hHIa1ig1WS729PphmL4TvxdU+yZcCs5ru9NlldflDsIcXPwXte7+giPfwH6442eoEP
         8/XZgONMowmKrVbnmWR/fAI+tiLG2fTnvuT6NtJkeQO3E43uFVV1sgx0j3x1GcLyqcqc
         ooXQ==
X-Gm-Message-State: APjAAAXozuAg4CjMu7BFWNe6BTDjN2MTfgiDH4d5YS0ZOXGApmwa8GoA
        PROqWXg+ATRohtde2EXbq+a2i7+ItxiYtjXTbP9MXPxC0ltULXiSAkiC1d3m0PMc1a+nNkCZYwo
        hdKC9IQBdhUASKYGmFo4lDv3YLOPuvWTm/nCtPQ==
X-Received: by 2002:a0c:a563:: with SMTP id y90mr12117950qvy.78.1578935413463;
        Mon, 13 Jan 2020 09:10:13 -0800 (PST)
X-Google-Smtp-Source: APXvYqw6xMGqfpVNYQhLa4UzQAfUTRXSqpnFDy7QjIqMIJ1OCfXEIw+hL2m0McX5wwUsqanMPpEUx1tT6/OSkk3fXgM=
X-Received: by 2002:a0c:a563:: with SMTP id y90mr12117901qvy.78.1578935412836;
 Mon, 13 Jan 2020 09:10:12 -0800 (PST)
MIME-Version: 1.0
References: <20200108100353.23770-1-lhenriques@suse.com> <913eb28e6bb698f27f1831f75ea5250497ee659c.camel@kernel.org>
In-Reply-To: <913eb28e6bb698f27f1831f75ea5250497ee659c.camel@kernel.org>
From:   Gregory Farnum <gfarnum@redhat.com>
Date:   Mon, 13 Jan 2020 09:10:01 -0800
Message-ID: <CAJ4mKGb-Qo281_HW8bEDtbF+B-v_AbwaH0QyQbk+asti-qn=Vg@mail.gmail.com>
Subject: Re: [RFC PATCH v4] ceph: use 'copy-from2' operation in copy_file_range
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Luis Henriques <lhenriques@suse.com>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Jan 9, 2020 at 5:06 AM Jeff Layton <jlayton@kernel.org> wrote:
>
> On Wed, 2020-01-08 at 10:03 +0000, Luis Henriques wrote:
> > Instead of using the 'copy-from' operation, switch copy_file_range to t=
he
> > new 'copy-from2' operation, which allows to send the truncate_seq and
> > truncate_size parameters.
> >
> > If an OSD does not support the 'copy-from2' operation it will return
> > -EOPNOTSUPP.  In that case, the kernel client will stop trying to do
> > remote object copies for this fs client and will always use the generic
> > VFS copy_file_range.
> >
> > Signed-off-by: Luis Henriques <lhenriques@suse.com>
> > ---
> > Hi Jeff,
> >
> > This is a follow-up to the discussion in [1].  Since PR [2] has been
> > merged, it's now time to change the kernel client to use the new
> > 'copy-from2'.  And that's what this patch does.
> >
> > [1] https://lore.kernel.org/lkml/20191118120935.7013-1-lhenriques@suse.=
com/
> > [2] https://github.com/ceph/ceph/pull/31728
> >
> >  fs/ceph/file.c                  | 13 ++++++++++++-
> >  fs/ceph/super.c                 |  1 +
> >  fs/ceph/super.h                 |  3 +++
> >  include/linux/ceph/osd_client.h |  1 +
> >  include/linux/ceph/rados.h      |  2 ++
> >  net/ceph/osd_client.c           | 18 ++++++++++++------
> >  6 files changed, 31 insertions(+), 7 deletions(-)
> >
> > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > index 11929d2bb594..1e6cdf2dfe90 100644
> > --- a/fs/ceph/file.c
> > +++ b/fs/ceph/file.c
> > @@ -1974,6 +1974,10 @@ static ssize_t __ceph_copy_file_range(struct fil=
e *src_file, loff_t src_off,
> >       if (ceph_test_mount_opt(src_fsc, NOCOPYFROM))
> >               return -EOPNOTSUPP;
> >
> > +     /* Do the OSDs support the 'copy-from2' operation? */
> > +     if (!src_fsc->have_copy_from2)
> > +             return -EOPNOTSUPP;
> > +
> >       /*
> >        * Striped file layouts require that we copy partial objects, but=
 the
> >        * OSD copy-from operation only supports full-object copies.  Lim=
it
> > @@ -2101,8 +2105,15 @@ static ssize_t __ceph_copy_file_range(struct fil=
e *src_file, loff_t src_off,
> >                       CEPH_OSD_OP_FLAG_FADVISE_NOCACHE,
> >                       &dst_oid, &dst_oloc,
> >                       CEPH_OSD_OP_FLAG_FADVISE_SEQUENTIAL |
> > -                     CEPH_OSD_OP_FLAG_FADVISE_DONTNEED, 0);
> > +                     CEPH_OSD_OP_FLAG_FADVISE_DONTNEED,
> > +                     dst_ci->i_truncate_seq, dst_ci->i_truncate_size,
> > +                     CEPH_OSD_COPY_FROM_FLAG_TRUNCATE_SEQ);
> >               if (err) {
> > +                     if (err =3D=3D -EOPNOTSUPP) {
> > +                             src_fsc->have_copy_from2 =3D false;
> > +                             pr_notice("OSDs don't support 'copy-from2=
'; "
> > +                                       "disabling copy_file_range\n");
> > +                     }
> >                       dout("ceph_osdc_copy_from returned %d\n", err);
> >                       if (!ret)
> >                               ret =3D err;
>
> The patch itself looks fine to me. I'll not merge yet, since you sent it
> as an RFC, but I don't have any objection to it at first glance. The
> only other comment I'd make is that you should probably split this into
> two patches -- one for the libceph changes and one for cephfs.
>
> On a related note, I wonder if we'd get better performance out of large
> copy_file_range calls here if you were to move the wait for all of these
> osd requests after issuing them all in parallel?
>
> Currently we're doing:
>
> copy_from
> wait
> copy_from
> wait
>
> ...but figure that the second copy_from might very well be between osds
> that are not involved in the first copy. There's no reason to do them
> sequentially. It'd be better to issue all of the OSD requests first, and
> then wait on all of the replies in turn:

If this is added (good idea in general) it should be throttled =E2=80=94 we
don=E2=80=99t want users accidentally trying to copy a 1TB file and setting
off 250000 simultaneous copy_from2 requests!
-Greg

>
> copy_from
> copy_from
> copy_from
> ...
> wait
> wait
> wait
>
> > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > index 29a795f975df..b62c487a53af 100644
> > --- a/fs/ceph/super.c
> > +++ b/fs/ceph/super.c
> > @@ -637,6 +637,7 @@ static struct ceph_fs_client *create_fs_client(stru=
ct ceph_mount_options *fsopt,
> >       fsc->sb =3D NULL;
> >       fsc->mount_state =3D CEPH_MOUNT_MOUNTING;
> >       fsc->filp_gen =3D 1;
> > +     fsc->have_copy_from2 =3D true;
> >
> >       atomic_long_set(&fsc->writeback_count, 0);
> >
> > diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> > index 3bf1a01cd536..b2f86bed5c2c 100644
> > --- a/fs/ceph/super.h
> > +++ b/fs/ceph/super.h
> > @@ -106,6 +106,9 @@ struct ceph_fs_client {
> >       unsigned long last_auto_reconnect;
> >       bool blacklisted;
> >
> > +     /* Do the OSDs support the 'copy-from2' Op? */
> > +     bool have_copy_from2;
> > +
> >       u32 filp_gen;
> >       loff_t max_file_size;
> >
> > diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_c=
lient.h
> > index eaffbdddf89a..5a62dbd3f4c2 100644
> > --- a/include/linux/ceph/osd_client.h
> > +++ b/include/linux/ceph/osd_client.h
> > @@ -534,6 +534,7 @@ int ceph_osdc_copy_from(struct ceph_osd_client *osd=
c,
> >                       struct ceph_object_id *dst_oid,
> >                       struct ceph_object_locator *dst_oloc,
> >                       u32 dst_fadvise_flags,
> > +                     u32 truncate_seq, u64 truncate_size,
> >                       u8 copy_from_flags);
> >
> >  /* watch/notify */
> > diff --git a/include/linux/ceph/rados.h b/include/linux/ceph/rados.h
> > index 3eb0e55665b4..59bdfd470100 100644
> > --- a/include/linux/ceph/rados.h
> > +++ b/include/linux/ceph/rados.h
> > @@ -256,6 +256,7 @@ extern const char *ceph_osd_state_name(int s);
> >                                                                        =
   \
> >       /* tiering */                                                    =
   \
> >       f(COPY_FROM,    __CEPH_OSD_OP(WR, DATA, 26),    "copy-from")     =
   \
> > +     f(COPY_FROM2,   __CEPH_OSD_OP(WR, DATA, 45),    "copy-from2")    =
   \
> >       f(COPY_GET_CLASSIC, __CEPH_OSD_OP(RD, DATA, 27), "copy-get-classi=
c") \
> >       f(UNDIRTY,      __CEPH_OSD_OP(WR, DATA, 28),    "undirty")       =
   \
> >       f(ISDIRTY,      __CEPH_OSD_OP(RD, DATA, 29),    "isdirty")       =
   \
> > @@ -446,6 +447,7 @@ enum {
> >       CEPH_OSD_COPY_FROM_FLAG_MAP_SNAP_CLONE =3D 8, /* map snap direct =
to
> >                                                    * cloneid */
> >       CEPH_OSD_COPY_FROM_FLAG_RWORDERED =3D 16,     /* order with write=
 */
> > +     CEPH_OSD_COPY_FROM_FLAG_TRUNCATE_SEQ =3D 32,  /* send truncate_{s=
eq,size} */
> >  };
> >
> >  enum {
> > diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> > index ba45b074a362..b68b376d8c2f 100644
> > --- a/net/ceph/osd_client.c
> > +++ b/net/ceph/osd_client.c
> > @@ -402,7 +402,7 @@ static void osd_req_op_data_release(struct ceph_osd=
_request *osd_req,
> >       case CEPH_OSD_OP_LIST_WATCHERS:
> >               ceph_osd_data_release(&op->list_watchers.response_data);
> >               break;
> > -     case CEPH_OSD_OP_COPY_FROM:
> > +     case CEPH_OSD_OP_COPY_FROM2:
> >               ceph_osd_data_release(&op->copy_from.osd_data);
> >               break;
> >       default:
> > @@ -697,7 +697,7 @@ static void get_num_data_items(struct ceph_osd_requ=
est *req,
> >               case CEPH_OSD_OP_SETXATTR:
> >               case CEPH_OSD_OP_CMPXATTR:
> >               case CEPH_OSD_OP_NOTIFY_ACK:
> > -             case CEPH_OSD_OP_COPY_FROM:
> > +             case CEPH_OSD_OP_COPY_FROM2:
> >                       *num_request_data_items +=3D 1;
> >                       break;
> >
> > @@ -1029,7 +1029,7 @@ static u32 osd_req_encode_op(struct ceph_osd_op *=
dst,
> >       case CEPH_OSD_OP_CREATE:
> >       case CEPH_OSD_OP_DELETE:
> >               break;
> > -     case CEPH_OSD_OP_COPY_FROM:
> > +     case CEPH_OSD_OP_COPY_FROM2:
> >               dst->copy_from.snapid =3D cpu_to_le64(src->copy_from.snap=
id);
> >               dst->copy_from.src_version =3D
> >                       cpu_to_le64(src->copy_from.src_version);
> > @@ -1966,7 +1966,7 @@ static void setup_request_data(struct ceph_osd_re=
quest *req)
> >                       ceph_osdc_msg_data_add(request_msg,
> >                                              &op->notify_ack.request_da=
ta);
> >                       break;
> > -             case CEPH_OSD_OP_COPY_FROM:
> > +             case CEPH_OSD_OP_COPY_FROM2:
> >                       ceph_osdc_msg_data_add(request_msg,
> >                                              &op->copy_from.osd_data);
> >                       break;
> > @@ -5315,6 +5315,7 @@ static int osd_req_op_copy_from_init(struct ceph_=
osd_request *req,
> >                                    struct ceph_object_locator *src_oloc=
,
> >                                    u32 src_fadvise_flags,
> >                                    u32 dst_fadvise_flags,
> > +                                  u32 truncate_seq, u64 truncate_size,
> >                                    u8 copy_from_flags)
> >  {
> >       struct ceph_osd_req_op *op;
> > @@ -5325,7 +5326,8 @@ static int osd_req_op_copy_from_init(struct ceph_=
osd_request *req,
> >       if (IS_ERR(pages))
> >               return PTR_ERR(pages);
> >
> > -     op =3D _osd_req_op_init(req, 0, CEPH_OSD_OP_COPY_FROM, dst_fadvis=
e_flags);
> > +     op =3D _osd_req_op_init(req, 0, CEPH_OSD_OP_COPY_FROM2,
> > +                           dst_fadvise_flags);
> >       op->copy_from.snapid =3D src_snapid;
> >       op->copy_from.src_version =3D src_version;
> >       op->copy_from.flags =3D copy_from_flags;
> > @@ -5335,6 +5337,8 @@ static int osd_req_op_copy_from_init(struct ceph_=
osd_request *req,
> >       end =3D p + PAGE_SIZE;
> >       ceph_encode_string(&p, end, src_oid->name, src_oid->name_len);
> >       encode_oloc(&p, end, src_oloc);
> > +     ceph_encode_32(&p, truncate_seq);
> > +     ceph_encode_64(&p, truncate_size);
> >       op->indata_len =3D PAGE_SIZE - (end - p);
> >
> >       ceph_osd_data_pages_init(&op->copy_from.osd_data, pages,
> > @@ -5350,6 +5354,7 @@ int ceph_osdc_copy_from(struct ceph_osd_client *o=
sdc,
> >                       struct ceph_object_id *dst_oid,
> >                       struct ceph_object_locator *dst_oloc,
> >                       u32 dst_fadvise_flags,
> > +                     u32 truncate_seq, u64 truncate_size,
> >                       u8 copy_from_flags)
> >  {
> >       struct ceph_osd_request *req;
> > @@ -5366,7 +5371,8 @@ int ceph_osdc_copy_from(struct ceph_osd_client *o=
sdc,
> >
> >       ret =3D osd_req_op_copy_from_init(req, src_snapid, src_version, s=
rc_oid,
> >                                       src_oloc, src_fadvise_flags,
> > -                                     dst_fadvise_flags, copy_from_flag=
s);
> > +                                     dst_fadvise_flags, truncate_seq,
> > +                                     truncate_size, copy_from_flags);
> >       if (ret)
> >               goto out;
> >
> --
> Jeff Layton <jlayton@kernel.org>
>

