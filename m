Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26158152983
	for <lists+ceph-devel@lfdr.de>; Wed,  5 Feb 2020 12:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728225AbgBELAD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 5 Feb 2020 06:00:03 -0500
Received: from mx2.suse.de ([195.135.220.15]:53350 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727522AbgBELAD (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 5 Feb 2020 06:00:03 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 26937ACEF;
        Wed,  5 Feb 2020 11:00:00 +0000 (UTC)
Date:   Wed, 5 Feb 2020 11:00:07 +0000
From:   Luis Henriques <lhenriques@suse.com>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        Gregory Farnum <gfarnum@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/1] ceph: parallelize all copy-from requests in
 copy_file_range
Message-ID: <20200205110007.GA11836@suse.com>
References: <20200203165117.5701-1-lhenriques@suse.com>
 <20200203165117.5701-2-lhenriques@suse.com>
 <CAOi1vP8vXeY156baexdZY2FWK_F0jHfWkyNdZ90PA+7txG=Qsw@mail.gmail.com>
 <20200204151158.GA15992@suse.com>
 <CAOi1vP-LvJYwAALQ_69rDUaiXYWa-_NPboeZV5zZiw_cokNyfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOi1vP-LvJYwAALQ_69rDUaiXYWa-_NPboeZV5zZiw_cokNyfw@mail.gmail.com>
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Feb 04, 2020 at 07:06:36PM +0100, Ilya Dryomov wrote:
> On Tue, Feb 4, 2020 at 4:11 PM Luis Henriques <lhenriques@suse.com> wrote:
> >
> > On Tue, Feb 04, 2020 at 11:56:57AM +0100, Ilya Dryomov wrote:
> > ...
> > > > @@ -2108,21 +2118,40 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
> > > >                         CEPH_OSD_OP_FLAG_FADVISE_DONTNEED,
> > > >                         dst_ci->i_truncate_seq, dst_ci->i_truncate_size,
> > > >                         CEPH_OSD_COPY_FROM_FLAG_TRUNCATE_SEQ);
> > > > -               if (err) {
> > > > -                       if (err == -EOPNOTSUPP) {
> > > > -                               src_fsc->have_copy_from2 = false;
> > > > -                               pr_notice("OSDs don't support 'copy-from2'; "
> > > > -                                         "disabling copy_file_range\n");
> > > > -                       }
> > > > +               if (IS_ERR(req)) {
> > > > +                       err = PTR_ERR(req);
> > > >                         dout("ceph_osdc_copy_from returned %d\n", err);
> > > > +
> > > > +                       /* wait for all queued requests */
> > > > +                       ceph_osdc_wait_requests(&osd_reqs, &reqs_complete);
> > > > +                       ret += reqs_complete * object_size; /* Update copied bytes */
> > >
> > > Hi Luis,
> > >
> > > Looks like ret is still incremented unconditionally?  What happens
> > > if there are three OSD requests on the list and the first fails but
> > > the second and the third succeed?  As is, ceph_osdc_wait_requests()
> > > will return an error with reqs_complete set to 2...
> > >
> > > >                         if (!ret)
> > > >                                 ret = err;
> > >
> > > ... and we will return 8M instead of an error.
> >
> > Right, my assumption was that if a request fails, all subsequent requests
> > would also fail.  This would allow ret to be updated with the number of
> > successful requests (x object size), even if the OSDs replies were being
> > delivered in a different order.  But from your comment I see that my
> > assumption is incorrect.
> >
> > In that case, when shall ret be updated with the number of bytes already
> > written?  Only after a successful call to ceph_osdc_wait_requests()?
> 
> I mentioned this in the previous email: you probably want to change
> ceph_osdc_wait_requests() so that the counter isn't incremented after
> an error is encountered.

Sure, I've seen that comment.  But it doesn't help either because it's not
guaranteed that we'll receive the replies from the OSDs in the same order
we've sent them.  Stopping the counter when we get an error doesn't
provide us any reliable information (which means I can simply drop that
counter).

> > I.e. only after each throttling cycle, when we don't have any requests
> > pending completion?  In this case, I can simply drop the extra
> > reqs_complete parameter to the ceph_osdc_wait_requests.
> >
> > In your example the right thing to do would be to simply return an error,
> > I guess.  But then we're assuming that we're loosing space in the storage,
> > as we may have created objects that won't be reachable anymore.
> 
> Well, that is what I'm getting at -- this needs a lot more
> consideration.  How errors are dealt with, how file metadata is
> updated, when do we fall back to plain copy, etc.  Generating stray
> objects is bad but way better than reporting that e.g. 0..12M were
> copied when only 0..4M and 8M..12M were actually copied, leaving
> the user one step away from data loss.  One option is to revert to
> issuing copy-from requests serially when an error is encountered.
> Another option is to fall back to plain copy on any error.  Or perhaps
> we just don't bother with the complexity of parallel copy-from requests
> at all...

To be honest, I'm starting to lean towards this option.  Reverting to
serializing requests or to plain copy on error will not necessarily
prevent the stray objects:

  - send a bunch of copy requests
  - wait for them to complete
     * 1 failed, the other 63 succeeded
  - revert to serialized copies, repeating the previous 64 requests
     * after a few copies, we get another failure (maybe on the same OSDs)
       and abort, leaving behind some stray objects from the previous bulk
       request

I guess the only way around this would be some sort of atomic operation
that would allow us to copy a bunch of objects in a single operation
(copy-from3!)

I thought a bit a about this while watching Jeff and Patrick's talk at
FOSDEM (great talk, by the way!) but I don't think async directory
operations have this problem because the requests there are
metadata-related and a failure in a request is somewhat independent from
other requests.

> Of course, no matter what we do for parallel copy-from requests, the
> existing short copy bug needs to be fixed separately.

Yep, 20200205102852.12236-1-lhenriques@suse.com should fix that (Cc'ed
stable@ as well).

Cheers,
--
Luís

> 
> >
> > >
> > > >                         goto out_caps;
> > > >                 }
> > > > +               list_add(&req->r_private_item, &osd_reqs);
> > > >                 len -= object_size;
> > > >                 src_off += object_size;
> > > >                 dst_off += object_size;
> > > > -               ret += object_size;
> > > > +               /*
> > > > +                * Wait requests if we've reached the maximum requests allowed
> > > > +                * or if this was the last copy
> > > > +                */
> > > > +               if ((--copy_count == 0) || (len < object_size)) {
> > > > +                       err = ceph_osdc_wait_requests(&osd_reqs, &reqs_complete);
> > > > +                       ret += reqs_complete * object_size; /* Update copied bytes */
> > >
> > > Same here.
> > >
> > > > +                       if (err) {
> > > > +                               if (err == -EOPNOTSUPP) {
> > > > +                                       src_fsc->have_copy_from2 = false;
> > >
> > > Since EOPNOTSUPP is special in that it triggers the fallback, it
> > > should be returned even if something was copied.  Think about a
> > > mixed cluster, where some OSDs support copy-from2 and some don't.
> > > If the range is split between such OSDs, copy_file_range() will
> > > always return short if the range happens to start on a new OSD.
> >
> > IMO, if we managed to copy some objects, we still need to return the
> > number of bytes copied.  Because, since this return value will be less
> > then the expected amount of bytes, the application will retry the
> > operation.  And at that point, since we've set have_copy_from2 to 'false',
> > the default VFS implementation will be used.
> 
> Ah, yeah, given have_copy_from2 guard, this particular corner case is
> fine.
> 
> Thanks,
> 
>                 Ilya
