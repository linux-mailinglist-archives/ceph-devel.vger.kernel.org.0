Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C78B252DFC
	for <lists+ceph-devel@lfdr.de>; Wed, 26 Aug 2020 14:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729676AbgHZMIP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 26 Aug 2020 08:08:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:43812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728934AbgHZMHY (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 26 Aug 2020 08:07:24 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4C2720838;
        Wed, 26 Aug 2020 12:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598443642;
        bh=bLzcXQ6Df8fpdqMZL0oCEgZ5PQZJnrK0uDNHGq/TWmg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=B113A5K+NXe4MxL0/NCmdo53RcK5CZQFkQRQVrW8YOjGBNeksw4yhJgn2DZ8x1jGH
         XLHTszypsb0B3EHSSKm15wFnMdbVG53pvxVrXn1I5h/2P1aDeje4U2dE570txOWBcl
         kEK76wRPnR6Y1wzwKhVQdjB1wTZLh/G5UOq/mkOA=
Message-ID: <72113751267b6ca23def361c19c0a85524735e3e.camel@kernel.org>
Subject: Re: [PATCH] ceph: drop special-casing for ITER_PIPE in
 ceph_sync_read
From:   Jeff Layton <jlayton@kernel.org>
To:     John Hubbard <jhubbard@nvidia.com>, ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, ukernel@gmail.com, viro@zeniv.linux.org.uk
Date:   Wed, 26 Aug 2020 08:07:20 -0400
In-Reply-To: <1143a189-7953-d523-bfd2-0fed8da83ac8@nvidia.com>
References: <20200825201326.286242-1-jlayton@kernel.org>
         <1143a189-7953-d523-bfd2-0fed8da83ac8@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2020-08-25 at 13:28 -0700, John Hubbard wrote:
> On 8/25/20 1:13 PM, Jeff Layton wrote:
> > From: John Hubbard <jhubbard@nvidia.com>
> > 
> 
> I think that's meant to be, "From: Jeff Layton <jlayton@kernel.org>".

Yeah, sorry -- artifact from squashing patches together. I noticed this
after I sent it out. It's fixed in tree though.

> This looks much nicer than what I came up with. :)
> 
> > This special casing was added in 7ce469a53e71 (ceph: fix splice
> > read for no Fc capability case). The confirm callback for ITER_PIPE
> > expects that the page is Uptodate or a pagecache page and and returns
> > an error otherwise.
> > 
> > A simpler workaround is just to use the Uptodate bit, which has no
> > meaning for anonymous pages. Rip out the special casing for ITER_PIPE
> > and just SetPageUptodate before we copy to the iter.
> > 
> > Cc: "Yan, Zheng" <ukernel@gmail.com>
> > Cc: John Hubbard <jhubbard@nvidia.com>
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
> > ---
> >   fs/ceph/file.c | 71 +++++++++++++++++---------------------------------
> >   1 file changed, 24 insertions(+), 47 deletions(-)
> > 
> > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > index fb3ea715a19d..ed8fbfe3bddc 100644
> > --- a/fs/ceph/file.c
> > +++ b/fs/ceph/file.c
> > @@ -863,6 +863,8 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
> >   		size_t page_off;
> >   		u64 i_size;
> >   		bool more;
> > +		int idx;
> > +		size_t left;
> >   
> >   		req = ceph_osdc_new_request(osdc, &ci->i_layout,
> >   					ci->i_vino, off, &len, 0, 1,
> > @@ -876,29 +878,13 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
> >   
> >   		more = len < iov_iter_count(to);
> >   
> > -		if (unlikely(iov_iter_is_pipe(to))) {
> > -			ret = iov_iter_get_pages_alloc(to, &pages, len,
> > -						       &page_off);
> 
> +1 for removing a call to iov_iter_get_pages_alloc()! My list is shorter now.
> 

Yep, and we got rid of some special-casing in ceph to boot. Thanks for
bringing it to our attention!

-- 
Jeff Layton <jlayton@kernel.org>

