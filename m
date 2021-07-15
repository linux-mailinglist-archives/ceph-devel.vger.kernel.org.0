Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97A473C9DE7
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Jul 2021 13:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbhGOLpB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 15 Jul 2021 07:45:01 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:57514 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbhGOLpA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 15 Jul 2021 07:45:00 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 8FB201FE14;
        Thu, 15 Jul 2021 11:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1626349326; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3hAmPRhMJ+RTybgNPqzcZqAlp8PBzekHw7e2a95Yenc=;
        b=Iu9CfXeBuiJIua+wvlTt2OiznYw/sLeIh/hfMsmNHwubjoURPVLXOoLzTE1VaPqHgVq7OX
        ymGrWSSqPgLtOr/3mnyPKrdZBNIY8PX3lhHzXbkYEte07YX4hjFNRWJbbhBEHmQ0TdTzPx
        0pBXSy7E/gZ7GELYh52AzKfDFF0buGw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1626349326;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3hAmPRhMJ+RTybgNPqzcZqAlp8PBzekHw7e2a95Yenc=;
        b=P9wIqJEFtH9lDgoPf9yHmHujFXWPP6nEC0tBAjj8hQApYL2TIl1c/glRksKjIwldhdsxcz
        bVfi9CU10VzRs3DA==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 0882713D89;
        Thu, 15 Jul 2021 11:42:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id TPP3OQ0f8GCzMAAAGKfGzw
        (envelope-from <lhenriques@suse.de>); Thu, 15 Jul 2021 11:42:05 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id bd73403a;
        Thu, 15 Jul 2021 11:42:05 +0000 (UTC)
Date:   Thu, 15 Jul 2021 12:42:04 +0100
From:   Luis Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@redhat.com>
Cc:     Venky Shankar <vshankar@redhat.com>, idryomov@gmail.com,
        Xiubo Li <xiubli@redhat.com>, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
Subject: Re: [PATCH v4 4/5] ceph: record updated mon_addr on remount
Message-ID: <YPAfDOanWnNb/UWv@suse.de>
References: <20210714100554.85978-1-vshankar@redhat.com>
 <20210714100554.85978-5-vshankar@redhat.com>
 <848d919c6a791ab9b7c61d7cb89f759b55195c18.camel@redhat.com>
 <YO8SZ+Q3LaCt3K+V@suse.de>
 <eefa9ad5fa2b8a1e20a2031d622024151240ba70.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <eefa9ad5fa2b8a1e20a2031d622024151240ba70.camel@redhat.com>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jul 14, 2021 at 02:15:50PM -0400, Jeff Layton wrote:
> On Wed, 2021-07-14 at 17:35 +0100, Luis Henriques wrote:
> > On Wed, Jul 14, 2021 at 12:17:33PM -0400, Jeff Layton wrote:
> > > On Wed, 2021-07-14 at 15:35 +0530, Venky Shankar wrote:
> > > > Note that the new monitors are just shown in /proc/mounts.
> > > > Ceph does not (re)connect to new monitors yet.
> > > > 
> > > > Signed-off-by: Venky Shankar <vshankar@redhat.com>
> > > > ---
> > > >  fs/ceph/super.c | 7 +++++++
> > > >  1 file changed, 7 insertions(+)
> > > > 
> > > > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > > > index d8c6168b7fcd..d3a5a3729c5b 100644
> > > > --- a/fs/ceph/super.c
> > > > +++ b/fs/ceph/super.c
> > > > @@ -1268,6 +1268,13 @@ static int ceph_reconfigure_fc(struct fs_context *fc)
> > > >  	else
> > > >  		ceph_clear_mount_opt(fsc, ASYNC_DIROPS);
> > > >  
> > > > +	if (strcmp(fsc->mount_options->mon_addr, fsopt->mon_addr)) {
> > > > +		kfree(fsc->mount_options->mon_addr);
> > > > +		fsc->mount_options->mon_addr = fsopt->mon_addr;
> > > > +		fsopt->mon_addr = NULL;
> > > > +		printk(KERN_NOTICE "ceph: monitor addresses recorded, but not used for reconnection");
> > > 
> > > It's currently more in-vogue to use pr_notice() for this. I'll plan to
> > > make that (minor) change before I merge. No need to resend.
> > 
> > Yeah, this was the only comment I had too.  I saw some issues in the
> > previous revision but the changes to ceph_parse_source() seem to fix it in
> > this revision.
> > 
> > The other annoying thing I found isn't related with this patchset but with
> > a change that's been done some time ago by Xiubo (added to CC): it looks
> > like that if we have an invalid parameter (for example, wrong secret)
> > we'll always get -EHOSTUNREACH.
> > 
> > See below a possible fix (although I'm not entirely sure that's the correct
> > one).
> > 
> > Cheers,
> > --
> > Luís
> > 
> > From a988d24d8e72fc4933459f3dd5d303cbc9a566ed Mon Sep 17 00:00:00 2001
> > From: Luis Henriques <lhenriques@suse.de>
> > Date: Wed, 14 Jul 2021 16:56:36 +0100
> > Subject: [PATCH] ceph: don't hide error code if we don't have mdsmap
> > 
> > Since commit 97820058fb28 ("ceph: check availability of mds cluster on mount
> > after wait timeout") we're returning -EHOSTUNREACH, even if the error isn't
> > related with the MDSs availability.  For example, we'll get it even if we're
> > trying to mounting a filesystem with an invalid username or secret.
> > 
> > Only return this error if we get -EIO.
> > 
> > Fixes: 97820058fb28 ("ceph: check availability of mds cluster on mount after wait timeout")
> > Signed-off-by: Luis Henriques <lhenriques@suse.de>
> > ---
> >  fs/ceph/super.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > index 086a1ceec9d8..67d70059ce9f 100644
> > --- a/fs/ceph/super.c
> > +++ b/fs/ceph/super.c
> > @@ -1230,7 +1230,8 @@ static int ceph_get_tree(struct fs_context *fc)
> >  	return 0;
> >  
> >  out_splat:
> > -	if (!ceph_mdsmap_is_cluster_available(fsc->mdsc->mdsmap)) {
> > +	if ((err == -EIO) &&
> > +	    !ceph_mdsmap_is_cluster_available(fsc->mdsc->mdsmap)) {
> >  		pr_info("No mds server is up or the cluster is laggy\n");
> >  		err = -EHOSTUNREACH;
> >  	}
> 
> Yeah, I've noticed that message pop up under all sorts of circumstances
> and it is an annoyance. I'm happy to consider such a patch if you send
> it separately.
> 
> That said, I'm honestly not sure this message is really helpful, and
> overriding errors like this at a high level seems sort of sketchy. Maybe
> we should just drop that message, or figure out a way to limit it to
> _just_ that situation.

I agree that the message isn't really useful but the -EHOSTUNREACH is a
bit more confusing if we get it in the mount command when we simply have a
typo in the parameters.

Anyway, after looking closer, I couldn't find a way to reach this code
and have -EHOSTUNREACH to make sense.  When the MDSs are down/unreachable
we have already err set to this error code.  This would mean that the
correct fix would be to simply drop this 'if' statement.  Xiubo, do you
remember how would this be possible?

Cheers,
--
Luís
