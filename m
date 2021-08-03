Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A57A23DF5E1
	for <lists+ceph-devel@lfdr.de>; Tue,  3 Aug 2021 21:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239842AbhHCTnz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 3 Aug 2021 15:43:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:44824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239560AbhHCTnz (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 3 Aug 2021 15:43:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48A5B60F38;
        Tue,  3 Aug 2021 19:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628019823;
        bh=bCbO59czbTLfW+CsEDMbo3Ya/ajwALy6MNZ96z0kEpA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Dbc1YcIFPMxmhg6qTA/WPCiEcVYWUSTcQP082GVilWerqk7lXZiD2zKMiPvrq2UQa
         3/s0AEXrhYhpQJ6U6Yymlen5jEilOZtGwy3uBn2jp/BxnqWAcRivqYE09RayiTjB98
         UPsHU1EXtb6J4VVh8pFFsFIWwFYMTFfUSjuOSbrqUXF0EhiYeiJGxX7R/teQOzULeU
         yba+gNxdxeaQM0oveyrrm15LdZqbDEJtP5Wvm/OF2YM8pcUe1R+XZ12+zJ6OwRxNhD
         mTYmPpB40m9aI91FA6A7ruKGRfdN0WNVoGL8Q1J77BlfU7/7OJ8aT/EbkoHmAewC4Z
         gVI0Ul5gpZ0qQ==
Message-ID: <b8fe3a47b4064bac53f74e7d7b0dbf318e571d5c.camel@kernel.org>
Subject: Re: [PATCH] ceph: new helper - ceph_change_snap_realm
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.de>
Cc:     ceph-devel@vger.kernel.org, idryomov@gmail.com
Date:   Tue, 03 Aug 2021 15:43:42 -0400
In-Reply-To: <87mtpyg774.fsf@suse.de>
References: <20210802185130.94783-1-jlayton@kernel.org>
         <87mtpyg774.fsf@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.3 (3.40.3-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2021-08-03 at 11:21 +0100, Luis Henriques wrote:
> Jeff Layton <jlayton@kernel.org> writes:
> 
> > Consolidate some fiddly code for changing an inode's snap_realm
> > into a new helper function, and change the callers to use it.
> > 
> > While we're in here, nothing uses the i_snap_realm_counter field, so
> > remove that from the inode.
> 
> Ah, nice!  I remember _long_ time ago I had seen that field and thought:
> "I'll need to send out a patch to remove this thing!".  But in the
> meantime I completely forgot.
> 
> > 
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/ceph/caps.c  | 36 +++---------------------------
> >  fs/ceph/inode.c | 11 ++-------
> >  fs/ceph/snap.c  | 59 ++++++++++++++++++++++++++++++++-----------------
> >  fs/ceph/super.h |  2 +-
> >  4 files changed, 45 insertions(+), 63 deletions(-)
> > 
> > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > index cb551c9e5867..cecd4f66a60d 100644
> > --- a/fs/ceph/caps.c
> > +++ b/fs/ceph/caps.c
> > @@ -704,23 +704,7 @@ void ceph_add_cap(struct inode *inode,
> >  		struct ceph_snap_realm *realm = ceph_lookup_snap_realm(mdsc,
> >  							       realmino);
> >  		if (realm) {
> > -			struct ceph_snap_realm *oldrealm = ci->i_snap_realm;
> > -			if (oldrealm) {
> > -				spin_lock(&oldrealm->inodes_with_caps_lock);
> > -				list_del_init(&ci->i_snap_realm_item);
> > -				spin_unlock(&oldrealm->inodes_with_caps_lock);
> > -			}
> > -
> > -			spin_lock(&realm->inodes_with_caps_lock);
> > -			list_add(&ci->i_snap_realm_item,
> > -				 &realm->inodes_with_caps);
> > -			ci->i_snap_realm = realm;
> > -			if (realm->ino == ci->i_vino.ino)
> > -				realm->inode = inode;
> > -			spin_unlock(&realm->inodes_with_caps_lock);
> > -
> > -			if (oldrealm)
> > -				ceph_put_snap_realm(mdsc, oldrealm);
> > +			ceph_change_snap_realm(inode, realm);
> >  		} else {
> >  			pr_err("ceph_add_cap: couldn't find snap realm %llx\n",
> >  			       realmino);
> > @@ -1112,20 +1096,6 @@ int ceph_is_any_caps(struct inode *inode)
> >  	return ret;
> >  }
> >  
> > -static void drop_inode_snap_realm(struct ceph_inode_info *ci)
> > -{
> > -	struct ceph_snap_realm *realm = ci->i_snap_realm;
> > -	spin_lock(&realm->inodes_with_caps_lock);
> > -	list_del_init(&ci->i_snap_realm_item);
> > -	ci->i_snap_realm_counter++;
> > -	ci->i_snap_realm = NULL;
> > -	if (realm->ino == ci->i_vino.ino)
> > -		realm->inode = NULL;
> > -	spin_unlock(&realm->inodes_with_caps_lock);
> > -	ceph_put_snap_realm(ceph_sb_to_client(ci->vfs_inode.i_sb)->mdsc,
> > -			    realm);
> > -}
> > -
> >  /*
> >   * Remove a cap.  Take steps to deal with a racing iterate_session_caps.
> >   *
> > @@ -1201,7 +1171,7 @@ void __ceph_remove_cap(struct ceph_cap *cap, bool queue_release)
> >  		 * keep i_snap_realm.
> >  		 */
> >  		if (ci->i_wr_ref == 0 && ci->i_snap_realm)
> > -			drop_inode_snap_realm(ci);
> > +			ceph_change_snap_realm(&ci->vfs_inode, NULL);
> >  
> >  		__cap_delay_cancel(mdsc, ci);
> >  	}
> > @@ -3083,7 +3053,7 @@ static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
> >  			}
> >  			/* see comment in __ceph_remove_cap() */
> >  			if (!__ceph_is_any_real_caps(ci) && ci->i_snap_realm)
> > -				drop_inode_snap_realm(ci);
> > +				ceph_change_snap_realm(inode, NULL);
> >  		}
> >  	}
> >  	if (check_flushsnaps && __ceph_have_pending_cap_snap(ci)) {
> > diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> > index 84e4f112fc45..61ecf81ed875 100644
> > --- a/fs/ceph/inode.c
> > +++ b/fs/ceph/inode.c
> > @@ -582,16 +582,9 @@ void ceph_evict_inode(struct inode *inode)
> >  	 */
> >  	if (ci->i_snap_realm) {
> >  		if (ceph_snap(inode) == CEPH_NOSNAP) {
> > -			struct ceph_snap_realm *realm = ci->i_snap_realm;
> >  			dout(" dropping residual ref to snap realm %p\n",
> > -			     realm);
> > -			spin_lock(&realm->inodes_with_caps_lock);
> > -			list_del_init(&ci->i_snap_realm_item);
> > -			ci->i_snap_realm = NULL;
> > -			if (realm->ino == ci->i_vino.ino)
> > -				realm->inode = NULL;
> > -			spin_unlock(&realm->inodes_with_caps_lock);
> > -			ceph_put_snap_realm(mdsc, realm);
> > +			     ci->i_snap_realm);
> > +			ceph_change_snap_realm(inode, NULL);
> >  		} else {
> >  			ceph_put_snapid_map(mdsc, ci->i_snapid_map);
> >  			ci->i_snap_realm = NULL;
> > diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> > index 4ac0606dcbd4..9dbc92cfda38 100644
> > --- a/fs/ceph/snap.c
> > +++ b/fs/ceph/snap.c
> > @@ -846,6 +846,43 @@ static void flush_snaps(struct ceph_mds_client *mdsc)
> >  	dout("flush_snaps done\n");
> >  }
> >  
> > +/**
> > + * ceph_change_snap_realm - change the snap_realm for an inode
> > + * @inode: inode to move to new snap realm
> > + * @realm: new realm to move inode into (may be NULL)
> > + *
> > + * Detach an inode from its old snaprealm (if any) and attach it to
> > + * the new snaprealm (if any). The old snap realm reference held by
> > + * the inode is put. If realm is non-NULL, then the caller's reference
> > + * to it is taken over by the inode.
> > + */
> > +void ceph_change_snap_realm(struct inode *inode, struct ceph_snap_realm *realm)
> > +{
> > +	struct ceph_inode_info *ci = ceph_inode(inode);
> 
> Just a suggestion: this function could received the struct
> ceph_inode_info instead of the inode.  Other than that, LGTM.  Nice
> cleanup!  Feel free to add my
>
> Reviewed-by: Luis Henriques <lhenriques@suse.de>
> 

Meh -- I started with that, but then I needed to get to the inode itself
for the realm->inode and to get to the mdsc.

I'm inclined to leave it as-is since I've already tested this version,
but maybe we could change it later if we need to add new callers.

Thanks for the Reviewed-by though!

> (The other 2 patches ("print more information when..." and "remove
> redundant initializations...") also look good BTW.)
> 
> Cheers

-- 
Jeff Layton <jlayton@kernel.org>

