Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2F31260FC
	for <lists+ceph-devel@lfdr.de>; Thu, 19 Dec 2019 12:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbfLSLjd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 19 Dec 2019 06:39:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:48506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726692AbfLSLja (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 19 Dec 2019 06:39:30 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 294532082E;
        Thu, 19 Dec 2019 11:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576755568;
        bh=LXBDsubEijKVjR2Ap/9NlfAl3z8mON8g9LLUpDHw4pY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RnODh74AKWmLUNrAFBm4g9U4qNnJk4WPRs+w3JkNv235aQcl14Fhdpxp5qFSNizcF
         7cOt5rGtu+DtKca1YQWJ8vuS3p10dD8UAYQ3VmKaaEqPQLkVsbfmHTppgFcg5snwF/
         Q6Ti5Z2+raAOjvTEMlKhZFvbOr+5bJ5Vakog9PWA=
Message-ID: <d2793594c1577c60bd940577ff143b34a3cb2891.camel@kernel.org>
Subject: Re: [PATCH] ceph: add possible_max_rank and make the code more
 readable
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Thu, 19 Dec 2019 06:39:27 -0500
In-Reply-To: <20191204115739.53303-1-xiubli@redhat.com>
References: <20191204115739.53303-1-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2019-12-04 at 06:57 -0500, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> The m_num_mds here is actually the number for MDSs which are in
> up:active status, and it will be duplicated to m_num_active_mds,
> so remove it.
> 
> Add possible_max_rank to the mdsmap struct and this will be
> the correctly possible largest rank boundary.
> 
> Remove the special case for one mds in __mdsmap_get_random_mds(),
> because the validate mds rank may not always be 0.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/debugfs.c           |  2 +-
>  fs/ceph/mds_client.c        | 10 ++++----
>  fs/ceph/mdsmap.c            | 49 +++++++++++++++----------------------
>  include/linux/ceph/mdsmap.h | 10 ++++----
>  4 files changed, 31 insertions(+), 40 deletions(-)
> 
> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> index facb387c2735..0b1591e76077 100644
> --- a/fs/ceph/debugfs.c
> +++ b/fs/ceph/debugfs.c
> @@ -33,7 +33,7 @@ static int mdsmap_show(struct seq_file *s, void *p)
>  	seq_printf(s, "max_mds %d\n", mdsmap->m_max_mds);
>  	seq_printf(s, "session_timeout %d\n", mdsmap->m_session_timeout);
>  	seq_printf(s, "session_autoclose %d\n", mdsmap->m_session_autoclose);
> -	for (i = 0; i < mdsmap->m_num_mds; i++) {
> +	for (i = 0; i < mdsmap->possible_max_rank; i++) {
>  		struct ceph_entity_addr *addr = &mdsmap->m_info[i].addr;
>  		int state = mdsmap->m_info[i].state;
>  		seq_printf(s, "\tmds%d\t%s\t(%s)\n", i,
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 39f4d8501df5..036d388ddb10 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -597,7 +597,7 @@ static struct ceph_mds_session *register_session(struct ceph_mds_client *mdsc,
>  {
>  	struct ceph_mds_session *s;
>  
> -	if (mds >= mdsc->mdsmap->m_num_mds)
> +	if (mds >= mdsc->mdsmap->possible_max_rank)
>  		return ERR_PTR(-EINVAL);
>  
>  	s = kzalloc(sizeof(*s), GFP_NOFS);
> @@ -1222,7 +1222,7 @@ static void __open_export_target_sessions(struct ceph_mds_client *mdsc,
>  	struct ceph_mds_session *ts;
>  	int i, mds = session->s_mds;
>  
> -	if (mds >= mdsc->mdsmap->m_num_mds)
> +	if (mds >= mdsc->mdsmap->possible_max_rank)
>  		return;
>  
>  	mi = &mdsc->mdsmap->m_info[mds];
> @@ -3762,7 +3762,7 @@ static void check_new_map(struct ceph_mds_client *mdsc,
>  	dout("check_new_map new %u old %u\n",
>  	     newmap->m_epoch, oldmap->m_epoch);
>  
> -	for (i = 0; i < oldmap->m_num_mds && i < mdsc->max_sessions; i++) {
> +	for (i = 0; i < oldmap->possible_max_rank && i < mdsc->max_sessions; i++) {
>  		if (!mdsc->sessions[i])
>  			continue;
>  		s = mdsc->sessions[i];
> @@ -3776,7 +3776,7 @@ static void check_new_map(struct ceph_mds_client *mdsc,
>  		     ceph_mdsmap_is_laggy(newmap, i) ? " (laggy)" : "",
>  		     ceph_session_state_name(s->s_state));
>  
> -		if (i >= newmap->m_num_mds) {
> +		if (i >= newmap->possible_max_rank) {
>  			/* force close session for stopped mds */
>  			get_session(s);
>  			__unregister_session(mdsc, s);
> @@ -3833,7 +3833,7 @@ static void check_new_map(struct ceph_mds_client *mdsc,
>  		}
>  	}
>  
> -	for (i = 0; i < newmap->m_num_mds && i < mdsc->max_sessions; i++) {
> +	for (i = 0; i < newmap->possible_max_rank && i < mdsc->max_sessions; i++) {
>  		s = mdsc->sessions[i];
>  		if (!s)
>  			continue;
> diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
> index a77e0ecb9a6b..889627817e52 100644
> --- a/fs/ceph/mdsmap.c
> +++ b/fs/ceph/mdsmap.c
> @@ -14,22 +14,15 @@
>  #include "super.h"
>  
>  #define CEPH_MDS_IS_READY(i, ignore_laggy) \
> -	(m->m_info[i].state > 0 && (ignore_laggy ? true : !m->m_info[i].laggy))
> +	(m->m_info[i].state > 0 && ignore_laggy ? true : !m->m_info[i].laggy)
>  
>  static int __mdsmap_get_random_mds(struct ceph_mdsmap *m, bool ignore_laggy)
>  {
>  	int n = 0;
>  	int i, j;
>  
> -	/*
> -	 * special case for one mds, no matter it is laggy or
> -	 * not we have no choice
> -	 */
> -	if (1 == m->m_num_mds && m->m_info[0].state > 0)
> -		return 0;
> -
>  	/* count */
> -	for (i = 0; i < m->m_num_mds; i++)
> +	for (i = 0; i < m->possible_max_rank; i++)
>  		if (CEPH_MDS_IS_READY(i, ignore_laggy))
>  			n++;
>  	if (n == 0)
> @@ -37,7 +30,7 @@ static int __mdsmap_get_random_mds(struct ceph_mdsmap *m, bool ignore_laggy)
>  
>  	/* pick */
>  	n = prandom_u32() % n;
> -	for (j = 0, i = 0; i < m->m_num_mds; i++) {
> +	for (j = 0, i = 0; i < m->possible_max_rank; i++) {
>  		if (CEPH_MDS_IS_READY(i, ignore_laggy))
>  			j++;
>  		if (j > n)
> @@ -55,10 +48,10 @@ int ceph_mdsmap_get_random_mds(struct ceph_mdsmap *m)
>  	int mds;
>  
>  	mds = __mdsmap_get_random_mds(m, false);
> -	if (mds == m->m_num_mds || mds == -1)
> +	if (mds == m->possible_max_rank || mds == -1)
>  		mds = __mdsmap_get_random_mds(m, true);
>  
> -	return mds == m->m_num_mds ? -1 : mds;
> +	return mds == m->possible_max_rank ? -1 : mds;
>  }
>  
>  #define __decode_and_drop_type(p, end, type, bad)		\
> @@ -129,7 +122,6 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end)
>  	int err;
>  	u8 mdsmap_v, mdsmap_cv;
>  	u16 mdsmap_ev;
> -	u32 possible_max_rank;
>  
>  	m = kzalloc(sizeof(*m), GFP_NOFS);
>  	if (!m)
> @@ -157,24 +149,23 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end)
>  	m->m_max_mds = ceph_decode_32(p);
>  
>  	/*
> -	 * pick out the active nodes as the m_num_mds, the m_num_mds
> -	 * maybe larger than m_max_mds when decreasing the max_mds in
> -	 * cluster side, in other case it should less than or equal
> -	 * to m_max_mds.
> +	 * pick out the active nodes as the m_num_active_mds, the
> +	 * m_num_active_mds maybe larger than m_max_mds when decreasing
> +	 * the max_mds in cluster side, in other case it should less
> +	 * than or equal to m_max_mds.
>  	 */
> -	m->m_num_mds = n = ceph_decode_32(p);
> -	m->m_num_active_mds = m->m_num_mds;
> +	m->m_num_active_mds = n = ceph_decode_32(p);
>  
>  	/*
> -	 * the possible max rank, it maybe larger than the m->m_num_mds,
> +	 * the possible max rank, it maybe larger than the m_num_active_mds,
>  	 * for example if the mds_max == 2 in the cluster, when the MDS(0)
>  	 * was laggy and being replaced by a new MDS, we will temporarily
>  	 * receive a new mds map with n_num_mds == 1 and the active MDS(1),
> -	 * and the mds rank >= m->m_num_mds.
> +	 * and the mds rank >= m_num_active_mds.
>  	 */
> -	possible_max_rank = max((u32)m->m_num_mds, m->m_max_mds);
> +	m->possible_max_rank = max(m->m_num_active_mds, m->m_max_mds);
>  
> -	m->m_info = kcalloc(m->m_num_mds, sizeof(*m->m_info), GFP_NOFS);
> +	m->m_info = kcalloc(m->possible_max_rank, sizeof(*m->m_info), GFP_NOFS);
>  	if (!m->m_info)
>  		goto nomem;
>  
> @@ -248,7 +239,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end)
>  		     ceph_mds_state_name(state),
>  		     laggy ? "(laggy)" : "");
>  
> -		if (mds < 0 || mds >= possible_max_rank) {
> +		if (mds < 0 || mds >= m->possible_max_rank) {
>  			pr_warn("mdsmap_decode got incorrect mds(%d)\n", mds);
>  			continue;
>  		}
> @@ -318,14 +309,14 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end)
>  
>  		for (i = 0; i < n; i++) {
>  			s32 mds = ceph_decode_32(p);
> -			if (mds >= 0 && mds < m->m_num_mds) {
> +			if (mds >= 0 && mds < m->possible_max_rank) {
>  				if (m->m_info[mds].laggy)
>  					num_laggy++;
>  			}
>  		}
>  		m->m_num_laggy = num_laggy;
>  
> -		if (n > m->m_num_mds) {
> +		if (n > m->possible_max_rank) {
>  			void *new_m_info = krealloc(m->m_info,
>  						    n * sizeof(*m->m_info),
>  						    GFP_NOFS | __GFP_ZERO);
> @@ -333,7 +324,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end)
>  				goto nomem;
>  			m->m_info = new_m_info;
>  		}
> -		m->m_num_mds = n;
> +		m->possible_max_rank = n;
>  	}
>  
>  	/* inc */
> @@ -404,7 +395,7 @@ void ceph_mdsmap_destroy(struct ceph_mdsmap *m)
>  {
>  	int i;
>  
> -	for (i = 0; i < m->m_num_mds; i++)
> +	for (i = 0; i < m->possible_max_rank; i++)
>  		kfree(m->m_info[i].export_targets);
>  	kfree(m->m_info);
>  	kfree(m->m_data_pg_pools);
> @@ -420,7 +411,7 @@ bool ceph_mdsmap_is_cluster_available(struct ceph_mdsmap *m)
>  		return false;
>  	if (m->m_num_laggy == m->m_num_active_mds)
>  		return false;
> -	for (i = 0; i < m->m_num_mds; i++) {
> +	for (i = 0; i < m->possible_max_rank; i++) {
>  		if (m->m_info[i].state == CEPH_MDS_STATE_ACTIVE)
>  			nr_active++;
>  	}
> diff --git a/include/linux/ceph/mdsmap.h b/include/linux/ceph/mdsmap.h
> index 3a66f4f926ce..35d385296fbb 100644
> --- a/include/linux/ceph/mdsmap.h
> +++ b/include/linux/ceph/mdsmap.h
> @@ -26,8 +26,8 @@ struct ceph_mdsmap {
>  	u32 m_session_autoclose;        /* seconds */
>  	u64 m_max_file_size;
>  	u32 m_max_mds;			/* expected up:active mds number */
> -	int m_num_active_mds;		/* actual up:active mds number */
> -	int m_num_mds;                  /* size of m_info array */
> +	u32 m_num_active_mds;		/* actual up:active mds number */
> +	u32 possible_max_rank;		/* possible max rank index */
>  	struct ceph_mds_info *m_info;
>  
>  	/* which object pools file data can be stored in */
> @@ -43,7 +43,7 @@ struct ceph_mdsmap {
>  static inline struct ceph_entity_addr *
>  ceph_mdsmap_get_addr(struct ceph_mdsmap *m, int w)
>  {
> -	if (w >= m->m_num_mds)
> +	if (w >= m->possible_max_rank)
>  		return NULL;
>  	return &m->m_info[w].addr;
>  }
> @@ -51,14 +51,14 @@ ceph_mdsmap_get_addr(struct ceph_mdsmap *m, int w)
>  static inline int ceph_mdsmap_get_state(struct ceph_mdsmap *m, int w)
>  {
>  	BUG_ON(w < 0);
> -	if (w >= m->m_num_mds)
> +	if (w >= m->possible_max_rank)
>  		return CEPH_MDS_STATE_DNE;
>  	return m->m_info[w].state;
>  }
>  
>  static inline bool ceph_mdsmap_is_laggy(struct ceph_mdsmap *m, int w)
>  {
> -	if (w >= 0 && w < m->m_num_mds)
> +	if (w >= 0 && w < m->possible_max_rank)
>  		return m->m_info[w].laggy;
>  	return false;
>  }


Looks reasonable -- merged.
-- 
Jeff Layton <jlayton@kernel.org>

