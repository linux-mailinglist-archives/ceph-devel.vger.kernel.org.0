Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B79B943DED9
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Oct 2021 12:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbhJ1Kbt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 28 Oct 2021 06:31:49 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:46254 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbhJ1Kbs (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 28 Oct 2021 06:31:48 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 7FFB21FD4B;
        Thu, 28 Oct 2021 10:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1635416960; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5TgacjKmaodGKLLY2JaO9xmNWxKCbHuKjY2PVMhd950=;
        b=1f009UIex3oPbGRNHcwtE5KXWsvvkjZ8g4xBWYR4zhzni57S6bG3rJjSBFN+KNqSKnQ9xB
        ZruNG1VvW/1HDHN1+lPruixGN07TSLdB6Us0H7FlV1EUe5WcF76ZKRW3rwsAArL01Y+EwP
        CgXrM93KC3k3Ibd9vAvuIBittuuZfe4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1635416960;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5TgacjKmaodGKLLY2JaO9xmNWxKCbHuKjY2PVMhd950=;
        b=SB+kZu9vgwoercREJ137fO709GLnk/wK/ULrbzs9oTmos0/zk0Swq30n0AOJYgDEnKV7/V
        Tew1gjtH4xz+bAAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2C5CE139BE;
        Thu, 28 Oct 2021 10:29:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id VHYcCIB7emFEFgAAMHmgww
        (envelope-from <lhenriques@suse.de>); Thu, 28 Oct 2021 10:29:20 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 9351211d;
        Thu, 28 Oct 2021 10:29:19 +0000 (UTC)
Date:   Thu, 28 Oct 2021 11:29:19 +0100
From:   =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, xiubli@redhat.com
Subject: Re: [RFC PATCH] ceph: add a "client_shutdown" fault-injection file
 to debugfs
Message-ID: <YXp7fy6A54F7kxu9@suse.de>
References: <20211027123127.11020-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211027123127.11020-1-jlayton@kernel.org>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Oct 27, 2021 at 08:31:27AM -0400, Jeff Layton wrote:
> Writing a non-zero value to this file will trigger spurious shutdown of
> the client, simulating the effect of receiving a bad mdsmap or fsmap.
> 
> Note that this effect cannot be reversed. The only remedy is to unmount.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/debugfs.c | 28 ++++++++++++++++++++++++++++
>  fs/ceph/super.h   |  1 +
>  2 files changed, 29 insertions(+)
> 
> I used this patch to do some fault injection testing before I proposed
> the patch recently to shut down the mount on receipt of a bad fsmap or
> mdsmap.
> 
> Is this something we should consider for mainline kernels?
> 
> We could put it behind a new Kconfig option if we're worried about
> footguns in production kernels. Maybe we could call the new file
> "fault_inject", and allow writing a mask value to it? We could roll
> tests for teuthology that use this too.
> 
> There are a lot of possibilities.

My opinion is that this is a bit too dangerous to be enabled, even in for
debugfs.  So, adding a new kconfig option for this sort of things would
probably make sense.

OTOH, I was wondering if it would be possible to use the in-kernel
fault-injection infrastructure to simulate this sort of things.  For
example, for your invalid mdsmap use-case, would you get similar results
by forcing ceph_mdsmap_decode() to return an error?  If so, then I guess
the fault-injection would be a better option (using the
ALLOW_ERROR_INJECTION macro).

Anyway, that was my two cents (and also a minor nit bellow).

> 
> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> index 55426514491b..57a72f267f6e 100644
> --- a/fs/ceph/debugfs.c
> +++ b/fs/ceph/debugfs.c
> @@ -401,11 +401,32 @@ DEFINE_SIMPLE_ATTRIBUTE(congestion_kb_fops, congestion_kb_get,
>  			congestion_kb_set, "%llu\n");
>  
>  
> +static int client_shutdown_set(void *data, u64 val)
> +{
> +	struct ceph_fs_client *fsc = (struct ceph_fs_client *)data;
> +
> +	if (val)
> +		ceph_umount_begin(fsc->sb);

Function ceph_umount_begin needs to be declared as 'extern'.

Cheers,
--
Luís

> +	return 0;
> +}
> +
> +static int client_shutdown_get(void *data, u64 *val)
> +{
> +	struct ceph_fs_client *fsc = (struct ceph_fs_client *)data;
> +
> +	*val = (u64)(fsc->mount_state == CEPH_MOUNT_SHUTDOWN);
> +	return 0;
> +}
> +
> +DEFINE_SIMPLE_ATTRIBUTE(client_shutdown_fops, client_shutdown_get,
> +			client_shutdown_set, "%llu\n");
> +
>  void ceph_fs_debugfs_cleanup(struct ceph_fs_client *fsc)
>  {
>  	dout("ceph_fs_debugfs_cleanup\n");
>  	debugfs_remove(fsc->debugfs_bdi);
>  	debugfs_remove(fsc->debugfs_congestion_kb);
> +	debugfs_remove(fsc->debugfs_client_shutdown);
>  	debugfs_remove(fsc->debugfs_mdsmap);
>  	debugfs_remove(fsc->debugfs_mds_sessions);
>  	debugfs_remove(fsc->debugfs_caps);
> @@ -426,6 +447,13 @@ void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
>  				    fsc,
>  				    &congestion_kb_fops);
>  
> +	fsc->debugfs_client_shutdown =
> +		debugfs_create_file("client_shutdown",
> +				    0600,
> +				    fsc->client->debugfs_dir,
> +				    fsc,
> +				    &client_shutdown_fops);
> +
>  	snprintf(name, sizeof(name), "../../bdi/%s",
>  		 bdi_dev_name(fsc->sb->s_bdi));
>  	fsc->debugfs_bdi =
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index ed51e04739c4..e5d0ad5c6135 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -135,6 +135,7 @@ struct ceph_fs_client {
>  	struct dentry *debugfs_status;
>  	struct dentry *debugfs_mds_sessions;
>  	struct dentry *debugfs_metrics_dir;
> +	struct dentry *debugfs_client_shutdown;
>  #endif
>  
>  #ifdef CONFIG_CEPH_FSCACHE
> -- 
> 2.31.1
> 
