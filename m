Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0371092AF
	for <lists+ceph-devel@lfdr.de>; Mon, 25 Nov 2019 18:22:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728868AbfKYRWU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 25 Nov 2019 12:22:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:41558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727508AbfKYRWU (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 25 Nov 2019 12:22:20 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1976920748;
        Mon, 25 Nov 2019 17:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574702539;
        bh=SEfIU4FIDnMgT7gmjKjO3vzxFNaiqMbMG7o1jEWqUdw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ym3HBsc3wIDhNzOqm8kJ3lDGovmj/xOpfUqW0wVm03zX5xKVwwZ4a7t6GOYLBjiDh
         ICrNgopdmWIyWWfTZvqVwjW4ITKkmRMMHUL4VORqUFkOeU+sOEXqL6JNpaAt1SOnVb
         RvvtBFObLfEVA4RyeisdA06fifnqkaLg7P5Xjf/Q=
Message-ID: <49bdbfbaab4d2080a045da0678d760880888c85b.camel@kernel.org>
Subject: Re: [PATCH v2 2/3] mdsmap: fix mdsmap cluster available check based
 on laggy number
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Mon, 25 Nov 2019 12:22:17 -0500
In-Reply-To: <7e9ebebf-10b2-76e4-ae5f-cbdde25061f1@redhat.com>
References: <20191125110827.12827-1-xiubli@redhat.com>
         <20191125110827.12827-3-xiubli@redhat.com>
         <3cbf12af7e05ea711e376ddbf93be5abf84fbf00.camel@kernel.org>
         <7e9ebebf-10b2-76e4-ae5f-cbdde25061f1@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1 (3.34.1-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2019-11-25 at 21:50 +0800, Xiubo Li wrote:
> On 2019/11/25 21:27, Jeff Layton wrote:
> > On Mon, 2019-11-25 at 06:08 -0500, xiubli@redhat.com wrote:
> > > From: Xiubo Li <xiubli@redhat.com>
> > > 
> > > In case the max_mds > 1 in MDS cluster and there is no any standby
> > > MDS and all the max_mds MDSs are in up:active state, if one of the
> > > up:active MDSs is dead, the m->m_num_laggy in kclient will be 1.
> > > Then the mount will fail without considering other healthy MDSs.
> > > 
> > > There manybe some MDSs still "in" the cluster but not in up:active
> > > state, we will ignore them. Only when all the up:active MDSs in
> > > the cluster are laggy will treat the cluster as not be available.
> > > 
> > > In case decreasing the max_mds, the cluster will not stop the extra
> > > up:active MDSs immediately and there will be a latency. During it
> > > the up:active MDS number will be larger than the max_mds, so later
> > > the m_info memories will 100% be reallocated.
> > > 
> > > Here will pick out the up:active MDSs as the m_num_mds and allocate
> > > the needed memories once.
> > > 
> > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > ---
> > >   fs/ceph/mdsmap.c            | 32 ++++++++++----------------------
> > >   include/linux/ceph/mdsmap.h |  5 +++--
> > >   2 files changed, 13 insertions(+), 24 deletions(-)
> > > 
> > > diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
> > > index 471bac335fae..cc9ec959fe46 100644
> > > --- a/fs/ceph/mdsmap.c
> > > +++ b/fs/ceph/mdsmap.c
> > > @@ -138,14 +138,21 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end)
> > >   	m->m_session_autoclose = ceph_decode_32(p);
> > >   	m->m_max_file_size = ceph_decode_64(p);
> > >   	m->m_max_mds = ceph_decode_32(p);
> > > -	m->m_num_mds = m->m_max_mds;
> > > +
> > > +	/*
> > > +	 * pick out the active nodes as the m_num_mds, the m_num_mds
> > > +	 * maybe larger than m_max_mds when decreasing the max_mds in
> > > +	 * cluster side, in other case it should less than or equal
> > > +	 * to m_max_mds.
> > > +	 */
> > > +	m->m_num_mds = n = ceph_decode_32(p);
> > > +	m->m_num_active_mds = m->m_num_mds;
> > >   
> > >   	m->m_info = kcalloc(m->m_num_mds, sizeof(*m->m_info), GFP_NOFS);
> > >   	if (!m->m_info)
> > >   		goto nomem;
> > >   
> > >   	/* pick out active nodes from mds_info (state > 0) */
> > > -	n = ceph_decode_32(p);
> > >   	for (i = 0; i < n; i++) {
> > >   		u64 global_id;
> > >   		u32 namelen;
> > > @@ -218,17 +225,6 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end)
> > >   		if (mds < 0 || state <= 0)
> > >   			continue;
> > >   
> > > -		if (mds >= m->m_num_mds) {
> > > -			int new_num = max(mds + 1, m->m_num_mds * 2);
> > > -			void *new_m_info = krealloc(m->m_info,
> > > -						new_num * sizeof(*m->m_info),
> > > -						GFP_NOFS | __GFP_ZERO);
> > > -			if (!new_m_info)
> > > -				goto nomem;
> > > -			m->m_info = new_m_info;
> > > -			m->m_num_mds = new_num;
> > > -		}
> > > -
> > I don't think we want to get rid of this bit. What happens if the number
> > of MDS' increases after the mount occurs?
> Every time when we receive a new version of mdsmap, the old whole 
> mdsc->mdsmap memory will be reallocated and replaced, no matter the MDS' 
> increases or decreases.
> 
> The active nodes from mds_info above will help record the actual MDS 
> number and then we decode it into "m_num_active_mds". If we are 
> decreasing the max_mds in the cluster side, the "m_num_active_mds" will 
> very probably be larger than the expected "m_num_mds", then we 
> definitely will need to reallocate the memory for m->m_info here. Why 
> not allocate enough memory beforehand ?
> 
> BTW, from my investigation that the mds number decoded from the mds_info 
> won't be larger than the "m_num_active_mds". If I am right then this 
> code is useless here, or we need it.
> 

It shouldn't be larger than that, but...the "mds" value is decoded from
the map and gets treated as an index into the m_info array. If that
value ends up being larger than the array you initially allocated, then
we're looking at a buffer overrun.

I don't think we should trust the consistency of the info in the map to
that degree, so we either need to keep something like the reallocation
in place, or add some sanity checks to make sure that that possibility
is handled sanely.

> 
> > >   		info = &m->m_info[mds];
> > >   		info->global_id = global_id;
> > >   		info->state = state;
> > > @@ -247,14 +243,6 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end)
> > >   			info->export_targets = NULL;
> > >   		}
> > >   	}
> > > -	if (m->m_num_mds > m->m_max_mds) {
> > > -		/* find max up mds */
> > > -		for (i = m->m_num_mds; i >= m->m_max_mds; i--) {
> > > -			if (i == 0 || m->m_info[i-1].state > 0)
> > > -				break;
> > > -		}
> > > -		m->m_num_mds = i;
> > > -	}
> > >   
> > >   	/* pg_pools */
> > >   	ceph_decode_32_safe(p, end, n, bad);
> > > @@ -396,7 +384,7 @@ bool ceph_mdsmap_is_cluster_available(struct ceph_mdsmap *m)
> > >   		return false;
> > >   	if (m->m_damaged)
> > >   		return false;
> > > -	if (m->m_num_laggy > 0)
> > > +	if (m->m_num_laggy == m->m_num_active_mds)
> > >   		return false;
> > >   	for (i = 0; i < m->m_num_mds; i++) {
> > >   		if (m->m_info[i].state == CEPH_MDS_STATE_ACTIVE)
> > > diff --git a/include/linux/ceph/mdsmap.h b/include/linux/ceph/mdsmap.h
> > > index 0067d767c9ae..3a66f4f926ce 100644
> > > --- a/include/linux/ceph/mdsmap.h
> > > +++ b/include/linux/ceph/mdsmap.h
> > > @@ -25,8 +25,9 @@ struct ceph_mdsmap {
> > >   	u32 m_session_timeout;          /* seconds */
> > >   	u32 m_session_autoclose;        /* seconds */
> > >   	u64 m_max_file_size;
> > > -	u32 m_max_mds;                  /* size of m_addr, m_state arrays */
> > > -	int m_num_mds;
> > > +	u32 m_max_mds;			/* expected up:active mds number */
> > > +	int m_num_active_mds;		/* actual up:active mds number */
> > > +	int m_num_mds;                  /* size of m_info array */
> > >   	struct ceph_mds_info *m_info;
> > >   
> > >   	/* which object pools file data can be stored in */
> 
> 

-- 
Jeff Layton <jlayton@kernel.org>

