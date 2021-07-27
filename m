Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B36673D798D
	for <lists+ceph-devel@lfdr.de>; Tue, 27 Jul 2021 17:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237108AbhG0PRm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 27 Jul 2021 11:17:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:43796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232633AbhG0PRl (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 27 Jul 2021 11:17:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC32C61B39;
        Tue, 27 Jul 2021 15:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627399061;
        bh=wx6Fxu5BE8E+Kri9vXOD593vCtpBQJGe9wxbhK0Hjmg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=iglc5SHaNp/rHERMZwEjp7wrahvJuIdN3FifchK5Ll1wyYa4q4HwfbltthvTA15w9
         +q3afuFZh5Q/MjG7sQsJ7pa396GkFo1xVx0gezuZ72v+H3+LXrLEbLIXAA6CXmmCd/
         e6LD7U8WhEFSIVRXm9V7sNCk0XDnHYhmbdjdd6Q0xrfsOAYtrrlARjEGeKaRpoz5Yi
         CghO3FHYY1Jso5rDTuOM2iz6ezWf1CB41XUFkMYY/LBaYQSsqmRUOKOMW+0mNijwkV
         9XFomMVCAst6TxDV4pKxxSSLDBG9ZQb9y0LIY3YhkqS47yNemt+HFyGzKnDyGHToFS
         HofMBnFIAu6Nw==
Message-ID: <6977f06b87abd518b0503fd0d8c04525ed68f6ae.camel@kernel.org>
Subject: Re: [PATCH] ceph: add a new vxattr to return auth mds for an inode
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.de>
Cc:     ceph-devel@vger.kernel.org, idryomov@gmail.com,
        Sage Weil <sage@redhat.com>
Date:   Tue, 27 Jul 2021 11:17:39 -0400
In-Reply-To: <YQAcRqN4FIuhjXUy@suse.de>
References: <20210727113509.7714-1-jlayton@kernel.org>
         <YQAcRqN4FIuhjXUy@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.3 (3.40.3-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2021-07-27 at 15:46 +0100, Luis Henriques wrote:
> On Tue, Jul 27, 2021 at 07:35:09AM -0400, Jeff Layton wrote:
> > Add a new vxattr that shows what MDS is authoritative for an inode (if
> > we happen to have auth caps). If we don't have an auth cap for the inode
> > then just return -1.
> > 
> > URL: https://tracker.ceph.com/issues/1276
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/ceph/xattr.c | 16 ++++++++++++++++
> >  1 file changed, 16 insertions(+)
> > 
> > diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> > index 1242db8d3444..70664a19b8dc 100644
> > --- a/fs/ceph/xattr.c
> > +++ b/fs/ceph/xattr.c
> > @@ -340,6 +340,15 @@ static ssize_t ceph_vxattrcb_caps(struct ceph_inode_info *ci, char *val,
> >  			      ceph_cap_string(issued), issued);
> >  }
> >  
> > +static ssize_t ceph_vxattrcb_auth_mds(struct ceph_inode_info *ci,
> > +				       char *val, size_t size)
> > +{
> > +	/* return -1 if we don't have auth caps (and thus can't tell) */
> > +	if (!ci->i_auth_cap)
> > +		return ceph_fmt_xattr(val, size, "-1");
> 
> I don't really have an opinion on this as I don't have a usecase for this
> xattr (other than debug, of course).  But I just checked a similar function
> ceph_vxattrcb_layout_pool_namespace() and, if there's no value for ns for an
> inode, it just returns 0.
> 
> Anyway, just my 5c, as I'm OK with returning a '-1' string too.
> 


TBH, I don't have much of a use-case for this either, but it was
requested by Sage long ago. That said, I figure it might be useful in
some cases, particularly when troubleshooting pinning issues.

Pool numbering is a bit different, as I think pool 0 is not valid,
whereas we index mds's starting with 0. I'm fine with a different
convention here, but I considered it as a safe way to say "I don't know"
in this situation.

> > +	return ceph_fmt_xattr(val, size, "%d", ci->i_auth_cap->session->s_mds);
> > +}
> > +
> >  #define CEPH_XATTR_NAME(_type, _name)	XATTR_CEPH_PREFIX #_type "." #_name
> >  #define CEPH_XATTR_NAME2(_type, _name, _name2)	\
> >  	XATTR_CEPH_PREFIX #_type "." #_name "." #_name2
> > @@ -473,6 +482,13 @@ static struct ceph_vxattr ceph_common_vxattrs[] = {
> >  		.exists_cb = NULL,
> >  		.flags = VXATTR_FLAG_READONLY,
> >  	},
> > +	{
> > +		.name = "ceph.auth_mds",
> > +		.name_size = sizeof("ceph.auth_mds"),
> > +		.getxattr_cb = ceph_vxattrcb_auth_mds,
> > +		.exists_cb = NULL,
> > +		.flags = VXATTR_FLAG_READONLY,
> > +	},
> >  	{ .name = NULL, 0 }	/* Required table terminator */
> >  };
> >  
> > -- 
> > 2.31.1
> > 

-- 
Jeff Layton <jlayton@kernel.org>

