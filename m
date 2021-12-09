Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39F2346E739
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Dec 2021 12:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236315AbhLILIj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 Dec 2021 06:08:39 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:37320 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232838AbhLILIj (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 9 Dec 2021 06:08:39 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 5E59E1F37D;
        Thu,  9 Dec 2021 11:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1639047905; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=siGuJxYs3u+U19GW8OW4NBqWHjpw8TCmMhhVxQCwKak=;
        b=vaxCJEu2puMakhMHQrVEXIEBXdQ04EN6Ss5oAjxd7fkxfHYt5jpGPBSdUSDhtuUrfZ88Aw
        HOI4oc9Ou3GYaNXNPKWZtSfbW0BagjNMfU/x9S1p8RwPCY7TJ4Rc3ywwSHFa1xoYhHSnM5
        ZcB1+WLYKIyQjZCbLnMsUjHlT1ORAHM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1639047905;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=siGuJxYs3u+U19GW8OW4NBqWHjpw8TCmMhhVxQCwKak=;
        b=iYPQBirhzDUTs7r05q6daEtALsDDYIHkFrCNF2XNVjfXxvXwsEfQUSfuewlbuTKi5tAWJ2
        ysdWJnuXE6EJ1SBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DDCA413343;
        Thu,  9 Dec 2021 11:05:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id A7JOM+DisWHkPAAAMHmgww
        (envelope-from <lhenriques@suse.de>); Thu, 09 Dec 2021 11:05:04 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id eca42638;
        Thu, 9 Dec 2021 11:05:04 +0000 (UTC)
Date:   Thu, 9 Dec 2021 11:05:03 +0000
From:   =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, idryomov@gmail.com,
        Hu Weiwen <sehuww@mail.scut.edu.cn>,
        Xiubo Li <xiubli@redhat.com>
Subject: Re: [PATCH v2] ceph: don't check for quotas on MDS stray dirs
Message-ID: <YbHi34FXfng9VOfk@suse.de>
References: <20211207152705.167010-1-jlayton@kernel.org>
 <e666ba1d2db25a90de7e2582c31c36a6fb9854ab.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e666ba1d2db25a90de7e2582c31c36a6fb9854ab.camel@kernel.org>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Dec 07, 2021 at 10:29:28AM -0500, Jeff Layton wrote:
> On Tue, 2021-12-07 at 10:27 -0500, Jeff Layton wrote:
> > 玮文 胡 reported seeing the WARN_RATELIMIT pop when writing to an
> > inode that had been transplanted into the stray dir. The client was
> > trying to look up the quotarealm info from the parent and that tripped
> > the warning.
> > 
> > Change the ceph_vino_is_reserved helper to not throw a warning for
> > MDS stray directories (0x100 - 0x1ff), only for reserved dirs that
> > are not in that range.
> > 
> > Also, fix ceph_has_realms_with_quotas to return false when encountering
> > a reserved inode.
> > 
> > URL: https://tracker.ceph.com/issues/53180
> > Reported-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
> > Reviewed-by: Luis Henriques <lhenriques@suse.de>
> > Reviewed-by: Xiubo Li <xiubli@redhat.com>
> 
> Oops, I forgot to remote the Reviewed-by: lines before sending since
> this patch is different. The one in the testing branch has them removed.
> Reviews of this patch would still be welcome.

Feel free to add my Reviewed-by: back, the patch looks OK to me.  Thanks!

Cheers,
--
Luís

> 
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/ceph/quota.c |  3 +++
> >  fs/ceph/super.h | 20 ++++++++++++--------
> >  2 files changed, 15 insertions(+), 8 deletions(-)
> > 
> > I was still seeing some warnings even with the earlier patch, so I
> > decided to rework it to just never warn on MDS stray dirs. This should
> > also silence the warnings on MDS stray dirs (and also alleviate Luis'
> > concern about the function renaming in the earlier patch).
> > 
> > diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
> > index 24ae13ea2241..a338a3ec0dc4 100644
> > --- a/fs/ceph/quota.c
> > +++ b/fs/ceph/quota.c
> > @@ -30,6 +30,9 @@ static inline bool ceph_has_realms_with_quotas(struct inode *inode)
> >  	/* if root is the real CephFS root, we don't have quota realms */
> >  	if (root && ceph_ino(root) == CEPH_INO_ROOT)
> >  		return false;
> > +	/* MDS stray dirs have no quota realms */
> > +	if (ceph_vino_is_reserved(ceph_inode(inode)->i_vino))
> > +		return false;
> >  	/* otherwise, we can't know for sure */
> >  	return true;
> >  }
> > diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> > index 387ee33894db..f9b1bbf26c1b 100644
> > --- a/fs/ceph/super.h
> > +++ b/fs/ceph/super.h
> > @@ -541,19 +541,23 @@ static inline int ceph_ino_compare(struct inode *inode, void *data)
> >   *
> >   * These come from src/mds/mdstypes.h in the ceph sources.
> >   */
> > -#define CEPH_MAX_MDS		0x100
> > -#define CEPH_NUM_STRAY		10
> > +#define CEPH_MAX_MDS			0x100
> > +#define CEPH_NUM_STRAY			10
> >  #define CEPH_MDS_INO_MDSDIR_OFFSET	(1 * CEPH_MAX_MDS)
> > +#define CEPH_MDS_INO_LOG_OFFSET		(2 * CEPH_MAX_MDS)
> >  #define CEPH_INO_SYSTEM_BASE		((6*CEPH_MAX_MDS) + (CEPH_MAX_MDS * CEPH_NUM_STRAY))
> >  
> >  static inline bool ceph_vino_is_reserved(const struct ceph_vino vino)
> >  {
> > -	if (vino.ino < CEPH_INO_SYSTEM_BASE &&
> > -	    vino.ino >= CEPH_MDS_INO_MDSDIR_OFFSET) {
> > -		WARN_RATELIMIT(1, "Attempt to access reserved inode number 0x%llx", vino.ino);
> > -		return true;
> > -	}
> > -	return false;
> > +	if (vino.ino >= CEPH_INO_SYSTEM_BASE ||
> > +	    vino.ino < CEPH_MDS_INO_MDSDIR_OFFSET)
> > +		return false;
> > +
> > +	/* Don't warn on mdsdirs */
> > +	WARN_RATELIMIT(vino.ino >= CEPH_MDS_INO_LOG_OFFSET,
> > +			"Attempt to access reserved inode number 0x%llx",
> > +			vino.ino);
> > +	return true;
> >  }
> >  
> >  static inline struct inode *ceph_find_inode(struct super_block *sb,
> 
> -- 
> Jeff Layton <jlayton@kernel.org>
