Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 409E014A9EE
	for <lists+ceph-devel@lfdr.de>; Mon, 27 Jan 2020 19:39:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbgA0Sjv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 27 Jan 2020 13:39:51 -0500
Received: from mx2.suse.de ([195.135.220.15]:52722 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725845AbgA0Sju (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 27 Jan 2020 13:39:50 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 802C2B15B;
        Mon, 27 Jan 2020 18:39:48 +0000 (UTC)
Date:   Mon, 27 Jan 2020 18:39:52 +0000
From:   Luis Henriques <lhenriques@suse.com>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        Gregory Farnum <gfarnum@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/3] libceph: add non-blocking version of
 ceph_osdc_copy_from()
Message-ID: <20200127183952.GA22545@suse.com>
References: <20200127164321.17468-1-lhenriques@suse.com>
 <20200127164321.17468-2-lhenriques@suse.com>
 <CAOi1vP9S3w13axR3FYxqFSZ1uF2V=0aMfnkcsMptMKL4W+-wEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOi1vP9S3w13axR3FYxqFSZ1uF2V=0aMfnkcsMptMKL4W+-wEA@mail.gmail.com>
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jan 27, 2020 at 06:47:02PM +0100, Ilya Dryomov wrote:
> On Mon, Jan 27, 2020 at 5:43 PM Luis Henriques <lhenriques@suse.com> wrote:
> >
> > A non-blocking version of ceph_osdc_copy_from will allow for callers to
> > send 'copy-from' requests in bulk and wait for all of them to complete in
> > the end.
> >
> > Signed-off-by: Luis Henriques <lhenriques@suse.com>
> > ---
> >  include/linux/ceph/osd_client.h | 12 ++++++++
> >  net/ceph/osd_client.c           | 54 +++++++++++++++++++++++++--------
> >  2 files changed, 53 insertions(+), 13 deletions(-)
> >
> > diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
> > index 5a62dbd3f4c2..7916a178d137 100644
> > --- a/include/linux/ceph/osd_client.h
> > +++ b/include/linux/ceph/osd_client.h
> > @@ -537,6 +537,18 @@ int ceph_osdc_copy_from(struct ceph_osd_client *osdc,
> >                         u32 truncate_seq, u64 truncate_size,
> >                         u8 copy_from_flags);
> >
> > +struct ceph_osd_request *ceph_osdc_copy_from_nowait(
> > +                       struct ceph_osd_client *osdc,
> > +                       u64 src_snapid, u64 src_version,
> > +                       struct ceph_object_id *src_oid,
> > +                       struct ceph_object_locator *src_oloc,
> > +                       u32 src_fadvise_flags,
> > +                       struct ceph_object_id *dst_oid,
> > +                       struct ceph_object_locator *dst_oloc,
> > +                       u32 dst_fadvise_flags,
> > +                       u32 truncate_seq, u64 truncate_size,
> > +                       u8 copy_from_flags);
> > +
> >  /* watch/notify */
> >  struct ceph_osd_linger_request *
> >  ceph_osdc_watch(struct ceph_osd_client *osdc,
> > diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> > index b68b376d8c2f..7f984532f37c 100644
> > --- a/net/ceph/osd_client.c
> > +++ b/net/ceph/osd_client.c
> > @@ -5346,23 +5346,24 @@ static int osd_req_op_copy_from_init(struct ceph_osd_request *req,
> >         return 0;
> >  }
> >
> > -int ceph_osdc_copy_from(struct ceph_osd_client *osdc,
> > -                       u64 src_snapid, u64 src_version,
> > -                       struct ceph_object_id *src_oid,
> > -                       struct ceph_object_locator *src_oloc,
> > -                       u32 src_fadvise_flags,
> > -                       struct ceph_object_id *dst_oid,
> > -                       struct ceph_object_locator *dst_oloc,
> > -                       u32 dst_fadvise_flags,
> > -                       u32 truncate_seq, u64 truncate_size,
> > -                       u8 copy_from_flags)
> > +struct ceph_osd_request *ceph_osdc_copy_from_nowait(
> > +               struct ceph_osd_client *osdc,
> > +               u64 src_snapid, u64 src_version,
> > +               struct ceph_object_id *src_oid,
> > +               struct ceph_object_locator *src_oloc,
> > +               u32 src_fadvise_flags,
> > +               struct ceph_object_id *dst_oid,
> > +               struct ceph_object_locator *dst_oloc,
> > +               u32 dst_fadvise_flags,
> > +               u32 truncate_seq, u64 truncate_size,
> > +               u8 copy_from_flags)
> >  {
> >         struct ceph_osd_request *req;
> >         int ret;
> >
> >         req = ceph_osdc_alloc_request(osdc, NULL, 1, false, GFP_KERNEL);
> >         if (!req)
> > -               return -ENOMEM;
> > +               return ERR_PTR(-ENOMEM);
> >
> >         req->r_flags = CEPH_OSD_FLAG_WRITE;
> >
> > @@ -5381,11 +5382,38 @@ int ceph_osdc_copy_from(struct ceph_osd_client *osdc,
> >                 goto out;
> >
> >         ceph_osdc_start_request(osdc, req, false);
> > -       ret = ceph_osdc_wait_request(osdc, req);
> > +       return req;
> >
> >  out:
> >         ceph_osdc_put_request(req);
> > -       return ret;
> > +       return ERR_PTR(ret);
> > +}
> > +EXPORT_SYMBOL(ceph_osdc_copy_from_nowait);
> > +
> > +int ceph_osdc_copy_from(struct ceph_osd_client *osdc,
> > +                       u64 src_snapid, u64 src_version,
> > +                       struct ceph_object_id *src_oid,
> > +                       struct ceph_object_locator *src_oloc,
> > +                       u32 src_fadvise_flags,
> > +                       struct ceph_object_id *dst_oid,
> > +                       struct ceph_object_locator *dst_oloc,
> > +                       u32 dst_fadvise_flags,
> > +                       u32 truncate_seq, u64 truncate_size,
> > +                       u8 copy_from_flags)
> > +{
> > +       struct ceph_osd_request *req;
> > +
> > +       req = ceph_osdc_copy_from_nowait(osdc,
> > +                       src_snapid, src_version,
> > +                       src_oid, src_oloc,
> > +                       src_fadvise_flags,
> > +                       dst_oid, dst_oloc,
> > +                       dst_fadvise_flags,
> > +                       truncate_seq, truncate_size,
> > +                       copy_from_flags);
> > +       if (IS_ERR(req))
> > +               return PTR_ERR(req);
> > +       return ceph_osdc_wait_request(osdc, req);
> 
> I don't think we need a blocking version.  Change ceph_osdc_copy_from()
> and keep the name -- no need for async or nowait suffixes.

Yeah, since the only user is copy_file_range we definitely don't need the
original version.  I'll include this change in the next iteration.

Cheers,
--
Luís
