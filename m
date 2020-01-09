Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F35E135D8F
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Jan 2020 17:06:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733021AbgAIQF4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 Jan 2020 11:05:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:58910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728584AbgAIQFy (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 9 Jan 2020 11:05:54 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E8562072E;
        Thu,  9 Jan 2020 16:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578585953;
        bh=E+4soxqfhxfGquTmA4RcmwB0tyse1BamCGTUnkYpNUs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Ft1LzzTY7zNPdOi90ZeMSvPTVYCq+XFqhKAjHJl2td3VS3ZZEA7AgBwZ8P68BlVAe
         mlj6Q8B20E2e0eOi3Pq5cmXxFhCgOCBsVEb1NQFgKPOZ7jZ1TZaIvJ5s5bqIvpZc6I
         R5AaShIfRWCZkkdAdcN5nB1J8L2Pk1XfNRsaqaTs=
Message-ID: <0c8566e39221cc475840da0f93913aeaa77dc0e4.camel@kernel.org>
Subject: Re: [RFC PATCH v4] ceph: use 'copy-from2' operation in
 copy_file_range
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>,
        Luis Henriques <lhenriques@suse.com>
Cc:     Sage Weil <sage@redhat.com>, "Yan, Zheng" <zyan@redhat.com>,
        Gregory Farnum <gfarnum@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date:   Thu, 09 Jan 2020 11:05:50 -0500
In-Reply-To: <CAOi1vP-YbPswsmk5TicVwnspBSkz9_8HreOWmpU=kZeTWWiV-A@mail.gmail.com>
References: <20200108100353.23770-1-lhenriques@suse.com>
         <913eb28e6bb698f27f1831f75ea5250497ee659c.camel@kernel.org>
         <20200109143011.GA14582@brahms>
         <CAOi1vP-YbPswsmk5TicVwnspBSkz9_8HreOWmpU=kZeTWWiV-A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2020-01-09 at 15:53 +0100, Ilya Dryomov wrote:
> On Thu, Jan 9, 2020 at 3:30 PM Luis Henriques <lhenriques@suse.com> wrote:
> > On Thu, Jan 09, 2020 at 08:06:17AM -0500, Jeff Layton wrote:
> > > On Wed, 2020-01-08 at 10:03 +0000, Luis Henriques wrote:
> > > > Instead of using the 'copy-from' operation, switch copy_file_range to the
> > > > new 'copy-from2' operation, which allows to send the truncate_seq and
> > > > truncate_size parameters.
> > > > 
> > > > If an OSD does not support the 'copy-from2' operation it will return
> > > > -EOPNOTSUPP.  In that case, the kernel client will stop trying to do
> > > > remote object copies for this fs client and will always use the generic
> > > > VFS copy_file_range.
> > > > 
> > > > Signed-off-by: Luis Henriques <lhenriques@suse.com>
> > > > ---
> > > > Hi Jeff,
> > > > 
> > > > This is a follow-up to the discussion in [1].  Since PR [2] has been
> > > > merged, it's now time to change the kernel client to use the new
> > > > 'copy-from2'.  And that's what this patch does.
> > > > 
> > > > [1] https://lore.kernel.org/lkml/20191118120935.7013-1-lhenriques@suse.com/
> > > > [2] https://github.com/ceph/ceph/pull/31728
> > > > 
> > > >  fs/ceph/file.c                  | 13 ++++++++++++-
> > > >  fs/ceph/super.c                 |  1 +
> > > >  fs/ceph/super.h                 |  3 +++
> > > >  include/linux/ceph/osd_client.h |  1 +
> > > >  include/linux/ceph/rados.h      |  2 ++
> > > >  net/ceph/osd_client.c           | 18 ++++++++++++------
> > > >  6 files changed, 31 insertions(+), 7 deletions(-)
> > > > 
> > > > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > > > index 11929d2bb594..1e6cdf2dfe90 100644
> > > > --- a/fs/ceph/file.c
> > > > +++ b/fs/ceph/file.c
> > > > @@ -1974,6 +1974,10 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
> > > >     if (ceph_test_mount_opt(src_fsc, NOCOPYFROM))
> > > >             return -EOPNOTSUPP;
> > > > 
> > > > +   /* Do the OSDs support the 'copy-from2' operation? */
> > > > +   if (!src_fsc->have_copy_from2)
> > > > +           return -EOPNOTSUPP;
> > > > +
> > > >     /*
> > > >      * Striped file layouts require that we copy partial objects, but the
> > > >      * OSD copy-from operation only supports full-object copies.  Limit
> > > > @@ -2101,8 +2105,15 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
> > > >                     CEPH_OSD_OP_FLAG_FADVISE_NOCACHE,
> > > >                     &dst_oid, &dst_oloc,
> > > >                     CEPH_OSD_OP_FLAG_FADVISE_SEQUENTIAL |
> > > > -                   CEPH_OSD_OP_FLAG_FADVISE_DONTNEED, 0);
> > > > +                   CEPH_OSD_OP_FLAG_FADVISE_DONTNEED,
> > > > +                   dst_ci->i_truncate_seq, dst_ci->i_truncate_size,
> > > > +                   CEPH_OSD_COPY_FROM_FLAG_TRUNCATE_SEQ);
> > > >             if (err) {
> > > > +                   if (err == -EOPNOTSUPP) {
> > > > +                           src_fsc->have_copy_from2 = false;
> > > > +                           pr_notice("OSDs don't support 'copy-from2'; "
> > > > +                                     "disabling copy_file_range\n");
> > > > +                   }
> > > >                     dout("ceph_osdc_copy_from returned %d\n", err);
> > > >                     if (!ret)
> > > >                             ret = err;
> > > 
> > > The patch itself looks fine to me. I'll not merge yet, since you sent it
> > > as an RFC, but I don't have any objection to it at first glance.
> > 
> > I was going to drop the RFC, but then at the last minute decided to leave.
> > 
> > >                                                                    The
> > > only other comment I'd make is that you should probably split this into
> > > two patches -- one for the libceph changes and one for cephfs.
> > 
> > Hmm... TBH I didn't thought about that, but since the libceph patch would
> > be changing its API (ceph_osdc_copy_from would have 2 extra parameters), I
> > don't think that's a good idea.  Bisection would be broken between these 2
> > patches.
> 

In that case, I'll just go ahead and do some testing with this patch and
will plan to merge it as-is, assuming that goes ok.
-- 
Jeff Layton <jlayton@kernel.org>

