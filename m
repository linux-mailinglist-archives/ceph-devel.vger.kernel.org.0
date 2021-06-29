Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 576FC3B75CD
	for <lists+ceph-devel@lfdr.de>; Tue, 29 Jun 2021 17:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233361AbhF2Poz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Jun 2021 11:44:55 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:47384 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233294AbhF2Poy (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 29 Jun 2021 11:44:54 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 15BCD20402;
        Tue, 29 Jun 2021 15:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624981346; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oYuAzs+h2gY6l7LC9c3T3K02mPklt+VGLc6bWyvmOWw=;
        b=Ib/+PgRlmvOD8X2k7foOLqCa8aF7AXe86CU8QBDarV973oHIC3CgGD8UC2hnxirAZ+cu5D
        5/++jeYkwaKgcAvbiJYodFpl7otcrYf+yGTwbgt6gDiC0cHxb8obOoLvqJKY/XvUBOk8hD
        en6uTdZ4jr/9aMIb4hADh9yj7j+AfwM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624981346;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oYuAzs+h2gY6l7LC9c3T3K02mPklt+VGLc6bWyvmOWw=;
        b=gW+iSX3000E5tyS3vF2RWvPdtWfAztbIgtPSnnAOt9b1uatt+hNVCMh88rYA9Z7vupXT3x
        9aPlMDT8rYTLmDAA==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id AC30811906;
        Tue, 29 Jun 2021 15:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624981346; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oYuAzs+h2gY6l7LC9c3T3K02mPklt+VGLc6bWyvmOWw=;
        b=Ib/+PgRlmvOD8X2k7foOLqCa8aF7AXe86CU8QBDarV973oHIC3CgGD8UC2hnxirAZ+cu5D
        5/++jeYkwaKgcAvbiJYodFpl7otcrYf+yGTwbgt6gDiC0cHxb8obOoLvqJKY/XvUBOk8hD
        en6uTdZ4jr/9aMIb4hADh9yj7j+AfwM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624981346;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oYuAzs+h2gY6l7LC9c3T3K02mPklt+VGLc6bWyvmOWw=;
        b=gW+iSX3000E5tyS3vF2RWvPdtWfAztbIgtPSnnAOt9b1uatt+hNVCMh88rYA9Z7vupXT3x
        9aPlMDT8rYTLmDAA==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id pCOAJmE/22BrLgAALh3uQQ
        (envelope-from <lhenriques@suse.de>); Tue, 29 Jun 2021 15:42:25 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id adc3a53f;
        Tue, 29 Jun 2021 15:42:24 +0000 (UTC)
Date:   Tue, 29 Jun 2021 16:42:24 +0100
From:   Luis Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@redhat.com>
Cc:     Venky Shankar <vshankar@redhat.com>, idryomov@gmail.com,
        ceph-devel <ceph-devel@vger.kernel.org>
Subject: Re: [PATCH 1/4] ceph: new device mount syntax
Message-ID: <YNs/YDS2BJJj7Hvk@suse.de>
References: <20210628075545.702106-1-vshankar@redhat.com>
 <20210628075545.702106-2-vshankar@redhat.com>
 <YNsEs9IwTEEqOTHj@suse.de>
 <CACPzV1=KaZU5Y4NL-Sy1J-nfd+WddXydQc3o-kVmoe-pEiXiqA@mail.gmail.com>
 <e3b6778ed89617efe869a530970f3dfe9d8d9d10.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e3b6778ed89617efe869a530970f3dfe9d8d9d10.camel@redhat.com>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jun 29, 2021 at 11:10:02AM -0400, Jeff Layton wrote:
> On Tue, 2021-06-29 at 19:24 +0530, Venky Shankar wrote:
> > On Tue, Jun 29, 2021 at 5:02 PM Luis Henriques <lhenriques@suse.de> wrote:
> > > 
> > > [ As I said, I didn't fully reviewed this patch.  Just sending out a few
> > >   comments. ]
> > > 
> > > On Mon, Jun 28, 2021 at 01:25:42PM +0530, Venky Shankar wrote:
> > > > Old mount device syntax (source) has the following problems:
> > > > 
> > > > - mounts to the same cluster but with different fsnames
> > > >   and/or creds have identical device string which can
> > > >   confuse xfstests.
> > > > 
> > > > - Userspace mount helper tool resolves monitor addresses
> > > >   and fill in mon addrs automatically, but that means the
> > > >   device shown in /proc/mounts is different than what was
> > > >   used for mounting.
> > > > 
> > > > New device syntax is as follows:
> > > > 
> > > >   cephuser@fsid.mycephfs2=/path
> > > > 
> > > > Note, there is no "monitor address" in the device string.
> > > > That gets passed in as mount option. This keeps the device
> > > > string same when monitor addresses change (on remounts).
> > > > 
> > > > Also note that the userspace mount helper tool is backward
> > > > compatible. I.e., the mount helper will fallback to using
> > > > old syntax after trying to mount with the new syntax.
> > > > 
> > > > Signed-off-by: Venky Shankar <vshankar@redhat.com>
> > > > ---
> > > >  fs/ceph/super.c | 117 +++++++++++++++++++++++++++++++++++++++++++-----
> > > >  fs/ceph/super.h |   3 ++
> > > >  2 files changed, 110 insertions(+), 10 deletions(-)
> > > > 
> > > > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > > > index 9b1b7f4cfdd4..950a28ad9c59 100644
> > > > --- a/fs/ceph/super.c
> > > > +++ b/fs/ceph/super.c
> > > > @@ -145,6 +145,7 @@ enum {
> > > >       Opt_mds_namespace,
> > > >       Opt_recover_session,
> > > >       Opt_source,
> > > > +     Opt_mon_addr,
> > > >       /* string args above */
> > > >       Opt_dirstat,
> > > >       Opt_rbytes,
> > > > @@ -196,6 +197,7 @@ static const struct fs_parameter_spec ceph_mount_parameters[] = {
> > > >       fsparam_u32     ("rsize",                       Opt_rsize),
> > > >       fsparam_string  ("snapdirname",                 Opt_snapdirname),
> > > >       fsparam_string  ("source",                      Opt_source),
> > > > +     fsparam_string  ("mon_addr",                    Opt_mon_addr),
> > > >       fsparam_u32     ("wsize",                       Opt_wsize),
> > > >       fsparam_flag_no ("wsync",                       Opt_wsync),
> > > >       {}
> > > > @@ -226,10 +228,68 @@ static void canonicalize_path(char *path)
> > > >       path[j] = '\0';
> > > >  }
> > > > 
> > > > +static int ceph_parse_old_source(const char *dev_name, const char *dev_name_end,
> > > > +                              struct fs_context *fc)
> > > > +{
> > > > +     int r;
> > > > +     struct ceph_parse_opts_ctx *pctx = fc->fs_private;
> > > > +     struct ceph_mount_options *fsopt = pctx->opts;
> > > > +
> > > > +     if (*dev_name_end != ':')
> > > > +             return invalfc(fc, "separator ':' missing in source");
> > > > +
> > > > +     r = ceph_parse_mon_ips(dev_name, dev_name_end - dev_name,
> > > > +                            pctx->copts, fc->log.log);
> > > > +     if (r)
> > > > +             return r;
> > > > +
> > > > +     fsopt->new_dev_syntax = false;
> > > > +     return 0;
> > > > +}
> > > > +
> > > > +static int ceph_parse_new_source(const char *dev_name, const char *dev_name_end,
> > > > +                              struct fs_context *fc)
> > > > +{
> > > > +     struct ceph_parse_opts_ctx *pctx = fc->fs_private;
> > > > +     struct ceph_mount_options *fsopt = pctx->opts;
> > > > +     char *fsid_start, *fs_name_start;
> > > > +
> > > > +     if (*dev_name_end != '=')
> > > > +                return invalfc(fc, "separator '=' missing in source");
> > > 
> > > An annoying thing is that we'll always see this error message when falling
> > > back to the old_source method.
> > > 
> 
> True. I'd rather this fallback be silent.
> 
> > > (Also, is there a good reason for using '=' instead of ':'?  I probably
> > > missed this discussion somewhere else already...)
> > > 
> 
> Yes, we needed a way for the kernel to distinguish between the old and
> new syntax. Old kernels already reject any mount string without ":/" in
> it, so we needed the new format to _not_ have that to ensure a clean
> fallback procedure.
> 
> It's not as pretty as I would have liked, but it's starting to grow on
> me. :)

Heh.  And gets even worst with using '/' for separating the mons IPs.  (I
understand why it can't be ',' and there's probably a reason for not using
';' either.)  But yeah, that ship has sailed, I'm sure you guys discussed
all this already ;-)

Cheers,
--
Luís
