Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 648403D7A13
	for <lists+ceph-devel@lfdr.de>; Tue, 27 Jul 2021 17:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbhG0Ppj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 27 Jul 2021 11:45:39 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:37634 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbhG0Pph (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 27 Jul 2021 11:45:37 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 4D782221F6;
        Tue, 27 Jul 2021 15:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1627400735; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1wfGOdIrWy92sDpGEjFad25P67vqoPTQ2IBlhcboWLM=;
        b=v27Gio5ZvKDsqY+HZDABx2qvfNW3GxEA1iYbSsG9GgY4706KUPzu4QGJ6uQxs5oqLJzmZ3
        ga9oV663alcHIIr/E1XiZNxk9+ih/n8iTqpGyweH+eYjlhdO5qw5yGTneF9o6Yr/AVq6+U
        wHrOkX4SmbAavwQXrFptPZaE21Mx2p0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1627400735;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1wfGOdIrWy92sDpGEjFad25P67vqoPTQ2IBlhcboWLM=;
        b=HfHOH2POHCcrYf97QEMUk6bvEMbktPsH0ZeT7COGxFynLotZCqDeZJi+cGfDRang7ewj8d
        cl+m/kccsYtG54Bg==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id EF2F113CF4;
        Tue, 27 Jul 2021 15:45:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id jgc5Nx4qAGGeJQAAGKfGzw
        (envelope-from <lhenriques@suse.de>); Tue, 27 Jul 2021 15:45:34 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id ea94d1aa;
        Tue, 27 Jul 2021 15:45:34 +0000 (UTC)
Date:   Tue, 27 Jul 2021 16:45:33 +0100
From:   Luis Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, idryomov@gmail.com,
        Sage Weil <sage@redhat.com>
Subject: Re: [PATCH] ceph: add a new vxattr to return auth mds for an inode
Message-ID: <YQAqHRX3Y52QSsFf@suse.de>
References: <20210727113509.7714-1-jlayton@kernel.org>
 <YQAcRqN4FIuhjXUy@suse.de>
 <6977f06b87abd518b0503fd0d8c04525ed68f6ae.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6977f06b87abd518b0503fd0d8c04525ed68f6ae.camel@kernel.org>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jul 27, 2021 at 11:17:39AM -0400, Jeff Layton wrote:
> On Tue, 2021-07-27 at 15:46 +0100, Luis Henriques wrote:
> > On Tue, Jul 27, 2021 at 07:35:09AM -0400, Jeff Layton wrote:
> > > Add a new vxattr that shows what MDS is authoritative for an inode (if
> > > we happen to have auth caps). If we don't have an auth cap for the inode
> > > then just return -1.
> > > 
> > > URL: https://tracker.ceph.com/issues/1276
> > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > ---
> > >  fs/ceph/xattr.c | 16 ++++++++++++++++
> > >  1 file changed, 16 insertions(+)
> > > 
> > > diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> > > index 1242db8d3444..70664a19b8dc 100644
> > > --- a/fs/ceph/xattr.c
> > > +++ b/fs/ceph/xattr.c
> > > @@ -340,6 +340,15 @@ static ssize_t ceph_vxattrcb_caps(struct ceph_inode_info *ci, char *val,
> > >  			      ceph_cap_string(issued), issued);
> > >  }
> > >  
> > > +static ssize_t ceph_vxattrcb_auth_mds(struct ceph_inode_info *ci,
> > > +				       char *val, size_t size)
> > > +{
> > > +	/* return -1 if we don't have auth caps (and thus can't tell) */
> > > +	if (!ci->i_auth_cap)
> > > +		return ceph_fmt_xattr(val, size, "-1");
> > 
> > I don't really have an opinion on this as I don't have a usecase for this
> > xattr (other than debug, of course).  But I just checked a similar function
> > ceph_vxattrcb_layout_pool_namespace() and, if there's no value for ns for an
> > inode, it just returns 0.
> > 
> > Anyway, just my 5c, as I'm OK with returning a '-1' string too.
> > 
> 
> 
> TBH, I don't have much of a use-case for this either, but it was
> requested by Sage long ago. That said, I figure it might be useful in
> some cases, particularly when troubleshooting pinning issues.
> 
> Pool numbering is a bit different, as I think pool 0 is not valid,
> whereas we index mds's starting with 0. I'm fine with a different
> convention here, but I considered it as a safe way to say "I don't know"
> in this situation.

Right, but what I meant by returning 0 was to really do:

	if (!ci->i_auth_cap)
		return 0;

and not to return the string "0".  Anyway, as I said, I don't have an
opinion on this and returning the "-1" string for the MDS index sounds
good too.

Cheers,
--
Luís

> > > +	return ceph_fmt_xattr(val, size, "%d", ci->i_auth_cap->session->s_mds);
> > > +}
> > > +
> > >  #define CEPH_XATTR_NAME(_type, _name)	XATTR_CEPH_PREFIX #_type "." #_name
> > >  #define CEPH_XATTR_NAME2(_type, _name, _name2)	\
> > >  	XATTR_CEPH_PREFIX #_type "." #_name "." #_name2
> > > @@ -473,6 +482,13 @@ static struct ceph_vxattr ceph_common_vxattrs[] = {
> > >  		.exists_cb = NULL,
> > >  		.flags = VXATTR_FLAG_READONLY,
> > >  	},
> > > +	{
> > > +		.name = "ceph.auth_mds",
> > > +		.name_size = sizeof("ceph.auth_mds"),
> > > +		.getxattr_cb = ceph_vxattrcb_auth_mds,
> > > +		.exists_cb = NULL,
> > > +		.flags = VXATTR_FLAG_READONLY,
> > > +	},
> > >  	{ .name = NULL, 0 }	/* Required table terminator */
> > >  };
> > >  
> > > -- 
> > > 2.31.1
> > > 
> 
> -- 
> Jeff Layton <jlayton@kernel.org>
> 
