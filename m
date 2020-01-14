Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8571A13AD25
	for <lists+ceph-devel@lfdr.de>; Tue, 14 Jan 2020 16:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729113AbgANPJE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 14 Jan 2020 10:09:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:55364 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728977AbgANPJE (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 14 Jan 2020 10:09:04 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id DE52DAD22;
        Tue, 14 Jan 2020 15:09:01 +0000 (UTC)
Date:   Tue, 14 Jan 2020 15:09:02 +0000
From:   Luis Henriques <lhenriques@suse.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Gregory Farnum <gfarnum@redhat.com>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v4] ceph: use 'copy-from2' operation in
 copy_file_range
Message-ID: <20200114150902.GA28556@brahms.Home>
References: <20200108100353.23770-1-lhenriques@suse.com>
 <913eb28e6bb698f27f1831f75ea5250497ee659c.camel@kernel.org>
 <CAJ4mKGb-Qo281_HW8bEDtbF+B-v_AbwaH0QyQbk+asti-qn=Vg@mail.gmail.com>
 <20200114095555.GA17907@brahms.Home>
 <46c92e6678906fa065b18e418044647e7cdb47e1.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46c92e6678906fa065b18e418044647e7cdb47e1.camel@kernel.org>
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jan 14, 2020 at 06:57:56AM -0500, Jeff Layton wrote:
> On Tue, 2020-01-14 at 09:55 +0000, Luis Henriques wrote:
> > On Mon, Jan 13, 2020 at 09:10:01AM -0800, Gregory Farnum wrote:
> > > On Thu, Jan 9, 2020 at 5:06 AM Jeff Layton <jlayton@kernel.org> wrote:
> > > > On Wed, 2020-01-08 at 10:03 +0000, Luis Henriques wrote:
> > > > > Instead of using the 'copy-from' operation, switch copy_file_range to the
> > > > > new 'copy-from2' operation, which allows to send the truncate_seq and
> > > > > truncate_size parameters.
> > > > > 
> > > > > If an OSD does not support the 'copy-from2' operation it will return
> > > > > -EOPNOTSUPP.  In that case, the kernel client will stop trying to do
> > > > > remote object copies for this fs client and will always use the generic
> > > > > VFS copy_file_range.
> > > > > 
> > > > > Signed-off-by: Luis Henriques <lhenriques@suse.com>
> > > > > ---
> > > > > Hi Jeff,
> > > > > 
> > > > > This is a follow-up to the discussion in [1].  Since PR [2] has been
> > > > > merged, it's now time to change the kernel client to use the new
> > > > > 'copy-from2'.  And that's what this patch does.
> > > > > 
> > > > > [1] https://lore.kernel.org/lkml/20191118120935.7013-1-lhenriques@suse.com/
> > > > > [2] https://github.com/ceph/ceph/pull/31728
> > > > > 
> > > > >  fs/ceph/file.c                  | 13 ++++++++++++-
> > > > >  fs/ceph/super.c                 |  1 +
> > > > >  fs/ceph/super.h                 |  3 +++
> > > > >  include/linux/ceph/osd_client.h |  1 +
> > > > >  include/linux/ceph/rados.h      |  2 ++
> > > > >  net/ceph/osd_client.c           | 18 ++++++++++++------
> > > > >  6 files changed, 31 insertions(+), 7 deletions(-)
> > > > > 
> > > > > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > > > > index 11929d2bb594..1e6cdf2dfe90 100644
> > > > > --- a/fs/ceph/file.c
> > > > > +++ b/fs/ceph/file.c
> > > > > @@ -1974,6 +1974,10 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
> > > > >       if (ceph_test_mount_opt(src_fsc, NOCOPYFROM))
> > > > >               return -EOPNOTSUPP;
> > > > > 
> > > > > +     /* Do the OSDs support the 'copy-from2' operation? */
> > > > > +     if (!src_fsc->have_copy_from2)
> > > > > +             return -EOPNOTSUPP;
> > > > > +
> > > > >       /*
> > > > >        * Striped file layouts require that we copy partial objects, but the
> > > > >        * OSD copy-from operation only supports full-object copies.  Limit
> > > > > @@ -2101,8 +2105,15 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
> > > > >                       CEPH_OSD_OP_FLAG_FADVISE_NOCACHE,
> > > > >                       &dst_oid, &dst_oloc,
> > > > >                       CEPH_OSD_OP_FLAG_FADVISE_SEQUENTIAL |
> > > > > -                     CEPH_OSD_OP_FLAG_FADVISE_DONTNEED, 0);
> > > > > +                     CEPH_OSD_OP_FLAG_FADVISE_DONTNEED,
> > > > > +                     dst_ci->i_truncate_seq, dst_ci->i_truncate_size,
> > > > > +                     CEPH_OSD_COPY_FROM_FLAG_TRUNCATE_SEQ);
> > > > >               if (err) {
> > > > > +                     if (err == -EOPNOTSUPP) {
> > > > > +                             src_fsc->have_copy_from2 = false;
> > > > > +                             pr_notice("OSDs don't support 'copy-from2'; "
> > > > > +                                       "disabling copy_file_range\n");
> > > > > +                     }
> > > > >                       dout("ceph_osdc_copy_from returned %d\n", err);
> > > > >                       if (!ret)
> > > > >                               ret = err;
> > > > 
> > > > The patch itself looks fine to me. I'll not merge yet, since you sent it
> > > > as an RFC, but I don't have any objection to it at first glance. The
> > > > only other comment I'd make is that you should probably split this into
> > > > two patches -- one for the libceph changes and one for cephfs.
> > > > 
> > > > On a related note, I wonder if we'd get better performance out of large
> > > > copy_file_range calls here if you were to move the wait for all of these
> > > > osd requests after issuing them all in parallel?
> > > > 
> > > > Currently we're doing:
> > > > 
> > > > copy_from
> > > > wait
> > > > copy_from
> > > > wait
> > > > 
> > > > ...but figure that the second copy_from might very well be between osds
> > > > that are not involved in the first copy. There's no reason to do them
> > > > sequentially. It'd be better to issue all of the OSD requests first, and
> > > > then wait on all of the replies in turn:
> > > 
> > > If this is added (good idea in general) it should be throttled — we
> > > don’t want users accidentally trying to copy a 1TB file and setting
> > > off 250000 simultaneous copy_from2 requests!
> > 
> > Good point, thanks for the input Greg.  I'll have this in consideration.
> > That'll probably require another kernel module knob for setting this
> > throttling value.
> > 
> > 
> 
> Yes, we probably do need some sort of limit here. It'd be nice to avoid
> adding new knobs for it though. Maybe we could make this value some
> multiple of min(rsize,wsize) ?

Yeah, that's probably a reasonable approach.  I'll see what I can come up
with, once I get to it.  First, /me wants to find out if this will
_really_ improve performance.

Cheers,
--
Luís
