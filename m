Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9943D7A37
	for <lists+ceph-devel@lfdr.de>; Tue, 27 Jul 2021 17:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232641AbhG0PxU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 27 Jul 2021 11:53:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:53456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229537AbhG0PxT (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 27 Jul 2021 11:53:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 427C661B67;
        Tue, 27 Jul 2021 15:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627401199;
        bh=M8pB7TCHiiV9KvGPQymMvHeI42PwiXfZnegJpCmHicE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uY3hnk4O0ked0w4VaKK4Wg7mAJgqXifQ2A2P5+CIUiGGE+JfWWuHcwDalsdEACaoK
         nIamkW8FkDsdhMXCfL2m2sq7rBcWQEmcGdqT/izSQyN1GEmXmSdxSB+1P5ggnfm+FI
         ucQBEw8MELrDZJpu/t87Spz1VPIW3gpoFH2TDtT3j8fvCisSCppJpNovD96CEStUra
         s+7IA4ck8QUEaWnZJiORHTWgrymep0GwpgwDzoNbOgdJX/e3feLfVKl41lna4nG9wT
         lEMSwoJCIJJ5kLD4Vf593c+P7gLCJHuSZBp46H8GN3FPsS+q44YQz4h+x4VXD2wEvk
         WyQAzgb3JBegA==
Message-ID: <e7c531436cc7f66c9599ee7426f28af80b2a1fb5.camel@kernel.org>
Subject: Re: [PATCH] ceph: add a new vxattr to return auth mds for an inode
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.de>
Cc:     ceph-devel@vger.kernel.org, idryomov@gmail.com,
        Sage Weil <sage@redhat.com>
Date:   Tue, 27 Jul 2021 11:53:18 -0400
In-Reply-To: <YQAqHRX3Y52QSsFf@suse.de>
References: <20210727113509.7714-1-jlayton@kernel.org>
         <YQAcRqN4FIuhjXUy@suse.de>
         <6977f06b87abd518b0503fd0d8c04525ed68f6ae.camel@kernel.org>
         <YQAqHRX3Y52QSsFf@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.3 (3.40.3-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2021-07-27 at 16:45 +0100, Luis Henriques wrote:
> On Tue, Jul 27, 2021 at 11:17:39AM -0400, Jeff Layton wrote:
> > On Tue, 2021-07-27 at 15:46 +0100, Luis Henriques wrote:
> > > On Tue, Jul 27, 2021 at 07:35:09AM -0400, Jeff Layton wrote:
> > > > Add a new vxattr that shows what MDS is authoritative for an inode (if
> > > > we happen to have auth caps). If we don't have an auth cap for the inode
> > > > then just return -1.
> > > > 
> > > > URL: https://tracker.ceph.com/issues/1276
> > > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > > ---
> > > >  fs/ceph/xattr.c | 16 ++++++++++++++++
> > > >  1 file changed, 16 insertions(+)
> > > > 
> > > > diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> > > > index 1242db8d3444..70664a19b8dc 100644
> > > > --- a/fs/ceph/xattr.c
> > > > +++ b/fs/ceph/xattr.c
> > > > @@ -340,6 +340,15 @@ static ssize_t ceph_vxattrcb_caps(struct ceph_inode_info *ci, char *val,
> > > >  			      ceph_cap_string(issued), issued);
> > > >  }
> > > >  
> > > > +static ssize_t ceph_vxattrcb_auth_mds(struct ceph_inode_info *ci,
> > > > +				       char *val, size_t size)
> > > > +{
> > > > +	/* return -1 if we don't have auth caps (and thus can't tell) */
> > > > +	if (!ci->i_auth_cap)
> > > > +		return ceph_fmt_xattr(val, size, "-1");
> > > 
> > > I don't really have an opinion on this as I don't have a usecase for this
> > > xattr (other than debug, of course).  But I just checked a similar function
> > > ceph_vxattrcb_layout_pool_namespace() and, if there's no value for ns for an
> > > inode, it just returns 0.
> > > 
> > > Anyway, just my 5c, as I'm OK with returning a '-1' string too.
> > > 
> > 
> > 
> > TBH, I don't have much of a use-case for this either, but it was
> > requested by Sage long ago. That said, I figure it might be useful in
> > some cases, particularly when troubleshooting pinning issues.
> > 
> > Pool numbering is a bit different, as I think pool 0 is not valid,
> > whereas we index mds's starting with 0. I'm fine with a different
> > convention here, but I considered it as a safe way to say "I don't know"
> > in this situation.
> 
> Right, but what I meant by returning 0 was to really do:
> 
> 	if (!ci->i_auth_cap)
> 		return 0;
> 
> and not to return the string "0".  Anyway, as I said, I don't have an
> opinion on this and returning the "-1" string for the MDS index sounds
> good too.
> 
> Cheers,
> --
> Luís
> 

Oh yeah, ok. We could do that I guess. I don't care much either way, but
that might be cleaner. Let me think on it a bit.

I also think we'll need to hold the ci->i_ceph_lock around the
i_auth_cap access. I'll need to send a v2 patch for that anyway.

> > > > +	return ceph_fmt_xattr(val, size, "%d", ci->i_auth_cap->session->s_mds);
> > > > +}
> > > > +
> > > >  #define CEPH_XATTR_NAME(_type, _name)	XATTR_CEPH_PREFIX #_type "." #_name
> > > >  #define CEPH_XATTR_NAME2(_type, _name, _name2)	\
> > > >  	XATTR_CEPH_PREFIX #_type "." #_name "." #_name2
> > > > @@ -473,6 +482,13 @@ static struct ceph_vxattr ceph_common_vxattrs[] = {
> > > >  		.exists_cb = NULL,
> > > >  		.flags = VXATTR_FLAG_READONLY,
> > > >  	},
> > > > +	{
> > > > +		.name = "ceph.auth_mds",
> > > > +		.name_size = sizeof("ceph.auth_mds"),
> > > > +		.getxattr_cb = ceph_vxattrcb_auth_mds,
> > > > +		.exists_cb = NULL,
> > > > +		.flags = VXATTR_FLAG_READONLY,
> > > > +	},
> > > >  	{ .name = NULL, 0 }	/* Required table terminator */
> > > >  };
> > > >  
> > > > -- 
> > > > 2.31.1
> > > > 
> > 
> > -- 
> > Jeff Layton <jlayton@kernel.org>
> > 

-- 
Jeff Layton <jlayton@kernel.org>

