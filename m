Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3DBC3B9F45
	for <lists+ceph-devel@lfdr.de>; Fri,  2 Jul 2021 12:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbhGBKux (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 2 Jul 2021 06:50:53 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:34876 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231563AbhGBKuu (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 2 Jul 2021 06:50:50 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 4F62F20084;
        Fri,  2 Jul 2021 10:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1625222897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9FOlnRq7dlwnpUQCgWB3T+p/rk+4nznnCE3KMn/GcDA=;
        b=uEBtZXxe6FxR7xxGgK5wuHebxw+0I+4DG1wTwNOtCmIkBAVc21IpoBzMQwxQn7Lzlyxrxx
        6s+p0Tafd+pWCzso6jKxWWiqMBarkE6RxT0oWyj1JQ1/76PGnEuTqM35VL7mJMjyT2K+3p
        mkZlrB4Io+zUHsEKXEpMolNe3Zpcgn0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1625222897;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9FOlnRq7dlwnpUQCgWB3T+p/rk+4nznnCE3KMn/GcDA=;
        b=bn8h/8YXD2RJ2Gx9ok0Vin/5XOzelOL4VxKDMVw+BGM223o61fCBXUcyq2yOn+qxf2xn46
        Liebk2I2HuUZKlAw==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id E1FE711C84;
        Fri,  2 Jul 2021 10:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1625222897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9FOlnRq7dlwnpUQCgWB3T+p/rk+4nznnCE3KMn/GcDA=;
        b=uEBtZXxe6FxR7xxGgK5wuHebxw+0I+4DG1wTwNOtCmIkBAVc21IpoBzMQwxQn7Lzlyxrxx
        6s+p0Tafd+pWCzso6jKxWWiqMBarkE6RxT0oWyj1JQ1/76PGnEuTqM35VL7mJMjyT2K+3p
        mkZlrB4Io+zUHsEKXEpMolNe3Zpcgn0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1625222897;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9FOlnRq7dlwnpUQCgWB3T+p/rk+4nznnCE3KMn/GcDA=;
        b=bn8h/8YXD2RJ2Gx9ok0Vin/5XOzelOL4VxKDMVw+BGM223o61fCBXUcyq2yOn+qxf2xn46
        Liebk2I2HuUZKlAw==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id xIZWNPDu3mC9agAALh3uQQ
        (envelope-from <lhenriques@suse.de>); Fri, 02 Jul 2021 10:48:16 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 64faae81;
        Fri, 2 Jul 2021 10:48:16 +0000 (UTC)
Date:   Fri, 2 Jul 2021 11:48:15 +0100
From:   Luis Henriques <lhenriques@suse.de>
To:     Venky Shankar <vshankar@redhat.com>
Cc:     jlayton@redhat.com, idryomov@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] ceph: validate cluster FSID for new device syntax
Message-ID: <YN7u73BDwB4aoe4w@suse.de>
References: <20210702064821.148063-1-vshankar@redhat.com>
 <20210702064821.148063-3-vshankar@redhat.com>
 <YN7t9TJlDG8YcbqM@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YN7t9TJlDG8YcbqM@suse.de>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Jul 02, 2021 at 11:44:05AM +0100, Luis Henriques wrote:
> On Fri, Jul 02, 2021 at 12:18:19PM +0530, Venky Shankar wrote:
> > The new device syntax requires the cluster FSID as part
> > of the device string. Use this FSID to verify if it matches
> > the cluster FSID we get back from the monitor, failing the
> > mount on mismatch.
> > 
> > Also, rename parse_fsid() to ceph_parse_fsid() as it is too
> > generic.
> > 
> > Signed-off-by: Venky Shankar <vshankar@redhat.com>
> > ---
> >  fs/ceph/super.c              | 9 +++++++++
> >  fs/ceph/super.h              | 1 +
> >  include/linux/ceph/libceph.h | 1 +
> >  net/ceph/ceph_common.c       | 5 +++--
> >  4 files changed, 14 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > index 0b324e43c9f4..03e5f4bb2b6f 100644
> > --- a/fs/ceph/super.c
> > +++ b/fs/ceph/super.c
> > @@ -268,6 +268,9 @@ static int ceph_parse_new_source(const char *dev_name, const char *dev_name_end,
> >  	if (!fs_name_start)
> >  		return invalfc(fc, "missing file system name");
> >  
> > +	if (ceph_parse_fsid(fsid_start, &fsopt->fsid))
> > +		return invalfc(fc, "invalid fsid format");
> > +
> >  	++fs_name_start; /* start of file system name */
> >  	fsopt->mds_namespace = kstrndup(fs_name_start,
> >  					dev_name_end - fs_name_start, GFP_KERNEL);
> > @@ -750,6 +753,12 @@ static struct ceph_fs_client *create_fs_client(struct ceph_mount_options *fsopt,
> >  	}
> >  	opt = NULL; /* fsc->client now owns this */
> >  
> > +	/* help learn fsid */
> > +	if (fsopt->new_dev_syntax) {
> > +		ceph_check_fsid(fsc->client, &fsopt->fsid);
> 
> This call to ceph_check_fsid() made me wonder what would happen if I use
> the wrong fsid with the new syntax.  And the result is:
> 
> [   41.882334] libceph: mon0 (1)192.168.155.1:40594 session established
> [   41.884537] libceph: bad fsid, had d52783e6-efc2-4dce-ad01-aa3272fa5f66 got 90bdb539-9d95-402e-8f23-b0e26cba8b1b
> [   41.885955] libceph: bad fsid, had d52783e6-efc2-4dce-ad01-aa3272fa5f66 got 90bdb539-9d95-402e-8f23-b0e26cba8b1b
> [   41.889313] libceph: bad fsid, had d52783e6-efc2-4dce-ad01-aa3272fa5f66 got 90bdb539-9d95-402e-8f23-b0e26cba8b1b
> [   41.892578] libceph: osdc handle_map corrupt msg
> 
> ... followed by a msg dump.
> 
> I guess this means that manually setting the fsid requires changes to the
> messenger (I've only tested with v1) so that it gracefully handles this
> scenario.

I forgot to mention that the above errors are, obviously, not due to this
call to ceph_check_fsid() but rather from calling it from mon_dispatch().

Cheers,
--
Luís
