Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B78D517A521
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Mar 2020 13:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbgCEMUx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 5 Mar 2020 07:20:53 -0500
Received: from mx2.suse.de ([195.135.220.15]:41730 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbgCEMUw (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 5 Mar 2020 07:20:52 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D6665B275;
        Thu,  5 Mar 2020 12:20:48 +0000 (UTC)
Received: from localhost (webern.olymp [local])
        by webern.olymp (OpenSMTPD) with ESMTPA id d36d555f;
        Thu, 5 Mar 2020 12:20:47 +0000 (WET)
Date:   Thu, 5 Mar 2020 12:20:47 +0000
From:   Luis Henriques <lhenriques@suse.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, idryomov@gmail.com, sage@redhat.com,
        zyan@redhat.com, pdonnell@redhat.com
Subject: Re: [PATCH v6 10/13] ceph: decode interval_sets for delegated inos
Message-ID: <20200305122047.GA18862@suse.com>
References: <20200302141434.59825-1-jlayton@kernel.org>
 <20200302141434.59825-11-jlayton@kernel.org>
 <20200305114523.GA70970@suse.com>
 <457281f5f81f3895408ac16f08abbe17429190db.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <457281f5f81f3895408ac16f08abbe17429190db.camel@kernel.org>
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Mar 05, 2020 at 07:02:59AM -0500, Jeff Layton wrote:
> On Thu, 2020-03-05 at 11:45 +0000, Luis Henriques wrote:
> > On Mon, Mar 02, 2020 at 09:14:31AM -0500, Jeff Layton wrote:
> > > Starting in Octopus, the MDS will hand out caps that allow the client
> > > to do asynchronous file creates under certain conditions. As part of
> > > that, the MDS will delegate ranges of inode numbers to the client.
> > > 
> > > Add the infrastructure to decode these ranges, and stuff them into an
> > > xarray for later consumption by the async creation code.
> > > 
> > > Because the xarray code currently only handles unsigned long indexes,
> > > and those are 32-bits on 32-bit arches, we only enable the decoding when
> > > running on a 64-bit arch.
> > > 
> > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > ---
> > >  fs/ceph/mds_client.c | 122 +++++++++++++++++++++++++++++++++++++++----
> > >  fs/ceph/mds_client.h |   9 +++-
> > >  2 files changed, 121 insertions(+), 10 deletions(-)
> > > 
> > > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > > index db8304447f35..87f75d05b004 100644
> > > --- a/fs/ceph/mds_client.c
> > > +++ b/fs/ceph/mds_client.c
> > > @@ -415,21 +415,121 @@ static int parse_reply_info_filelock(void **p, void *end,
> > >  	return -EIO;
> > >  }
> > >  
> > > +
> > > +#if BITS_PER_LONG == 64
> > > +
> > > +#define DELEGATED_INO_AVAILABLE		xa_mk_value(1)
> > > +
> > > +static int ceph_parse_deleg_inos(void **p, void *end,
> > > +				 struct ceph_mds_session *s)
> > > +{
> > > +	u32 sets;
> > > +
> > > +	ceph_decode_32_safe(p, end, sets, bad);
> > > +	dout("got %u sets of delegated inodes\n", sets);
> > > +	while (sets--) {
> > > +		u64 start, len, ino;
> > > +
> > > +		ceph_decode_64_safe(p, end, start, bad);
> > > +		ceph_decode_64_safe(p, end, len, bad);
> > > +		while (len--) {
> > > +			int err = xa_insert(&s->s_delegated_inos, ino = start++,
> > > +					    DELEGATED_INO_AVAILABLE,
> > > +					    GFP_KERNEL);
> > > +			if (!err) {
> > > +				dout("added delegated inode 0x%llx\n",
> > > +				     start - 1);
> > > +			} else if (err == -EBUSY) {
> > > +				pr_warn("ceph: MDS delegated inode 0x%llx more than once.\n",
> > > +					start - 1);
> > > +			} else {
> > > +				return err;
> > > +			}
> > > +		}
> > > +	}
> > > +	return 0;
> > > +bad:
> > > +	return -EIO;
> > > +}
> > > +
> > > +u64 ceph_get_deleg_ino(struct ceph_mds_session *s)
> > > +{
> > > +	unsigned long ino;
> > > +	void *val;
> > > +
> > > +	xa_for_each(&s->s_delegated_inos, ino, val) {
> > > +		val = xa_erase(&s->s_delegated_inos, ino);
> > > +		if (val == DELEGATED_INO_AVAILABLE)
> > > +			return ino;
> > > +	}
> > > +	return 0;
> > > +}
> > > +
> > > +int ceph_restore_deleg_ino(struct ceph_mds_session *s, u64 ino)
> > > +{
> > > +	return xa_insert(&s->s_delegated_inos, ino, DELEGATED_INO_AVAILABLE,
> > > +			 GFP_KERNEL);
> > > +}
> > > +#else /* BITS_PER_LONG == 64 */
> > > +/*
> > > + * FIXME: xarrays can't handle 64-bit indexes on a 32-bit arch. For now, just
> > > + * ignore delegated_inos on 32 bit arch. Maybe eventually add xarrays for top
> > > + * and bottom words?
> > > + */
> > > +static int ceph_parse_deleg_inos(void **p, void *end,
> > > +				 struct ceph_mds_session *s)
> > > +{
> > > +	u32 sets;
> > > +
> > > +	ceph_decode_32_safe(p, end, sets, bad);
> > > +	if (sets)
> > > +		ceph_decode_skip_n(p, end, sets * 2 * sizeof(__le64), bad);
> > > +	return 0;
> > > +bad:
> > > +	return -EIO;
> > > +}
> > > +
> > > +u64 ceph_get_deleg_ino(struct ceph_mds_session *s)
> > > +{
> > > +	return 0;
> > > +}
> > > +
> > > +int ceph_restore_deleg_ino(struct ceph_mds_session *s, u64 ino)
> > > +{
> > > +	return 0;
> > > +}
> > > +#endif /* BITS_PER_LONG == 64 */
> > > +
> > >  /*
> > >   * parse create results
> > >   */
> > >  static int parse_reply_info_create(void **p, void *end,
> > >  				  struct ceph_mds_reply_info_parsed *info,
> > > -				  u64 features)
> > > +				  u64 features, struct ceph_mds_session *s)
> > >  {
> > > +	int ret;
> > > +
> > >  	if (features == (u64)-1 ||
> > >  	    (features & CEPH_FEATURE_REPLY_CREATE_INODE)) {
> > > -		/* Malformed reply? */
> > >  		if (*p == end) {
> > > +			/* Malformed reply? */
> > >  			info->has_create_ino = false;
> > > -		} else {
> > > +		} else if (test_bit(CEPHFS_FEATURE_DELEG_INO, &s->s_features)) {
> > > +			u8 struct_v, struct_compat;
> > > +			u32 len;
> > > +
> > >  			info->has_create_ino = true;
> > > +			ceph_decode_8_safe(p, end, struct_v, bad);
> > > +			ceph_decode_8_safe(p, end, struct_compat, bad);
> > > +			ceph_decode_32_safe(p, end, len, bad);
> > > +			ceph_decode_64_safe(p, end, info->ino, bad);
> > 
> > I've done a quick test in current 'testing' branch and it seems that it's
> > currently broken.  A bisect identified this commit as 'bad' and it's
> > failing at this point.
> > 
> > I'm running an old (a few weeks) 'master' vstart cluster, so I don't have
> > the needed bits for using this DELEG_INO feature.  Running xfstest
> > generic/001 results in:
> > 
> >    ceph: mds parse_reply err -5
> >    ceph: mdsc_handle_reply got corrupt reply mds0(tid:9)
> >    ...
> > 
> > s->s_features does include the CEPHFS_FEATURE_DELEG_INO bit set;
> > 'features' is -1 (0xffffffffffffffff) and s->s_features is 0x3fff.  Maybe
> > the issue is actually somewhere else (the cephfs feature handling code),
> > but I'm still looking.
> > 
> 
> From the patch that added this feature in userland ceph code (commit
> 2bcf4b62643b5):
> 
> --- a/src/mds/cephfs_features.h
> +++ b/src/mds/cephfs_features.h
> @@ -32,6 +32,7 @@
>  #define CEPHFS_FEATURE_LAZY_CAP_WANTED  11
>  #define CEPHFS_FEATURE_MULTI_RECONNECT  12
>  #define CEPHFS_FEATURE_NAUTILUS         12
> +#define CEPHFS_FEATURE_DELEG_INO        13
>  #define CEPHFS_FEATURE_OCTOPUS          13
>  
>  #define CEPHFS_FEATURES_ALL {          \
> @@ -45,6 +46,7 @@
>    CEPHFS_FEATURE_LAZY_CAP_WANTED,      \
>    CEPHFS_FEATURE_MULTI_RECONNECT,      \
>    CEPHFS_FEATURE_NAUTILUS,              \
> +  CEPHFS_FEATURE_DELEG_INO,             \
>    CEPHFS_FEATURE_OCTOPUS,               \
>  }
> 
> ...this feature was added under the aegis of the
> CEPHFS_FEATURE_DELEG_INO flag, but that bit is shared with
> CEPHFS_FEATURE_OCTOPUS, which was already enabled in octopus before we
> ever added it (back on April 1st 2019).
> 
> Any version of the MDS that has commit 49930ad8a3402 but does not have 
> 2bcf4b62643b5 will not work properly with newer kernels. Personally, I
> don't see that as a problem per-se, as that should only be the case with
> bleeding-edge MDS builds. Official releases should never see this issue.
> 
> Going forward, I think commit 49930ad8a3402 was probably a bad idea. We
> really should not add "release" cephfs feature bits to the mask until
> just before an official release, and should just make it alias the last
> "real" feature bit. That should help ensure that we don't hit this
> problem in the future.

Doh!  Thanks a lot for figuring this out, Jeff!  You may have saved me a
few hours with this explanation!

Cheers,
--
Luís


> 
> > > +			ret = ceph_parse_deleg_inos(p, end, s);
> > > +			if (ret)
> > > +				return ret;
> > > +		} else {
> > > +			/* legacy */
> > >  			ceph_decode_64_safe(p, end, info->ino, bad);
> > > +			info->has_create_ino = true;
> > >  		}
> > >  	} else {
> > >  		if (*p != end)
> > > @@ -448,7 +548,7 @@ static int parse_reply_info_create(void **p, void *end,
> > >   */
> > >  static int parse_reply_info_extra(void **p, void *end,
> > >  				  struct ceph_mds_reply_info_parsed *info,
> > > -				  u64 features)
> > > +				  u64 features, struct ceph_mds_session *s)
> > >  {
> > >  	u32 op = le32_to_cpu(info->head->op);
> > >  
> > > @@ -457,7 +557,7 @@ static int parse_reply_info_extra(void **p, void *end,
> > >  	else if (op == CEPH_MDS_OP_READDIR || op == CEPH_MDS_OP_LSSNAP)
> > >  		return parse_reply_info_readdir(p, end, info, features);
> > >  	else if (op == CEPH_MDS_OP_CREATE)
> > > -		return parse_reply_info_create(p, end, info, features);
> > > +		return parse_reply_info_create(p, end, info, features, s);
> > >  	else
> > >  		return -EIO;
> > >  }
> > > @@ -465,7 +565,7 @@ static int parse_reply_info_extra(void **p, void *end,
> > >  /*
> > >   * parse entire mds reply
> > >   */
> > > -static int parse_reply_info(struct ceph_msg *msg,
> > > +static int parse_reply_info(struct ceph_mds_session *s, struct ceph_msg *msg,
> > >  			    struct ceph_mds_reply_info_parsed *info,
> > >  			    u64 features)
> > >  {
> > > @@ -490,7 +590,7 @@ static int parse_reply_info(struct ceph_msg *msg,
> > >  	ceph_decode_32_safe(&p, end, len, bad);
> > >  	if (len > 0) {
> > >  		ceph_decode_need(&p, end, len, bad);
> > > -		err = parse_reply_info_extra(&p, p+len, info, features);
> > > +		err = parse_reply_info_extra(&p, p+len, info, features, s);
> > >  		if (err < 0)
> > >  			goto out_bad;
> > >  	}
> > > @@ -558,6 +658,7 @@ void ceph_put_mds_session(struct ceph_mds_session *s)
> > >  	if (refcount_dec_and_test(&s->s_ref)) {
> > >  		if (s->s_auth.authorizer)
> > >  			ceph_auth_destroy_authorizer(s->s_auth.authorizer);
> > > +		xa_destroy(&s->s_delegated_inos);
> > >  		kfree(s);
> > >  	}
> > >  }
> > > @@ -645,6 +746,7 @@ static struct ceph_mds_session *register_session(struct ceph_mds_client *mdsc,
> > >  	refcount_set(&s->s_ref, 1);
> > >  	INIT_LIST_HEAD(&s->s_waiting);
> > >  	INIT_LIST_HEAD(&s->s_unsafe);
> > > +	xa_init(&s->s_delegated_inos);
> > >  	s->s_num_cap_releases = 0;
> > >  	s->s_cap_reconnect = 0;
> > >  	s->s_cap_iterator = NULL;
> > > @@ -2975,9 +3077,9 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
> > >  	dout("handle_reply tid %lld result %d\n", tid, result);
> > >  	rinfo = &req->r_reply_info;
> > >  	if (test_bit(CEPHFS_FEATURE_REPLY_ENCODING, &session->s_features))
> > > -		err = parse_reply_info(msg, rinfo, (u64)-1);
> > > +		err = parse_reply_info(session, msg, rinfo, (u64)-1);
> > >  	else
> > > -		err = parse_reply_info(msg, rinfo, session->s_con.peer_features);
> > > +		err = parse_reply_info(session, msg, rinfo, session->s_con.peer_features);
> > >  	mutex_unlock(&mdsc->mutex);
> > >  
> > >  	mutex_lock(&session->s_mutex);
> > > @@ -3673,6 +3775,8 @@ static void send_mds_reconnect(struct ceph_mds_client *mdsc,
> > >  	if (!reply)
> > >  		goto fail_nomsg;
> > >  
> > > +	xa_destroy(&session->s_delegated_inos);
> > > +
> > >  	mutex_lock(&session->s_mutex);
> > >  	session->s_state = CEPH_MDS_SESSION_RECONNECTING;
> > >  	session->s_seq = 0;
> > > diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> > > index f10d342ea585..4c3b71707470 100644
> > > --- a/fs/ceph/mds_client.h
> > > +++ b/fs/ceph/mds_client.h
> > > @@ -23,8 +23,9 @@ enum ceph_feature_type {
> > >  	CEPHFS_FEATURE_RECLAIM_CLIENT,
> > >  	CEPHFS_FEATURE_LAZY_CAP_WANTED,
> > >  	CEPHFS_FEATURE_MULTI_RECONNECT,
> > > +	CEPHFS_FEATURE_DELEG_INO,
> > >  
> > > -	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_MULTI_RECONNECT,
> > > +	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_DELEG_INO,
> > >  };
> > >  
> > >  /*
> > > @@ -37,6 +38,7 @@ enum ceph_feature_type {
> > >  	CEPHFS_FEATURE_REPLY_ENCODING,		\
> > >  	CEPHFS_FEATURE_LAZY_CAP_WANTED,		\
> > >  	CEPHFS_FEATURE_MULTI_RECONNECT,		\
> > > +	CEPHFS_FEATURE_DELEG_INO,		\
> > >  						\
> > >  	CEPHFS_FEATURE_MAX,			\
> > >  }
> > > @@ -201,6 +203,7 @@ struct ceph_mds_session {
> > >  
> > >  	struct list_head  s_waiting;  /* waiting requests */
> > >  	struct list_head  s_unsafe;   /* unsafe requests */
> > > +	struct xarray	  s_delegated_inos;
> > >  };
> > >  
> > >  /*
> > > @@ -542,6 +545,7 @@ extern void ceph_mdsc_open_export_target_sessions(struct ceph_mds_client *mdsc,
> > >  extern int ceph_trim_caps(struct ceph_mds_client *mdsc,
> > >  			  struct ceph_mds_session *session,
> > >  			  int max_caps);
> > > +
> > >  static inline int ceph_wait_on_async_create(struct inode *inode)
> > >  {
> > >  	struct ceph_inode_info *ci = ceph_inode(inode);
> > > @@ -549,4 +553,7 @@ static inline int ceph_wait_on_async_create(struct inode *inode)
> > >  	return wait_on_bit(&ci->i_ceph_flags, CEPH_ASYNC_CREATE_BIT,
> > >  			   TASK_INTERRUPTIBLE);
> > >  }
> > > +
> > > +extern u64 ceph_get_deleg_ino(struct ceph_mds_session *session);
> > > +extern int ceph_restore_deleg_ino(struct ceph_mds_session *session, u64 ino);
> > >  #endif
> > > -- 
> > > 2.24.1
> > > 
> 
> -- 
> Jeff Layton <jlayton@kernel.org>
> 
