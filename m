Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1E13ACB7D
	for <lists+ceph-devel@lfdr.de>; Fri, 18 Jun 2021 14:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233006AbhFRM6k (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 18 Jun 2021 08:58:40 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:58284 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbhFRM6j (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 18 Jun 2021 08:58:39 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 97AF021B65;
        Fri, 18 Jun 2021 12:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624020989; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PcyfQz3H0EhDjM8W+4AzftwfgJwUKiUsJIV90gdWAoo=;
        b=jpW/TDuRvP2C5jbJlZvogWqa6SK6CIpjY+3F4NmzhM1bmm6I5OgkVZTtYEd8MMCPg2i2Hu
        Tb/NEmb0LZLNzwKHe3yXpHqLNHM6/pkjpQW1uUwqA2YZ4pd+5NtNAHpNzbqoTZ6nakxgtE
        6sLYvWdooUXLup1YhshIhs4tY32+eX8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624020989;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PcyfQz3H0EhDjM8W+4AzftwfgJwUKiUsJIV90gdWAoo=;
        b=qmAStBNW6zevnvObBs0oFFekbDuhFmcw+KRdpGhwL5EWYgDhTYq2bHFBdfrrl1kRITOlXg
        BqpXW2P+Qb4aH2Ag==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 23E29118DD;
        Fri, 18 Jun 2021 12:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624020989; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PcyfQz3H0EhDjM8W+4AzftwfgJwUKiUsJIV90gdWAoo=;
        b=jpW/TDuRvP2C5jbJlZvogWqa6SK6CIpjY+3F4NmzhM1bmm6I5OgkVZTtYEd8MMCPg2i2Hu
        Tb/NEmb0LZLNzwKHe3yXpHqLNHM6/pkjpQW1uUwqA2YZ4pd+5NtNAHpNzbqoTZ6nakxgtE
        6sLYvWdooUXLup1YhshIhs4tY32+eX8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624020989;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PcyfQz3H0EhDjM8W+4AzftwfgJwUKiUsJIV90gdWAoo=;
        b=qmAStBNW6zevnvObBs0oFFekbDuhFmcw+KRdpGhwL5EWYgDhTYq2bHFBdfrrl1kRITOlXg
        BqpXW2P+Qb4aH2Ag==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id KUbFBf2XzGDBJAAALh3uQQ
        (envelope-from <lhenriques@suse.de>); Fri, 18 Jun 2021 12:56:29 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 6ef9f199;
        Fri, 18 Jun 2021 12:56:28 +0000 (UTC)
Date:   Fri, 18 Jun 2021 13:56:28 +0100
From:   Luis Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, pdonnell@redhat.com, ukernel@gmail.com,
        idryomov@gmail.com, xiubli@redhat.com
Subject: Re: [RFC PATCH 6/6] ceph: eliminate ceph_async_iput()
Message-ID: <YMyX/EjKZRV8/liC@suse.de>
References: <20210615145730.21952-1-jlayton@kernel.org>
 <20210615145730.21952-7-jlayton@kernel.org>
 <YMoYE+DYFt+eEAWm@suse.de>
 <1d1b99544873ba7d7fb5442db152e739a5234c39.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1d1b99544873ba7d7fb5442db152e739a5234c39.camel@kernel.org>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Jun 17, 2021 at 12:24:35PM -0400, Jeff Layton wrote:
> On Wed, 2021-06-16 at 16:26 +0100, Luis Henriques wrote:
> > On Tue, Jun 15, 2021 at 10:57:30AM -0400, Jeff Layton wrote:
> > > Now that we don't need to hold session->s_mutex or the snap_rwsem when
> > > calling ceph_check_caps, we can eliminate ceph_async_iput and just use
> > > normal iput calls.
> > > 
> > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > ---
> > >  fs/ceph/caps.c       |  6 +++---
> > >  fs/ceph/inode.c      | 25 +++----------------------
> > >  fs/ceph/mds_client.c | 22 +++++++++++-----------
> > >  fs/ceph/quota.c      |  6 +++---
> > >  fs/ceph/snap.c       | 10 +++++-----
> > >  fs/ceph/super.h      |  2 --
> > >  6 files changed, 25 insertions(+), 46 deletions(-)
> > > 
> > > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > > index 5864d5088e27..fd9243e9a1b2 100644
> > > --- a/fs/ceph/caps.c
> > > +++ b/fs/ceph/caps.c
> > > @@ -3147,7 +3147,7 @@ void ceph_put_wrbuffer_cap_refs(struct ceph_inode_info *ci, int nr,
> > >  		wake_up_all(&ci->i_cap_wq);
> > >  	while (put-- > 0) {
> > >  		/* avoid calling iput_final() in osd dispatch threads */
> > > -		ceph_async_iput(inode);
> > > +		iput(inode);
> > >  	}
> > >  }
> > >  
> > > @@ -4136,7 +4136,7 @@ void ceph_handle_caps(struct ceph_mds_session *session,
> > >  done_unlocked:
> > >  	ceph_put_string(extra_info.pool_ns);
> > >  	/* avoid calling iput_final() in mds dispatch threads */
> > > -	ceph_async_iput(inode);
> > > +	iput(inode);
> > 
> > To be honest, I'm not really convinced we can blindly substitute
> > ceph_async_iput() by iput().  This case specifically can problematic
> > because we may have called ceph_queue_vmtruncate() above (or
> > handle_cap_grant()).  If we did, we have ci->i_work_mask set and the wq
> > would have invoked __ceph_do_pending_vmtruncate().  Using the iput() here
> > won't have that result.  Am I missing something?
> > 
> 
> The point of this set is to make iput safe to run even when the s_mutex
> and/or snap_rwsem is held. When we queue up the ci->i_work, we do take a
> reference to the inode and still run iput there. This set just stops
> queueing iputs themselves to the workqueue.
> 
> I really don't see a problem with this call site in ceph_handle_caps in
> particular, as it's calling iput after dropping the s_mutex. Probably
> that should not have been converted to use ceph_async_iput in the first
> place.

Obviously, you're right.  I don't what I was thinking of when I was
reading this code and saw: ci->i_work_mask bits are set in one place (in
ceph_queue_vmtruncate(), for ex.) and then the work is queued only in
ceph_async_iput().  Which is obviously wrong!

Anyway, sorry for the noise.

(Oh, and BTW: this patch should also remove comments such as "avoid
calling iput_final() in mds dispatch threads", and similar that exist in
several places before ceph_async_iput() is (or rather *was*) called.)

Cheers,
--
Luís
