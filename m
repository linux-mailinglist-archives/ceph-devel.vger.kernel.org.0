Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB6615317C
	for <lists+ceph-devel@lfdr.de>; Wed,  5 Feb 2020 14:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbgBENMZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 5 Feb 2020 08:12:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:59484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726961AbgBENMZ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 5 Feb 2020 08:12:25 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7CEA217BA;
        Wed,  5 Feb 2020 13:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580908344;
        bh=oKgy9dQpK3nwx7Di04OkzCy+/fe0qZS/610lbODO8hI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=sC8i8s7/YIFcU7OUABAhe6F2vKi8VFazY8PbSlXTGuerjJ/c0pgvdVpC51ZPWc5Lf
         XB9Xqf97SiTkRymP1A//84Dds8OKAm++iQ+GwI6nUO1oSH2KCzBdhPDsSbjMl+d99D
         wp4cxx09am02m5/WCrZzfB04/gnFPvGLds6W0R0s=
Message-ID: <2ce07148b49e6c1a857b4dd90c3bcea6ed0e8ce3.camel@kernel.org>
Subject: Re: [PATCH v3 1/1] ceph: parallelize all copy-from requests in
 copy_file_range
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>,
        Luis Henriques <lhenriques@suse.com>
Cc:     Sage Weil <sage@redhat.com>, "Yan, Zheng" <zyan@redhat.com>,
        Gregory Farnum <gfarnum@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date:   Wed, 05 Feb 2020 08:12:22 -0500
In-Reply-To: <CAOi1vP-kLCY+Q2UwpqvJdfeEV6me=FneLhasQrj2nkcu_7tRew@mail.gmail.com>
References: <20200203165117.5701-1-lhenriques@suse.com>
         <20200203165117.5701-2-lhenriques@suse.com>
         <CAOi1vP8vXeY156baexdZY2FWK_F0jHfWkyNdZ90PA+7txG=Qsw@mail.gmail.com>
         <20200204151158.GA15992@suse.com>
         <CAOi1vP-LvJYwAALQ_69rDUaiXYWa-_NPboeZV5zZiw_cokNyfw@mail.gmail.com>
         <20200205110007.GA11836@suse.com>
         <CAOi1vP-kLCY+Q2UwpqvJdfeEV6me=FneLhasQrj2nkcu_7tRew@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.3 (3.34.3-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2020-02-05 at 13:01 +0100, Ilya Dryomov wrote:
> On Wed, Feb 5, 2020 at 12:00 PM Luis Henriques <lhenriques@suse.com> wrote:
> > On Tue, Feb 04, 2020 at 07:06:36PM +0100, Ilya Dryomov wrote:
> > > On Tue, Feb 4, 2020 at 4:11 PM Luis Henriques <lhenriques@suse.com> wrote:
> > > > On Tue, Feb 04, 2020 at 11:56:57AM +0100, Ilya Dryomov wrote:
> > > > ...
> > > > > > @@ -2108,21 +2118,40 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
> > > > > >                         CEPH_OSD_OP_FLAG_FADVISE_DONTNEED,
> > > > > >                         dst_ci->i_truncate_seq, dst_ci->i_truncate_size,
> > > > > >                         CEPH_OSD_COPY_FROM_FLAG_TRUNCATE_SEQ);
> > > > > > -               if (err) {
> > > > > > -                       if (err == -EOPNOTSUPP) {
> > > > > > -                               src_fsc->have_copy_from2 = false;
> > > > > > -                               pr_notice("OSDs don't support 'copy-from2'; "
> > > > > > -                                         "disabling copy_file_range\n");
> > > > > > -                       }
> > > > > > +               if (IS_ERR(req)) {
> > > > > > +                       err = PTR_ERR(req);
> > > > > >                         dout("ceph_osdc_copy_from returned %d\n", err);
> > > > > > +
> > > > > > +                       /* wait for all queued requests */
> > > > > > +                       ceph_osdc_wait_requests(&osd_reqs, &reqs_complete);
> > > > > > +                       ret += reqs_complete * object_size; /* Update copied bytes */
> > > > > 
> > > > > Hi Luis,
> > > > > 
> > > > > Looks like ret is still incremented unconditionally?  What happens
> > > > > if there are three OSD requests on the list and the first fails but
> > > > > the second and the third succeed?  As is, ceph_osdc_wait_requests()
> > > > > will return an error with reqs_complete set to 2...
> > > > > 
> > > > > >                         if (!ret)
> > > > > >                                 ret = err;
> > > > > 
> > > > > ... and we will return 8M instead of an error.
> > > > 
> > > > Right, my assumption was that if a request fails, all subsequent requests
> > > > would also fail.  This would allow ret to be updated with the number of
> > > > successful requests (x object size), even if the OSDs replies were being
> > > > delivered in a different order.  But from your comment I see that my
> > > > assumption is incorrect.
> > > > 
> > > > In that case, when shall ret be updated with the number of bytes already
> > > > written?  Only after a successful call to ceph_osdc_wait_requests()?
> > > 
> > > I mentioned this in the previous email: you probably want to change
> > > ceph_osdc_wait_requests() so that the counter isn't incremented after
> > > an error is encountered.
> > 
> > Sure, I've seen that comment.  But it doesn't help either because it's not
> > guaranteed that we'll receive the replies from the OSDs in the same order
> > we've sent them.  Stopping the counter when we get an error doesn't
> > provide us any reliable information (which means I can simply drop that
> > counter).
> 
> The list is FIFO so even though replies may indeed arrive out of
> order, ceph_osdc_wait_requests() will process them in order.  If you
> stop counting as soon as an error is encountered, you know for sure
> that requests 1 through $COUNTER were successful and can safely
> multiply it by object size.
> 
> > > > I.e. only after each throttling cycle, when we don't have any requests
> > > > pending completion?  In this case, I can simply drop the extra
> > > > reqs_complete parameter to the ceph_osdc_wait_requests.
> > > > 
> > > > In your example the right thing to do would be to simply return an error,
> > > > I guess.  But then we're assuming that we're loosing space in the storage,
> > > > as we may have created objects that won't be reachable anymore.
> > > 
> > > Well, that is what I'm getting at -- this needs a lot more
> > > consideration.  How errors are dealt with, how file metadata is
> > > updated, when do we fall back to plain copy, etc.  Generating stray
> > > objects is bad but way better than reporting that e.g. 0..12M were
> > > copied when only 0..4M and 8M..12M were actually copied, leaving
> > > the user one step away from data loss.  One option is to revert to
> > > issuing copy-from requests serially when an error is encountered.
> > > Another option is to fall back to plain copy on any error.  Or perhaps
> > > we just don't bother with the complexity of parallel copy-from requests
> > > at all...
> > 
> > To be honest, I'm starting to lean towards this option.  Reverting to
> > serializing requests or to plain copy on error will not necessarily
> > prevent the stray objects:
> > 
> >   - send a bunch of copy requests
> >   - wait for them to complete
> >      * 1 failed, the other 63 succeeded
> >   - revert to serialized copies, repeating the previous 64 requests
> >      * after a few copies, we get another failure (maybe on the same OSDs)
> >        and abort, leaving behind some stray objects from the previous bulk
> >        request
> 
> Yeah, doing it serially makes the accounting a lot easier.  If you
> issue any OSD requests before updating the size, stray objects are
> bound to happen -- that's why "how file metadata is updated" is one
> of the important considerations.

I don't think this is fundamentally different from the direct write
codepath. It's just that the source of the write is another OSD rather
than being sent in the request.

If you look at ceph_direct_read_write(), then it does this:

      /*
       * To simplify error handling, allow AIO when IO within i_size
       * or IO can be satisfied by single OSD request.
       */

So, that's another possibility. Do the requests synchronously when they
will result in a change to i_size. Otherwise, you can do them in
parallel.

In practice, we'd have to recommend that people truncate the destination
file up to the final length before doing copy_file_range, but that
doesn't sound too onerous.

-- 
Jeff Layton <jlayton@kernel.org>

