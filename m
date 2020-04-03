Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5128119D51E
	for <lists+ceph-devel@lfdr.de>; Fri,  3 Apr 2020 12:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390586AbgDCKhM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 3 Apr 2020 06:37:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:36196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727774AbgDCKhL (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 3 Apr 2020 06:37:11 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB0B020737;
        Fri,  3 Apr 2020 10:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585910230;
        bh=HNA5qbbZtorQENdiOhAUjVNkNFRm/fmdQxW1PrWc1tg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZN3r/jHZzsvQuwXUAaE4Tb4Z1ScMtVUEtKOrnUG4lk9MUbsqoNVBTpW4ZWkcPUc90
         4FwyQ90kKmvX3zRLE9YENOQGPAbgWRXpsQB2flDtJmA70dOFqKqNtC6zsHfcrVhBqw
         vn+dpKQyYMsIqtWCX9iY4p6ClgGd//32LAoWZtCo=
Message-ID: <599b09e9b901fd9b86e3e45c4875abbc680c321d.camel@kernel.org>
Subject: Re: [PATCH v2 2/2] ceph: request expedited service on session's
 last cap flush
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.com>
Cc:     ceph-devel@vger.kernel.org, ukernel@gmail.com, idryomov@gmail.com,
        sage@redhat.com, jfajerski@suse.com, gfarnum@redhat.com
Date:   Fri, 03 Apr 2020 06:37:08 -0400
In-Reply-To: <20200403102317.GA1066@suse.com>
References: <20200402112911.17023-1-jlayton@kernel.org>
         <20200402112911.17023-3-jlayton@kernel.org>
         <20200403102317.GA1066@suse.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2020-04-03 at 11:23 +0100, Luis Henriques wrote:
> On Thu, Apr 02, 2020 at 07:29:11AM -0400, Jeff Layton wrote:
> > When flushing a lot of caps to the MDS's at once (e.g. for syncfs),
> > we can end up waiting a substantial amount of time for MDS replies, due
> > to the fact that it may delay some of them so that it can batch them up
> > together in a single journal transaction. This can lead to stalls when
> > calling sync or syncfs.
> > 
> > What we'd really like to do is request expedited service on the _last_
> > cap we're flushing back to the server. If the CHECK_CAPS_FLUSH flag is
> > set on the request and the current inode was the last one on the
> > session->s_cap_dirty list, then mark the request with
> > CEPH_CLIENT_CAPS_SYNC.
> > 
> > Note that this heuristic is not perfect. New inodes can race onto the
> > list after we've started flushing, but it does seem to fix some common
> > use cases.
> > 
> > Reported-by: Jan Fajerski <jfajerski@suse.com>
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/ceph/caps.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > index 95c9b25e45a6..3630f05993b3 100644
> > --- a/fs/ceph/caps.c
> > +++ b/fs/ceph/caps.c
> > @@ -1987,6 +1987,7 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
> >  	}
> >  
> >  	for (p = rb_first(&ci->i_caps); p; p = rb_next(p)) {
> > +		int mflags = 0;
> >  		struct cap_msg_args arg;
> >  
> >  		cap = rb_entry(p, struct ceph_cap, ci_node);
> > @@ -2118,6 +2119,9 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
> >  			flushing = ci->i_dirty_caps;
> >  			flush_tid = __mark_caps_flushing(inode, session, false,
> >  							 &oldest_flush_tid);
> > +			if (flags & CHECK_CAPS_FLUSH &&
> > +			    list_empty(&session->s_cap_dirty))
> > +				mflags |= CEPH_CLIENT_CAPS_SYNC;
> >  		} else {
> >  			flushing = 0;
> >  			flush_tid = 0;
> > @@ -2128,8 +2132,8 @@ void ceph_check_caps(struct ceph_inode_info *ci, int flags,
> >  
> >  		mds = cap->mds;  /* remember mds, so we don't repeat */
> >  
> > -		__prep_cap(&arg, cap, CEPH_CAP_OP_UPDATE, 0, cap_used, want,
> > -			   retain, flushing, flush_tid, oldest_flush_tid);
> > +		__prep_cap(&arg, cap, CEPH_CAP_OP_UPDATE, mflags, cap_used,
> > +			   want, retain, flushing, flush_tid, oldest_flush_tid);
> >  		spin_unlock(&ci->i_ceph_lock);
> >  
> >  		__send_cap(mdsc, &arg, ci);
> > -- 
> > 2.25.1
> > 
> 
> FWIW, it looks good to me.  I've also tested it and I confirm it improves
> (a lot!) the testcase reported by Jan.  Maybe it's worth adding the URL to
> the tracker.
> 

Will do. Thanks for the reminder!
-- 
Jeff Layton <jlayton@kernel.org>

