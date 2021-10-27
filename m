Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5622A43CB66
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Oct 2021 16:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242346AbhJ0ODA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 27 Oct 2021 10:03:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:40794 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237462AbhJ0OC7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 27 Oct 2021 10:02:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635343234;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IOz+0Tm2iT9Us9BiTD8Xx5+CynXJonH99ahpbnVAzPI=;
        b=JIg63DbSW9vcspONYiP5Zjq10B5BSl3RONvTdqyrZWaPY+WRhRJ9uz9nZDCJ/NTJa9ZHMG
        /YgA7+8TepUCXQ38xc3SoWl4gMWJRjreVkO74EBR8eYno47g7eZ0PCkJa3vtLU6u+MQVNL
        qG/TfzAndy2CDUWULQBenPuU24KU294=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-kkG-QDt3NK2vi3Ec3uQLNQ-1; Wed, 27 Oct 2021 10:00:32 -0400
X-MC-Unique: kkG-QDt3NK2vi3Ec3uQLNQ-1
Received: by mail-pl1-f197.google.com with SMTP id w8-20020a170902a70800b0013ffaf12fbaso1241800plq.23
        for <ceph-devel@vger.kernel.org>; Wed, 27 Oct 2021 07:00:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=IOz+0Tm2iT9Us9BiTD8Xx5+CynXJonH99ahpbnVAzPI=;
        b=srB504hgxd9V09cMR9ApXoS1lga1jLZJ65ftrZaH3DSowxX5v76NrET+K/5glerz0X
         Wai7ZVsIJhyV75Ja/KlCn+uRZq8M+JD/P0Z6D630B9AyxhDLSEqBeq4z3/jAebvEcDJh
         RNkbK+3MvtEVVhW9VAn4x6y0IKH5VbBraiRY2trLB8+JL9GXnbDz+RWfNXRjqjoY4yWD
         tuP+U9xXlDj+yaD8gW4MZiqVL02zjx0GHqA/GhyifvVZ2xz5hzNn3iXrEaSSUwStO8HH
         MqqnQi9n+vxidq0F8gZ8xiS8acia1rljIElQQZU/CLlvyFB9wQzlbfkmow1olPICj3AU
         CA2Q==
X-Gm-Message-State: AOAM5308hbeOBCEVbb1LNHzrUbywsuoUnYs04xVNQWjkv29UO8htIYcl
        uGTJDvLOMTUV2/xkXCEuAVmTPXyufI4FhqGz5GcfG9BXNXYud5OyEFzPZCvAX0O6T8HAstQxKkg
        S3ZR5/WMvAgYsEaoPIAj2pw==
X-Received: by 2002:a63:7e57:: with SMTP id o23mr19594145pgn.350.1635343231055;
        Wed, 27 Oct 2021 07:00:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxVHONYIP9ft5WhacB0+lDziImU+UT7FSkDfDlDlig8uE/j2UyPLga50sLypQG52zpZRg2u8g==
X-Received: by 2002:a63:7e57:: with SMTP id o23mr19594126pgn.350.1635343230836;
        Wed, 27 Oct 2021 07:00:30 -0700 (PDT)
Received: from [10.72.12.118] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id n7sm108647pfd.37.2021.10.27.07.00.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 07:00:30 -0700 (PDT)
Subject: Re: [RFC PATCH] ceph: add a "client_shutdown" fault-injection file to
 debugfs
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com,
        ceph-devel@vger.kernel.org
Cc:     lhenriques@suse.de
References: <20211027123127.11020-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <2ff75cda-19c9-4959-65ce-963e55b7543d@redhat.com>
Date:   Wed, 27 Oct 2021 22:00:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211027123127.11020-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 10/27/21 8:31 PM, Jeff Layton wrote:
> Writing a non-zero value to this file will trigger spurious shutdown of
> the client, simulating the effect of receiving a bad mdsmap or fsmap.
>
> Note that this effect cannot be reversed. The only remedy is to unmount.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/debugfs.c | 28 ++++++++++++++++++++++++++++
>   fs/ceph/super.h   |  1 +
>   2 files changed, 29 insertions(+)
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

How about adding one mount option to enable this ? And disable it as 
default.


> There are a lot of possibilities.
>
> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> index 55426514491b..57a72f267f6e 100644
> --- a/fs/ceph/debugfs.c
> +++ b/fs/ceph/debugfs.c
> @@ -401,11 +401,32 @@ DEFINE_SIMPLE_ATTRIBUTE(congestion_kb_fops, congestion_kb_get,
>   			congestion_kb_set, "%llu\n");
>   
>   
> +static int client_shutdown_set(void *data, u64 val)
> +{
> +	struct ceph_fs_client *fsc = (struct ceph_fs_client *)data;
> +
> +	if (val)
> +		ceph_umount_begin(fsc->sb);
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
>   void ceph_fs_debugfs_cleanup(struct ceph_fs_client *fsc)
>   {
>   	dout("ceph_fs_debugfs_cleanup\n");
>   	debugfs_remove(fsc->debugfs_bdi);
>   	debugfs_remove(fsc->debugfs_congestion_kb);
> +	debugfs_remove(fsc->debugfs_client_shutdown);
>   	debugfs_remove(fsc->debugfs_mdsmap);
>   	debugfs_remove(fsc->debugfs_mds_sessions);
>   	debugfs_remove(fsc->debugfs_caps);
> @@ -426,6 +447,13 @@ void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
>   				    fsc,
>   				    &congestion_kb_fops);
>   
> +	fsc->debugfs_client_shutdown =
> +		debugfs_create_file("client_shutdown",
> +				    0600,
> +				    fsc->client->debugfs_dir,
> +				    fsc,
> +				    &client_shutdown_fops);
> +
>   	snprintf(name, sizeof(name), "../../bdi/%s",
>   		 bdi_dev_name(fsc->sb->s_bdi));
>   	fsc->debugfs_bdi =
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index ed51e04739c4..e5d0ad5c6135 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -135,6 +135,7 @@ struct ceph_fs_client {
>   	struct dentry *debugfs_status;
>   	struct dentry *debugfs_mds_sessions;
>   	struct dentry *debugfs_metrics_dir;
> +	struct dentry *debugfs_client_shutdown;
>   #endif
>   
>   #ifdef CONFIG_CEPH_FSCACHE

