Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8EB01073B8
	for <lists+ceph-devel@lfdr.de>; Fri, 22 Nov 2019 14:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbfKVNz0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 22 Nov 2019 08:55:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:34194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726907AbfKVNz0 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 22 Nov 2019 08:55:26 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BFD82071C;
        Fri, 22 Nov 2019 13:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574430925;
        bh=QCuODaQWU4Ixd30dwmYw/Y33hdUBTvZHb9kwF7mFPys=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DYNGZr5DziHC5F5paX/9GhmhX6epCcAp522kpeU7hF4auSI1m7lnWwggWlQ2vOQ90
         sIWKOBdwbcP/Lb8pCeAkdcN9Y4/4axH4ahf0Tj9ZJioT/MwStWKQAS4WJiTyJ1wR7W
         r7BcCj44B+JTXciWLzgUX2RHWTcON32Y+JQw9ZxA=
Message-ID: <69d4abdfe6f62eac5be6f1b8203faa68942cc849.camel@kernel.org>
Subject: Re: [PATCH 2/3] mdsmap: fix mdsmap cluster available check based on
 laggy number
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Fri, 22 Nov 2019 08:55:23 -0500
In-Reply-To: <3fbcbc90-b323-5e8a-5664-fe8ce64a5100@redhat.com>
References: <20191120082902.38666-1-xiubli@redhat.com>
         <20191120082902.38666-3-xiubli@redhat.com>
         <52135037d9009f678e1b05964f0d6a1366a77ed0.camel@kernel.org>
         <3fbcbc90-b323-5e8a-5664-fe8ce64a5100@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1 (3.34.1-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2019-11-22 at 14:56 +0800, Xiubo Li wrote:
> On 2019/11/22 1:30, Jeff Layton wrote:
> > On Wed, 2019-11-20 at 03:29 -0500, xiubli@redhat.com wrote:
> > > From: Xiubo Li <xiubli@redhat.com>
> > > 
> > > In case the max_mds > 1 in MDS cluster and there is no any standby
> > > MDS and all the max_mds MDSs are in up:active state, if one of the
> > > up:active MDSs is dead, the m->m_num_laggy in kclient will be 1.
> > > Then the mount will fail without considering other healthy MDSs.
> > > 
> > > Only when all the MDSs in the cluster are laggy will treat the
> > > cluster as not be available.
> > > 
> > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > ---
> > >   fs/ceph/mdsmap.c | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
> > > index 471bac335fae..8b4f93e5b468 100644
> > > --- a/fs/ceph/mdsmap.c
> > > +++ b/fs/ceph/mdsmap.c
> > > @@ -396,7 +396,7 @@ bool ceph_mdsmap_is_cluster_available(struct ceph_mdsmap *m)
> > >   		return false;
> > >   	if (m->m_damaged)
> > >   		return false;
> > > -	if (m->m_num_laggy > 0)
> > > +	if (m->m_num_laggy == m->m_num_mds)
> > >   		return false;
> > >   	for (i = 0; i < m->m_num_mds; i++) {
> > >   		if (m->m_info[i].state == CEPH_MDS_STATE_ACTIVE)
> > Given that laggy servers are still expected to be "in" the cluster,
> > should we just eliminate this check altogether? It seems like we'd still
> > want to allow a mount to occur even if the cluster is lagging.
> 
> For this we need one way to distinguish between mds crash and transient 
> mds laggy, for now in both cases the mds will keep staying "in" the 
> cluster and be in "up:active & laggy" state.

I would doubt there's any way to do that reliably, and in any case
detection of that state will always involve some delay.

ceph_mdsmap_is_cluster_available() is only called when mounting though.
We wouldn't want to choose a laggy server over one that isn't, but I
don't think we want to fail to mount just because all of the servers
appear to be laggy. We should consider such servers to be potentially
available but not preferred.
-- 
Jeff Layton <jlayton@kernel.org>

