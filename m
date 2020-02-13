Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03D8515BDB1
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Feb 2020 12:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729544AbgBMLfO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 13 Feb 2020 06:35:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:48016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726232AbgBMLfO (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 13 Feb 2020 06:35:14 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A50632073C;
        Thu, 13 Feb 2020 11:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581593713;
        bh=dAvaKgdyLJ0tpfAtFwrwvwE1CI0xkU8dmN9m4xr/r+E=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cN1CF9ZYqdlUA4IJglwqKfburiFnnP+OTXoXUxUtJtYpArYw/+/bLN0oaIklOj1Fl
         ydII7KQsEdh7otETvTC/rcT2+8ow7KYyrvAVvypxEKPYNhjX21eeanuz6G6yML94ON
         KPeKD7aa5xjN7esUaFoKbm+euJph+QZ/AZ2fhCP0=
Message-ID: <07c0e667bd2c766081ccfe4fb9532874095832d9.camel@kernel.org>
Subject: Re: [PATCH v4 1/9] ceph: add flag to designate that a request is
 asynchronous
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>, idridryomov@gmail.com,
        Sage Weil <sage@redhat.com>, Zheng Yan <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>
Date:   Thu, 13 Feb 2020 06:35:11 -0500
In-Reply-To: <CAAM7YA==_fYLnaVjhs51=T5Ju+t8EtDSQEpUTYKko620h86=-A@mail.gmail.com>
References: <20200212172729.260752-1-jlayton@kernel.org>
         <20200212172729.260752-2-jlayton@kernel.org>
         <CAAM7YA==_fYLnaVjhs51=T5Ju+t8EtDSQEpUTYKko620h86=-A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.3 (3.34.3-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2020-02-13 at 17:29 +0800, Yan, Zheng wrote:
> On Thu, Feb 13, 2020 at 1:29 AM Jeff Layton <jlayton@kernel.org> wrote:
> > ...and ensure that such requests are never queued. The MDS has need to
> > know that a request is asynchronous so add flags and proper
> > infrastructure for that.
> > 
> > Also, delegated inode numbers and directory caps are associated with the
> > session, so ensure that async requests are always transmitted on the
> > first attempt and are never queued to wait for session reestablishment.
> > 
> > If it does end up looking like we'll need to queue the request, then
> > have it return -EJUKEBOX so the caller can reattempt with a synchronous
> > request.
> > 
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/ceph/inode.c              |  1 +
> >  fs/ceph/mds_client.c         | 11 +++++++++++
> >  fs/ceph/mds_client.h         |  1 +
> >  include/linux/ceph/ceph_fs.h |  5 +++--
> >  4 files changed, 16 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> > index 094b8fc37787..9869ec101e88 100644
> > --- a/fs/ceph/inode.c
> > +++ b/fs/ceph/inode.c
> > @@ -1311,6 +1311,7 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
> >                 err = fill_inode(in, req->r_locked_page, &rinfo->targeti, NULL,
> >                                 session,
> >                                 (!test_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags) &&
> > +                                !test_bit(CEPH_MDS_R_ASYNC, &req->r_req_flags) &&
> >                                  rinfo->head->result == 0) ?  req->r_fmode : -1,
> >                                 &req->r_caps_reservation);
> >                 if (err < 0) {
> > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > index 2980e57ca7b9..9f2aeb6908b2 100644
> > --- a/fs/ceph/mds_client.c
> > +++ b/fs/ceph/mds_client.c
> > @@ -2527,6 +2527,8 @@ static int __prepare_send_request(struct ceph_mds_client *mdsc,
> >         rhead->oldest_client_tid = cpu_to_le64(__get_oldest_tid(mdsc));
> >         if (test_bit(CEPH_MDS_R_GOT_UNSAFE, &req->r_req_flags))
> >                 flags |= CEPH_MDS_FLAG_REPLAY;
> > +       if (test_bit(CEPH_MDS_R_ASYNC, &req->r_req_flags))
> > +               flags |= CEPH_MDS_FLAG_ASYNC;
> >         if (req->r_parent)
> >                 flags |= CEPH_MDS_FLAG_WANT_DENTRY;
> >         rhead->flags = cpu_to_le32(flags);
> > @@ -2634,6 +2636,15 @@ static void __do_request(struct ceph_mds_client *mdsc,
> >                         err = -EACCES;
> >                         goto out_session;
> >                 }
> > +               /*
> > +                * We cannot queue async requests since the caps and delegated
> > +                * inodes are bound to the session. Just return -EJUKEBOX and
> > +                * let the caller retry a sync request in that case.
> > +                */
> > +               if (test_bit(CEPH_MDS_R_ASYNC, &req->r_req_flags)) {
> > +                       err = -EJUKEBOX;
> > +                       goto out_session;
> > +               }
> 
> the code near __choose_mds also can queue request
> 
> 

Ahh, right. Something like this maybe:

[PATCH] SQUASH: don't allow async req to be queued waiting for mdsmap

Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/ceph/mds_client.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 09d5301b036c..ac5bd58bb971 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -2702,6 +2702,10 @@ static void __do_request(struct ceph_mds_client *mdsc,
 	mds = __choose_mds(mdsc, req, &random);
 	if (mds < 0 ||
 	    ceph_mdsmap_get_state(mdsc->mdsmap, mds) < CEPH_MDS_STATE_ACTIVE) {
+		if (test_bit(CEPH_MDS_R_ASYNC, &req->r_req_flags)) {
+			err = -EJUKEBOX;
+			goto finish;
+		}
 		dout("do_request no mds or not active, waiting for map\n");
 		list_add(&req->r_wait, &mdsc->waiting_for_map);
 		return;
-- 
2.24.1


