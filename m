Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEC2B1BF8CC
	for <lists+ceph-devel@lfdr.de>; Thu, 30 Apr 2020 15:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbgD3NDd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 30 Apr 2020 09:03:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726770AbgD3NDd (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 30 Apr 2020 09:03:33 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BCC12076D;
        Thu, 30 Apr 2020 13:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588251812;
        bh=37JYruxc6RRcPOyba+Tfs3iw/r4R4J6RQN7RZVcwxlA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Uxz9YfyHQ8L1ft2i8tKA6T/6Nh9ZzuZwwvvRaKwixNQYJYlf3mRDlLWcLs1+D33sB
         fJH0pSLACPEGY8Ui8r9OaRm68yDN3NIOOzZaULWZQDWEo3LQjh96Gabxm1btuiX0a8
         BnboUZ6qHVO2TyfEs0h4FGmIVczylYczPM2R7HWY=
Message-ID: <4f37cee17e39b03470ec3248cae44d3f0868ce0f.camel@kernel.org>
Subject: Re: [PATCH] ceph: fix up endian bug in managing feature bits
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Eduard Shishkin <edward6@linux.ibm.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        Ulrich.Weigand@de.ibm.com, Tuan.Hoang1@ibm.com,
        "Yan, Zheng" <ukernel@gmail.com>
Date:   Thu, 30 Apr 2020 09:03:30 -0400
In-Reply-To: <CAOi1vP-6sWTw68UJx4kV-0fmhLGE0=hw3ZYPYd8tp6aXVNYJXg@mail.gmail.com>
References: <1588023986-23672-1-git-send-email-edward6@linux.ibm.com>
         <f36451800e4656f99483f4d47487a40ea5f942cd.camel@kernel.org>
         <d322ad5e-8409-7e5e-8d16-a2706223f26f@linux.ibm.com>
         <ea3dc3b2657a766f2fc253fe6b1bac08aeb968db.camel@kernel.org>
         <CAOi1vP-6sWTw68UJx4kV-0fmhLGE0=hw3ZYPYd8tp6aXVNYJXg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.1 (3.36.1-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2020-04-29 at 18:08 +0200, Ilya Dryomov wrote:
> On Wed, Apr 29, 2020 at 5:42 PM Jeff Layton <jlayton@kernel.org> wrote:
> > On Wed, 2020-04-29 at 11:46 +0200, Eduard Shishkin wrote:
> > > On 4/28/20 2:23 PM, Jeff Layton wrote:
> > > > On Mon, 2020-04-27 at 23:46 +0200, edward6@linux.ibm.com wrote:
> > > > > From: Eduard Shishkin <edward6@linux.ibm.com>
> > > > > 
> > > > > In the function handle_session() variable @features always
> > > > > contains little endian order of bytes. Just because the feature
> > > > > bits are packed bytewise from left to right in
> > > > > encode_supported_features().
> > > > > 
> > > > > However, test_bit(), called to check features availability, assumes
> > > > > the host order of bytes in that variable. This leads to problems on
> > > > > big endian architectures. Specifically it is impossible to mount
> > > > > ceph volume on s390.
> > > > > 
> > > > > This patch adds conversion from little endian to the host order
> > > > > of bytes, thus fixing the problem.
> > > > > 
> > > > > Signed-off-by: Eduard Shishkin <edward6@linux.ibm.com>
> > > > > ---
> > > > >   fs/ceph/mds_client.c | 4 ++--
> > > > >   1 file changed, 2 insertions(+), 2 deletions(-)
> > > > > 
> > > > > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > > > > index 486f91f..190598d 100644
> > > > > --- a/fs/ceph/mds_client.c
> > > > > +++ b/fs/ceph/mds_client.c
> > > > > @@ -3252,7 +3252,7 @@ static void handle_session(struct ceph_mds_session *session,
> > > > >           struct ceph_mds_session_head *h;
> > > > >           u32 op;
> > > > >           u64 seq;
> > > > > - unsigned long features = 0;
> > > > > + __le64 features = 0;
> > > > >           int wake = 0;
> > > > >           bool blacklisted = false;
> > > > > 
> > > > > @@ -3301,7 +3301,7 @@ static void handle_session(struct ceph_mds_session *session,
> > > > >                   if (session->s_state == CEPH_MDS_SESSION_RECONNECTING)
> > > > >                           pr_info("mds%d reconnect success\n", session->s_mds);
> > > > >                   session->s_state = CEPH_MDS_SESSION_OPEN;
> > > > > -         session->s_features = features;
> > > > > +         session->s_features = le64_to_cpu(features);
> > > > >                   renewed_caps(mdsc, session, 0);
> > > > >                   wake = 1;
> > > > >                   if (mdsc->stopping)
> > > > 
> > > > (cc'ing Zheng since he did the original patches here)
> > > > 
> > > > Thanks Eduard. The problem is real, but I think we can just do the
> > > > conversion during the decode.
> > > > 
> > > > The feature mask words sent by the MDS are 64 bits, so if it's smaller
> > > > we can assume that it's malformed. So, I don't think we need to handle
> > > > the case where it's smaller than 8 bytes.
> > > > 
> > > > How about this patch instead?
> > > 
> > > Hi Jeff,
> > > 
> > > This also works. Please, apply.
> > > 
> > > Thanks,
> > > Eduard.
> > > 
> > 
> > Thanks. Merged into ceph-client/testing branch, and should make v5.8.
> 
> I think this is stable material.  I'll tag it and get it queued up for 5.7-rc.
> 
> Thanks,
> 

Yeah, that sounds reasonable.

If you're going to send up another PR, then we might want to add these
bugfixes currently in the testing branch to it as well:

445645c8be5f fs/ceph:fix special error code in ceph_try_get_caps()
591681748b56 fs/ceph:fix double unlock in handle_cap_export()
0e84a1ebe161 ceph: ceph_kick_flushing_caps needs the s_mutex

I'm not sure that any of them need to go to stable though. We might also
want this one though:

7b3facb61440 ceph: reset i_requested_max_size if file write is not wanted

...but it'll probably need to be reworked due to merge conflicts if we
move it ahead of some of the cap handling cleanup patches (or we could
just pull those in too).

Zheng, do you have an opinion here? Should 7b3facb61440 go to stable?

Thanks,
--
Jeff Layton <jlayton@kernel.org>

