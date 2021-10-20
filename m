Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AEE54350D6
	for <lists+ceph-devel@lfdr.de>; Wed, 20 Oct 2021 18:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbhJTRBE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 20 Oct 2021 13:01:04 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:39538 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbhJTRBC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 20 Oct 2021 13:01:02 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 8A46B1F770;
        Wed, 20 Oct 2021 16:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1634749127; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VN0v+zOWuBsqaAT4ViBMl8+wcEXyZFLvnBOe3gzHdj4=;
        b=uBjaajxosTI5BEj118k+barreikD1g/xefkK2zPfRdTrvsjX0517/T47SS25HeS+CGBTsl
        rdBZbctke0LcMeO/ZCp+8nsYVH0QZw7L2uDiI6BGP14E2lIKS6QvqeYSxQIg2IVWBmk3YT
        Q2um4nmCiE1zhjrCA7p9Rj920agcgIw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1634749127;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VN0v+zOWuBsqaAT4ViBMl8+wcEXyZFLvnBOe3gzHdj4=;
        b=hqqFG8nl6PJVW80hGDmoZIcen0GSjdbcFoq20Hb9f4w3YjBDoVTZ7P/UVp0izsnDCzsOpD
        5ll9dGJWeHvU7TDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 358B513BA1;
        Wed, 20 Oct 2021 16:58:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id x/XKCcdKcGGZXwAAMHmgww
        (envelope-from <lhenriques@suse.de>); Wed, 20 Oct 2021 16:58:47 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id c68a32f7;
        Wed, 20 Oct 2021 16:58:46 +0000 (UTC)
Date:   Wed, 20 Oct 2021 17:58:46 +0100
From:   =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Patrick Donnelly <pdonnell@redhat.com>
Subject: Re: [RFC PATCH] ceph: add remote object copy counter to fs client
Message-ID: <YXBKxh1FepRXpyHg@suse.de>
References: <20211020143708.14728-1-lhenriques@suse.de>
 <34e379f9dec1cbdf09fffd8207f6ef7f4e1a6841.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <34e379f9dec1cbdf09fffd8207f6ef7f4e1a6841.camel@kernel.org>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Oct 20, 2021 at 12:27:21PM -0400, Jeff Layton wrote:
> On Wed, 2021-10-20 at 15:37 +0100, Luís Henriques wrote:
> > This counter will keep track of the number of remote object copies done on
> > copy_file_range syscalls.  This counter will be filesystem per-client, and
> > can be accessed from the client debugfs directory.
> > 
> > Cc: Patrick Donnelly <pdonnell@redhat.com>
> > Signed-off-by: Luís Henriques <lhenriques@suse.de>
> > ---
> > This is an RFC to reply to Patrick's request in [0].  Note that I'm not
> > 100% sure about the usefulness of this patch, or if this is the best way
> > to provide the functionality Patrick requested.  Anyway, this is just to
> > get some feedback, hence the RFC.
> > 
> > Cheers,
> > --
> > Luís
> > 
> > [0] https://github.com/ceph/ceph/pull/42720
> > 
> 
> I think this would be better integrated into the stats infrastructure.
> 
> Maybe you could add a new set of "copy" stats to struct
> ceph_client_metric that tracks the total copy operations done, their
> size and latency (similar to read and write ops)?

Ah, yeah.  That probably makes sense, I'll have a closer look at that
infrastructure.  I suspect that involves touching the MDS code, which
means that unfortunately it'll take me a bit longer to send out v2.

Cheers,
--
Luís


> >  fs/ceph/debugfs.c | 17 ++++++++++++++++-
> >  fs/ceph/file.c    |  1 +
> >  fs/ceph/super.c   |  1 +
> >  fs/ceph/super.h   |  2 ++
> >  4 files changed, 20 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> > index 38b78b45811f..09f4c04ade0e 100644
> > --- a/fs/ceph/debugfs.c
> > +++ b/fs/ceph/debugfs.c
> > @@ -346,13 +346,22 @@ static int status_show(struct seq_file *s, void *p)
> >  	return 0;
> >  }
> >  
> > +static int copyfrom_show(struct seq_file *s, void *p)
> > +{
> > +	struct ceph_fs_client *fsc = s->private;
> > +
> > +	seq_printf(s, "%llu\n", atomic64_read(&fsc->copyfrom_count));
> > +
> > +	return 0;
> > +}
> > +
> >  DEFINE_SHOW_ATTRIBUTE(mdsmap);
> >  DEFINE_SHOW_ATTRIBUTE(mdsc);
> >  DEFINE_SHOW_ATTRIBUTE(caps);
> >  DEFINE_SHOW_ATTRIBUTE(mds_sessions);
> >  DEFINE_SHOW_ATTRIBUTE(metric);
> >  DEFINE_SHOW_ATTRIBUTE(status);
> > -
> > +DEFINE_SHOW_ATTRIBUTE(copyfrom);
> >  
> >  /*
> >   * debugfs
> > @@ -387,6 +396,7 @@ void ceph_fs_debugfs_cleanup(struct ceph_fs_client *fsc)
> >  	debugfs_remove(fsc->debugfs_caps);
> >  	debugfs_remove(fsc->debugfs_metric);
> >  	debugfs_remove(fsc->debugfs_mdsc);
> > +	debugfs_remove(fsc->debugfs_copyfrom);
> >  }
> >  
> >  void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
> > @@ -443,6 +453,11 @@ void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
> >  						  fsc->client->debugfs_dir,
> >  						  fsc,
> >  						  &status_fops);
> > +	fsc->debugfs_copyfrom = debugfs_create_file("copyfrom",
> > +						    0400,
> > +						    fsc->client->debugfs_dir,
> > +						    fsc,
> > +						    &copyfrom_fops);
> >  }
> >  
> >  
> > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > index d16fd2d5fd42..bbeb437ca4bf 100644
> > --- a/fs/ceph/file.c
> > +++ b/fs/ceph/file.c
> > @@ -2254,6 +2254,7 @@ static ssize_t ceph_do_objects_copy(struct ceph_inode_info *src_ci, u64 *src_off
> >  				bytes = ret;
> >  			goto out;
> >  		}
> > +		atomic64_inc(&fsc->copyfrom_count);
> >  		len -= object_size;
> >  		bytes += object_size;
> >  		*src_off += object_size;
> > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > index 9b1b7f4cfdd4..4972554185e3 100644
> > --- a/fs/ceph/super.c
> > +++ b/fs/ceph/super.c
> > @@ -670,6 +670,7 @@ static struct ceph_fs_client *create_fs_client(struct ceph_mount_options *fsopt,
> >  	fsc->have_copy_from2 = true;
> >  
> >  	atomic_long_set(&fsc->writeback_count, 0);
> > +	atomic64_set(&fsc->copyfrom_count, 0);
> >  
> >  	err = -ENOMEM;
> >  	/*
> > diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> > index a40eb14c282a..65846beca418 100644
> > --- a/fs/ceph/super.h
> > +++ b/fs/ceph/super.h
> > @@ -119,6 +119,7 @@ struct ceph_fs_client {
> >  	struct ceph_mds_client *mdsc;
> >  
> >  	atomic_long_t writeback_count;
> > +	atomic64_t copyfrom_count;
> >  
> >  	struct workqueue_struct *inode_wq;
> >  	struct workqueue_struct *cap_wq;
> > @@ -131,6 +132,7 @@ struct ceph_fs_client {
> >  	struct dentry *debugfs_metric;
> >  	struct dentry *debugfs_status;
> >  	struct dentry *debugfs_mds_sessions;
> > +	struct dentry *debugfs_copyfrom;
> >  #endif
> >  
> >  #ifdef CONFIG_CEPH_FSCACHE
> 
> -- 
> Jeff Layton <jlayton@kernel.org>
> 
