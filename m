Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 494E9116D4A
	for <lists+ceph-devel@lfdr.de>; Mon,  9 Dec 2019 13:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727600AbfLIMqG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 9 Dec 2019 07:46:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:56646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727200AbfLIMqF (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 9 Dec 2019 07:46:05 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCD2A20726;
        Mon,  9 Dec 2019 12:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575895564;
        bh=/uFyJznLZFu2dkwFr/BBG8k7IlHuyGXhBCl3MEKt5EU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=OFl1boSZOzX2Utpb1707dK52KTqBkiXLTFyz3wc6BapDB0kASNXseLEeIQ4XoHtVt
         rGg0PnX9emZG04vUOw5WxHwZoRU5W1BnoLb9Nm00pv9fh0YgTvYRs30x6RI5WdCWrD
         0UqStR6aom3rxJAoq6nPeqPYtGv6AUPGHUhvrpBc=
Message-ID: <c8fff676999dfc43321ae5e73eda9d958ca3ea89.camel@kernel.org>
Subject: Re: [PATCH] ceph: clean the dirty page when session is closed or
 rejected
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Mon, 09 Dec 2019 07:46:02 -0500
In-Reply-To: <0d3d8008-f675-431d-0eb4-f064ea88aa5c@redhat.com>
References: <20191209092830.22157-1-xiubli@redhat.com>
         <3db8af6d73324694035532611036d8bc5e3d9921.camel@kernel.org>
         <0d3d8008-f675-431d-0eb4-f064ea88aa5c@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2019-12-09 at 19:54 +0800, Xiubo Li wrote:
> On 2019/12/9 19:38, Jeff Layton wrote:
> > On Mon, 2019-12-09 at 04:28 -0500, xiubli@redhat.com wrote:
> > > From: Xiubo Li <xiubli@redhat.com>
> > > 
> > > Try to queue writeback and invalidate the dirty pages when sessions
> > > are closed, rejected or reconnect denied.
> > > 
> > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > ---
> > >   fs/ceph/mds_client.c | 13 +++++++++++++
> > >   1 file changed, 13 insertions(+)
> > > 
> > Can you explain a bit more about the problem you're fixing? In what
> > situation is this currently broken, and what are the effects of that
> > breakage?
> > 
> > > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > > index be1ac9f8e0e6..68f3b5ed6ac8 100644
> > > --- a/fs/ceph/mds_client.c
> > > +++ b/fs/ceph/mds_client.c
> > > @@ -1385,9 +1385,11 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
> > >   {
> > >   	struct ceph_fs_client *fsc = (struct ceph_fs_client *)arg;
> > >   	struct ceph_inode_info *ci = ceph_inode(inode);
> > > +	struct ceph_mds_session *session = cap->session;
> > >   	LIST_HEAD(to_remove);
> > >   	bool dirty_dropped = false;
> > >   	bool invalidate = false;
> > > +	bool writeback = false;
> > >   
> > >   	dout("removing cap %p, ci is %p, inode is %p\n",
> > >   	     cap, ci, &ci->vfs_inode);
> > > @@ -1398,12 +1400,21 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
> > >   	if (!ci->i_auth_cap) {
> > >   		struct ceph_cap_flush *cf;
> > >   		struct ceph_mds_client *mdsc = fsc->mdsc;
> > > +		int s_state = session->s_state;
> > >   
> > >   		if (READ_ONCE(fsc->mount_state) == CEPH_MOUNT_SHUTDOWN) {
> > >   			if (inode->i_data.nrpages > 0)
> > >   				invalidate = true;
> > >   			if (ci->i_wrbuffer_ref > 0)
> > >   				mapping_set_error(&inode->i_data, -EIO);
> > > +		} else if (s_state == CEPH_MDS_SESSION_CLOSED ||
> > > +			   s_state == CEPH_MDS_SESSION_REJECTED) {
> > > +			/* reconnect denied or rejected */
> > > +			if (!__ceph_is_any_real_caps(ci) &&
> > > +			    inode->i_data.nrpages > 0)
> > > +				invalidate = true;
> > > +			if (ci->i_wrbuffer_ref > 0)
> > > +				writeback = true;
> > I don't know here. If the session is CLOSED/REJECTED, is kicking off
> > writeback the right thing to do? In principle, this means that the
> > client may have been blacklisted and none of the writes will succeed.
> 
> If the client was blacklisted,  it will be not safe to still buffer the 
> data and flush it after the related sessions are reconnected without 
> remounting.
> 
> Maybe we need to throw it directly.
> 
> 

It depends. We have tunable behavior for this now.

I think you may want to look over the recover_session= patches  that
were merged v5.4 ((131d7eb4faa1fc, and previous patches). That mount
option governs what happens if the client is blacklisted, and then the
blacklisting is later removed.

Will this patch change either recover_session= behavior? If so, then you
should explain how and why.


> > >   		}
> > >   
> > >   		while (!list_empty(&ci->i_cap_flush_list)) {
> > > @@ -1472,6 +1483,8 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
> > >   	}
> > >   
> > >   	wake_up_all(&ci->i_cap_wq);
> > > +	if (writeback)
> > > +		ceph_queue_writeback(inode);
> > >   	if (invalidate)
> > >   		ceph_queue_invalidate(inode);
> > >   	if (dirty_dropped)
> > Thanks,
> 
> 

-- 
Jeff Layton <jlayton@kernel.org>

