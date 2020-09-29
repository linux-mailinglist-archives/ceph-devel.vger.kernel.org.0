Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45EBD27CDF2
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Sep 2020 14:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387626AbgI2MsK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Sep 2020 08:48:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:56396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729363AbgI2Mqr (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 29 Sep 2020 08:46:47 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B18AC2083B;
        Tue, 29 Sep 2020 12:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601383606;
        bh=rupOkeDxy3oYsnvNpA2aUcNyWe43pYOz/tl4D0t3va0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GaQWKXb2Y8au5S+VPgcB1nPGrIfWWISQqSQNTncbmzTQ2EBKYSCv3iO3jYCliUVtz
         CoXYxxJ7cZWk5nMzXUkEc54RBCBwwVyyCk6kcWpb3KWooU8Jlw1aUklVoQiUIcTE48
         9/xKwqHiXszxAXrJj/INaQkTlLU7PF2Y8np8sS+Q=
Message-ID: <165246a0e8fb3db114f5b31c9950b51f551b3811.camel@kernel.org>
Subject: Re: [RFC PATCH 4/4] ceph: queue request when CLEANRECOVER is set
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Patrick Donnelly <pdonnell@redhat.com>
Date:   Tue, 29 Sep 2020 08:46:44 -0400
In-Reply-To: <CAAM7YAnNQG7-iV_LcV2Uc1qCsUFeVu1j+G426sG4ruZs=E_n+w@mail.gmail.com>
References: <20200925140851.320673-1-jlayton@kernel.org>
         <20200925140851.320673-5-jlayton@kernel.org>
         <CAAM7YAnNQG7-iV_LcV2Uc1qCsUFeVu1j+G426sG4ruZs=E_n+w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2020-09-29 at 16:31 +0800, Yan, Zheng wrote:
> On Fri, Sep 25, 2020 at 10:08 PM Jeff Layton <jlayton@kernel.org> wrote:
> > Ilya noticed that the first access to a blacklisted mount would often
> > get back -EACCES, but then subsequent calls would be OK. The problem is
> > in __do_request. If the session is marked as REJECTED, a hard error is
> > returned instead of waiting for a new session to come into being.
> > 
> > When the session is REJECTED and the mount was done with
> > recover_session=clean, queue the request to the waiting_for_map queue,
> > which will be awoken after tearing down the old session.
> > 
> > URL: https://tracker.ceph.com/issues/47385
> > Reported-by: Ilya Dryomov <idryomov@gmail.com>
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/ceph/mds_client.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > index fd16db6ecb0a..b07e7adf146f 100644
> > --- a/fs/ceph/mds_client.c
> > +++ b/fs/ceph/mds_client.c
> > @@ -2819,7 +2819,10 @@ static void __do_request(struct ceph_mds_client *mdsc,
> >         if (session->s_state != CEPH_MDS_SESSION_OPEN &&
> >             session->s_state != CEPH_MDS_SESSION_HUNG) {
> >                 if (session->s_state == CEPH_MDS_SESSION_REJECTED) {
> > -                       err = -EACCES;
> > +                       if (ceph_test_mount_opt(mdsc->fsc, CLEANRECOVER))
> > +                               list_add(&req->r_wait, &mdsc->waiting_for_map);
> > +                       else
> > +                               err = -EACCES;
> 
> During recovering session, client drops all dirty caps and abort all
> osd requests.  It does not make sense , some operations are waiting,
> the others get aborted.
> 


It makes sense to drop the caps and fail writeback of pages that were
dirty. The issue here is what to do with MDS (metadata) requests that
come in just after we notice the blocklisting but before the session has
been reestablished. Most of those aren't going to have any dependency on
the state of the pagecache.

They also (for the most part) won't have a dependency on caps. The main
exception I see is async unlink (async creates will be saved by the fact
we'll be dropping our delegated inode number range). An async unlink
could end up stalling across a recovery. The new MDS probably won't have
granted Du caps by the time the call goes out. We could cancel that but
likely would have already returned success on the unlink() call.

Granted, with all of this we're _way_ outside the realm of POSIX
behavior, so ultimately the right behavior is whatever we decide it
should be. Anyone who turns this stuff on should be prepared for some of
the operations leading up to the blocklisting to vaporize.

-- 
Jeff Layton <jlayton@kernel.org>

