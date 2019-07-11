Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB1F6540A
	for <lists+ceph-devel@lfdr.de>; Thu, 11 Jul 2019 11:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728301AbfGKJmX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 11 Jul 2019 05:42:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:44602 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728292AbfGKJmX (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 11 Jul 2019 05:42:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AF9D4AE74;
        Thu, 11 Jul 2019 09:42:21 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.com>
To:     "Jeff Layton" <jlayton@kernel.org>
Cc:     <idryomov@gmail.com>, <sage@redhat.com>, <zyan@redhat.com>,
        <ceph-devel@vger.kernel.org>
Subject: Re: [PATCH 3/3] ceph: fix potential races in ceph_uninline_data
References: <20190710161154.26125-1-jlayton@kernel.org>
        <20190710161154.26125-4-jlayton@kernel.org> <87k1cpdaxi.fsf@suse.com>
        <941b9bea3fe33b95ce5d5510b810df37bb757101.camel@kernel.org>
Date:   Thu, 11 Jul 2019 10:42:20 +0100
In-Reply-To: <941b9bea3fe33b95ce5d5510b810df37bb757101.camel@kernel.org> (Jeff
        Layton's message of "Wed, 10 Jul 2019 14:34:07 -0400")
Message-ID: <87a7dk6h6r.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

"Jeff Layton" <jlayton@kernel.org> writes:

> On Wed, 2019-07-10 at 19:03 +0100, Luis Henriques wrote:
>> Jeff Layton <jlayton@kernel.org> writes:
>> 
>> > The current code will do the uninlining but it relies on the caller to
>> > set the i_inline_version appropriately afterward. There are several
>> > potential races here.
>> > 
>> > Protect against competing uninlining attempts by having the callers
>> > take the i_truncate_mutex and then have them update the version
>> > themselves before dropping it.
>> > 
>> > Other callers can then re-check the i_inline_version after acquiring the
>> > mutex and if it has changed to CEPH_INLINE_NONE, they can just drop it
>> > and do nothing.
>> > 
>> > Finally since we are doing a lockless check first in all cases, just
>> > move that into ceph_uninline_data as well, and have the callers call
>> > it unconditionally.
>> > 
>> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
>> > ---
>> >  fs/ceph/addr.c | 33 ++++++++++++++++++++++++---------
>> >  fs/ceph/file.c | 18 ++++++------------
>> >  2 files changed, 30 insertions(+), 21 deletions(-)
>> > 
>> > diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
>> > index 5f1e2b6577fb..e9700c997d12 100644
>> > --- a/fs/ceph/addr.c
>> > +++ b/fs/ceph/addr.c
>> > @@ -1541,11 +1541,9 @@ static vm_fault_t ceph_page_mkwrite(struct vm_fault *vmf)
>> >  
>> >  	ceph_block_sigs(&oldset);
>> >  
>> > -	if (ci->i_inline_version != CEPH_INLINE_NONE) {
>> > -		err = ceph_uninline_data(inode, off == 0 ? page : NULL);
>> > -		if (err < 0)
>> > -			goto out_free;
>> > -	}
>> > +	err = ceph_uninline_data(inode, off == 0 ? page : NULL);
>> > +	if (err < 0)
>> > +		goto out_free;
>> >  
>> >  	if (off + PAGE_SIZE <= size)
>> >  		len = PAGE_SIZE;
>> > @@ -1593,7 +1591,6 @@ static vm_fault_t ceph_page_mkwrite(struct vm_fault *vmf)
>> >  	    ci->i_inline_version != CEPH_INLINE_NONE) {
>> >  		int dirty;
>> >  		spin_lock(&ci->i_ceph_lock);
>> > -		ci->i_inline_version = CEPH_INLINE_NONE;
>> >  		dirty = __ceph_mark_dirty_caps(ci, CEPH_CAP_FILE_WR,
>> >  					       &prealloc_cf);
>> >  		spin_unlock(&ci->i_ceph_lock);
>> > @@ -1656,6 +1653,10 @@ void ceph_fill_inline_data(struct inode *inode, struct page *locked_page,
>> >  	}
>> >  }
>> >  
>> > +/*
>> > + * We borrow the i_truncate_mutex to serialize callers that may be racing to
>> > + * uninline the data.
>> > + */
>> >  int ceph_uninline_data(struct inode *inode, struct page *page)
>> >  {
>> >  	struct ceph_inode_info *ci = ceph_inode(inode);
>> > @@ -1665,15 +1666,23 @@ int ceph_uninline_data(struct inode *inode, struct page *page)
>> >  	int err = 0;
>> >  	bool from_pagecache = false;
>> >  
>> > -	spin_lock(&ci->i_ceph_lock);
>> > -	inline_version = ci->i_inline_version;
>> > -	spin_unlock(&ci->i_ceph_lock);
>> > +	/* Do a lockless check first -- paired with i_ceph_lock for changes */
>> > +	inline_version = READ_ONCE(ci->i_inline_version);
>> >  
>> >  	dout("uninline_data %p %llx.%llx inline_version %llu\n",
>> >  	     inode, ceph_vinop(inode), inline_version);
>> >  
>> >  	if (inline_version == 1 || /* initial version, no data */
>> >  	    inline_version == CEPH_INLINE_NONE)
>> > +		return 0;
>> 
>> We may need to do the unlock_page(page) before returning.
>> 
>
> No, we shouldn't here, because of patch #2.

Doh!  Right, sorry.

Regarding your earlier inquire (on IRC) about copy_file_range handling
of inline data: a quick look shows that it does not really handle it.  I
guess that the right thing to do is to simply return -EOPNOTSUPP if
either src or dst inodes have i_inline_version = CEPH_INLINE_NONE.

In practice, this may happen already because due to:

	if (len < src_ci->i_layout.object_size)
        	return -EOPNOTSUPP;

but I couldn't dig all the details on how big the inlined data can be.
I could see client_max_inline_size being mentioned in the docs, but at a
first glance this isn't enforced by the MDS but only validated by the
fuse client (I could be wrong, as I just did a quick grep in the code).

Anyway, I'll soon send a patch to do an explicit check for inline data
in the cfr implementation.

Cheers,
-- 
Luis

>
>> > + + mutex_lock(&ci->i_truncate_mutex); + + /* Double check the version
>> > after taking mutex */ + spin_lock(&ci->i_ceph_lock); + inline_version
>> > = ci->i_inline_version; + spin_unlock(&ci->i_ceph_lock); + if
>> > (inline_version == CEPH_INLINE_NONE) goto out;
>> >  
>> >  	if (page) {
>> > @@ -1770,11 +1779,17 @@ int ceph_uninline_data(struct inode *inode, struct page *page)
>> >  	err = ceph_osdc_start_request(&fsc->client->osdc, req, false);
>> >  	if (!err)
>> >  		err = ceph_osdc_wait_request(&fsc->client->osdc, req);
>> > +	if (!err) {
>> > +		spin_lock(&ci->i_ceph_lock);
>> > +		inline_version = CEPH_INLINE_NONE;
>> 
>> Shouldn't this be ci->i_inline_version = CEPH_INLINE_NONE ?  Or maybe
>> both since the dout() below uses inline_version.
>> 
>
> Yes!

