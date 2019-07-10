Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF7ED64C1F
	for <lists+ceph-devel@lfdr.de>; Wed, 10 Jul 2019 20:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727287AbfGJSeK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 10 Jul 2019 14:34:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:57070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727063AbfGJSeK (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 10 Jul 2019 14:34:10 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5328920651;
        Wed, 10 Jul 2019 18:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562783648;
        bh=Imp/6yldw5Nk7wj5oMtmNa024kijFVRUN+7ltmcfqbY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QpTJ8YBUQZzd4NabDHnD2Yp5zwwsFwdJdt3a3uBPCYnak+mk+vQkFaULaow0NrLnE
         7p8PJozH8Ep3h+vmDfa1von6QDzuzdh3xYnND/nqNQI6l6nBQyOxCNqzth/vrnNjzv
         JwZIJ/53KGptB63CpOOtTwvg09rb/pAlUbM5fOZE=
Message-ID: <941b9bea3fe33b95ce5d5510b810df37bb757101.camel@kernel.org>
Subject: Re: [PATCH 3/3] ceph: fix potential races in ceph_uninline_data
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.com>
Cc:     ceph-devel@vger.kernel.org, zyan@redhat.com, idryomov@gmail.com,
        sage@redhat.com
Date:   Wed, 10 Jul 2019 14:34:07 -0400
In-Reply-To: <87k1cpdaxi.fsf@suse.com>
References: <20190710161154.26125-1-jlayton@kernel.org>
         <20190710161154.26125-4-jlayton@kernel.org> <87k1cpdaxi.fsf@suse.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.3 (3.32.3-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2019-07-10 at 19:03 +0100, Luis Henriques wrote:
> Jeff Layton <jlayton@kernel.org> writes:
> 
> > The current code will do the uninlining but it relies on the caller to
> > set the i_inline_version appropriately afterward. There are several
> > potential races here.
> > 
> > Protect against competing uninlining attempts by having the callers
> > take the i_truncate_mutex and then have them update the version
> > themselves before dropping it.
> > 
> > Other callers can then re-check the i_inline_version after acquiring the
> > mutex and if it has changed to CEPH_INLINE_NONE, they can just drop it
> > and do nothing.
> > 
> > Finally since we are doing a lockless check first in all cases, just
> > move that into ceph_uninline_data as well, and have the callers call
> > it unconditionally.
> > 
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/ceph/addr.c | 33 ++++++++++++++++++++++++---------
> >  fs/ceph/file.c | 18 ++++++------------
> >  2 files changed, 30 insertions(+), 21 deletions(-)
> > 
> > diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> > index 5f1e2b6577fb..e9700c997d12 100644
> > --- a/fs/ceph/addr.c
> > +++ b/fs/ceph/addr.c
> > @@ -1541,11 +1541,9 @@ static vm_fault_t ceph_page_mkwrite(struct vm_fault *vmf)
> >  
> >  	ceph_block_sigs(&oldset);
> >  
> > -	if (ci->i_inline_version != CEPH_INLINE_NONE) {
> > -		err = ceph_uninline_data(inode, off == 0 ? page : NULL);
> > -		if (err < 0)
> > -			goto out_free;
> > -	}
> > +	err = ceph_uninline_data(inode, off == 0 ? page : NULL);
> > +	if (err < 0)
> > +		goto out_free;
> >  
> >  	if (off + PAGE_SIZE <= size)
> >  		len = PAGE_SIZE;
> > @@ -1593,7 +1591,6 @@ static vm_fault_t ceph_page_mkwrite(struct vm_fault *vmf)
> >  	    ci->i_inline_version != CEPH_INLINE_NONE) {
> >  		int dirty;
> >  		spin_lock(&ci->i_ceph_lock);
> > -		ci->i_inline_version = CEPH_INLINE_NONE;
> >  		dirty = __ceph_mark_dirty_caps(ci, CEPH_CAP_FILE_WR,
> >  					       &prealloc_cf);
> >  		spin_unlock(&ci->i_ceph_lock);
> > @@ -1656,6 +1653,10 @@ void ceph_fill_inline_data(struct inode *inode, struct page *locked_page,
> >  	}
> >  }
> >  
> > +/*
> > + * We borrow the i_truncate_mutex to serialize callers that may be racing to
> > + * uninline the data.
> > + */
> >  int ceph_uninline_data(struct inode *inode, struct page *page)
> >  {
> >  	struct ceph_inode_info *ci = ceph_inode(inode);
> > @@ -1665,15 +1666,23 @@ int ceph_uninline_data(struct inode *inode, struct page *page)
> >  	int err = 0;
> >  	bool from_pagecache = false;
> >  
> > -	spin_lock(&ci->i_ceph_lock);
> > -	inline_version = ci->i_inline_version;
> > -	spin_unlock(&ci->i_ceph_lock);
> > +	/* Do a lockless check first -- paired with i_ceph_lock for changes */
> > +	inline_version = READ_ONCE(ci->i_inline_version);
> >  
> >  	dout("uninline_data %p %llx.%llx inline_version %llu\n",
> >  	     inode, ceph_vinop(inode), inline_version);
> >  
> >  	if (inline_version == 1 || /* initial version, no data */
> >  	    inline_version == CEPH_INLINE_NONE)
> > +		return 0;
> 
> We may need to do the unlock_page(page) before returning.
> 

No, we shouldn't here, because of patch #2.

> > + + mutex_lock(&ci->i_truncate_mutex); + + /* Double check the version
> > after taking mutex */ + spin_lock(&ci->i_ceph_lock); + inline_version
> > = ci->i_inline_version; + spin_unlock(&ci->i_ceph_lock); + if
> > (inline_version == CEPH_INLINE_NONE) goto out;
> >  
> >  	if (page) {
> > @@ -1770,11 +1779,17 @@ int ceph_uninline_data(struct inode *inode, struct page *page)
> >  	err = ceph_osdc_start_request(&fsc->client->osdc, req, false);
> >  	if (!err)
> >  		err = ceph_osdc_wait_request(&fsc->client->osdc, req);
> > +	if (!err) {
> > +		spin_lock(&ci->i_ceph_lock);
> > +		inline_version = CEPH_INLINE_NONE;
> 
> Shouldn't this be ci->i_inline_version = CEPH_INLINE_NONE ?  Or maybe
> both since the dout() below uses inline_version.
> 

Yes!
-- 
Jeff Layton <jlayton@kernel.org>

